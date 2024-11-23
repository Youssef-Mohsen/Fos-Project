
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
  800081:	68 00 51 80 00       	push   $0x805100
  800086:	6a 1e                	push   $0x1e
  800088:	68 1c 51 80 00       	push   $0x80511c
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
  8000d7:	e8 56 2d 00 00       	call   802e32 <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 30 51 80 00       	push   $0x805130
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
  800103:	e8 2a 2d 00 00       	call   802e32 <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 6d 2d 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  800142:	68 8c 51 80 00       	push   $0x80518c
  800147:	e8 64 19 00 00       	call   801ab0 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 d4 2c 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800195:	68 c0 51 80 00       	push   $0x8051c0
  80019a:	e8 11 19 00 00       	call   801ab0 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 d6 2c 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 30 52 80 00       	push   $0x805230
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 6a 2c 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8001ff:	e8 2e 2c 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800237:	68 64 52 80 00       	push   $0x805264
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
  80027e:	e8 0a 30 00 00       	call   80328d <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 e4 52 80 00       	push   $0x8052e4
  80029e:	e8 0d 18 00 00       	call   801ab0 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 87 2b 00 00       	call   802e32 <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 ca 2b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  8002f2:	68 08 53 80 00       	push   $0x805308
  8002f7:	e8 b4 17 00 00       	call   801ab0 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 24 2b 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800345:	68 3c 53 80 00       	push   $0x80533c
  80034a:	e8 61 17 00 00       	call   801ab0 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 26 2b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 ac 53 80 00       	push   $0x8053ac
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 ba 2a 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8003b8:	e8 75 2a 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8003f0:	68 e0 53 80 00       	push   $0x8053e0
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
  80043b:	e8 4d 2e 00 00       	call   80328d <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 60 54 80 00       	push   $0x805460
  80045b:	e8 50 16 00 00       	call   801ab0 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 15 2a 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  8004a9:	68 84 54 80 00       	push   $0x805484
  8004ae:	e8 fd 15 00 00       	call   801ab0 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 6d 29 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8004fc:	68 b8 54 80 00       	push   $0x8054b8
  800501:	e8 aa 15 00 00       	call   801ab0 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 6f 29 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 28 55 80 00       	push   $0x805528
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 03 29 00 00       	call   802e32 <sys_calculate_free_frames>
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
  80056d:	e8 c0 28 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8005a5:	68 5c 55 80 00       	push   $0x80555c
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
  8005f3:	e8 95 2c 00 00       	call   80328d <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 dc 55 80 00       	push   $0x8055dc
  800613:	e8 98 14 00 00       	call   801ab0 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 5d 28 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  800669:	68 00 56 80 00       	push   $0x805600
  80066e:	e8 3d 14 00 00       	call   801ab0 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 02 28 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 34 56 80 00       	push   $0x805634
  80068f:	e8 1c 14 00 00       	call   801ab0 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 96 27 00 00       	call   802e32 <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 d9 27 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  8006f1:	68 68 56 80 00       	push   $0x805668
  8006f6:	e8 b5 13 00 00       	call   801ab0 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 25 27 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800744:	68 9c 56 80 00       	push   $0x80569c
  800749:	e8 62 13 00 00       	call   801ab0 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 27 27 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 0c 57 80 00       	push   $0x80570c
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 bb 26 00 00       	call   802e32 <sys_calculate_free_frames>
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
  8007fc:	e8 31 26 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800834:	68 40 57 80 00       	push   $0x805740
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
  800888:	e8 00 2a 00 00       	call   80328d <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 c0 57 80 00       	push   $0x8057c0
  8008a8:	e8 03 12 00 00       	call   801ab0 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 7d 25 00 00       	call   802e32 <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 c0 25 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  800909:	68 e4 57 80 00       	push   $0x8057e4
  80090e:	e8 9d 11 00 00       	call   801ab0 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 0d 25 00 00       	call   802e32 <sys_calculate_free_frames>
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
  80095c:	68 18 58 80 00       	push   $0x805818
  800961:	e8 4a 11 00 00       	call   801ab0 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 0f 25 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 88 58 80 00       	push   $0x805888
  800982:	e8 29 11 00 00       	call   801ab0 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 a3 24 00 00       	call   802e32 <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 e6 24 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 bc 58 80 00       	push   $0x8058bc
  8009f1:	e8 ba 10 00 00       	call   801ab0 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 2a 24 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800a3f:	68 f0 58 80 00       	push   $0x8058f0
  800a44:	e8 67 10 00 00       	call   801ab0 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 2c 24 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 60 59 80 00       	push   $0x805960
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 c0 23 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800ae5:	e8 48 23 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800b1d:	68 94 59 80 00       	push   $0x805994
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
  800ba9:	e8 df 26 00 00       	call   80328d <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 14 5a 80 00       	push   $0x805a14
  800bc9:	e8 e2 0e 00 00       	call   801ab0 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 5c 22 00 00       	call   802e32 <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 9f 22 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
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
  800c35:	68 38 5a 80 00       	push   $0x805a38
  800c3a:	e8 71 0e 00 00       	call   801ab0 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 e1 21 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800c88:	68 6c 5a 80 00       	push   $0x805a6c
  800c8d:	e8 1e 0e 00 00       	call   801ab0 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 e3 21 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 dc 5a 80 00       	push   $0x805adc
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 77 21 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800d3f:	e8 ee 20 00 00       	call   802e32 <sys_calculate_free_frames>
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
  800d77:	68 10 5b 80 00       	push   $0x805b10
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
  800e09:	e8 7f 24 00 00       	call   80328d <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 90 5b 80 00       	push   $0x805b90
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
  800e5e:	68 b4 5b 80 00       	push   $0x805bb4
  800e63:	e8 48 0c 00 00       	call   801ab0 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 c2 1f 00 00       	call   802e32 <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 05 20 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 eb 1f 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 f4 5b 80 00       	push   $0x805bf4
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 7f 1f 00 00       	call   802e32 <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 34 5c 80 00       	push   $0x805c34
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
  800f1e:	e8 6a 23 00 00       	call   80328d <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 84 5c 80 00       	push   $0x805c84
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
  800f5d:	e8 d0 1e 00 00       	call   802e32 <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 13 1f 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 f9 1e 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 ac 5c 80 00       	push   $0x805cac
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 8d 1e 00 00       	call   802e32 <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 ec 5c 80 00       	push   $0x805cec
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
  801014:	e8 74 22 00 00       	call   80328d <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 3c 5d 80 00       	push   $0x805d3c
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
  801053:	e8 da 1d 00 00       	call   802e32 <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 1d 1e 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 03 1e 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 64 5d 80 00       	push   $0x805d64
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 97 1d 00 00       	call   802e32 <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 a4 5d 80 00       	push   $0x805da4
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
  80113f:	e8 49 21 00 00       	call   80328d <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 f4 5d 80 00       	push   $0x805df4
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
  80117e:	e8 af 1c 00 00       	call   802e32 <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 f2 1c 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 d8 1c 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 1c 5e 80 00       	push   $0x805e1c
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 6c 1c 00 00       	call   802e32 <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 5c 5e 80 00       	push   $0x805e5c
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
  801238:	e8 50 20 00 00       	call   80328d <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 ac 5e 80 00       	push   $0x805eac
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
  801277:	e8 b6 1b 00 00       	call   802e32 <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 f9 1b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 df 1b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 d4 5e 80 00       	push   $0x805ed4
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 73 1b 00 00       	call   802e32 <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 14 5f 80 00       	push   $0x805f14
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
  8012f0:	e8 3d 1b 00 00       	call   802e32 <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 80 1b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 66 1b 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 58 5f 80 00       	push   $0x805f58
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 fa 1a 00 00       	call   802e32 <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 98 5f 80 00       	push   $0x805f98
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
  8013aa:	e8 de 1e 00 00       	call   80328d <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 e8 5f 80 00       	push   $0x805fe8
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
  8013e9:	e8 44 1a 00 00       	call   802e32 <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 87 1a 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 6d 1a 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 10 60 80 00       	push   $0x806010
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 01 1a 00 00       	call   802e32 <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 50 60 80 00       	push   $0x806050
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
  801462:	e8 cb 19 00 00       	call   802e32 <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 0e 1a 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 f4 19 00 00       	call   802e7d <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 a0 60 80 00       	push   $0x8060a0
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 88 19 00 00       	call   802e32 <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 e0 60 80 00       	push   $0x8060e0
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
  801554:	e8 34 1d 00 00       	call   80328d <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 30 61 80 00       	push   $0x806130
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
  80159d:	68 58 61 80 00       	push   $0x806158
  8015a2:	e8 09 05 00 00       	call   801ab0 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 2a 1b 00 00       	call   8030d9 <rsttst>
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
  8015d5:	68 c6 61 80 00       	push   $0x8061c6
  8015da:	e8 ae 19 00 00       	call   802f8d <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 b5 19 00 00       	call   802fab <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 54 1b 00 00       	call   803153 <gettst>
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
  80162a:	68 d1 61 80 00       	push   $0x8061d1
  80162f:	e8 59 19 00 00       	call   802f8d <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 60 19 00 00       	call   802fab <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 ff 1a 00 00       	call   803153 <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 db 1a 00 00       	call   803139 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 69 37 00 00       	call   804dd4 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 e0 1a 00 00       	call   803153 <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 dc 61 80 00       	push   $0x8061dc
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
  80169f:	68 6c 62 80 00       	push   $0x80626c
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
  8016ba:	e8 3c 19 00 00       	call   802ffb <sys_getenvindex>
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
  801728:	e8 52 16 00 00       	call   802d7f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	68 c0 62 80 00       	push   $0x8062c0
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
  801758:	68 e8 62 80 00       	push   $0x8062e8
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
  801789:	68 10 63 80 00       	push   $0x806310
  80178e:	e8 1d 03 00 00       	call   801ab0 <cprintf>
  801793:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801796:	a1 20 70 80 00       	mov    0x807020,%eax
  80179b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 68 63 80 00       	push   $0x806368
  8017aa:	e8 01 03 00 00       	call   801ab0 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 c0 62 80 00       	push   $0x8062c0
  8017ba:	e8 f1 02 00 00       	call   801ab0 <cprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017c2:	e8 d2 15 00 00       	call   802d99 <sys_unlock_cons>
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
  8017da:	e8 e8 17 00 00       	call   802fc7 <sys_destroy_env>
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
  8017eb:	e8 3d 18 00 00       	call   80302d <sys_exit_env>
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
  801814:	68 7c 63 80 00       	push   $0x80637c
  801819:	e8 92 02 00 00       	call   801ab0 <cprintf>
  80181e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801821:	a1 00 70 80 00       	mov    0x807000,%eax
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	68 81 63 80 00       	push   $0x806381
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
  801851:	68 9d 63 80 00       	push   $0x80639d
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
  801880:	68 a0 63 80 00       	push   $0x8063a0
  801885:	6a 26                	push   $0x26
  801887:	68 ec 63 80 00       	push   $0x8063ec
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
  801955:	68 f8 63 80 00       	push   $0x8063f8
  80195a:	6a 3a                	push   $0x3a
  80195c:	68 ec 63 80 00       	push   $0x8063ec
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
  8019c8:	68 4c 64 80 00       	push   $0x80644c
  8019cd:	6a 44                	push   $0x44
  8019cf:	68 ec 63 80 00       	push   $0x8063ec
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
  801a22:	e8 16 13 00 00       	call   802d3d <sys_cputs>
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
  801a99:	e8 9f 12 00 00       	call   802d3d <sys_cputs>
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
  801ae3:	e8 97 12 00 00       	call   802d7f <sys_lock_cons>
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
  801b03:	e8 91 12 00 00       	call   802d99 <sys_unlock_cons>
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
  801b4d:	e8 36 33 00 00       	call   804e88 <__udivdi3>
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
  801b9d:	e8 f6 33 00 00       	call   804f98 <__umoddi3>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	05 b4 66 80 00       	add    $0x8066b4,%eax
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
  801cf8:	8b 04 85 d8 66 80 00 	mov    0x8066d8(,%eax,4),%eax
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
  801dd9:	8b 34 9d 20 65 80 00 	mov    0x806520(,%ebx,4),%esi
  801de0:	85 f6                	test   %esi,%esi
  801de2:	75 19                	jne    801dfd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de4:	53                   	push   %ebx
  801de5:	68 c5 66 80 00       	push   $0x8066c5
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
  801dfe:	68 ce 66 80 00       	push   $0x8066ce
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
  801e2b:	be d1 66 80 00       	mov    $0x8066d1,%esi
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
  802836:	68 48 68 80 00       	push   $0x806848
  80283b:	68 3f 01 00 00       	push   $0x13f
  802840:	68 6a 68 80 00       	push   $0x80686a
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
  802856:	e8 8d 0a 00 00       	call   8032e8 <sys_sbrk>
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
  8028d1:	e8 96 08 00 00       	call   80316c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 d6 0d 00 00       	call   8036bb <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 a8 08 00 00       	call   80319d <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 6f 12 00 00       	call   803b77 <alloc_block_BF>
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
  802a69:	e8 b1 08 00 00       	call   80331f <sys_allocate_user_mem>
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
  802ab1:	e8 85 08 00 00       	call   80333b <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 b8 1a 00 00       	call   80457f <free_block>
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
  802b59:	e8 a5 07 00 00       	call   803303 <sys_free_user_mem>
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
  802b67:	68 78 68 80 00       	push   $0x806878
  802b6c:	68 84 00 00 00       	push   $0x84
  802b71:	68 a2 68 80 00       	push   $0x8068a2
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
  802b94:	eb 64                	jmp    802bfa <smalloc+0x7d>
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
  802bc9:	eb 2f                	jmp    802bfa <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802bcb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802bcf:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd2:	50                   	push   %eax
  802bd3:	ff 75 0c             	pushl  0xc(%ebp)
  802bd6:	ff 75 08             	pushl  0x8(%ebp)
  802bd9:	e8 2c 03 00 00       	call   802f0a <sys_createSharedObject>
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802be4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802be8:	74 06                	je     802bf0 <smalloc+0x73>
  802bea:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802bee:	75 07                	jne    802bf7 <smalloc+0x7a>
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf5:	eb 03                	jmp    802bfa <smalloc+0x7d>
	 return ptr;
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802c02:	83 ec 08             	sub    $0x8,%esp
  802c05:	ff 75 0c             	pushl  0xc(%ebp)
  802c08:	ff 75 08             	pushl  0x8(%ebp)
  802c0b:	e8 24 03 00 00       	call   802f34 <sys_getSizeOfSharedObject>
  802c10:	83 c4 10             	add    $0x10,%esp
  802c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802c16:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802c1a:	75 07                	jne    802c23 <sget+0x27>
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	eb 5c                	jmp    802c7f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c29:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	39 d0                	cmp    %edx,%eax
  802c38:	7d 02                	jge    802c3c <sget+0x40>
  802c3a:	89 d0                	mov    %edx,%eax
  802c3c:	83 ec 0c             	sub    $0xc,%esp
  802c3f:	50                   	push   %eax
  802c40:	e8 1b fc ff ff       	call   802860 <malloc>
  802c45:	83 c4 10             	add    $0x10,%esp
  802c48:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802c4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4f:	75 07                	jne    802c58 <sget+0x5c>
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
  802c56:	eb 27                	jmp    802c7f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	ff 75 e8             	pushl  -0x18(%ebp)
  802c5e:	ff 75 0c             	pushl  0xc(%ebp)
  802c61:	ff 75 08             	pushl  0x8(%ebp)
  802c64:	e8 e8 02 00 00       	call   802f51 <sys_getSharedObject>
  802c69:	83 c4 10             	add    $0x10,%esp
  802c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802c6f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802c73:	75 07                	jne    802c7c <sget+0x80>
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7a:	eb 03                	jmp    802c7f <sget+0x83>
	return ptr;
  802c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802c7f:	c9                   	leave  
  802c80:	c3                   	ret    

00802c81 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802c81:	55                   	push   %ebp
  802c82:	89 e5                	mov    %esp,%ebp
  802c84:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802c87:	83 ec 04             	sub    $0x4,%esp
  802c8a:	68 b0 68 80 00       	push   $0x8068b0
  802c8f:	68 c1 00 00 00       	push   $0xc1
  802c94:	68 a2 68 80 00       	push   $0x8068a2
  802c99:	e8 55 eb ff ff       	call   8017f3 <_panic>

00802c9e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 d4 68 80 00       	push   $0x8068d4
  802cac:	68 d8 00 00 00       	push   $0xd8
  802cb1:	68 a2 68 80 00       	push   $0x8068a2
  802cb6:	e8 38 eb ff ff       	call   8017f3 <_panic>

00802cbb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 fa 68 80 00       	push   $0x8068fa
  802cc9:	68 e4 00 00 00       	push   $0xe4
  802cce:	68 a2 68 80 00       	push   $0x8068a2
  802cd3:	e8 1b eb ff ff       	call   8017f3 <_panic>

00802cd8 <shrink>:

}
void shrink(uint32 newSize)
{
  802cd8:	55                   	push   %ebp
  802cd9:	89 e5                	mov    %esp,%ebp
  802cdb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	68 fa 68 80 00       	push   $0x8068fa
  802ce6:	68 e9 00 00 00       	push   $0xe9
  802ceb:	68 a2 68 80 00       	push   $0x8068a2
  802cf0:	e8 fe ea ff ff       	call   8017f3 <_panic>

00802cf5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
  802cf8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	68 fa 68 80 00       	push   $0x8068fa
  802d03:	68 ee 00 00 00       	push   $0xee
  802d08:	68 a2 68 80 00       	push   $0x8068a2
  802d0d:	e8 e1 ea ff ff       	call   8017f3 <_panic>

00802d12 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
  802d15:	57                   	push   %edi
  802d16:	56                   	push   %esi
  802d17:	53                   	push   %ebx
  802d18:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d27:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d2a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d2d:	cd 30                	int    $0x30
  802d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	5b                   	pop    %ebx
  802d39:	5e                   	pop    %esi
  802d3a:	5f                   	pop    %edi
  802d3b:	5d                   	pop    %ebp
  802d3c:	c3                   	ret    

00802d3d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d3d:	55                   	push   %ebp
  802d3e:	89 e5                	mov    %esp,%ebp
  802d40:	83 ec 04             	sub    $0x4,%esp
  802d43:	8b 45 10             	mov    0x10(%ebp),%eax
  802d46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802d49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	6a 00                	push   $0x0
  802d52:	6a 00                	push   $0x0
  802d54:	52                   	push   %edx
  802d55:	ff 75 0c             	pushl  0xc(%ebp)
  802d58:	50                   	push   %eax
  802d59:	6a 00                	push   $0x0
  802d5b:	e8 b2 ff ff ff       	call   802d12 <syscall>
  802d60:	83 c4 18             	add    $0x18,%esp
}
  802d63:	90                   	nop
  802d64:	c9                   	leave  
  802d65:	c3                   	ret    

00802d66 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d66:	55                   	push   %ebp
  802d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 02                	push   $0x2
  802d75:	e8 98 ff ff ff       	call   802d12 <syscall>
  802d7a:	83 c4 18             	add    $0x18,%esp
}
  802d7d:	c9                   	leave  
  802d7e:	c3                   	ret    

00802d7f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d7f:	55                   	push   %ebp
  802d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 03                	push   $0x3
  802d8e:	e8 7f ff ff ff       	call   802d12 <syscall>
  802d93:	83 c4 18             	add    $0x18,%esp
}
  802d96:	90                   	nop
  802d97:	c9                   	leave  
  802d98:	c3                   	ret    

00802d99 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 04                	push   $0x4
  802da8:	e8 65 ff ff ff       	call   802d12 <syscall>
  802dad:	83 c4 18             	add    $0x18,%esp
}
  802db0:	90                   	nop
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	52                   	push   %edx
  802dc3:	50                   	push   %eax
  802dc4:	6a 08                	push   $0x8
  802dc6:	e8 47 ff ff ff       	call   802d12 <syscall>
  802dcb:	83 c4 18             	add    $0x18,%esp
}
  802dce:	c9                   	leave  
  802dcf:	c3                   	ret    

00802dd0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dd0:	55                   	push   %ebp
  802dd1:	89 e5                	mov    %esp,%ebp
  802dd3:	56                   	push   %esi
  802dd4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802dd5:	8b 75 18             	mov    0x18(%ebp),%esi
  802dd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ddb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	56                   	push   %esi
  802de5:	53                   	push   %ebx
  802de6:	51                   	push   %ecx
  802de7:	52                   	push   %edx
  802de8:	50                   	push   %eax
  802de9:	6a 09                	push   $0x9
  802deb:	e8 22 ff ff ff       	call   802d12 <syscall>
  802df0:	83 c4 18             	add    $0x18,%esp
}
  802df3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802df6:	5b                   	pop    %ebx
  802df7:	5e                   	pop    %esi
  802df8:	5d                   	pop    %ebp
  802df9:	c3                   	ret    

00802dfa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	52                   	push   %edx
  802e0a:	50                   	push   %eax
  802e0b:	6a 0a                	push   $0xa
  802e0d:	e8 00 ff ff ff       	call   802d12 <syscall>
  802e12:	83 c4 18             	add    $0x18,%esp
}
  802e15:	c9                   	leave  
  802e16:	c3                   	ret    

00802e17 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e17:	55                   	push   %ebp
  802e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	ff 75 0c             	pushl  0xc(%ebp)
  802e23:	ff 75 08             	pushl  0x8(%ebp)
  802e26:	6a 0b                	push   $0xb
  802e28:	e8 e5 fe ff ff       	call   802d12 <syscall>
  802e2d:	83 c4 18             	add    $0x18,%esp
}
  802e30:	c9                   	leave  
  802e31:	c3                   	ret    

00802e32 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e32:	55                   	push   %ebp
  802e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 0c                	push   $0xc
  802e41:	e8 cc fe ff ff       	call   802d12 <syscall>
  802e46:	83 c4 18             	add    $0x18,%esp
}
  802e49:	c9                   	leave  
  802e4a:	c3                   	ret    

00802e4b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e4b:	55                   	push   %ebp
  802e4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 0d                	push   $0xd
  802e5a:	e8 b3 fe ff ff       	call   802d12 <syscall>
  802e5f:	83 c4 18             	add    $0x18,%esp
}
  802e62:	c9                   	leave  
  802e63:	c3                   	ret    

00802e64 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e67:	6a 00                	push   $0x0
  802e69:	6a 00                	push   $0x0
  802e6b:	6a 00                	push   $0x0
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 0e                	push   $0xe
  802e73:	e8 9a fe ff ff       	call   802d12 <syscall>
  802e78:	83 c4 18             	add    $0x18,%esp
}
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 00                	push   $0x0
  802e88:	6a 00                	push   $0x0
  802e8a:	6a 0f                	push   $0xf
  802e8c:	e8 81 fe ff ff       	call   802d12 <syscall>
  802e91:	83 c4 18             	add    $0x18,%esp
}
  802e94:	c9                   	leave  
  802e95:	c3                   	ret    

00802e96 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e96:	55                   	push   %ebp
  802e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	ff 75 08             	pushl  0x8(%ebp)
  802ea4:	6a 10                	push   $0x10
  802ea6:	e8 67 fe ff ff       	call   802d12 <syscall>
  802eab:	83 c4 18             	add    $0x18,%esp
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 11                	push   $0x11
  802ebf:	e8 4e fe ff ff       	call   802d12 <syscall>
  802ec4:	83 c4 18             	add    $0x18,%esp
}
  802ec7:	90                   	nop
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_cputc>:

void
sys_cputc(const char c)
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ed6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	50                   	push   %eax
  802ee3:	6a 01                	push   $0x1
  802ee5:	e8 28 fe ff ff       	call   802d12 <syscall>
  802eea:	83 c4 18             	add    $0x18,%esp
}
  802eed:	90                   	nop
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 14                	push   $0x14
  802eff:	e8 0e fe ff ff       	call   802d12 <syscall>
  802f04:	83 c4 18             	add    $0x18,%esp
}
  802f07:	90                   	nop
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	8b 45 10             	mov    0x10(%ebp),%eax
  802f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f16:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	6a 00                	push   $0x0
  802f22:	51                   	push   %ecx
  802f23:	52                   	push   %edx
  802f24:	ff 75 0c             	pushl  0xc(%ebp)
  802f27:	50                   	push   %eax
  802f28:	6a 15                	push   $0x15
  802f2a:	e8 e3 fd ff ff       	call   802d12 <syscall>
  802f2f:	83 c4 18             	add    $0x18,%esp
}
  802f32:	c9                   	leave  
  802f33:	c3                   	ret    

00802f34 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f37:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	52                   	push   %edx
  802f44:	50                   	push   %eax
  802f45:	6a 16                	push   $0x16
  802f47:	e8 c6 fd ff ff       	call   802d12 <syscall>
  802f4c:	83 c4 18             	add    $0x18,%esp
}
  802f4f:	c9                   	leave  
  802f50:	c3                   	ret    

00802f51 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802f51:	55                   	push   %ebp
  802f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	51                   	push   %ecx
  802f62:	52                   	push   %edx
  802f63:	50                   	push   %eax
  802f64:	6a 17                	push   $0x17
  802f66:	e8 a7 fd ff ff       	call   802d12 <syscall>
  802f6b:	83 c4 18             	add    $0x18,%esp
}
  802f6e:	c9                   	leave  
  802f6f:	c3                   	ret    

00802f70 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802f70:	55                   	push   %ebp
  802f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	52                   	push   %edx
  802f80:	50                   	push   %eax
  802f81:	6a 18                	push   $0x18
  802f83:	e8 8a fd ff ff       	call   802d12 <syscall>
  802f88:	83 c4 18             	add    $0x18,%esp
}
  802f8b:	c9                   	leave  
  802f8c:	c3                   	ret    

00802f8d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f8d:	55                   	push   %ebp
  802f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	6a 00                	push   $0x0
  802f95:	ff 75 14             	pushl  0x14(%ebp)
  802f98:	ff 75 10             	pushl  0x10(%ebp)
  802f9b:	ff 75 0c             	pushl  0xc(%ebp)
  802f9e:	50                   	push   %eax
  802f9f:	6a 19                	push   $0x19
  802fa1:	e8 6c fd ff ff       	call   802d12 <syscall>
  802fa6:	83 c4 18             	add    $0x18,%esp
}
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <sys_run_env>:

void sys_run_env(int32 envId)
{
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	50                   	push   %eax
  802fba:	6a 1a                	push   $0x1a
  802fbc:	e8 51 fd ff ff       	call   802d12 <syscall>
  802fc1:	83 c4 18             	add    $0x18,%esp
}
  802fc4:	90                   	nop
  802fc5:	c9                   	leave  
  802fc6:	c3                   	ret    

00802fc7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fc7:	55                   	push   %ebp
  802fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	6a 00                	push   $0x0
  802fd5:	50                   	push   %eax
  802fd6:	6a 1b                	push   $0x1b
  802fd8:	e8 35 fd ff ff       	call   802d12 <syscall>
  802fdd:	83 c4 18             	add    $0x18,%esp
}
  802fe0:	c9                   	leave  
  802fe1:	c3                   	ret    

00802fe2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802fe2:	55                   	push   %ebp
  802fe3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 05                	push   $0x5
  802ff1:	e8 1c fd ff ff       	call   802d12 <syscall>
  802ff6:	83 c4 18             	add    $0x18,%esp
}
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    

00802ffb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ffb:	55                   	push   %ebp
  802ffc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 06                	push   $0x6
  80300a:	e8 03 fd ff ff       	call   802d12 <syscall>
  80300f:	83 c4 18             	add    $0x18,%esp
}
  803012:	c9                   	leave  
  803013:	c3                   	ret    

00803014 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 07                	push   $0x7
  803023:	e8 ea fc ff ff       	call   802d12 <syscall>
  803028:	83 c4 18             	add    $0x18,%esp
}
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <sys_exit_env>:


void sys_exit_env(void)
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 1c                	push   $0x1c
  80303c:	e8 d1 fc ff ff       	call   802d12 <syscall>
  803041:	83 c4 18             	add    $0x18,%esp
}
  803044:	90                   	nop
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80304d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803050:	8d 50 04             	lea    0x4(%eax),%edx
  803053:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	52                   	push   %edx
  80305d:	50                   	push   %eax
  80305e:	6a 1d                	push   $0x1d
  803060:	e8 ad fc ff ff       	call   802d12 <syscall>
  803065:	83 c4 18             	add    $0x18,%esp
	return result;
  803068:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80306b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80306e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803071:	89 01                	mov    %eax,(%ecx)
  803073:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	c9                   	leave  
  80307a:	c2 04 00             	ret    $0x4

0080307d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	ff 75 10             	pushl  0x10(%ebp)
  803087:	ff 75 0c             	pushl  0xc(%ebp)
  80308a:	ff 75 08             	pushl  0x8(%ebp)
  80308d:	6a 13                	push   $0x13
  80308f:	e8 7e fc ff ff       	call   802d12 <syscall>
  803094:	83 c4 18             	add    $0x18,%esp
	return ;
  803097:	90                   	nop
}
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <sys_rcr2>:
uint32 sys_rcr2()
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 1e                	push   $0x1e
  8030a9:	e8 64 fc ff ff       	call   802d12 <syscall>
  8030ae:	83 c4 18             	add    $0x18,%esp
}
  8030b1:	c9                   	leave  
  8030b2:	c3                   	ret    

008030b3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030b3:	55                   	push   %ebp
  8030b4:	89 e5                	mov    %esp,%ebp
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8030bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	50                   	push   %eax
  8030cc:	6a 1f                	push   $0x1f
  8030ce:	e8 3f fc ff ff       	call   802d12 <syscall>
  8030d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8030d6:	90                   	nop
}
  8030d7:	c9                   	leave  
  8030d8:	c3                   	ret    

008030d9 <rsttst>:
void rsttst()
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 00                	push   $0x0
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 21                	push   $0x21
  8030e8:	e8 25 fc ff ff       	call   802d12 <syscall>
  8030ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f0:	90                   	nop
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8030fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030ff:	8b 55 18             	mov    0x18(%ebp),%edx
  803102:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803106:	52                   	push   %edx
  803107:	50                   	push   %eax
  803108:	ff 75 10             	pushl  0x10(%ebp)
  80310b:	ff 75 0c             	pushl  0xc(%ebp)
  80310e:	ff 75 08             	pushl  0x8(%ebp)
  803111:	6a 20                	push   $0x20
  803113:	e8 fa fb ff ff       	call   802d12 <syscall>
  803118:	83 c4 18             	add    $0x18,%esp
	return ;
  80311b:	90                   	nop
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <chktst>:
void chktst(uint32 n)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	ff 75 08             	pushl  0x8(%ebp)
  80312c:	6a 22                	push   $0x22
  80312e:	e8 df fb ff ff       	call   802d12 <syscall>
  803133:	83 c4 18             	add    $0x18,%esp
	return ;
  803136:	90                   	nop
}
  803137:	c9                   	leave  
  803138:	c3                   	ret    

00803139 <inctst>:

void inctst()
{
  803139:	55                   	push   %ebp
  80313a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 23                	push   $0x23
  803148:	e8 c5 fb ff ff       	call   802d12 <syscall>
  80314d:	83 c4 18             	add    $0x18,%esp
	return ;
  803150:	90                   	nop
}
  803151:	c9                   	leave  
  803152:	c3                   	ret    

00803153 <gettst>:
uint32 gettst()
{
  803153:	55                   	push   %ebp
  803154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 24                	push   $0x24
  803162:	e8 ab fb ff ff       	call   802d12 <syscall>
  803167:	83 c4 18             	add    $0x18,%esp
}
  80316a:	c9                   	leave  
  80316b:	c3                   	ret    

0080316c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 25                	push   $0x25
  80317e:	e8 8f fb ff ff       	call   802d12 <syscall>
  803183:	83 c4 18             	add    $0x18,%esp
  803186:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803189:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80318d:	75 07                	jne    803196 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80318f:	b8 01 00 00 00       	mov    $0x1,%eax
  803194:	eb 05                	jmp    80319b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803196:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319b:	c9                   	leave  
  80319c:	c3                   	ret    

0080319d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
  8031a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 00                	push   $0x0
  8031ad:	6a 25                	push   $0x25
  8031af:	e8 5e fb ff ff       	call   802d12 <syscall>
  8031b4:	83 c4 18             	add    $0x18,%esp
  8031b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8031ba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8031be:	75 07                	jne    8031c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8031c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c5:	eb 05                	jmp    8031cc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8031c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
  8031d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 25                	push   $0x25
  8031e0:	e8 2d fb ff ff       	call   802d12 <syscall>
  8031e5:	83 c4 18             	add    $0x18,%esp
  8031e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8031eb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8031ef:	75 07                	jne    8031f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8031f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031f6:	eb 05                	jmp    8031fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031fd:	c9                   	leave  
  8031fe:	c3                   	ret    

008031ff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8031ff:	55                   	push   %ebp
  803200:	89 e5                	mov    %esp,%ebp
  803202:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 25                	push   $0x25
  803211:	e8 fc fa ff ff       	call   802d12 <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
  803219:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80321c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803220:	75 07                	jne    803229 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803222:	b8 01 00 00 00       	mov    $0x1,%eax
  803227:	eb 05                	jmp    80322e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803229:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80322e:	c9                   	leave  
  80322f:	c3                   	ret    

00803230 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803233:	6a 00                	push   $0x0
  803235:	6a 00                	push   $0x0
  803237:	6a 00                	push   $0x0
  803239:	6a 00                	push   $0x0
  80323b:	ff 75 08             	pushl  0x8(%ebp)
  80323e:	6a 26                	push   $0x26
  803240:	e8 cd fa ff ff       	call   802d12 <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
	return ;
  803248:	90                   	nop
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
  80324e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80324f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803252:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803255:	8b 55 0c             	mov    0xc(%ebp),%edx
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	6a 00                	push   $0x0
  80325d:	53                   	push   %ebx
  80325e:	51                   	push   %ecx
  80325f:	52                   	push   %edx
  803260:	50                   	push   %eax
  803261:	6a 27                	push   $0x27
  803263:	e8 aa fa ff ff       	call   802d12 <syscall>
  803268:	83 c4 18             	add    $0x18,%esp
}
  80326b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803273:	8b 55 0c             	mov    0xc(%ebp),%edx
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	52                   	push   %edx
  803280:	50                   	push   %eax
  803281:	6a 28                	push   $0x28
  803283:	e8 8a fa ff ff       	call   802d12 <syscall>
  803288:	83 c4 18             	add    $0x18,%esp
}
  80328b:	c9                   	leave  
  80328c:	c3                   	ret    

0080328d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80328d:	55                   	push   %ebp
  80328e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803290:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803293:	8b 55 0c             	mov    0xc(%ebp),%edx
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	6a 00                	push   $0x0
  80329b:	51                   	push   %ecx
  80329c:	ff 75 10             	pushl  0x10(%ebp)
  80329f:	52                   	push   %edx
  8032a0:	50                   	push   %eax
  8032a1:	6a 29                	push   $0x29
  8032a3:	e8 6a fa ff ff       	call   802d12 <syscall>
  8032a8:	83 c4 18             	add    $0x18,%esp
}
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	ff 75 10             	pushl  0x10(%ebp)
  8032b7:	ff 75 0c             	pushl  0xc(%ebp)
  8032ba:	ff 75 08             	pushl  0x8(%ebp)
  8032bd:	6a 12                	push   $0x12
  8032bf:	e8 4e fa ff ff       	call   802d12 <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c7:	90                   	nop
}
  8032c8:	c9                   	leave  
  8032c9:	c3                   	ret    

008032ca <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8032cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 00                	push   $0x0
  8032d9:	52                   	push   %edx
  8032da:	50                   	push   %eax
  8032db:	6a 2a                	push   $0x2a
  8032dd:	e8 30 fa ff ff       	call   802d12 <syscall>
  8032e2:	83 c4 18             	add    $0x18,%esp
	return;
  8032e5:	90                   	nop
}
  8032e6:	c9                   	leave  
  8032e7:	c3                   	ret    

008032e8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8032e8:	55                   	push   %ebp
  8032e9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	6a 00                	push   $0x0
  8032f0:	6a 00                	push   $0x0
  8032f2:	6a 00                	push   $0x0
  8032f4:	6a 00                	push   $0x0
  8032f6:	50                   	push   %eax
  8032f7:	6a 2b                	push   $0x2b
  8032f9:	e8 14 fa ff ff       	call   802d12 <syscall>
  8032fe:	83 c4 18             	add    $0x18,%esp
}
  803301:	c9                   	leave  
  803302:	c3                   	ret    

00803303 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803303:	55                   	push   %ebp
  803304:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	ff 75 0c             	pushl  0xc(%ebp)
  80330f:	ff 75 08             	pushl  0x8(%ebp)
  803312:	6a 2c                	push   $0x2c
  803314:	e8 f9 f9 ff ff       	call   802d12 <syscall>
  803319:	83 c4 18             	add    $0x18,%esp
	return;
  80331c:	90                   	nop
}
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    

0080331f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	ff 75 0c             	pushl  0xc(%ebp)
  80332b:	ff 75 08             	pushl  0x8(%ebp)
  80332e:	6a 2d                	push   $0x2d
  803330:	e8 dd f9 ff ff       	call   802d12 <syscall>
  803335:	83 c4 18             	add    $0x18,%esp
	return;
  803338:	90                   	nop
}
  803339:	c9                   	leave  
  80333a:	c3                   	ret    

0080333b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
  80333e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	83 e8 04             	sub    $0x4,%eax
  803347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80334a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803354:	55                   	push   %ebp
  803355:	89 e5                	mov    %esp,%ebp
  803357:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	83 e8 04             	sub    $0x4,%eax
  803360:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  803363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	83 e0 01             	and    $0x1,%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	0f 94 c0             	sete   %al
}
  803370:	c9                   	leave  
  803371:	c3                   	ret    

00803372 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
  803375:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803378:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80337f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803382:	83 f8 02             	cmp    $0x2,%eax
  803385:	74 2b                	je     8033b2 <alloc_block+0x40>
  803387:	83 f8 02             	cmp    $0x2,%eax
  80338a:	7f 07                	jg     803393 <alloc_block+0x21>
  80338c:	83 f8 01             	cmp    $0x1,%eax
  80338f:	74 0e                	je     80339f <alloc_block+0x2d>
  803391:	eb 58                	jmp    8033eb <alloc_block+0x79>
  803393:	83 f8 03             	cmp    $0x3,%eax
  803396:	74 2d                	je     8033c5 <alloc_block+0x53>
  803398:	83 f8 04             	cmp    $0x4,%eax
  80339b:	74 3b                	je     8033d8 <alloc_block+0x66>
  80339d:	eb 4c                	jmp    8033eb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	ff 75 08             	pushl  0x8(%ebp)
  8033a5:	e8 11 03 00 00       	call   8036bb <alloc_block_FF>
  8033aa:	83 c4 10             	add    $0x10,%esp
  8033ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033b0:	eb 4a                	jmp    8033fc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8033b2:	83 ec 0c             	sub    $0xc,%esp
  8033b5:	ff 75 08             	pushl  0x8(%ebp)
  8033b8:	e8 fa 19 00 00       	call   804db7 <alloc_block_NF>
  8033bd:	83 c4 10             	add    $0x10,%esp
  8033c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033c3:	eb 37                	jmp    8033fc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	ff 75 08             	pushl  0x8(%ebp)
  8033cb:	e8 a7 07 00 00       	call   803b77 <alloc_block_BF>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033d6:	eb 24                	jmp    8033fc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8033d8:	83 ec 0c             	sub    $0xc,%esp
  8033db:	ff 75 08             	pushl  0x8(%ebp)
  8033de:	e8 b7 19 00 00       	call   804d9a <alloc_block_WF>
  8033e3:	83 c4 10             	add    $0x10,%esp
  8033e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033e9:	eb 11                	jmp    8033fc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8033eb:	83 ec 0c             	sub    $0xc,%esp
  8033ee:	68 0c 69 80 00       	push   $0x80690c
  8033f3:	e8 b8 e6 ff ff       	call   801ab0 <cprintf>
  8033f8:	83 c4 10             	add    $0x10,%esp
		break;
  8033fb:	90                   	nop
	}
	return va;
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8033ff:	c9                   	leave  
  803400:	c3                   	ret    

00803401 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  803401:	55                   	push   %ebp
  803402:	89 e5                	mov    %esp,%ebp
  803404:	53                   	push   %ebx
  803405:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	68 2c 69 80 00       	push   $0x80692c
  803410:	e8 9b e6 ff ff       	call   801ab0 <cprintf>
  803415:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	68 57 69 80 00       	push   $0x806957
  803420:	e8 8b e6 ff ff       	call   801ab0 <cprintf>
  803425:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80342e:	eb 37                	jmp    803467 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803430:	83 ec 0c             	sub    $0xc,%esp
  803433:	ff 75 f4             	pushl  -0xc(%ebp)
  803436:	e8 19 ff ff ff       	call   803354 <is_free_block>
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	0f be d8             	movsbl %al,%ebx
  803441:	83 ec 0c             	sub    $0xc,%esp
  803444:	ff 75 f4             	pushl  -0xc(%ebp)
  803447:	e8 ef fe ff ff       	call   80333b <get_block_size>
  80344c:	83 c4 10             	add    $0x10,%esp
  80344f:	83 ec 04             	sub    $0x4,%esp
  803452:	53                   	push   %ebx
  803453:	50                   	push   %eax
  803454:	68 6f 69 80 00       	push   $0x80696f
  803459:	e8 52 e6 ff ff       	call   801ab0 <cprintf>
  80345e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803461:	8b 45 10             	mov    0x10(%ebp),%eax
  803464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346b:	74 07                	je     803474 <print_blocks_list+0x73>
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	eb 05                	jmp    803479 <print_blocks_list+0x78>
  803474:	b8 00 00 00 00       	mov    $0x0,%eax
  803479:	89 45 10             	mov    %eax,0x10(%ebp)
  80347c:	8b 45 10             	mov    0x10(%ebp),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	75 ad                	jne    803430 <print_blocks_list+0x2f>
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	75 a7                	jne    803430 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803489:	83 ec 0c             	sub    $0xc,%esp
  80348c:	68 2c 69 80 00       	push   $0x80692c
  803491:	e8 1a e6 ff ff       	call   801ab0 <cprintf>
  803496:	83 c4 10             	add    $0x10,%esp

}
  803499:	90                   	nop
  80349a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80349d:	c9                   	leave  
  80349e:	c3                   	ret    

0080349f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80349f:	55                   	push   %ebp
  8034a0:	89 e5                	mov    %esp,%ebp
  8034a2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a8:	83 e0 01             	and    $0x1,%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 03                	je     8034b2 <initialize_dynamic_allocator+0x13>
  8034af:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8034b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b6:	0f 84 c7 01 00 00    	je     803683 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8034bc:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  8034c3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8034c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cc:	01 d0                	add    %edx,%eax
  8034ce:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8034d3:	0f 87 ad 01 00 00    	ja     803686 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	0f 89 a5 01 00 00    	jns    803689 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8034e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ea:	01 d0                	add    %edx,%eax
  8034ec:	83 e8 04             	sub    $0x4,%eax
  8034ef:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  8034f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8034fb:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803503:	e9 87 00 00 00       	jmp    80358f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350c:	75 14                	jne    803522 <initialize_dynamic_allocator+0x83>
  80350e:	83 ec 04             	sub    $0x4,%esp
  803511:	68 87 69 80 00       	push   $0x806987
  803516:	6a 79                	push   $0x79
  803518:	68 a5 69 80 00       	push   $0x8069a5
  80351d:	e8 d1 e2 ff ff       	call   8017f3 <_panic>
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 10                	je     80353b <initialize_dynamic_allocator+0x9c>
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803533:	8b 52 04             	mov    0x4(%edx),%edx
  803536:	89 50 04             	mov    %edx,0x4(%eax)
  803539:	eb 0b                	jmp    803546 <initialize_dynamic_allocator+0xa7>
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	a3 30 70 80 00       	mov    %eax,0x807030
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 0f                	je     80355f <initialize_dynamic_allocator+0xc0>
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803559:	8b 12                	mov    (%edx),%edx
  80355b:	89 10                	mov    %edx,(%eax)
  80355d:	eb 0a                	jmp    803569 <initialize_dynamic_allocator+0xca>
  80355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357c:	a1 38 70 80 00       	mov    0x807038,%eax
  803581:	48                   	dec    %eax
  803582:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803587:	a1 34 70 80 00       	mov    0x807034,%eax
  80358c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80358f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803593:	74 07                	je     80359c <initialize_dynamic_allocator+0xfd>
  803595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	eb 05                	jmp    8035a1 <initialize_dynamic_allocator+0x102>
  80359c:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a1:	a3 34 70 80 00       	mov    %eax,0x807034
  8035a6:	a1 34 70 80 00       	mov    0x807034,%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	0f 85 55 ff ff ff    	jne    803508 <initialize_dynamic_allocator+0x69>
  8035b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b7:	0f 85 4b ff ff ff    	jne    803508 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8035c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8035cc:	a1 44 70 80 00       	mov    0x807044,%eax
  8035d1:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  8035d6:	a1 40 70 80 00       	mov    0x807040,%eax
  8035db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	83 c0 08             	add    $0x8,%eax
  8035e7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	83 c0 04             	add    $0x4,%eax
  8035f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f3:	83 ea 08             	sub    $0x8,%edx
  8035f6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8035f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	01 d0                	add    %edx,%eax
  803600:	83 e8 08             	sub    $0x8,%eax
  803603:	8b 55 0c             	mov    0xc(%ebp),%edx
  803606:	83 ea 08             	sub    $0x8,%edx
  803609:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80360b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80361e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803622:	75 17                	jne    80363b <initialize_dynamic_allocator+0x19c>
  803624:	83 ec 04             	sub    $0x4,%esp
  803627:	68 c0 69 80 00       	push   $0x8069c0
  80362c:	68 90 00 00 00       	push   $0x90
  803631:	68 a5 69 80 00       	push   $0x8069a5
  803636:	e8 b8 e1 ff ff       	call   8017f3 <_panic>
  80363b:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803644:	89 10                	mov    %edx,(%eax)
  803646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	74 0d                	je     80365c <initialize_dynamic_allocator+0x1bd>
  80364f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803654:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803657:	89 50 04             	mov    %edx,0x4(%eax)
  80365a:	eb 08                	jmp    803664 <initialize_dynamic_allocator+0x1c5>
  80365c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365f:	a3 30 70 80 00       	mov    %eax,0x807030
  803664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803667:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80366c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803676:	a1 38 70 80 00       	mov    0x807038,%eax
  80367b:	40                   	inc    %eax
  80367c:	a3 38 70 80 00       	mov    %eax,0x807038
  803681:	eb 07                	jmp    80368a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803683:	90                   	nop
  803684:	eb 04                	jmp    80368a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803686:	90                   	nop
  803687:	eb 01                	jmp    80368a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803689:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80368a:	c9                   	leave  
  80368b:	c3                   	ret    

0080368c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80368c:	55                   	push   %ebp
  80368d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80368f:	8b 45 10             	mov    0x10(%ebp),%eax
  803692:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803695:	8b 45 08             	mov    0x8(%ebp),%eax
  803698:	8d 50 fc             	lea    -0x4(%eax),%edx
  80369b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	83 e8 04             	sub    $0x4,%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8036ab:	8d 50 f8             	lea    -0x8(%eax),%edx
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	01 c2                	add    %eax,%edx
  8036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b6:	89 02                	mov    %eax,(%edx)
}
  8036b8:	90                   	nop
  8036b9:	5d                   	pop    %ebp
  8036ba:	c3                   	ret    

008036bb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8036bb:	55                   	push   %ebp
  8036bc:	89 e5                	mov    %esp,%ebp
  8036be:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c4:	83 e0 01             	and    $0x1,%eax
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	74 03                	je     8036ce <alloc_block_FF+0x13>
  8036cb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8036ce:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8036d2:	77 07                	ja     8036db <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8036d4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8036db:	a1 24 70 80 00       	mov    0x807024,%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	75 73                	jne    803757 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	83 c0 10             	add    $0x10,%eax
  8036ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8036ed:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8036f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036fa:	01 d0                	add    %edx,%eax
  8036fc:	48                   	dec    %eax
  8036fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	ba 00 00 00 00       	mov    $0x0,%edx
  803708:	f7 75 ec             	divl   -0x14(%ebp)
  80370b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370e:	29 d0                	sub    %edx,%eax
  803710:	c1 e8 0c             	shr    $0xc,%eax
  803713:	83 ec 0c             	sub    $0xc,%esp
  803716:	50                   	push   %eax
  803717:	e8 2e f1 ff ff       	call   80284a <sbrk>
  80371c:	83 c4 10             	add    $0x10,%esp
  80371f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	6a 00                	push   $0x0
  803727:	e8 1e f1 ff ff       	call   80284a <sbrk>
  80372c:	83 c4 10             	add    $0x10,%esp
  80372f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803735:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803738:	83 ec 08             	sub    $0x8,%esp
  80373b:	50                   	push   %eax
  80373c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80373f:	e8 5b fd ff ff       	call   80349f <initialize_dynamic_allocator>
  803744:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803747:	83 ec 0c             	sub    $0xc,%esp
  80374a:	68 e3 69 80 00       	push   $0x8069e3
  80374f:	e8 5c e3 ff ff       	call   801ab0 <cprintf>
  803754:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803757:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375b:	75 0a                	jne    803767 <alloc_block_FF+0xac>
	        return NULL;
  80375d:	b8 00 00 00 00       	mov    $0x0,%eax
  803762:	e9 0e 04 00 00       	jmp    803b75 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80376e:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803773:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803776:	e9 f3 02 00 00       	jmp    803a6e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803781:	83 ec 0c             	sub    $0xc,%esp
  803784:	ff 75 bc             	pushl  -0x44(%ebp)
  803787:	e8 af fb ff ff       	call   80333b <get_block_size>
  80378c:	83 c4 10             	add    $0x10,%esp
  80378f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803792:	8b 45 08             	mov    0x8(%ebp),%eax
  803795:	83 c0 08             	add    $0x8,%eax
  803798:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80379b:	0f 87 c5 02 00 00    	ja     803a66 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	83 c0 18             	add    $0x18,%eax
  8037a7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8037aa:	0f 87 19 02 00 00    	ja     8039c9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8037b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8037b6:	83 e8 08             	sub    $0x8,%eax
  8037b9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bf:	8d 50 08             	lea    0x8(%eax),%edx
  8037c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8037c5:	01 d0                	add    %edx,%eax
  8037c7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	83 c0 08             	add    $0x8,%eax
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	6a 01                	push   $0x1
  8037d5:	50                   	push   %eax
  8037d6:	ff 75 bc             	pushl  -0x44(%ebp)
  8037d9:	e8 ae fe ff ff       	call   80368c <set_block_data>
  8037de:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8037e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e4:	8b 40 04             	mov    0x4(%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	75 68                	jne    803853 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037eb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8037ef:	75 17                	jne    803808 <alloc_block_FF+0x14d>
  8037f1:	83 ec 04             	sub    $0x4,%esp
  8037f4:	68 c0 69 80 00       	push   $0x8069c0
  8037f9:	68 d7 00 00 00       	push   $0xd7
  8037fe:	68 a5 69 80 00       	push   $0x8069a5
  803803:	e8 eb df ff ff       	call   8017f3 <_panic>
  803808:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80380e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803811:	89 10                	mov    %edx,(%eax)
  803813:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	85 c0                	test   %eax,%eax
  80381a:	74 0d                	je     803829 <alloc_block_FF+0x16e>
  80381c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803821:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803824:	89 50 04             	mov    %edx,0x4(%eax)
  803827:	eb 08                	jmp    803831 <alloc_block_FF+0x176>
  803829:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80382c:	a3 30 70 80 00       	mov    %eax,0x807030
  803831:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803834:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803839:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80383c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803843:	a1 38 70 80 00       	mov    0x807038,%eax
  803848:	40                   	inc    %eax
  803849:	a3 38 70 80 00       	mov    %eax,0x807038
  80384e:	e9 dc 00 00 00       	jmp    80392f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	75 65                	jne    8038c1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80385c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803860:	75 17                	jne    803879 <alloc_block_FF+0x1be>
  803862:	83 ec 04             	sub    $0x4,%esp
  803865:	68 f4 69 80 00       	push   $0x8069f4
  80386a:	68 db 00 00 00       	push   $0xdb
  80386f:	68 a5 69 80 00       	push   $0x8069a5
  803874:	e8 7a df ff ff       	call   8017f3 <_panic>
  803879:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80387f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803888:	8b 40 04             	mov    0x4(%eax),%eax
  80388b:	85 c0                	test   %eax,%eax
  80388d:	74 0c                	je     80389b <alloc_block_FF+0x1e0>
  80388f:	a1 30 70 80 00       	mov    0x807030,%eax
  803894:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803897:	89 10                	mov    %edx,(%eax)
  803899:	eb 08                	jmp    8038a3 <alloc_block_FF+0x1e8>
  80389b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80389e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8038a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038a6:	a3 30 70 80 00       	mov    %eax,0x807030
  8038ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b4:	a1 38 70 80 00       	mov    0x807038,%eax
  8038b9:	40                   	inc    %eax
  8038ba:	a3 38 70 80 00       	mov    %eax,0x807038
  8038bf:	eb 6e                	jmp    80392f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8038c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c5:	74 06                	je     8038cd <alloc_block_FF+0x212>
  8038c7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8038cb:	75 17                	jne    8038e4 <alloc_block_FF+0x229>
  8038cd:	83 ec 04             	sub    $0x4,%esp
  8038d0:	68 18 6a 80 00       	push   $0x806a18
  8038d5:	68 df 00 00 00       	push   $0xdf
  8038da:	68 a5 69 80 00       	push   $0x8069a5
  8038df:	e8 0f df ff ff       	call   8017f3 <_panic>
  8038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e7:	8b 10                	mov    (%eax),%edx
  8038e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038ec:	89 10                	mov    %edx,(%eax)
  8038ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 0b                	je     803902 <alloc_block_FF+0x247>
  8038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803905:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803908:	89 10                	mov    %edx,(%eax)
  80390a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80390d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803910:	89 50 04             	mov    %edx,0x4(%eax)
  803913:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	75 08                	jne    803924 <alloc_block_FF+0x269>
  80391c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80391f:	a3 30 70 80 00       	mov    %eax,0x807030
  803924:	a1 38 70 80 00       	mov    0x807038,%eax
  803929:	40                   	inc    %eax
  80392a:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80392f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803933:	75 17                	jne    80394c <alloc_block_FF+0x291>
  803935:	83 ec 04             	sub    $0x4,%esp
  803938:	68 87 69 80 00       	push   $0x806987
  80393d:	68 e1 00 00 00       	push   $0xe1
  803942:	68 a5 69 80 00       	push   $0x8069a5
  803947:	e8 a7 de ff ff       	call   8017f3 <_panic>
  80394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394f:	8b 00                	mov    (%eax),%eax
  803951:	85 c0                	test   %eax,%eax
  803953:	74 10                	je     803965 <alloc_block_FF+0x2aa>
  803955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395d:	8b 52 04             	mov    0x4(%edx),%edx
  803960:	89 50 04             	mov    %edx,0x4(%eax)
  803963:	eb 0b                	jmp    803970 <alloc_block_FF+0x2b5>
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	8b 40 04             	mov    0x4(%eax),%eax
  80396b:	a3 30 70 80 00       	mov    %eax,0x807030
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	85 c0                	test   %eax,%eax
  803978:	74 0f                	je     803989 <alloc_block_FF+0x2ce>
  80397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803983:	8b 12                	mov    (%edx),%edx
  803985:	89 10                	mov    %edx,(%eax)
  803987:	eb 0a                	jmp    803993 <alloc_block_FF+0x2d8>
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80399c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a6:	a1 38 70 80 00       	mov    0x807038,%eax
  8039ab:	48                   	dec    %eax
  8039ac:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	6a 00                	push   $0x0
  8039b6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8039b9:	ff 75 b0             	pushl  -0x50(%ebp)
  8039bc:	e8 cb fc ff ff       	call   80368c <set_block_data>
  8039c1:	83 c4 10             	add    $0x10,%esp
  8039c4:	e9 95 00 00 00       	jmp    803a5e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8039c9:	83 ec 04             	sub    $0x4,%esp
  8039cc:	6a 01                	push   $0x1
  8039ce:	ff 75 b8             	pushl  -0x48(%ebp)
  8039d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8039d4:	e8 b3 fc ff ff       	call   80368c <set_block_data>
  8039d9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8039dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e0:	75 17                	jne    8039f9 <alloc_block_FF+0x33e>
  8039e2:	83 ec 04             	sub    $0x4,%esp
  8039e5:	68 87 69 80 00       	push   $0x806987
  8039ea:	68 e8 00 00 00       	push   $0xe8
  8039ef:	68 a5 69 80 00       	push   $0x8069a5
  8039f4:	e8 fa dd ff ff       	call   8017f3 <_panic>
  8039f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fc:	8b 00                	mov    (%eax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	74 10                	je     803a12 <alloc_block_FF+0x357>
  803a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a05:	8b 00                	mov    (%eax),%eax
  803a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a0a:	8b 52 04             	mov    0x4(%edx),%edx
  803a0d:	89 50 04             	mov    %edx,0x4(%eax)
  803a10:	eb 0b                	jmp    803a1d <alloc_block_FF+0x362>
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 40 04             	mov    0x4(%eax),%eax
  803a18:	a3 30 70 80 00       	mov    %eax,0x807030
  803a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a20:	8b 40 04             	mov    0x4(%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 0f                	je     803a36 <alloc_block_FF+0x37b>
  803a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2a:	8b 40 04             	mov    0x4(%eax),%eax
  803a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a30:	8b 12                	mov    (%edx),%edx
  803a32:	89 10                	mov    %edx,(%eax)
  803a34:	eb 0a                	jmp    803a40 <alloc_block_FF+0x385>
  803a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a53:	a1 38 70 80 00       	mov    0x807038,%eax
  803a58:	48                   	dec    %eax
  803a59:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  803a5e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a61:	e9 0f 01 00 00       	jmp    803b75 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803a66:	a1 34 70 80 00       	mov    0x807034,%eax
  803a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a72:	74 07                	je     803a7b <alloc_block_FF+0x3c0>
  803a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a77:	8b 00                	mov    (%eax),%eax
  803a79:	eb 05                	jmp    803a80 <alloc_block_FF+0x3c5>
  803a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a80:	a3 34 70 80 00       	mov    %eax,0x807034
  803a85:	a1 34 70 80 00       	mov    0x807034,%eax
  803a8a:	85 c0                	test   %eax,%eax
  803a8c:	0f 85 e9 fc ff ff    	jne    80377b <alloc_block_FF+0xc0>
  803a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a96:	0f 85 df fc ff ff    	jne    80377b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9f:	83 c0 08             	add    $0x8,%eax
  803aa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803aa5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803aaf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ab2:	01 d0                	add    %edx,%eax
  803ab4:	48                   	dec    %eax
  803ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abb:	ba 00 00 00 00       	mov    $0x0,%edx
  803ac0:	f7 75 d8             	divl   -0x28(%ebp)
  803ac3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac6:	29 d0                	sub    %edx,%eax
  803ac8:	c1 e8 0c             	shr    $0xc,%eax
  803acb:	83 ec 0c             	sub    $0xc,%esp
  803ace:	50                   	push   %eax
  803acf:	e8 76 ed ff ff       	call   80284a <sbrk>
  803ad4:	83 c4 10             	add    $0x10,%esp
  803ad7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803ada:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803ade:	75 0a                	jne    803aea <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae5:	e9 8b 00 00 00       	jmp    803b75 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803aea:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803af1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803af4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803af7:	01 d0                	add    %edx,%eax
  803af9:	48                   	dec    %eax
  803afa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803afd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b00:	ba 00 00 00 00       	mov    $0x0,%edx
  803b05:	f7 75 cc             	divl   -0x34(%ebp)
  803b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b0b:	29 d0                	sub    %edx,%eax
  803b0d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803b10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b13:	01 d0                	add    %edx,%eax
  803b15:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  803b1a:	a1 40 70 80 00       	mov    0x807040,%eax
  803b1f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803b25:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b32:	01 d0                	add    %edx,%eax
  803b34:	48                   	dec    %eax
  803b35:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803b38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  803b40:	f7 75 c4             	divl   -0x3c(%ebp)
  803b43:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b46:	29 d0                	sub    %edx,%eax
  803b48:	83 ec 04             	sub    $0x4,%esp
  803b4b:	6a 01                	push   $0x1
  803b4d:	50                   	push   %eax
  803b4e:	ff 75 d0             	pushl  -0x30(%ebp)
  803b51:	e8 36 fb ff ff       	call   80368c <set_block_data>
  803b56:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803b59:	83 ec 0c             	sub    $0xc,%esp
  803b5c:	ff 75 d0             	pushl  -0x30(%ebp)
  803b5f:	e8 1b 0a 00 00       	call   80457f <free_block>
  803b64:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803b67:	83 ec 0c             	sub    $0xc,%esp
  803b6a:	ff 75 08             	pushl  0x8(%ebp)
  803b6d:	e8 49 fb ff ff       	call   8036bb <alloc_block_FF>
  803b72:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803b75:	c9                   	leave  
  803b76:	c3                   	ret    

00803b77 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803b77:	55                   	push   %ebp
  803b78:	89 e5                	mov    %esp,%ebp
  803b7a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b80:	83 e0 01             	and    $0x1,%eax
  803b83:	85 c0                	test   %eax,%eax
  803b85:	74 03                	je     803b8a <alloc_block_BF+0x13>
  803b87:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803b8a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803b8e:	77 07                	ja     803b97 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803b90:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803b97:	a1 24 70 80 00       	mov    0x807024,%eax
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	75 73                	jne    803c13 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba3:	83 c0 10             	add    $0x10,%eax
  803ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803ba9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803bb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb6:	01 d0                	add    %edx,%eax
  803bb8:	48                   	dec    %eax
  803bb9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc4:	f7 75 e0             	divl   -0x20(%ebp)
  803bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bca:	29 d0                	sub    %edx,%eax
  803bcc:	c1 e8 0c             	shr    $0xc,%eax
  803bcf:	83 ec 0c             	sub    $0xc,%esp
  803bd2:	50                   	push   %eax
  803bd3:	e8 72 ec ff ff       	call   80284a <sbrk>
  803bd8:	83 c4 10             	add    $0x10,%esp
  803bdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803bde:	83 ec 0c             	sub    $0xc,%esp
  803be1:	6a 00                	push   $0x0
  803be3:	e8 62 ec ff ff       	call   80284a <sbrk>
  803be8:	83 c4 10             	add    $0x10,%esp
  803beb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803bf4:	83 ec 08             	sub    $0x8,%esp
  803bf7:	50                   	push   %eax
  803bf8:	ff 75 d8             	pushl  -0x28(%ebp)
  803bfb:	e8 9f f8 ff ff       	call   80349f <initialize_dynamic_allocator>
  803c00:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803c03:	83 ec 0c             	sub    $0xc,%esp
  803c06:	68 e3 69 80 00       	push   $0x8069e3
  803c0b:	e8 a0 de ff ff       	call   801ab0 <cprintf>
  803c10:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803c1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803c21:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803c28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803c2f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c37:	e9 1d 01 00 00       	jmp    803d59 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803c42:	83 ec 0c             	sub    $0xc,%esp
  803c45:	ff 75 a8             	pushl  -0x58(%ebp)
  803c48:	e8 ee f6 ff ff       	call   80333b <get_block_size>
  803c4d:	83 c4 10             	add    $0x10,%esp
  803c50:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803c53:	8b 45 08             	mov    0x8(%ebp),%eax
  803c56:	83 c0 08             	add    $0x8,%eax
  803c59:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c5c:	0f 87 ef 00 00 00    	ja     803d51 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803c62:	8b 45 08             	mov    0x8(%ebp),%eax
  803c65:	83 c0 18             	add    $0x18,%eax
  803c68:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c6b:	77 1d                	ja     803c8a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c70:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c73:	0f 86 d8 00 00 00    	jbe    803d51 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803c79:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803c7f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c85:	e9 c7 00 00 00       	jmp    803d51 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	83 c0 08             	add    $0x8,%eax
  803c90:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c93:	0f 85 9d 00 00 00    	jne    803d36 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803c99:	83 ec 04             	sub    $0x4,%esp
  803c9c:	6a 01                	push   $0x1
  803c9e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803ca1:	ff 75 a8             	pushl  -0x58(%ebp)
  803ca4:	e8 e3 f9 ff ff       	call   80368c <set_block_data>
  803ca9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb0:	75 17                	jne    803cc9 <alloc_block_BF+0x152>
  803cb2:	83 ec 04             	sub    $0x4,%esp
  803cb5:	68 87 69 80 00       	push   $0x806987
  803cba:	68 2c 01 00 00       	push   $0x12c
  803cbf:	68 a5 69 80 00       	push   $0x8069a5
  803cc4:	e8 2a db ff ff       	call   8017f3 <_panic>
  803cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccc:	8b 00                	mov    (%eax),%eax
  803cce:	85 c0                	test   %eax,%eax
  803cd0:	74 10                	je     803ce2 <alloc_block_BF+0x16b>
  803cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd5:	8b 00                	mov    (%eax),%eax
  803cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cda:	8b 52 04             	mov    0x4(%edx),%edx
  803cdd:	89 50 04             	mov    %edx,0x4(%eax)
  803ce0:	eb 0b                	jmp    803ced <alloc_block_BF+0x176>
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	8b 40 04             	mov    0x4(%eax),%eax
  803ce8:	a3 30 70 80 00       	mov    %eax,0x807030
  803ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf0:	8b 40 04             	mov    0x4(%eax),%eax
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	74 0f                	je     803d06 <alloc_block_BF+0x18f>
  803cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfa:	8b 40 04             	mov    0x4(%eax),%eax
  803cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d00:	8b 12                	mov    (%edx),%edx
  803d02:	89 10                	mov    %edx,(%eax)
  803d04:	eb 0a                	jmp    803d10 <alloc_block_BF+0x199>
  803d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d09:	8b 00                	mov    (%eax),%eax
  803d0b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d23:	a1 38 70 80 00       	mov    0x807038,%eax
  803d28:	48                   	dec    %eax
  803d29:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  803d2e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d31:	e9 24 04 00 00       	jmp    80415a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d39:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803d3c:	76 13                	jbe    803d51 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803d3e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803d45:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803d4b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803d4e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803d51:	a1 34 70 80 00       	mov    0x807034,%eax
  803d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d5d:	74 07                	je     803d66 <alloc_block_BF+0x1ef>
  803d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d62:	8b 00                	mov    (%eax),%eax
  803d64:	eb 05                	jmp    803d6b <alloc_block_BF+0x1f4>
  803d66:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6b:	a3 34 70 80 00       	mov    %eax,0x807034
  803d70:	a1 34 70 80 00       	mov    0x807034,%eax
  803d75:	85 c0                	test   %eax,%eax
  803d77:	0f 85 bf fe ff ff    	jne    803c3c <alloc_block_BF+0xc5>
  803d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d81:	0f 85 b5 fe ff ff    	jne    803c3c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d8b:	0f 84 26 02 00 00    	je     803fb7 <alloc_block_BF+0x440>
  803d91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d95:	0f 85 1c 02 00 00    	jne    803fb7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9e:	2b 45 08             	sub    0x8(%ebp),%eax
  803da1:	83 e8 08             	sub    $0x8,%eax
  803da4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803da7:	8b 45 08             	mov    0x8(%ebp),%eax
  803daa:	8d 50 08             	lea    0x8(%eax),%edx
  803dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db0:	01 d0                	add    %edx,%eax
  803db2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803db5:	8b 45 08             	mov    0x8(%ebp),%eax
  803db8:	83 c0 08             	add    $0x8,%eax
  803dbb:	83 ec 04             	sub    $0x4,%esp
  803dbe:	6a 01                	push   $0x1
  803dc0:	50                   	push   %eax
  803dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  803dc4:	e8 c3 f8 ff ff       	call   80368c <set_block_data>
  803dc9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcf:	8b 40 04             	mov    0x4(%eax),%eax
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	75 68                	jne    803e3e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803dd6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803dda:	75 17                	jne    803df3 <alloc_block_BF+0x27c>
  803ddc:	83 ec 04             	sub    $0x4,%esp
  803ddf:	68 c0 69 80 00       	push   $0x8069c0
  803de4:	68 45 01 00 00       	push   $0x145
  803de9:	68 a5 69 80 00       	push   $0x8069a5
  803dee:	e8 00 da ff ff       	call   8017f3 <_panic>
  803df3:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803df9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dfc:	89 10                	mov    %edx,(%eax)
  803dfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e01:	8b 00                	mov    (%eax),%eax
  803e03:	85 c0                	test   %eax,%eax
  803e05:	74 0d                	je     803e14 <alloc_block_BF+0x29d>
  803e07:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803e0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e0f:	89 50 04             	mov    %edx,0x4(%eax)
  803e12:	eb 08                	jmp    803e1c <alloc_block_BF+0x2a5>
  803e14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e17:	a3 30 70 80 00       	mov    %eax,0x807030
  803e1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e1f:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e2e:	a1 38 70 80 00       	mov    0x807038,%eax
  803e33:	40                   	inc    %eax
  803e34:	a3 38 70 80 00       	mov    %eax,0x807038
  803e39:	e9 dc 00 00 00       	jmp    803f1a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e41:	8b 00                	mov    (%eax),%eax
  803e43:	85 c0                	test   %eax,%eax
  803e45:	75 65                	jne    803eac <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803e47:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e4b:	75 17                	jne    803e64 <alloc_block_BF+0x2ed>
  803e4d:	83 ec 04             	sub    $0x4,%esp
  803e50:	68 f4 69 80 00       	push   $0x8069f4
  803e55:	68 4a 01 00 00       	push   $0x14a
  803e5a:	68 a5 69 80 00       	push   $0x8069a5
  803e5f:	e8 8f d9 ff ff       	call   8017f3 <_panic>
  803e64:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803e6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e6d:	89 50 04             	mov    %edx,0x4(%eax)
  803e70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e73:	8b 40 04             	mov    0x4(%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 0c                	je     803e86 <alloc_block_BF+0x30f>
  803e7a:	a1 30 70 80 00       	mov    0x807030,%eax
  803e7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e82:	89 10                	mov    %edx,(%eax)
  803e84:	eb 08                	jmp    803e8e <alloc_block_BF+0x317>
  803e86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e89:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e91:	a3 30 70 80 00       	mov    %eax,0x807030
  803e96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e9f:	a1 38 70 80 00       	mov    0x807038,%eax
  803ea4:	40                   	inc    %eax
  803ea5:	a3 38 70 80 00       	mov    %eax,0x807038
  803eaa:	eb 6e                	jmp    803f1a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eb0:	74 06                	je     803eb8 <alloc_block_BF+0x341>
  803eb2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803eb6:	75 17                	jne    803ecf <alloc_block_BF+0x358>
  803eb8:	83 ec 04             	sub    $0x4,%esp
  803ebb:	68 18 6a 80 00       	push   $0x806a18
  803ec0:	68 4f 01 00 00       	push   $0x14f
  803ec5:	68 a5 69 80 00       	push   $0x8069a5
  803eca:	e8 24 d9 ff ff       	call   8017f3 <_panic>
  803ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed2:	8b 10                	mov    (%eax),%edx
  803ed4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ed7:	89 10                	mov    %edx,(%eax)
  803ed9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803edc:	8b 00                	mov    (%eax),%eax
  803ede:	85 c0                	test   %eax,%eax
  803ee0:	74 0b                	je     803eed <alloc_block_BF+0x376>
  803ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee5:	8b 00                	mov    (%eax),%eax
  803ee7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803ef3:	89 10                	mov    %edx,(%eax)
  803ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ef8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803efb:	89 50 04             	mov    %edx,0x4(%eax)
  803efe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f01:	8b 00                	mov    (%eax),%eax
  803f03:	85 c0                	test   %eax,%eax
  803f05:	75 08                	jne    803f0f <alloc_block_BF+0x398>
  803f07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f0a:	a3 30 70 80 00       	mov    %eax,0x807030
  803f0f:	a1 38 70 80 00       	mov    0x807038,%eax
  803f14:	40                   	inc    %eax
  803f15:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803f1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f1e:	75 17                	jne    803f37 <alloc_block_BF+0x3c0>
  803f20:	83 ec 04             	sub    $0x4,%esp
  803f23:	68 87 69 80 00       	push   $0x806987
  803f28:	68 51 01 00 00       	push   $0x151
  803f2d:	68 a5 69 80 00       	push   $0x8069a5
  803f32:	e8 bc d8 ff ff       	call   8017f3 <_panic>
  803f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	85 c0                	test   %eax,%eax
  803f3e:	74 10                	je     803f50 <alloc_block_BF+0x3d9>
  803f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f43:	8b 00                	mov    (%eax),%eax
  803f45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f48:	8b 52 04             	mov    0x4(%edx),%edx
  803f4b:	89 50 04             	mov    %edx,0x4(%eax)
  803f4e:	eb 0b                	jmp    803f5b <alloc_block_BF+0x3e4>
  803f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f53:	8b 40 04             	mov    0x4(%eax),%eax
  803f56:	a3 30 70 80 00       	mov    %eax,0x807030
  803f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5e:	8b 40 04             	mov    0x4(%eax),%eax
  803f61:	85 c0                	test   %eax,%eax
  803f63:	74 0f                	je     803f74 <alloc_block_BF+0x3fd>
  803f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f68:	8b 40 04             	mov    0x4(%eax),%eax
  803f6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f6e:	8b 12                	mov    (%edx),%edx
  803f70:	89 10                	mov    %edx,(%eax)
  803f72:	eb 0a                	jmp    803f7e <alloc_block_BF+0x407>
  803f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f91:	a1 38 70 80 00       	mov    0x807038,%eax
  803f96:	48                   	dec    %eax
  803f97:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  803f9c:	83 ec 04             	sub    $0x4,%esp
  803f9f:	6a 00                	push   $0x0
  803fa1:	ff 75 d0             	pushl  -0x30(%ebp)
  803fa4:	ff 75 cc             	pushl  -0x34(%ebp)
  803fa7:	e8 e0 f6 ff ff       	call   80368c <set_block_data>
  803fac:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb2:	e9 a3 01 00 00       	jmp    80415a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803fb7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803fbb:	0f 85 9d 00 00 00    	jne    80405e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803fc1:	83 ec 04             	sub    $0x4,%esp
  803fc4:	6a 01                	push   $0x1
  803fc6:	ff 75 ec             	pushl  -0x14(%ebp)
  803fc9:	ff 75 f0             	pushl  -0x10(%ebp)
  803fcc:	e8 bb f6 ff ff       	call   80368c <set_block_data>
  803fd1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fd8:	75 17                	jne    803ff1 <alloc_block_BF+0x47a>
  803fda:	83 ec 04             	sub    $0x4,%esp
  803fdd:	68 87 69 80 00       	push   $0x806987
  803fe2:	68 58 01 00 00       	push   $0x158
  803fe7:	68 a5 69 80 00       	push   $0x8069a5
  803fec:	e8 02 d8 ff ff       	call   8017f3 <_panic>
  803ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff4:	8b 00                	mov    (%eax),%eax
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	74 10                	je     80400a <alloc_block_BF+0x493>
  803ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ffd:	8b 00                	mov    (%eax),%eax
  803fff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804002:	8b 52 04             	mov    0x4(%edx),%edx
  804005:	89 50 04             	mov    %edx,0x4(%eax)
  804008:	eb 0b                	jmp    804015 <alloc_block_BF+0x49e>
  80400a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400d:	8b 40 04             	mov    0x4(%eax),%eax
  804010:	a3 30 70 80 00       	mov    %eax,0x807030
  804015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804018:	8b 40 04             	mov    0x4(%eax),%eax
  80401b:	85 c0                	test   %eax,%eax
  80401d:	74 0f                	je     80402e <alloc_block_BF+0x4b7>
  80401f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804022:	8b 40 04             	mov    0x4(%eax),%eax
  804025:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804028:	8b 12                	mov    (%edx),%edx
  80402a:	89 10                	mov    %edx,(%eax)
  80402c:	eb 0a                	jmp    804038 <alloc_block_BF+0x4c1>
  80402e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804031:	8b 00                	mov    (%eax),%eax
  804033:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80404b:	a1 38 70 80 00       	mov    0x807038,%eax
  804050:	48                   	dec    %eax
  804051:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  804056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804059:	e9 fc 00 00 00       	jmp    80415a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	83 c0 08             	add    $0x8,%eax
  804064:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  804067:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80406e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804071:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804074:	01 d0                	add    %edx,%eax
  804076:	48                   	dec    %eax
  804077:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80407a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80407d:	ba 00 00 00 00       	mov    $0x0,%edx
  804082:	f7 75 c4             	divl   -0x3c(%ebp)
  804085:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804088:	29 d0                	sub    %edx,%eax
  80408a:	c1 e8 0c             	shr    $0xc,%eax
  80408d:	83 ec 0c             	sub    $0xc,%esp
  804090:	50                   	push   %eax
  804091:	e8 b4 e7 ff ff       	call   80284a <sbrk>
  804096:	83 c4 10             	add    $0x10,%esp
  804099:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80409c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8040a0:	75 0a                	jne    8040ac <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8040a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a7:	e9 ae 00 00 00       	jmp    80415a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8040ac:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8040b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b9:	01 d0                	add    %edx,%eax
  8040bb:	48                   	dec    %eax
  8040bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8040bf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8040c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8040c7:	f7 75 b8             	divl   -0x48(%ebp)
  8040ca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8040cd:	29 d0                	sub    %edx,%eax
  8040cf:	8d 50 fc             	lea    -0x4(%eax),%edx
  8040d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8040d5:	01 d0                	add    %edx,%eax
  8040d7:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  8040dc:	a1 40 70 80 00       	mov    0x807040,%eax
  8040e1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8040e7:	83 ec 0c             	sub    $0xc,%esp
  8040ea:	68 4c 6a 80 00       	push   $0x806a4c
  8040ef:	e8 bc d9 ff ff       	call   801ab0 <cprintf>
  8040f4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8040f7:	83 ec 08             	sub    $0x8,%esp
  8040fa:	ff 75 bc             	pushl  -0x44(%ebp)
  8040fd:	68 51 6a 80 00       	push   $0x806a51
  804102:	e8 a9 d9 ff ff       	call   801ab0 <cprintf>
  804107:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80410a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  804111:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804114:	8b 45 b0             	mov    -0x50(%ebp),%eax
  804117:	01 d0                	add    %edx,%eax
  804119:	48                   	dec    %eax
  80411a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80411d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804120:	ba 00 00 00 00       	mov    $0x0,%edx
  804125:	f7 75 b0             	divl   -0x50(%ebp)
  804128:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80412b:	29 d0                	sub    %edx,%eax
  80412d:	83 ec 04             	sub    $0x4,%esp
  804130:	6a 01                	push   $0x1
  804132:	50                   	push   %eax
  804133:	ff 75 bc             	pushl  -0x44(%ebp)
  804136:	e8 51 f5 ff ff       	call   80368c <set_block_data>
  80413b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80413e:	83 ec 0c             	sub    $0xc,%esp
  804141:	ff 75 bc             	pushl  -0x44(%ebp)
  804144:	e8 36 04 00 00       	call   80457f <free_block>
  804149:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80414c:	83 ec 0c             	sub    $0xc,%esp
  80414f:	ff 75 08             	pushl  0x8(%ebp)
  804152:	e8 20 fa ff ff       	call   803b77 <alloc_block_BF>
  804157:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80415a:	c9                   	leave  
  80415b:	c3                   	ret    

0080415c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80415c:	55                   	push   %ebp
  80415d:	89 e5                	mov    %esp,%ebp
  80415f:	53                   	push   %ebx
  804160:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  804163:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80416a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  804171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804175:	74 1e                	je     804195 <merging+0x39>
  804177:	ff 75 08             	pushl  0x8(%ebp)
  80417a:	e8 bc f1 ff ff       	call   80333b <get_block_size>
  80417f:	83 c4 04             	add    $0x4,%esp
  804182:	89 c2                	mov    %eax,%edx
  804184:	8b 45 08             	mov    0x8(%ebp),%eax
  804187:	01 d0                	add    %edx,%eax
  804189:	3b 45 10             	cmp    0x10(%ebp),%eax
  80418c:	75 07                	jne    804195 <merging+0x39>
		prev_is_free = 1;
  80418e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  804195:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804199:	74 1e                	je     8041b9 <merging+0x5d>
  80419b:	ff 75 10             	pushl  0x10(%ebp)
  80419e:	e8 98 f1 ff ff       	call   80333b <get_block_size>
  8041a3:	83 c4 04             	add    $0x4,%esp
  8041a6:	89 c2                	mov    %eax,%edx
  8041a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8041ab:	01 d0                	add    %edx,%eax
  8041ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8041b0:	75 07                	jne    8041b9 <merging+0x5d>
		next_is_free = 1;
  8041b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8041b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041bd:	0f 84 cc 00 00 00    	je     80428f <merging+0x133>
  8041c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041c7:	0f 84 c2 00 00 00    	je     80428f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8041cd:	ff 75 08             	pushl  0x8(%ebp)
  8041d0:	e8 66 f1 ff ff       	call   80333b <get_block_size>
  8041d5:	83 c4 04             	add    $0x4,%esp
  8041d8:	89 c3                	mov    %eax,%ebx
  8041da:	ff 75 10             	pushl  0x10(%ebp)
  8041dd:	e8 59 f1 ff ff       	call   80333b <get_block_size>
  8041e2:	83 c4 04             	add    $0x4,%esp
  8041e5:	01 c3                	add    %eax,%ebx
  8041e7:	ff 75 0c             	pushl  0xc(%ebp)
  8041ea:	e8 4c f1 ff ff       	call   80333b <get_block_size>
  8041ef:	83 c4 04             	add    $0x4,%esp
  8041f2:	01 d8                	add    %ebx,%eax
  8041f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8041f7:	6a 00                	push   $0x0
  8041f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8041fc:	ff 75 08             	pushl  0x8(%ebp)
  8041ff:	e8 88 f4 ff ff       	call   80368c <set_block_data>
  804204:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  804207:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80420b:	75 17                	jne    804224 <merging+0xc8>
  80420d:	83 ec 04             	sub    $0x4,%esp
  804210:	68 87 69 80 00       	push   $0x806987
  804215:	68 7d 01 00 00       	push   $0x17d
  80421a:	68 a5 69 80 00       	push   $0x8069a5
  80421f:	e8 cf d5 ff ff       	call   8017f3 <_panic>
  804224:	8b 45 0c             	mov    0xc(%ebp),%eax
  804227:	8b 00                	mov    (%eax),%eax
  804229:	85 c0                	test   %eax,%eax
  80422b:	74 10                	je     80423d <merging+0xe1>
  80422d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804230:	8b 00                	mov    (%eax),%eax
  804232:	8b 55 0c             	mov    0xc(%ebp),%edx
  804235:	8b 52 04             	mov    0x4(%edx),%edx
  804238:	89 50 04             	mov    %edx,0x4(%eax)
  80423b:	eb 0b                	jmp    804248 <merging+0xec>
  80423d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804240:	8b 40 04             	mov    0x4(%eax),%eax
  804243:	a3 30 70 80 00       	mov    %eax,0x807030
  804248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80424b:	8b 40 04             	mov    0x4(%eax),%eax
  80424e:	85 c0                	test   %eax,%eax
  804250:	74 0f                	je     804261 <merging+0x105>
  804252:	8b 45 0c             	mov    0xc(%ebp),%eax
  804255:	8b 40 04             	mov    0x4(%eax),%eax
  804258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80425b:	8b 12                	mov    (%edx),%edx
  80425d:	89 10                	mov    %edx,(%eax)
  80425f:	eb 0a                	jmp    80426b <merging+0x10f>
  804261:	8b 45 0c             	mov    0xc(%ebp),%eax
  804264:	8b 00                	mov    (%eax),%eax
  804266:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80426b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80426e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804274:	8b 45 0c             	mov    0xc(%ebp),%eax
  804277:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80427e:	a1 38 70 80 00       	mov    0x807038,%eax
  804283:	48                   	dec    %eax
  804284:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804289:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80428a:	e9 ea 02 00 00       	jmp    804579 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80428f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804293:	74 3b                	je     8042d0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  804295:	83 ec 0c             	sub    $0xc,%esp
  804298:	ff 75 08             	pushl  0x8(%ebp)
  80429b:	e8 9b f0 ff ff       	call   80333b <get_block_size>
  8042a0:	83 c4 10             	add    $0x10,%esp
  8042a3:	89 c3                	mov    %eax,%ebx
  8042a5:	83 ec 0c             	sub    $0xc,%esp
  8042a8:	ff 75 10             	pushl  0x10(%ebp)
  8042ab:	e8 8b f0 ff ff       	call   80333b <get_block_size>
  8042b0:	83 c4 10             	add    $0x10,%esp
  8042b3:	01 d8                	add    %ebx,%eax
  8042b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8042b8:	83 ec 04             	sub    $0x4,%esp
  8042bb:	6a 00                	push   $0x0
  8042bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8042c0:	ff 75 08             	pushl  0x8(%ebp)
  8042c3:	e8 c4 f3 ff ff       	call   80368c <set_block_data>
  8042c8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8042cb:	e9 a9 02 00 00       	jmp    804579 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8042d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d4:	0f 84 2d 01 00 00    	je     804407 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8042da:	83 ec 0c             	sub    $0xc,%esp
  8042dd:	ff 75 10             	pushl  0x10(%ebp)
  8042e0:	e8 56 f0 ff ff       	call   80333b <get_block_size>
  8042e5:	83 c4 10             	add    $0x10,%esp
  8042e8:	89 c3                	mov    %eax,%ebx
  8042ea:	83 ec 0c             	sub    $0xc,%esp
  8042ed:	ff 75 0c             	pushl  0xc(%ebp)
  8042f0:	e8 46 f0 ff ff       	call   80333b <get_block_size>
  8042f5:	83 c4 10             	add    $0x10,%esp
  8042f8:	01 d8                	add    %ebx,%eax
  8042fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8042fd:	83 ec 04             	sub    $0x4,%esp
  804300:	6a 00                	push   $0x0
  804302:	ff 75 e4             	pushl  -0x1c(%ebp)
  804305:	ff 75 10             	pushl  0x10(%ebp)
  804308:	e8 7f f3 ff ff       	call   80368c <set_block_data>
  80430d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  804310:	8b 45 10             	mov    0x10(%ebp),%eax
  804313:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  804316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80431a:	74 06                	je     804322 <merging+0x1c6>
  80431c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804320:	75 17                	jne    804339 <merging+0x1dd>
  804322:	83 ec 04             	sub    $0x4,%esp
  804325:	68 60 6a 80 00       	push   $0x806a60
  80432a:	68 8d 01 00 00       	push   $0x18d
  80432f:	68 a5 69 80 00       	push   $0x8069a5
  804334:	e8 ba d4 ff ff       	call   8017f3 <_panic>
  804339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80433c:	8b 50 04             	mov    0x4(%eax),%edx
  80433f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804342:	89 50 04             	mov    %edx,0x4(%eax)
  804345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80434b:	89 10                	mov    %edx,(%eax)
  80434d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804350:	8b 40 04             	mov    0x4(%eax),%eax
  804353:	85 c0                	test   %eax,%eax
  804355:	74 0d                	je     804364 <merging+0x208>
  804357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80435a:	8b 40 04             	mov    0x4(%eax),%eax
  80435d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804360:	89 10                	mov    %edx,(%eax)
  804362:	eb 08                	jmp    80436c <merging+0x210>
  804364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804367:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80436c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80436f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804372:	89 50 04             	mov    %edx,0x4(%eax)
  804375:	a1 38 70 80 00       	mov    0x807038,%eax
  80437a:	40                   	inc    %eax
  80437b:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  804380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804384:	75 17                	jne    80439d <merging+0x241>
  804386:	83 ec 04             	sub    $0x4,%esp
  804389:	68 87 69 80 00       	push   $0x806987
  80438e:	68 8e 01 00 00       	push   $0x18e
  804393:	68 a5 69 80 00       	push   $0x8069a5
  804398:	e8 56 d4 ff ff       	call   8017f3 <_panic>
  80439d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043a0:	8b 00                	mov    (%eax),%eax
  8043a2:	85 c0                	test   %eax,%eax
  8043a4:	74 10                	je     8043b6 <merging+0x25a>
  8043a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043a9:	8b 00                	mov    (%eax),%eax
  8043ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043ae:	8b 52 04             	mov    0x4(%edx),%edx
  8043b1:	89 50 04             	mov    %edx,0x4(%eax)
  8043b4:	eb 0b                	jmp    8043c1 <merging+0x265>
  8043b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043b9:	8b 40 04             	mov    0x4(%eax),%eax
  8043bc:	a3 30 70 80 00       	mov    %eax,0x807030
  8043c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043c4:	8b 40 04             	mov    0x4(%eax),%eax
  8043c7:	85 c0                	test   %eax,%eax
  8043c9:	74 0f                	je     8043da <merging+0x27e>
  8043cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043ce:	8b 40 04             	mov    0x4(%eax),%eax
  8043d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043d4:	8b 12                	mov    (%edx),%edx
  8043d6:	89 10                	mov    %edx,(%eax)
  8043d8:	eb 0a                	jmp    8043e4 <merging+0x288>
  8043da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043dd:	8b 00                	mov    (%eax),%eax
  8043df:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8043e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f7:	a1 38 70 80 00       	mov    0x807038,%eax
  8043fc:	48                   	dec    %eax
  8043fd:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804402:	e9 72 01 00 00       	jmp    804579 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  804407:	8b 45 10             	mov    0x10(%ebp),%eax
  80440a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80440d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804411:	74 79                	je     80448c <merging+0x330>
  804413:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804417:	74 73                	je     80448c <merging+0x330>
  804419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80441d:	74 06                	je     804425 <merging+0x2c9>
  80441f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804423:	75 17                	jne    80443c <merging+0x2e0>
  804425:	83 ec 04             	sub    $0x4,%esp
  804428:	68 18 6a 80 00       	push   $0x806a18
  80442d:	68 94 01 00 00       	push   $0x194
  804432:	68 a5 69 80 00       	push   $0x8069a5
  804437:	e8 b7 d3 ff ff       	call   8017f3 <_panic>
  80443c:	8b 45 08             	mov    0x8(%ebp),%eax
  80443f:	8b 10                	mov    (%eax),%edx
  804441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804444:	89 10                	mov    %edx,(%eax)
  804446:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804449:	8b 00                	mov    (%eax),%eax
  80444b:	85 c0                	test   %eax,%eax
  80444d:	74 0b                	je     80445a <merging+0x2fe>
  80444f:	8b 45 08             	mov    0x8(%ebp),%eax
  804452:	8b 00                	mov    (%eax),%eax
  804454:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804457:	89 50 04             	mov    %edx,0x4(%eax)
  80445a:	8b 45 08             	mov    0x8(%ebp),%eax
  80445d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804460:	89 10                	mov    %edx,(%eax)
  804462:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804465:	8b 55 08             	mov    0x8(%ebp),%edx
  804468:	89 50 04             	mov    %edx,0x4(%eax)
  80446b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80446e:	8b 00                	mov    (%eax),%eax
  804470:	85 c0                	test   %eax,%eax
  804472:	75 08                	jne    80447c <merging+0x320>
  804474:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804477:	a3 30 70 80 00       	mov    %eax,0x807030
  80447c:	a1 38 70 80 00       	mov    0x807038,%eax
  804481:	40                   	inc    %eax
  804482:	a3 38 70 80 00       	mov    %eax,0x807038
  804487:	e9 ce 00 00 00       	jmp    80455a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80448c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804490:	74 65                	je     8044f7 <merging+0x39b>
  804492:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804496:	75 17                	jne    8044af <merging+0x353>
  804498:	83 ec 04             	sub    $0x4,%esp
  80449b:	68 f4 69 80 00       	push   $0x8069f4
  8044a0:	68 95 01 00 00       	push   $0x195
  8044a5:	68 a5 69 80 00       	push   $0x8069a5
  8044aa:	e8 44 d3 ff ff       	call   8017f3 <_panic>
  8044af:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8044b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044b8:	89 50 04             	mov    %edx,0x4(%eax)
  8044bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044be:	8b 40 04             	mov    0x4(%eax),%eax
  8044c1:	85 c0                	test   %eax,%eax
  8044c3:	74 0c                	je     8044d1 <merging+0x375>
  8044c5:	a1 30 70 80 00       	mov    0x807030,%eax
  8044ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044cd:	89 10                	mov    %edx,(%eax)
  8044cf:	eb 08                	jmp    8044d9 <merging+0x37d>
  8044d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044d4:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8044d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044dc:	a3 30 70 80 00       	mov    %eax,0x807030
  8044e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044ea:	a1 38 70 80 00       	mov    0x807038,%eax
  8044ef:	40                   	inc    %eax
  8044f0:	a3 38 70 80 00       	mov    %eax,0x807038
  8044f5:	eb 63                	jmp    80455a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8044f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8044fb:	75 17                	jne    804514 <merging+0x3b8>
  8044fd:	83 ec 04             	sub    $0x4,%esp
  804500:	68 c0 69 80 00       	push   $0x8069c0
  804505:	68 98 01 00 00       	push   $0x198
  80450a:	68 a5 69 80 00       	push   $0x8069a5
  80450f:	e8 df d2 ff ff       	call   8017f3 <_panic>
  804514:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80451a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80451d:	89 10                	mov    %edx,(%eax)
  80451f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804522:	8b 00                	mov    (%eax),%eax
  804524:	85 c0                	test   %eax,%eax
  804526:	74 0d                	je     804535 <merging+0x3d9>
  804528:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80452d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804530:	89 50 04             	mov    %edx,0x4(%eax)
  804533:	eb 08                	jmp    80453d <merging+0x3e1>
  804535:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804538:	a3 30 70 80 00       	mov    %eax,0x807030
  80453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804540:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804545:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80454f:	a1 38 70 80 00       	mov    0x807038,%eax
  804554:	40                   	inc    %eax
  804555:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  80455a:	83 ec 0c             	sub    $0xc,%esp
  80455d:	ff 75 10             	pushl  0x10(%ebp)
  804560:	e8 d6 ed ff ff       	call   80333b <get_block_size>
  804565:	83 c4 10             	add    $0x10,%esp
  804568:	83 ec 04             	sub    $0x4,%esp
  80456b:	6a 00                	push   $0x0
  80456d:	50                   	push   %eax
  80456e:	ff 75 10             	pushl  0x10(%ebp)
  804571:	e8 16 f1 ff ff       	call   80368c <set_block_data>
  804576:	83 c4 10             	add    $0x10,%esp
	}
}
  804579:	90                   	nop
  80457a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80457d:	c9                   	leave  
  80457e:	c3                   	ret    

0080457f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80457f:	55                   	push   %ebp
  804580:	89 e5                	mov    %esp,%ebp
  804582:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804585:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80458a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80458d:	a1 30 70 80 00       	mov    0x807030,%eax
  804592:	3b 45 08             	cmp    0x8(%ebp),%eax
  804595:	73 1b                	jae    8045b2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804597:	a1 30 70 80 00       	mov    0x807030,%eax
  80459c:	83 ec 04             	sub    $0x4,%esp
  80459f:	ff 75 08             	pushl  0x8(%ebp)
  8045a2:	6a 00                	push   $0x0
  8045a4:	50                   	push   %eax
  8045a5:	e8 b2 fb ff ff       	call   80415c <merging>
  8045aa:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8045ad:	e9 8b 00 00 00       	jmp    80463d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8045b2:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045ba:	76 18                	jbe    8045d4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8045bc:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045c1:	83 ec 04             	sub    $0x4,%esp
  8045c4:	ff 75 08             	pushl  0x8(%ebp)
  8045c7:	50                   	push   %eax
  8045c8:	6a 00                	push   $0x0
  8045ca:	e8 8d fb ff ff       	call   80415c <merging>
  8045cf:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8045d2:	eb 69                	jmp    80463d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8045d4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045dc:	eb 39                	jmp    804617 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8045de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045e4:	73 29                	jae    80460f <free_block+0x90>
  8045e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e9:	8b 00                	mov    (%eax),%eax
  8045eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045ee:	76 1f                	jbe    80460f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f3:	8b 00                	mov    (%eax),%eax
  8045f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8045f8:	83 ec 04             	sub    $0x4,%esp
  8045fb:	ff 75 08             	pushl  0x8(%ebp)
  8045fe:	ff 75 f0             	pushl  -0x10(%ebp)
  804601:	ff 75 f4             	pushl  -0xc(%ebp)
  804604:	e8 53 fb ff ff       	call   80415c <merging>
  804609:	83 c4 10             	add    $0x10,%esp
			break;
  80460c:	90                   	nop
		}
	}
}
  80460d:	eb 2e                	jmp    80463d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80460f:	a1 34 70 80 00       	mov    0x807034,%eax
  804614:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80461b:	74 07                	je     804624 <free_block+0xa5>
  80461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804620:	8b 00                	mov    (%eax),%eax
  804622:	eb 05                	jmp    804629 <free_block+0xaa>
  804624:	b8 00 00 00 00       	mov    $0x0,%eax
  804629:	a3 34 70 80 00       	mov    %eax,0x807034
  80462e:	a1 34 70 80 00       	mov    0x807034,%eax
  804633:	85 c0                	test   %eax,%eax
  804635:	75 a7                	jne    8045de <free_block+0x5f>
  804637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80463b:	75 a1                	jne    8045de <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80463d:	90                   	nop
  80463e:	c9                   	leave  
  80463f:	c3                   	ret    

00804640 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804640:	55                   	push   %ebp
  804641:	89 e5                	mov    %esp,%ebp
  804643:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804646:	ff 75 08             	pushl  0x8(%ebp)
  804649:	e8 ed ec ff ff       	call   80333b <get_block_size>
  80464e:	83 c4 04             	add    $0x4,%esp
  804651:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804654:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80465b:	eb 17                	jmp    804674 <copy_data+0x34>
  80465d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804660:	8b 45 0c             	mov    0xc(%ebp),%eax
  804663:	01 c2                	add    %eax,%edx
  804665:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804668:	8b 45 08             	mov    0x8(%ebp),%eax
  80466b:	01 c8                	add    %ecx,%eax
  80466d:	8a 00                	mov    (%eax),%al
  80466f:	88 02                	mov    %al,(%edx)
  804671:	ff 45 fc             	incl   -0x4(%ebp)
  804674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804677:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80467a:	72 e1                	jb     80465d <copy_data+0x1d>
}
  80467c:	90                   	nop
  80467d:	c9                   	leave  
  80467e:	c3                   	ret    

0080467f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80467f:	55                   	push   %ebp
  804680:	89 e5                	mov    %esp,%ebp
  804682:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804685:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804689:	75 23                	jne    8046ae <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80468b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80468f:	74 13                	je     8046a4 <realloc_block_FF+0x25>
  804691:	83 ec 0c             	sub    $0xc,%esp
  804694:	ff 75 0c             	pushl  0xc(%ebp)
  804697:	e8 1f f0 ff ff       	call   8036bb <alloc_block_FF>
  80469c:	83 c4 10             	add    $0x10,%esp
  80469f:	e9 f4 06 00 00       	jmp    804d98 <realloc_block_FF+0x719>
		return NULL;
  8046a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a9:	e9 ea 06 00 00       	jmp    804d98 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8046ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8046b2:	75 18                	jne    8046cc <realloc_block_FF+0x4d>
	{
		free_block(va);
  8046b4:	83 ec 0c             	sub    $0xc,%esp
  8046b7:	ff 75 08             	pushl  0x8(%ebp)
  8046ba:	e8 c0 fe ff ff       	call   80457f <free_block>
  8046bf:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8046c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c7:	e9 cc 06 00 00       	jmp    804d98 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8046cc:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8046d0:	77 07                	ja     8046d9 <realloc_block_FF+0x5a>
  8046d2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8046d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046dc:	83 e0 01             	and    $0x1,%eax
  8046df:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8046e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046e5:	83 c0 08             	add    $0x8,%eax
  8046e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8046eb:	83 ec 0c             	sub    $0xc,%esp
  8046ee:	ff 75 08             	pushl  0x8(%ebp)
  8046f1:	e8 45 ec ff ff       	call   80333b <get_block_size>
  8046f6:	83 c4 10             	add    $0x10,%esp
  8046f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8046fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046ff:	83 e8 08             	sub    $0x8,%eax
  804702:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804705:	8b 45 08             	mov    0x8(%ebp),%eax
  804708:	83 e8 04             	sub    $0x4,%eax
  80470b:	8b 00                	mov    (%eax),%eax
  80470d:	83 e0 fe             	and    $0xfffffffe,%eax
  804710:	89 c2                	mov    %eax,%edx
  804712:	8b 45 08             	mov    0x8(%ebp),%eax
  804715:	01 d0                	add    %edx,%eax
  804717:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80471a:	83 ec 0c             	sub    $0xc,%esp
  80471d:	ff 75 e4             	pushl  -0x1c(%ebp)
  804720:	e8 16 ec ff ff       	call   80333b <get_block_size>
  804725:	83 c4 10             	add    $0x10,%esp
  804728:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80472b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80472e:	83 e8 08             	sub    $0x8,%eax
  804731:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804734:	8b 45 0c             	mov    0xc(%ebp),%eax
  804737:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80473a:	75 08                	jne    804744 <realloc_block_FF+0xc5>
	{
		 return va;
  80473c:	8b 45 08             	mov    0x8(%ebp),%eax
  80473f:	e9 54 06 00 00       	jmp    804d98 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804744:	8b 45 0c             	mov    0xc(%ebp),%eax
  804747:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80474a:	0f 83 e5 03 00 00    	jae    804b35 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804753:	2b 45 0c             	sub    0xc(%ebp),%eax
  804756:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804759:	83 ec 0c             	sub    $0xc,%esp
  80475c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80475f:	e8 f0 eb ff ff       	call   803354 <is_free_block>
  804764:	83 c4 10             	add    $0x10,%esp
  804767:	84 c0                	test   %al,%al
  804769:	0f 84 3b 01 00 00    	je     8048aa <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80476f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804772:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804775:	01 d0                	add    %edx,%eax
  804777:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80477a:	83 ec 04             	sub    $0x4,%esp
  80477d:	6a 01                	push   $0x1
  80477f:	ff 75 f0             	pushl  -0x10(%ebp)
  804782:	ff 75 08             	pushl  0x8(%ebp)
  804785:	e8 02 ef ff ff       	call   80368c <set_block_data>
  80478a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80478d:	8b 45 08             	mov    0x8(%ebp),%eax
  804790:	83 e8 04             	sub    $0x4,%eax
  804793:	8b 00                	mov    (%eax),%eax
  804795:	83 e0 fe             	and    $0xfffffffe,%eax
  804798:	89 c2                	mov    %eax,%edx
  80479a:	8b 45 08             	mov    0x8(%ebp),%eax
  80479d:	01 d0                	add    %edx,%eax
  80479f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8047a2:	83 ec 04             	sub    $0x4,%esp
  8047a5:	6a 00                	push   $0x0
  8047a7:	ff 75 cc             	pushl  -0x34(%ebp)
  8047aa:	ff 75 c8             	pushl  -0x38(%ebp)
  8047ad:	e8 da ee ff ff       	call   80368c <set_block_data>
  8047b2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8047b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8047b9:	74 06                	je     8047c1 <realloc_block_FF+0x142>
  8047bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8047bf:	75 17                	jne    8047d8 <realloc_block_FF+0x159>
  8047c1:	83 ec 04             	sub    $0x4,%esp
  8047c4:	68 18 6a 80 00       	push   $0x806a18
  8047c9:	68 f6 01 00 00       	push   $0x1f6
  8047ce:	68 a5 69 80 00       	push   $0x8069a5
  8047d3:	e8 1b d0 ff ff       	call   8017f3 <_panic>
  8047d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047db:	8b 10                	mov    (%eax),%edx
  8047dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047e0:	89 10                	mov    %edx,(%eax)
  8047e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047e5:	8b 00                	mov    (%eax),%eax
  8047e7:	85 c0                	test   %eax,%eax
  8047e9:	74 0b                	je     8047f6 <realloc_block_FF+0x177>
  8047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ee:	8b 00                	mov    (%eax),%eax
  8047f0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8047f3:	89 50 04             	mov    %edx,0x4(%eax)
  8047f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047f9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8047fc:	89 10                	mov    %edx,(%eax)
  8047fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804801:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804804:	89 50 04             	mov    %edx,0x4(%eax)
  804807:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80480a:	8b 00                	mov    (%eax),%eax
  80480c:	85 c0                	test   %eax,%eax
  80480e:	75 08                	jne    804818 <realloc_block_FF+0x199>
  804810:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804813:	a3 30 70 80 00       	mov    %eax,0x807030
  804818:	a1 38 70 80 00       	mov    0x807038,%eax
  80481d:	40                   	inc    %eax
  80481e:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804823:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804827:	75 17                	jne    804840 <realloc_block_FF+0x1c1>
  804829:	83 ec 04             	sub    $0x4,%esp
  80482c:	68 87 69 80 00       	push   $0x806987
  804831:	68 f7 01 00 00       	push   $0x1f7
  804836:	68 a5 69 80 00       	push   $0x8069a5
  80483b:	e8 b3 cf ff ff       	call   8017f3 <_panic>
  804840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804843:	8b 00                	mov    (%eax),%eax
  804845:	85 c0                	test   %eax,%eax
  804847:	74 10                	je     804859 <realloc_block_FF+0x1da>
  804849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80484c:	8b 00                	mov    (%eax),%eax
  80484e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804851:	8b 52 04             	mov    0x4(%edx),%edx
  804854:	89 50 04             	mov    %edx,0x4(%eax)
  804857:	eb 0b                	jmp    804864 <realloc_block_FF+0x1e5>
  804859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80485c:	8b 40 04             	mov    0x4(%eax),%eax
  80485f:	a3 30 70 80 00       	mov    %eax,0x807030
  804864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804867:	8b 40 04             	mov    0x4(%eax),%eax
  80486a:	85 c0                	test   %eax,%eax
  80486c:	74 0f                	je     80487d <realloc_block_FF+0x1fe>
  80486e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804871:	8b 40 04             	mov    0x4(%eax),%eax
  804874:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804877:	8b 12                	mov    (%edx),%edx
  804879:	89 10                	mov    %edx,(%eax)
  80487b:	eb 0a                	jmp    804887 <realloc_block_FF+0x208>
  80487d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804880:	8b 00                	mov    (%eax),%eax
  804882:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80488a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804893:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80489a:	a1 38 70 80 00       	mov    0x807038,%eax
  80489f:	48                   	dec    %eax
  8048a0:	a3 38 70 80 00       	mov    %eax,0x807038
  8048a5:	e9 83 02 00 00       	jmp    804b2d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8048aa:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8048ae:	0f 86 69 02 00 00    	jbe    804b1d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8048b4:	83 ec 04             	sub    $0x4,%esp
  8048b7:	6a 01                	push   $0x1
  8048b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8048bc:	ff 75 08             	pushl  0x8(%ebp)
  8048bf:	e8 c8 ed ff ff       	call   80368c <set_block_data>
  8048c4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8048c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8048ca:	83 e8 04             	sub    $0x4,%eax
  8048cd:	8b 00                	mov    (%eax),%eax
  8048cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8048d2:	89 c2                	mov    %eax,%edx
  8048d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8048d7:	01 d0                	add    %edx,%eax
  8048d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8048dc:	a1 38 70 80 00       	mov    0x807038,%eax
  8048e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8048e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8048e8:	75 68                	jne    804952 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8048ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8048ee:	75 17                	jne    804907 <realloc_block_FF+0x288>
  8048f0:	83 ec 04             	sub    $0x4,%esp
  8048f3:	68 c0 69 80 00       	push   $0x8069c0
  8048f8:	68 06 02 00 00       	push   $0x206
  8048fd:	68 a5 69 80 00       	push   $0x8069a5
  804902:	e8 ec ce ff ff       	call   8017f3 <_panic>
  804907:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80490d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804910:	89 10                	mov    %edx,(%eax)
  804912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804915:	8b 00                	mov    (%eax),%eax
  804917:	85 c0                	test   %eax,%eax
  804919:	74 0d                	je     804928 <realloc_block_FF+0x2a9>
  80491b:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804920:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804923:	89 50 04             	mov    %edx,0x4(%eax)
  804926:	eb 08                	jmp    804930 <realloc_block_FF+0x2b1>
  804928:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80492b:	a3 30 70 80 00       	mov    %eax,0x807030
  804930:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804933:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804938:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80493b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804942:	a1 38 70 80 00       	mov    0x807038,%eax
  804947:	40                   	inc    %eax
  804948:	a3 38 70 80 00       	mov    %eax,0x807038
  80494d:	e9 b0 01 00 00       	jmp    804b02 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804952:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804957:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80495a:	76 68                	jbe    8049c4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80495c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804960:	75 17                	jne    804979 <realloc_block_FF+0x2fa>
  804962:	83 ec 04             	sub    $0x4,%esp
  804965:	68 c0 69 80 00       	push   $0x8069c0
  80496a:	68 0b 02 00 00       	push   $0x20b
  80496f:	68 a5 69 80 00       	push   $0x8069a5
  804974:	e8 7a ce ff ff       	call   8017f3 <_panic>
  804979:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80497f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804982:	89 10                	mov    %edx,(%eax)
  804984:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804987:	8b 00                	mov    (%eax),%eax
  804989:	85 c0                	test   %eax,%eax
  80498b:	74 0d                	je     80499a <realloc_block_FF+0x31b>
  80498d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804992:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804995:	89 50 04             	mov    %edx,0x4(%eax)
  804998:	eb 08                	jmp    8049a2 <realloc_block_FF+0x323>
  80499a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80499d:	a3 30 70 80 00       	mov    %eax,0x807030
  8049a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a5:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8049aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049b4:	a1 38 70 80 00       	mov    0x807038,%eax
  8049b9:	40                   	inc    %eax
  8049ba:	a3 38 70 80 00       	mov    %eax,0x807038
  8049bf:	e9 3e 01 00 00       	jmp    804b02 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8049c4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049c9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8049cc:	73 68                	jae    804a36 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8049ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8049d2:	75 17                	jne    8049eb <realloc_block_FF+0x36c>
  8049d4:	83 ec 04             	sub    $0x4,%esp
  8049d7:	68 f4 69 80 00       	push   $0x8069f4
  8049dc:	68 10 02 00 00       	push   $0x210
  8049e1:	68 a5 69 80 00       	push   $0x8069a5
  8049e6:	e8 08 ce ff ff       	call   8017f3 <_panic>
  8049eb:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8049f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049f4:	89 50 04             	mov    %edx,0x4(%eax)
  8049f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049fa:	8b 40 04             	mov    0x4(%eax),%eax
  8049fd:	85 c0                	test   %eax,%eax
  8049ff:	74 0c                	je     804a0d <realloc_block_FF+0x38e>
  804a01:	a1 30 70 80 00       	mov    0x807030,%eax
  804a06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a09:	89 10                	mov    %edx,(%eax)
  804a0b:	eb 08                	jmp    804a15 <realloc_block_FF+0x396>
  804a0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a10:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a18:	a3 30 70 80 00       	mov    %eax,0x807030
  804a1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a26:	a1 38 70 80 00       	mov    0x807038,%eax
  804a2b:	40                   	inc    %eax
  804a2c:	a3 38 70 80 00       	mov    %eax,0x807038
  804a31:	e9 cc 00 00 00       	jmp    804b02 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804a36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804a3d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a45:	e9 8a 00 00 00       	jmp    804ad4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a4d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a50:	73 7a                	jae    804acc <realloc_block_FF+0x44d>
  804a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a55:	8b 00                	mov    (%eax),%eax
  804a57:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a5a:	73 70                	jae    804acc <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804a60:	74 06                	je     804a68 <realloc_block_FF+0x3e9>
  804a62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a66:	75 17                	jne    804a7f <realloc_block_FF+0x400>
  804a68:	83 ec 04             	sub    $0x4,%esp
  804a6b:	68 18 6a 80 00       	push   $0x806a18
  804a70:	68 1a 02 00 00       	push   $0x21a
  804a75:	68 a5 69 80 00       	push   $0x8069a5
  804a7a:	e8 74 cd ff ff       	call   8017f3 <_panic>
  804a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a82:	8b 10                	mov    (%eax),%edx
  804a84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a87:	89 10                	mov    %edx,(%eax)
  804a89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a8c:	8b 00                	mov    (%eax),%eax
  804a8e:	85 c0                	test   %eax,%eax
  804a90:	74 0b                	je     804a9d <realloc_block_FF+0x41e>
  804a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a95:	8b 00                	mov    (%eax),%eax
  804a97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a9a:	89 50 04             	mov    %edx,0x4(%eax)
  804a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aa0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804aa3:	89 10                	mov    %edx,(%eax)
  804aa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804aab:	89 50 04             	mov    %edx,0x4(%eax)
  804aae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ab1:	8b 00                	mov    (%eax),%eax
  804ab3:	85 c0                	test   %eax,%eax
  804ab5:	75 08                	jne    804abf <realloc_block_FF+0x440>
  804ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804aba:	a3 30 70 80 00       	mov    %eax,0x807030
  804abf:	a1 38 70 80 00       	mov    0x807038,%eax
  804ac4:	40                   	inc    %eax
  804ac5:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  804aca:	eb 36                	jmp    804b02 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804acc:	a1 34 70 80 00       	mov    0x807034,%eax
  804ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804ad8:	74 07                	je     804ae1 <realloc_block_FF+0x462>
  804ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804add:	8b 00                	mov    (%eax),%eax
  804adf:	eb 05                	jmp    804ae6 <realloc_block_FF+0x467>
  804ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  804ae6:	a3 34 70 80 00       	mov    %eax,0x807034
  804aeb:	a1 34 70 80 00       	mov    0x807034,%eax
  804af0:	85 c0                	test   %eax,%eax
  804af2:	0f 85 52 ff ff ff    	jne    804a4a <realloc_block_FF+0x3cb>
  804af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804afc:	0f 85 48 ff ff ff    	jne    804a4a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804b02:	83 ec 04             	sub    $0x4,%esp
  804b05:	6a 00                	push   $0x0
  804b07:	ff 75 d8             	pushl  -0x28(%ebp)
  804b0a:	ff 75 d4             	pushl  -0x2c(%ebp)
  804b0d:	e8 7a eb ff ff       	call   80368c <set_block_data>
  804b12:	83 c4 10             	add    $0x10,%esp
				return va;
  804b15:	8b 45 08             	mov    0x8(%ebp),%eax
  804b18:	e9 7b 02 00 00       	jmp    804d98 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804b1d:	83 ec 0c             	sub    $0xc,%esp
  804b20:	68 95 6a 80 00       	push   $0x806a95
  804b25:	e8 86 cf ff ff       	call   801ab0 <cprintf>
  804b2a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  804b30:	e9 63 02 00 00       	jmp    804d98 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b38:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804b3b:	0f 86 4d 02 00 00    	jbe    804d8e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804b41:	83 ec 0c             	sub    $0xc,%esp
  804b44:	ff 75 e4             	pushl  -0x1c(%ebp)
  804b47:	e8 08 e8 ff ff       	call   803354 <is_free_block>
  804b4c:	83 c4 10             	add    $0x10,%esp
  804b4f:	84 c0                	test   %al,%al
  804b51:	0f 84 37 02 00 00    	je     804d8e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b5a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804b5d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804b60:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804b63:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804b66:	76 38                	jbe    804ba0 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804b68:	83 ec 0c             	sub    $0xc,%esp
  804b6b:	ff 75 08             	pushl  0x8(%ebp)
  804b6e:	e8 0c fa ff ff       	call   80457f <free_block>
  804b73:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804b76:	83 ec 0c             	sub    $0xc,%esp
  804b79:	ff 75 0c             	pushl  0xc(%ebp)
  804b7c:	e8 3a eb ff ff       	call   8036bb <alloc_block_FF>
  804b81:	83 c4 10             	add    $0x10,%esp
  804b84:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804b87:	83 ec 08             	sub    $0x8,%esp
  804b8a:	ff 75 c0             	pushl  -0x40(%ebp)
  804b8d:	ff 75 08             	pushl  0x8(%ebp)
  804b90:	e8 ab fa ff ff       	call   804640 <copy_data>
  804b95:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804b98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804b9b:	e9 f8 01 00 00       	jmp    804d98 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ba3:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804ba6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804ba9:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804bad:	0f 87 a0 00 00 00    	ja     804c53 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804bb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804bb7:	75 17                	jne    804bd0 <realloc_block_FF+0x551>
  804bb9:	83 ec 04             	sub    $0x4,%esp
  804bbc:	68 87 69 80 00       	push   $0x806987
  804bc1:	68 38 02 00 00       	push   $0x238
  804bc6:	68 a5 69 80 00       	push   $0x8069a5
  804bcb:	e8 23 cc ff ff       	call   8017f3 <_panic>
  804bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bd3:	8b 00                	mov    (%eax),%eax
  804bd5:	85 c0                	test   %eax,%eax
  804bd7:	74 10                	je     804be9 <realloc_block_FF+0x56a>
  804bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bdc:	8b 00                	mov    (%eax),%eax
  804bde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804be1:	8b 52 04             	mov    0x4(%edx),%edx
  804be4:	89 50 04             	mov    %edx,0x4(%eax)
  804be7:	eb 0b                	jmp    804bf4 <realloc_block_FF+0x575>
  804be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bec:	8b 40 04             	mov    0x4(%eax),%eax
  804bef:	a3 30 70 80 00       	mov    %eax,0x807030
  804bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bf7:	8b 40 04             	mov    0x4(%eax),%eax
  804bfa:	85 c0                	test   %eax,%eax
  804bfc:	74 0f                	je     804c0d <realloc_block_FF+0x58e>
  804bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c01:	8b 40 04             	mov    0x4(%eax),%eax
  804c04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c07:	8b 12                	mov    (%edx),%edx
  804c09:	89 10                	mov    %edx,(%eax)
  804c0b:	eb 0a                	jmp    804c17 <realloc_block_FF+0x598>
  804c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c10:	8b 00                	mov    (%eax),%eax
  804c12:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c2a:	a1 38 70 80 00       	mov    0x807038,%eax
  804c2f:	48                   	dec    %eax
  804c30:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804c35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804c3b:	01 d0                	add    %edx,%eax
  804c3d:	83 ec 04             	sub    $0x4,%esp
  804c40:	6a 01                	push   $0x1
  804c42:	50                   	push   %eax
  804c43:	ff 75 08             	pushl  0x8(%ebp)
  804c46:	e8 41 ea ff ff       	call   80368c <set_block_data>
  804c4b:	83 c4 10             	add    $0x10,%esp
  804c4e:	e9 36 01 00 00       	jmp    804d89 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804c59:	01 d0                	add    %edx,%eax
  804c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804c5e:	83 ec 04             	sub    $0x4,%esp
  804c61:	6a 01                	push   $0x1
  804c63:	ff 75 f0             	pushl  -0x10(%ebp)
  804c66:	ff 75 08             	pushl  0x8(%ebp)
  804c69:	e8 1e ea ff ff       	call   80368c <set_block_data>
  804c6e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804c71:	8b 45 08             	mov    0x8(%ebp),%eax
  804c74:	83 e8 04             	sub    $0x4,%eax
  804c77:	8b 00                	mov    (%eax),%eax
  804c79:	83 e0 fe             	and    $0xfffffffe,%eax
  804c7c:	89 c2                	mov    %eax,%edx
  804c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  804c81:	01 d0                	add    %edx,%eax
  804c83:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804c86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c8a:	74 06                	je     804c92 <realloc_block_FF+0x613>
  804c8c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804c90:	75 17                	jne    804ca9 <realloc_block_FF+0x62a>
  804c92:	83 ec 04             	sub    $0x4,%esp
  804c95:	68 18 6a 80 00       	push   $0x806a18
  804c9a:	68 44 02 00 00       	push   $0x244
  804c9f:	68 a5 69 80 00       	push   $0x8069a5
  804ca4:	e8 4a cb ff ff       	call   8017f3 <_panic>
  804ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cac:	8b 10                	mov    (%eax),%edx
  804cae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cb1:	89 10                	mov    %edx,(%eax)
  804cb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cb6:	8b 00                	mov    (%eax),%eax
  804cb8:	85 c0                	test   %eax,%eax
  804cba:	74 0b                	je     804cc7 <realloc_block_FF+0x648>
  804cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cbf:	8b 00                	mov    (%eax),%eax
  804cc1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804cc4:	89 50 04             	mov    %edx,0x4(%eax)
  804cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cca:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804ccd:	89 10                	mov    %edx,(%eax)
  804ccf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804cd5:	89 50 04             	mov    %edx,0x4(%eax)
  804cd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cdb:	8b 00                	mov    (%eax),%eax
  804cdd:	85 c0                	test   %eax,%eax
  804cdf:	75 08                	jne    804ce9 <realloc_block_FF+0x66a>
  804ce1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804ce4:	a3 30 70 80 00       	mov    %eax,0x807030
  804ce9:	a1 38 70 80 00       	mov    0x807038,%eax
  804cee:	40                   	inc    %eax
  804cef:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804cf8:	75 17                	jne    804d11 <realloc_block_FF+0x692>
  804cfa:	83 ec 04             	sub    $0x4,%esp
  804cfd:	68 87 69 80 00       	push   $0x806987
  804d02:	68 45 02 00 00       	push   $0x245
  804d07:	68 a5 69 80 00       	push   $0x8069a5
  804d0c:	e8 e2 ca ff ff       	call   8017f3 <_panic>
  804d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d14:	8b 00                	mov    (%eax),%eax
  804d16:	85 c0                	test   %eax,%eax
  804d18:	74 10                	je     804d2a <realloc_block_FF+0x6ab>
  804d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d1d:	8b 00                	mov    (%eax),%eax
  804d1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d22:	8b 52 04             	mov    0x4(%edx),%edx
  804d25:	89 50 04             	mov    %edx,0x4(%eax)
  804d28:	eb 0b                	jmp    804d35 <realloc_block_FF+0x6b6>
  804d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d2d:	8b 40 04             	mov    0x4(%eax),%eax
  804d30:	a3 30 70 80 00       	mov    %eax,0x807030
  804d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d38:	8b 40 04             	mov    0x4(%eax),%eax
  804d3b:	85 c0                	test   %eax,%eax
  804d3d:	74 0f                	je     804d4e <realloc_block_FF+0x6cf>
  804d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d42:	8b 40 04             	mov    0x4(%eax),%eax
  804d45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d48:	8b 12                	mov    (%edx),%edx
  804d4a:	89 10                	mov    %edx,(%eax)
  804d4c:	eb 0a                	jmp    804d58 <realloc_block_FF+0x6d9>
  804d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d51:	8b 00                	mov    (%eax),%eax
  804d53:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d6b:	a1 38 70 80 00       	mov    0x807038,%eax
  804d70:	48                   	dec    %eax
  804d71:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804d76:	83 ec 04             	sub    $0x4,%esp
  804d79:	6a 00                	push   $0x0
  804d7b:	ff 75 bc             	pushl  -0x44(%ebp)
  804d7e:	ff 75 b8             	pushl  -0x48(%ebp)
  804d81:	e8 06 e9 ff ff       	call   80368c <set_block_data>
  804d86:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804d89:	8b 45 08             	mov    0x8(%ebp),%eax
  804d8c:	eb 0a                	jmp    804d98 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804d8e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804d95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804d98:	c9                   	leave  
  804d99:	c3                   	ret    

00804d9a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804d9a:	55                   	push   %ebp
  804d9b:	89 e5                	mov    %esp,%ebp
  804d9d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804da0:	83 ec 04             	sub    $0x4,%esp
  804da3:	68 9c 6a 80 00       	push   $0x806a9c
  804da8:	68 58 02 00 00       	push   $0x258
  804dad:	68 a5 69 80 00       	push   $0x8069a5
  804db2:	e8 3c ca ff ff       	call   8017f3 <_panic>

00804db7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804db7:	55                   	push   %ebp
  804db8:	89 e5                	mov    %esp,%ebp
  804dba:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804dbd:	83 ec 04             	sub    $0x4,%esp
  804dc0:	68 c4 6a 80 00       	push   $0x806ac4
  804dc5:	68 61 02 00 00       	push   $0x261
  804dca:	68 a5 69 80 00       	push   $0x8069a5
  804dcf:	e8 1f ca ff ff       	call   8017f3 <_panic>

00804dd4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804dd4:	55                   	push   %ebp
  804dd5:	89 e5                	mov    %esp,%ebp
  804dd7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804dda:	8b 55 08             	mov    0x8(%ebp),%edx
  804ddd:	89 d0                	mov    %edx,%eax
  804ddf:	c1 e0 02             	shl    $0x2,%eax
  804de2:	01 d0                	add    %edx,%eax
  804de4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804deb:	01 d0                	add    %edx,%eax
  804ded:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804df4:	01 d0                	add    %edx,%eax
  804df6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804dfd:	01 d0                	add    %edx,%eax
  804dff:	c1 e0 04             	shl    $0x4,%eax
  804e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804e05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804e0c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804e0f:	83 ec 0c             	sub    $0xc,%esp
  804e12:	50                   	push   %eax
  804e13:	e8 2f e2 ff ff       	call   803047 <sys_get_virtual_time>
  804e18:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804e1b:	eb 41                	jmp    804e5e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804e1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804e20:	83 ec 0c             	sub    $0xc,%esp
  804e23:	50                   	push   %eax
  804e24:	e8 1e e2 ff ff       	call   803047 <sys_get_virtual_time>
  804e29:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804e2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e32:	29 c2                	sub    %eax,%edx
  804e34:	89 d0                	mov    %edx,%eax
  804e36:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804e39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804e3f:	89 d1                	mov    %edx,%ecx
  804e41:	29 c1                	sub    %eax,%ecx
  804e43:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804e49:	39 c2                	cmp    %eax,%edx
  804e4b:	0f 97 c0             	seta   %al
  804e4e:	0f b6 c0             	movzbl %al,%eax
  804e51:	29 c1                	sub    %eax,%ecx
  804e53:	89 c8                	mov    %ecx,%eax
  804e55:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804e58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804e64:	72 b7                	jb     804e1d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804e66:	90                   	nop
  804e67:	c9                   	leave  
  804e68:	c3                   	ret    

00804e69 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804e69:	55                   	push   %ebp
  804e6a:	89 e5                	mov    %esp,%ebp
  804e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804e6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804e76:	eb 03                	jmp    804e7b <busy_wait+0x12>
  804e78:	ff 45 fc             	incl   -0x4(%ebp)
  804e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804e7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  804e81:	72 f5                	jb     804e78 <busy_wait+0xf>
	return i;
  804e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804e86:	c9                   	leave  
  804e87:	c3                   	ret    

00804e88 <__udivdi3>:
  804e88:	55                   	push   %ebp
  804e89:	57                   	push   %edi
  804e8a:	56                   	push   %esi
  804e8b:	53                   	push   %ebx
  804e8c:	83 ec 1c             	sub    $0x1c,%esp
  804e8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804e93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804e97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804e9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804e9f:	89 ca                	mov    %ecx,%edx
  804ea1:	89 f8                	mov    %edi,%eax
  804ea3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804ea7:	85 f6                	test   %esi,%esi
  804ea9:	75 2d                	jne    804ed8 <__udivdi3+0x50>
  804eab:	39 cf                	cmp    %ecx,%edi
  804ead:	77 65                	ja     804f14 <__udivdi3+0x8c>
  804eaf:	89 fd                	mov    %edi,%ebp
  804eb1:	85 ff                	test   %edi,%edi
  804eb3:	75 0b                	jne    804ec0 <__udivdi3+0x38>
  804eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  804eba:	31 d2                	xor    %edx,%edx
  804ebc:	f7 f7                	div    %edi
  804ebe:	89 c5                	mov    %eax,%ebp
  804ec0:	31 d2                	xor    %edx,%edx
  804ec2:	89 c8                	mov    %ecx,%eax
  804ec4:	f7 f5                	div    %ebp
  804ec6:	89 c1                	mov    %eax,%ecx
  804ec8:	89 d8                	mov    %ebx,%eax
  804eca:	f7 f5                	div    %ebp
  804ecc:	89 cf                	mov    %ecx,%edi
  804ece:	89 fa                	mov    %edi,%edx
  804ed0:	83 c4 1c             	add    $0x1c,%esp
  804ed3:	5b                   	pop    %ebx
  804ed4:	5e                   	pop    %esi
  804ed5:	5f                   	pop    %edi
  804ed6:	5d                   	pop    %ebp
  804ed7:	c3                   	ret    
  804ed8:	39 ce                	cmp    %ecx,%esi
  804eda:	77 28                	ja     804f04 <__udivdi3+0x7c>
  804edc:	0f bd fe             	bsr    %esi,%edi
  804edf:	83 f7 1f             	xor    $0x1f,%edi
  804ee2:	75 40                	jne    804f24 <__udivdi3+0x9c>
  804ee4:	39 ce                	cmp    %ecx,%esi
  804ee6:	72 0a                	jb     804ef2 <__udivdi3+0x6a>
  804ee8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804eec:	0f 87 9e 00 00 00    	ja     804f90 <__udivdi3+0x108>
  804ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  804ef7:	89 fa                	mov    %edi,%edx
  804ef9:	83 c4 1c             	add    $0x1c,%esp
  804efc:	5b                   	pop    %ebx
  804efd:	5e                   	pop    %esi
  804efe:	5f                   	pop    %edi
  804eff:	5d                   	pop    %ebp
  804f00:	c3                   	ret    
  804f01:	8d 76 00             	lea    0x0(%esi),%esi
  804f04:	31 ff                	xor    %edi,%edi
  804f06:	31 c0                	xor    %eax,%eax
  804f08:	89 fa                	mov    %edi,%edx
  804f0a:	83 c4 1c             	add    $0x1c,%esp
  804f0d:	5b                   	pop    %ebx
  804f0e:	5e                   	pop    %esi
  804f0f:	5f                   	pop    %edi
  804f10:	5d                   	pop    %ebp
  804f11:	c3                   	ret    
  804f12:	66 90                	xchg   %ax,%ax
  804f14:	89 d8                	mov    %ebx,%eax
  804f16:	f7 f7                	div    %edi
  804f18:	31 ff                	xor    %edi,%edi
  804f1a:	89 fa                	mov    %edi,%edx
  804f1c:	83 c4 1c             	add    $0x1c,%esp
  804f1f:	5b                   	pop    %ebx
  804f20:	5e                   	pop    %esi
  804f21:	5f                   	pop    %edi
  804f22:	5d                   	pop    %ebp
  804f23:	c3                   	ret    
  804f24:	bd 20 00 00 00       	mov    $0x20,%ebp
  804f29:	89 eb                	mov    %ebp,%ebx
  804f2b:	29 fb                	sub    %edi,%ebx
  804f2d:	89 f9                	mov    %edi,%ecx
  804f2f:	d3 e6                	shl    %cl,%esi
  804f31:	89 c5                	mov    %eax,%ebp
  804f33:	88 d9                	mov    %bl,%cl
  804f35:	d3 ed                	shr    %cl,%ebp
  804f37:	89 e9                	mov    %ebp,%ecx
  804f39:	09 f1                	or     %esi,%ecx
  804f3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804f3f:	89 f9                	mov    %edi,%ecx
  804f41:	d3 e0                	shl    %cl,%eax
  804f43:	89 c5                	mov    %eax,%ebp
  804f45:	89 d6                	mov    %edx,%esi
  804f47:	88 d9                	mov    %bl,%cl
  804f49:	d3 ee                	shr    %cl,%esi
  804f4b:	89 f9                	mov    %edi,%ecx
  804f4d:	d3 e2                	shl    %cl,%edx
  804f4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804f53:	88 d9                	mov    %bl,%cl
  804f55:	d3 e8                	shr    %cl,%eax
  804f57:	09 c2                	or     %eax,%edx
  804f59:	89 d0                	mov    %edx,%eax
  804f5b:	89 f2                	mov    %esi,%edx
  804f5d:	f7 74 24 0c          	divl   0xc(%esp)
  804f61:	89 d6                	mov    %edx,%esi
  804f63:	89 c3                	mov    %eax,%ebx
  804f65:	f7 e5                	mul    %ebp
  804f67:	39 d6                	cmp    %edx,%esi
  804f69:	72 19                	jb     804f84 <__udivdi3+0xfc>
  804f6b:	74 0b                	je     804f78 <__udivdi3+0xf0>
  804f6d:	89 d8                	mov    %ebx,%eax
  804f6f:	31 ff                	xor    %edi,%edi
  804f71:	e9 58 ff ff ff       	jmp    804ece <__udivdi3+0x46>
  804f76:	66 90                	xchg   %ax,%ax
  804f78:	8b 54 24 08          	mov    0x8(%esp),%edx
  804f7c:	89 f9                	mov    %edi,%ecx
  804f7e:	d3 e2                	shl    %cl,%edx
  804f80:	39 c2                	cmp    %eax,%edx
  804f82:	73 e9                	jae    804f6d <__udivdi3+0xe5>
  804f84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804f87:	31 ff                	xor    %edi,%edi
  804f89:	e9 40 ff ff ff       	jmp    804ece <__udivdi3+0x46>
  804f8e:	66 90                	xchg   %ax,%ax
  804f90:	31 c0                	xor    %eax,%eax
  804f92:	e9 37 ff ff ff       	jmp    804ece <__udivdi3+0x46>
  804f97:	90                   	nop

00804f98 <__umoddi3>:
  804f98:	55                   	push   %ebp
  804f99:	57                   	push   %edi
  804f9a:	56                   	push   %esi
  804f9b:	53                   	push   %ebx
  804f9c:	83 ec 1c             	sub    $0x1c,%esp
  804f9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804fa3:	8b 74 24 34          	mov    0x34(%esp),%esi
  804fa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804fab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804faf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804fb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804fb7:	89 f3                	mov    %esi,%ebx
  804fb9:	89 fa                	mov    %edi,%edx
  804fbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804fbf:	89 34 24             	mov    %esi,(%esp)
  804fc2:	85 c0                	test   %eax,%eax
  804fc4:	75 1a                	jne    804fe0 <__umoddi3+0x48>
  804fc6:	39 f7                	cmp    %esi,%edi
  804fc8:	0f 86 a2 00 00 00    	jbe    805070 <__umoddi3+0xd8>
  804fce:	89 c8                	mov    %ecx,%eax
  804fd0:	89 f2                	mov    %esi,%edx
  804fd2:	f7 f7                	div    %edi
  804fd4:	89 d0                	mov    %edx,%eax
  804fd6:	31 d2                	xor    %edx,%edx
  804fd8:	83 c4 1c             	add    $0x1c,%esp
  804fdb:	5b                   	pop    %ebx
  804fdc:	5e                   	pop    %esi
  804fdd:	5f                   	pop    %edi
  804fde:	5d                   	pop    %ebp
  804fdf:	c3                   	ret    
  804fe0:	39 f0                	cmp    %esi,%eax
  804fe2:	0f 87 ac 00 00 00    	ja     805094 <__umoddi3+0xfc>
  804fe8:	0f bd e8             	bsr    %eax,%ebp
  804feb:	83 f5 1f             	xor    $0x1f,%ebp
  804fee:	0f 84 ac 00 00 00    	je     8050a0 <__umoddi3+0x108>
  804ff4:	bf 20 00 00 00       	mov    $0x20,%edi
  804ff9:	29 ef                	sub    %ebp,%edi
  804ffb:	89 fe                	mov    %edi,%esi
  804ffd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805001:	89 e9                	mov    %ebp,%ecx
  805003:	d3 e0                	shl    %cl,%eax
  805005:	89 d7                	mov    %edx,%edi
  805007:	89 f1                	mov    %esi,%ecx
  805009:	d3 ef                	shr    %cl,%edi
  80500b:	09 c7                	or     %eax,%edi
  80500d:	89 e9                	mov    %ebp,%ecx
  80500f:	d3 e2                	shl    %cl,%edx
  805011:	89 14 24             	mov    %edx,(%esp)
  805014:	89 d8                	mov    %ebx,%eax
  805016:	d3 e0                	shl    %cl,%eax
  805018:	89 c2                	mov    %eax,%edx
  80501a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80501e:	d3 e0                	shl    %cl,%eax
  805020:	89 44 24 04          	mov    %eax,0x4(%esp)
  805024:	8b 44 24 08          	mov    0x8(%esp),%eax
  805028:	89 f1                	mov    %esi,%ecx
  80502a:	d3 e8                	shr    %cl,%eax
  80502c:	09 d0                	or     %edx,%eax
  80502e:	d3 eb                	shr    %cl,%ebx
  805030:	89 da                	mov    %ebx,%edx
  805032:	f7 f7                	div    %edi
  805034:	89 d3                	mov    %edx,%ebx
  805036:	f7 24 24             	mull   (%esp)
  805039:	89 c6                	mov    %eax,%esi
  80503b:	89 d1                	mov    %edx,%ecx
  80503d:	39 d3                	cmp    %edx,%ebx
  80503f:	0f 82 87 00 00 00    	jb     8050cc <__umoddi3+0x134>
  805045:	0f 84 91 00 00 00    	je     8050dc <__umoddi3+0x144>
  80504b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80504f:	29 f2                	sub    %esi,%edx
  805051:	19 cb                	sbb    %ecx,%ebx
  805053:	89 d8                	mov    %ebx,%eax
  805055:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805059:	d3 e0                	shl    %cl,%eax
  80505b:	89 e9                	mov    %ebp,%ecx
  80505d:	d3 ea                	shr    %cl,%edx
  80505f:	09 d0                	or     %edx,%eax
  805061:	89 e9                	mov    %ebp,%ecx
  805063:	d3 eb                	shr    %cl,%ebx
  805065:	89 da                	mov    %ebx,%edx
  805067:	83 c4 1c             	add    $0x1c,%esp
  80506a:	5b                   	pop    %ebx
  80506b:	5e                   	pop    %esi
  80506c:	5f                   	pop    %edi
  80506d:	5d                   	pop    %ebp
  80506e:	c3                   	ret    
  80506f:	90                   	nop
  805070:	89 fd                	mov    %edi,%ebp
  805072:	85 ff                	test   %edi,%edi
  805074:	75 0b                	jne    805081 <__umoddi3+0xe9>
  805076:	b8 01 00 00 00       	mov    $0x1,%eax
  80507b:	31 d2                	xor    %edx,%edx
  80507d:	f7 f7                	div    %edi
  80507f:	89 c5                	mov    %eax,%ebp
  805081:	89 f0                	mov    %esi,%eax
  805083:	31 d2                	xor    %edx,%edx
  805085:	f7 f5                	div    %ebp
  805087:	89 c8                	mov    %ecx,%eax
  805089:	f7 f5                	div    %ebp
  80508b:	89 d0                	mov    %edx,%eax
  80508d:	e9 44 ff ff ff       	jmp    804fd6 <__umoddi3+0x3e>
  805092:	66 90                	xchg   %ax,%ax
  805094:	89 c8                	mov    %ecx,%eax
  805096:	89 f2                	mov    %esi,%edx
  805098:	83 c4 1c             	add    $0x1c,%esp
  80509b:	5b                   	pop    %ebx
  80509c:	5e                   	pop    %esi
  80509d:	5f                   	pop    %edi
  80509e:	5d                   	pop    %ebp
  80509f:	c3                   	ret    
  8050a0:	3b 04 24             	cmp    (%esp),%eax
  8050a3:	72 06                	jb     8050ab <__umoddi3+0x113>
  8050a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8050a9:	77 0f                	ja     8050ba <__umoddi3+0x122>
  8050ab:	89 f2                	mov    %esi,%edx
  8050ad:	29 f9                	sub    %edi,%ecx
  8050af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8050b3:	89 14 24             	mov    %edx,(%esp)
  8050b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8050ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8050be:	8b 14 24             	mov    (%esp),%edx
  8050c1:	83 c4 1c             	add    $0x1c,%esp
  8050c4:	5b                   	pop    %ebx
  8050c5:	5e                   	pop    %esi
  8050c6:	5f                   	pop    %edi
  8050c7:	5d                   	pop    %ebp
  8050c8:	c3                   	ret    
  8050c9:	8d 76 00             	lea    0x0(%esi),%esi
  8050cc:	2b 04 24             	sub    (%esp),%eax
  8050cf:	19 fa                	sbb    %edi,%edx
  8050d1:	89 d1                	mov    %edx,%ecx
  8050d3:	89 c6                	mov    %eax,%esi
  8050d5:	e9 71 ff ff ff       	jmp    80504b <__umoddi3+0xb3>
  8050da:	66 90                	xchg   %ax,%ax
  8050dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8050e0:	72 ea                	jb     8050cc <__umoddi3+0x134>
  8050e2:	89 d9                	mov    %ebx,%ecx
  8050e4:	e9 62 ff ff ff       	jmp    80504b <__umoddi3+0xb3>
