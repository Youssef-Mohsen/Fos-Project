
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
  8000d7:	e8 66 2d 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800103:	e8 3a 2d 00 00       	call   802e42 <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 7d 2d 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800159:	e8 e4 2c 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8001a2:	e8 e6 2c 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 30 52 80 00       	push   $0x805230
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 7a 2c 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8001ff:	e8 3e 2c 00 00       	call   802e42 <sys_calculate_free_frames>
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
  80027e:	e8 1a 30 00 00       	call   80329d <sys_check_WS_list>
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
  8002a6:	e8 97 2b 00 00       	call   802e42 <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 da 2b 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800309:	e8 34 2b 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800352:	e8 36 2b 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 ac 53 80 00       	push   $0x8053ac
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 ca 2a 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8003b8:	e8 85 2a 00 00       	call   802e42 <sys_calculate_free_frames>
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
  80043b:	e8 5d 2e 00 00       	call   80329d <sys_check_WS_list>
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
  800463:	e8 25 2a 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  8004c0:	e8 7d 29 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800509:	e8 7f 29 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 28 55 80 00       	push   $0x805528
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 13 29 00 00       	call   802e42 <sys_calculate_free_frames>
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
  80056d:	e8 d0 28 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8005f3:	e8 a5 2c 00 00       	call   80329d <sys_check_WS_list>
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
  80061b:	e8 6d 28 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800676:	e8 12 28 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800697:	e8 a6 27 00 00       	call   802e42 <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 e9 27 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800708:	e8 35 27 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800751:	e8 37 27 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 0c 57 80 00       	push   $0x80570c
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 cb 26 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8007fc:	e8 41 26 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800888:	e8 10 2a 00 00       	call   80329d <sys_check_WS_list>
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
  8008b0:	e8 8d 25 00 00       	call   802e42 <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 d0 25 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800920:	e8 1d 25 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800969:	e8 1f 25 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  80098a:	e8 b3 24 00 00       	call   802e42 <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 f6 24 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800a03:	e8 3a 24 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800a4c:	e8 3c 24 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 60 59 80 00       	push   $0x805960
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 d0 23 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800ae5:	e8 58 23 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800ba9:	e8 ef 26 00 00       	call   80329d <sys_check_WS_list>
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
  800bd1:	e8 6c 22 00 00       	call   802e42 <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 af 22 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
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
  800c4c:	e8 f1 21 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800c95:	e8 f3 21 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 dc 5a 80 00       	push   $0x805adc
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 87 21 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800d3f:	e8 fe 20 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800e09:	e8 8f 24 00 00       	call   80329d <sys_check_WS_list>
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
  800e6b:	e8 d2 1f 00 00       	call   802e42 <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 15 20 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 fb 1f 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 f4 5b 80 00       	push   $0x805bf4
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 8f 1f 00 00       	call   802e42 <sys_calculate_free_frames>
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
  800f1e:	e8 7a 23 00 00       	call   80329d <sys_check_WS_list>
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
  800f5d:	e8 e0 1e 00 00       	call   802e42 <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 23 1f 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 09 1f 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 ac 5c 80 00       	push   $0x805cac
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 9d 1e 00 00       	call   802e42 <sys_calculate_free_frames>
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
  801014:	e8 84 22 00 00       	call   80329d <sys_check_WS_list>
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
  801053:	e8 ea 1d 00 00       	call   802e42 <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 2d 1e 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 13 1e 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 64 5d 80 00       	push   $0x805d64
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 a7 1d 00 00       	call   802e42 <sys_calculate_free_frames>
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
  80113f:	e8 59 21 00 00       	call   80329d <sys_check_WS_list>
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
  80117e:	e8 bf 1c 00 00       	call   802e42 <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 02 1d 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 e8 1c 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 1c 5e 80 00       	push   $0x805e1c
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 7c 1c 00 00       	call   802e42 <sys_calculate_free_frames>
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
  801238:	e8 60 20 00 00       	call   80329d <sys_check_WS_list>
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
  801277:	e8 c6 1b 00 00       	call   802e42 <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 09 1c 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 ef 1b 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 d4 5e 80 00       	push   $0x805ed4
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 83 1b 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8012f0:	e8 4d 1b 00 00       	call   802e42 <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 90 1b 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 76 1b 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 58 5f 80 00       	push   $0x805f58
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 0a 1b 00 00       	call   802e42 <sys_calculate_free_frames>
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
  8013aa:	e8 ee 1e 00 00       	call   80329d <sys_check_WS_list>
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
  8013e9:	e8 54 1a 00 00       	call   802e42 <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 97 1a 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 7d 1a 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 10 60 80 00       	push   $0x806010
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 11 1a 00 00       	call   802e42 <sys_calculate_free_frames>
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
  801462:	e8 db 19 00 00       	call   802e42 <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 1e 1a 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 04 1a 00 00       	call   802e8d <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 a0 60 80 00       	push   $0x8060a0
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 98 19 00 00       	call   802e42 <sys_calculate_free_frames>
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
  801554:	e8 44 1d 00 00       	call   80329d <sys_check_WS_list>
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
  8015aa:	e8 3a 1b 00 00       	call   8030e9 <rsttst>
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
  8015da:	e8 be 19 00 00       	call   802f9d <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 c5 19 00 00       	call   802fbb <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 64 1b 00 00       	call   803163 <gettst>
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
  80162f:	e8 69 19 00 00       	call   802f9d <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 70 19 00 00       	call   802fbb <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 0f 1b 00 00       	call   803163 <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 eb 1a 00 00       	call   803149 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 79 37 00 00       	call   804de4 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 f0 1a 00 00       	call   803163 <gettst>
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
  8016ba:	e8 4c 19 00 00       	call   80300b <sys_getenvindex>
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
  801728:	e8 62 16 00 00       	call   802d8f <sys_lock_cons>
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
  8017c2:	e8 e2 15 00 00       	call   802da9 <sys_unlock_cons>
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
  8017da:	e8 f8 17 00 00       	call   802fd7 <sys_destroy_env>
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
  8017eb:	e8 4d 18 00 00       	call   80303d <sys_exit_env>
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
  801a22:	e8 26 13 00 00       	call   802d4d <sys_cputs>
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
  801a99:	e8 af 12 00 00       	call   802d4d <sys_cputs>
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
  801ae3:	e8 a7 12 00 00       	call   802d8f <sys_lock_cons>
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
  801b03:	e8 a1 12 00 00       	call   802da9 <sys_unlock_cons>
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
  801b4d:	e8 46 33 00 00       	call   804e98 <__udivdi3>
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
  801b9d:	e8 06 34 00 00       	call   804fa8 <__umoddi3>
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
  802856:	e8 9d 0a 00 00       	call   8032f8 <sys_sbrk>
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
  8028d1:	e8 a6 08 00 00       	call   80317c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 e6 0d 00 00       	call   8036cb <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 b8 08 00 00       	call   8031ad <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 7f 12 00 00       	call   803b87 <alloc_block_BF>
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
  802a69:	e8 c1 08 00 00       	call   80332f <sys_allocate_user_mem>
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
  802ab1:	e8 95 08 00 00       	call   80334b <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 c8 1a 00 00       	call   80458f <free_block>
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
  802b59:	e8 b5 07 00 00       	call   803313 <sys_free_user_mem>
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
  802bd9:	e8 3c 03 00 00       	call   802f1a <sys_createSharedObject>
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
  802bfa:	68 ae 68 80 00       	push   $0x8068ae
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
  802c0f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802c12:	83 ec 08             	sub    $0x8,%esp
  802c15:	ff 75 0c             	pushl  0xc(%ebp)
  802c18:	ff 75 08             	pushl  0x8(%ebp)
  802c1b:	e8 24 03 00 00       	call   802f44 <sys_getSizeOfSharedObject>
  802c20:	83 c4 10             	add    $0x10,%esp
  802c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802c26:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802c2a:	75 07                	jne    802c33 <sget+0x27>
  802c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c31:	eb 5c                	jmp    802c8f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c39:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	39 d0                	cmp    %edx,%eax
  802c48:	7d 02                	jge    802c4c <sget+0x40>
  802c4a:	89 d0                	mov    %edx,%eax
  802c4c:	83 ec 0c             	sub    $0xc,%esp
  802c4f:	50                   	push   %eax
  802c50:	e8 0b fc ff ff       	call   802860 <malloc>
  802c55:	83 c4 10             	add    $0x10,%esp
  802c58:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802c5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c5f:	75 07                	jne    802c68 <sget+0x5c>
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
  802c66:	eb 27                	jmp    802c8f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802c68:	83 ec 04             	sub    $0x4,%esp
  802c6b:	ff 75 e8             	pushl  -0x18(%ebp)
  802c6e:	ff 75 0c             	pushl  0xc(%ebp)
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	e8 e8 02 00 00       	call   802f61 <sys_getSharedObject>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802c7f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802c83:	75 07                	jne    802c8c <sget+0x80>
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8a:	eb 03                	jmp    802c8f <sget+0x83>
	return ptr;
  802c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802c8f:	c9                   	leave  
  802c90:	c3                   	ret    

00802c91 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 b4 68 80 00       	push   $0x8068b4
  802c9f:	68 c2 00 00 00       	push   $0xc2
  802ca4:	68 a2 68 80 00       	push   $0x8068a2
  802ca9:	e8 45 eb ff ff       	call   8017f3 <_panic>

00802cae <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802cae:	55                   	push   %ebp
  802caf:	89 e5                	mov    %esp,%ebp
  802cb1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 d8 68 80 00       	push   $0x8068d8
  802cbc:	68 d9 00 00 00       	push   $0xd9
  802cc1:	68 a2 68 80 00       	push   $0x8068a2
  802cc6:	e8 28 eb ff ff       	call   8017f3 <_panic>

00802ccb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	68 fe 68 80 00       	push   $0x8068fe
  802cd9:	68 e5 00 00 00       	push   $0xe5
  802cde:	68 a2 68 80 00       	push   $0x8068a2
  802ce3:	e8 0b eb ff ff       	call   8017f3 <_panic>

00802ce8 <shrink>:

}
void shrink(uint32 newSize)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 fe 68 80 00       	push   $0x8068fe
  802cf6:	68 ea 00 00 00       	push   $0xea
  802cfb:	68 a2 68 80 00       	push   $0x8068a2
  802d00:	e8 ee ea ff ff       	call   8017f3 <_panic>

00802d05 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d0b:	83 ec 04             	sub    $0x4,%esp
  802d0e:	68 fe 68 80 00       	push   $0x8068fe
  802d13:	68 ef 00 00 00       	push   $0xef
  802d18:	68 a2 68 80 00       	push   $0x8068a2
  802d1d:	e8 d1 ea ff ff       	call   8017f3 <_panic>

00802d22 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
  802d25:	57                   	push   %edi
  802d26:	56                   	push   %esi
  802d27:	53                   	push   %ebx
  802d28:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d37:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d3a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d3d:	cd 30                	int    $0x30
  802d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d45:	83 c4 10             	add    $0x10,%esp
  802d48:	5b                   	pop    %ebx
  802d49:	5e                   	pop    %esi
  802d4a:	5f                   	pop    %edi
  802d4b:	5d                   	pop    %ebp
  802d4c:	c3                   	ret    

00802d4d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	8b 45 10             	mov    0x10(%ebp),%eax
  802d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802d59:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	52                   	push   %edx
  802d65:	ff 75 0c             	pushl  0xc(%ebp)
  802d68:	50                   	push   %eax
  802d69:	6a 00                	push   $0x0
  802d6b:	e8 b2 ff ff ff       	call   802d22 <syscall>
  802d70:	83 c4 18             	add    $0x18,%esp
}
  802d73:	90                   	nop
  802d74:	c9                   	leave  
  802d75:	c3                   	ret    

00802d76 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d76:	55                   	push   %ebp
  802d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 02                	push   $0x2
  802d85:	e8 98 ff ff ff       	call   802d22 <syscall>
  802d8a:	83 c4 18             	add    $0x18,%esp
}
  802d8d:	c9                   	leave  
  802d8e:	c3                   	ret    

00802d8f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d8f:	55                   	push   %ebp
  802d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 03                	push   $0x3
  802d9e:	e8 7f ff ff ff       	call   802d22 <syscall>
  802da3:	83 c4 18             	add    $0x18,%esp
}
  802da6:	90                   	nop
  802da7:	c9                   	leave  
  802da8:	c3                   	ret    

00802da9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802da9:	55                   	push   %ebp
  802daa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 04                	push   $0x4
  802db8:	e8 65 ff ff ff       	call   802d22 <syscall>
  802dbd:	83 c4 18             	add    $0x18,%esp
}
  802dc0:	90                   	nop
  802dc1:	c9                   	leave  
  802dc2:	c3                   	ret    

00802dc3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	52                   	push   %edx
  802dd3:	50                   	push   %eax
  802dd4:	6a 08                	push   $0x8
  802dd6:	e8 47 ff ff ff       	call   802d22 <syscall>
  802ddb:	83 c4 18             	add    $0x18,%esp
}
  802dde:	c9                   	leave  
  802ddf:	c3                   	ret    

00802de0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802de0:	55                   	push   %ebp
  802de1:	89 e5                	mov    %esp,%ebp
  802de3:	56                   	push   %esi
  802de4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802de5:	8b 75 18             	mov    0x18(%ebp),%esi
  802de8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802deb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	56                   	push   %esi
  802df5:	53                   	push   %ebx
  802df6:	51                   	push   %ecx
  802df7:	52                   	push   %edx
  802df8:	50                   	push   %eax
  802df9:	6a 09                	push   $0x9
  802dfb:	e8 22 ff ff ff       	call   802d22 <syscall>
  802e00:	83 c4 18             	add    $0x18,%esp
}
  802e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e06:	5b                   	pop    %ebx
  802e07:	5e                   	pop    %esi
  802e08:	5d                   	pop    %ebp
  802e09:	c3                   	ret    

00802e0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802e0a:	55                   	push   %ebp
  802e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	52                   	push   %edx
  802e1a:	50                   	push   %eax
  802e1b:	6a 0a                	push   $0xa
  802e1d:	e8 00 ff ff ff       	call   802d22 <syscall>
  802e22:	83 c4 18             	add    $0x18,%esp
}
  802e25:	c9                   	leave  
  802e26:	c3                   	ret    

00802e27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e27:	55                   	push   %ebp
  802e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	ff 75 0c             	pushl  0xc(%ebp)
  802e33:	ff 75 08             	pushl  0x8(%ebp)
  802e36:	6a 0b                	push   $0xb
  802e38:	e8 e5 fe ff ff       	call   802d22 <syscall>
  802e3d:	83 c4 18             	add    $0x18,%esp
}
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    

00802e42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e42:	55                   	push   %ebp
  802e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e45:	6a 00                	push   $0x0
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	6a 0c                	push   $0xc
  802e51:	e8 cc fe ff ff       	call   802d22 <syscall>
  802e56:	83 c4 18             	add    $0x18,%esp
}
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    

00802e5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 0d                	push   $0xd
  802e6a:	e8 b3 fe ff ff       	call   802d22 <syscall>
  802e6f:	83 c4 18             	add    $0x18,%esp
}
  802e72:	c9                   	leave  
  802e73:	c3                   	ret    

00802e74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e77:	6a 00                	push   $0x0
  802e79:	6a 00                	push   $0x0
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 0e                	push   $0xe
  802e83:	e8 9a fe ff ff       	call   802d22 <syscall>
  802e88:	83 c4 18             	add    $0x18,%esp
}
  802e8b:	c9                   	leave  
  802e8c:	c3                   	ret    

00802e8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e8d:	55                   	push   %ebp
  802e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e90:	6a 00                	push   $0x0
  802e92:	6a 00                	push   $0x0
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 0f                	push   $0xf
  802e9c:	e8 81 fe ff ff       	call   802d22 <syscall>
  802ea1:	83 c4 18             	add    $0x18,%esp
}
  802ea4:	c9                   	leave  
  802ea5:	c3                   	ret    

00802ea6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ea6:	55                   	push   %ebp
  802ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 00                	push   $0x0
  802ead:	6a 00                	push   $0x0
  802eaf:	6a 00                	push   $0x0
  802eb1:	ff 75 08             	pushl  0x8(%ebp)
  802eb4:	6a 10                	push   $0x10
  802eb6:	e8 67 fe ff ff       	call   802d22 <syscall>
  802ebb:	83 c4 18             	add    $0x18,%esp
}
  802ebe:	c9                   	leave  
  802ebf:	c3                   	ret    

00802ec0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ec0:	55                   	push   %ebp
  802ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 11                	push   $0x11
  802ecf:	e8 4e fe ff ff       	call   802d22 <syscall>
  802ed4:	83 c4 18             	add    $0x18,%esp
}
  802ed7:	90                   	nop
  802ed8:	c9                   	leave  
  802ed9:	c3                   	ret    

00802eda <sys_cputc>:

void
sys_cputc(const char c)
{
  802eda:	55                   	push   %ebp
  802edb:	89 e5                	mov    %esp,%ebp
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ee6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802eea:	6a 00                	push   $0x0
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	50                   	push   %eax
  802ef3:	6a 01                	push   $0x1
  802ef5:	e8 28 fe ff ff       	call   802d22 <syscall>
  802efa:	83 c4 18             	add    $0x18,%esp
}
  802efd:	90                   	nop
  802efe:	c9                   	leave  
  802eff:	c3                   	ret    

00802f00 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 14                	push   $0x14
  802f0f:	e8 0e fe ff ff       	call   802d22 <syscall>
  802f14:	83 c4 18             	add    $0x18,%esp
}
  802f17:	90                   	nop
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    

00802f1a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
  802f1d:	83 ec 04             	sub    $0x4,%esp
  802f20:	8b 45 10             	mov    0x10(%ebp),%eax
  802f23:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f29:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	6a 00                	push   $0x0
  802f32:	51                   	push   %ecx
  802f33:	52                   	push   %edx
  802f34:	ff 75 0c             	pushl  0xc(%ebp)
  802f37:	50                   	push   %eax
  802f38:	6a 15                	push   $0x15
  802f3a:	e8 e3 fd ff ff       	call   802d22 <syscall>
  802f3f:	83 c4 18             	add    $0x18,%esp
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	52                   	push   %edx
  802f54:	50                   	push   %eax
  802f55:	6a 16                	push   $0x16
  802f57:	e8 c6 fd ff ff       	call   802d22 <syscall>
  802f5c:	83 c4 18             	add    $0x18,%esp
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	51                   	push   %ecx
  802f72:	52                   	push   %edx
  802f73:	50                   	push   %eax
  802f74:	6a 17                	push   $0x17
  802f76:	e8 a7 fd ff ff       	call   802d22 <syscall>
  802f7b:	83 c4 18             	add    $0x18,%esp
}
  802f7e:	c9                   	leave  
  802f7f:	c3                   	ret    

00802f80 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	52                   	push   %edx
  802f90:	50                   	push   %eax
  802f91:	6a 18                	push   $0x18
  802f93:	e8 8a fd ff ff       	call   802d22 <syscall>
  802f98:	83 c4 18             	add    $0x18,%esp
}
  802f9b:	c9                   	leave  
  802f9c:	c3                   	ret    

00802f9d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	6a 00                	push   $0x0
  802fa5:	ff 75 14             	pushl  0x14(%ebp)
  802fa8:	ff 75 10             	pushl  0x10(%ebp)
  802fab:	ff 75 0c             	pushl  0xc(%ebp)
  802fae:	50                   	push   %eax
  802faf:	6a 19                	push   $0x19
  802fb1:	e8 6c fd ff ff       	call   802d22 <syscall>
  802fb6:	83 c4 18             	add    $0x18,%esp
}
  802fb9:	c9                   	leave  
  802fba:	c3                   	ret    

00802fbb <sys_run_env>:

void sys_run_env(int32 envId)
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	50                   	push   %eax
  802fca:	6a 1a                	push   $0x1a
  802fcc:	e8 51 fd ff ff       	call   802d22 <syscall>
  802fd1:	83 c4 18             	add    $0x18,%esp
}
  802fd4:	90                   	nop
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	50                   	push   %eax
  802fe6:	6a 1b                	push   $0x1b
  802fe8:	e8 35 fd ff ff       	call   802d22 <syscall>
  802fed:	83 c4 18             	add    $0x18,%esp
}
  802ff0:	c9                   	leave  
  802ff1:	c3                   	ret    

00802ff2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ff2:	55                   	push   %ebp
  802ff3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 05                	push   $0x5
  803001:	e8 1c fd ff ff       	call   802d22 <syscall>
  803006:	83 c4 18             	add    $0x18,%esp
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	6a 06                	push   $0x6
  80301a:	e8 03 fd ff ff       	call   802d22 <syscall>
  80301f:	83 c4 18             	add    $0x18,%esp
}
  803022:	c9                   	leave  
  803023:	c3                   	ret    

00803024 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803024:	55                   	push   %ebp
  803025:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803027:	6a 00                	push   $0x0
  803029:	6a 00                	push   $0x0
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	6a 00                	push   $0x0
  803031:	6a 07                	push   $0x7
  803033:	e8 ea fc ff ff       	call   802d22 <syscall>
  803038:	83 c4 18             	add    $0x18,%esp
}
  80303b:	c9                   	leave  
  80303c:	c3                   	ret    

0080303d <sys_exit_env>:


void sys_exit_env(void)
{
  80303d:	55                   	push   %ebp
  80303e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803040:	6a 00                	push   $0x0
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 1c                	push   $0x1c
  80304c:	e8 d1 fc ff ff       	call   802d22 <syscall>
  803051:	83 c4 18             	add    $0x18,%esp
}
  803054:	90                   	nop
  803055:	c9                   	leave  
  803056:	c3                   	ret    

00803057 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803057:	55                   	push   %ebp
  803058:	89 e5                	mov    %esp,%ebp
  80305a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80305d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803060:	8d 50 04             	lea    0x4(%eax),%edx
  803063:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 00                	push   $0x0
  80306c:	52                   	push   %edx
  80306d:	50                   	push   %eax
  80306e:	6a 1d                	push   $0x1d
  803070:	e8 ad fc ff ff       	call   802d22 <syscall>
  803075:	83 c4 18             	add    $0x18,%esp
	return result;
  803078:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80307b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80307e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803081:	89 01                	mov    %eax,(%ecx)
  803083:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	c9                   	leave  
  80308a:	c2 04 00             	ret    $0x4

0080308d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80308d:	55                   	push   %ebp
  80308e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	ff 75 10             	pushl  0x10(%ebp)
  803097:	ff 75 0c             	pushl  0xc(%ebp)
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	6a 13                	push   $0x13
  80309f:	e8 7e fc ff ff       	call   802d22 <syscall>
  8030a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8030a7:	90                   	nop
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <sys_rcr2>:
uint32 sys_rcr2()
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 1e                	push   $0x1e
  8030b9:	e8 64 fc ff ff       	call   802d22 <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8030cf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	50                   	push   %eax
  8030dc:	6a 1f                	push   $0x1f
  8030de:	e8 3f fc ff ff       	call   802d22 <syscall>
  8030e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8030e6:	90                   	nop
}
  8030e7:	c9                   	leave  
  8030e8:	c3                   	ret    

008030e9 <rsttst>:
void rsttst()
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 21                	push   $0x21
  8030f8:	e8 25 fc ff ff       	call   802d22 <syscall>
  8030fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803100:	90                   	nop
}
  803101:	c9                   	leave  
  803102:	c3                   	ret    

00803103 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	8b 45 14             	mov    0x14(%ebp),%eax
  80310c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80310f:	8b 55 18             	mov    0x18(%ebp),%edx
  803112:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803116:	52                   	push   %edx
  803117:	50                   	push   %eax
  803118:	ff 75 10             	pushl  0x10(%ebp)
  80311b:	ff 75 0c             	pushl  0xc(%ebp)
  80311e:	ff 75 08             	pushl  0x8(%ebp)
  803121:	6a 20                	push   $0x20
  803123:	e8 fa fb ff ff       	call   802d22 <syscall>
  803128:	83 c4 18             	add    $0x18,%esp
	return ;
  80312b:	90                   	nop
}
  80312c:	c9                   	leave  
  80312d:	c3                   	ret    

0080312e <chktst>:
void chktst(uint32 n)
{
  80312e:	55                   	push   %ebp
  80312f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	6a 00                	push   $0x0
  803139:	ff 75 08             	pushl  0x8(%ebp)
  80313c:	6a 22                	push   $0x22
  80313e:	e8 df fb ff ff       	call   802d22 <syscall>
  803143:	83 c4 18             	add    $0x18,%esp
	return ;
  803146:	90                   	nop
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    

00803149 <inctst>:

void inctst()
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 23                	push   $0x23
  803158:	e8 c5 fb ff ff       	call   802d22 <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
	return ;
  803160:	90                   	nop
}
  803161:	c9                   	leave  
  803162:	c3                   	ret    

00803163 <gettst>:
uint32 gettst()
{
  803163:	55                   	push   %ebp
  803164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 24                	push   $0x24
  803172:	e8 ab fb ff ff       	call   802d22 <syscall>
  803177:	83 c4 18             	add    $0x18,%esp
}
  80317a:	c9                   	leave  
  80317b:	c3                   	ret    

0080317c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803182:	6a 00                	push   $0x0
  803184:	6a 00                	push   $0x0
  803186:	6a 00                	push   $0x0
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 25                	push   $0x25
  80318e:	e8 8f fb ff ff       	call   802d22 <syscall>
  803193:	83 c4 18             	add    $0x18,%esp
  803196:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803199:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80319d:	75 07                	jne    8031a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80319f:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a4:	eb 05                	jmp    8031ab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8031a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
  8031b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 00                	push   $0x0
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 25                	push   $0x25
  8031bf:	e8 5e fb ff ff       	call   802d22 <syscall>
  8031c4:	83 c4 18             	add    $0x18,%esp
  8031c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8031ca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8031ce:	75 07                	jne    8031d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8031d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d5:	eb 05                	jmp    8031dc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031e4:	6a 00                	push   $0x0
  8031e6:	6a 00                	push   $0x0
  8031e8:	6a 00                	push   $0x0
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 25                	push   $0x25
  8031f0:	e8 2d fb ff ff       	call   802d22 <syscall>
  8031f5:	83 c4 18             	add    $0x18,%esp
  8031f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8031fb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8031ff:	75 07                	jne    803208 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803201:	b8 01 00 00 00       	mov    $0x1,%eax
  803206:	eb 05                	jmp    80320d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80320d:	c9                   	leave  
  80320e:	c3                   	ret    

0080320f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80320f:	55                   	push   %ebp
  803210:	89 e5                	mov    %esp,%ebp
  803212:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803215:	6a 00                	push   $0x0
  803217:	6a 00                	push   $0x0
  803219:	6a 00                	push   $0x0
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 25                	push   $0x25
  803221:	e8 fc fa ff ff       	call   802d22 <syscall>
  803226:	83 c4 18             	add    $0x18,%esp
  803229:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80322c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803230:	75 07                	jne    803239 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803232:	b8 01 00 00 00       	mov    $0x1,%eax
  803237:	eb 05                	jmp    80323e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80323e:	c9                   	leave  
  80323f:	c3                   	ret    

00803240 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803240:	55                   	push   %ebp
  803241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	ff 75 08             	pushl  0x8(%ebp)
  80324e:	6a 26                	push   $0x26
  803250:	e8 cd fa ff ff       	call   802d22 <syscall>
  803255:	83 c4 18             	add    $0x18,%esp
	return ;
  803258:	90                   	nop
}
  803259:	c9                   	leave  
  80325a:	c3                   	ret    

0080325b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80325b:	55                   	push   %ebp
  80325c:	89 e5                	mov    %esp,%ebp
  80325e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80325f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803262:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803265:	8b 55 0c             	mov    0xc(%ebp),%edx
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	6a 00                	push   $0x0
  80326d:	53                   	push   %ebx
  80326e:	51                   	push   %ecx
  80326f:	52                   	push   %edx
  803270:	50                   	push   %eax
  803271:	6a 27                	push   $0x27
  803273:	e8 aa fa ff ff       	call   802d22 <syscall>
  803278:	83 c4 18             	add    $0x18,%esp
}
  80327b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80327e:	c9                   	leave  
  80327f:	c3                   	ret    

00803280 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803280:	55                   	push   %ebp
  803281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803283:	8b 55 0c             	mov    0xc(%ebp),%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	6a 00                	push   $0x0
  80328b:	6a 00                	push   $0x0
  80328d:	6a 00                	push   $0x0
  80328f:	52                   	push   %edx
  803290:	50                   	push   %eax
  803291:	6a 28                	push   $0x28
  803293:	e8 8a fa ff ff       	call   802d22 <syscall>
  803298:	83 c4 18             	add    $0x18,%esp
}
  80329b:	c9                   	leave  
  80329c:	c3                   	ret    

0080329d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80329d:	55                   	push   %ebp
  80329e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	6a 00                	push   $0x0
  8032ab:	51                   	push   %ecx
  8032ac:	ff 75 10             	pushl  0x10(%ebp)
  8032af:	52                   	push   %edx
  8032b0:	50                   	push   %eax
  8032b1:	6a 29                	push   $0x29
  8032b3:	e8 6a fa ff ff       	call   802d22 <syscall>
  8032b8:	83 c4 18             	add    $0x18,%esp
}
  8032bb:	c9                   	leave  
  8032bc:	c3                   	ret    

008032bd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8032bd:	55                   	push   %ebp
  8032be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	ff 75 10             	pushl  0x10(%ebp)
  8032c7:	ff 75 0c             	pushl  0xc(%ebp)
  8032ca:	ff 75 08             	pushl  0x8(%ebp)
  8032cd:	6a 12                	push   $0x12
  8032cf:	e8 4e fa ff ff       	call   802d22 <syscall>
  8032d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032d7:	90                   	nop
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8032dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	6a 00                	push   $0x0
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 00                	push   $0x0
  8032e9:	52                   	push   %edx
  8032ea:	50                   	push   %eax
  8032eb:	6a 2a                	push   $0x2a
  8032ed:	e8 30 fa ff ff       	call   802d22 <syscall>
  8032f2:	83 c4 18             	add    $0x18,%esp
	return;
  8032f5:	90                   	nop
}
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	50                   	push   %eax
  803307:	6a 2b                	push   $0x2b
  803309:	e8 14 fa ff ff       	call   802d22 <syscall>
  80330e:	83 c4 18             	add    $0x18,%esp
}
  803311:	c9                   	leave  
  803312:	c3                   	ret    

00803313 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803313:	55                   	push   %ebp
  803314:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803316:	6a 00                	push   $0x0
  803318:	6a 00                	push   $0x0
  80331a:	6a 00                	push   $0x0
  80331c:	ff 75 0c             	pushl  0xc(%ebp)
  80331f:	ff 75 08             	pushl  0x8(%ebp)
  803322:	6a 2c                	push   $0x2c
  803324:	e8 f9 f9 ff ff       	call   802d22 <syscall>
  803329:	83 c4 18             	add    $0x18,%esp
	return;
  80332c:	90                   	nop
}
  80332d:	c9                   	leave  
  80332e:	c3                   	ret    

0080332f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80332f:	55                   	push   %ebp
  803330:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  803332:	6a 00                	push   $0x0
  803334:	6a 00                	push   $0x0
  803336:	6a 00                	push   $0x0
  803338:	ff 75 0c             	pushl  0xc(%ebp)
  80333b:	ff 75 08             	pushl  0x8(%ebp)
  80333e:	6a 2d                	push   $0x2d
  803340:	e8 dd f9 ff ff       	call   802d22 <syscall>
  803345:	83 c4 18             	add    $0x18,%esp
	return;
  803348:	90                   	nop
}
  803349:	c9                   	leave  
  80334a:	c3                   	ret    

0080334b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80334b:	55                   	push   %ebp
  80334c:	89 e5                	mov    %esp,%ebp
  80334e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	83 e8 04             	sub    $0x4,%eax
  803357:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80335a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803362:	c9                   	leave  
  803363:	c3                   	ret    

00803364 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803364:	55                   	push   %ebp
  803365:	89 e5                	mov    %esp,%ebp
  803367:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	83 e8 04             	sub    $0x4,%eax
  803370:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  803373:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	83 e0 01             	and    $0x1,%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	0f 94 c0             	sete   %al
}
  803380:	c9                   	leave  
  803381:	c3                   	ret    

00803382 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803382:	55                   	push   %ebp
  803383:	89 e5                	mov    %esp,%ebp
  803385:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80338f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803392:	83 f8 02             	cmp    $0x2,%eax
  803395:	74 2b                	je     8033c2 <alloc_block+0x40>
  803397:	83 f8 02             	cmp    $0x2,%eax
  80339a:	7f 07                	jg     8033a3 <alloc_block+0x21>
  80339c:	83 f8 01             	cmp    $0x1,%eax
  80339f:	74 0e                	je     8033af <alloc_block+0x2d>
  8033a1:	eb 58                	jmp    8033fb <alloc_block+0x79>
  8033a3:	83 f8 03             	cmp    $0x3,%eax
  8033a6:	74 2d                	je     8033d5 <alloc_block+0x53>
  8033a8:	83 f8 04             	cmp    $0x4,%eax
  8033ab:	74 3b                	je     8033e8 <alloc_block+0x66>
  8033ad:	eb 4c                	jmp    8033fb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	ff 75 08             	pushl  0x8(%ebp)
  8033b5:	e8 11 03 00 00       	call   8036cb <alloc_block_FF>
  8033ba:	83 c4 10             	add    $0x10,%esp
  8033bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033c0:	eb 4a                	jmp    80340c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8033c2:	83 ec 0c             	sub    $0xc,%esp
  8033c5:	ff 75 08             	pushl  0x8(%ebp)
  8033c8:	e8 fa 19 00 00       	call   804dc7 <alloc_block_NF>
  8033cd:	83 c4 10             	add    $0x10,%esp
  8033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033d3:	eb 37                	jmp    80340c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8033d5:	83 ec 0c             	sub    $0xc,%esp
  8033d8:	ff 75 08             	pushl  0x8(%ebp)
  8033db:	e8 a7 07 00 00       	call   803b87 <alloc_block_BF>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033e6:	eb 24                	jmp    80340c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8033e8:	83 ec 0c             	sub    $0xc,%esp
  8033eb:	ff 75 08             	pushl  0x8(%ebp)
  8033ee:	e8 b7 19 00 00       	call   804daa <alloc_block_WF>
  8033f3:	83 c4 10             	add    $0x10,%esp
  8033f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033f9:	eb 11                	jmp    80340c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8033fb:	83 ec 0c             	sub    $0xc,%esp
  8033fe:	68 10 69 80 00       	push   $0x806910
  803403:	e8 a8 e6 ff ff       	call   801ab0 <cprintf>
  803408:	83 c4 10             	add    $0x10,%esp
		break;
  80340b:	90                   	nop
	}
	return va;
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	53                   	push   %ebx
  803415:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	68 30 69 80 00       	push   $0x806930
  803420:	e8 8b e6 ff ff       	call   801ab0 <cprintf>
  803425:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803428:	83 ec 0c             	sub    $0xc,%esp
  80342b:	68 5b 69 80 00       	push   $0x80695b
  803430:	e8 7b e6 ff ff       	call   801ab0 <cprintf>
  803435:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343e:	eb 37                	jmp    803477 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803440:	83 ec 0c             	sub    $0xc,%esp
  803443:	ff 75 f4             	pushl  -0xc(%ebp)
  803446:	e8 19 ff ff ff       	call   803364 <is_free_block>
  80344b:	83 c4 10             	add    $0x10,%esp
  80344e:	0f be d8             	movsbl %al,%ebx
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 f4             	pushl  -0xc(%ebp)
  803457:	e8 ef fe ff ff       	call   80334b <get_block_size>
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	53                   	push   %ebx
  803463:	50                   	push   %eax
  803464:	68 73 69 80 00       	push   $0x806973
  803469:	e8 42 e6 ff ff       	call   801ab0 <cprintf>
  80346e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803471:	8b 45 10             	mov    0x10(%ebp),%eax
  803474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347b:	74 07                	je     803484 <print_blocks_list+0x73>
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	eb 05                	jmp    803489 <print_blocks_list+0x78>
  803484:	b8 00 00 00 00       	mov    $0x0,%eax
  803489:	89 45 10             	mov    %eax,0x10(%ebp)
  80348c:	8b 45 10             	mov    0x10(%ebp),%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	75 ad                	jne    803440 <print_blocks_list+0x2f>
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	75 a7                	jne    803440 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803499:	83 ec 0c             	sub    $0xc,%esp
  80349c:	68 30 69 80 00       	push   $0x806930
  8034a1:	e8 0a e6 ff ff       	call   801ab0 <cprintf>
  8034a6:	83 c4 10             	add    $0x10,%esp

}
  8034a9:	90                   	nop
  8034aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034ad:	c9                   	leave  
  8034ae:	c3                   	ret    

008034af <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8034af:	55                   	push   %ebp
  8034b0:	89 e5                	mov    %esp,%ebp
  8034b2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8034b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b8:	83 e0 01             	and    $0x1,%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	74 03                	je     8034c2 <initialize_dynamic_allocator+0x13>
  8034bf:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8034c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c6:	0f 84 c7 01 00 00    	je     803693 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8034cc:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  8034d3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8034d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034dc:	01 d0                	add    %edx,%eax
  8034de:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8034e3:	0f 87 ad 01 00 00    	ja     803696 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	0f 89 a5 01 00 00    	jns    803699 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8034f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	83 e8 04             	sub    $0x4,%eax
  8034ff:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  803504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80350b:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803513:	e9 87 00 00 00       	jmp    80359f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351c:	75 14                	jne    803532 <initialize_dynamic_allocator+0x83>
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	68 8b 69 80 00       	push   $0x80698b
  803526:	6a 79                	push   $0x79
  803528:	68 a9 69 80 00       	push   $0x8069a9
  80352d:	e8 c1 e2 ff ff       	call   8017f3 <_panic>
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	85 c0                	test   %eax,%eax
  803539:	74 10                	je     80354b <initialize_dynamic_allocator+0x9c>
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803543:	8b 52 04             	mov    0x4(%edx),%edx
  803546:	89 50 04             	mov    %edx,0x4(%eax)
  803549:	eb 0b                	jmp    803556 <initialize_dynamic_allocator+0xa7>
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	8b 40 04             	mov    0x4(%eax),%eax
  803551:	a3 30 70 80 00       	mov    %eax,0x807030
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 40 04             	mov    0x4(%eax),%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	74 0f                	je     80356f <initialize_dynamic_allocator+0xc0>
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 40 04             	mov    0x4(%eax),%eax
  803566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803569:	8b 12                	mov    (%edx),%edx
  80356b:	89 10                	mov    %edx,(%eax)
  80356d:	eb 0a                	jmp    803579 <initialize_dynamic_allocator+0xca>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358c:	a1 38 70 80 00       	mov    0x807038,%eax
  803591:	48                   	dec    %eax
  803592:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803597:	a1 34 70 80 00       	mov    0x807034,%eax
  80359c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a3:	74 07                	je     8035ac <initialize_dynamic_allocator+0xfd>
  8035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	eb 05                	jmp    8035b1 <initialize_dynamic_allocator+0x102>
  8035ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b1:	a3 34 70 80 00       	mov    %eax,0x807034
  8035b6:	a1 34 70 80 00       	mov    0x807034,%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	0f 85 55 ff ff ff    	jne    803518 <initialize_dynamic_allocator+0x69>
  8035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c7:	0f 85 4b ff ff ff    	jne    803518 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8035d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8035dc:	a1 44 70 80 00       	mov    0x807044,%eax
  8035e1:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  8035e6:	a1 40 70 80 00       	mov    0x807040,%eax
  8035eb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	83 c0 08             	add    $0x8,%eax
  8035f7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	83 c0 04             	add    $0x4,%eax
  803600:	8b 55 0c             	mov    0xc(%ebp),%edx
  803603:	83 ea 08             	sub    $0x8,%edx
  803606:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	01 d0                	add    %edx,%eax
  803610:	83 e8 08             	sub    $0x8,%eax
  803613:	8b 55 0c             	mov    0xc(%ebp),%edx
  803616:	83 ea 08             	sub    $0x8,%edx
  803619:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80361b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80362e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803632:	75 17                	jne    80364b <initialize_dynamic_allocator+0x19c>
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 c4 69 80 00       	push   $0x8069c4
  80363c:	68 90 00 00 00       	push   $0x90
  803641:	68 a9 69 80 00       	push   $0x8069a9
  803646:	e8 a8 e1 ff ff       	call   8017f3 <_panic>
  80364b:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803654:	89 10                	mov    %edx,(%eax)
  803656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803659:	8b 00                	mov    (%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0d                	je     80366c <initialize_dynamic_allocator+0x1bd>
  80365f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803664:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803667:	89 50 04             	mov    %edx,0x4(%eax)
  80366a:	eb 08                	jmp    803674 <initialize_dynamic_allocator+0x1c5>
  80366c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366f:	a3 30 70 80 00       	mov    %eax,0x807030
  803674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803677:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80367c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803686:	a1 38 70 80 00       	mov    0x807038,%eax
  80368b:	40                   	inc    %eax
  80368c:	a3 38 70 80 00       	mov    %eax,0x807038
  803691:	eb 07                	jmp    80369a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803693:	90                   	nop
  803694:	eb 04                	jmp    80369a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803696:	90                   	nop
  803697:	eb 01                	jmp    80369a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803699:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80369a:	c9                   	leave  
  80369b:	c3                   	ret    

0080369c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80369c:	55                   	push   %ebp
  80369d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80369f:	8b 45 10             	mov    0x10(%ebp),%eax
  8036a2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8036ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ae:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	83 e8 04             	sub    $0x4,%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8036bb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	01 c2                	add    %eax,%edx
  8036c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c6:	89 02                	mov    %eax,(%edx)
}
  8036c8:	90                   	nop
  8036c9:	5d                   	pop    %ebp
  8036ca:	c3                   	ret    

008036cb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8036cb:	55                   	push   %ebp
  8036cc:	89 e5                	mov    %esp,%ebp
  8036ce:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	83 e0 01             	and    $0x1,%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 03                	je     8036de <alloc_block_FF+0x13>
  8036db:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8036de:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8036e2:	77 07                	ja     8036eb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8036e4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8036eb:	a1 24 70 80 00       	mov    0x807024,%eax
  8036f0:	85 c0                	test   %eax,%eax
  8036f2:	75 73                	jne    803767 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	83 c0 10             	add    $0x10,%eax
  8036fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8036fd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370a:	01 d0                	add    %edx,%eax
  80370c:	48                   	dec    %eax
  80370d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803713:	ba 00 00 00 00       	mov    $0x0,%edx
  803718:	f7 75 ec             	divl   -0x14(%ebp)
  80371b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371e:	29 d0                	sub    %edx,%eax
  803720:	c1 e8 0c             	shr    $0xc,%eax
  803723:	83 ec 0c             	sub    $0xc,%esp
  803726:	50                   	push   %eax
  803727:	e8 1e f1 ff ff       	call   80284a <sbrk>
  80372c:	83 c4 10             	add    $0x10,%esp
  80372f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803732:	83 ec 0c             	sub    $0xc,%esp
  803735:	6a 00                	push   $0x0
  803737:	e8 0e f1 ff ff       	call   80284a <sbrk>
  80373c:	83 c4 10             	add    $0x10,%esp
  80373f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803742:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803745:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803748:	83 ec 08             	sub    $0x8,%esp
  80374b:	50                   	push   %eax
  80374c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80374f:	e8 5b fd ff ff       	call   8034af <initialize_dynamic_allocator>
  803754:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803757:	83 ec 0c             	sub    $0xc,%esp
  80375a:	68 e7 69 80 00       	push   $0x8069e7
  80375f:	e8 4c e3 ff ff       	call   801ab0 <cprintf>
  803764:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803767:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80376b:	75 0a                	jne    803777 <alloc_block_FF+0xac>
	        return NULL;
  80376d:	b8 00 00 00 00       	mov    $0x0,%eax
  803772:	e9 0e 04 00 00       	jmp    803b85 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80377e:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803783:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803786:	e9 f3 02 00 00       	jmp    803a7e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803791:	83 ec 0c             	sub    $0xc,%esp
  803794:	ff 75 bc             	pushl  -0x44(%ebp)
  803797:	e8 af fb ff ff       	call   80334b <get_block_size>
  80379c:	83 c4 10             	add    $0x10,%esp
  80379f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	83 c0 08             	add    $0x8,%eax
  8037a8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8037ab:	0f 87 c5 02 00 00    	ja     803a76 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	83 c0 18             	add    $0x18,%eax
  8037b7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8037ba:	0f 87 19 02 00 00    	ja     8039d9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8037c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8037c6:	83 e8 08             	sub    $0x8,%eax
  8037c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	8d 50 08             	lea    0x8(%eax),%edx
  8037d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8037d5:	01 d0                	add    %edx,%eax
  8037d7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	83 c0 08             	add    $0x8,%eax
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	6a 01                	push   $0x1
  8037e5:	50                   	push   %eax
  8037e6:	ff 75 bc             	pushl  -0x44(%ebp)
  8037e9:	e8 ae fe ff ff       	call   80369c <set_block_data>
  8037ee:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	75 68                	jne    803863 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037fb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8037ff:	75 17                	jne    803818 <alloc_block_FF+0x14d>
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	68 c4 69 80 00       	push   $0x8069c4
  803809:	68 d7 00 00 00       	push   $0xd7
  80380e:	68 a9 69 80 00       	push   $0x8069a9
  803813:	e8 db df ff ff       	call   8017f3 <_panic>
  803818:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80381e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803821:	89 10                	mov    %edx,(%eax)
  803823:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	85 c0                	test   %eax,%eax
  80382a:	74 0d                	je     803839 <alloc_block_FF+0x16e>
  80382c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803831:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803834:	89 50 04             	mov    %edx,0x4(%eax)
  803837:	eb 08                	jmp    803841 <alloc_block_FF+0x176>
  803839:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80383c:	a3 30 70 80 00       	mov    %eax,0x807030
  803841:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803844:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803849:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80384c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803853:	a1 38 70 80 00       	mov    0x807038,%eax
  803858:	40                   	inc    %eax
  803859:	a3 38 70 80 00       	mov    %eax,0x807038
  80385e:	e9 dc 00 00 00       	jmp    80393f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	85 c0                	test   %eax,%eax
  80386a:	75 65                	jne    8038d1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80386c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803870:	75 17                	jne    803889 <alloc_block_FF+0x1be>
  803872:	83 ec 04             	sub    $0x4,%esp
  803875:	68 f8 69 80 00       	push   $0x8069f8
  80387a:	68 db 00 00 00       	push   $0xdb
  80387f:	68 a9 69 80 00       	push   $0x8069a9
  803884:	e8 6a df ff ff       	call   8017f3 <_panic>
  803889:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80388f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803892:	89 50 04             	mov    %edx,0x4(%eax)
  803895:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803898:	8b 40 04             	mov    0x4(%eax),%eax
  80389b:	85 c0                	test   %eax,%eax
  80389d:	74 0c                	je     8038ab <alloc_block_FF+0x1e0>
  80389f:	a1 30 70 80 00       	mov    0x807030,%eax
  8038a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038a7:	89 10                	mov    %edx,(%eax)
  8038a9:	eb 08                	jmp    8038b3 <alloc_block_FF+0x1e8>
  8038ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038ae:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8038b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038b6:	a3 30 70 80 00       	mov    %eax,0x807030
  8038bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c4:	a1 38 70 80 00       	mov    0x807038,%eax
  8038c9:	40                   	inc    %eax
  8038ca:	a3 38 70 80 00       	mov    %eax,0x807038
  8038cf:	eb 6e                	jmp    80393f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8038d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d5:	74 06                	je     8038dd <alloc_block_FF+0x212>
  8038d7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8038db:	75 17                	jne    8038f4 <alloc_block_FF+0x229>
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	68 1c 6a 80 00       	push   $0x806a1c
  8038e5:	68 df 00 00 00       	push   $0xdf
  8038ea:	68 a9 69 80 00       	push   $0x8069a9
  8038ef:	e8 ff de ff ff       	call   8017f3 <_panic>
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 10                	mov    (%eax),%edx
  8038f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038fc:	89 10                	mov    %edx,(%eax)
  8038fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803901:	8b 00                	mov    (%eax),%eax
  803903:	85 c0                	test   %eax,%eax
  803905:	74 0b                	je     803912 <alloc_block_FF+0x247>
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80390f:	89 50 04             	mov    %edx,0x4(%eax)
  803912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803915:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803918:	89 10                	mov    %edx,(%eax)
  80391a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80391d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803920:	89 50 04             	mov    %edx,0x4(%eax)
  803923:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803926:	8b 00                	mov    (%eax),%eax
  803928:	85 c0                	test   %eax,%eax
  80392a:	75 08                	jne    803934 <alloc_block_FF+0x269>
  80392c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80392f:	a3 30 70 80 00       	mov    %eax,0x807030
  803934:	a1 38 70 80 00       	mov    0x807038,%eax
  803939:	40                   	inc    %eax
  80393a:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80393f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803943:	75 17                	jne    80395c <alloc_block_FF+0x291>
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	68 8b 69 80 00       	push   $0x80698b
  80394d:	68 e1 00 00 00       	push   $0xe1
  803952:	68 a9 69 80 00       	push   $0x8069a9
  803957:	e8 97 de ff ff       	call   8017f3 <_panic>
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	74 10                	je     803975 <alloc_block_FF+0x2aa>
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80396d:	8b 52 04             	mov    0x4(%edx),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	eb 0b                	jmp    803980 <alloc_block_FF+0x2b5>
  803975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803978:	8b 40 04             	mov    0x4(%eax),%eax
  80397b:	a3 30 70 80 00       	mov    %eax,0x807030
  803980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803983:	8b 40 04             	mov    0x4(%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 0f                	je     803999 <alloc_block_FF+0x2ce>
  80398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398d:	8b 40 04             	mov    0x4(%eax),%eax
  803990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803993:	8b 12                	mov    (%edx),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	eb 0a                	jmp    8039a3 <alloc_block_FF+0x2d8>
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	8b 00                	mov    (%eax),%eax
  80399e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b6:	a1 38 70 80 00       	mov    0x807038,%eax
  8039bb:	48                   	dec    %eax
  8039bc:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	6a 00                	push   $0x0
  8039c6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8039c9:	ff 75 b0             	pushl  -0x50(%ebp)
  8039cc:	e8 cb fc ff ff       	call   80369c <set_block_data>
  8039d1:	83 c4 10             	add    $0x10,%esp
  8039d4:	e9 95 00 00 00       	jmp    803a6e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8039d9:	83 ec 04             	sub    $0x4,%esp
  8039dc:	6a 01                	push   $0x1
  8039de:	ff 75 b8             	pushl  -0x48(%ebp)
  8039e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8039e4:	e8 b3 fc ff ff       	call   80369c <set_block_data>
  8039e9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8039ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f0:	75 17                	jne    803a09 <alloc_block_FF+0x33e>
  8039f2:	83 ec 04             	sub    $0x4,%esp
  8039f5:	68 8b 69 80 00       	push   $0x80698b
  8039fa:	68 e8 00 00 00       	push   $0xe8
  8039ff:	68 a9 69 80 00       	push   $0x8069a9
  803a04:	e8 ea dd ff ff       	call   8017f3 <_panic>
  803a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	74 10                	je     803a22 <alloc_block_FF+0x357>
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 00                	mov    (%eax),%eax
  803a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a1a:	8b 52 04             	mov    0x4(%edx),%edx
  803a1d:	89 50 04             	mov    %edx,0x4(%eax)
  803a20:	eb 0b                	jmp    803a2d <alloc_block_FF+0x362>
  803a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a25:	8b 40 04             	mov    0x4(%eax),%eax
  803a28:	a3 30 70 80 00       	mov    %eax,0x807030
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	8b 40 04             	mov    0x4(%eax),%eax
  803a33:	85 c0                	test   %eax,%eax
  803a35:	74 0f                	je     803a46 <alloc_block_FF+0x37b>
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a40:	8b 12                	mov    (%edx),%edx
  803a42:	89 10                	mov    %edx,(%eax)
  803a44:	eb 0a                	jmp    803a50 <alloc_block_FF+0x385>
  803a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a49:	8b 00                	mov    (%eax),%eax
  803a4b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a63:	a1 38 70 80 00       	mov    0x807038,%eax
  803a68:	48                   	dec    %eax
  803a69:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  803a6e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a71:	e9 0f 01 00 00       	jmp    803b85 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803a76:	a1 34 70 80 00       	mov    0x807034,%eax
  803a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a82:	74 07                	je     803a8b <alloc_block_FF+0x3c0>
  803a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	eb 05                	jmp    803a90 <alloc_block_FF+0x3c5>
  803a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a90:	a3 34 70 80 00       	mov    %eax,0x807034
  803a95:	a1 34 70 80 00       	mov    0x807034,%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	0f 85 e9 fc ff ff    	jne    80378b <alloc_block_FF+0xc0>
  803aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa6:	0f 85 df fc ff ff    	jne    80378b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803aac:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaf:	83 c0 08             	add    $0x8,%eax
  803ab2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803ab5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803abf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	48                   	dec    %eax
  803ac5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803ac8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803acb:	ba 00 00 00 00       	mov    $0x0,%edx
  803ad0:	f7 75 d8             	divl   -0x28(%ebp)
  803ad3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad6:	29 d0                	sub    %edx,%eax
  803ad8:	c1 e8 0c             	shr    $0xc,%eax
  803adb:	83 ec 0c             	sub    $0xc,%esp
  803ade:	50                   	push   %eax
  803adf:	e8 66 ed ff ff       	call   80284a <sbrk>
  803ae4:	83 c4 10             	add    $0x10,%esp
  803ae7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803aea:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803aee:	75 0a                	jne    803afa <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803af0:	b8 00 00 00 00       	mov    $0x0,%eax
  803af5:	e9 8b 00 00 00       	jmp    803b85 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803afa:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803b01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b07:	01 d0                	add    %edx,%eax
  803b09:	48                   	dec    %eax
  803b0a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803b0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b10:	ba 00 00 00 00       	mov    $0x0,%edx
  803b15:	f7 75 cc             	divl   -0x34(%ebp)
  803b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1b:	29 d0                	sub    %edx,%eax
  803b1d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803b20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b23:	01 d0                	add    %edx,%eax
  803b25:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  803b2a:	a1 40 70 80 00       	mov    0x807040,%eax
  803b2f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803b35:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b42:	01 d0                	add    %edx,%eax
  803b44:	48                   	dec    %eax
  803b45:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803b48:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  803b50:	f7 75 c4             	divl   -0x3c(%ebp)
  803b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b56:	29 d0                	sub    %edx,%eax
  803b58:	83 ec 04             	sub    $0x4,%esp
  803b5b:	6a 01                	push   $0x1
  803b5d:	50                   	push   %eax
  803b5e:	ff 75 d0             	pushl  -0x30(%ebp)
  803b61:	e8 36 fb ff ff       	call   80369c <set_block_data>
  803b66:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803b69:	83 ec 0c             	sub    $0xc,%esp
  803b6c:	ff 75 d0             	pushl  -0x30(%ebp)
  803b6f:	e8 1b 0a 00 00       	call   80458f <free_block>
  803b74:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	ff 75 08             	pushl  0x8(%ebp)
  803b7d:	e8 49 fb ff ff       	call   8036cb <alloc_block_FF>
  803b82:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803b85:	c9                   	leave  
  803b86:	c3                   	ret    

00803b87 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803b87:	55                   	push   %ebp
  803b88:	89 e5                	mov    %esp,%ebp
  803b8a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b90:	83 e0 01             	and    $0x1,%eax
  803b93:	85 c0                	test   %eax,%eax
  803b95:	74 03                	je     803b9a <alloc_block_BF+0x13>
  803b97:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803b9a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803b9e:	77 07                	ja     803ba7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803ba0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803ba7:	a1 24 70 80 00       	mov    0x807024,%eax
  803bac:	85 c0                	test   %eax,%eax
  803bae:	75 73                	jne    803c23 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb3:	83 c0 10             	add    $0x10,%eax
  803bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803bb9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803bc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc6:	01 d0                	add    %edx,%eax
  803bc8:	48                   	dec    %eax
  803bc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  803bd4:	f7 75 e0             	divl   -0x20(%ebp)
  803bd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bda:	29 d0                	sub    %edx,%eax
  803bdc:	c1 e8 0c             	shr    $0xc,%eax
  803bdf:	83 ec 0c             	sub    $0xc,%esp
  803be2:	50                   	push   %eax
  803be3:	e8 62 ec ff ff       	call   80284a <sbrk>
  803be8:	83 c4 10             	add    $0x10,%esp
  803beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803bee:	83 ec 0c             	sub    $0xc,%esp
  803bf1:	6a 00                	push   $0x0
  803bf3:	e8 52 ec ff ff       	call   80284a <sbrk>
  803bf8:	83 c4 10             	add    $0x10,%esp
  803bfb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803bfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c01:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803c04:	83 ec 08             	sub    $0x8,%esp
  803c07:	50                   	push   %eax
  803c08:	ff 75 d8             	pushl  -0x28(%ebp)
  803c0b:	e8 9f f8 ff ff       	call   8034af <initialize_dynamic_allocator>
  803c10:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803c13:	83 ec 0c             	sub    $0xc,%esp
  803c16:	68 e7 69 80 00       	push   $0x8069e7
  803c1b:	e8 90 de ff ff       	call   801ab0 <cprintf>
  803c20:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803c2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803c31:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803c38:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803c3f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c47:	e9 1d 01 00 00       	jmp    803d69 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803c52:	83 ec 0c             	sub    $0xc,%esp
  803c55:	ff 75 a8             	pushl  -0x58(%ebp)
  803c58:	e8 ee f6 ff ff       	call   80334b <get_block_size>
  803c5d:	83 c4 10             	add    $0x10,%esp
  803c60:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803c63:	8b 45 08             	mov    0x8(%ebp),%eax
  803c66:	83 c0 08             	add    $0x8,%eax
  803c69:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c6c:	0f 87 ef 00 00 00    	ja     803d61 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803c72:	8b 45 08             	mov    0x8(%ebp),%eax
  803c75:	83 c0 18             	add    $0x18,%eax
  803c78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c7b:	77 1d                	ja     803c9a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c80:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c83:	0f 86 d8 00 00 00    	jbe    803d61 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803c89:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803c8f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803c92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c95:	e9 c7 00 00 00       	jmp    803d61 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9d:	83 c0 08             	add    $0x8,%eax
  803ca0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ca3:	0f 85 9d 00 00 00    	jne    803d46 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803ca9:	83 ec 04             	sub    $0x4,%esp
  803cac:	6a 01                	push   $0x1
  803cae:	ff 75 a4             	pushl  -0x5c(%ebp)
  803cb1:	ff 75 a8             	pushl  -0x58(%ebp)
  803cb4:	e8 e3 f9 ff ff       	call   80369c <set_block_data>
  803cb9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc0:	75 17                	jne    803cd9 <alloc_block_BF+0x152>
  803cc2:	83 ec 04             	sub    $0x4,%esp
  803cc5:	68 8b 69 80 00       	push   $0x80698b
  803cca:	68 2c 01 00 00       	push   $0x12c
  803ccf:	68 a9 69 80 00       	push   $0x8069a9
  803cd4:	e8 1a db ff ff       	call   8017f3 <_panic>
  803cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdc:	8b 00                	mov    (%eax),%eax
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	74 10                	je     803cf2 <alloc_block_BF+0x16b>
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	8b 00                	mov    (%eax),%eax
  803ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cea:	8b 52 04             	mov    0x4(%edx),%edx
  803ced:	89 50 04             	mov    %edx,0x4(%eax)
  803cf0:	eb 0b                	jmp    803cfd <alloc_block_BF+0x176>
  803cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf5:	8b 40 04             	mov    0x4(%eax),%eax
  803cf8:	a3 30 70 80 00       	mov    %eax,0x807030
  803cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d00:	8b 40 04             	mov    0x4(%eax),%eax
  803d03:	85 c0                	test   %eax,%eax
  803d05:	74 0f                	je     803d16 <alloc_block_BF+0x18f>
  803d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0a:	8b 40 04             	mov    0x4(%eax),%eax
  803d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d10:	8b 12                	mov    (%edx),%edx
  803d12:	89 10                	mov    %edx,(%eax)
  803d14:	eb 0a                	jmp    803d20 <alloc_block_BF+0x199>
  803d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d33:	a1 38 70 80 00       	mov    0x807038,%eax
  803d38:	48                   	dec    %eax
  803d39:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  803d3e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d41:	e9 24 04 00 00       	jmp    80416a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d49:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803d4c:	76 13                	jbe    803d61 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803d4e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803d55:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803d5b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803d61:	a1 34 70 80 00       	mov    0x807034,%eax
  803d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d6d:	74 07                	je     803d76 <alloc_block_BF+0x1ef>
  803d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	eb 05                	jmp    803d7b <alloc_block_BF+0x1f4>
  803d76:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7b:	a3 34 70 80 00       	mov    %eax,0x807034
  803d80:	a1 34 70 80 00       	mov    0x807034,%eax
  803d85:	85 c0                	test   %eax,%eax
  803d87:	0f 85 bf fe ff ff    	jne    803c4c <alloc_block_BF+0xc5>
  803d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d91:	0f 85 b5 fe ff ff    	jne    803c4c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9b:	0f 84 26 02 00 00    	je     803fc7 <alloc_block_BF+0x440>
  803da1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803da5:	0f 85 1c 02 00 00    	jne    803fc7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dae:	2b 45 08             	sub    0x8(%ebp),%eax
  803db1:	83 e8 08             	sub    $0x8,%eax
  803db4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803db7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dba:	8d 50 08             	lea    0x8(%eax),%edx
  803dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc0:	01 d0                	add    %edx,%eax
  803dc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc8:	83 c0 08             	add    $0x8,%eax
  803dcb:	83 ec 04             	sub    $0x4,%esp
  803dce:	6a 01                	push   $0x1
  803dd0:	50                   	push   %eax
  803dd1:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd4:	e8 c3 f8 ff ff       	call   80369c <set_block_data>
  803dd9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddf:	8b 40 04             	mov    0x4(%eax),%eax
  803de2:	85 c0                	test   %eax,%eax
  803de4:	75 68                	jne    803e4e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803de6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803dea:	75 17                	jne    803e03 <alloc_block_BF+0x27c>
  803dec:	83 ec 04             	sub    $0x4,%esp
  803def:	68 c4 69 80 00       	push   $0x8069c4
  803df4:	68 45 01 00 00       	push   $0x145
  803df9:	68 a9 69 80 00       	push   $0x8069a9
  803dfe:	e8 f0 d9 ff ff       	call   8017f3 <_panic>
  803e03:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803e09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e0c:	89 10                	mov    %edx,(%eax)
  803e0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e11:	8b 00                	mov    (%eax),%eax
  803e13:	85 c0                	test   %eax,%eax
  803e15:	74 0d                	je     803e24 <alloc_block_BF+0x29d>
  803e17:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803e1c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e1f:	89 50 04             	mov    %edx,0x4(%eax)
  803e22:	eb 08                	jmp    803e2c <alloc_block_BF+0x2a5>
  803e24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e27:	a3 30 70 80 00       	mov    %eax,0x807030
  803e2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e2f:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e3e:	a1 38 70 80 00       	mov    0x807038,%eax
  803e43:	40                   	inc    %eax
  803e44:	a3 38 70 80 00       	mov    %eax,0x807038
  803e49:	e9 dc 00 00 00       	jmp    803f2a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e51:	8b 00                	mov    (%eax),%eax
  803e53:	85 c0                	test   %eax,%eax
  803e55:	75 65                	jne    803ebc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803e57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e5b:	75 17                	jne    803e74 <alloc_block_BF+0x2ed>
  803e5d:	83 ec 04             	sub    $0x4,%esp
  803e60:	68 f8 69 80 00       	push   $0x8069f8
  803e65:	68 4a 01 00 00       	push   $0x14a
  803e6a:	68 a9 69 80 00       	push   $0x8069a9
  803e6f:	e8 7f d9 ff ff       	call   8017f3 <_panic>
  803e74:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803e7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e7d:	89 50 04             	mov    %edx,0x4(%eax)
  803e80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e83:	8b 40 04             	mov    0x4(%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 0c                	je     803e96 <alloc_block_BF+0x30f>
  803e8a:	a1 30 70 80 00       	mov    0x807030,%eax
  803e8f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e92:	89 10                	mov    %edx,(%eax)
  803e94:	eb 08                	jmp    803e9e <alloc_block_BF+0x317>
  803e96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e99:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ea1:	a3 30 70 80 00       	mov    %eax,0x807030
  803ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eaf:	a1 38 70 80 00       	mov    0x807038,%eax
  803eb4:	40                   	inc    %eax
  803eb5:	a3 38 70 80 00       	mov    %eax,0x807038
  803eba:	eb 6e                	jmp    803f2a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ec0:	74 06                	je     803ec8 <alloc_block_BF+0x341>
  803ec2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803ec6:	75 17                	jne    803edf <alloc_block_BF+0x358>
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	68 1c 6a 80 00       	push   $0x806a1c
  803ed0:	68 4f 01 00 00       	push   $0x14f
  803ed5:	68 a9 69 80 00       	push   $0x8069a9
  803eda:	e8 14 d9 ff ff       	call   8017f3 <_panic>
  803edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee2:	8b 10                	mov    (%eax),%edx
  803ee4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ee7:	89 10                	mov    %edx,(%eax)
  803ee9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803eec:	8b 00                	mov    (%eax),%eax
  803eee:	85 c0                	test   %eax,%eax
  803ef0:	74 0b                	je     803efd <alloc_block_BF+0x376>
  803ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef5:	8b 00                	mov    (%eax),%eax
  803ef7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803efa:	89 50 04             	mov    %edx,0x4(%eax)
  803efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f03:	89 10                	mov    %edx,(%eax)
  803f05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f0b:	89 50 04             	mov    %edx,0x4(%eax)
  803f0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f11:	8b 00                	mov    (%eax),%eax
  803f13:	85 c0                	test   %eax,%eax
  803f15:	75 08                	jne    803f1f <alloc_block_BF+0x398>
  803f17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f1a:	a3 30 70 80 00       	mov    %eax,0x807030
  803f1f:	a1 38 70 80 00       	mov    0x807038,%eax
  803f24:	40                   	inc    %eax
  803f25:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803f2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f2e:	75 17                	jne    803f47 <alloc_block_BF+0x3c0>
  803f30:	83 ec 04             	sub    $0x4,%esp
  803f33:	68 8b 69 80 00       	push   $0x80698b
  803f38:	68 51 01 00 00       	push   $0x151
  803f3d:	68 a9 69 80 00       	push   $0x8069a9
  803f42:	e8 ac d8 ff ff       	call   8017f3 <_panic>
  803f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4a:	8b 00                	mov    (%eax),%eax
  803f4c:	85 c0                	test   %eax,%eax
  803f4e:	74 10                	je     803f60 <alloc_block_BF+0x3d9>
  803f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f53:	8b 00                	mov    (%eax),%eax
  803f55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f58:	8b 52 04             	mov    0x4(%edx),%edx
  803f5b:	89 50 04             	mov    %edx,0x4(%eax)
  803f5e:	eb 0b                	jmp    803f6b <alloc_block_BF+0x3e4>
  803f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f63:	8b 40 04             	mov    0x4(%eax),%eax
  803f66:	a3 30 70 80 00       	mov    %eax,0x807030
  803f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6e:	8b 40 04             	mov    0x4(%eax),%eax
  803f71:	85 c0                	test   %eax,%eax
  803f73:	74 0f                	je     803f84 <alloc_block_BF+0x3fd>
  803f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f78:	8b 40 04             	mov    0x4(%eax),%eax
  803f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f7e:	8b 12                	mov    (%edx),%edx
  803f80:	89 10                	mov    %edx,(%eax)
  803f82:	eb 0a                	jmp    803f8e <alloc_block_BF+0x407>
  803f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f87:	8b 00                	mov    (%eax),%eax
  803f89:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa1:	a1 38 70 80 00       	mov    0x807038,%eax
  803fa6:	48                   	dec    %eax
  803fa7:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  803fac:	83 ec 04             	sub    $0x4,%esp
  803faf:	6a 00                	push   $0x0
  803fb1:	ff 75 d0             	pushl  -0x30(%ebp)
  803fb4:	ff 75 cc             	pushl  -0x34(%ebp)
  803fb7:	e8 e0 f6 ff ff       	call   80369c <set_block_data>
  803fbc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc2:	e9 a3 01 00 00       	jmp    80416a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803fc7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803fcb:	0f 85 9d 00 00 00    	jne    80406e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803fd1:	83 ec 04             	sub    $0x4,%esp
  803fd4:	6a 01                	push   $0x1
  803fd6:	ff 75 ec             	pushl  -0x14(%ebp)
  803fd9:	ff 75 f0             	pushl  -0x10(%ebp)
  803fdc:	e8 bb f6 ff ff       	call   80369c <set_block_data>
  803fe1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803fe4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fe8:	75 17                	jne    804001 <alloc_block_BF+0x47a>
  803fea:	83 ec 04             	sub    $0x4,%esp
  803fed:	68 8b 69 80 00       	push   $0x80698b
  803ff2:	68 58 01 00 00       	push   $0x158
  803ff7:	68 a9 69 80 00       	push   $0x8069a9
  803ffc:	e8 f2 d7 ff ff       	call   8017f3 <_panic>
  804001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804004:	8b 00                	mov    (%eax),%eax
  804006:	85 c0                	test   %eax,%eax
  804008:	74 10                	je     80401a <alloc_block_BF+0x493>
  80400a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400d:	8b 00                	mov    (%eax),%eax
  80400f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804012:	8b 52 04             	mov    0x4(%edx),%edx
  804015:	89 50 04             	mov    %edx,0x4(%eax)
  804018:	eb 0b                	jmp    804025 <alloc_block_BF+0x49e>
  80401a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401d:	8b 40 04             	mov    0x4(%eax),%eax
  804020:	a3 30 70 80 00       	mov    %eax,0x807030
  804025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804028:	8b 40 04             	mov    0x4(%eax),%eax
  80402b:	85 c0                	test   %eax,%eax
  80402d:	74 0f                	je     80403e <alloc_block_BF+0x4b7>
  80402f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804032:	8b 40 04             	mov    0x4(%eax),%eax
  804035:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804038:	8b 12                	mov    (%edx),%edx
  80403a:	89 10                	mov    %edx,(%eax)
  80403c:	eb 0a                	jmp    804048 <alloc_block_BF+0x4c1>
  80403e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804041:	8b 00                	mov    (%eax),%eax
  804043:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80405b:	a1 38 70 80 00       	mov    0x807038,%eax
  804060:	48                   	dec    %eax
  804061:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  804066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804069:	e9 fc 00 00 00       	jmp    80416a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80406e:	8b 45 08             	mov    0x8(%ebp),%eax
  804071:	83 c0 08             	add    $0x8,%eax
  804074:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  804077:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80407e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804081:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804084:	01 d0                	add    %edx,%eax
  804086:	48                   	dec    %eax
  804087:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80408a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80408d:	ba 00 00 00 00       	mov    $0x0,%edx
  804092:	f7 75 c4             	divl   -0x3c(%ebp)
  804095:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804098:	29 d0                	sub    %edx,%eax
  80409a:	c1 e8 0c             	shr    $0xc,%eax
  80409d:	83 ec 0c             	sub    $0xc,%esp
  8040a0:	50                   	push   %eax
  8040a1:	e8 a4 e7 ff ff       	call   80284a <sbrk>
  8040a6:	83 c4 10             	add    $0x10,%esp
  8040a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8040ac:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8040b0:	75 0a                	jne    8040bc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8040b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b7:	e9 ae 00 00 00       	jmp    80416a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8040bc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8040c3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040c9:	01 d0                	add    %edx,%eax
  8040cb:	48                   	dec    %eax
  8040cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8040cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8040d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8040d7:	f7 75 b8             	divl   -0x48(%ebp)
  8040da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8040dd:	29 d0                	sub    %edx,%eax
  8040df:	8d 50 fc             	lea    -0x4(%eax),%edx
  8040e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8040e5:	01 d0                	add    %edx,%eax
  8040e7:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  8040ec:	a1 40 70 80 00       	mov    0x807040,%eax
  8040f1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8040f7:	83 ec 0c             	sub    $0xc,%esp
  8040fa:	68 50 6a 80 00       	push   $0x806a50
  8040ff:	e8 ac d9 ff ff       	call   801ab0 <cprintf>
  804104:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  804107:	83 ec 08             	sub    $0x8,%esp
  80410a:	ff 75 bc             	pushl  -0x44(%ebp)
  80410d:	68 55 6a 80 00       	push   $0x806a55
  804112:	e8 99 d9 ff ff       	call   801ab0 <cprintf>
  804117:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80411a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  804121:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804124:	8b 45 b0             	mov    -0x50(%ebp),%eax
  804127:	01 d0                	add    %edx,%eax
  804129:	48                   	dec    %eax
  80412a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80412d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804130:	ba 00 00 00 00       	mov    $0x0,%edx
  804135:	f7 75 b0             	divl   -0x50(%ebp)
  804138:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80413b:	29 d0                	sub    %edx,%eax
  80413d:	83 ec 04             	sub    $0x4,%esp
  804140:	6a 01                	push   $0x1
  804142:	50                   	push   %eax
  804143:	ff 75 bc             	pushl  -0x44(%ebp)
  804146:	e8 51 f5 ff ff       	call   80369c <set_block_data>
  80414b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80414e:	83 ec 0c             	sub    $0xc,%esp
  804151:	ff 75 bc             	pushl  -0x44(%ebp)
  804154:	e8 36 04 00 00       	call   80458f <free_block>
  804159:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80415c:	83 ec 0c             	sub    $0xc,%esp
  80415f:	ff 75 08             	pushl  0x8(%ebp)
  804162:	e8 20 fa ff ff       	call   803b87 <alloc_block_BF>
  804167:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80416a:	c9                   	leave  
  80416b:	c3                   	ret    

0080416c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80416c:	55                   	push   %ebp
  80416d:	89 e5                	mov    %esp,%ebp
  80416f:	53                   	push   %ebx
  804170:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  804173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80417a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  804181:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804185:	74 1e                	je     8041a5 <merging+0x39>
  804187:	ff 75 08             	pushl  0x8(%ebp)
  80418a:	e8 bc f1 ff ff       	call   80334b <get_block_size>
  80418f:	83 c4 04             	add    $0x4,%esp
  804192:	89 c2                	mov    %eax,%edx
  804194:	8b 45 08             	mov    0x8(%ebp),%eax
  804197:	01 d0                	add    %edx,%eax
  804199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80419c:	75 07                	jne    8041a5 <merging+0x39>
		prev_is_free = 1;
  80419e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8041a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041a9:	74 1e                	je     8041c9 <merging+0x5d>
  8041ab:	ff 75 10             	pushl  0x10(%ebp)
  8041ae:	e8 98 f1 ff ff       	call   80334b <get_block_size>
  8041b3:	83 c4 04             	add    $0x4,%esp
  8041b6:	89 c2                	mov    %eax,%edx
  8041b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8041bb:	01 d0                	add    %edx,%eax
  8041bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8041c0:	75 07                	jne    8041c9 <merging+0x5d>
		next_is_free = 1;
  8041c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8041c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041cd:	0f 84 cc 00 00 00    	je     80429f <merging+0x133>
  8041d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041d7:	0f 84 c2 00 00 00    	je     80429f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8041dd:	ff 75 08             	pushl  0x8(%ebp)
  8041e0:	e8 66 f1 ff ff       	call   80334b <get_block_size>
  8041e5:	83 c4 04             	add    $0x4,%esp
  8041e8:	89 c3                	mov    %eax,%ebx
  8041ea:	ff 75 10             	pushl  0x10(%ebp)
  8041ed:	e8 59 f1 ff ff       	call   80334b <get_block_size>
  8041f2:	83 c4 04             	add    $0x4,%esp
  8041f5:	01 c3                	add    %eax,%ebx
  8041f7:	ff 75 0c             	pushl  0xc(%ebp)
  8041fa:	e8 4c f1 ff ff       	call   80334b <get_block_size>
  8041ff:	83 c4 04             	add    $0x4,%esp
  804202:	01 d8                	add    %ebx,%eax
  804204:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804207:	6a 00                	push   $0x0
  804209:	ff 75 ec             	pushl  -0x14(%ebp)
  80420c:	ff 75 08             	pushl  0x8(%ebp)
  80420f:	e8 88 f4 ff ff       	call   80369c <set_block_data>
  804214:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  804217:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80421b:	75 17                	jne    804234 <merging+0xc8>
  80421d:	83 ec 04             	sub    $0x4,%esp
  804220:	68 8b 69 80 00       	push   $0x80698b
  804225:	68 7d 01 00 00       	push   $0x17d
  80422a:	68 a9 69 80 00       	push   $0x8069a9
  80422f:	e8 bf d5 ff ff       	call   8017f3 <_panic>
  804234:	8b 45 0c             	mov    0xc(%ebp),%eax
  804237:	8b 00                	mov    (%eax),%eax
  804239:	85 c0                	test   %eax,%eax
  80423b:	74 10                	je     80424d <merging+0xe1>
  80423d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804240:	8b 00                	mov    (%eax),%eax
  804242:	8b 55 0c             	mov    0xc(%ebp),%edx
  804245:	8b 52 04             	mov    0x4(%edx),%edx
  804248:	89 50 04             	mov    %edx,0x4(%eax)
  80424b:	eb 0b                	jmp    804258 <merging+0xec>
  80424d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804250:	8b 40 04             	mov    0x4(%eax),%eax
  804253:	a3 30 70 80 00       	mov    %eax,0x807030
  804258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80425b:	8b 40 04             	mov    0x4(%eax),%eax
  80425e:	85 c0                	test   %eax,%eax
  804260:	74 0f                	je     804271 <merging+0x105>
  804262:	8b 45 0c             	mov    0xc(%ebp),%eax
  804265:	8b 40 04             	mov    0x4(%eax),%eax
  804268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80426b:	8b 12                	mov    (%edx),%edx
  80426d:	89 10                	mov    %edx,(%eax)
  80426f:	eb 0a                	jmp    80427b <merging+0x10f>
  804271:	8b 45 0c             	mov    0xc(%ebp),%eax
  804274:	8b 00                	mov    (%eax),%eax
  804276:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80427b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80427e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804284:	8b 45 0c             	mov    0xc(%ebp),%eax
  804287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80428e:	a1 38 70 80 00       	mov    0x807038,%eax
  804293:	48                   	dec    %eax
  804294:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804299:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80429a:	e9 ea 02 00 00       	jmp    804589 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80429f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042a3:	74 3b                	je     8042e0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8042a5:	83 ec 0c             	sub    $0xc,%esp
  8042a8:	ff 75 08             	pushl  0x8(%ebp)
  8042ab:	e8 9b f0 ff ff       	call   80334b <get_block_size>
  8042b0:	83 c4 10             	add    $0x10,%esp
  8042b3:	89 c3                	mov    %eax,%ebx
  8042b5:	83 ec 0c             	sub    $0xc,%esp
  8042b8:	ff 75 10             	pushl  0x10(%ebp)
  8042bb:	e8 8b f0 ff ff       	call   80334b <get_block_size>
  8042c0:	83 c4 10             	add    $0x10,%esp
  8042c3:	01 d8                	add    %ebx,%eax
  8042c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8042c8:	83 ec 04             	sub    $0x4,%esp
  8042cb:	6a 00                	push   $0x0
  8042cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8042d0:	ff 75 08             	pushl  0x8(%ebp)
  8042d3:	e8 c4 f3 ff ff       	call   80369c <set_block_data>
  8042d8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8042db:	e9 a9 02 00 00       	jmp    804589 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8042e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042e4:	0f 84 2d 01 00 00    	je     804417 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8042ea:	83 ec 0c             	sub    $0xc,%esp
  8042ed:	ff 75 10             	pushl  0x10(%ebp)
  8042f0:	e8 56 f0 ff ff       	call   80334b <get_block_size>
  8042f5:	83 c4 10             	add    $0x10,%esp
  8042f8:	89 c3                	mov    %eax,%ebx
  8042fa:	83 ec 0c             	sub    $0xc,%esp
  8042fd:	ff 75 0c             	pushl  0xc(%ebp)
  804300:	e8 46 f0 ff ff       	call   80334b <get_block_size>
  804305:	83 c4 10             	add    $0x10,%esp
  804308:	01 d8                	add    %ebx,%eax
  80430a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80430d:	83 ec 04             	sub    $0x4,%esp
  804310:	6a 00                	push   $0x0
  804312:	ff 75 e4             	pushl  -0x1c(%ebp)
  804315:	ff 75 10             	pushl  0x10(%ebp)
  804318:	e8 7f f3 ff ff       	call   80369c <set_block_data>
  80431d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  804320:	8b 45 10             	mov    0x10(%ebp),%eax
  804323:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  804326:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80432a:	74 06                	je     804332 <merging+0x1c6>
  80432c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804330:	75 17                	jne    804349 <merging+0x1dd>
  804332:	83 ec 04             	sub    $0x4,%esp
  804335:	68 64 6a 80 00       	push   $0x806a64
  80433a:	68 8d 01 00 00       	push   $0x18d
  80433f:	68 a9 69 80 00       	push   $0x8069a9
  804344:	e8 aa d4 ff ff       	call   8017f3 <_panic>
  804349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80434c:	8b 50 04             	mov    0x4(%eax),%edx
  80434f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804352:	89 50 04             	mov    %edx,0x4(%eax)
  804355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80435b:	89 10                	mov    %edx,(%eax)
  80435d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804360:	8b 40 04             	mov    0x4(%eax),%eax
  804363:	85 c0                	test   %eax,%eax
  804365:	74 0d                	je     804374 <merging+0x208>
  804367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80436a:	8b 40 04             	mov    0x4(%eax),%eax
  80436d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804370:	89 10                	mov    %edx,(%eax)
  804372:	eb 08                	jmp    80437c <merging+0x210>
  804374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804377:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80437c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80437f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804382:	89 50 04             	mov    %edx,0x4(%eax)
  804385:	a1 38 70 80 00       	mov    0x807038,%eax
  80438a:	40                   	inc    %eax
  80438b:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  804390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804394:	75 17                	jne    8043ad <merging+0x241>
  804396:	83 ec 04             	sub    $0x4,%esp
  804399:	68 8b 69 80 00       	push   $0x80698b
  80439e:	68 8e 01 00 00       	push   $0x18e
  8043a3:	68 a9 69 80 00       	push   $0x8069a9
  8043a8:	e8 46 d4 ff ff       	call   8017f3 <_panic>
  8043ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043b0:	8b 00                	mov    (%eax),%eax
  8043b2:	85 c0                	test   %eax,%eax
  8043b4:	74 10                	je     8043c6 <merging+0x25a>
  8043b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043b9:	8b 00                	mov    (%eax),%eax
  8043bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043be:	8b 52 04             	mov    0x4(%edx),%edx
  8043c1:	89 50 04             	mov    %edx,0x4(%eax)
  8043c4:	eb 0b                	jmp    8043d1 <merging+0x265>
  8043c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043c9:	8b 40 04             	mov    0x4(%eax),%eax
  8043cc:	a3 30 70 80 00       	mov    %eax,0x807030
  8043d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043d4:	8b 40 04             	mov    0x4(%eax),%eax
  8043d7:	85 c0                	test   %eax,%eax
  8043d9:	74 0f                	je     8043ea <merging+0x27e>
  8043db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043de:	8b 40 04             	mov    0x4(%eax),%eax
  8043e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043e4:	8b 12                	mov    (%edx),%edx
  8043e6:	89 10                	mov    %edx,(%eax)
  8043e8:	eb 0a                	jmp    8043f4 <merging+0x288>
  8043ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043ed:	8b 00                	mov    (%eax),%eax
  8043ef:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8043f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  804400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804407:	a1 38 70 80 00       	mov    0x807038,%eax
  80440c:	48                   	dec    %eax
  80440d:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804412:	e9 72 01 00 00       	jmp    804589 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  804417:	8b 45 10             	mov    0x10(%ebp),%eax
  80441a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80441d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804421:	74 79                	je     80449c <merging+0x330>
  804423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804427:	74 73                	je     80449c <merging+0x330>
  804429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80442d:	74 06                	je     804435 <merging+0x2c9>
  80442f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804433:	75 17                	jne    80444c <merging+0x2e0>
  804435:	83 ec 04             	sub    $0x4,%esp
  804438:	68 1c 6a 80 00       	push   $0x806a1c
  80443d:	68 94 01 00 00       	push   $0x194
  804442:	68 a9 69 80 00       	push   $0x8069a9
  804447:	e8 a7 d3 ff ff       	call   8017f3 <_panic>
  80444c:	8b 45 08             	mov    0x8(%ebp),%eax
  80444f:	8b 10                	mov    (%eax),%edx
  804451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804454:	89 10                	mov    %edx,(%eax)
  804456:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804459:	8b 00                	mov    (%eax),%eax
  80445b:	85 c0                	test   %eax,%eax
  80445d:	74 0b                	je     80446a <merging+0x2fe>
  80445f:	8b 45 08             	mov    0x8(%ebp),%eax
  804462:	8b 00                	mov    (%eax),%eax
  804464:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804467:	89 50 04             	mov    %edx,0x4(%eax)
  80446a:	8b 45 08             	mov    0x8(%ebp),%eax
  80446d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804470:	89 10                	mov    %edx,(%eax)
  804472:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804475:	8b 55 08             	mov    0x8(%ebp),%edx
  804478:	89 50 04             	mov    %edx,0x4(%eax)
  80447b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80447e:	8b 00                	mov    (%eax),%eax
  804480:	85 c0                	test   %eax,%eax
  804482:	75 08                	jne    80448c <merging+0x320>
  804484:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804487:	a3 30 70 80 00       	mov    %eax,0x807030
  80448c:	a1 38 70 80 00       	mov    0x807038,%eax
  804491:	40                   	inc    %eax
  804492:	a3 38 70 80 00       	mov    %eax,0x807038
  804497:	e9 ce 00 00 00       	jmp    80456a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80449c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044a0:	74 65                	je     804507 <merging+0x39b>
  8044a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8044a6:	75 17                	jne    8044bf <merging+0x353>
  8044a8:	83 ec 04             	sub    $0x4,%esp
  8044ab:	68 f8 69 80 00       	push   $0x8069f8
  8044b0:	68 95 01 00 00       	push   $0x195
  8044b5:	68 a9 69 80 00       	push   $0x8069a9
  8044ba:	e8 34 d3 ff ff       	call   8017f3 <_panic>
  8044bf:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8044c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c8:	89 50 04             	mov    %edx,0x4(%eax)
  8044cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044ce:	8b 40 04             	mov    0x4(%eax),%eax
  8044d1:	85 c0                	test   %eax,%eax
  8044d3:	74 0c                	je     8044e1 <merging+0x375>
  8044d5:	a1 30 70 80 00       	mov    0x807030,%eax
  8044da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044dd:	89 10                	mov    %edx,(%eax)
  8044df:	eb 08                	jmp    8044e9 <merging+0x37d>
  8044e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044e4:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8044e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044ec:	a3 30 70 80 00       	mov    %eax,0x807030
  8044f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044fa:	a1 38 70 80 00       	mov    0x807038,%eax
  8044ff:	40                   	inc    %eax
  804500:	a3 38 70 80 00       	mov    %eax,0x807038
  804505:	eb 63                	jmp    80456a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  804507:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80450b:	75 17                	jne    804524 <merging+0x3b8>
  80450d:	83 ec 04             	sub    $0x4,%esp
  804510:	68 c4 69 80 00       	push   $0x8069c4
  804515:	68 98 01 00 00       	push   $0x198
  80451a:	68 a9 69 80 00       	push   $0x8069a9
  80451f:	e8 cf d2 ff ff       	call   8017f3 <_panic>
  804524:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80452a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80452d:	89 10                	mov    %edx,(%eax)
  80452f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804532:	8b 00                	mov    (%eax),%eax
  804534:	85 c0                	test   %eax,%eax
  804536:	74 0d                	je     804545 <merging+0x3d9>
  804538:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80453d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804540:	89 50 04             	mov    %edx,0x4(%eax)
  804543:	eb 08                	jmp    80454d <merging+0x3e1>
  804545:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804548:	a3 30 70 80 00       	mov    %eax,0x807030
  80454d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804550:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804558:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80455f:	a1 38 70 80 00       	mov    0x807038,%eax
  804564:	40                   	inc    %eax
  804565:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  80456a:	83 ec 0c             	sub    $0xc,%esp
  80456d:	ff 75 10             	pushl  0x10(%ebp)
  804570:	e8 d6 ed ff ff       	call   80334b <get_block_size>
  804575:	83 c4 10             	add    $0x10,%esp
  804578:	83 ec 04             	sub    $0x4,%esp
  80457b:	6a 00                	push   $0x0
  80457d:	50                   	push   %eax
  80457e:	ff 75 10             	pushl  0x10(%ebp)
  804581:	e8 16 f1 ff ff       	call   80369c <set_block_data>
  804586:	83 c4 10             	add    $0x10,%esp
	}
}
  804589:	90                   	nop
  80458a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80458d:	c9                   	leave  
  80458e:	c3                   	ret    

0080458f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80458f:	55                   	push   %ebp
  804590:	89 e5                	mov    %esp,%ebp
  804592:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804595:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80459a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80459d:	a1 30 70 80 00       	mov    0x807030,%eax
  8045a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045a5:	73 1b                	jae    8045c2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8045a7:	a1 30 70 80 00       	mov    0x807030,%eax
  8045ac:	83 ec 04             	sub    $0x4,%esp
  8045af:	ff 75 08             	pushl  0x8(%ebp)
  8045b2:	6a 00                	push   $0x0
  8045b4:	50                   	push   %eax
  8045b5:	e8 b2 fb ff ff       	call   80416c <merging>
  8045ba:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8045bd:	e9 8b 00 00 00       	jmp    80464d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8045c2:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045ca:	76 18                	jbe    8045e4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8045cc:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045d1:	83 ec 04             	sub    $0x4,%esp
  8045d4:	ff 75 08             	pushl  0x8(%ebp)
  8045d7:	50                   	push   %eax
  8045d8:	6a 00                	push   $0x0
  8045da:	e8 8d fb ff ff       	call   80416c <merging>
  8045df:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8045e2:	eb 69                	jmp    80464d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8045e4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045ec:	eb 39                	jmp    804627 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045f4:	73 29                	jae    80461f <free_block+0x90>
  8045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f9:	8b 00                	mov    (%eax),%eax
  8045fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045fe:	76 1f                	jbe    80461f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  804600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804603:	8b 00                	mov    (%eax),%eax
  804605:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804608:	83 ec 04             	sub    $0x4,%esp
  80460b:	ff 75 08             	pushl  0x8(%ebp)
  80460e:	ff 75 f0             	pushl  -0x10(%ebp)
  804611:	ff 75 f4             	pushl  -0xc(%ebp)
  804614:	e8 53 fb ff ff       	call   80416c <merging>
  804619:	83 c4 10             	add    $0x10,%esp
			break;
  80461c:	90                   	nop
		}
	}
}
  80461d:	eb 2e                	jmp    80464d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80461f:	a1 34 70 80 00       	mov    0x807034,%eax
  804624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80462b:	74 07                	je     804634 <free_block+0xa5>
  80462d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804630:	8b 00                	mov    (%eax),%eax
  804632:	eb 05                	jmp    804639 <free_block+0xaa>
  804634:	b8 00 00 00 00       	mov    $0x0,%eax
  804639:	a3 34 70 80 00       	mov    %eax,0x807034
  80463e:	a1 34 70 80 00       	mov    0x807034,%eax
  804643:	85 c0                	test   %eax,%eax
  804645:	75 a7                	jne    8045ee <free_block+0x5f>
  804647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80464b:	75 a1                	jne    8045ee <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80464d:	90                   	nop
  80464e:	c9                   	leave  
  80464f:	c3                   	ret    

00804650 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804650:	55                   	push   %ebp
  804651:	89 e5                	mov    %esp,%ebp
  804653:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804656:	ff 75 08             	pushl  0x8(%ebp)
  804659:	e8 ed ec ff ff       	call   80334b <get_block_size>
  80465e:	83 c4 04             	add    $0x4,%esp
  804661:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80466b:	eb 17                	jmp    804684 <copy_data+0x34>
  80466d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804670:	8b 45 0c             	mov    0xc(%ebp),%eax
  804673:	01 c2                	add    %eax,%edx
  804675:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804678:	8b 45 08             	mov    0x8(%ebp),%eax
  80467b:	01 c8                	add    %ecx,%eax
  80467d:	8a 00                	mov    (%eax),%al
  80467f:	88 02                	mov    %al,(%edx)
  804681:	ff 45 fc             	incl   -0x4(%ebp)
  804684:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80468a:	72 e1                	jb     80466d <copy_data+0x1d>
}
  80468c:	90                   	nop
  80468d:	c9                   	leave  
  80468e:	c3                   	ret    

0080468f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80468f:	55                   	push   %ebp
  804690:	89 e5                	mov    %esp,%ebp
  804692:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804699:	75 23                	jne    8046be <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80469b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80469f:	74 13                	je     8046b4 <realloc_block_FF+0x25>
  8046a1:	83 ec 0c             	sub    $0xc,%esp
  8046a4:	ff 75 0c             	pushl  0xc(%ebp)
  8046a7:	e8 1f f0 ff ff       	call   8036cb <alloc_block_FF>
  8046ac:	83 c4 10             	add    $0x10,%esp
  8046af:	e9 f4 06 00 00       	jmp    804da8 <realloc_block_FF+0x719>
		return NULL;
  8046b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046b9:	e9 ea 06 00 00       	jmp    804da8 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8046be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8046c2:	75 18                	jne    8046dc <realloc_block_FF+0x4d>
	{
		free_block(va);
  8046c4:	83 ec 0c             	sub    $0xc,%esp
  8046c7:	ff 75 08             	pushl  0x8(%ebp)
  8046ca:	e8 c0 fe ff ff       	call   80458f <free_block>
  8046cf:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8046d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d7:	e9 cc 06 00 00       	jmp    804da8 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8046dc:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8046e0:	77 07                	ja     8046e9 <realloc_block_FF+0x5a>
  8046e2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8046e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046ec:	83 e0 01             	and    $0x1,%eax
  8046ef:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046f5:	83 c0 08             	add    $0x8,%eax
  8046f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8046fb:	83 ec 0c             	sub    $0xc,%esp
  8046fe:	ff 75 08             	pushl  0x8(%ebp)
  804701:	e8 45 ec ff ff       	call   80334b <get_block_size>
  804706:	83 c4 10             	add    $0x10,%esp
  804709:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80470c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80470f:	83 e8 08             	sub    $0x8,%eax
  804712:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804715:	8b 45 08             	mov    0x8(%ebp),%eax
  804718:	83 e8 04             	sub    $0x4,%eax
  80471b:	8b 00                	mov    (%eax),%eax
  80471d:	83 e0 fe             	and    $0xfffffffe,%eax
  804720:	89 c2                	mov    %eax,%edx
  804722:	8b 45 08             	mov    0x8(%ebp),%eax
  804725:	01 d0                	add    %edx,%eax
  804727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80472a:	83 ec 0c             	sub    $0xc,%esp
  80472d:	ff 75 e4             	pushl  -0x1c(%ebp)
  804730:	e8 16 ec ff ff       	call   80334b <get_block_size>
  804735:	83 c4 10             	add    $0x10,%esp
  804738:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80473b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80473e:	83 e8 08             	sub    $0x8,%eax
  804741:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804744:	8b 45 0c             	mov    0xc(%ebp),%eax
  804747:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80474a:	75 08                	jne    804754 <realloc_block_FF+0xc5>
	{
		 return va;
  80474c:	8b 45 08             	mov    0x8(%ebp),%eax
  80474f:	e9 54 06 00 00       	jmp    804da8 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804754:	8b 45 0c             	mov    0xc(%ebp),%eax
  804757:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80475a:	0f 83 e5 03 00 00    	jae    804b45 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804763:	2b 45 0c             	sub    0xc(%ebp),%eax
  804766:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804769:	83 ec 0c             	sub    $0xc,%esp
  80476c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80476f:	e8 f0 eb ff ff       	call   803364 <is_free_block>
  804774:	83 c4 10             	add    $0x10,%esp
  804777:	84 c0                	test   %al,%al
  804779:	0f 84 3b 01 00 00    	je     8048ba <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80477f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804782:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804785:	01 d0                	add    %edx,%eax
  804787:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80478a:	83 ec 04             	sub    $0x4,%esp
  80478d:	6a 01                	push   $0x1
  80478f:	ff 75 f0             	pushl  -0x10(%ebp)
  804792:	ff 75 08             	pushl  0x8(%ebp)
  804795:	e8 02 ef ff ff       	call   80369c <set_block_data>
  80479a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80479d:	8b 45 08             	mov    0x8(%ebp),%eax
  8047a0:	83 e8 04             	sub    $0x4,%eax
  8047a3:	8b 00                	mov    (%eax),%eax
  8047a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8047a8:	89 c2                	mov    %eax,%edx
  8047aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ad:	01 d0                	add    %edx,%eax
  8047af:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8047b2:	83 ec 04             	sub    $0x4,%esp
  8047b5:	6a 00                	push   $0x0
  8047b7:	ff 75 cc             	pushl  -0x34(%ebp)
  8047ba:	ff 75 c8             	pushl  -0x38(%ebp)
  8047bd:	e8 da ee ff ff       	call   80369c <set_block_data>
  8047c2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8047c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8047c9:	74 06                	je     8047d1 <realloc_block_FF+0x142>
  8047cb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8047cf:	75 17                	jne    8047e8 <realloc_block_FF+0x159>
  8047d1:	83 ec 04             	sub    $0x4,%esp
  8047d4:	68 1c 6a 80 00       	push   $0x806a1c
  8047d9:	68 f6 01 00 00       	push   $0x1f6
  8047de:	68 a9 69 80 00       	push   $0x8069a9
  8047e3:	e8 0b d0 ff ff       	call   8017f3 <_panic>
  8047e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047eb:	8b 10                	mov    (%eax),%edx
  8047ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047f0:	89 10                	mov    %edx,(%eax)
  8047f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047f5:	8b 00                	mov    (%eax),%eax
  8047f7:	85 c0                	test   %eax,%eax
  8047f9:	74 0b                	je     804806 <realloc_block_FF+0x177>
  8047fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047fe:	8b 00                	mov    (%eax),%eax
  804800:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804803:	89 50 04             	mov    %edx,0x4(%eax)
  804806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804809:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80480c:	89 10                	mov    %edx,(%eax)
  80480e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804811:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804814:	89 50 04             	mov    %edx,0x4(%eax)
  804817:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80481a:	8b 00                	mov    (%eax),%eax
  80481c:	85 c0                	test   %eax,%eax
  80481e:	75 08                	jne    804828 <realloc_block_FF+0x199>
  804820:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804823:	a3 30 70 80 00       	mov    %eax,0x807030
  804828:	a1 38 70 80 00       	mov    0x807038,%eax
  80482d:	40                   	inc    %eax
  80482e:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804837:	75 17                	jne    804850 <realloc_block_FF+0x1c1>
  804839:	83 ec 04             	sub    $0x4,%esp
  80483c:	68 8b 69 80 00       	push   $0x80698b
  804841:	68 f7 01 00 00       	push   $0x1f7
  804846:	68 a9 69 80 00       	push   $0x8069a9
  80484b:	e8 a3 cf ff ff       	call   8017f3 <_panic>
  804850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804853:	8b 00                	mov    (%eax),%eax
  804855:	85 c0                	test   %eax,%eax
  804857:	74 10                	je     804869 <realloc_block_FF+0x1da>
  804859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80485c:	8b 00                	mov    (%eax),%eax
  80485e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804861:	8b 52 04             	mov    0x4(%edx),%edx
  804864:	89 50 04             	mov    %edx,0x4(%eax)
  804867:	eb 0b                	jmp    804874 <realloc_block_FF+0x1e5>
  804869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80486c:	8b 40 04             	mov    0x4(%eax),%eax
  80486f:	a3 30 70 80 00       	mov    %eax,0x807030
  804874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804877:	8b 40 04             	mov    0x4(%eax),%eax
  80487a:	85 c0                	test   %eax,%eax
  80487c:	74 0f                	je     80488d <realloc_block_FF+0x1fe>
  80487e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804881:	8b 40 04             	mov    0x4(%eax),%eax
  804884:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804887:	8b 12                	mov    (%edx),%edx
  804889:	89 10                	mov    %edx,(%eax)
  80488b:	eb 0a                	jmp    804897 <realloc_block_FF+0x208>
  80488d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804890:	8b 00                	mov    (%eax),%eax
  804892:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80489a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048aa:	a1 38 70 80 00       	mov    0x807038,%eax
  8048af:	48                   	dec    %eax
  8048b0:	a3 38 70 80 00       	mov    %eax,0x807038
  8048b5:	e9 83 02 00 00       	jmp    804b3d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8048ba:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8048be:	0f 86 69 02 00 00    	jbe    804b2d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8048c4:	83 ec 04             	sub    $0x4,%esp
  8048c7:	6a 01                	push   $0x1
  8048c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8048cc:	ff 75 08             	pushl  0x8(%ebp)
  8048cf:	e8 c8 ed ff ff       	call   80369c <set_block_data>
  8048d4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8048d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8048da:	83 e8 04             	sub    $0x4,%eax
  8048dd:	8b 00                	mov    (%eax),%eax
  8048df:	83 e0 fe             	and    $0xfffffffe,%eax
  8048e2:	89 c2                	mov    %eax,%edx
  8048e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e7:	01 d0                	add    %edx,%eax
  8048e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8048ec:	a1 38 70 80 00       	mov    0x807038,%eax
  8048f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8048f4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8048f8:	75 68                	jne    804962 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8048fa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8048fe:	75 17                	jne    804917 <realloc_block_FF+0x288>
  804900:	83 ec 04             	sub    $0x4,%esp
  804903:	68 c4 69 80 00       	push   $0x8069c4
  804908:	68 06 02 00 00       	push   $0x206
  80490d:	68 a9 69 80 00       	push   $0x8069a9
  804912:	e8 dc ce ff ff       	call   8017f3 <_panic>
  804917:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80491d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804920:	89 10                	mov    %edx,(%eax)
  804922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804925:	8b 00                	mov    (%eax),%eax
  804927:	85 c0                	test   %eax,%eax
  804929:	74 0d                	je     804938 <realloc_block_FF+0x2a9>
  80492b:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804930:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804933:	89 50 04             	mov    %edx,0x4(%eax)
  804936:	eb 08                	jmp    804940 <realloc_block_FF+0x2b1>
  804938:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80493b:	a3 30 70 80 00       	mov    %eax,0x807030
  804940:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804943:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80494b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804952:	a1 38 70 80 00       	mov    0x807038,%eax
  804957:	40                   	inc    %eax
  804958:	a3 38 70 80 00       	mov    %eax,0x807038
  80495d:	e9 b0 01 00 00       	jmp    804b12 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804962:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804967:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80496a:	76 68                	jbe    8049d4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80496c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804970:	75 17                	jne    804989 <realloc_block_FF+0x2fa>
  804972:	83 ec 04             	sub    $0x4,%esp
  804975:	68 c4 69 80 00       	push   $0x8069c4
  80497a:	68 0b 02 00 00       	push   $0x20b
  80497f:	68 a9 69 80 00       	push   $0x8069a9
  804984:	e8 6a ce ff ff       	call   8017f3 <_panic>
  804989:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80498f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804992:	89 10                	mov    %edx,(%eax)
  804994:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804997:	8b 00                	mov    (%eax),%eax
  804999:	85 c0                	test   %eax,%eax
  80499b:	74 0d                	je     8049aa <realloc_block_FF+0x31b>
  80499d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049a5:	89 50 04             	mov    %edx,0x4(%eax)
  8049a8:	eb 08                	jmp    8049b2 <realloc_block_FF+0x323>
  8049aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049ad:	a3 30 70 80 00       	mov    %eax,0x807030
  8049b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049b5:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8049ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049c4:	a1 38 70 80 00       	mov    0x807038,%eax
  8049c9:	40                   	inc    %eax
  8049ca:	a3 38 70 80 00       	mov    %eax,0x807038
  8049cf:	e9 3e 01 00 00       	jmp    804b12 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8049d4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049d9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8049dc:	73 68                	jae    804a46 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8049de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8049e2:	75 17                	jne    8049fb <realloc_block_FF+0x36c>
  8049e4:	83 ec 04             	sub    $0x4,%esp
  8049e7:	68 f8 69 80 00       	push   $0x8069f8
  8049ec:	68 10 02 00 00       	push   $0x210
  8049f1:	68 a9 69 80 00       	push   $0x8069a9
  8049f6:	e8 f8 cd ff ff       	call   8017f3 <_panic>
  8049fb:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804a01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a04:	89 50 04             	mov    %edx,0x4(%eax)
  804a07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a0a:	8b 40 04             	mov    0x4(%eax),%eax
  804a0d:	85 c0                	test   %eax,%eax
  804a0f:	74 0c                	je     804a1d <realloc_block_FF+0x38e>
  804a11:	a1 30 70 80 00       	mov    0x807030,%eax
  804a16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a19:	89 10                	mov    %edx,(%eax)
  804a1b:	eb 08                	jmp    804a25 <realloc_block_FF+0x396>
  804a1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a20:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a28:	a3 30 70 80 00       	mov    %eax,0x807030
  804a2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a36:	a1 38 70 80 00       	mov    0x807038,%eax
  804a3b:	40                   	inc    %eax
  804a3c:	a3 38 70 80 00       	mov    %eax,0x807038
  804a41:	e9 cc 00 00 00       	jmp    804b12 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804a46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804a4d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a55:	e9 8a 00 00 00       	jmp    804ae4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a5d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a60:	73 7a                	jae    804adc <realloc_block_FF+0x44d>
  804a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a65:	8b 00                	mov    (%eax),%eax
  804a67:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a6a:	73 70                	jae    804adc <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804a70:	74 06                	je     804a78 <realloc_block_FF+0x3e9>
  804a72:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a76:	75 17                	jne    804a8f <realloc_block_FF+0x400>
  804a78:	83 ec 04             	sub    $0x4,%esp
  804a7b:	68 1c 6a 80 00       	push   $0x806a1c
  804a80:	68 1a 02 00 00       	push   $0x21a
  804a85:	68 a9 69 80 00       	push   $0x8069a9
  804a8a:	e8 64 cd ff ff       	call   8017f3 <_panic>
  804a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a92:	8b 10                	mov    (%eax),%edx
  804a94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a97:	89 10                	mov    %edx,(%eax)
  804a99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a9c:	8b 00                	mov    (%eax),%eax
  804a9e:	85 c0                	test   %eax,%eax
  804aa0:	74 0b                	je     804aad <realloc_block_FF+0x41e>
  804aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aa5:	8b 00                	mov    (%eax),%eax
  804aa7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804aaa:	89 50 04             	mov    %edx,0x4(%eax)
  804aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ab0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804ab3:	89 10                	mov    %edx,(%eax)
  804ab5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804abb:	89 50 04             	mov    %edx,0x4(%eax)
  804abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ac1:	8b 00                	mov    (%eax),%eax
  804ac3:	85 c0                	test   %eax,%eax
  804ac5:	75 08                	jne    804acf <realloc_block_FF+0x440>
  804ac7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804aca:	a3 30 70 80 00       	mov    %eax,0x807030
  804acf:	a1 38 70 80 00       	mov    0x807038,%eax
  804ad4:	40                   	inc    %eax
  804ad5:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  804ada:	eb 36                	jmp    804b12 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804adc:	a1 34 70 80 00       	mov    0x807034,%eax
  804ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804ae8:	74 07                	je     804af1 <realloc_block_FF+0x462>
  804aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aed:	8b 00                	mov    (%eax),%eax
  804aef:	eb 05                	jmp    804af6 <realloc_block_FF+0x467>
  804af1:	b8 00 00 00 00       	mov    $0x0,%eax
  804af6:	a3 34 70 80 00       	mov    %eax,0x807034
  804afb:	a1 34 70 80 00       	mov    0x807034,%eax
  804b00:	85 c0                	test   %eax,%eax
  804b02:	0f 85 52 ff ff ff    	jne    804a5a <realloc_block_FF+0x3cb>
  804b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b0c:	0f 85 48 ff ff ff    	jne    804a5a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804b12:	83 ec 04             	sub    $0x4,%esp
  804b15:	6a 00                	push   $0x0
  804b17:	ff 75 d8             	pushl  -0x28(%ebp)
  804b1a:	ff 75 d4             	pushl  -0x2c(%ebp)
  804b1d:	e8 7a eb ff ff       	call   80369c <set_block_data>
  804b22:	83 c4 10             	add    $0x10,%esp
				return va;
  804b25:	8b 45 08             	mov    0x8(%ebp),%eax
  804b28:	e9 7b 02 00 00       	jmp    804da8 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804b2d:	83 ec 0c             	sub    $0xc,%esp
  804b30:	68 99 6a 80 00       	push   $0x806a99
  804b35:	e8 76 cf ff ff       	call   801ab0 <cprintf>
  804b3a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  804b40:	e9 63 02 00 00       	jmp    804da8 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b48:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804b4b:	0f 86 4d 02 00 00    	jbe    804d9e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804b51:	83 ec 0c             	sub    $0xc,%esp
  804b54:	ff 75 e4             	pushl  -0x1c(%ebp)
  804b57:	e8 08 e8 ff ff       	call   803364 <is_free_block>
  804b5c:	83 c4 10             	add    $0x10,%esp
  804b5f:	84 c0                	test   %al,%al
  804b61:	0f 84 37 02 00 00    	je     804d9e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b6a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804b6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804b70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804b73:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804b76:	76 38                	jbe    804bb0 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804b78:	83 ec 0c             	sub    $0xc,%esp
  804b7b:	ff 75 08             	pushl  0x8(%ebp)
  804b7e:	e8 0c fa ff ff       	call   80458f <free_block>
  804b83:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804b86:	83 ec 0c             	sub    $0xc,%esp
  804b89:	ff 75 0c             	pushl  0xc(%ebp)
  804b8c:	e8 3a eb ff ff       	call   8036cb <alloc_block_FF>
  804b91:	83 c4 10             	add    $0x10,%esp
  804b94:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804b97:	83 ec 08             	sub    $0x8,%esp
  804b9a:	ff 75 c0             	pushl  -0x40(%ebp)
  804b9d:	ff 75 08             	pushl  0x8(%ebp)
  804ba0:	e8 ab fa ff ff       	call   804650 <copy_data>
  804ba5:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804ba8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804bab:	e9 f8 01 00 00       	jmp    804da8 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804bb3:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804bb6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804bb9:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804bbd:	0f 87 a0 00 00 00    	ja     804c63 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804bc7:	75 17                	jne    804be0 <realloc_block_FF+0x551>
  804bc9:	83 ec 04             	sub    $0x4,%esp
  804bcc:	68 8b 69 80 00       	push   $0x80698b
  804bd1:	68 38 02 00 00       	push   $0x238
  804bd6:	68 a9 69 80 00       	push   $0x8069a9
  804bdb:	e8 13 cc ff ff       	call   8017f3 <_panic>
  804be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804be3:	8b 00                	mov    (%eax),%eax
  804be5:	85 c0                	test   %eax,%eax
  804be7:	74 10                	je     804bf9 <realloc_block_FF+0x56a>
  804be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bec:	8b 00                	mov    (%eax),%eax
  804bee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804bf1:	8b 52 04             	mov    0x4(%edx),%edx
  804bf4:	89 50 04             	mov    %edx,0x4(%eax)
  804bf7:	eb 0b                	jmp    804c04 <realloc_block_FF+0x575>
  804bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bfc:	8b 40 04             	mov    0x4(%eax),%eax
  804bff:	a3 30 70 80 00       	mov    %eax,0x807030
  804c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c07:	8b 40 04             	mov    0x4(%eax),%eax
  804c0a:	85 c0                	test   %eax,%eax
  804c0c:	74 0f                	je     804c1d <realloc_block_FF+0x58e>
  804c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c11:	8b 40 04             	mov    0x4(%eax),%eax
  804c14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c17:	8b 12                	mov    (%edx),%edx
  804c19:	89 10                	mov    %edx,(%eax)
  804c1b:	eb 0a                	jmp    804c27 <realloc_block_FF+0x598>
  804c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c20:	8b 00                	mov    (%eax),%eax
  804c22:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c3a:	a1 38 70 80 00       	mov    0x807038,%eax
  804c3f:	48                   	dec    %eax
  804c40:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804c45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804c4b:	01 d0                	add    %edx,%eax
  804c4d:	83 ec 04             	sub    $0x4,%esp
  804c50:	6a 01                	push   $0x1
  804c52:	50                   	push   %eax
  804c53:	ff 75 08             	pushl  0x8(%ebp)
  804c56:	e8 41 ea ff ff       	call   80369c <set_block_data>
  804c5b:	83 c4 10             	add    $0x10,%esp
  804c5e:	e9 36 01 00 00       	jmp    804d99 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804c63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804c69:	01 d0                	add    %edx,%eax
  804c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804c6e:	83 ec 04             	sub    $0x4,%esp
  804c71:	6a 01                	push   $0x1
  804c73:	ff 75 f0             	pushl  -0x10(%ebp)
  804c76:	ff 75 08             	pushl  0x8(%ebp)
  804c79:	e8 1e ea ff ff       	call   80369c <set_block_data>
  804c7e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804c81:	8b 45 08             	mov    0x8(%ebp),%eax
  804c84:	83 e8 04             	sub    $0x4,%eax
  804c87:	8b 00                	mov    (%eax),%eax
  804c89:	83 e0 fe             	and    $0xfffffffe,%eax
  804c8c:	89 c2                	mov    %eax,%edx
  804c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  804c91:	01 d0                	add    %edx,%eax
  804c93:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c9a:	74 06                	je     804ca2 <realloc_block_FF+0x613>
  804c9c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804ca0:	75 17                	jne    804cb9 <realloc_block_FF+0x62a>
  804ca2:	83 ec 04             	sub    $0x4,%esp
  804ca5:	68 1c 6a 80 00       	push   $0x806a1c
  804caa:	68 44 02 00 00       	push   $0x244
  804caf:	68 a9 69 80 00       	push   $0x8069a9
  804cb4:	e8 3a cb ff ff       	call   8017f3 <_panic>
  804cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cbc:	8b 10                	mov    (%eax),%edx
  804cbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cc1:	89 10                	mov    %edx,(%eax)
  804cc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cc6:	8b 00                	mov    (%eax),%eax
  804cc8:	85 c0                	test   %eax,%eax
  804cca:	74 0b                	je     804cd7 <realloc_block_FF+0x648>
  804ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ccf:	8b 00                	mov    (%eax),%eax
  804cd1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804cd4:	89 50 04             	mov    %edx,0x4(%eax)
  804cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cda:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804cdd:	89 10                	mov    %edx,(%eax)
  804cdf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804ce2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804ce5:	89 50 04             	mov    %edx,0x4(%eax)
  804ce8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804ceb:	8b 00                	mov    (%eax),%eax
  804ced:	85 c0                	test   %eax,%eax
  804cef:	75 08                	jne    804cf9 <realloc_block_FF+0x66a>
  804cf1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804cf4:	a3 30 70 80 00       	mov    %eax,0x807030
  804cf9:	a1 38 70 80 00       	mov    0x807038,%eax
  804cfe:	40                   	inc    %eax
  804cff:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804d04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d08:	75 17                	jne    804d21 <realloc_block_FF+0x692>
  804d0a:	83 ec 04             	sub    $0x4,%esp
  804d0d:	68 8b 69 80 00       	push   $0x80698b
  804d12:	68 45 02 00 00       	push   $0x245
  804d17:	68 a9 69 80 00       	push   $0x8069a9
  804d1c:	e8 d2 ca ff ff       	call   8017f3 <_panic>
  804d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d24:	8b 00                	mov    (%eax),%eax
  804d26:	85 c0                	test   %eax,%eax
  804d28:	74 10                	je     804d3a <realloc_block_FF+0x6ab>
  804d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d2d:	8b 00                	mov    (%eax),%eax
  804d2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d32:	8b 52 04             	mov    0x4(%edx),%edx
  804d35:	89 50 04             	mov    %edx,0x4(%eax)
  804d38:	eb 0b                	jmp    804d45 <realloc_block_FF+0x6b6>
  804d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d3d:	8b 40 04             	mov    0x4(%eax),%eax
  804d40:	a3 30 70 80 00       	mov    %eax,0x807030
  804d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d48:	8b 40 04             	mov    0x4(%eax),%eax
  804d4b:	85 c0                	test   %eax,%eax
  804d4d:	74 0f                	je     804d5e <realloc_block_FF+0x6cf>
  804d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d52:	8b 40 04             	mov    0x4(%eax),%eax
  804d55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d58:	8b 12                	mov    (%edx),%edx
  804d5a:	89 10                	mov    %edx,(%eax)
  804d5c:	eb 0a                	jmp    804d68 <realloc_block_FF+0x6d9>
  804d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d61:	8b 00                	mov    (%eax),%eax
  804d63:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d7b:	a1 38 70 80 00       	mov    0x807038,%eax
  804d80:	48                   	dec    %eax
  804d81:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804d86:	83 ec 04             	sub    $0x4,%esp
  804d89:	6a 00                	push   $0x0
  804d8b:	ff 75 bc             	pushl  -0x44(%ebp)
  804d8e:	ff 75 b8             	pushl  -0x48(%ebp)
  804d91:	e8 06 e9 ff ff       	call   80369c <set_block_data>
  804d96:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804d99:	8b 45 08             	mov    0x8(%ebp),%eax
  804d9c:	eb 0a                	jmp    804da8 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804d9e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804da8:	c9                   	leave  
  804da9:	c3                   	ret    

00804daa <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804daa:	55                   	push   %ebp
  804dab:	89 e5                	mov    %esp,%ebp
  804dad:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804db0:	83 ec 04             	sub    $0x4,%esp
  804db3:	68 a0 6a 80 00       	push   $0x806aa0
  804db8:	68 58 02 00 00       	push   $0x258
  804dbd:	68 a9 69 80 00       	push   $0x8069a9
  804dc2:	e8 2c ca ff ff       	call   8017f3 <_panic>

00804dc7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804dc7:	55                   	push   %ebp
  804dc8:	89 e5                	mov    %esp,%ebp
  804dca:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804dcd:	83 ec 04             	sub    $0x4,%esp
  804dd0:	68 c8 6a 80 00       	push   $0x806ac8
  804dd5:	68 61 02 00 00       	push   $0x261
  804dda:	68 a9 69 80 00       	push   $0x8069a9
  804ddf:	e8 0f ca ff ff       	call   8017f3 <_panic>

00804de4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804de4:	55                   	push   %ebp
  804de5:	89 e5                	mov    %esp,%ebp
  804de7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804dea:	8b 55 08             	mov    0x8(%ebp),%edx
  804ded:	89 d0                	mov    %edx,%eax
  804def:	c1 e0 02             	shl    $0x2,%eax
  804df2:	01 d0                	add    %edx,%eax
  804df4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804dfb:	01 d0                	add    %edx,%eax
  804dfd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e04:	01 d0                	add    %edx,%eax
  804e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e0d:	01 d0                	add    %edx,%eax
  804e0f:	c1 e0 04             	shl    $0x4,%eax
  804e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804e15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804e1c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804e1f:	83 ec 0c             	sub    $0xc,%esp
  804e22:	50                   	push   %eax
  804e23:	e8 2f e2 ff ff       	call   803057 <sys_get_virtual_time>
  804e28:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804e2b:	eb 41                	jmp    804e6e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804e2d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804e30:	83 ec 0c             	sub    $0xc,%esp
  804e33:	50                   	push   %eax
  804e34:	e8 1e e2 ff ff       	call   803057 <sys_get_virtual_time>
  804e39:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804e3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e42:	29 c2                	sub    %eax,%edx
  804e44:	89 d0                	mov    %edx,%eax
  804e46:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804e49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804e4f:	89 d1                	mov    %edx,%ecx
  804e51:	29 c1                	sub    %eax,%ecx
  804e53:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804e59:	39 c2                	cmp    %eax,%edx
  804e5b:	0f 97 c0             	seta   %al
  804e5e:	0f b6 c0             	movzbl %al,%eax
  804e61:	29 c1                	sub    %eax,%ecx
  804e63:	89 c8                	mov    %ecx,%eax
  804e65:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804e68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804e74:	72 b7                	jb     804e2d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804e76:	90                   	nop
  804e77:	c9                   	leave  
  804e78:	c3                   	ret    

00804e79 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804e79:	55                   	push   %ebp
  804e7a:	89 e5                	mov    %esp,%ebp
  804e7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804e86:	eb 03                	jmp    804e8b <busy_wait+0x12>
  804e88:	ff 45 fc             	incl   -0x4(%ebp)
  804e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804e8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  804e91:	72 f5                	jb     804e88 <busy_wait+0xf>
	return i;
  804e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804e96:	c9                   	leave  
  804e97:	c3                   	ret    

00804e98 <__udivdi3>:
  804e98:	55                   	push   %ebp
  804e99:	57                   	push   %edi
  804e9a:	56                   	push   %esi
  804e9b:	53                   	push   %ebx
  804e9c:	83 ec 1c             	sub    $0x1c,%esp
  804e9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804ea3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804ea7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804eab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804eaf:	89 ca                	mov    %ecx,%edx
  804eb1:	89 f8                	mov    %edi,%eax
  804eb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804eb7:	85 f6                	test   %esi,%esi
  804eb9:	75 2d                	jne    804ee8 <__udivdi3+0x50>
  804ebb:	39 cf                	cmp    %ecx,%edi
  804ebd:	77 65                	ja     804f24 <__udivdi3+0x8c>
  804ebf:	89 fd                	mov    %edi,%ebp
  804ec1:	85 ff                	test   %edi,%edi
  804ec3:	75 0b                	jne    804ed0 <__udivdi3+0x38>
  804ec5:	b8 01 00 00 00       	mov    $0x1,%eax
  804eca:	31 d2                	xor    %edx,%edx
  804ecc:	f7 f7                	div    %edi
  804ece:	89 c5                	mov    %eax,%ebp
  804ed0:	31 d2                	xor    %edx,%edx
  804ed2:	89 c8                	mov    %ecx,%eax
  804ed4:	f7 f5                	div    %ebp
  804ed6:	89 c1                	mov    %eax,%ecx
  804ed8:	89 d8                	mov    %ebx,%eax
  804eda:	f7 f5                	div    %ebp
  804edc:	89 cf                	mov    %ecx,%edi
  804ede:	89 fa                	mov    %edi,%edx
  804ee0:	83 c4 1c             	add    $0x1c,%esp
  804ee3:	5b                   	pop    %ebx
  804ee4:	5e                   	pop    %esi
  804ee5:	5f                   	pop    %edi
  804ee6:	5d                   	pop    %ebp
  804ee7:	c3                   	ret    
  804ee8:	39 ce                	cmp    %ecx,%esi
  804eea:	77 28                	ja     804f14 <__udivdi3+0x7c>
  804eec:	0f bd fe             	bsr    %esi,%edi
  804eef:	83 f7 1f             	xor    $0x1f,%edi
  804ef2:	75 40                	jne    804f34 <__udivdi3+0x9c>
  804ef4:	39 ce                	cmp    %ecx,%esi
  804ef6:	72 0a                	jb     804f02 <__udivdi3+0x6a>
  804ef8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804efc:	0f 87 9e 00 00 00    	ja     804fa0 <__udivdi3+0x108>
  804f02:	b8 01 00 00 00       	mov    $0x1,%eax
  804f07:	89 fa                	mov    %edi,%edx
  804f09:	83 c4 1c             	add    $0x1c,%esp
  804f0c:	5b                   	pop    %ebx
  804f0d:	5e                   	pop    %esi
  804f0e:	5f                   	pop    %edi
  804f0f:	5d                   	pop    %ebp
  804f10:	c3                   	ret    
  804f11:	8d 76 00             	lea    0x0(%esi),%esi
  804f14:	31 ff                	xor    %edi,%edi
  804f16:	31 c0                	xor    %eax,%eax
  804f18:	89 fa                	mov    %edi,%edx
  804f1a:	83 c4 1c             	add    $0x1c,%esp
  804f1d:	5b                   	pop    %ebx
  804f1e:	5e                   	pop    %esi
  804f1f:	5f                   	pop    %edi
  804f20:	5d                   	pop    %ebp
  804f21:	c3                   	ret    
  804f22:	66 90                	xchg   %ax,%ax
  804f24:	89 d8                	mov    %ebx,%eax
  804f26:	f7 f7                	div    %edi
  804f28:	31 ff                	xor    %edi,%edi
  804f2a:	89 fa                	mov    %edi,%edx
  804f2c:	83 c4 1c             	add    $0x1c,%esp
  804f2f:	5b                   	pop    %ebx
  804f30:	5e                   	pop    %esi
  804f31:	5f                   	pop    %edi
  804f32:	5d                   	pop    %ebp
  804f33:	c3                   	ret    
  804f34:	bd 20 00 00 00       	mov    $0x20,%ebp
  804f39:	89 eb                	mov    %ebp,%ebx
  804f3b:	29 fb                	sub    %edi,%ebx
  804f3d:	89 f9                	mov    %edi,%ecx
  804f3f:	d3 e6                	shl    %cl,%esi
  804f41:	89 c5                	mov    %eax,%ebp
  804f43:	88 d9                	mov    %bl,%cl
  804f45:	d3 ed                	shr    %cl,%ebp
  804f47:	89 e9                	mov    %ebp,%ecx
  804f49:	09 f1                	or     %esi,%ecx
  804f4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804f4f:	89 f9                	mov    %edi,%ecx
  804f51:	d3 e0                	shl    %cl,%eax
  804f53:	89 c5                	mov    %eax,%ebp
  804f55:	89 d6                	mov    %edx,%esi
  804f57:	88 d9                	mov    %bl,%cl
  804f59:	d3 ee                	shr    %cl,%esi
  804f5b:	89 f9                	mov    %edi,%ecx
  804f5d:	d3 e2                	shl    %cl,%edx
  804f5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804f63:	88 d9                	mov    %bl,%cl
  804f65:	d3 e8                	shr    %cl,%eax
  804f67:	09 c2                	or     %eax,%edx
  804f69:	89 d0                	mov    %edx,%eax
  804f6b:	89 f2                	mov    %esi,%edx
  804f6d:	f7 74 24 0c          	divl   0xc(%esp)
  804f71:	89 d6                	mov    %edx,%esi
  804f73:	89 c3                	mov    %eax,%ebx
  804f75:	f7 e5                	mul    %ebp
  804f77:	39 d6                	cmp    %edx,%esi
  804f79:	72 19                	jb     804f94 <__udivdi3+0xfc>
  804f7b:	74 0b                	je     804f88 <__udivdi3+0xf0>
  804f7d:	89 d8                	mov    %ebx,%eax
  804f7f:	31 ff                	xor    %edi,%edi
  804f81:	e9 58 ff ff ff       	jmp    804ede <__udivdi3+0x46>
  804f86:	66 90                	xchg   %ax,%ax
  804f88:	8b 54 24 08          	mov    0x8(%esp),%edx
  804f8c:	89 f9                	mov    %edi,%ecx
  804f8e:	d3 e2                	shl    %cl,%edx
  804f90:	39 c2                	cmp    %eax,%edx
  804f92:	73 e9                	jae    804f7d <__udivdi3+0xe5>
  804f94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804f97:	31 ff                	xor    %edi,%edi
  804f99:	e9 40 ff ff ff       	jmp    804ede <__udivdi3+0x46>
  804f9e:	66 90                	xchg   %ax,%ax
  804fa0:	31 c0                	xor    %eax,%eax
  804fa2:	e9 37 ff ff ff       	jmp    804ede <__udivdi3+0x46>
  804fa7:	90                   	nop

00804fa8 <__umoddi3>:
  804fa8:	55                   	push   %ebp
  804fa9:	57                   	push   %edi
  804faa:	56                   	push   %esi
  804fab:	53                   	push   %ebx
  804fac:	83 ec 1c             	sub    $0x1c,%esp
  804faf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804fb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  804fb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804fbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804fbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804fc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804fc7:	89 f3                	mov    %esi,%ebx
  804fc9:	89 fa                	mov    %edi,%edx
  804fcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804fcf:	89 34 24             	mov    %esi,(%esp)
  804fd2:	85 c0                	test   %eax,%eax
  804fd4:	75 1a                	jne    804ff0 <__umoddi3+0x48>
  804fd6:	39 f7                	cmp    %esi,%edi
  804fd8:	0f 86 a2 00 00 00    	jbe    805080 <__umoddi3+0xd8>
  804fde:	89 c8                	mov    %ecx,%eax
  804fe0:	89 f2                	mov    %esi,%edx
  804fe2:	f7 f7                	div    %edi
  804fe4:	89 d0                	mov    %edx,%eax
  804fe6:	31 d2                	xor    %edx,%edx
  804fe8:	83 c4 1c             	add    $0x1c,%esp
  804feb:	5b                   	pop    %ebx
  804fec:	5e                   	pop    %esi
  804fed:	5f                   	pop    %edi
  804fee:	5d                   	pop    %ebp
  804fef:	c3                   	ret    
  804ff0:	39 f0                	cmp    %esi,%eax
  804ff2:	0f 87 ac 00 00 00    	ja     8050a4 <__umoddi3+0xfc>
  804ff8:	0f bd e8             	bsr    %eax,%ebp
  804ffb:	83 f5 1f             	xor    $0x1f,%ebp
  804ffe:	0f 84 ac 00 00 00    	je     8050b0 <__umoddi3+0x108>
  805004:	bf 20 00 00 00       	mov    $0x20,%edi
  805009:	29 ef                	sub    %ebp,%edi
  80500b:	89 fe                	mov    %edi,%esi
  80500d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805011:	89 e9                	mov    %ebp,%ecx
  805013:	d3 e0                	shl    %cl,%eax
  805015:	89 d7                	mov    %edx,%edi
  805017:	89 f1                	mov    %esi,%ecx
  805019:	d3 ef                	shr    %cl,%edi
  80501b:	09 c7                	or     %eax,%edi
  80501d:	89 e9                	mov    %ebp,%ecx
  80501f:	d3 e2                	shl    %cl,%edx
  805021:	89 14 24             	mov    %edx,(%esp)
  805024:	89 d8                	mov    %ebx,%eax
  805026:	d3 e0                	shl    %cl,%eax
  805028:	89 c2                	mov    %eax,%edx
  80502a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80502e:	d3 e0                	shl    %cl,%eax
  805030:	89 44 24 04          	mov    %eax,0x4(%esp)
  805034:	8b 44 24 08          	mov    0x8(%esp),%eax
  805038:	89 f1                	mov    %esi,%ecx
  80503a:	d3 e8                	shr    %cl,%eax
  80503c:	09 d0                	or     %edx,%eax
  80503e:	d3 eb                	shr    %cl,%ebx
  805040:	89 da                	mov    %ebx,%edx
  805042:	f7 f7                	div    %edi
  805044:	89 d3                	mov    %edx,%ebx
  805046:	f7 24 24             	mull   (%esp)
  805049:	89 c6                	mov    %eax,%esi
  80504b:	89 d1                	mov    %edx,%ecx
  80504d:	39 d3                	cmp    %edx,%ebx
  80504f:	0f 82 87 00 00 00    	jb     8050dc <__umoddi3+0x134>
  805055:	0f 84 91 00 00 00    	je     8050ec <__umoddi3+0x144>
  80505b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80505f:	29 f2                	sub    %esi,%edx
  805061:	19 cb                	sbb    %ecx,%ebx
  805063:	89 d8                	mov    %ebx,%eax
  805065:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805069:	d3 e0                	shl    %cl,%eax
  80506b:	89 e9                	mov    %ebp,%ecx
  80506d:	d3 ea                	shr    %cl,%edx
  80506f:	09 d0                	or     %edx,%eax
  805071:	89 e9                	mov    %ebp,%ecx
  805073:	d3 eb                	shr    %cl,%ebx
  805075:	89 da                	mov    %ebx,%edx
  805077:	83 c4 1c             	add    $0x1c,%esp
  80507a:	5b                   	pop    %ebx
  80507b:	5e                   	pop    %esi
  80507c:	5f                   	pop    %edi
  80507d:	5d                   	pop    %ebp
  80507e:	c3                   	ret    
  80507f:	90                   	nop
  805080:	89 fd                	mov    %edi,%ebp
  805082:	85 ff                	test   %edi,%edi
  805084:	75 0b                	jne    805091 <__umoddi3+0xe9>
  805086:	b8 01 00 00 00       	mov    $0x1,%eax
  80508b:	31 d2                	xor    %edx,%edx
  80508d:	f7 f7                	div    %edi
  80508f:	89 c5                	mov    %eax,%ebp
  805091:	89 f0                	mov    %esi,%eax
  805093:	31 d2                	xor    %edx,%edx
  805095:	f7 f5                	div    %ebp
  805097:	89 c8                	mov    %ecx,%eax
  805099:	f7 f5                	div    %ebp
  80509b:	89 d0                	mov    %edx,%eax
  80509d:	e9 44 ff ff ff       	jmp    804fe6 <__umoddi3+0x3e>
  8050a2:	66 90                	xchg   %ax,%ax
  8050a4:	89 c8                	mov    %ecx,%eax
  8050a6:	89 f2                	mov    %esi,%edx
  8050a8:	83 c4 1c             	add    $0x1c,%esp
  8050ab:	5b                   	pop    %ebx
  8050ac:	5e                   	pop    %esi
  8050ad:	5f                   	pop    %edi
  8050ae:	5d                   	pop    %ebp
  8050af:	c3                   	ret    
  8050b0:	3b 04 24             	cmp    (%esp),%eax
  8050b3:	72 06                	jb     8050bb <__umoddi3+0x113>
  8050b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8050b9:	77 0f                	ja     8050ca <__umoddi3+0x122>
  8050bb:	89 f2                	mov    %esi,%edx
  8050bd:	29 f9                	sub    %edi,%ecx
  8050bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8050c3:	89 14 24             	mov    %edx,(%esp)
  8050c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8050ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8050ce:	8b 14 24             	mov    (%esp),%edx
  8050d1:	83 c4 1c             	add    $0x1c,%esp
  8050d4:	5b                   	pop    %ebx
  8050d5:	5e                   	pop    %esi
  8050d6:	5f                   	pop    %edi
  8050d7:	5d                   	pop    %ebp
  8050d8:	c3                   	ret    
  8050d9:	8d 76 00             	lea    0x0(%esi),%esi
  8050dc:	2b 04 24             	sub    (%esp),%eax
  8050df:	19 fa                	sbb    %edi,%edx
  8050e1:	89 d1                	mov    %edx,%ecx
  8050e3:	89 c6                	mov    %eax,%esi
  8050e5:	e9 71 ff ff ff       	jmp    80505b <__umoddi3+0xb3>
  8050ea:	66 90                	xchg   %ax,%ax
  8050ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8050f0:	72 ea                	jb     8050dc <__umoddi3+0x134>
  8050f2:	89 d9                	mov    %ebx,%ecx
  8050f4:	e9 62 ff ff ff       	jmp    80505b <__umoddi3+0xb3>
