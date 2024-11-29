
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
  800081:	68 80 51 80 00       	push   $0x805180
  800086:	6a 1e                	push   $0x1e
  800088:	68 9c 51 80 00       	push   $0x80519c
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
  8000d7:	e8 d3 2d 00 00       	call   802eaf <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 b0 51 80 00       	push   $0x8051b0
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
  800103:	e8 a7 2d 00 00       	call   802eaf <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 ea 2d 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  800142:	68 0c 52 80 00       	push   $0x80520c
  800147:	e8 64 19 00 00       	call   801ab0 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 51 2d 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800195:	68 40 52 80 00       	push   $0x805240
  80019a:	e8 11 19 00 00       	call   801ab0 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 53 2d 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 b0 52 80 00       	push   $0x8052b0
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 e7 2c 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8001ff:	e8 ab 2c 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800237:	68 e4 52 80 00       	push   $0x8052e4
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
  80027e:	e8 87 30 00 00       	call   80330a <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 64 53 80 00       	push   $0x805364
  80029e:	e8 0d 18 00 00       	call   801ab0 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 04 2c 00 00       	call   802eaf <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 47 2c 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  8002f2:	68 88 53 80 00       	push   $0x805388
  8002f7:	e8 b4 17 00 00       	call   801ab0 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 a1 2b 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800345:	68 bc 53 80 00       	push   $0x8053bc
  80034a:	e8 61 17 00 00       	call   801ab0 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 a3 2b 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 2c 54 80 00       	push   $0x80542c
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 37 2b 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8003b8:	e8 f2 2a 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8003f0:	68 60 54 80 00       	push   $0x805460
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
  80043b:	e8 ca 2e 00 00       	call   80330a <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 e0 54 80 00       	push   $0x8054e0
  80045b:	e8 50 16 00 00       	call   801ab0 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 92 2a 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  8004a9:	68 04 55 80 00       	push   $0x805504
  8004ae:	e8 fd 15 00 00       	call   801ab0 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 ea 29 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8004fc:	68 38 55 80 00       	push   $0x805538
  800501:	e8 aa 15 00 00       	call   801ab0 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 ec 29 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 a8 55 80 00       	push   $0x8055a8
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 80 29 00 00       	call   802eaf <sys_calculate_free_frames>
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
  80056d:	e8 3d 29 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8005a5:	68 dc 55 80 00       	push   $0x8055dc
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
  8005f3:	e8 12 2d 00 00       	call   80330a <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 5c 56 80 00       	push   $0x80565c
  800613:	e8 98 14 00 00       	call   801ab0 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 da 28 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  800669:	68 80 56 80 00       	push   $0x805680
  80066e:	e8 3d 14 00 00       	call   801ab0 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 7f 28 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 b4 56 80 00       	push   $0x8056b4
  80068f:	e8 1c 14 00 00       	call   801ab0 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 13 28 00 00       	call   802eaf <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 56 28 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  8006f1:	68 e8 56 80 00       	push   $0x8056e8
  8006f6:	e8 b5 13 00 00       	call   801ab0 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 a2 27 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800744:	68 1c 57 80 00       	push   $0x80571c
  800749:	e8 62 13 00 00       	call   801ab0 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 a4 27 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 8c 57 80 00       	push   $0x80578c
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 38 27 00 00       	call   802eaf <sys_calculate_free_frames>
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
  8007fc:	e8 ae 26 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800834:	68 c0 57 80 00       	push   $0x8057c0
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
  800888:	e8 7d 2a 00 00       	call   80330a <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 40 58 80 00       	push   $0x805840
  8008a8:	e8 03 12 00 00       	call   801ab0 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 fa 25 00 00       	call   802eaf <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 3d 26 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  800909:	68 64 58 80 00       	push   $0x805864
  80090e:	e8 9d 11 00 00       	call   801ab0 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 8a 25 00 00       	call   802eaf <sys_calculate_free_frames>
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
  80095c:	68 98 58 80 00       	push   $0x805898
  800961:	e8 4a 11 00 00       	call   801ab0 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 8c 25 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 08 59 80 00       	push   $0x805908
  800982:	e8 29 11 00 00       	call   801ab0 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 20 25 00 00       	call   802eaf <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 63 25 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 3c 59 80 00       	push   $0x80593c
  8009f1:	e8 ba 10 00 00       	call   801ab0 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 a7 24 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800a3f:	68 70 59 80 00       	push   $0x805970
  800a44:	e8 67 10 00 00       	call   801ab0 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 a9 24 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 e0 59 80 00       	push   $0x8059e0
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 3d 24 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800ae5:	e8 c5 23 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800b1d:	68 14 5a 80 00       	push   $0x805a14
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
  800ba9:	e8 5c 27 00 00       	call   80330a <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 94 5a 80 00       	push   $0x805a94
  800bc9:	e8 e2 0e 00 00       	call   801ab0 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 d9 22 00 00       	call   802eaf <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 1c 23 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
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
  800c35:	68 b8 5a 80 00       	push   $0x805ab8
  800c3a:	e8 71 0e 00 00       	call   801ab0 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 5e 22 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800c88:	68 ec 5a 80 00       	push   $0x805aec
  800c8d:	e8 1e 0e 00 00       	call   801ab0 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 60 22 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 5c 5b 80 00       	push   $0x805b5c
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 f4 21 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800d3f:	e8 6b 21 00 00       	call   802eaf <sys_calculate_free_frames>
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
  800d77:	68 90 5b 80 00       	push   $0x805b90
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
  800e09:	e8 fc 24 00 00       	call   80330a <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 10 5c 80 00       	push   $0x805c10
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
  800e5e:	68 34 5c 80 00       	push   $0x805c34
  800e63:	e8 48 0c 00 00       	call   801ab0 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 3f 20 00 00       	call   802eaf <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 82 20 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 68 20 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 74 5c 80 00       	push   $0x805c74
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 fc 1f 00 00       	call   802eaf <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 b4 5c 80 00       	push   $0x805cb4
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
  800f1e:	e8 e7 23 00 00       	call   80330a <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 04 5d 80 00       	push   $0x805d04
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
  800f5d:	e8 4d 1f 00 00       	call   802eaf <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 90 1f 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 76 1f 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 2c 5d 80 00       	push   $0x805d2c
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 0a 1f 00 00       	call   802eaf <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 6c 5d 80 00       	push   $0x805d6c
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
  801014:	e8 f1 22 00 00       	call   80330a <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 bc 5d 80 00       	push   $0x805dbc
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
  801053:	e8 57 1e 00 00       	call   802eaf <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 9a 1e 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 80 1e 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 e4 5d 80 00       	push   $0x805de4
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 14 1e 00 00       	call   802eaf <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 24 5e 80 00       	push   $0x805e24
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
  80113f:	e8 c6 21 00 00       	call   80330a <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 74 5e 80 00       	push   $0x805e74
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
  80117e:	e8 2c 1d 00 00       	call   802eaf <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 6f 1d 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 55 1d 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 9c 5e 80 00       	push   $0x805e9c
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 e9 1c 00 00       	call   802eaf <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 dc 5e 80 00       	push   $0x805edc
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
  801238:	e8 cd 20 00 00       	call   80330a <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 2c 5f 80 00       	push   $0x805f2c
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
  801277:	e8 33 1c 00 00       	call   802eaf <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 76 1c 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 5c 1c 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 54 5f 80 00       	push   $0x805f54
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 f0 1b 00 00       	call   802eaf <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 94 5f 80 00       	push   $0x805f94
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
  8012f0:	e8 ba 1b 00 00       	call   802eaf <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 fd 1b 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 e3 1b 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 d8 5f 80 00       	push   $0x805fd8
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 77 1b 00 00       	call   802eaf <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 18 60 80 00       	push   $0x806018
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
  8013aa:	e8 5b 1f 00 00       	call   80330a <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 68 60 80 00       	push   $0x806068
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
  8013e9:	e8 c1 1a 00 00       	call   802eaf <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 04 1b 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 ea 1a 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 90 60 80 00       	push   $0x806090
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 7e 1a 00 00       	call   802eaf <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 d0 60 80 00       	push   $0x8060d0
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
  801462:	e8 48 1a 00 00       	call   802eaf <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 8b 1a 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 71 1a 00 00       	call   802efa <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 20 61 80 00       	push   $0x806120
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 05 1a 00 00       	call   802eaf <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 60 61 80 00       	push   $0x806160
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
  801554:	e8 b1 1d 00 00       	call   80330a <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 b0 61 80 00       	push   $0x8061b0
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
  80159d:	68 d8 61 80 00       	push   $0x8061d8
  8015a2:	e8 09 05 00 00       	call   801ab0 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 a7 1b 00 00       	call   803156 <rsttst>
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
  8015d5:	68 46 62 80 00       	push   $0x806246
  8015da:	e8 2b 1a 00 00       	call   80300a <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 32 1a 00 00       	call   803028 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 d1 1b 00 00       	call   8031d0 <gettst>
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
  80162a:	68 51 62 80 00       	push   $0x806251
  80162f:	e8 d6 19 00 00       	call   80300a <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 dd 19 00 00       	call   803028 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 7c 1b 00 00       	call   8031d0 <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 58 1b 00 00       	call   8031b6 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 e6 37 00 00       	call   804e51 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 5d 1b 00 00       	call   8031d0 <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 5c 62 80 00       	push   $0x80625c
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
  80169f:	68 ec 62 80 00       	push   $0x8062ec
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
  8016ba:	e8 b9 19 00 00       	call   803078 <sys_getenvindex>
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
  801728:	e8 cf 16 00 00       	call   802dfc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	68 40 63 80 00       	push   $0x806340
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
  801758:	68 68 63 80 00       	push   $0x806368
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
  801789:	68 90 63 80 00       	push   $0x806390
  80178e:	e8 1d 03 00 00       	call   801ab0 <cprintf>
  801793:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801796:	a1 20 70 80 00       	mov    0x807020,%eax
  80179b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 e8 63 80 00       	push   $0x8063e8
  8017aa:	e8 01 03 00 00       	call   801ab0 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 40 63 80 00       	push   $0x806340
  8017ba:	e8 f1 02 00 00       	call   801ab0 <cprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017c2:	e8 4f 16 00 00       	call   802e16 <sys_unlock_cons>
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
  8017da:	e8 65 18 00 00       	call   803044 <sys_destroy_env>
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
  8017eb:	e8 ba 18 00 00       	call   8030aa <sys_exit_env>
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
  801814:	68 fc 63 80 00       	push   $0x8063fc
  801819:	e8 92 02 00 00       	call   801ab0 <cprintf>
  80181e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801821:	a1 00 70 80 00       	mov    0x807000,%eax
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	68 01 64 80 00       	push   $0x806401
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
  801851:	68 1d 64 80 00       	push   $0x80641d
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
  801880:	68 20 64 80 00       	push   $0x806420
  801885:	6a 26                	push   $0x26
  801887:	68 6c 64 80 00       	push   $0x80646c
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
  801955:	68 78 64 80 00       	push   $0x806478
  80195a:	6a 3a                	push   $0x3a
  80195c:	68 6c 64 80 00       	push   $0x80646c
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
  8019c8:	68 cc 64 80 00       	push   $0x8064cc
  8019cd:	6a 44                	push   $0x44
  8019cf:	68 6c 64 80 00       	push   $0x80646c
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
  801a22:	e8 93 13 00 00       	call   802dba <sys_cputs>
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
  801a99:	e8 1c 13 00 00       	call   802dba <sys_cputs>
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
  801ae3:	e8 14 13 00 00       	call   802dfc <sys_lock_cons>
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
  801b03:	e8 0e 13 00 00       	call   802e16 <sys_unlock_cons>
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
  801b4d:	e8 b6 33 00 00       	call   804f08 <__udivdi3>
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
  801b9d:	e8 76 34 00 00       	call   805018 <__umoddi3>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	05 34 67 80 00       	add    $0x806734,%eax
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
  801cf8:	8b 04 85 58 67 80 00 	mov    0x806758(,%eax,4),%eax
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
  801dd9:	8b 34 9d a0 65 80 00 	mov    0x8065a0(,%ebx,4),%esi
  801de0:	85 f6                	test   %esi,%esi
  801de2:	75 19                	jne    801dfd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de4:	53                   	push   %ebx
  801de5:	68 45 67 80 00       	push   $0x806745
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
  801dfe:	68 4e 67 80 00       	push   $0x80674e
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
  801e2b:	be 51 67 80 00       	mov    $0x806751,%esi
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
  802836:	68 c8 68 80 00       	push   $0x8068c8
  80283b:	68 3f 01 00 00       	push   $0x13f
  802840:	68 ea 68 80 00       	push   $0x8068ea
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
  802856:	e8 0a 0b 00 00       	call   803365 <sys_sbrk>
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
  8028d1:	e8 13 09 00 00       	call   8031e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 53 0e 00 00       	call   803738 <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 25 09 00 00       	call   80321a <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 ec 12 00 00       	call   803bf4 <alloc_block_BF>
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
  802a69:	e8 2e 09 00 00       	call   80339c <sys_allocate_user_mem>
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
  802ab1:	e8 02 09 00 00       	call   8033b8 <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 35 1b 00 00       	call   8045fc <free_block>
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
  802b59:	e8 22 08 00 00       	call   803380 <sys_free_user_mem>
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
  802b67:	68 f8 68 80 00       	push   $0x8068f8
  802b6c:	68 85 00 00 00       	push   $0x85
  802b71:	68 22 69 80 00       	push   $0x806922
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
  802bdc:	e8 a6 03 00 00       	call   802f87 <sys_createSharedObject>
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
  802c00:	68 2e 69 80 00       	push   $0x80692e
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
  802c44:	e8 68 03 00 00       	call   802fb1 <sys_getSizeOfSharedObject>
  802c49:	83 c4 10             	add    $0x10,%esp
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802c4f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802c53:	75 07                	jne    802c5c <sget+0x27>
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5a:	eb 7f                	jmp    802cdb <sget+0xa6>
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
  802c8f:	eb 4a                	jmp    802cdb <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	ff 75 e8             	pushl  -0x18(%ebp)
  802c97:	ff 75 0c             	pushl  0xc(%ebp)
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	e8 2c 03 00 00       	call   802fce <sys_getSharedObject>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802ca8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cab:	a1 20 70 80 00       	mov    0x807020,%eax
  802cb0:	8b 40 78             	mov    0x78(%eax),%eax
  802cb3:	29 c2                	sub    %eax,%edx
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  802cbc:	c1 e8 0c             	shr    $0xc,%eax
  802cbf:	89 c2                	mov    %eax,%edx
  802cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc4:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802ccb:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802ccf:	75 07                	jne    802cd8 <sget+0xa3>
  802cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd6:	eb 03                	jmp    802cdb <sget+0xa6>
	return ptr;
  802cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce6:	a1 20 70 80 00       	mov    0x807020,%eax
  802ceb:	8b 40 78             	mov    0x78(%eax),%eax
  802cee:	29 c2                	sub    %eax,%edx
  802cf0:	89 d0                	mov    %edx,%eax
  802cf2:	2d 00 10 00 00       	sub    $0x1000,%eax
  802cf7:	c1 e8 0c             	shr    $0xc,%eax
  802cfa:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
  802d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802d04:	83 ec 08             	sub    $0x8,%esp
  802d07:	ff 75 08             	pushl  0x8(%ebp)
  802d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  802d0d:	e8 db 02 00 00       	call   802fed <sys_freeSharedObject>
  802d12:	83 c4 10             	add    $0x10,%esp
  802d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802d18:	90                   	nop
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
  802d1e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 40 69 80 00       	push   $0x806940
  802d29:	68 de 00 00 00       	push   $0xde
  802d2e:	68 22 69 80 00       	push   $0x806922
  802d33:	e8 bb ea ff ff       	call   8017f3 <_panic>

00802d38 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802d38:	55                   	push   %ebp
  802d39:	89 e5                	mov    %esp,%ebp
  802d3b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 66 69 80 00       	push   $0x806966
  802d46:	68 ea 00 00 00       	push   $0xea
  802d4b:	68 22 69 80 00       	push   $0x806922
  802d50:	e8 9e ea ff ff       	call   8017f3 <_panic>

00802d55 <shrink>:

}
void shrink(uint32 newSize)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
  802d58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 66 69 80 00       	push   $0x806966
  802d63:	68 ef 00 00 00       	push   $0xef
  802d68:	68 22 69 80 00       	push   $0x806922
  802d6d:	e8 81 ea ff ff       	call   8017f3 <_panic>

00802d72 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802d72:	55                   	push   %ebp
  802d73:	89 e5                	mov    %esp,%ebp
  802d75:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 66 69 80 00       	push   $0x806966
  802d80:	68 f4 00 00 00       	push   $0xf4
  802d85:	68 22 69 80 00       	push   $0x806922
  802d8a:	e8 64 ea ff ff       	call   8017f3 <_panic>

00802d8f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d8f:	55                   	push   %ebp
  802d90:	89 e5                	mov    %esp,%ebp
  802d92:	57                   	push   %edi
  802d93:	56                   	push   %esi
  802d94:	53                   	push   %ebx
  802d95:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802da1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802da4:	8b 7d 18             	mov    0x18(%ebp),%edi
  802da7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802daa:	cd 30                	int    $0x30
  802dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802db2:	83 c4 10             	add    $0x10,%esp
  802db5:	5b                   	pop    %ebx
  802db6:	5e                   	pop    %esi
  802db7:	5f                   	pop    %edi
  802db8:	5d                   	pop    %ebp
  802db9:	c3                   	ret    

00802dba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  802dc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802dc6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	6a 00                	push   $0x0
  802dcf:	6a 00                	push   $0x0
  802dd1:	52                   	push   %edx
  802dd2:	ff 75 0c             	pushl  0xc(%ebp)
  802dd5:	50                   	push   %eax
  802dd6:	6a 00                	push   $0x0
  802dd8:	e8 b2 ff ff ff       	call   802d8f <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
}
  802de0:	90                   	nop
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <sys_cgetc>:

int
sys_cgetc(void)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 02                	push   $0x2
  802df2:	e8 98 ff ff ff       	call   802d8f <syscall>
  802df7:	83 c4 18             	add    $0x18,%esp
}
  802dfa:	c9                   	leave  
  802dfb:	c3                   	ret    

00802dfc <sys_lock_cons>:

void sys_lock_cons(void)
{
  802dfc:	55                   	push   %ebp
  802dfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	6a 03                	push   $0x3
  802e0b:	e8 7f ff ff ff       	call   802d8f <syscall>
  802e10:	83 c4 18             	add    $0x18,%esp
}
  802e13:	90                   	nop
  802e14:	c9                   	leave  
  802e15:	c3                   	ret    

00802e16 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e16:	55                   	push   %ebp
  802e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 00                	push   $0x0
  802e23:	6a 04                	push   $0x4
  802e25:	e8 65 ff ff ff       	call   802d8f <syscall>
  802e2a:	83 c4 18             	add    $0x18,%esp
}
  802e2d:	90                   	nop
  802e2e:	c9                   	leave  
  802e2f:	c3                   	ret    

00802e30 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	52                   	push   %edx
  802e40:	50                   	push   %eax
  802e41:	6a 08                	push   $0x8
  802e43:	e8 47 ff ff ff       	call   802d8f <syscall>
  802e48:	83 c4 18             	add    $0x18,%esp
}
  802e4b:	c9                   	leave  
  802e4c:	c3                   	ret    

00802e4d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
  802e50:	56                   	push   %esi
  802e51:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e52:	8b 75 18             	mov    0x18(%ebp),%esi
  802e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	56                   	push   %esi
  802e62:	53                   	push   %ebx
  802e63:	51                   	push   %ecx
  802e64:	52                   	push   %edx
  802e65:	50                   	push   %eax
  802e66:	6a 09                	push   $0x9
  802e68:	e8 22 ff ff ff       	call   802d8f <syscall>
  802e6d:	83 c4 18             	add    $0x18,%esp
}
  802e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e73:	5b                   	pop    %ebx
  802e74:	5e                   	pop    %esi
  802e75:	5d                   	pop    %ebp
  802e76:	c3                   	ret    

00802e77 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	52                   	push   %edx
  802e87:	50                   	push   %eax
  802e88:	6a 0a                	push   $0xa
  802e8a:	e8 00 ff ff ff       	call   802d8f <syscall>
  802e8f:	83 c4 18             	add    $0x18,%esp
}
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	ff 75 0c             	pushl  0xc(%ebp)
  802ea0:	ff 75 08             	pushl  0x8(%ebp)
  802ea3:	6a 0b                	push   $0xb
  802ea5:	e8 e5 fe ff ff       	call   802d8f <syscall>
  802eaa:	83 c4 18             	add    $0x18,%esp
}
  802ead:	c9                   	leave  
  802eae:	c3                   	ret    

00802eaf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802eaf:	55                   	push   %ebp
  802eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 0c                	push   $0xc
  802ebe:	e8 cc fe ff ff       	call   802d8f <syscall>
  802ec3:	83 c4 18             	add    $0x18,%esp
}
  802ec6:	c9                   	leave  
  802ec7:	c3                   	ret    

00802ec8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802ec8:	55                   	push   %ebp
  802ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	6a 00                	push   $0x0
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 0d                	push   $0xd
  802ed7:	e8 b3 fe ff ff       	call   802d8f <syscall>
  802edc:	83 c4 18             	add    $0x18,%esp
}
  802edf:	c9                   	leave  
  802ee0:	c3                   	ret    

00802ee1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 00                	push   $0x0
  802eea:	6a 00                	push   $0x0
  802eec:	6a 00                	push   $0x0
  802eee:	6a 0e                	push   $0xe
  802ef0:	e8 9a fe ff ff       	call   802d8f <syscall>
  802ef5:	83 c4 18             	add    $0x18,%esp
}
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 0f                	push   $0xf
  802f09:	e8 81 fe ff ff       	call   802d8f <syscall>
  802f0e:	83 c4 18             	add    $0x18,%esp
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	ff 75 08             	pushl  0x8(%ebp)
  802f21:	6a 10                	push   $0x10
  802f23:	e8 67 fe ff ff       	call   802d8f <syscall>
  802f28:	83 c4 18             	add    $0x18,%esp
}
  802f2b:	c9                   	leave  
  802f2c:	c3                   	ret    

00802f2d <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f2d:	55                   	push   %ebp
  802f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f30:	6a 00                	push   $0x0
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 11                	push   $0x11
  802f3c:	e8 4e fe ff ff       	call   802d8f <syscall>
  802f41:	83 c4 18             	add    $0x18,%esp
}
  802f44:	90                   	nop
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <sys_cputc>:

void
sys_cputc(const char c)
{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
  802f4a:	83 ec 04             	sub    $0x4,%esp
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	50                   	push   %eax
  802f60:	6a 01                	push   $0x1
  802f62:	e8 28 fe ff ff       	call   802d8f <syscall>
  802f67:	83 c4 18             	add    $0x18,%esp
}
  802f6a:	90                   	nop
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f70:	6a 00                	push   $0x0
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 14                	push   $0x14
  802f7c:	e8 0e fe ff ff       	call   802d8f <syscall>
  802f81:	83 c4 18             	add    $0x18,%esp
}
  802f84:	90                   	nop
  802f85:	c9                   	leave  
  802f86:	c3                   	ret    

00802f87 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f87:	55                   	push   %ebp
  802f88:	89 e5                	mov    %esp,%ebp
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f90:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f96:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	6a 00                	push   $0x0
  802f9f:	51                   	push   %ecx
  802fa0:	52                   	push   %edx
  802fa1:	ff 75 0c             	pushl  0xc(%ebp)
  802fa4:	50                   	push   %eax
  802fa5:	6a 15                	push   $0x15
  802fa7:	e8 e3 fd ff ff       	call   802d8f <syscall>
  802fac:	83 c4 18             	add    $0x18,%esp
}
  802faf:	c9                   	leave  
  802fb0:	c3                   	ret    

00802fb1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802fb1:	55                   	push   %ebp
  802fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802fb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	52                   	push   %edx
  802fc1:	50                   	push   %eax
  802fc2:	6a 16                	push   $0x16
  802fc4:	e8 c6 fd ff ff       	call   802d8f <syscall>
  802fc9:	83 c4 18             	add    $0x18,%esp
}
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    

00802fce <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802fce:	55                   	push   %ebp
  802fcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802fd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	51                   	push   %ecx
  802fdf:	52                   	push   %edx
  802fe0:	50                   	push   %eax
  802fe1:	6a 17                	push   $0x17
  802fe3:	e8 a7 fd ff ff       	call   802d8f <syscall>
  802fe8:	83 c4 18             	add    $0x18,%esp
}
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	52                   	push   %edx
  802ffd:	50                   	push   %eax
  802ffe:	6a 18                	push   $0x18
  803000:	e8 8a fd ff ff       	call   802d8f <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
}
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	6a 00                	push   $0x0
  803012:	ff 75 14             	pushl  0x14(%ebp)
  803015:	ff 75 10             	pushl  0x10(%ebp)
  803018:	ff 75 0c             	pushl  0xc(%ebp)
  80301b:	50                   	push   %eax
  80301c:	6a 19                	push   $0x19
  80301e:	e8 6c fd ff ff       	call   802d8f <syscall>
  803023:	83 c4 18             	add    $0x18,%esp
}
  803026:	c9                   	leave  
  803027:	c3                   	ret    

00803028 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803028:	55                   	push   %ebp
  803029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	50                   	push   %eax
  803037:	6a 1a                	push   $0x1a
  803039:	e8 51 fd ff ff       	call   802d8f <syscall>
  80303e:	83 c4 18             	add    $0x18,%esp
}
  803041:	90                   	nop
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	50                   	push   %eax
  803053:	6a 1b                	push   $0x1b
  803055:	e8 35 fd ff ff       	call   802d8f <syscall>
  80305a:	83 c4 18             	add    $0x18,%esp
}
  80305d:	c9                   	leave  
  80305e:	c3                   	ret    

0080305f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80305f:	55                   	push   %ebp
  803060:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 00                	push   $0x0
  80306c:	6a 05                	push   $0x5
  80306e:	e8 1c fd ff ff       	call   802d8f <syscall>
  803073:	83 c4 18             	add    $0x18,%esp
}
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 06                	push   $0x6
  803087:	e8 03 fd ff ff       	call   802d8f <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803091:	55                   	push   %ebp
  803092:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 07                	push   $0x7
  8030a0:	e8 ea fc ff ff       	call   802d8f <syscall>
  8030a5:	83 c4 18             	add    $0x18,%esp
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <sys_exit_env>:


void sys_exit_env(void)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 1c                	push   $0x1c
  8030b9:	e8 d1 fc ff ff       	call   802d8f <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	90                   	nop
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8030ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030cd:	8d 50 04             	lea    0x4(%eax),%edx
  8030d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	52                   	push   %edx
  8030da:	50                   	push   %eax
  8030db:	6a 1d                	push   $0x1d
  8030dd:	e8 ad fc ff ff       	call   802d8f <syscall>
  8030e2:	83 c4 18             	add    $0x18,%esp
	return result;
  8030e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030ee:	89 01                	mov    %eax,(%ecx)
  8030f0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	c9                   	leave  
  8030f7:	c2 04 00             	ret    $0x4

008030fa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	ff 75 10             	pushl  0x10(%ebp)
  803104:	ff 75 0c             	pushl  0xc(%ebp)
  803107:	ff 75 08             	pushl  0x8(%ebp)
  80310a:	6a 13                	push   $0x13
  80310c:	e8 7e fc ff ff       	call   802d8f <syscall>
  803111:	83 c4 18             	add    $0x18,%esp
	return ;
  803114:	90                   	nop
}
  803115:	c9                   	leave  
  803116:	c3                   	ret    

00803117 <sys_rcr2>:
uint32 sys_rcr2()
{
  803117:	55                   	push   %ebp
  803118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	6a 00                	push   $0x0
  803122:	6a 00                	push   $0x0
  803124:	6a 1e                	push   $0x1e
  803126:	e8 64 fc ff ff       	call   802d8f <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
}
  80312e:	c9                   	leave  
  80312f:	c3                   	ret    

00803130 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803130:	55                   	push   %ebp
  803131:	89 e5                	mov    %esp,%ebp
  803133:	83 ec 04             	sub    $0x4,%esp
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80313c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	50                   	push   %eax
  803149:	6a 1f                	push   $0x1f
  80314b:	e8 3f fc ff ff       	call   802d8f <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
	return ;
  803153:	90                   	nop
}
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <rsttst>:
void rsttst()
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803159:	6a 00                	push   $0x0
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 21                	push   $0x21
  803165:	e8 25 fc ff ff       	call   802d8f <syscall>
  80316a:	83 c4 18             	add    $0x18,%esp
	return ;
  80316d:	90                   	nop
}
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
  803173:	83 ec 04             	sub    $0x4,%esp
  803176:	8b 45 14             	mov    0x14(%ebp),%eax
  803179:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80317c:	8b 55 18             	mov    0x18(%ebp),%edx
  80317f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803183:	52                   	push   %edx
  803184:	50                   	push   %eax
  803185:	ff 75 10             	pushl  0x10(%ebp)
  803188:	ff 75 0c             	pushl  0xc(%ebp)
  80318b:	ff 75 08             	pushl  0x8(%ebp)
  80318e:	6a 20                	push   $0x20
  803190:	e8 fa fb ff ff       	call   802d8f <syscall>
  803195:	83 c4 18             	add    $0x18,%esp
	return ;
  803198:	90                   	nop
}
  803199:	c9                   	leave  
  80319a:	c3                   	ret    

0080319b <chktst>:
void chktst(uint32 n)
{
  80319b:	55                   	push   %ebp
  80319c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	ff 75 08             	pushl  0x8(%ebp)
  8031a9:	6a 22                	push   $0x22
  8031ab:	e8 df fb ff ff       	call   802d8f <syscall>
  8031b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8031b3:	90                   	nop
}
  8031b4:	c9                   	leave  
  8031b5:	c3                   	ret    

008031b6 <inctst>:

void inctst()
{
  8031b6:	55                   	push   %ebp
  8031b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8031b9:	6a 00                	push   $0x0
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 23                	push   $0x23
  8031c5:	e8 c5 fb ff ff       	call   802d8f <syscall>
  8031ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8031cd:	90                   	nop
}
  8031ce:	c9                   	leave  
  8031cf:	c3                   	ret    

008031d0 <gettst>:
uint32 gettst()
{
  8031d0:	55                   	push   %ebp
  8031d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8031d3:	6a 00                	push   $0x0
  8031d5:	6a 00                	push   $0x0
  8031d7:	6a 00                	push   $0x0
  8031d9:	6a 00                	push   $0x0
  8031db:	6a 00                	push   $0x0
  8031dd:	6a 24                	push   $0x24
  8031df:	e8 ab fb ff ff       	call   802d8f <syscall>
  8031e4:	83 c4 18             	add    $0x18,%esp
}
  8031e7:	c9                   	leave  
  8031e8:	c3                   	ret    

008031e9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8031e9:	55                   	push   %ebp
  8031ea:	89 e5                	mov    %esp,%ebp
  8031ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 00                	push   $0x0
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 25                	push   $0x25
  8031fb:	e8 8f fb ff ff       	call   802d8f <syscall>
  803200:	83 c4 18             	add    $0x18,%esp
  803203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803206:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80320a:	75 07                	jne    803213 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80320c:	b8 01 00 00 00       	mov    $0x1,%eax
  803211:	eb 05                	jmp    803218 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803218:	c9                   	leave  
  803219:	c3                   	ret    

0080321a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80321a:	55                   	push   %ebp
  80321b:	89 e5                	mov    %esp,%ebp
  80321d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 25                	push   $0x25
  80322c:	e8 5e fb ff ff       	call   802d8f <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
  803234:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803237:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80323b:	75 07                	jne    803244 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80323d:	b8 01 00 00 00       	mov    $0x1,%eax
  803242:	eb 05                	jmp    803249 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
  80324e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 25                	push   $0x25
  80325d:	e8 2d fb ff ff       	call   802d8f <syscall>
  803262:	83 c4 18             	add    $0x18,%esp
  803265:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803268:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80326c:	75 07                	jne    803275 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80326e:	b8 01 00 00 00       	mov    $0x1,%eax
  803273:	eb 05                	jmp    80327a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
  80327f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 25                	push   $0x25
  80328e:	e8 fc fa ff ff       	call   802d8f <syscall>
  803293:	83 c4 18             	add    $0x18,%esp
  803296:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803299:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80329d:	75 07                	jne    8032a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80329f:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a4:	eb 05                	jmp    8032ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8032a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	ff 75 08             	pushl  0x8(%ebp)
  8032bb:	6a 26                	push   $0x26
  8032bd:	e8 cd fa ff ff       	call   802d8f <syscall>
  8032c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c5:	90                   	nop
}
  8032c6:	c9                   	leave  
  8032c7:	c3                   	ret    

008032c8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032c8:	55                   	push   %ebp
  8032c9:	89 e5                	mov    %esp,%ebp
  8032cb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	6a 00                	push   $0x0
  8032da:	53                   	push   %ebx
  8032db:	51                   	push   %ecx
  8032dc:	52                   	push   %edx
  8032dd:	50                   	push   %eax
  8032de:	6a 27                	push   $0x27
  8032e0:	e8 aa fa ff ff       	call   802d8f <syscall>
  8032e5:	83 c4 18             	add    $0x18,%esp
}
  8032e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032eb:	c9                   	leave  
  8032ec:	c3                   	ret    

008032ed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032ed:	55                   	push   %ebp
  8032ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	6a 00                	push   $0x0
  8032f8:	6a 00                	push   $0x0
  8032fa:	6a 00                	push   $0x0
  8032fc:	52                   	push   %edx
  8032fd:	50                   	push   %eax
  8032fe:	6a 28                	push   $0x28
  803300:	e8 8a fa ff ff       	call   802d8f <syscall>
  803305:	83 c4 18             	add    $0x18,%esp
}
  803308:	c9                   	leave  
  803309:	c3                   	ret    

0080330a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80330a:	55                   	push   %ebp
  80330b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80330d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803310:	8b 55 0c             	mov    0xc(%ebp),%edx
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	6a 00                	push   $0x0
  803318:	51                   	push   %ecx
  803319:	ff 75 10             	pushl  0x10(%ebp)
  80331c:	52                   	push   %edx
  80331d:	50                   	push   %eax
  80331e:	6a 29                	push   $0x29
  803320:	e8 6a fa ff ff       	call   802d8f <syscall>
  803325:	83 c4 18             	add    $0x18,%esp
}
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	ff 75 10             	pushl  0x10(%ebp)
  803334:	ff 75 0c             	pushl  0xc(%ebp)
  803337:	ff 75 08             	pushl  0x8(%ebp)
  80333a:	6a 12                	push   $0x12
  80333c:	e8 4e fa ff ff       	call   802d8f <syscall>
  803341:	83 c4 18             	add    $0x18,%esp
	return ;
  803344:	90                   	nop
}
  803345:	c9                   	leave  
  803346:	c3                   	ret    

00803347 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803347:	55                   	push   %ebp
  803348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80334a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 00                	push   $0x0
  803356:	52                   	push   %edx
  803357:	50                   	push   %eax
  803358:	6a 2a                	push   $0x2a
  80335a:	e8 30 fa ff ff       	call   802d8f <syscall>
  80335f:	83 c4 18             	add    $0x18,%esp
	return;
  803362:	90                   	nop
}
  803363:	c9                   	leave  
  803364:	c3                   	ret    

00803365 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803365:	55                   	push   %ebp
  803366:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	6a 00                	push   $0x0
  803373:	50                   	push   %eax
  803374:	6a 2b                	push   $0x2b
  803376:	e8 14 fa ff ff       	call   802d8f <syscall>
  80337b:	83 c4 18             	add    $0x18,%esp
}
  80337e:	c9                   	leave  
  80337f:	c3                   	ret    

00803380 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803383:	6a 00                	push   $0x0
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	ff 75 0c             	pushl  0xc(%ebp)
  80338c:	ff 75 08             	pushl  0x8(%ebp)
  80338f:	6a 2c                	push   $0x2c
  803391:	e8 f9 f9 ff ff       	call   802d8f <syscall>
  803396:	83 c4 18             	add    $0x18,%esp
	return;
  803399:	90                   	nop
}
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	ff 75 0c             	pushl  0xc(%ebp)
  8033a8:	ff 75 08             	pushl  0x8(%ebp)
  8033ab:	6a 2d                	push   $0x2d
  8033ad:	e8 dd f9 ff ff       	call   802d8f <syscall>
  8033b2:	83 c4 18             	add    $0x18,%esp
	return;
  8033b5:	90                   	nop
}
  8033b6:	c9                   	leave  
  8033b7:	c3                   	ret    

008033b8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8033b8:	55                   	push   %ebp
  8033b9:	89 e5                	mov    %esp,%ebp
  8033bb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	83 e8 04             	sub    $0x4,%eax
  8033c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8033c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	83 e8 04             	sub    $0x4,%eax
  8033dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8033e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	83 e0 01             	and    $0x1,%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	0f 94 c0             	sete   %al
}
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8033f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8033fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ff:	83 f8 02             	cmp    $0x2,%eax
  803402:	74 2b                	je     80342f <alloc_block+0x40>
  803404:	83 f8 02             	cmp    $0x2,%eax
  803407:	7f 07                	jg     803410 <alloc_block+0x21>
  803409:	83 f8 01             	cmp    $0x1,%eax
  80340c:	74 0e                	je     80341c <alloc_block+0x2d>
  80340e:	eb 58                	jmp    803468 <alloc_block+0x79>
  803410:	83 f8 03             	cmp    $0x3,%eax
  803413:	74 2d                	je     803442 <alloc_block+0x53>
  803415:	83 f8 04             	cmp    $0x4,%eax
  803418:	74 3b                	je     803455 <alloc_block+0x66>
  80341a:	eb 4c                	jmp    803468 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80341c:	83 ec 0c             	sub    $0xc,%esp
  80341f:	ff 75 08             	pushl  0x8(%ebp)
  803422:	e8 11 03 00 00       	call   803738 <alloc_block_FF>
  803427:	83 c4 10             	add    $0x10,%esp
  80342a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80342d:	eb 4a                	jmp    803479 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80342f:	83 ec 0c             	sub    $0xc,%esp
  803432:	ff 75 08             	pushl  0x8(%ebp)
  803435:	e8 fa 19 00 00       	call   804e34 <alloc_block_NF>
  80343a:	83 c4 10             	add    $0x10,%esp
  80343d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803440:	eb 37                	jmp    803479 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803442:	83 ec 0c             	sub    $0xc,%esp
  803445:	ff 75 08             	pushl  0x8(%ebp)
  803448:	e8 a7 07 00 00       	call   803bf4 <alloc_block_BF>
  80344d:	83 c4 10             	add    $0x10,%esp
  803450:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803453:	eb 24                	jmp    803479 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803455:	83 ec 0c             	sub    $0xc,%esp
  803458:	ff 75 08             	pushl  0x8(%ebp)
  80345b:	e8 b7 19 00 00       	call   804e17 <alloc_block_WF>
  803460:	83 c4 10             	add    $0x10,%esp
  803463:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803466:	eb 11                	jmp    803479 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803468:	83 ec 0c             	sub    $0xc,%esp
  80346b:	68 78 69 80 00       	push   $0x806978
  803470:	e8 3b e6 ff ff       	call   801ab0 <cprintf>
  803475:	83 c4 10             	add    $0x10,%esp
		break;
  803478:	90                   	nop
	}
	return va;
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80347c:	c9                   	leave  
  80347d:	c3                   	ret    

0080347e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80347e:	55                   	push   %ebp
  80347f:	89 e5                	mov    %esp,%ebp
  803481:	53                   	push   %ebx
  803482:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803485:	83 ec 0c             	sub    $0xc,%esp
  803488:	68 98 69 80 00       	push   $0x806998
  80348d:	e8 1e e6 ff ff       	call   801ab0 <cprintf>
  803492:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803495:	83 ec 0c             	sub    $0xc,%esp
  803498:	68 c3 69 80 00       	push   $0x8069c3
  80349d:	e8 0e e6 ff ff       	call   801ab0 <cprintf>
  8034a2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ab:	eb 37                	jmp    8034e4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8034ad:	83 ec 0c             	sub    $0xc,%esp
  8034b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8034b3:	e8 19 ff ff ff       	call   8033d1 <is_free_block>
  8034b8:	83 c4 10             	add    $0x10,%esp
  8034bb:	0f be d8             	movsbl %al,%ebx
  8034be:	83 ec 0c             	sub    $0xc,%esp
  8034c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8034c4:	e8 ef fe ff ff       	call   8033b8 <get_block_size>
  8034c9:	83 c4 10             	add    $0x10,%esp
  8034cc:	83 ec 04             	sub    $0x4,%esp
  8034cf:	53                   	push   %ebx
  8034d0:	50                   	push   %eax
  8034d1:	68 db 69 80 00       	push   $0x8069db
  8034d6:	e8 d5 e5 ff ff       	call   801ab0 <cprintf>
  8034db:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8034de:	8b 45 10             	mov    0x10(%ebp),%eax
  8034e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e8:	74 07                	je     8034f1 <print_blocks_list+0x73>
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	8b 00                	mov    (%eax),%eax
  8034ef:	eb 05                	jmp    8034f6 <print_blocks_list+0x78>
  8034f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f6:	89 45 10             	mov    %eax,0x10(%ebp)
  8034f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	75 ad                	jne    8034ad <print_blocks_list+0x2f>
  803500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803504:	75 a7                	jne    8034ad <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803506:	83 ec 0c             	sub    $0xc,%esp
  803509:	68 98 69 80 00       	push   $0x806998
  80350e:	e8 9d e5 ff ff       	call   801ab0 <cprintf>
  803513:	83 c4 10             	add    $0x10,%esp

}
  803516:	90                   	nop
  803517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80351a:	c9                   	leave  
  80351b:	c3                   	ret    

0080351c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	83 e0 01             	and    $0x1,%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 03                	je     80352f <initialize_dynamic_allocator+0x13>
  80352c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80352f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803533:	0f 84 c7 01 00 00    	je     803700 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  803539:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  803540:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  803543:	8b 55 08             	mov    0x8(%ebp),%edx
  803546:	8b 45 0c             	mov    0xc(%ebp),%eax
  803549:	01 d0                	add    %edx,%eax
  80354b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  803550:	0f 87 ad 01 00 00    	ja     803703 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	85 c0                	test   %eax,%eax
  80355b:	0f 89 a5 01 00 00    	jns    803706 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  803561:	8b 55 08             	mov    0x8(%ebp),%edx
  803564:	8b 45 0c             	mov    0xc(%ebp),%eax
  803567:	01 d0                	add    %edx,%eax
  803569:	83 e8 04             	sub    $0x4,%eax
  80356c:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  803571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  803578:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80357d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803580:	e9 87 00 00 00       	jmp    80360c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803589:	75 14                	jne    80359f <initialize_dynamic_allocator+0x83>
  80358b:	83 ec 04             	sub    $0x4,%esp
  80358e:	68 f3 69 80 00       	push   $0x8069f3
  803593:	6a 79                	push   $0x79
  803595:	68 11 6a 80 00       	push   $0x806a11
  80359a:	e8 54 e2 ff ff       	call   8017f3 <_panic>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	74 10                	je     8035b8 <initialize_dynamic_allocator+0x9c>
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b0:	8b 52 04             	mov    0x4(%edx),%edx
  8035b3:	89 50 04             	mov    %edx,0x4(%eax)
  8035b6:	eb 0b                	jmp    8035c3 <initialize_dynamic_allocator+0xa7>
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	8b 40 04             	mov    0x4(%eax),%eax
  8035be:	a3 30 70 80 00       	mov    %eax,0x807030
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0f                	je     8035dc <initialize_dynamic_allocator+0xc0>
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	8b 40 04             	mov    0x4(%eax),%eax
  8035d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d6:	8b 12                	mov    (%edx),%edx
  8035d8:	89 10                	mov    %edx,(%eax)
  8035da:	eb 0a                	jmp    8035e6 <initialize_dynamic_allocator+0xca>
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f9:	a1 38 70 80 00       	mov    0x807038,%eax
  8035fe:	48                   	dec    %eax
  8035ff:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803604:	a1 34 70 80 00       	mov    0x807034,%eax
  803609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803610:	74 07                	je     803619 <initialize_dynamic_allocator+0xfd>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	eb 05                	jmp    80361e <initialize_dynamic_allocator+0x102>
  803619:	b8 00 00 00 00       	mov    $0x0,%eax
  80361e:	a3 34 70 80 00       	mov    %eax,0x807034
  803623:	a1 34 70 80 00       	mov    0x807034,%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	0f 85 55 ff ff ff    	jne    803585 <initialize_dynamic_allocator+0x69>
  803630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803634:	0f 85 4b ff ff ff    	jne    803585 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803643:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803649:	a1 44 70 80 00       	mov    0x807044,%eax
  80364e:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  803653:	a1 40 70 80 00       	mov    0x807040,%eax
  803658:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	83 c0 08             	add    $0x8,%eax
  803664:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	83 c0 04             	add    $0x4,%eax
  80366d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803670:	83 ea 08             	sub    $0x8,%edx
  803673:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803675:	8b 55 0c             	mov    0xc(%ebp),%edx
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	01 d0                	add    %edx,%eax
  80367d:	83 e8 08             	sub    $0x8,%eax
  803680:	8b 55 0c             	mov    0xc(%ebp),%edx
  803683:	83 ea 08             	sub    $0x8,%edx
  803686:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80369b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80369f:	75 17                	jne    8036b8 <initialize_dynamic_allocator+0x19c>
  8036a1:	83 ec 04             	sub    $0x4,%esp
  8036a4:	68 2c 6a 80 00       	push   $0x806a2c
  8036a9:	68 90 00 00 00       	push   $0x90
  8036ae:	68 11 6a 80 00       	push   $0x806a11
  8036b3:	e8 3b e1 ff ff       	call   8017f3 <_panic>
  8036b8:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8036be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c1:	89 10                	mov    %edx,(%eax)
  8036c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 0d                	je     8036d9 <initialize_dynamic_allocator+0x1bd>
  8036cc:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8036d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036d4:	89 50 04             	mov    %edx,0x4(%eax)
  8036d7:	eb 08                	jmp    8036e1 <initialize_dynamic_allocator+0x1c5>
  8036d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036dc:	a3 30 70 80 00       	mov    %eax,0x807030
  8036e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e4:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8036e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f3:	a1 38 70 80 00       	mov    0x807038,%eax
  8036f8:	40                   	inc    %eax
  8036f9:	a3 38 70 80 00       	mov    %eax,0x807038
  8036fe:	eb 07                	jmp    803707 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803700:	90                   	nop
  803701:	eb 04                	jmp    803707 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803703:	90                   	nop
  803704:	eb 01                	jmp    803707 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803706:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  803707:	c9                   	leave  
  803708:	c3                   	ret    

00803709 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803709:	55                   	push   %ebp
  80370a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80370c:	8b 45 10             	mov    0x10(%ebp),%eax
  80370f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	8d 50 fc             	lea    -0x4(%eax),%edx
  803718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	83 e8 04             	sub    $0x4,%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	83 e0 fe             	and    $0xfffffffe,%eax
  803728:	8d 50 f8             	lea    -0x8(%eax),%edx
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	01 c2                	add    %eax,%edx
  803730:	8b 45 0c             	mov    0xc(%ebp),%eax
  803733:	89 02                	mov    %eax,(%edx)
}
  803735:	90                   	nop
  803736:	5d                   	pop    %ebp
  803737:	c3                   	ret    

00803738 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803738:	55                   	push   %ebp
  803739:	89 e5                	mov    %esp,%ebp
  80373b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	83 e0 01             	and    $0x1,%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	74 03                	je     80374b <alloc_block_FF+0x13>
  803748:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80374b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80374f:	77 07                	ja     803758 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803751:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803758:	a1 24 70 80 00       	mov    0x807024,%eax
  80375d:	85 c0                	test   %eax,%eax
  80375f:	75 73                	jne    8037d4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803761:	8b 45 08             	mov    0x8(%ebp),%eax
  803764:	83 c0 10             	add    $0x10,%eax
  803767:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80376a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803771:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803777:	01 d0                	add    %edx,%eax
  803779:	48                   	dec    %eax
  80377a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80377d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803780:	ba 00 00 00 00       	mov    $0x0,%edx
  803785:	f7 75 ec             	divl   -0x14(%ebp)
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	29 d0                	sub    %edx,%eax
  80378d:	c1 e8 0c             	shr    $0xc,%eax
  803790:	83 ec 0c             	sub    $0xc,%esp
  803793:	50                   	push   %eax
  803794:	e8 b1 f0 ff ff       	call   80284a <sbrk>
  803799:	83 c4 10             	add    $0x10,%esp
  80379c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80379f:	83 ec 0c             	sub    $0xc,%esp
  8037a2:	6a 00                	push   $0x0
  8037a4:	e8 a1 f0 ff ff       	call   80284a <sbrk>
  8037a9:	83 c4 10             	add    $0x10,%esp
  8037ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8037af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8037b5:	83 ec 08             	sub    $0x8,%esp
  8037b8:	50                   	push   %eax
  8037b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037bc:	e8 5b fd ff ff       	call   80351c <initialize_dynamic_allocator>
  8037c1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8037c4:	83 ec 0c             	sub    $0xc,%esp
  8037c7:	68 4f 6a 80 00       	push   $0x806a4f
  8037cc:	e8 df e2 ff ff       	call   801ab0 <cprintf>
  8037d1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	75 0a                	jne    8037e4 <alloc_block_FF+0xac>
	        return NULL;
  8037da:	b8 00 00 00 00       	mov    $0x0,%eax
  8037df:	e9 0e 04 00 00       	jmp    803bf2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8037e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8037eb:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8037f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f3:	e9 f3 02 00 00       	jmp    803aeb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8037fe:	83 ec 0c             	sub    $0xc,%esp
  803801:	ff 75 bc             	pushl  -0x44(%ebp)
  803804:	e8 af fb ff ff       	call   8033b8 <get_block_size>
  803809:	83 c4 10             	add    $0x10,%esp
  80380c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	83 c0 08             	add    $0x8,%eax
  803815:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803818:	0f 87 c5 02 00 00    	ja     803ae3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	83 c0 18             	add    $0x18,%eax
  803824:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803827:	0f 87 19 02 00 00    	ja     803a46 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80382d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803830:	2b 45 08             	sub    0x8(%ebp),%eax
  803833:	83 e8 08             	sub    $0x8,%eax
  803836:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	8d 50 08             	lea    0x8(%eax),%edx
  80383f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803842:	01 d0                	add    %edx,%eax
  803844:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	83 c0 08             	add    $0x8,%eax
  80384d:	83 ec 04             	sub    $0x4,%esp
  803850:	6a 01                	push   $0x1
  803852:	50                   	push   %eax
  803853:	ff 75 bc             	pushl  -0x44(%ebp)
  803856:	e8 ae fe ff ff       	call   803709 <set_block_data>
  80385b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	8b 40 04             	mov    0x4(%eax),%eax
  803864:	85 c0                	test   %eax,%eax
  803866:	75 68                	jne    8038d0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803868:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80386c:	75 17                	jne    803885 <alloc_block_FF+0x14d>
  80386e:	83 ec 04             	sub    $0x4,%esp
  803871:	68 2c 6a 80 00       	push   $0x806a2c
  803876:	68 d7 00 00 00       	push   $0xd7
  80387b:	68 11 6a 80 00       	push   $0x806a11
  803880:	e8 6e df ff ff       	call   8017f3 <_panic>
  803885:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80388b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80388e:	89 10                	mov    %edx,(%eax)
  803890:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	85 c0                	test   %eax,%eax
  803897:	74 0d                	je     8038a6 <alloc_block_FF+0x16e>
  803899:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80389e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038a1:	89 50 04             	mov    %edx,0x4(%eax)
  8038a4:	eb 08                	jmp    8038ae <alloc_block_FF+0x176>
  8038a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038a9:	a3 30 70 80 00       	mov    %eax,0x807030
  8038ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038b1:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8038b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c0:	a1 38 70 80 00       	mov    0x807038,%eax
  8038c5:	40                   	inc    %eax
  8038c6:	a3 38 70 80 00       	mov    %eax,0x807038
  8038cb:	e9 dc 00 00 00       	jmp    8039ac <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8038d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	85 c0                	test   %eax,%eax
  8038d7:	75 65                	jne    80393e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8038d9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8038dd:	75 17                	jne    8038f6 <alloc_block_FF+0x1be>
  8038df:	83 ec 04             	sub    $0x4,%esp
  8038e2:	68 60 6a 80 00       	push   $0x806a60
  8038e7:	68 db 00 00 00       	push   $0xdb
  8038ec:	68 11 6a 80 00       	push   $0x806a11
  8038f1:	e8 fd de ff ff       	call   8017f3 <_panic>
  8038f6:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8038fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803905:	8b 40 04             	mov    0x4(%eax),%eax
  803908:	85 c0                	test   %eax,%eax
  80390a:	74 0c                	je     803918 <alloc_block_FF+0x1e0>
  80390c:	a1 30 70 80 00       	mov    0x807030,%eax
  803911:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803914:	89 10                	mov    %edx,(%eax)
  803916:	eb 08                	jmp    803920 <alloc_block_FF+0x1e8>
  803918:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80391b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803920:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803923:	a3 30 70 80 00       	mov    %eax,0x807030
  803928:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80392b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803931:	a1 38 70 80 00       	mov    0x807038,%eax
  803936:	40                   	inc    %eax
  803937:	a3 38 70 80 00       	mov    %eax,0x807038
  80393c:	eb 6e                	jmp    8039ac <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80393e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803942:	74 06                	je     80394a <alloc_block_FF+0x212>
  803944:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803948:	75 17                	jne    803961 <alloc_block_FF+0x229>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 84 6a 80 00       	push   $0x806a84
  803952:	68 df 00 00 00       	push   $0xdf
  803957:	68 11 6a 80 00       	push   $0x806a11
  80395c:	e8 92 de ff ff       	call   8017f3 <_panic>
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	8b 10                	mov    (%eax),%edx
  803966:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0b                	je     80397f <alloc_block_FF+0x247>
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	8b 00                	mov    (%eax),%eax
  803979:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80397c:	89 50 04             	mov    %edx,0x4(%eax)
  80397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803982:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803985:	89 10                	mov    %edx,(%eax)
  803987:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80398a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80398d:	89 50 04             	mov    %edx,0x4(%eax)
  803990:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803993:	8b 00                	mov    (%eax),%eax
  803995:	85 c0                	test   %eax,%eax
  803997:	75 08                	jne    8039a1 <alloc_block_FF+0x269>
  803999:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80399c:	a3 30 70 80 00       	mov    %eax,0x807030
  8039a1:	a1 38 70 80 00       	mov    0x807038,%eax
  8039a6:	40                   	inc    %eax
  8039a7:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b0:	75 17                	jne    8039c9 <alloc_block_FF+0x291>
  8039b2:	83 ec 04             	sub    $0x4,%esp
  8039b5:	68 f3 69 80 00       	push   $0x8069f3
  8039ba:	68 e1 00 00 00       	push   $0xe1
  8039bf:	68 11 6a 80 00       	push   $0x806a11
  8039c4:	e8 2a de ff ff       	call   8017f3 <_panic>
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 10                	je     8039e2 <alloc_block_FF+0x2aa>
  8039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d5:	8b 00                	mov    (%eax),%eax
  8039d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039da:	8b 52 04             	mov    0x4(%edx),%edx
  8039dd:	89 50 04             	mov    %edx,0x4(%eax)
  8039e0:	eb 0b                	jmp    8039ed <alloc_block_FF+0x2b5>
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 40 04             	mov    0x4(%eax),%eax
  8039e8:	a3 30 70 80 00       	mov    %eax,0x807030
  8039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f0:	8b 40 04             	mov    0x4(%eax),%eax
  8039f3:	85 c0                	test   %eax,%eax
  8039f5:	74 0f                	je     803a06 <alloc_block_FF+0x2ce>
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	8b 40 04             	mov    0x4(%eax),%eax
  8039fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a00:	8b 12                	mov    (%edx),%edx
  803a02:	89 10                	mov    %edx,(%eax)
  803a04:	eb 0a                	jmp    803a10 <alloc_block_FF+0x2d8>
  803a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a23:	a1 38 70 80 00       	mov    0x807038,%eax
  803a28:	48                   	dec    %eax
  803a29:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	6a 00                	push   $0x0
  803a33:	ff 75 b4             	pushl  -0x4c(%ebp)
  803a36:	ff 75 b0             	pushl  -0x50(%ebp)
  803a39:	e8 cb fc ff ff       	call   803709 <set_block_data>
  803a3e:	83 c4 10             	add    $0x10,%esp
  803a41:	e9 95 00 00 00       	jmp    803adb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	6a 01                	push   $0x1
  803a4b:	ff 75 b8             	pushl  -0x48(%ebp)
  803a4e:	ff 75 bc             	pushl  -0x44(%ebp)
  803a51:	e8 b3 fc ff ff       	call   803709 <set_block_data>
  803a56:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5d:	75 17                	jne    803a76 <alloc_block_FF+0x33e>
  803a5f:	83 ec 04             	sub    $0x4,%esp
  803a62:	68 f3 69 80 00       	push   $0x8069f3
  803a67:	68 e8 00 00 00       	push   $0xe8
  803a6c:	68 11 6a 80 00       	push   $0x806a11
  803a71:	e8 7d dd ff ff       	call   8017f3 <_panic>
  803a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	74 10                	je     803a8f <alloc_block_FF+0x357>
  803a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a87:	8b 52 04             	mov    0x4(%edx),%edx
  803a8a:	89 50 04             	mov    %edx,0x4(%eax)
  803a8d:	eb 0b                	jmp    803a9a <alloc_block_FF+0x362>
  803a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a92:	8b 40 04             	mov    0x4(%eax),%eax
  803a95:	a3 30 70 80 00       	mov    %eax,0x807030
  803a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9d:	8b 40 04             	mov    0x4(%eax),%eax
  803aa0:	85 c0                	test   %eax,%eax
  803aa2:	74 0f                	je     803ab3 <alloc_block_FF+0x37b>
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 40 04             	mov    0x4(%eax),%eax
  803aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aad:	8b 12                	mov    (%edx),%edx
  803aaf:	89 10                	mov    %edx,(%eax)
  803ab1:	eb 0a                	jmp    803abd <alloc_block_FF+0x385>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	8b 00                	mov    (%eax),%eax
  803ab8:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad0:	a1 38 70 80 00       	mov    0x807038,%eax
  803ad5:	48                   	dec    %eax
  803ad6:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  803adb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ade:	e9 0f 01 00 00       	jmp    803bf2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803ae3:	a1 34 70 80 00       	mov    0x807034,%eax
  803ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aef:	74 07                	je     803af8 <alloc_block_FF+0x3c0>
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	eb 05                	jmp    803afd <alloc_block_FF+0x3c5>
  803af8:	b8 00 00 00 00       	mov    $0x0,%eax
  803afd:	a3 34 70 80 00       	mov    %eax,0x807034
  803b02:	a1 34 70 80 00       	mov    0x807034,%eax
  803b07:	85 c0                	test   %eax,%eax
  803b09:	0f 85 e9 fc ff ff    	jne    8037f8 <alloc_block_FF+0xc0>
  803b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b13:	0f 85 df fc ff ff    	jne    8037f8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803b19:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1c:	83 c0 08             	add    $0x8,%eax
  803b1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803b22:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803b29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b2f:	01 d0                	add    %edx,%eax
  803b31:	48                   	dec    %eax
  803b32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803b35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b38:	ba 00 00 00 00       	mov    $0x0,%edx
  803b3d:	f7 75 d8             	divl   -0x28(%ebp)
  803b40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b43:	29 d0                	sub    %edx,%eax
  803b45:	c1 e8 0c             	shr    $0xc,%eax
  803b48:	83 ec 0c             	sub    $0xc,%esp
  803b4b:	50                   	push   %eax
  803b4c:	e8 f9 ec ff ff       	call   80284a <sbrk>
  803b51:	83 c4 10             	add    $0x10,%esp
  803b54:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803b57:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803b5b:	75 0a                	jne    803b67 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b62:	e9 8b 00 00 00       	jmp    803bf2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803b67:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803b6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b74:	01 d0                	add    %edx,%eax
  803b76:	48                   	dec    %eax
  803b77:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803b7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  803b82:	f7 75 cc             	divl   -0x34(%ebp)
  803b85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b88:	29 d0                	sub    %edx,%eax
  803b8a:	8d 50 fc             	lea    -0x4(%eax),%edx
  803b8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b90:	01 d0                	add    %edx,%eax
  803b92:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  803b97:	a1 40 70 80 00       	mov    0x807040,%eax
  803b9c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803ba2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803ba9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803baf:	01 d0                	add    %edx,%eax
  803bb1:	48                   	dec    %eax
  803bb2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803bb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  803bbd:	f7 75 c4             	divl   -0x3c(%ebp)
  803bc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bc3:	29 d0                	sub    %edx,%eax
  803bc5:	83 ec 04             	sub    $0x4,%esp
  803bc8:	6a 01                	push   $0x1
  803bca:	50                   	push   %eax
  803bcb:	ff 75 d0             	pushl  -0x30(%ebp)
  803bce:	e8 36 fb ff ff       	call   803709 <set_block_data>
  803bd3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803bd6:	83 ec 0c             	sub    $0xc,%esp
  803bd9:	ff 75 d0             	pushl  -0x30(%ebp)
  803bdc:	e8 1b 0a 00 00       	call   8045fc <free_block>
  803be1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803be4:	83 ec 0c             	sub    $0xc,%esp
  803be7:	ff 75 08             	pushl  0x8(%ebp)
  803bea:	e8 49 fb ff ff       	call   803738 <alloc_block_FF>
  803bef:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803bf2:	c9                   	leave  
  803bf3:	c3                   	ret    

00803bf4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803bf4:	55                   	push   %ebp
  803bf5:	89 e5                	mov    %esp,%ebp
  803bf7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfd:	83 e0 01             	and    $0x1,%eax
  803c00:	85 c0                	test   %eax,%eax
  803c02:	74 03                	je     803c07 <alloc_block_BF+0x13>
  803c04:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803c07:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803c0b:	77 07                	ja     803c14 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803c0d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803c14:	a1 24 70 80 00       	mov    0x807024,%eax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	75 73                	jne    803c90 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c20:	83 c0 10             	add    $0x10,%eax
  803c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803c26:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803c2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c33:	01 d0                	add    %edx,%eax
  803c35:	48                   	dec    %eax
  803c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  803c41:	f7 75 e0             	divl   -0x20(%ebp)
  803c44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c47:	29 d0                	sub    %edx,%eax
  803c49:	c1 e8 0c             	shr    $0xc,%eax
  803c4c:	83 ec 0c             	sub    $0xc,%esp
  803c4f:	50                   	push   %eax
  803c50:	e8 f5 eb ff ff       	call   80284a <sbrk>
  803c55:	83 c4 10             	add    $0x10,%esp
  803c58:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803c5b:	83 ec 0c             	sub    $0xc,%esp
  803c5e:	6a 00                	push   $0x0
  803c60:	e8 e5 eb ff ff       	call   80284a <sbrk>
  803c65:	83 c4 10             	add    $0x10,%esp
  803c68:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803c6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803c71:	83 ec 08             	sub    $0x8,%esp
  803c74:	50                   	push   %eax
  803c75:	ff 75 d8             	pushl  -0x28(%ebp)
  803c78:	e8 9f f8 ff ff       	call   80351c <initialize_dynamic_allocator>
  803c7d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803c80:	83 ec 0c             	sub    $0xc,%esp
  803c83:	68 4f 6a 80 00       	push   $0x806a4f
  803c88:	e8 23 de ff ff       	call   801ab0 <cprintf>
  803c8d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803c97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803c9e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803ca5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803cac:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cb4:	e9 1d 01 00 00       	jmp    803dd6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803cbf:	83 ec 0c             	sub    $0xc,%esp
  803cc2:	ff 75 a8             	pushl  -0x58(%ebp)
  803cc5:	e8 ee f6 ff ff       	call   8033b8 <get_block_size>
  803cca:	83 c4 10             	add    $0x10,%esp
  803ccd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd3:	83 c0 08             	add    $0x8,%eax
  803cd6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803cd9:	0f 87 ef 00 00 00    	ja     803dce <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce2:	83 c0 18             	add    $0x18,%eax
  803ce5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ce8:	77 1d                	ja     803d07 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ced:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803cf0:	0f 86 d8 00 00 00    	jbe    803dce <alloc_block_BF+0x1da>
				{
					best_va = va;
  803cf6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803cfc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d02:	e9 c7 00 00 00       	jmp    803dce <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803d07:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0a:	83 c0 08             	add    $0x8,%eax
  803d0d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803d10:	0f 85 9d 00 00 00    	jne    803db3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803d16:	83 ec 04             	sub    $0x4,%esp
  803d19:	6a 01                	push   $0x1
  803d1b:	ff 75 a4             	pushl  -0x5c(%ebp)
  803d1e:	ff 75 a8             	pushl  -0x58(%ebp)
  803d21:	e8 e3 f9 ff ff       	call   803709 <set_block_data>
  803d26:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803d29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2d:	75 17                	jne    803d46 <alloc_block_BF+0x152>
  803d2f:	83 ec 04             	sub    $0x4,%esp
  803d32:	68 f3 69 80 00       	push   $0x8069f3
  803d37:	68 2c 01 00 00       	push   $0x12c
  803d3c:	68 11 6a 80 00       	push   $0x806a11
  803d41:	e8 ad da ff ff       	call   8017f3 <_panic>
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	8b 00                	mov    (%eax),%eax
  803d4b:	85 c0                	test   %eax,%eax
  803d4d:	74 10                	je     803d5f <alloc_block_BF+0x16b>
  803d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d52:	8b 00                	mov    (%eax),%eax
  803d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d57:	8b 52 04             	mov    0x4(%edx),%edx
  803d5a:	89 50 04             	mov    %edx,0x4(%eax)
  803d5d:	eb 0b                	jmp    803d6a <alloc_block_BF+0x176>
  803d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d62:	8b 40 04             	mov    0x4(%eax),%eax
  803d65:	a3 30 70 80 00       	mov    %eax,0x807030
  803d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6d:	8b 40 04             	mov    0x4(%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	74 0f                	je     803d83 <alloc_block_BF+0x18f>
  803d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d77:	8b 40 04             	mov    0x4(%eax),%eax
  803d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7d:	8b 12                	mov    (%edx),%edx
  803d7f:	89 10                	mov    %edx,(%eax)
  803d81:	eb 0a                	jmp    803d8d <alloc_block_BF+0x199>
  803d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d86:	8b 00                	mov    (%eax),%eax
  803d88:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da0:	a1 38 70 80 00       	mov    0x807038,%eax
  803da5:	48                   	dec    %eax
  803da6:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  803dab:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803dae:	e9 24 04 00 00       	jmp    8041d7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803db6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803db9:	76 13                	jbe    803dce <alloc_block_BF+0x1da>
					{
						internal = 1;
  803dbb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803dc2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803dc8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803dce:	a1 34 70 80 00       	mov    0x807034,%eax
  803dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dda:	74 07                	je     803de3 <alloc_block_BF+0x1ef>
  803ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddf:	8b 00                	mov    (%eax),%eax
  803de1:	eb 05                	jmp    803de8 <alloc_block_BF+0x1f4>
  803de3:	b8 00 00 00 00       	mov    $0x0,%eax
  803de8:	a3 34 70 80 00       	mov    %eax,0x807034
  803ded:	a1 34 70 80 00       	mov    0x807034,%eax
  803df2:	85 c0                	test   %eax,%eax
  803df4:	0f 85 bf fe ff ff    	jne    803cb9 <alloc_block_BF+0xc5>
  803dfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dfe:	0f 85 b5 fe ff ff    	jne    803cb9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803e04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e08:	0f 84 26 02 00 00    	je     804034 <alloc_block_BF+0x440>
  803e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e12:	0f 85 1c 02 00 00    	jne    804034 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1b:	2b 45 08             	sub    0x8(%ebp),%eax
  803e1e:	83 e8 08             	sub    $0x8,%eax
  803e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803e24:	8b 45 08             	mov    0x8(%ebp),%eax
  803e27:	8d 50 08             	lea    0x8(%eax),%edx
  803e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2d:	01 d0                	add    %edx,%eax
  803e2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803e32:	8b 45 08             	mov    0x8(%ebp),%eax
  803e35:	83 c0 08             	add    $0x8,%eax
  803e38:	83 ec 04             	sub    $0x4,%esp
  803e3b:	6a 01                	push   $0x1
  803e3d:	50                   	push   %eax
  803e3e:	ff 75 f0             	pushl  -0x10(%ebp)
  803e41:	e8 c3 f8 ff ff       	call   803709 <set_block_data>
  803e46:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4c:	8b 40 04             	mov    0x4(%eax),%eax
  803e4f:	85 c0                	test   %eax,%eax
  803e51:	75 68                	jne    803ebb <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803e53:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e57:	75 17                	jne    803e70 <alloc_block_BF+0x27c>
  803e59:	83 ec 04             	sub    $0x4,%esp
  803e5c:	68 2c 6a 80 00       	push   $0x806a2c
  803e61:	68 45 01 00 00       	push   $0x145
  803e66:	68 11 6a 80 00       	push   $0x806a11
  803e6b:	e8 83 d9 ff ff       	call   8017f3 <_panic>
  803e70:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803e76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e79:	89 10                	mov    %edx,(%eax)
  803e7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e7e:	8b 00                	mov    (%eax),%eax
  803e80:	85 c0                	test   %eax,%eax
  803e82:	74 0d                	je     803e91 <alloc_block_BF+0x29d>
  803e84:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803e89:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e8c:	89 50 04             	mov    %edx,0x4(%eax)
  803e8f:	eb 08                	jmp    803e99 <alloc_block_BF+0x2a5>
  803e91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e94:	a3 30 70 80 00       	mov    %eax,0x807030
  803e99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e9c:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803ea1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eab:	a1 38 70 80 00       	mov    0x807038,%eax
  803eb0:	40                   	inc    %eax
  803eb1:	a3 38 70 80 00       	mov    %eax,0x807038
  803eb6:	e9 dc 00 00 00       	jmp    803f97 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ebe:	8b 00                	mov    (%eax),%eax
  803ec0:	85 c0                	test   %eax,%eax
  803ec2:	75 65                	jne    803f29 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803ec4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803ec8:	75 17                	jne    803ee1 <alloc_block_BF+0x2ed>
  803eca:	83 ec 04             	sub    $0x4,%esp
  803ecd:	68 60 6a 80 00       	push   $0x806a60
  803ed2:	68 4a 01 00 00       	push   $0x14a
  803ed7:	68 11 6a 80 00       	push   $0x806a11
  803edc:	e8 12 d9 ff ff       	call   8017f3 <_panic>
  803ee1:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803ee7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ef0:	8b 40 04             	mov    0x4(%eax),%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	74 0c                	je     803f03 <alloc_block_BF+0x30f>
  803ef7:	a1 30 70 80 00       	mov    0x807030,%eax
  803efc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803eff:	89 10                	mov    %edx,(%eax)
  803f01:	eb 08                	jmp    803f0b <alloc_block_BF+0x317>
  803f03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f06:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803f0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f0e:	a3 30 70 80 00       	mov    %eax,0x807030
  803f13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f1c:	a1 38 70 80 00       	mov    0x807038,%eax
  803f21:	40                   	inc    %eax
  803f22:	a3 38 70 80 00       	mov    %eax,0x807038
  803f27:	eb 6e                	jmp    803f97 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803f29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f2d:	74 06                	je     803f35 <alloc_block_BF+0x341>
  803f2f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f33:	75 17                	jne    803f4c <alloc_block_BF+0x358>
  803f35:	83 ec 04             	sub    $0x4,%esp
  803f38:	68 84 6a 80 00       	push   $0x806a84
  803f3d:	68 4f 01 00 00       	push   $0x14f
  803f42:	68 11 6a 80 00       	push   $0x806a11
  803f47:	e8 a7 d8 ff ff       	call   8017f3 <_panic>
  803f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4f:	8b 10                	mov    (%eax),%edx
  803f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f54:	89 10                	mov    %edx,(%eax)
  803f56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f59:	8b 00                	mov    (%eax),%eax
  803f5b:	85 c0                	test   %eax,%eax
  803f5d:	74 0b                	je     803f6a <alloc_block_BF+0x376>
  803f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f62:	8b 00                	mov    (%eax),%eax
  803f64:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f67:	89 50 04             	mov    %edx,0x4(%eax)
  803f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f70:	89 10                	mov    %edx,(%eax)
  803f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f78:	89 50 04             	mov    %edx,0x4(%eax)
  803f7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f7e:	8b 00                	mov    (%eax),%eax
  803f80:	85 c0                	test   %eax,%eax
  803f82:	75 08                	jne    803f8c <alloc_block_BF+0x398>
  803f84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f87:	a3 30 70 80 00       	mov    %eax,0x807030
  803f8c:	a1 38 70 80 00       	mov    0x807038,%eax
  803f91:	40                   	inc    %eax
  803f92:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f9b:	75 17                	jne    803fb4 <alloc_block_BF+0x3c0>
  803f9d:	83 ec 04             	sub    $0x4,%esp
  803fa0:	68 f3 69 80 00       	push   $0x8069f3
  803fa5:	68 51 01 00 00       	push   $0x151
  803faa:	68 11 6a 80 00       	push   $0x806a11
  803faf:	e8 3f d8 ff ff       	call   8017f3 <_panic>
  803fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb7:	8b 00                	mov    (%eax),%eax
  803fb9:	85 c0                	test   %eax,%eax
  803fbb:	74 10                	je     803fcd <alloc_block_BF+0x3d9>
  803fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc0:	8b 00                	mov    (%eax),%eax
  803fc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc5:	8b 52 04             	mov    0x4(%edx),%edx
  803fc8:	89 50 04             	mov    %edx,0x4(%eax)
  803fcb:	eb 0b                	jmp    803fd8 <alloc_block_BF+0x3e4>
  803fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd0:	8b 40 04             	mov    0x4(%eax),%eax
  803fd3:	a3 30 70 80 00       	mov    %eax,0x807030
  803fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdb:	8b 40 04             	mov    0x4(%eax),%eax
  803fde:	85 c0                	test   %eax,%eax
  803fe0:	74 0f                	je     803ff1 <alloc_block_BF+0x3fd>
  803fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe5:	8b 40 04             	mov    0x4(%eax),%eax
  803fe8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803feb:	8b 12                	mov    (%edx),%edx
  803fed:	89 10                	mov    %edx,(%eax)
  803fef:	eb 0a                	jmp    803ffb <alloc_block_BF+0x407>
  803ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff4:	8b 00                	mov    (%eax),%eax
  803ff6:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ffe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804007:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80400e:	a1 38 70 80 00       	mov    0x807038,%eax
  804013:	48                   	dec    %eax
  804014:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  804019:	83 ec 04             	sub    $0x4,%esp
  80401c:	6a 00                	push   $0x0
  80401e:	ff 75 d0             	pushl  -0x30(%ebp)
  804021:	ff 75 cc             	pushl  -0x34(%ebp)
  804024:	e8 e0 f6 ff ff       	call   803709 <set_block_data>
  804029:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80402c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402f:	e9 a3 01 00 00       	jmp    8041d7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  804034:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  804038:	0f 85 9d 00 00 00    	jne    8040db <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80403e:	83 ec 04             	sub    $0x4,%esp
  804041:	6a 01                	push   $0x1
  804043:	ff 75 ec             	pushl  -0x14(%ebp)
  804046:	ff 75 f0             	pushl  -0x10(%ebp)
  804049:	e8 bb f6 ff ff       	call   803709 <set_block_data>
  80404e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  804051:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804055:	75 17                	jne    80406e <alloc_block_BF+0x47a>
  804057:	83 ec 04             	sub    $0x4,%esp
  80405a:	68 f3 69 80 00       	push   $0x8069f3
  80405f:	68 58 01 00 00       	push   $0x158
  804064:	68 11 6a 80 00       	push   $0x806a11
  804069:	e8 85 d7 ff ff       	call   8017f3 <_panic>
  80406e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804071:	8b 00                	mov    (%eax),%eax
  804073:	85 c0                	test   %eax,%eax
  804075:	74 10                	je     804087 <alloc_block_BF+0x493>
  804077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407a:	8b 00                	mov    (%eax),%eax
  80407c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80407f:	8b 52 04             	mov    0x4(%edx),%edx
  804082:	89 50 04             	mov    %edx,0x4(%eax)
  804085:	eb 0b                	jmp    804092 <alloc_block_BF+0x49e>
  804087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80408a:	8b 40 04             	mov    0x4(%eax),%eax
  80408d:	a3 30 70 80 00       	mov    %eax,0x807030
  804092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804095:	8b 40 04             	mov    0x4(%eax),%eax
  804098:	85 c0                	test   %eax,%eax
  80409a:	74 0f                	je     8040ab <alloc_block_BF+0x4b7>
  80409c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409f:	8b 40 04             	mov    0x4(%eax),%eax
  8040a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040a5:	8b 12                	mov    (%edx),%edx
  8040a7:	89 10                	mov    %edx,(%eax)
  8040a9:	eb 0a                	jmp    8040b5 <alloc_block_BF+0x4c1>
  8040ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8040b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040c8:	a1 38 70 80 00       	mov    0x807038,%eax
  8040cd:	48                   	dec    %eax
  8040ce:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  8040d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d6:	e9 fc 00 00 00       	jmp    8041d7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8040db:	8b 45 08             	mov    0x8(%ebp),%eax
  8040de:	83 c0 08             	add    $0x8,%eax
  8040e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8040e4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8040eb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040f1:	01 d0                	add    %edx,%eax
  8040f3:	48                   	dec    %eax
  8040f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8040f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8040fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8040ff:	f7 75 c4             	divl   -0x3c(%ebp)
  804102:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804105:	29 d0                	sub    %edx,%eax
  804107:	c1 e8 0c             	shr    $0xc,%eax
  80410a:	83 ec 0c             	sub    $0xc,%esp
  80410d:	50                   	push   %eax
  80410e:	e8 37 e7 ff ff       	call   80284a <sbrk>
  804113:	83 c4 10             	add    $0x10,%esp
  804116:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  804119:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80411d:	75 0a                	jne    804129 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80411f:	b8 00 00 00 00       	mov    $0x0,%eax
  804124:	e9 ae 00 00 00       	jmp    8041d7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  804129:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  804130:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804133:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804136:	01 d0                	add    %edx,%eax
  804138:	48                   	dec    %eax
  804139:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80413c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80413f:	ba 00 00 00 00       	mov    $0x0,%edx
  804144:	f7 75 b8             	divl   -0x48(%ebp)
  804147:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80414a:	29 d0                	sub    %edx,%eax
  80414c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80414f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  804152:	01 d0                	add    %edx,%eax
  804154:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  804159:	a1 40 70 80 00       	mov    0x807040,%eax
  80415e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  804164:	83 ec 0c             	sub    $0xc,%esp
  804167:	68 b8 6a 80 00       	push   $0x806ab8
  80416c:	e8 3f d9 ff ff       	call   801ab0 <cprintf>
  804171:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  804174:	83 ec 08             	sub    $0x8,%esp
  804177:	ff 75 bc             	pushl  -0x44(%ebp)
  80417a:	68 bd 6a 80 00       	push   $0x806abd
  80417f:	e8 2c d9 ff ff       	call   801ab0 <cprintf>
  804184:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  804187:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80418e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804191:	8b 45 b0             	mov    -0x50(%ebp),%eax
  804194:	01 d0                	add    %edx,%eax
  804196:	48                   	dec    %eax
  804197:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80419a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80419d:	ba 00 00 00 00       	mov    $0x0,%edx
  8041a2:	f7 75 b0             	divl   -0x50(%ebp)
  8041a5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8041a8:	29 d0                	sub    %edx,%eax
  8041aa:	83 ec 04             	sub    $0x4,%esp
  8041ad:	6a 01                	push   $0x1
  8041af:	50                   	push   %eax
  8041b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8041b3:	e8 51 f5 ff ff       	call   803709 <set_block_data>
  8041b8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8041bb:	83 ec 0c             	sub    $0xc,%esp
  8041be:	ff 75 bc             	pushl  -0x44(%ebp)
  8041c1:	e8 36 04 00 00       	call   8045fc <free_block>
  8041c6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8041c9:	83 ec 0c             	sub    $0xc,%esp
  8041cc:	ff 75 08             	pushl  0x8(%ebp)
  8041cf:	e8 20 fa ff ff       	call   803bf4 <alloc_block_BF>
  8041d4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8041d7:	c9                   	leave  
  8041d8:	c3                   	ret    

008041d9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8041d9:	55                   	push   %ebp
  8041da:	89 e5                	mov    %esp,%ebp
  8041dc:	53                   	push   %ebx
  8041dd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8041e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8041e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8041ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041f2:	74 1e                	je     804212 <merging+0x39>
  8041f4:	ff 75 08             	pushl  0x8(%ebp)
  8041f7:	e8 bc f1 ff ff       	call   8033b8 <get_block_size>
  8041fc:	83 c4 04             	add    $0x4,%esp
  8041ff:	89 c2                	mov    %eax,%edx
  804201:	8b 45 08             	mov    0x8(%ebp),%eax
  804204:	01 d0                	add    %edx,%eax
  804206:	3b 45 10             	cmp    0x10(%ebp),%eax
  804209:	75 07                	jne    804212 <merging+0x39>
		prev_is_free = 1;
  80420b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  804212:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804216:	74 1e                	je     804236 <merging+0x5d>
  804218:	ff 75 10             	pushl  0x10(%ebp)
  80421b:	e8 98 f1 ff ff       	call   8033b8 <get_block_size>
  804220:	83 c4 04             	add    $0x4,%esp
  804223:	89 c2                	mov    %eax,%edx
  804225:	8b 45 10             	mov    0x10(%ebp),%eax
  804228:	01 d0                	add    %edx,%eax
  80422a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80422d:	75 07                	jne    804236 <merging+0x5d>
		next_is_free = 1;
  80422f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  804236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80423a:	0f 84 cc 00 00 00    	je     80430c <merging+0x133>
  804240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804244:	0f 84 c2 00 00 00    	je     80430c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80424a:	ff 75 08             	pushl  0x8(%ebp)
  80424d:	e8 66 f1 ff ff       	call   8033b8 <get_block_size>
  804252:	83 c4 04             	add    $0x4,%esp
  804255:	89 c3                	mov    %eax,%ebx
  804257:	ff 75 10             	pushl  0x10(%ebp)
  80425a:	e8 59 f1 ff ff       	call   8033b8 <get_block_size>
  80425f:	83 c4 04             	add    $0x4,%esp
  804262:	01 c3                	add    %eax,%ebx
  804264:	ff 75 0c             	pushl  0xc(%ebp)
  804267:	e8 4c f1 ff ff       	call   8033b8 <get_block_size>
  80426c:	83 c4 04             	add    $0x4,%esp
  80426f:	01 d8                	add    %ebx,%eax
  804271:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804274:	6a 00                	push   $0x0
  804276:	ff 75 ec             	pushl  -0x14(%ebp)
  804279:	ff 75 08             	pushl  0x8(%ebp)
  80427c:	e8 88 f4 ff ff       	call   803709 <set_block_data>
  804281:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  804284:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804288:	75 17                	jne    8042a1 <merging+0xc8>
  80428a:	83 ec 04             	sub    $0x4,%esp
  80428d:	68 f3 69 80 00       	push   $0x8069f3
  804292:	68 7d 01 00 00       	push   $0x17d
  804297:	68 11 6a 80 00       	push   $0x806a11
  80429c:	e8 52 d5 ff ff       	call   8017f3 <_panic>
  8042a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042a4:	8b 00                	mov    (%eax),%eax
  8042a6:	85 c0                	test   %eax,%eax
  8042a8:	74 10                	je     8042ba <merging+0xe1>
  8042aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042ad:	8b 00                	mov    (%eax),%eax
  8042af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042b2:	8b 52 04             	mov    0x4(%edx),%edx
  8042b5:	89 50 04             	mov    %edx,0x4(%eax)
  8042b8:	eb 0b                	jmp    8042c5 <merging+0xec>
  8042ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042bd:	8b 40 04             	mov    0x4(%eax),%eax
  8042c0:	a3 30 70 80 00       	mov    %eax,0x807030
  8042c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042c8:	8b 40 04             	mov    0x4(%eax),%eax
  8042cb:	85 c0                	test   %eax,%eax
  8042cd:	74 0f                	je     8042de <merging+0x105>
  8042cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d2:	8b 40 04             	mov    0x4(%eax),%eax
  8042d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042d8:	8b 12                	mov    (%edx),%edx
  8042da:	89 10                	mov    %edx,(%eax)
  8042dc:	eb 0a                	jmp    8042e8 <merging+0x10f>
  8042de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042e1:	8b 00                	mov    (%eax),%eax
  8042e3:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042fb:	a1 38 70 80 00       	mov    0x807038,%eax
  804300:	48                   	dec    %eax
  804301:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804306:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804307:	e9 ea 02 00 00       	jmp    8045f6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80430c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804310:	74 3b                	je     80434d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  804312:	83 ec 0c             	sub    $0xc,%esp
  804315:	ff 75 08             	pushl  0x8(%ebp)
  804318:	e8 9b f0 ff ff       	call   8033b8 <get_block_size>
  80431d:	83 c4 10             	add    $0x10,%esp
  804320:	89 c3                	mov    %eax,%ebx
  804322:	83 ec 0c             	sub    $0xc,%esp
  804325:	ff 75 10             	pushl  0x10(%ebp)
  804328:	e8 8b f0 ff ff       	call   8033b8 <get_block_size>
  80432d:	83 c4 10             	add    $0x10,%esp
  804330:	01 d8                	add    %ebx,%eax
  804332:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804335:	83 ec 04             	sub    $0x4,%esp
  804338:	6a 00                	push   $0x0
  80433a:	ff 75 e8             	pushl  -0x18(%ebp)
  80433d:	ff 75 08             	pushl  0x8(%ebp)
  804340:	e8 c4 f3 ff ff       	call   803709 <set_block_data>
  804345:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804348:	e9 a9 02 00 00       	jmp    8045f6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80434d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804351:	0f 84 2d 01 00 00    	je     804484 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  804357:	83 ec 0c             	sub    $0xc,%esp
  80435a:	ff 75 10             	pushl  0x10(%ebp)
  80435d:	e8 56 f0 ff ff       	call   8033b8 <get_block_size>
  804362:	83 c4 10             	add    $0x10,%esp
  804365:	89 c3                	mov    %eax,%ebx
  804367:	83 ec 0c             	sub    $0xc,%esp
  80436a:	ff 75 0c             	pushl  0xc(%ebp)
  80436d:	e8 46 f0 ff ff       	call   8033b8 <get_block_size>
  804372:	83 c4 10             	add    $0x10,%esp
  804375:	01 d8                	add    %ebx,%eax
  804377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80437a:	83 ec 04             	sub    $0x4,%esp
  80437d:	6a 00                	push   $0x0
  80437f:	ff 75 e4             	pushl  -0x1c(%ebp)
  804382:	ff 75 10             	pushl  0x10(%ebp)
  804385:	e8 7f f3 ff ff       	call   803709 <set_block_data>
  80438a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80438d:	8b 45 10             	mov    0x10(%ebp),%eax
  804390:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  804393:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804397:	74 06                	je     80439f <merging+0x1c6>
  804399:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80439d:	75 17                	jne    8043b6 <merging+0x1dd>
  80439f:	83 ec 04             	sub    $0x4,%esp
  8043a2:	68 cc 6a 80 00       	push   $0x806acc
  8043a7:	68 8d 01 00 00       	push   $0x18d
  8043ac:	68 11 6a 80 00       	push   $0x806a11
  8043b1:	e8 3d d4 ff ff       	call   8017f3 <_panic>
  8043b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043b9:	8b 50 04             	mov    0x4(%eax),%edx
  8043bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043bf:	89 50 04             	mov    %edx,0x4(%eax)
  8043c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043c8:	89 10                	mov    %edx,(%eax)
  8043ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043cd:	8b 40 04             	mov    0x4(%eax),%eax
  8043d0:	85 c0                	test   %eax,%eax
  8043d2:	74 0d                	je     8043e1 <merging+0x208>
  8043d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043d7:	8b 40 04             	mov    0x4(%eax),%eax
  8043da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043dd:	89 10                	mov    %edx,(%eax)
  8043df:	eb 08                	jmp    8043e9 <merging+0x210>
  8043e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043e4:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8043e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043ef:	89 50 04             	mov    %edx,0x4(%eax)
  8043f2:	a1 38 70 80 00       	mov    0x807038,%eax
  8043f7:	40                   	inc    %eax
  8043f8:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  8043fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804401:	75 17                	jne    80441a <merging+0x241>
  804403:	83 ec 04             	sub    $0x4,%esp
  804406:	68 f3 69 80 00       	push   $0x8069f3
  80440b:	68 8e 01 00 00       	push   $0x18e
  804410:	68 11 6a 80 00       	push   $0x806a11
  804415:	e8 d9 d3 ff ff       	call   8017f3 <_panic>
  80441a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80441d:	8b 00                	mov    (%eax),%eax
  80441f:	85 c0                	test   %eax,%eax
  804421:	74 10                	je     804433 <merging+0x25a>
  804423:	8b 45 0c             	mov    0xc(%ebp),%eax
  804426:	8b 00                	mov    (%eax),%eax
  804428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80442b:	8b 52 04             	mov    0x4(%edx),%edx
  80442e:	89 50 04             	mov    %edx,0x4(%eax)
  804431:	eb 0b                	jmp    80443e <merging+0x265>
  804433:	8b 45 0c             	mov    0xc(%ebp),%eax
  804436:	8b 40 04             	mov    0x4(%eax),%eax
  804439:	a3 30 70 80 00       	mov    %eax,0x807030
  80443e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804441:	8b 40 04             	mov    0x4(%eax),%eax
  804444:	85 c0                	test   %eax,%eax
  804446:	74 0f                	je     804457 <merging+0x27e>
  804448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80444b:	8b 40 04             	mov    0x4(%eax),%eax
  80444e:	8b 55 0c             	mov    0xc(%ebp),%edx
  804451:	8b 12                	mov    (%edx),%edx
  804453:	89 10                	mov    %edx,(%eax)
  804455:	eb 0a                	jmp    804461 <merging+0x288>
  804457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80445a:	8b 00                	mov    (%eax),%eax
  80445c:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804461:	8b 45 0c             	mov    0xc(%ebp),%eax
  804464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80446a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80446d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804474:	a1 38 70 80 00       	mov    0x807038,%eax
  804479:	48                   	dec    %eax
  80447a:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80447f:	e9 72 01 00 00       	jmp    8045f6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  804484:	8b 45 10             	mov    0x10(%ebp),%eax
  804487:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80448a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80448e:	74 79                	je     804509 <merging+0x330>
  804490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804494:	74 73                	je     804509 <merging+0x330>
  804496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80449a:	74 06                	je     8044a2 <merging+0x2c9>
  80449c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8044a0:	75 17                	jne    8044b9 <merging+0x2e0>
  8044a2:	83 ec 04             	sub    $0x4,%esp
  8044a5:	68 84 6a 80 00       	push   $0x806a84
  8044aa:	68 94 01 00 00       	push   $0x194
  8044af:	68 11 6a 80 00       	push   $0x806a11
  8044b4:	e8 3a d3 ff ff       	call   8017f3 <_panic>
  8044b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044bc:	8b 10                	mov    (%eax),%edx
  8044be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c1:	89 10                	mov    %edx,(%eax)
  8044c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c6:	8b 00                	mov    (%eax),%eax
  8044c8:	85 c0                	test   %eax,%eax
  8044ca:	74 0b                	je     8044d7 <merging+0x2fe>
  8044cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8044cf:	8b 00                	mov    (%eax),%eax
  8044d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044d4:	89 50 04             	mov    %edx,0x4(%eax)
  8044d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044dd:	89 10                	mov    %edx,(%eax)
  8044df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8044e5:	89 50 04             	mov    %edx,0x4(%eax)
  8044e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044eb:	8b 00                	mov    (%eax),%eax
  8044ed:	85 c0                	test   %eax,%eax
  8044ef:	75 08                	jne    8044f9 <merging+0x320>
  8044f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044f4:	a3 30 70 80 00       	mov    %eax,0x807030
  8044f9:	a1 38 70 80 00       	mov    0x807038,%eax
  8044fe:	40                   	inc    %eax
  8044ff:	a3 38 70 80 00       	mov    %eax,0x807038
  804504:	e9 ce 00 00 00       	jmp    8045d7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  804509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80450d:	74 65                	je     804574 <merging+0x39b>
  80450f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804513:	75 17                	jne    80452c <merging+0x353>
  804515:	83 ec 04             	sub    $0x4,%esp
  804518:	68 60 6a 80 00       	push   $0x806a60
  80451d:	68 95 01 00 00       	push   $0x195
  804522:	68 11 6a 80 00       	push   $0x806a11
  804527:	e8 c7 d2 ff ff       	call   8017f3 <_panic>
  80452c:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804532:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804535:	89 50 04             	mov    %edx,0x4(%eax)
  804538:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80453b:	8b 40 04             	mov    0x4(%eax),%eax
  80453e:	85 c0                	test   %eax,%eax
  804540:	74 0c                	je     80454e <merging+0x375>
  804542:	a1 30 70 80 00       	mov    0x807030,%eax
  804547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80454a:	89 10                	mov    %edx,(%eax)
  80454c:	eb 08                	jmp    804556 <merging+0x37d>
  80454e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804551:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804556:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804559:	a3 30 70 80 00       	mov    %eax,0x807030
  80455e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804567:	a1 38 70 80 00       	mov    0x807038,%eax
  80456c:	40                   	inc    %eax
  80456d:	a3 38 70 80 00       	mov    %eax,0x807038
  804572:	eb 63                	jmp    8045d7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  804574:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804578:	75 17                	jne    804591 <merging+0x3b8>
  80457a:	83 ec 04             	sub    $0x4,%esp
  80457d:	68 2c 6a 80 00       	push   $0x806a2c
  804582:	68 98 01 00 00       	push   $0x198
  804587:	68 11 6a 80 00       	push   $0x806a11
  80458c:	e8 62 d2 ff ff       	call   8017f3 <_panic>
  804591:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  804597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80459a:	89 10                	mov    %edx,(%eax)
  80459c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80459f:	8b 00                	mov    (%eax),%eax
  8045a1:	85 c0                	test   %eax,%eax
  8045a3:	74 0d                	je     8045b2 <merging+0x3d9>
  8045a5:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8045ad:	89 50 04             	mov    %edx,0x4(%eax)
  8045b0:	eb 08                	jmp    8045ba <merging+0x3e1>
  8045b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045b5:	a3 30 70 80 00       	mov    %eax,0x807030
  8045ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045bd:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8045c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045cc:	a1 38 70 80 00       	mov    0x807038,%eax
  8045d1:	40                   	inc    %eax
  8045d2:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  8045d7:	83 ec 0c             	sub    $0xc,%esp
  8045da:	ff 75 10             	pushl  0x10(%ebp)
  8045dd:	e8 d6 ed ff ff       	call   8033b8 <get_block_size>
  8045e2:	83 c4 10             	add    $0x10,%esp
  8045e5:	83 ec 04             	sub    $0x4,%esp
  8045e8:	6a 00                	push   $0x0
  8045ea:	50                   	push   %eax
  8045eb:	ff 75 10             	pushl  0x10(%ebp)
  8045ee:	e8 16 f1 ff ff       	call   803709 <set_block_data>
  8045f3:	83 c4 10             	add    $0x10,%esp
	}
}
  8045f6:	90                   	nop
  8045f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8045fa:	c9                   	leave  
  8045fb:	c3                   	ret    

008045fc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8045fc:	55                   	push   %ebp
  8045fd:	89 e5                	mov    %esp,%ebp
  8045ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804602:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804607:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80460a:	a1 30 70 80 00       	mov    0x807030,%eax
  80460f:	3b 45 08             	cmp    0x8(%ebp),%eax
  804612:	73 1b                	jae    80462f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804614:	a1 30 70 80 00       	mov    0x807030,%eax
  804619:	83 ec 04             	sub    $0x4,%esp
  80461c:	ff 75 08             	pushl  0x8(%ebp)
  80461f:	6a 00                	push   $0x0
  804621:	50                   	push   %eax
  804622:	e8 b2 fb ff ff       	call   8041d9 <merging>
  804627:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80462a:	e9 8b 00 00 00       	jmp    8046ba <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80462f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804634:	3b 45 08             	cmp    0x8(%ebp),%eax
  804637:	76 18                	jbe    804651 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804639:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80463e:	83 ec 04             	sub    $0x4,%esp
  804641:	ff 75 08             	pushl  0x8(%ebp)
  804644:	50                   	push   %eax
  804645:	6a 00                	push   $0x0
  804647:	e8 8d fb ff ff       	call   8041d9 <merging>
  80464c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80464f:	eb 69                	jmp    8046ba <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804651:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804659:	eb 39                	jmp    804694 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80465e:	3b 45 08             	cmp    0x8(%ebp),%eax
  804661:	73 29                	jae    80468c <free_block+0x90>
  804663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804666:	8b 00                	mov    (%eax),%eax
  804668:	3b 45 08             	cmp    0x8(%ebp),%eax
  80466b:	76 1f                	jbe    80468c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80466d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804670:	8b 00                	mov    (%eax),%eax
  804672:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804675:	83 ec 04             	sub    $0x4,%esp
  804678:	ff 75 08             	pushl  0x8(%ebp)
  80467b:	ff 75 f0             	pushl  -0x10(%ebp)
  80467e:	ff 75 f4             	pushl  -0xc(%ebp)
  804681:	e8 53 fb ff ff       	call   8041d9 <merging>
  804686:	83 c4 10             	add    $0x10,%esp
			break;
  804689:	90                   	nop
		}
	}
}
  80468a:	eb 2e                	jmp    8046ba <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80468c:	a1 34 70 80 00       	mov    0x807034,%eax
  804691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804698:	74 07                	je     8046a1 <free_block+0xa5>
  80469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80469d:	8b 00                	mov    (%eax),%eax
  80469f:	eb 05                	jmp    8046a6 <free_block+0xaa>
  8046a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a6:	a3 34 70 80 00       	mov    %eax,0x807034
  8046ab:	a1 34 70 80 00       	mov    0x807034,%eax
  8046b0:	85 c0                	test   %eax,%eax
  8046b2:	75 a7                	jne    80465b <free_block+0x5f>
  8046b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8046b8:	75 a1                	jne    80465b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8046ba:	90                   	nop
  8046bb:	c9                   	leave  
  8046bc:	c3                   	ret    

008046bd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8046bd:	55                   	push   %ebp
  8046be:	89 e5                	mov    %esp,%ebp
  8046c0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8046c3:	ff 75 08             	pushl  0x8(%ebp)
  8046c6:	e8 ed ec ff ff       	call   8033b8 <get_block_size>
  8046cb:	83 c4 04             	add    $0x4,%esp
  8046ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8046d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8046d8:	eb 17                	jmp    8046f1 <copy_data+0x34>
  8046da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8046dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046e0:	01 c2                	add    %eax,%edx
  8046e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8046e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e8:	01 c8                	add    %ecx,%eax
  8046ea:	8a 00                	mov    (%eax),%al
  8046ec:	88 02                	mov    %al,(%edx)
  8046ee:	ff 45 fc             	incl   -0x4(%ebp)
  8046f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8046f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8046f7:	72 e1                	jb     8046da <copy_data+0x1d>
}
  8046f9:	90                   	nop
  8046fa:	c9                   	leave  
  8046fb:	c3                   	ret    

008046fc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8046fc:	55                   	push   %ebp
  8046fd:	89 e5                	mov    %esp,%ebp
  8046ff:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804702:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804706:	75 23                	jne    80472b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  804708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80470c:	74 13                	je     804721 <realloc_block_FF+0x25>
  80470e:	83 ec 0c             	sub    $0xc,%esp
  804711:	ff 75 0c             	pushl  0xc(%ebp)
  804714:	e8 1f f0 ff ff       	call   803738 <alloc_block_FF>
  804719:	83 c4 10             	add    $0x10,%esp
  80471c:	e9 f4 06 00 00       	jmp    804e15 <realloc_block_FF+0x719>
		return NULL;
  804721:	b8 00 00 00 00       	mov    $0x0,%eax
  804726:	e9 ea 06 00 00       	jmp    804e15 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80472b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80472f:	75 18                	jne    804749 <realloc_block_FF+0x4d>
	{
		free_block(va);
  804731:	83 ec 0c             	sub    $0xc,%esp
  804734:	ff 75 08             	pushl  0x8(%ebp)
  804737:	e8 c0 fe ff ff       	call   8045fc <free_block>
  80473c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80473f:	b8 00 00 00 00       	mov    $0x0,%eax
  804744:	e9 cc 06 00 00       	jmp    804e15 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  804749:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80474d:	77 07                	ja     804756 <realloc_block_FF+0x5a>
  80474f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804756:	8b 45 0c             	mov    0xc(%ebp),%eax
  804759:	83 e0 01             	and    $0x1,%eax
  80475c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80475f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804762:	83 c0 08             	add    $0x8,%eax
  804765:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804768:	83 ec 0c             	sub    $0xc,%esp
  80476b:	ff 75 08             	pushl  0x8(%ebp)
  80476e:	e8 45 ec ff ff       	call   8033b8 <get_block_size>
  804773:	83 c4 10             	add    $0x10,%esp
  804776:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80477c:	83 e8 08             	sub    $0x8,%eax
  80477f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804782:	8b 45 08             	mov    0x8(%ebp),%eax
  804785:	83 e8 04             	sub    $0x4,%eax
  804788:	8b 00                	mov    (%eax),%eax
  80478a:	83 e0 fe             	and    $0xfffffffe,%eax
  80478d:	89 c2                	mov    %eax,%edx
  80478f:	8b 45 08             	mov    0x8(%ebp),%eax
  804792:	01 d0                	add    %edx,%eax
  804794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804797:	83 ec 0c             	sub    $0xc,%esp
  80479a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80479d:	e8 16 ec ff ff       	call   8033b8 <get_block_size>
  8047a2:	83 c4 10             	add    $0x10,%esp
  8047a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8047a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8047ab:	83 e8 08             	sub    $0x8,%eax
  8047ae:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8047b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8047b4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8047b7:	75 08                	jne    8047c1 <realloc_block_FF+0xc5>
	{
		 return va;
  8047b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8047bc:	e9 54 06 00 00       	jmp    804e15 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8047c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8047c4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8047c7:	0f 83 e5 03 00 00    	jae    804bb2 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8047cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047d0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8047d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8047d6:	83 ec 0c             	sub    $0xc,%esp
  8047d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8047dc:	e8 f0 eb ff ff       	call   8033d1 <is_free_block>
  8047e1:	83 c4 10             	add    $0x10,%esp
  8047e4:	84 c0                	test   %al,%al
  8047e6:	0f 84 3b 01 00 00    	je     804927 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8047ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8047ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8047f2:	01 d0                	add    %edx,%eax
  8047f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8047f7:	83 ec 04             	sub    $0x4,%esp
  8047fa:	6a 01                	push   $0x1
  8047fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8047ff:	ff 75 08             	pushl  0x8(%ebp)
  804802:	e8 02 ef ff ff       	call   803709 <set_block_data>
  804807:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80480a:	8b 45 08             	mov    0x8(%ebp),%eax
  80480d:	83 e8 04             	sub    $0x4,%eax
  804810:	8b 00                	mov    (%eax),%eax
  804812:	83 e0 fe             	and    $0xfffffffe,%eax
  804815:	89 c2                	mov    %eax,%edx
  804817:	8b 45 08             	mov    0x8(%ebp),%eax
  80481a:	01 d0                	add    %edx,%eax
  80481c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80481f:	83 ec 04             	sub    $0x4,%esp
  804822:	6a 00                	push   $0x0
  804824:	ff 75 cc             	pushl  -0x34(%ebp)
  804827:	ff 75 c8             	pushl  -0x38(%ebp)
  80482a:	e8 da ee ff ff       	call   803709 <set_block_data>
  80482f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804836:	74 06                	je     80483e <realloc_block_FF+0x142>
  804838:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80483c:	75 17                	jne    804855 <realloc_block_FF+0x159>
  80483e:	83 ec 04             	sub    $0x4,%esp
  804841:	68 84 6a 80 00       	push   $0x806a84
  804846:	68 f6 01 00 00       	push   $0x1f6
  80484b:	68 11 6a 80 00       	push   $0x806a11
  804850:	e8 9e cf ff ff       	call   8017f3 <_panic>
  804855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804858:	8b 10                	mov    (%eax),%edx
  80485a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80485d:	89 10                	mov    %edx,(%eax)
  80485f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804862:	8b 00                	mov    (%eax),%eax
  804864:	85 c0                	test   %eax,%eax
  804866:	74 0b                	je     804873 <realloc_block_FF+0x177>
  804868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80486b:	8b 00                	mov    (%eax),%eax
  80486d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804870:	89 50 04             	mov    %edx,0x4(%eax)
  804873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804876:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804879:	89 10                	mov    %edx,(%eax)
  80487b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80487e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804881:	89 50 04             	mov    %edx,0x4(%eax)
  804884:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804887:	8b 00                	mov    (%eax),%eax
  804889:	85 c0                	test   %eax,%eax
  80488b:	75 08                	jne    804895 <realloc_block_FF+0x199>
  80488d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804890:	a3 30 70 80 00       	mov    %eax,0x807030
  804895:	a1 38 70 80 00       	mov    0x807038,%eax
  80489a:	40                   	inc    %eax
  80489b:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8048a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8048a4:	75 17                	jne    8048bd <realloc_block_FF+0x1c1>
  8048a6:	83 ec 04             	sub    $0x4,%esp
  8048a9:	68 f3 69 80 00       	push   $0x8069f3
  8048ae:	68 f7 01 00 00       	push   $0x1f7
  8048b3:	68 11 6a 80 00       	push   $0x806a11
  8048b8:	e8 36 cf ff ff       	call   8017f3 <_panic>
  8048bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048c0:	8b 00                	mov    (%eax),%eax
  8048c2:	85 c0                	test   %eax,%eax
  8048c4:	74 10                	je     8048d6 <realloc_block_FF+0x1da>
  8048c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048c9:	8b 00                	mov    (%eax),%eax
  8048cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048ce:	8b 52 04             	mov    0x4(%edx),%edx
  8048d1:	89 50 04             	mov    %edx,0x4(%eax)
  8048d4:	eb 0b                	jmp    8048e1 <realloc_block_FF+0x1e5>
  8048d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048d9:	8b 40 04             	mov    0x4(%eax),%eax
  8048dc:	a3 30 70 80 00       	mov    %eax,0x807030
  8048e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048e4:	8b 40 04             	mov    0x4(%eax),%eax
  8048e7:	85 c0                	test   %eax,%eax
  8048e9:	74 0f                	je     8048fa <realloc_block_FF+0x1fe>
  8048eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048ee:	8b 40 04             	mov    0x4(%eax),%eax
  8048f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048f4:	8b 12                	mov    (%edx),%edx
  8048f6:	89 10                	mov    %edx,(%eax)
  8048f8:	eb 0a                	jmp    804904 <realloc_block_FF+0x208>
  8048fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048fd:	8b 00                	mov    (%eax),%eax
  8048ff:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80490d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804910:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804917:	a1 38 70 80 00       	mov    0x807038,%eax
  80491c:	48                   	dec    %eax
  80491d:	a3 38 70 80 00       	mov    %eax,0x807038
  804922:	e9 83 02 00 00       	jmp    804baa <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804927:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80492b:	0f 86 69 02 00 00    	jbe    804b9a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804931:	83 ec 04             	sub    $0x4,%esp
  804934:	6a 01                	push   $0x1
  804936:	ff 75 f0             	pushl  -0x10(%ebp)
  804939:	ff 75 08             	pushl  0x8(%ebp)
  80493c:	e8 c8 ed ff ff       	call   803709 <set_block_data>
  804941:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804944:	8b 45 08             	mov    0x8(%ebp),%eax
  804947:	83 e8 04             	sub    $0x4,%eax
  80494a:	8b 00                	mov    (%eax),%eax
  80494c:	83 e0 fe             	and    $0xfffffffe,%eax
  80494f:	89 c2                	mov    %eax,%edx
  804951:	8b 45 08             	mov    0x8(%ebp),%eax
  804954:	01 d0                	add    %edx,%eax
  804956:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804959:	a1 38 70 80 00       	mov    0x807038,%eax
  80495e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804961:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804965:	75 68                	jne    8049cf <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804967:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80496b:	75 17                	jne    804984 <realloc_block_FF+0x288>
  80496d:	83 ec 04             	sub    $0x4,%esp
  804970:	68 2c 6a 80 00       	push   $0x806a2c
  804975:	68 06 02 00 00       	push   $0x206
  80497a:	68 11 6a 80 00       	push   $0x806a11
  80497f:	e8 6f ce ff ff       	call   8017f3 <_panic>
  804984:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80498a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80498d:	89 10                	mov    %edx,(%eax)
  80498f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804992:	8b 00                	mov    (%eax),%eax
  804994:	85 c0                	test   %eax,%eax
  804996:	74 0d                	je     8049a5 <realloc_block_FF+0x2a9>
  804998:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80499d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049a0:	89 50 04             	mov    %edx,0x4(%eax)
  8049a3:	eb 08                	jmp    8049ad <realloc_block_FF+0x2b1>
  8049a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a8:	a3 30 70 80 00       	mov    %eax,0x807030
  8049ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049b0:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8049b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049bf:	a1 38 70 80 00       	mov    0x807038,%eax
  8049c4:	40                   	inc    %eax
  8049c5:	a3 38 70 80 00       	mov    %eax,0x807038
  8049ca:	e9 b0 01 00 00       	jmp    804b7f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8049cf:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049d4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8049d7:	76 68                	jbe    804a41 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8049d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8049dd:	75 17                	jne    8049f6 <realloc_block_FF+0x2fa>
  8049df:	83 ec 04             	sub    $0x4,%esp
  8049e2:	68 2c 6a 80 00       	push   $0x806a2c
  8049e7:	68 0b 02 00 00       	push   $0x20b
  8049ec:	68 11 6a 80 00       	push   $0x806a11
  8049f1:	e8 fd cd ff ff       	call   8017f3 <_panic>
  8049f6:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8049fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049ff:	89 10                	mov    %edx,(%eax)
  804a01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a04:	8b 00                	mov    (%eax),%eax
  804a06:	85 c0                	test   %eax,%eax
  804a08:	74 0d                	je     804a17 <realloc_block_FF+0x31b>
  804a0a:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a12:	89 50 04             	mov    %edx,0x4(%eax)
  804a15:	eb 08                	jmp    804a1f <realloc_block_FF+0x323>
  804a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a1a:	a3 30 70 80 00       	mov    %eax,0x807030
  804a1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a22:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a31:	a1 38 70 80 00       	mov    0x807038,%eax
  804a36:	40                   	inc    %eax
  804a37:	a3 38 70 80 00       	mov    %eax,0x807038
  804a3c:	e9 3e 01 00 00       	jmp    804b7f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804a41:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a46:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a49:	73 68                	jae    804ab3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804a4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a4f:	75 17                	jne    804a68 <realloc_block_FF+0x36c>
  804a51:	83 ec 04             	sub    $0x4,%esp
  804a54:	68 60 6a 80 00       	push   $0x806a60
  804a59:	68 10 02 00 00       	push   $0x210
  804a5e:	68 11 6a 80 00       	push   $0x806a11
  804a63:	e8 8b cd ff ff       	call   8017f3 <_panic>
  804a68:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804a6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a71:	89 50 04             	mov    %edx,0x4(%eax)
  804a74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a77:	8b 40 04             	mov    0x4(%eax),%eax
  804a7a:	85 c0                	test   %eax,%eax
  804a7c:	74 0c                	je     804a8a <realloc_block_FF+0x38e>
  804a7e:	a1 30 70 80 00       	mov    0x807030,%eax
  804a83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a86:	89 10                	mov    %edx,(%eax)
  804a88:	eb 08                	jmp    804a92 <realloc_block_FF+0x396>
  804a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a8d:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a95:	a3 30 70 80 00       	mov    %eax,0x807030
  804a9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804aa3:	a1 38 70 80 00       	mov    0x807038,%eax
  804aa8:	40                   	inc    %eax
  804aa9:	a3 38 70 80 00       	mov    %eax,0x807038
  804aae:	e9 cc 00 00 00       	jmp    804b7f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804aba:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804ac2:	e9 8a 00 00 00       	jmp    804b51 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804acd:	73 7a                	jae    804b49 <realloc_block_FF+0x44d>
  804acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ad2:	8b 00                	mov    (%eax),%eax
  804ad4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804ad7:	73 70                	jae    804b49 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804add:	74 06                	je     804ae5 <realloc_block_FF+0x3e9>
  804adf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804ae3:	75 17                	jne    804afc <realloc_block_FF+0x400>
  804ae5:	83 ec 04             	sub    $0x4,%esp
  804ae8:	68 84 6a 80 00       	push   $0x806a84
  804aed:	68 1a 02 00 00       	push   $0x21a
  804af2:	68 11 6a 80 00       	push   $0x806a11
  804af7:	e8 f7 cc ff ff       	call   8017f3 <_panic>
  804afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aff:	8b 10                	mov    (%eax),%edx
  804b01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b04:	89 10                	mov    %edx,(%eax)
  804b06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b09:	8b 00                	mov    (%eax),%eax
  804b0b:	85 c0                	test   %eax,%eax
  804b0d:	74 0b                	je     804b1a <realloc_block_FF+0x41e>
  804b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b12:	8b 00                	mov    (%eax),%eax
  804b14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804b17:	89 50 04             	mov    %edx,0x4(%eax)
  804b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804b20:	89 10                	mov    %edx,(%eax)
  804b22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804b28:	89 50 04             	mov    %edx,0x4(%eax)
  804b2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b2e:	8b 00                	mov    (%eax),%eax
  804b30:	85 c0                	test   %eax,%eax
  804b32:	75 08                	jne    804b3c <realloc_block_FF+0x440>
  804b34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b37:	a3 30 70 80 00       	mov    %eax,0x807030
  804b3c:	a1 38 70 80 00       	mov    0x807038,%eax
  804b41:	40                   	inc    %eax
  804b42:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  804b47:	eb 36                	jmp    804b7f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804b49:	a1 34 70 80 00       	mov    0x807034,%eax
  804b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b55:	74 07                	je     804b5e <realloc_block_FF+0x462>
  804b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b5a:	8b 00                	mov    (%eax),%eax
  804b5c:	eb 05                	jmp    804b63 <realloc_block_FF+0x467>
  804b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b63:	a3 34 70 80 00       	mov    %eax,0x807034
  804b68:	a1 34 70 80 00       	mov    0x807034,%eax
  804b6d:	85 c0                	test   %eax,%eax
  804b6f:	0f 85 52 ff ff ff    	jne    804ac7 <realloc_block_FF+0x3cb>
  804b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b79:	0f 85 48 ff ff ff    	jne    804ac7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804b7f:	83 ec 04             	sub    $0x4,%esp
  804b82:	6a 00                	push   $0x0
  804b84:	ff 75 d8             	pushl  -0x28(%ebp)
  804b87:	ff 75 d4             	pushl  -0x2c(%ebp)
  804b8a:	e8 7a eb ff ff       	call   803709 <set_block_data>
  804b8f:	83 c4 10             	add    $0x10,%esp
				return va;
  804b92:	8b 45 08             	mov    0x8(%ebp),%eax
  804b95:	e9 7b 02 00 00       	jmp    804e15 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804b9a:	83 ec 0c             	sub    $0xc,%esp
  804b9d:	68 01 6b 80 00       	push   $0x806b01
  804ba2:	e8 09 cf ff ff       	call   801ab0 <cprintf>
  804ba7:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804baa:	8b 45 08             	mov    0x8(%ebp),%eax
  804bad:	e9 63 02 00 00       	jmp    804e15 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  804bb5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804bb8:	0f 86 4d 02 00 00    	jbe    804e0b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804bbe:	83 ec 0c             	sub    $0xc,%esp
  804bc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  804bc4:	e8 08 e8 ff ff       	call   8033d1 <is_free_block>
  804bc9:	83 c4 10             	add    $0x10,%esp
  804bcc:	84 c0                	test   %al,%al
  804bce:	0f 84 37 02 00 00    	je     804e0b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  804bd7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804bda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804bdd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804be0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804be3:	76 38                	jbe    804c1d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804be5:	83 ec 0c             	sub    $0xc,%esp
  804be8:	ff 75 08             	pushl  0x8(%ebp)
  804beb:	e8 0c fa ff ff       	call   8045fc <free_block>
  804bf0:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804bf3:	83 ec 0c             	sub    $0xc,%esp
  804bf6:	ff 75 0c             	pushl  0xc(%ebp)
  804bf9:	e8 3a eb ff ff       	call   803738 <alloc_block_FF>
  804bfe:	83 c4 10             	add    $0x10,%esp
  804c01:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804c04:	83 ec 08             	sub    $0x8,%esp
  804c07:	ff 75 c0             	pushl  -0x40(%ebp)
  804c0a:	ff 75 08             	pushl  0x8(%ebp)
  804c0d:	e8 ab fa ff ff       	call   8046bd <copy_data>
  804c12:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804c15:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804c18:	e9 f8 01 00 00       	jmp    804e15 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804c1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804c20:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804c23:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804c26:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804c2a:	0f 87 a0 00 00 00    	ja     804cd0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c34:	75 17                	jne    804c4d <realloc_block_FF+0x551>
  804c36:	83 ec 04             	sub    $0x4,%esp
  804c39:	68 f3 69 80 00       	push   $0x8069f3
  804c3e:	68 38 02 00 00       	push   $0x238
  804c43:	68 11 6a 80 00       	push   $0x806a11
  804c48:	e8 a6 cb ff ff       	call   8017f3 <_panic>
  804c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c50:	8b 00                	mov    (%eax),%eax
  804c52:	85 c0                	test   %eax,%eax
  804c54:	74 10                	je     804c66 <realloc_block_FF+0x56a>
  804c56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c59:	8b 00                	mov    (%eax),%eax
  804c5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c5e:	8b 52 04             	mov    0x4(%edx),%edx
  804c61:	89 50 04             	mov    %edx,0x4(%eax)
  804c64:	eb 0b                	jmp    804c71 <realloc_block_FF+0x575>
  804c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c69:	8b 40 04             	mov    0x4(%eax),%eax
  804c6c:	a3 30 70 80 00       	mov    %eax,0x807030
  804c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c74:	8b 40 04             	mov    0x4(%eax),%eax
  804c77:	85 c0                	test   %eax,%eax
  804c79:	74 0f                	je     804c8a <realloc_block_FF+0x58e>
  804c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c7e:	8b 40 04             	mov    0x4(%eax),%eax
  804c81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c84:	8b 12                	mov    (%edx),%edx
  804c86:	89 10                	mov    %edx,(%eax)
  804c88:	eb 0a                	jmp    804c94 <realloc_block_FF+0x598>
  804c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c8d:	8b 00                	mov    (%eax),%eax
  804c8f:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ca0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ca7:	a1 38 70 80 00       	mov    0x807038,%eax
  804cac:	48                   	dec    %eax
  804cad:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804cb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804cb8:	01 d0                	add    %edx,%eax
  804cba:	83 ec 04             	sub    $0x4,%esp
  804cbd:	6a 01                	push   $0x1
  804cbf:	50                   	push   %eax
  804cc0:	ff 75 08             	pushl  0x8(%ebp)
  804cc3:	e8 41 ea ff ff       	call   803709 <set_block_data>
  804cc8:	83 c4 10             	add    $0x10,%esp
  804ccb:	e9 36 01 00 00       	jmp    804e06 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804cd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cd3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804cd6:	01 d0                	add    %edx,%eax
  804cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804cdb:	83 ec 04             	sub    $0x4,%esp
  804cde:	6a 01                	push   $0x1
  804ce0:	ff 75 f0             	pushl  -0x10(%ebp)
  804ce3:	ff 75 08             	pushl  0x8(%ebp)
  804ce6:	e8 1e ea ff ff       	call   803709 <set_block_data>
  804ceb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804cee:	8b 45 08             	mov    0x8(%ebp),%eax
  804cf1:	83 e8 04             	sub    $0x4,%eax
  804cf4:	8b 00                	mov    (%eax),%eax
  804cf6:	83 e0 fe             	and    $0xfffffffe,%eax
  804cf9:	89 c2                	mov    %eax,%edx
  804cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  804cfe:	01 d0                	add    %edx,%eax
  804d00:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d07:	74 06                	je     804d0f <realloc_block_FF+0x613>
  804d09:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804d0d:	75 17                	jne    804d26 <realloc_block_FF+0x62a>
  804d0f:	83 ec 04             	sub    $0x4,%esp
  804d12:	68 84 6a 80 00       	push   $0x806a84
  804d17:	68 44 02 00 00       	push   $0x244
  804d1c:	68 11 6a 80 00       	push   $0x806a11
  804d21:	e8 cd ca ff ff       	call   8017f3 <_panic>
  804d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d29:	8b 10                	mov    (%eax),%edx
  804d2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d2e:	89 10                	mov    %edx,(%eax)
  804d30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d33:	8b 00                	mov    (%eax),%eax
  804d35:	85 c0                	test   %eax,%eax
  804d37:	74 0b                	je     804d44 <realloc_block_FF+0x648>
  804d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d3c:	8b 00                	mov    (%eax),%eax
  804d3e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804d41:	89 50 04             	mov    %edx,0x4(%eax)
  804d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d47:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804d4a:	89 10                	mov    %edx,(%eax)
  804d4c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d52:	89 50 04             	mov    %edx,0x4(%eax)
  804d55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d58:	8b 00                	mov    (%eax),%eax
  804d5a:	85 c0                	test   %eax,%eax
  804d5c:	75 08                	jne    804d66 <realloc_block_FF+0x66a>
  804d5e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d61:	a3 30 70 80 00       	mov    %eax,0x807030
  804d66:	a1 38 70 80 00       	mov    0x807038,%eax
  804d6b:	40                   	inc    %eax
  804d6c:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804d71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d75:	75 17                	jne    804d8e <realloc_block_FF+0x692>
  804d77:	83 ec 04             	sub    $0x4,%esp
  804d7a:	68 f3 69 80 00       	push   $0x8069f3
  804d7f:	68 45 02 00 00       	push   $0x245
  804d84:	68 11 6a 80 00       	push   $0x806a11
  804d89:	e8 65 ca ff ff       	call   8017f3 <_panic>
  804d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d91:	8b 00                	mov    (%eax),%eax
  804d93:	85 c0                	test   %eax,%eax
  804d95:	74 10                	je     804da7 <realloc_block_FF+0x6ab>
  804d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d9a:	8b 00                	mov    (%eax),%eax
  804d9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d9f:	8b 52 04             	mov    0x4(%edx),%edx
  804da2:	89 50 04             	mov    %edx,0x4(%eax)
  804da5:	eb 0b                	jmp    804db2 <realloc_block_FF+0x6b6>
  804da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804daa:	8b 40 04             	mov    0x4(%eax),%eax
  804dad:	a3 30 70 80 00       	mov    %eax,0x807030
  804db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804db5:	8b 40 04             	mov    0x4(%eax),%eax
  804db8:	85 c0                	test   %eax,%eax
  804dba:	74 0f                	je     804dcb <realloc_block_FF+0x6cf>
  804dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dbf:	8b 40 04             	mov    0x4(%eax),%eax
  804dc2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804dc5:	8b 12                	mov    (%edx),%edx
  804dc7:	89 10                	mov    %edx,(%eax)
  804dc9:	eb 0a                	jmp    804dd5 <realloc_block_FF+0x6d9>
  804dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dce:	8b 00                	mov    (%eax),%eax
  804dd0:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804de8:	a1 38 70 80 00       	mov    0x807038,%eax
  804ded:	48                   	dec    %eax
  804dee:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804df3:	83 ec 04             	sub    $0x4,%esp
  804df6:	6a 00                	push   $0x0
  804df8:	ff 75 bc             	pushl  -0x44(%ebp)
  804dfb:	ff 75 b8             	pushl  -0x48(%ebp)
  804dfe:	e8 06 e9 ff ff       	call   803709 <set_block_data>
  804e03:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804e06:	8b 45 08             	mov    0x8(%ebp),%eax
  804e09:	eb 0a                	jmp    804e15 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804e0b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804e15:	c9                   	leave  
  804e16:	c3                   	ret    

00804e17 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804e17:	55                   	push   %ebp
  804e18:	89 e5                	mov    %esp,%ebp
  804e1a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804e1d:	83 ec 04             	sub    $0x4,%esp
  804e20:	68 08 6b 80 00       	push   $0x806b08
  804e25:	68 58 02 00 00       	push   $0x258
  804e2a:	68 11 6a 80 00       	push   $0x806a11
  804e2f:	e8 bf c9 ff ff       	call   8017f3 <_panic>

00804e34 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804e34:	55                   	push   %ebp
  804e35:	89 e5                	mov    %esp,%ebp
  804e37:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804e3a:	83 ec 04             	sub    $0x4,%esp
  804e3d:	68 30 6b 80 00       	push   $0x806b30
  804e42:	68 61 02 00 00       	push   $0x261
  804e47:	68 11 6a 80 00       	push   $0x806a11
  804e4c:	e8 a2 c9 ff ff       	call   8017f3 <_panic>

00804e51 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804e51:	55                   	push   %ebp
  804e52:	89 e5                	mov    %esp,%ebp
  804e54:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804e57:	8b 55 08             	mov    0x8(%ebp),%edx
  804e5a:	89 d0                	mov    %edx,%eax
  804e5c:	c1 e0 02             	shl    $0x2,%eax
  804e5f:	01 d0                	add    %edx,%eax
  804e61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e68:	01 d0                	add    %edx,%eax
  804e6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e71:	01 d0                	add    %edx,%eax
  804e73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e7a:	01 d0                	add    %edx,%eax
  804e7c:	c1 e0 04             	shl    $0x4,%eax
  804e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804e89:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804e8c:	83 ec 0c             	sub    $0xc,%esp
  804e8f:	50                   	push   %eax
  804e90:	e8 2f e2 ff ff       	call   8030c4 <sys_get_virtual_time>
  804e95:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804e98:	eb 41                	jmp    804edb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804e9a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804e9d:	83 ec 0c             	sub    $0xc,%esp
  804ea0:	50                   	push   %eax
  804ea1:	e8 1e e2 ff ff       	call   8030c4 <sys_get_virtual_time>
  804ea6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804ea9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804eaf:	29 c2                	sub    %eax,%edx
  804eb1:	89 d0                	mov    %edx,%eax
  804eb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804eb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ebc:	89 d1                	mov    %edx,%ecx
  804ebe:	29 c1                	sub    %eax,%ecx
  804ec0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ec6:	39 c2                	cmp    %eax,%edx
  804ec8:	0f 97 c0             	seta   %al
  804ecb:	0f b6 c0             	movzbl %al,%eax
  804ece:	29 c1                	sub    %eax,%ecx
  804ed0:	89 c8                	mov    %ecx,%eax
  804ed2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804ed5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ede:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804ee1:	72 b7                	jb     804e9a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804ee3:	90                   	nop
  804ee4:	c9                   	leave  
  804ee5:	c3                   	ret    

00804ee6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804ee6:	55                   	push   %ebp
  804ee7:	89 e5                	mov    %esp,%ebp
  804ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804ef3:	eb 03                	jmp    804ef8 <busy_wait+0x12>
  804ef5:	ff 45 fc             	incl   -0x4(%ebp)
  804ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  804efe:	72 f5                	jb     804ef5 <busy_wait+0xf>
	return i;
  804f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804f03:	c9                   	leave  
  804f04:	c3                   	ret    
  804f05:	66 90                	xchg   %ax,%ax
  804f07:	90                   	nop

00804f08 <__udivdi3>:
  804f08:	55                   	push   %ebp
  804f09:	57                   	push   %edi
  804f0a:	56                   	push   %esi
  804f0b:	53                   	push   %ebx
  804f0c:	83 ec 1c             	sub    $0x1c,%esp
  804f0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804f13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804f17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804f1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804f1f:	89 ca                	mov    %ecx,%edx
  804f21:	89 f8                	mov    %edi,%eax
  804f23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804f27:	85 f6                	test   %esi,%esi
  804f29:	75 2d                	jne    804f58 <__udivdi3+0x50>
  804f2b:	39 cf                	cmp    %ecx,%edi
  804f2d:	77 65                	ja     804f94 <__udivdi3+0x8c>
  804f2f:	89 fd                	mov    %edi,%ebp
  804f31:	85 ff                	test   %edi,%edi
  804f33:	75 0b                	jne    804f40 <__udivdi3+0x38>
  804f35:	b8 01 00 00 00       	mov    $0x1,%eax
  804f3a:	31 d2                	xor    %edx,%edx
  804f3c:	f7 f7                	div    %edi
  804f3e:	89 c5                	mov    %eax,%ebp
  804f40:	31 d2                	xor    %edx,%edx
  804f42:	89 c8                	mov    %ecx,%eax
  804f44:	f7 f5                	div    %ebp
  804f46:	89 c1                	mov    %eax,%ecx
  804f48:	89 d8                	mov    %ebx,%eax
  804f4a:	f7 f5                	div    %ebp
  804f4c:	89 cf                	mov    %ecx,%edi
  804f4e:	89 fa                	mov    %edi,%edx
  804f50:	83 c4 1c             	add    $0x1c,%esp
  804f53:	5b                   	pop    %ebx
  804f54:	5e                   	pop    %esi
  804f55:	5f                   	pop    %edi
  804f56:	5d                   	pop    %ebp
  804f57:	c3                   	ret    
  804f58:	39 ce                	cmp    %ecx,%esi
  804f5a:	77 28                	ja     804f84 <__udivdi3+0x7c>
  804f5c:	0f bd fe             	bsr    %esi,%edi
  804f5f:	83 f7 1f             	xor    $0x1f,%edi
  804f62:	75 40                	jne    804fa4 <__udivdi3+0x9c>
  804f64:	39 ce                	cmp    %ecx,%esi
  804f66:	72 0a                	jb     804f72 <__udivdi3+0x6a>
  804f68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804f6c:	0f 87 9e 00 00 00    	ja     805010 <__udivdi3+0x108>
  804f72:	b8 01 00 00 00       	mov    $0x1,%eax
  804f77:	89 fa                	mov    %edi,%edx
  804f79:	83 c4 1c             	add    $0x1c,%esp
  804f7c:	5b                   	pop    %ebx
  804f7d:	5e                   	pop    %esi
  804f7e:	5f                   	pop    %edi
  804f7f:	5d                   	pop    %ebp
  804f80:	c3                   	ret    
  804f81:	8d 76 00             	lea    0x0(%esi),%esi
  804f84:	31 ff                	xor    %edi,%edi
  804f86:	31 c0                	xor    %eax,%eax
  804f88:	89 fa                	mov    %edi,%edx
  804f8a:	83 c4 1c             	add    $0x1c,%esp
  804f8d:	5b                   	pop    %ebx
  804f8e:	5e                   	pop    %esi
  804f8f:	5f                   	pop    %edi
  804f90:	5d                   	pop    %ebp
  804f91:	c3                   	ret    
  804f92:	66 90                	xchg   %ax,%ax
  804f94:	89 d8                	mov    %ebx,%eax
  804f96:	f7 f7                	div    %edi
  804f98:	31 ff                	xor    %edi,%edi
  804f9a:	89 fa                	mov    %edi,%edx
  804f9c:	83 c4 1c             	add    $0x1c,%esp
  804f9f:	5b                   	pop    %ebx
  804fa0:	5e                   	pop    %esi
  804fa1:	5f                   	pop    %edi
  804fa2:	5d                   	pop    %ebp
  804fa3:	c3                   	ret    
  804fa4:	bd 20 00 00 00       	mov    $0x20,%ebp
  804fa9:	89 eb                	mov    %ebp,%ebx
  804fab:	29 fb                	sub    %edi,%ebx
  804fad:	89 f9                	mov    %edi,%ecx
  804faf:	d3 e6                	shl    %cl,%esi
  804fb1:	89 c5                	mov    %eax,%ebp
  804fb3:	88 d9                	mov    %bl,%cl
  804fb5:	d3 ed                	shr    %cl,%ebp
  804fb7:	89 e9                	mov    %ebp,%ecx
  804fb9:	09 f1                	or     %esi,%ecx
  804fbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804fbf:	89 f9                	mov    %edi,%ecx
  804fc1:	d3 e0                	shl    %cl,%eax
  804fc3:	89 c5                	mov    %eax,%ebp
  804fc5:	89 d6                	mov    %edx,%esi
  804fc7:	88 d9                	mov    %bl,%cl
  804fc9:	d3 ee                	shr    %cl,%esi
  804fcb:	89 f9                	mov    %edi,%ecx
  804fcd:	d3 e2                	shl    %cl,%edx
  804fcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  804fd3:	88 d9                	mov    %bl,%cl
  804fd5:	d3 e8                	shr    %cl,%eax
  804fd7:	09 c2                	or     %eax,%edx
  804fd9:	89 d0                	mov    %edx,%eax
  804fdb:	89 f2                	mov    %esi,%edx
  804fdd:	f7 74 24 0c          	divl   0xc(%esp)
  804fe1:	89 d6                	mov    %edx,%esi
  804fe3:	89 c3                	mov    %eax,%ebx
  804fe5:	f7 e5                	mul    %ebp
  804fe7:	39 d6                	cmp    %edx,%esi
  804fe9:	72 19                	jb     805004 <__udivdi3+0xfc>
  804feb:	74 0b                	je     804ff8 <__udivdi3+0xf0>
  804fed:	89 d8                	mov    %ebx,%eax
  804fef:	31 ff                	xor    %edi,%edi
  804ff1:	e9 58 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  804ff6:	66 90                	xchg   %ax,%ax
  804ff8:	8b 54 24 08          	mov    0x8(%esp),%edx
  804ffc:	89 f9                	mov    %edi,%ecx
  804ffe:	d3 e2                	shl    %cl,%edx
  805000:	39 c2                	cmp    %eax,%edx
  805002:	73 e9                	jae    804fed <__udivdi3+0xe5>
  805004:	8d 43 ff             	lea    -0x1(%ebx),%eax
  805007:	31 ff                	xor    %edi,%edi
  805009:	e9 40 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  80500e:	66 90                	xchg   %ax,%ax
  805010:	31 c0                	xor    %eax,%eax
  805012:	e9 37 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  805017:	90                   	nop

00805018 <__umoddi3>:
  805018:	55                   	push   %ebp
  805019:	57                   	push   %edi
  80501a:	56                   	push   %esi
  80501b:	53                   	push   %ebx
  80501c:	83 ec 1c             	sub    $0x1c,%esp
  80501f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  805023:	8b 74 24 34          	mov    0x34(%esp),%esi
  805027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80502b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80502f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  805033:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  805037:	89 f3                	mov    %esi,%ebx
  805039:	89 fa                	mov    %edi,%edx
  80503b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80503f:	89 34 24             	mov    %esi,(%esp)
  805042:	85 c0                	test   %eax,%eax
  805044:	75 1a                	jne    805060 <__umoddi3+0x48>
  805046:	39 f7                	cmp    %esi,%edi
  805048:	0f 86 a2 00 00 00    	jbe    8050f0 <__umoddi3+0xd8>
  80504e:	89 c8                	mov    %ecx,%eax
  805050:	89 f2                	mov    %esi,%edx
  805052:	f7 f7                	div    %edi
  805054:	89 d0                	mov    %edx,%eax
  805056:	31 d2                	xor    %edx,%edx
  805058:	83 c4 1c             	add    $0x1c,%esp
  80505b:	5b                   	pop    %ebx
  80505c:	5e                   	pop    %esi
  80505d:	5f                   	pop    %edi
  80505e:	5d                   	pop    %ebp
  80505f:	c3                   	ret    
  805060:	39 f0                	cmp    %esi,%eax
  805062:	0f 87 ac 00 00 00    	ja     805114 <__umoddi3+0xfc>
  805068:	0f bd e8             	bsr    %eax,%ebp
  80506b:	83 f5 1f             	xor    $0x1f,%ebp
  80506e:	0f 84 ac 00 00 00    	je     805120 <__umoddi3+0x108>
  805074:	bf 20 00 00 00       	mov    $0x20,%edi
  805079:	29 ef                	sub    %ebp,%edi
  80507b:	89 fe                	mov    %edi,%esi
  80507d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805081:	89 e9                	mov    %ebp,%ecx
  805083:	d3 e0                	shl    %cl,%eax
  805085:	89 d7                	mov    %edx,%edi
  805087:	89 f1                	mov    %esi,%ecx
  805089:	d3 ef                	shr    %cl,%edi
  80508b:	09 c7                	or     %eax,%edi
  80508d:	89 e9                	mov    %ebp,%ecx
  80508f:	d3 e2                	shl    %cl,%edx
  805091:	89 14 24             	mov    %edx,(%esp)
  805094:	89 d8                	mov    %ebx,%eax
  805096:	d3 e0                	shl    %cl,%eax
  805098:	89 c2                	mov    %eax,%edx
  80509a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80509e:	d3 e0                	shl    %cl,%eax
  8050a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8050a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8050a8:	89 f1                	mov    %esi,%ecx
  8050aa:	d3 e8                	shr    %cl,%eax
  8050ac:	09 d0                	or     %edx,%eax
  8050ae:	d3 eb                	shr    %cl,%ebx
  8050b0:	89 da                	mov    %ebx,%edx
  8050b2:	f7 f7                	div    %edi
  8050b4:	89 d3                	mov    %edx,%ebx
  8050b6:	f7 24 24             	mull   (%esp)
  8050b9:	89 c6                	mov    %eax,%esi
  8050bb:	89 d1                	mov    %edx,%ecx
  8050bd:	39 d3                	cmp    %edx,%ebx
  8050bf:	0f 82 87 00 00 00    	jb     80514c <__umoddi3+0x134>
  8050c5:	0f 84 91 00 00 00    	je     80515c <__umoddi3+0x144>
  8050cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8050cf:	29 f2                	sub    %esi,%edx
  8050d1:	19 cb                	sbb    %ecx,%ebx
  8050d3:	89 d8                	mov    %ebx,%eax
  8050d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8050d9:	d3 e0                	shl    %cl,%eax
  8050db:	89 e9                	mov    %ebp,%ecx
  8050dd:	d3 ea                	shr    %cl,%edx
  8050df:	09 d0                	or     %edx,%eax
  8050e1:	89 e9                	mov    %ebp,%ecx
  8050e3:	d3 eb                	shr    %cl,%ebx
  8050e5:	89 da                	mov    %ebx,%edx
  8050e7:	83 c4 1c             	add    $0x1c,%esp
  8050ea:	5b                   	pop    %ebx
  8050eb:	5e                   	pop    %esi
  8050ec:	5f                   	pop    %edi
  8050ed:	5d                   	pop    %ebp
  8050ee:	c3                   	ret    
  8050ef:	90                   	nop
  8050f0:	89 fd                	mov    %edi,%ebp
  8050f2:	85 ff                	test   %edi,%edi
  8050f4:	75 0b                	jne    805101 <__umoddi3+0xe9>
  8050f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8050fb:	31 d2                	xor    %edx,%edx
  8050fd:	f7 f7                	div    %edi
  8050ff:	89 c5                	mov    %eax,%ebp
  805101:	89 f0                	mov    %esi,%eax
  805103:	31 d2                	xor    %edx,%edx
  805105:	f7 f5                	div    %ebp
  805107:	89 c8                	mov    %ecx,%eax
  805109:	f7 f5                	div    %ebp
  80510b:	89 d0                	mov    %edx,%eax
  80510d:	e9 44 ff ff ff       	jmp    805056 <__umoddi3+0x3e>
  805112:	66 90                	xchg   %ax,%ax
  805114:	89 c8                	mov    %ecx,%eax
  805116:	89 f2                	mov    %esi,%edx
  805118:	83 c4 1c             	add    $0x1c,%esp
  80511b:	5b                   	pop    %ebx
  80511c:	5e                   	pop    %esi
  80511d:	5f                   	pop    %edi
  80511e:	5d                   	pop    %ebp
  80511f:	c3                   	ret    
  805120:	3b 04 24             	cmp    (%esp),%eax
  805123:	72 06                	jb     80512b <__umoddi3+0x113>
  805125:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805129:	77 0f                	ja     80513a <__umoddi3+0x122>
  80512b:	89 f2                	mov    %esi,%edx
  80512d:	29 f9                	sub    %edi,%ecx
  80512f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  805133:	89 14 24             	mov    %edx,(%esp)
  805136:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80513a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80513e:	8b 14 24             	mov    (%esp),%edx
  805141:	83 c4 1c             	add    $0x1c,%esp
  805144:	5b                   	pop    %ebx
  805145:	5e                   	pop    %esi
  805146:	5f                   	pop    %edi
  805147:	5d                   	pop    %ebp
  805148:	c3                   	ret    
  805149:	8d 76 00             	lea    0x0(%esi),%esi
  80514c:	2b 04 24             	sub    (%esp),%eax
  80514f:	19 fa                	sbb    %edi,%edx
  805151:	89 d1                	mov    %edx,%ecx
  805153:	89 c6                	mov    %eax,%esi
  805155:	e9 71 ff ff ff       	jmp    8050cb <__umoddi3+0xb3>
  80515a:	66 90                	xchg   %ax,%ax
  80515c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805160:	72 ea                	jb     80514c <__umoddi3+0x134>
  805162:	89 d9                	mov    %ebx,%ecx
  805164:	e9 62 ff ff ff       	jmp    8050cb <__umoddi3+0xb3>
