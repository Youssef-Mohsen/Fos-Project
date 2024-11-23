
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 0b 0e 00 00       	call   800e41 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
  800055:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 15                	jmp    80008b <_main+0x53>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
  80007e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800087:	39 c2                	cmp    %eax,%edx
  800089:	77 c5                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008f:	74 14                	je     8000a5 <_main+0x6d>
  800091:	83 ec 04             	sub    $0x4,%esp
  800094:	68 20 48 80 00       	push   $0x804820
  800099:	6a 1a                	push   $0x1a
  80009b:	68 3c 48 80 00       	push   $0x80483c
  8000a0:	e8 db 0e 00 00       	call   800f80 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 3e 1f 00 00       	call   801fed <malloc>
  8000af:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000b2:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000c0:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c4:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c8:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000ce:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d4:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000db:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000e2:	e8 32 25 00 00       	call   802619 <sys_calculate_free_frames>
  8000e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000ea:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000f0:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 61 25 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800103:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 d6 1e 00 00       	call   801fed <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800120:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800126:	85 c0                	test   %eax,%eax
  800128:	79 0d                	jns    800137 <_main+0xff>
  80012a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800130:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800135:	76 14                	jbe    80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 50 48 80 00       	push   $0x804850
  80013f:	6a 39                	push   $0x39
  800141:	68 3c 48 80 00       	push   $0x80483c
  800146:	e8 35 0e 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 14 25 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 b8 48 80 00       	push   $0x8048b8
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 3c 48 80 00       	push   $0x80483c
  800164:	e8 17 0e 00 00       	call   800f80 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 ab 24 00 00       	call   802619 <sys_calculate_free_frames>
  80016e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800174:	01 c0                	add    %eax,%eax
  800176:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800179:	48                   	dec    %eax
  80017a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800183:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800186:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800189:	8a 55 df             	mov    -0x21(%ebp),%dl
  80018c:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800191:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800194:	01 c2                	add    %eax,%edx
  800196:	8a 45 de             	mov    -0x22(%ebp),%al
  800199:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019e:	e8 76 24 00 00       	call   802619 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 e8 48 80 00       	push   $0x8048e8
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 3c 48 80 00       	push   $0x80483c
  8001bb:	e8 c0 0d 00 00       	call   800f80 <_panic>
		int var;
		int found = 0;
  8001c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	e9 82 00 00 00       	jmp    800255 <_main+0x21d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8001de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e1:	89 d0                	mov    %edx,%eax
  8001e3:	01 c0                	add    %eax,%eax
  8001e5:	01 d0                	add    %edx,%eax
  8001e7:	c1 e0 03             	shl    $0x3,%eax
  8001ea:	01 c8                	add    %ecx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f9:	89 c2                	mov    %eax,%edx
  8001fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800201:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800204:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800209:	39 c2                	cmp    %eax,%edx
  80020b:	75 03                	jne    800210 <_main+0x1d8>
				found++;
  80020d:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800210:	a1 20 60 80 00       	mov    0x806020,%eax
  800215:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80021b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021e:	89 d0                	mov    %edx,%eax
  800220:	01 c0                	add    %eax,%eax
  800222:	01 d0                	add    %edx,%eax
  800224:	c1 e0 03             	shl    $0x3,%eax
  800227:	01 c8                	add    %ecx,%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800231:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800236:	89 c1                	mov    %eax,%ecx
  800238:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80023b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023e:	01 d0                	add    %edx,%eax
  800240:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800243:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024b:	39 c1                	cmp    %eax,%ecx
  80024d:	75 03                	jne    800252 <_main+0x21a>
				found++;
  80024f:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	a1 20 60 80 00       	mov    0x806020,%eax
  80025a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800263:	39 c2                	cmp    %eax,%edx
  800265:	0f 87 68 ff ff ff    	ja     8001d3 <_main+0x19b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80026b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80026f:	74 14                	je     800285 <_main+0x24d>
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 2c 49 80 00       	push   $0x80492c
  800279:	6a 4b                	push   $0x4b
  80027b:	68 3c 48 80 00       	push   $0x80483c
  800280:	e8 fb 0c 00 00       	call   800f80 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 da 23 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  80028a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800290:	01 c0                	add    %eax,%eax
  800292:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	50                   	push   %eax
  800299:	e8 4f 1d 00 00       	call   801fed <malloc>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002ad:	89 c2                	mov    %eax,%edx
  8002af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b2:	01 c0                	add    %eax,%eax
  8002b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b9:	39 c2                	cmp    %eax,%edx
  8002bb:	72 16                	jb     8002d3 <_main+0x29b>
  8002bd:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002c3:	89 c2                	mov    %eax,%edx
  8002c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c8:	01 c0                	add    %eax,%eax
  8002ca:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002cf:	39 c2                	cmp    %eax,%edx
  8002d1:	76 14                	jbe    8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 50 48 80 00       	push   $0x804850
  8002db:	6a 50                	push   $0x50
  8002dd:	68 3c 48 80 00       	push   $0x80483c
  8002e2:	e8 99 0c 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 78 23 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 b8 48 80 00       	push   $0x8048b8
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 3c 48 80 00       	push   $0x80483c
  800300:	e8 7b 0c 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 0f 23 00 00       	call   802619 <sys_calculate_free_frames>
  80030a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  80030d:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800313:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800319:	01 c0                	add    %eax,%eax
  80031b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80031e:	d1 e8                	shr    %eax
  800320:	48                   	dec    %eax
  800321:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  800324:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800327:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032a:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80032d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800330:	01 c0                	add    %eax,%eax
  800332:	89 c2                	mov    %eax,%edx
  800334:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800337:	01 c2                	add    %eax,%edx
  800339:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  80033d:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800340:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800343:	e8 d1 22 00 00       	call   802619 <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 e8 48 80 00       	push   $0x8048e8
  800359:	6a 58                	push   $0x58
  80035b:	68 3c 48 80 00       	push   $0x80483c
  800360:	e8 1b 0c 00 00       	call   800f80 <_panic>
		found = 0;
  800365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80036c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800373:	e9 86 00 00 00       	jmp    8003fe <_main+0x3c6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800378:	a1 20 60 80 00       	mov    0x806020,%eax
  80037d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800383:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800386:	89 d0                	mov    %edx,%eax
  800388:	01 c0                	add    %eax,%eax
  80038a:	01 d0                	add    %edx,%eax
  80038c:	c1 e0 03             	shl    $0x3,%eax
  80038f:	01 c8                	add    %ecx,%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800396:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800399:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a3:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	75 03                	jne    8003b5 <_main+0x37d>
				found++;
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8003ba:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8003c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	01 c0                	add    %eax,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 c8                	add    %ecx,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003db:	89 c2                	mov    %eax,%edx
  8003dd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e0:	01 c0                	add    %eax,%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e7:	01 c8                	add    %ecx,%eax
  8003e9:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003ec:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f4:	39 c2                	cmp    %eax,%edx
  8003f6:	75 03                	jne    8003fb <_main+0x3c3>
				found++;
  8003f8:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003fb:	ff 45 ec             	incl   -0x14(%ebp)
  8003fe:	a1 20 60 80 00       	mov    0x806020,%eax
  800403:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	0f 87 64 ff ff ff    	ja     800378 <_main+0x340>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800414:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800418:	74 14                	je     80042e <_main+0x3f6>
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 2c 49 80 00       	push   $0x80492c
  800422:	6a 61                	push   $0x61
  800424:	68 3c 48 80 00       	push   $0x80483c
  800429:	e8 52 0b 00 00       	call   800f80 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 31 22 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800433:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	01 d2                	add    %edx,%edx
  80043d:	01 d0                	add    %edx,%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 a5 1b 00 00       	call   801fed <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800451:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045c:	c1 e0 02             	shl    $0x2,%eax
  80045f:	05 00 00 00 80       	add    $0x80000000,%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	72 17                	jb     80047f <_main+0x447>
  800468:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800473:	c1 e0 02             	shl    $0x2,%eax
  800476:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80047b:	39 c2                	cmp    %eax,%edx
  80047d:	76 14                	jbe    800493 <_main+0x45b>
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 50 48 80 00       	push   $0x804850
  800487:	6a 66                	push   $0x66
  800489:	68 3c 48 80 00       	push   $0x80483c
  80048e:	e8 ed 0a 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 cc 21 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 b8 48 80 00       	push   $0x8048b8
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 3c 48 80 00       	push   $0x80483c
  8004ac:	e8 cf 0a 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 63 21 00 00       	call   802619 <sys_calculate_free_frames>
  8004b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b9:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004bf:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	c1 e8 02             	shr    $0x2,%eax
  8004ca:	48                   	dec    %eax
  8004cb:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004ce:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d4:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004d6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004e3:	01 c2                	add    %eax,%edx
  8004e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e8:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ea:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004ed:	e8 27 21 00 00       	call   802619 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 e8 48 80 00       	push   $0x8048e8
  800503:	6a 6e                	push   $0x6e
  800505:	68 3c 48 80 00       	push   $0x80483c
  80050a:	e8 71 0a 00 00       	call   800f80 <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 8f 00 00 00       	jmp    8005b1 <_main+0x579>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 20 60 80 00       	mov    0x806020,%eax
  800527:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80052d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 88             	mov    %eax,-0x78(%ebp)
  800540:	8b 45 88             	mov    -0x78(%ebp),%eax
  800543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80054d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800550:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800558:	39 c2                	cmp    %eax,%edx
  80055a:	75 03                	jne    80055f <_main+0x527>
				found++;
  80055c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80055f:	a1 20 60 80 00       	mov    0x806020,%eax
  800564:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80056a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	01 c0                	add    %eax,%eax
  800571:	01 d0                	add    %edx,%eax
  800573:	c1 e0 03             	shl    $0x3,%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 80             	mov    %eax,-0x80(%ebp)
  80057d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800580:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800585:	89 c2                	mov    %eax,%edx
  800587:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800591:	8b 45 90             	mov    -0x70(%ebp),%eax
  800594:	01 c8                	add    %ecx,%eax
  800596:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80059c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a7:	39 c2                	cmp    %eax,%edx
  8005a9:	75 03                	jne    8005ae <_main+0x576>
				found++;
  8005ab:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005ae:	ff 45 ec             	incl   -0x14(%ebp)
  8005b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8005b6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	0f 87 5b ff ff ff    	ja     800522 <_main+0x4ea>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005c7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005cb:	74 14                	je     8005e1 <_main+0x5a9>
  8005cd:	83 ec 04             	sub    $0x4,%esp
  8005d0:	68 2c 49 80 00       	push   $0x80492c
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 3c 48 80 00       	push   $0x80483c
  8005dc:	e8 9f 09 00 00       	call   800f80 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 33 20 00 00       	call   802619 <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 76 20 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  8005ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f4:	89 c2                	mov    %eax,%edx
  8005f6:	01 d2                	add    %edx,%edx
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 ea 19 00 00       	call   801fed <malloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060c:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800617:	c1 e0 02             	shl    $0x2,%eax
  80061a:	89 c1                	mov    %eax,%ecx
  80061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061f:	c1 e0 02             	shl    $0x2,%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	05 00 00 00 80       	add    $0x80000000,%eax
  800629:	39 c2                	cmp    %eax,%edx
  80062b:	72 21                	jb     80064e <_main+0x616>
  80062d:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800633:	89 c2                	mov    %eax,%edx
  800635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800638:	c1 e0 02             	shl    $0x2,%eax
  80063b:	89 c1                	mov    %eax,%ecx
  80063d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800640:	c1 e0 02             	shl    $0x2,%eax
  800643:	01 c8                	add    %ecx,%eax
  800645:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80064a:	39 c2                	cmp    %eax,%edx
  80064c:	76 14                	jbe    800662 <_main+0x62a>
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	68 50 48 80 00       	push   $0x804850
  800656:	6a 7d                	push   $0x7d
  800658:	68 3c 48 80 00       	push   $0x80483c
  80065d:	e8 1e 09 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 fd 1f 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 b8 48 80 00       	push   $0x8048b8
  800674:	6a 7e                	push   $0x7e
  800676:	68 3c 48 80 00       	push   $0x80483c
  80067b:	e8 00 09 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 df 1f 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800685:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800688:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	01 c0                	add    %eax,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	50                   	push   %eax
  800699:	e8 4f 19 00 00       	call   801fed <malloc>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006a7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006ad:	89 c2                	mov    %eax,%edx
  8006af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b2:	c1 e0 02             	shl    $0x2,%eax
  8006b5:	89 c1                	mov    %eax,%ecx
  8006b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ba:	c1 e0 03             	shl    $0x3,%eax
  8006bd:	01 c8                	add    %ecx,%eax
  8006bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c4:	39 c2                	cmp    %eax,%edx
  8006c6:	72 21                	jb     8006e9 <_main+0x6b1>
  8006c8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d3:	c1 e0 02             	shl    $0x2,%eax
  8006d6:	89 c1                	mov    %eax,%ecx
  8006d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006db:	c1 e0 03             	shl    $0x3,%eax
  8006de:	01 c8                	add    %ecx,%eax
  8006e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e5:	39 c2                	cmp    %eax,%edx
  8006e7:	76 17                	jbe    800700 <_main+0x6c8>
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	68 50 48 80 00       	push   $0x804850
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 3c 48 80 00       	push   $0x80483c
  8006fb:	e8 80 08 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 5f 1f 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 b8 48 80 00       	push   $0x8048b8
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 3c 48 80 00       	push   $0x80483c
  80071c:	e8 5f 08 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 f3 1e 00 00       	call   802619 <sys_calculate_free_frames>
  800726:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  800729:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  80072f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800735:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800738:	89 d0                	mov    %edx,%eax
  80073a:	01 c0                	add    %eax,%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	01 c0                	add    %eax,%eax
  800740:	01 d0                	add    %edx,%eax
  800742:	c1 e8 03             	shr    $0x3,%eax
  800745:	48                   	dec    %eax
  800746:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80074c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800752:	8a 55 df             	mov    -0x21(%ebp),%dl
  800755:	88 10                	mov    %dl,(%eax)
  800757:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  80075d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800760:	66 89 42 02          	mov    %ax,0x2(%edx)
  800764:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80076d:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800770:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800776:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800783:	01 c2                	add    %eax,%edx
  800785:	8a 45 de             	mov    -0x22(%ebp),%al
  800788:	88 02                	mov    %al,(%edx)
  80078a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800797:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80079d:	01 c2                	add    %eax,%edx
  80079f:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  8007a3:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ba:	01 c2                	add    %eax,%edx
  8007bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007bf:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c2:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007c5:	e8 4f 1e 00 00       	call   802619 <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 e8 48 80 00       	push   $0x8048e8
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 3c 48 80 00       	push   $0x80483c
  8007e5:	e8 96 07 00 00       	call   800f80 <_panic>
		found = 0;
  8007ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007f8:	e9 aa 00 00 00       	jmp    8008a7 <_main+0x86f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007fd:	a1 20 60 80 00       	mov    0x806020,%eax
  800802:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800808:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80080b:	89 d0                	mov    %edx,%eax
  80080d:	01 c0                	add    %eax,%eax
  80080f:	01 d0                	add    %edx,%eax
  800811:	c1 e0 03             	shl    $0x3,%eax
  800814:	01 c8                	add    %ecx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  80081e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800829:	89 c2                	mov    %eax,%edx
  80082b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800831:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800837:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80083d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800842:	39 c2                	cmp    %eax,%edx
  800844:	75 03                	jne    800849 <_main+0x811>
				found++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  800849:	a1 20 60 80 00       	mov    0x806020,%eax
  80084e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800854:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	01 c0                	add    %eax,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	c1 e0 03             	shl    $0x3,%eax
  800860:	01 c8                	add    %ecx,%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80086a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 c2                	mov    %eax,%edx
  800877:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800884:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80088a:	01 c8                	add    %ecx,%eax
  80088c:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800892:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800898:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089d:	39 c2                	cmp    %eax,%edx
  80089f:	75 03                	jne    8008a4 <_main+0x86c>
				found++;
  8008a1:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008a4:	ff 45 ec             	incl   -0x14(%ebp)
  8008a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8008ac:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b5:	39 c2                	cmp    %eax,%edx
  8008b7:	0f 87 40 ff ff ff    	ja     8007fd <_main+0x7c5>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c1:	74 17                	je     8008da <_main+0x8a2>
  8008c3:	83 ec 04             	sub    $0x4,%esp
  8008c6:	68 2c 49 80 00       	push   $0x80492c
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 3c 48 80 00       	push   $0x80483c
  8008d5:	e8 a6 06 00 00       	call   800f80 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 3a 1d 00 00       	call   802619 <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 7d 1d 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  8008e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	01 d2                	add    %edx,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	83 ec 0c             	sub    $0xc,%esp
  8008f9:	50                   	push   %eax
  8008fa:	e8 ee 16 00 00       	call   801fed <malloc>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800908:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80090e:	89 c2                	mov    %eax,%edx
  800910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800913:	c1 e0 02             	shl    $0x2,%eax
  800916:	89 c1                	mov    %eax,%ecx
  800918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091b:	c1 e0 04             	shl    $0x4,%eax
  80091e:	01 c8                	add    %ecx,%eax
  800920:	05 00 00 00 80       	add    $0x80000000,%eax
  800925:	39 c2                	cmp    %eax,%edx
  800927:	72 21                	jb     80094a <_main+0x912>
  800929:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80092f:	89 c2                	mov    %eax,%edx
  800931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800934:	c1 e0 02             	shl    $0x2,%eax
  800937:	89 c1                	mov    %eax,%ecx
  800939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093c:	c1 e0 04             	shl    $0x4,%eax
  80093f:	01 c8                	add    %ecx,%eax
  800941:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800946:	39 c2                	cmp    %eax,%edx
  800948:	76 17                	jbe    800961 <_main+0x929>
  80094a:	83 ec 04             	sub    $0x4,%esp
  80094d:	68 50 48 80 00       	push   $0x804850
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 3c 48 80 00       	push   $0x80483c
  80095c:	e8 1f 06 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 fe 1c 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 b8 48 80 00       	push   $0x8048b8
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 3c 48 80 00       	push   $0x80483c
  80097d:	e8 fe 05 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 dd 1c 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800987:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80098a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	01 c0                	add    %eax,%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	01 c0                	add    %eax,%eax
  800995:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800998:	83 ec 0c             	sub    $0xc,%esp
  80099b:	50                   	push   %eax
  80099c:	e8 4c 16 00 00       	call   801fed <malloc>
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009b0:	89 c1                	mov    %eax,%ecx
  8009b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c4:	c1 e0 04             	shl    $0x4,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	05 00 00 00 80       	add    $0x80000000,%eax
  8009ce:	39 c1                	cmp    %eax,%ecx
  8009d0:	72 28                	jb     8009fa <_main+0x9c2>
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009d8:	89 c1                	mov    %eax,%ecx
  8009da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	01 c0                	add    %eax,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d0                	add    %edx,%eax
  8009e7:	89 c2                	mov    %eax,%edx
  8009e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ec:	c1 e0 04             	shl    $0x4,%eax
  8009ef:	01 d0                	add    %edx,%eax
  8009f1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009f6:	39 c1                	cmp    %eax,%ecx
  8009f8:	76 17                	jbe    800a11 <_main+0x9d9>
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 50 48 80 00       	push   $0x804850
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 3c 48 80 00       	push   $0x80483c
  800a0c:	e8 6f 05 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 4e 1c 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 b8 48 80 00       	push   $0x8048b8
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 3c 48 80 00       	push   $0x80483c
  800a2d:	e8 4e 05 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 e2 1b 00 00       	call   802619 <sys_calculate_free_frames>
  800a37:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a3d:	89 d0                	mov    %edx,%eax
  800a3f:	01 c0                	add    %eax,%eax
  800a41:	01 d0                	add    %edx,%eax
  800a43:	01 c0                	add    %eax,%eax
  800a45:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a48:	48                   	dec    %eax
  800a49:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a4f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a55:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a5b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a61:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a64:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a66:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a6c:	89 c2                	mov    %eax,%edx
  800a6e:	c1 ea 1f             	shr    $0x1f,%edx
  800a71:	01 d0                	add    %edx,%eax
  800a73:	d1 f8                	sar    %eax
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a7d:	01 c2                	add    %eax,%edx
  800a7f:	8a 45 de             	mov    -0x22(%ebp),%al
  800a82:	88 c1                	mov    %al,%cl
  800a84:	c0 e9 07             	shr    $0x7,%cl
  800a87:	01 c8                	add    %ecx,%eax
  800a89:	d0 f8                	sar    %al
  800a8b:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a8d:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a93:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a99:	01 c2                	add    %eax,%edx
  800a9b:	8a 45 de             	mov    -0x22(%ebp),%al
  800a9e:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800aa0:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800aa3:	e8 71 1b 00 00       	call   802619 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 e8 48 80 00       	push   $0x8048e8
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 3c 48 80 00       	push   $0x80483c
  800ac3:	e8 b8 04 00 00       	call   800f80 <_panic>
		found = 0;
  800ac8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ad6:	e9 02 01 00 00       	jmp    800bdd <_main+0xba5>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800adb:	a1 20 60 80 00       	mov    0x806020,%eax
  800ae0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800ae6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	01 c0                	add    %eax,%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	c1 e0 03             	shl    $0x3,%eax
  800af2:	01 c8                	add    %ecx,%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800afc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b0f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b15:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	75 03                	jne    800b27 <_main+0xaef>
				found++;
  800b24:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b27:	a1 20 60 80 00       	mov    0x806020,%eax
  800b2c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800b32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b35:	89 d0                	mov    %edx,%eax
  800b37:	01 c0                	add    %eax,%eax
  800b39:	01 d0                	add    %edx,%eax
  800b3b:	c1 e0 03             	shl    $0x3,%eax
  800b3e:	01 c8                	add    %ecx,%eax
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b48:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b5b:	89 c1                	mov    %eax,%ecx
  800b5d:	c1 e9 1f             	shr    $0x1f,%ecx
  800b60:	01 c8                	add    %ecx,%eax
  800b62:	d1 f8                	sar    %eax
  800b64:	89 c1                	mov    %eax,%ecx
  800b66:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b6c:	01 c8                	add    %ecx,%eax
  800b6e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b74:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7f:	39 c2                	cmp    %eax,%edx
  800b81:	75 03                	jne    800b86 <_main+0xb4e>
				found++;
  800b83:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b86:	a1 20 60 80 00       	mov    0x806020,%eax
  800b8b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800b91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b94:	89 d0                	mov    %edx,%eax
  800b96:	01 c0                	add    %eax,%eax
  800b98:	01 d0                	add    %edx,%eax
  800b9a:	c1 e0 03             	shl    $0x3,%eax
  800b9d:	01 c8                	add    %ecx,%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800ba7:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800bad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb2:	89 c1                	mov    %eax,%ecx
  800bb4:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bba:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bc0:	01 d0                	add    %edx,%eax
  800bc2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bc8:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd3:	39 c1                	cmp    %eax,%ecx
  800bd5:	75 03                	jne    800bda <_main+0xba2>
				found++;
  800bd7:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bda:	ff 45 ec             	incl   -0x14(%ebp)
  800bdd:	a1 20 60 80 00       	mov    0x806020,%eax
  800be2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	39 c2                	cmp    %eax,%edx
  800bed:	0f 87 e8 fe ff ff    	ja     800adb <_main+0xaa3>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bf3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800bf7:	74 17                	je     800c10 <_main+0xbd8>
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	68 2c 49 80 00       	push   $0x80492c
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 3c 48 80 00       	push   $0x80483c
  800c0b:	e8 70 03 00 00       	call   800f80 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 4f 1a 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800c15:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	01 c0                	add    %eax,%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	01 c0                	add    %eax,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	50                   	push   %eax
  800c2b:	e8 bd 13 00 00       	call   801fed <malloc>
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c39:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c3f:	89 c1                	mov    %eax,%ecx
  800c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c44:	89 d0                	mov    %edx,%eax
  800c46:	01 c0                	add    %eax,%eax
  800c48:	01 d0                	add    %edx,%eax
  800c4a:	c1 e0 02             	shl    $0x2,%eax
  800c4d:	01 d0                	add    %edx,%eax
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	c1 e0 04             	shl    $0x4,%eax
  800c57:	01 d0                	add    %edx,%eax
  800c59:	05 00 00 00 80       	add    $0x80000000,%eax
  800c5e:	39 c1                	cmp    %eax,%ecx
  800c60:	72 29                	jb     800c8b <_main+0xc53>
  800c62:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c68:	89 c1                	mov    %eax,%ecx
  800c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c6d:	89 d0                	mov    %edx,%eax
  800c6f:	01 c0                	add    %eax,%eax
  800c71:	01 d0                	add    %edx,%eax
  800c73:	c1 e0 02             	shl    $0x2,%eax
  800c76:	01 d0                	add    %edx,%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c7d:	c1 e0 04             	shl    $0x4,%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c87:	39 c1                	cmp    %eax,%ecx
  800c89:	76 17                	jbe    800ca2 <_main+0xc6a>
  800c8b:	83 ec 04             	sub    $0x4,%esp
  800c8e:	68 50 48 80 00       	push   $0x804850
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 3c 48 80 00       	push   $0x80483c
  800c9d:	e8 de 02 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 bd 19 00 00       	call   802664 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 b8 48 80 00       	push   $0x8048b8
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 3c 48 80 00       	push   $0x80483c
  800cbe:	e8 bd 02 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 51 19 00 00       	call   802619 <sys_calculate_free_frames>
  800cc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800ccb:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cd1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cda:	89 d0                	mov    %edx,%eax
  800cdc:	01 c0                	add    %eax,%eax
  800cde:	01 d0                	add    %edx,%eax
  800ce0:	01 c0                	add    %eax,%eax
  800ce2:	01 d0                	add    %edx,%eax
  800ce4:	01 c0                	add    %eax,%eax
  800ce6:	d1 e8                	shr    %eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cef:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cf8:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800cfb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d01:	01 c0                	add    %eax,%eax
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d0b:	01 c2                	add    %eax,%edx
  800d0d:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800d11:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d14:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d17:	e8 fd 18 00 00       	call   802619 <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 e8 48 80 00       	push   $0x8048e8
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 3c 48 80 00       	push   $0x80483c
  800d37:	e8 44 02 00 00       	call   800f80 <_panic>
		found = 0;
  800d3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d4a:	e9 a7 00 00 00       	jmp    800df6 <_main+0xdbe>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d4f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d54:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d5d:	89 d0                	mov    %edx,%eax
  800d5f:	01 c0                	add    %eax,%eax
  800d61:	01 d0                	add    %edx,%eax
  800d63:	c1 e0 03             	shl    $0x3,%eax
  800d66:	01 c8                	add    %ecx,%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d70:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d83:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d89:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d94:	39 c2                	cmp    %eax,%edx
  800d96:	75 03                	jne    800d9b <_main+0xd63>
				found++;
  800d98:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d9b:	a1 20 60 80 00       	mov    0x806020,%eax
  800da0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800da6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	01 c0                	add    %eax,%eax
  800dad:	01 d0                	add    %edx,%eax
  800daf:	c1 e0 03             	shl    $0x3,%eax
  800db2:	01 c8                	add    %ecx,%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800dbc:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dc7:	89 c2                	mov    %eax,%edx
  800dc9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dcf:	01 c0                	add    %eax,%eax
  800dd1:	89 c1                	mov    %eax,%ecx
  800dd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dd9:	01 c8                	add    %ecx,%eax
  800ddb:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800de1:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800de7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dec:	39 c2                	cmp    %eax,%edx
  800dee:	75 03                	jne    800df3 <_main+0xdbb>
				found++;
  800df0:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800df3:	ff 45 ec             	incl   -0x14(%ebp)
  800df6:	a1 20 60 80 00       	mov    0x806020,%eax
  800dfb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e04:	39 c2                	cmp    %eax,%edx
  800e06:	0f 87 43 ff ff ff    	ja     800d4f <_main+0xd17>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e0c:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e10:	74 17                	je     800e29 <_main+0xdf1>
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	68 2c 49 80 00       	push   $0x80492c
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 3c 48 80 00       	push   $0x80483c
  800e24:	e8 57 01 00 00       	call   800f80 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 4c 49 80 00       	push   $0x80494c
  800e31:	e8 07 04 00 00       	call   80123d <cprintf>
  800e36:	83 c4 10             	add    $0x10,%esp

	return;
  800e39:	90                   	nop
}
  800e3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e47:	e8 96 19 00 00       	call   8027e2 <sys_getenvindex>
  800e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	c1 e0 03             	shl    $0x3,%eax
  800e57:	01 d0                	add    %edx,%eax
  800e59:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800e60:	01 c8                	add    %ecx,%eax
  800e62:	01 c0                	add    %eax,%eax
  800e64:	01 d0                	add    %edx,%eax
  800e66:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800e6d:	01 c8                	add    %ecx,%eax
  800e6f:	01 d0                	add    %edx,%eax
  800e71:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e76:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e7b:	a1 20 60 80 00       	mov    0x806020,%eax
  800e80:	8a 40 20             	mov    0x20(%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	74 0d                	je     800e94 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800e87:	a1 20 60 80 00       	mov    0x806020,%eax
  800e8c:	83 c0 20             	add    $0x20,%eax
  800e8f:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e98:	7e 0a                	jle    800ea4 <libmain+0x63>
		binaryname = argv[0];
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	8b 00                	mov    (%eax),%eax
  800e9f:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  800ea4:	83 ec 08             	sub    $0x8,%esp
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	ff 75 08             	pushl  0x8(%ebp)
  800ead:	e8 86 f1 ff ff       	call   800038 <_main>
  800eb2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800eb5:	e8 ac 16 00 00       	call   802566 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	68 a0 49 80 00       	push   $0x8049a0
  800ec2:	e8 76 03 00 00       	call   80123d <cprintf>
  800ec7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eca:	a1 20 60 80 00       	mov    0x806020,%eax
  800ecf:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800ed5:	a1 20 60 80 00       	mov    0x806020,%eax
  800eda:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800ee0:	83 ec 04             	sub    $0x4,%esp
  800ee3:	52                   	push   %edx
  800ee4:	50                   	push   %eax
  800ee5:	68 c8 49 80 00       	push   $0x8049c8
  800eea:	e8 4e 03 00 00       	call   80123d <cprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ef2:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef7:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800efd:	a1 20 60 80 00       	mov    0x806020,%eax
  800f02:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800f08:	a1 20 60 80 00       	mov    0x806020,%eax
  800f0d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800f13:	51                   	push   %ecx
  800f14:	52                   	push   %edx
  800f15:	50                   	push   %eax
  800f16:	68 f0 49 80 00       	push   $0x8049f0
  800f1b:	e8 1d 03 00 00       	call   80123d <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f23:	a1 20 60 80 00       	mov    0x806020,%eax
  800f28:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	50                   	push   %eax
  800f32:	68 48 4a 80 00       	push   $0x804a48
  800f37:	e8 01 03 00 00       	call   80123d <cprintf>
  800f3c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	68 a0 49 80 00       	push   $0x8049a0
  800f47:	e8 f1 02 00 00       	call   80123d <cprintf>
  800f4c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f4f:	e8 2c 16 00 00       	call   802580 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800f54:	e8 19 00 00 00       	call   800f72 <exit>
}
  800f59:	90                   	nop
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	6a 00                	push   $0x0
  800f67:	e8 42 18 00 00       	call   8027ae <sys_destroy_env>
  800f6c:	83 c4 10             	add    $0x10,%esp
}
  800f6f:	90                   	nop
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <exit>:

void
exit(void)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f78:	e8 97 18 00 00       	call   802814 <sys_exit_env>
}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f86:	8d 45 10             	lea    0x10(%ebp),%eax
  800f89:	83 c0 04             	add    $0x4,%eax
  800f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f8f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800f94:	85 c0                	test   %eax,%eax
  800f96:	74 16                	je     800fae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f98:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	50                   	push   %eax
  800fa1:	68 5c 4a 80 00       	push   $0x804a5c
  800fa6:	e8 92 02 00 00       	call   80123d <cprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fae:	a1 00 60 80 00       	mov    0x806000,%eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	68 61 4a 80 00       	push   $0x804a61
  800fbf:	e8 79 02 00 00       	call   80123d <cprintf>
  800fc4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd0:	50                   	push   %eax
  800fd1:	e8 fc 01 00 00       	call   8011d2 <vcprintf>
  800fd6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	6a 00                	push   $0x0
  800fde:	68 7d 4a 80 00       	push   $0x804a7d
  800fe3:	e8 ea 01 00 00       	call   8011d2 <vcprintf>
  800fe8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800feb:	e8 82 ff ff ff       	call   800f72 <exit>

	// should not return here
	while (1) ;
  800ff0:	eb fe                	jmp    800ff0 <_panic+0x70>

00800ff2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ff8:	a1 20 60 80 00       	mov    0x806020,%eax
  800ffd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	39 c2                	cmp    %eax,%edx
  801008:	74 14                	je     80101e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	68 80 4a 80 00       	push   $0x804a80
  801012:	6a 26                	push   $0x26
  801014:	68 cc 4a 80 00       	push   $0x804acc
  801019:	e8 62 ff ff ff       	call   800f80 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80101e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80102c:	e9 c5 00 00 00       	jmp    8010f6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801034:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	01 d0                	add    %edx,%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	85 c0                	test   %eax,%eax
  801044:	75 08                	jne    80104e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801046:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801049:	e9 a5 00 00 00       	jmp    8010f3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80104e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801055:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80105c:	eb 69                	jmp    8010c7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80105e:	a1 20 60 80 00       	mov    0x806020,%eax
  801063:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801069:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80106c:	89 d0                	mov    %edx,%eax
  80106e:	01 c0                	add    %eax,%eax
  801070:	01 d0                	add    %edx,%eax
  801072:	c1 e0 03             	shl    $0x3,%eax
  801075:	01 c8                	add    %ecx,%eax
  801077:	8a 40 04             	mov    0x4(%eax),%al
  80107a:	84 c0                	test   %al,%al
  80107c:	75 46                	jne    8010c4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80107e:	a1 20 60 80 00       	mov    0x806020,%eax
  801083:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801089:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80108c:	89 d0                	mov    %edx,%eax
  80108e:	01 c0                	add    %eax,%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	c1 e0 03             	shl    $0x3,%eax
  801095:	01 c8                	add    %ecx,%eax
  801097:	8b 00                	mov    (%eax),%eax
  801099:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80109c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80109f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	01 c8                	add    %ecx,%eax
  8010b5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	75 09                	jne    8010c4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010bb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010c2:	eb 15                	jmp    8010d9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010c4:	ff 45 e8             	incl   -0x18(%ebp)
  8010c7:	a1 20 60 80 00       	mov    0x806020,%eax
  8010cc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8010d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010d5:	39 c2                	cmp    %eax,%edx
  8010d7:	77 85                	ja     80105e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010dd:	75 14                	jne    8010f3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	68 d8 4a 80 00       	push   $0x804ad8
  8010e7:	6a 3a                	push   $0x3a
  8010e9:	68 cc 4a 80 00       	push   $0x804acc
  8010ee:	e8 8d fe ff ff       	call   800f80 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010f3:	ff 45 f0             	incl   -0x10(%ebp)
  8010f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010fc:	0f 8c 2f ff ff ff    	jl     801031 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801102:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801109:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801110:	eb 26                	jmp    801138 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801112:	a1 20 60 80 00       	mov    0x806020,%eax
  801117:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80111d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801120:	89 d0                	mov    %edx,%eax
  801122:	01 c0                	add    %eax,%eax
  801124:	01 d0                	add    %edx,%eax
  801126:	c1 e0 03             	shl    $0x3,%eax
  801129:	01 c8                	add    %ecx,%eax
  80112b:	8a 40 04             	mov    0x4(%eax),%al
  80112e:	3c 01                	cmp    $0x1,%al
  801130:	75 03                	jne    801135 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801132:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801135:	ff 45 e0             	incl   -0x20(%ebp)
  801138:	a1 20 60 80 00       	mov    0x806020,%eax
  80113d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801143:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801146:	39 c2                	cmp    %eax,%edx
  801148:	77 c8                	ja     801112 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80114a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801150:	74 14                	je     801166 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801152:	83 ec 04             	sub    $0x4,%esp
  801155:	68 2c 4b 80 00       	push   $0x804b2c
  80115a:	6a 44                	push   $0x44
  80115c:	68 cc 4a 80 00       	push   $0x804acc
  801161:	e8 1a fe ff ff       	call   800f80 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801166:	90                   	nop
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	8d 48 01             	lea    0x1(%eax),%ecx
  801177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117a:	89 0a                	mov    %ecx,(%edx)
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	88 d1                	mov    %dl,%cl
  801181:	8b 55 0c             	mov    0xc(%ebp),%edx
  801184:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 00                	mov    (%eax),%eax
  80118d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801192:	75 2c                	jne    8011c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801194:	a0 28 60 80 00       	mov    0x806028,%al
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119f:	8b 12                	mov    (%edx),%edx
  8011a1:	89 d1                	mov    %edx,%ecx
  8011a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a6:	83 c2 08             	add    $0x8,%edx
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	50                   	push   %eax
  8011ad:	51                   	push   %ecx
  8011ae:	52                   	push   %edx
  8011af:	e8 70 13 00 00       	call   802524 <sys_cputs>
  8011b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	8b 40 04             	mov    0x4(%eax),%eax
  8011c6:	8d 50 01             	lea    0x1(%eax),%edx
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011cf:	90                   	nop
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011e2:	00 00 00 
	b.cnt = 0;
  8011e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ef:	ff 75 0c             	pushl  0xc(%ebp)
  8011f2:	ff 75 08             	pushl  0x8(%ebp)
  8011f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011fb:	50                   	push   %eax
  8011fc:	68 69 11 80 00       	push   $0x801169
  801201:	e8 11 02 00 00       	call   801417 <vprintfmt>
  801206:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801209:	a0 28 60 80 00       	mov    0x806028,%al
  80120e:	0f b6 c0             	movzbl %al,%eax
  801211:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	50                   	push   %eax
  80121b:	52                   	push   %edx
  80121c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801222:	83 c0 08             	add    $0x8,%eax
  801225:	50                   	push   %eax
  801226:	e8 f9 12 00 00       	call   802524 <sys_cputs>
  80122b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80122e:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  801235:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801243:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  80124a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80124d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 f4             	pushl  -0xc(%ebp)
  801259:	50                   	push   %eax
  80125a:	e8 73 ff ff ff       	call   8011d2 <vcprintf>
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801265:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801270:	e8 f1 12 00 00       	call   802566 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801275:	8d 45 0c             	lea    0xc(%ebp),%eax
  801278:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	83 ec 08             	sub    $0x8,%esp
  801281:	ff 75 f4             	pushl  -0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	e8 48 ff ff ff       	call   8011d2 <vcprintf>
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801290:	e8 eb 12 00 00       	call   802580 <sys_unlock_cons>
	return cnt;
  801295:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	53                   	push   %ebx
  80129e:	83 ec 14             	sub    $0x14,%esp
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8012b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012b8:	77 55                	ja     80130f <printnum+0x75>
  8012ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012bd:	72 05                	jb     8012c4 <printnum+0x2a>
  8012bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c2:	77 4b                	ja     80130f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8012cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d2:	52                   	push   %edx
  8012d3:	50                   	push   %eax
  8012d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8012da:	e8 dd 32 00 00       	call   8045bc <__udivdi3>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	ff 75 20             	pushl  0x20(%ebp)
  8012e8:	53                   	push   %ebx
  8012e9:	ff 75 18             	pushl  0x18(%ebp)
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	e8 a1 ff ff ff       	call   80129a <printnum>
  8012f9:	83 c4 20             	add    $0x20,%esp
  8012fc:	eb 1a                	jmp    801318 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	ff 75 0c             	pushl  0xc(%ebp)
  801304:	ff 75 20             	pushl  0x20(%ebp)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	ff d0                	call   *%eax
  80130c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80130f:	ff 4d 1c             	decl   0x1c(%ebp)
  801312:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801316:	7f e6                	jg     8012fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801318:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80131b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	53                   	push   %ebx
  801327:	51                   	push   %ecx
  801328:	52                   	push   %edx
  801329:	50                   	push   %eax
  80132a:	e8 9d 33 00 00       	call   8046cc <__umoddi3>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	05 94 4d 80 00       	add    $0x804d94,%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	ff 75 0c             	pushl  0xc(%ebp)
  801342:	50                   	push   %eax
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	ff d0                	call   *%eax
  801348:	83 c4 10             	add    $0x10,%esp
}
  80134b:	90                   	nop
  80134c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801354:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801358:	7e 1c                	jle    801376 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	8d 50 08             	lea    0x8(%eax),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	89 10                	mov    %edx,(%eax)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	83 e8 08             	sub    $0x8,%eax
  80136f:	8b 50 04             	mov    0x4(%eax),%edx
  801372:	8b 00                	mov    (%eax),%eax
  801374:	eb 40                	jmp    8013b6 <getuint+0x65>
	else if (lflag)
  801376:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137a:	74 1e                	je     80139a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8b 00                	mov    (%eax),%eax
  801381:	8d 50 04             	lea    0x4(%eax),%edx
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	89 10                	mov    %edx,(%eax)
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	83 e8 04             	sub    $0x4,%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	ba 00 00 00 00       	mov    $0x0,%edx
  801398:	eb 1c                	jmp    8013b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	8d 50 04             	lea    0x4(%eax),%edx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	89 10                	mov    %edx,(%eax)
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	83 e8 04             	sub    $0x4,%eax
  8013af:	8b 00                	mov    (%eax),%eax
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013bf:	7e 1c                	jle    8013dd <getint+0x25>
		return va_arg(*ap, long long);
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	8d 50 08             	lea    0x8(%eax),%edx
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	89 10                	mov    %edx,(%eax)
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	83 e8 08             	sub    $0x8,%eax
  8013d6:	8b 50 04             	mov    0x4(%eax),%edx
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	eb 38                	jmp    801415 <getint+0x5d>
	else if (lflag)
  8013dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e1:	74 1a                	je     8013fd <getint+0x45>
		return va_arg(*ap, long);
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	8d 50 04             	lea    0x4(%eax),%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 10                	mov    %edx,(%eax)
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8b 00                	mov    (%eax),%eax
  8013f5:	83 e8 04             	sub    $0x4,%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	99                   	cltd   
  8013fb:	eb 18                	jmp    801415 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8b 00                	mov    (%eax),%eax
  801402:	8d 50 04             	lea    0x4(%eax),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	89 10                	mov    %edx,(%eax)
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	83 e8 04             	sub    $0x4,%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	99                   	cltd   
}
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80141f:	eb 17                	jmp    801438 <vprintfmt+0x21>
			if (ch == '\0')
  801421:	85 db                	test   %ebx,%ebx
  801423:	0f 84 c1 03 00 00    	je     8017ea <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	ff 75 0c             	pushl  0xc(%ebp)
  80142f:	53                   	push   %ebx
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	ff d0                	call   *%eax
  801435:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801438:	8b 45 10             	mov    0x10(%ebp),%eax
  80143b:	8d 50 01             	lea    0x1(%eax),%edx
  80143e:	89 55 10             	mov    %edx,0x10(%ebp)
  801441:	8a 00                	mov    (%eax),%al
  801443:	0f b6 d8             	movzbl %al,%ebx
  801446:	83 fb 25             	cmp    $0x25,%ebx
  801449:	75 d6                	jne    801421 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80144b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80144f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801456:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80145d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801464:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 10             	mov    %edx,0x10(%ebp)
  801474:	8a 00                	mov    (%eax),%al
  801476:	0f b6 d8             	movzbl %al,%ebx
  801479:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80147c:	83 f8 5b             	cmp    $0x5b,%eax
  80147f:	0f 87 3d 03 00 00    	ja     8017c2 <vprintfmt+0x3ab>
  801485:	8b 04 85 b8 4d 80 00 	mov    0x804db8(,%eax,4),%eax
  80148c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80148e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801492:	eb d7                	jmp    80146b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801494:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801498:	eb d1                	jmp    80146b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80149a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014a4:	89 d0                	mov    %edx,%eax
  8014a6:	c1 e0 02             	shl    $0x2,%eax
  8014a9:	01 d0                	add    %edx,%eax
  8014ab:	01 c0                	add    %eax,%eax
  8014ad:	01 d8                	add    %ebx,%eax
  8014af:	83 e8 30             	sub    $0x30,%eax
  8014b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8014c0:	7e 3e                	jle    801500 <vprintfmt+0xe9>
  8014c2:	83 fb 39             	cmp    $0x39,%ebx
  8014c5:	7f 39                	jg     801500 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014ca:	eb d5                	jmp    8014a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cf:	83 c0 04             	add    $0x4,%eax
  8014d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d8:	83 e8 04             	sub    $0x4,%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014e0:	eb 1f                	jmp    801501 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e6:	79 83                	jns    80146b <vprintfmt+0x54>
				width = 0;
  8014e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ef:	e9 77 ff ff ff       	jmp    80146b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014fb:	e9 6b ff ff ff       	jmp    80146b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801500:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801501:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801505:	0f 89 60 ff ff ff    	jns    80146b <vprintfmt+0x54>
				width = precision, precision = -1;
  80150b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801511:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801518:	e9 4e ff ff ff       	jmp    80146b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80151d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801520:	e9 46 ff ff ff       	jmp    80146b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	83 c0 04             	add    $0x4,%eax
  80152b:	89 45 14             	mov    %eax,0x14(%ebp)
  80152e:	8b 45 14             	mov    0x14(%ebp),%eax
  801531:	83 e8 04             	sub    $0x4,%eax
  801534:	8b 00                	mov    (%eax),%eax
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	50                   	push   %eax
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	ff d0                	call   *%eax
  801542:	83 c4 10             	add    $0x10,%esp
			break;
  801545:	e9 9b 02 00 00       	jmp    8017e5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80154a:	8b 45 14             	mov    0x14(%ebp),%eax
  80154d:	83 c0 04             	add    $0x4,%eax
  801550:	89 45 14             	mov    %eax,0x14(%ebp)
  801553:	8b 45 14             	mov    0x14(%ebp),%eax
  801556:	83 e8 04             	sub    $0x4,%eax
  801559:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80155b:	85 db                	test   %ebx,%ebx
  80155d:	79 02                	jns    801561 <vprintfmt+0x14a>
				err = -err;
  80155f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801561:	83 fb 64             	cmp    $0x64,%ebx
  801564:	7f 0b                	jg     801571 <vprintfmt+0x15a>
  801566:	8b 34 9d 00 4c 80 00 	mov    0x804c00(,%ebx,4),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 19                	jne    80158a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801571:	53                   	push   %ebx
  801572:	68 a5 4d 80 00       	push   $0x804da5
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 70 02 00 00       	call   8017f2 <printfmt>
  801582:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801585:	e9 5b 02 00 00       	jmp    8017e5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80158a:	56                   	push   %esi
  80158b:	68 ae 4d 80 00       	push   $0x804dae
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 57 02 00 00       	call   8017f2 <printfmt>
  80159b:	83 c4 10             	add    $0x10,%esp
			break;
  80159e:	e9 42 02 00 00       	jmp    8017e5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	83 c0 04             	add    $0x4,%eax
  8015a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8015af:	83 e8 04             	sub    $0x4,%eax
  8015b2:	8b 30                	mov    (%eax),%esi
  8015b4:	85 f6                	test   %esi,%esi
  8015b6:	75 05                	jne    8015bd <vprintfmt+0x1a6>
				p = "(null)";
  8015b8:	be b1 4d 80 00       	mov    $0x804db1,%esi
			if (width > 0 && padc != '-')
  8015bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015c1:	7e 6d                	jle    801630 <vprintfmt+0x219>
  8015c3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015c7:	74 67                	je     801630 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	50                   	push   %eax
  8015d0:	56                   	push   %esi
  8015d1:	e8 1e 03 00 00       	call   8018f4 <strnlen>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015dc:	eb 16                	jmp    8015f4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015de:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	50                   	push   %eax
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	ff d0                	call   *%eax
  8015ee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015f1:	ff 4d e4             	decl   -0x1c(%ebp)
  8015f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f8:	7f e4                	jg     8015de <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015fa:	eb 34                	jmp    801630 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801600:	74 1c                	je     80161e <vprintfmt+0x207>
  801602:	83 fb 1f             	cmp    $0x1f,%ebx
  801605:	7e 05                	jle    80160c <vprintfmt+0x1f5>
  801607:	83 fb 7e             	cmp    $0x7e,%ebx
  80160a:	7e 12                	jle    80161e <vprintfmt+0x207>
					putch('?', putdat);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	6a 3f                	push   $0x3f
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	ff d0                	call   *%eax
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	eb 0f                	jmp    80162d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	53                   	push   %ebx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	ff d0                	call   *%eax
  80162a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80162d:	ff 4d e4             	decl   -0x1c(%ebp)
  801630:	89 f0                	mov    %esi,%eax
  801632:	8d 70 01             	lea    0x1(%eax),%esi
  801635:	8a 00                	mov    (%eax),%al
  801637:	0f be d8             	movsbl %al,%ebx
  80163a:	85 db                	test   %ebx,%ebx
  80163c:	74 24                	je     801662 <vprintfmt+0x24b>
  80163e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801642:	78 b8                	js     8015fc <vprintfmt+0x1e5>
  801644:	ff 4d e0             	decl   -0x20(%ebp)
  801647:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80164b:	79 af                	jns    8015fc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80164d:	eb 13                	jmp    801662 <vprintfmt+0x24b>
				putch(' ', putdat);
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	6a 20                	push   $0x20
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	ff d0                	call   *%eax
  80165c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80165f:	ff 4d e4             	decl   -0x1c(%ebp)
  801662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801666:	7f e7                	jg     80164f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801668:	e9 78 01 00 00       	jmp    8017e5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	ff 75 e8             	pushl  -0x18(%ebp)
  801673:	8d 45 14             	lea    0x14(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	e8 3c fd ff ff       	call   8013b8 <getint>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801682:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168b:	85 d2                	test   %edx,%edx
  80168d:	79 23                	jns    8016b2 <vprintfmt+0x29b>
				putch('-', putdat);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	6a 2d                	push   $0x2d
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	ff d0                	call   *%eax
  80169c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a5:	f7 d8                	neg    %eax
  8016a7:	83 d2 00             	adc    $0x0,%edx
  8016aa:	f7 da                	neg    %edx
  8016ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016b2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016b9:	e9 bc 00 00 00       	jmp    80177a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	e8 84 fc ff ff       	call   801351 <getuint>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016dd:	e9 98 00 00 00       	jmp    80177a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	ff 75 0c             	pushl  0xc(%ebp)
  8016e8:	6a 58                	push   $0x58
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	ff d0                	call   *%eax
  8016ef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	6a 58                	push   $0x58
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	ff d0                	call   *%eax
  8016ff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	6a 58                	push   $0x58
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	ff d0                	call   *%eax
  80170f:	83 c4 10             	add    $0x10,%esp
			break;
  801712:	e9 ce 00 00 00       	jmp    8017e5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	6a 30                	push   $0x30
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	ff d0                	call   *%eax
  801724:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	6a 78                	push   $0x78
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	ff d0                	call   *%eax
  801734:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801737:	8b 45 14             	mov    0x14(%ebp),%eax
  80173a:	83 c0 04             	add    $0x4,%eax
  80173d:	89 45 14             	mov    %eax,0x14(%ebp)
  801740:	8b 45 14             	mov    0x14(%ebp),%eax
  801743:	83 e8 04             	sub    $0x4,%eax
  801746:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801759:	eb 1f                	jmp    80177a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	ff 75 e8             	pushl  -0x18(%ebp)
  801761:	8d 45 14             	lea    0x14(%ebp),%eax
  801764:	50                   	push   %eax
  801765:	e8 e7 fb ff ff       	call   801351 <getuint>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801770:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801773:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80177a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80177e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	52                   	push   %edx
  801785:	ff 75 e4             	pushl  -0x1c(%ebp)
  801788:	50                   	push   %eax
  801789:	ff 75 f4             	pushl  -0xc(%ebp)
  80178c:	ff 75 f0             	pushl  -0x10(%ebp)
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	e8 00 fb ff ff       	call   80129a <printnum>
  80179a:	83 c4 20             	add    $0x20,%esp
			break;
  80179d:	eb 46                	jmp    8017e5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	53                   	push   %ebx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	ff d0                	call   *%eax
  8017ab:	83 c4 10             	add    $0x10,%esp
			break;
  8017ae:	eb 35                	jmp    8017e5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8017b0:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  8017b7:	eb 2c                	jmp    8017e5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8017b9:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  8017c0:	eb 23                	jmp    8017e5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	6a 25                	push   $0x25
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	ff d0                	call   *%eax
  8017cf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017d2:	ff 4d 10             	decl   0x10(%ebp)
  8017d5:	eb 03                	jmp    8017da <vprintfmt+0x3c3>
  8017d7:	ff 4d 10             	decl   0x10(%ebp)
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	48                   	dec    %eax
  8017de:	8a 00                	mov    (%eax),%al
  8017e0:	3c 25                	cmp    $0x25,%al
  8017e2:	75 f3                	jne    8017d7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8017e4:	90                   	nop
		}
	}
  8017e5:	e9 35 fc ff ff       	jmp    80141f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017ea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    

008017f2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8017fb:	83 c0 04             	add    $0x4,%eax
  8017fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	ff 75 f4             	pushl  -0xc(%ebp)
  801807:	50                   	push   %eax
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	e8 04 fc ff ff       	call   801417 <vprintfmt>
  801813:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801816:	90                   	nop
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80181c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181f:	8b 40 08             	mov    0x8(%eax),%eax
  801822:	8d 50 01             	lea    0x1(%eax),%edx
  801825:	8b 45 0c             	mov    0xc(%ebp),%eax
  801828:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	8b 10                	mov    (%eax),%edx
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	8b 40 04             	mov    0x4(%eax),%eax
  801836:	39 c2                	cmp    %eax,%edx
  801838:	73 12                	jae    80184c <sprintputch+0x33>
		*b->buf++ = ch;
  80183a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 48 01             	lea    0x1(%eax),%ecx
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	89 0a                	mov    %ecx,(%edx)
  801847:	8b 55 08             	mov    0x8(%ebp),%edx
  80184a:	88 10                	mov    %dl,(%eax)
}
  80184c:	90                   	nop
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80185b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	01 d0                	add    %edx,%eax
  801866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801869:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801870:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801874:	74 06                	je     80187c <vsnprintf+0x2d>
  801876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80187a:	7f 07                	jg     801883 <vsnprintf+0x34>
		return -E_INVAL;
  80187c:	b8 03 00 00 00       	mov    $0x3,%eax
  801881:	eb 20                	jmp    8018a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801883:	ff 75 14             	pushl  0x14(%ebp)
  801886:	ff 75 10             	pushl  0x10(%ebp)
  801889:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80188c:	50                   	push   %eax
  80188d:	68 19 18 80 00       	push   $0x801819
  801892:	e8 80 fb ff ff       	call   801417 <vprintfmt>
  801897:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80189a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8018ae:	83 c0 04             	add    $0x4,%eax
  8018b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ba:	50                   	push   %eax
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	e8 89 ff ff ff       	call   80184f <vsnprintf>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018de:	eb 06                	jmp    8018e6 <strlen+0x15>
		n++;
  8018e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e3:	ff 45 08             	incl   0x8(%ebp)
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	84 c0                	test   %al,%al
  8018ed:	75 f1                	jne    8018e0 <strlen+0xf>
		n++;
	return n;
  8018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801901:	eb 09                	jmp    80190c <strnlen+0x18>
		n++;
  801903:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801906:	ff 45 08             	incl   0x8(%ebp)
  801909:	ff 4d 0c             	decl   0xc(%ebp)
  80190c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801910:	74 09                	je     80191b <strnlen+0x27>
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	84 c0                	test   %al,%al
  801919:	75 e8                	jne    801903 <strnlen+0xf>
		n++;
	return n;
  80191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80192c:	90                   	nop
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8d 50 01             	lea    0x1(%eax),%edx
  801933:	89 55 08             	mov    %edx,0x8(%ebp)
  801936:	8b 55 0c             	mov    0xc(%ebp),%edx
  801939:	8d 4a 01             	lea    0x1(%edx),%ecx
  80193c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80193f:	8a 12                	mov    (%edx),%dl
  801941:	88 10                	mov    %dl,(%eax)
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	75 e4                	jne    80192d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801949:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80195a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801961:	eb 1f                	jmp    801982 <strncpy+0x34>
		*dst++ = *src;
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8d 50 01             	lea    0x1(%eax),%edx
  801969:	89 55 08             	mov    %edx,0x8(%ebp)
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8a 12                	mov    (%edx),%dl
  801971:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	8a 00                	mov    (%eax),%al
  801978:	84 c0                	test   %al,%al
  80197a:	74 03                	je     80197f <strncpy+0x31>
			src++;
  80197c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80197f:	ff 45 fc             	incl   -0x4(%ebp)
  801982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801985:	3b 45 10             	cmp    0x10(%ebp),%eax
  801988:	72 d9                	jb     801963 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80198a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80199b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80199f:	74 30                	je     8019d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019a1:	eb 16                	jmp    8019b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8d 50 01             	lea    0x1(%eax),%edx
  8019a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019b5:	8a 12                	mov    (%edx),%dl
  8019b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019b9:	ff 4d 10             	decl   0x10(%ebp)
  8019bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c0:	74 09                	je     8019cb <strlcpy+0x3c>
  8019c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	75 d8                	jne    8019a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d7:	29 c2                	sub    %eax,%edx
  8019d9:	89 d0                	mov    %edx,%eax
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019e0:	eb 06                	jmp    8019e8 <strcmp+0xb>
		p++, q++;
  8019e2:	ff 45 08             	incl   0x8(%ebp)
  8019e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	84 c0                	test   %al,%al
  8019ef:	74 0e                	je     8019ff <strcmp+0x22>
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 10                	mov    (%eax),%dl
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	38 c2                	cmp    %al,%dl
  8019fd:	74 e3                	je     8019e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	0f b6 d0             	movzbl %al,%edx
  801a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0a:	8a 00                	mov    (%eax),%al
  801a0c:	0f b6 c0             	movzbl %al,%eax
  801a0f:	29 c2                	sub    %eax,%edx
  801a11:	89 d0                	mov    %edx,%eax
}
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a18:	eb 09                	jmp    801a23 <strncmp+0xe>
		n--, p++, q++;
  801a1a:	ff 4d 10             	decl   0x10(%ebp)
  801a1d:	ff 45 08             	incl   0x8(%ebp)
  801a20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a27:	74 17                	je     801a40 <strncmp+0x2b>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	84 c0                	test   %al,%al
  801a30:	74 0e                	je     801a40 <strncmp+0x2b>
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8a 10                	mov    (%eax),%dl
  801a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	38 c2                	cmp    %al,%dl
  801a3e:	74 da                	je     801a1a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a44:	75 07                	jne    801a4d <strncmp+0x38>
		return 0;
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4b:	eb 14                	jmp    801a61 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8a 00                	mov    (%eax),%al
  801a52:	0f b6 d0             	movzbl %al,%edx
  801a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a58:	8a 00                	mov    (%eax),%al
  801a5a:	0f b6 c0             	movzbl %al,%eax
  801a5d:	29 c2                	sub    %eax,%edx
  801a5f:	89 d0                	mov    %edx,%eax
}
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6f:	eb 12                	jmp    801a83 <strchr+0x20>
		if (*s == c)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a79:	75 05                	jne    801a80 <strchr+0x1d>
			return (char *) s;
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	eb 11                	jmp    801a91 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a80:	ff 45 08             	incl   0x8(%ebp)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8a 00                	mov    (%eax),%al
  801a88:	84 c0                	test   %al,%al
  801a8a:	75 e5                	jne    801a71 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a9f:	eb 0d                	jmp    801aae <strfind+0x1b>
		if (*s == c)
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aa9:	74 0e                	je     801ab9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801aab:	ff 45 08             	incl   0x8(%ebp)
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	75 ea                	jne    801aa1 <strfind+0xe>
  801ab7:	eb 01                	jmp    801aba <strfind+0x27>
		if (*s == c)
			break;
  801ab9:	90                   	nop
	return (char *) s;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801acb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ace:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801ad1:	eb 0e                	jmp    801ae1 <memset+0x22>
		*p++ = c;
  801ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ad6:	8d 50 01             	lea    0x1(%eax),%edx
  801ad9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ae1:	ff 4d f8             	decl   -0x8(%ebp)
  801ae4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ae8:	79 e9                	jns    801ad3 <memset+0x14>
		*p++ = c;

	return v;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b01:	eb 16                	jmp    801b19 <memcpy+0x2a>
		*d++ = *s++;
  801b03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b06:	8d 50 01             	lea    0x1(%eax),%edx
  801b09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b12:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b15:	8a 12                	mov    (%edx),%dl
  801b17:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b1f:	89 55 10             	mov    %edx,0x10(%ebp)
  801b22:	85 c0                	test   %eax,%eax
  801b24:	75 dd                	jne    801b03 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b40:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b43:	73 50                	jae    801b95 <memmove+0x6a>
  801b45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b48:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4b:	01 d0                	add    %edx,%eax
  801b4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b50:	76 43                	jbe    801b95 <memmove+0x6a>
		s += n;
  801b52:	8b 45 10             	mov    0x10(%ebp),%eax
  801b55:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b58:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b5e:	eb 10                	jmp    801b70 <memmove+0x45>
			*--d = *--s;
  801b60:	ff 4d f8             	decl   -0x8(%ebp)
  801b63:	ff 4d fc             	decl   -0x4(%ebp)
  801b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b69:	8a 10                	mov    (%eax),%dl
  801b6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b70:	8b 45 10             	mov    0x10(%ebp),%eax
  801b73:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b76:	89 55 10             	mov    %edx,0x10(%ebp)
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	75 e3                	jne    801b60 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b7d:	eb 23                	jmp    801ba2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b82:	8d 50 01             	lea    0x1(%eax),%edx
  801b85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b8e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b91:	8a 12                	mov    (%edx),%dl
  801b93:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b95:	8b 45 10             	mov    0x10(%ebp),%eax
  801b98:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	75 dd                	jne    801b7f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bb9:	eb 2a                	jmp    801be5 <memcmp+0x3e>
		if (*s1 != *s2)
  801bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbe:	8a 10                	mov    (%eax),%dl
  801bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc3:	8a 00                	mov    (%eax),%al
  801bc5:	38 c2                	cmp    %al,%dl
  801bc7:	74 16                	je     801bdf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bcc:	8a 00                	mov    (%eax),%al
  801bce:	0f b6 d0             	movzbl %al,%edx
  801bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	0f b6 c0             	movzbl %al,%eax
  801bd9:	29 c2                	sub    %eax,%edx
  801bdb:	89 d0                	mov    %edx,%eax
  801bdd:	eb 18                	jmp    801bf7 <memcmp+0x50>
		s1++, s2++;
  801bdf:	ff 45 fc             	incl   -0x4(%ebp)
  801be2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801beb:	89 55 10             	mov    %edx,0x10(%ebp)
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	75 c9                	jne    801bbb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bff:	8b 55 08             	mov    0x8(%ebp),%edx
  801c02:	8b 45 10             	mov    0x10(%ebp),%eax
  801c05:	01 d0                	add    %edx,%eax
  801c07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c0a:	eb 15                	jmp    801c21 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	8a 00                	mov    (%eax),%al
  801c11:	0f b6 d0             	movzbl %al,%edx
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	0f b6 c0             	movzbl %al,%eax
  801c1a:	39 c2                	cmp    %eax,%edx
  801c1c:	74 0d                	je     801c2b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c1e:	ff 45 08             	incl   0x8(%ebp)
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c27:	72 e3                	jb     801c0c <memfind+0x13>
  801c29:	eb 01                	jmp    801c2c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c2b:	90                   	nop
	return (void *) s;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c45:	eb 03                	jmp    801c4a <strtol+0x19>
		s++;
  801c47:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	8a 00                	mov    (%eax),%al
  801c4f:	3c 20                	cmp    $0x20,%al
  801c51:	74 f4                	je     801c47 <strtol+0x16>
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	8a 00                	mov    (%eax),%al
  801c58:	3c 09                	cmp    $0x9,%al
  801c5a:	74 eb                	je     801c47 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	8a 00                	mov    (%eax),%al
  801c61:	3c 2b                	cmp    $0x2b,%al
  801c63:	75 05                	jne    801c6a <strtol+0x39>
		s++;
  801c65:	ff 45 08             	incl   0x8(%ebp)
  801c68:	eb 13                	jmp    801c7d <strtol+0x4c>
	else if (*s == '-')
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3c 2d                	cmp    $0x2d,%al
  801c71:	75 0a                	jne    801c7d <strtol+0x4c>
		s++, neg = 1;
  801c73:	ff 45 08             	incl   0x8(%ebp)
  801c76:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c81:	74 06                	je     801c89 <strtol+0x58>
  801c83:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c87:	75 20                	jne    801ca9 <strtol+0x78>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	3c 30                	cmp    $0x30,%al
  801c90:	75 17                	jne    801ca9 <strtol+0x78>
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	40                   	inc    %eax
  801c96:	8a 00                	mov    (%eax),%al
  801c98:	3c 78                	cmp    $0x78,%al
  801c9a:	75 0d                	jne    801ca9 <strtol+0x78>
		s += 2, base = 16;
  801c9c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801ca0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ca7:	eb 28                	jmp    801cd1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ca9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cad:	75 15                	jne    801cc4 <strtol+0x93>
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8a 00                	mov    (%eax),%al
  801cb4:	3c 30                	cmp    $0x30,%al
  801cb6:	75 0c                	jne    801cc4 <strtol+0x93>
		s++, base = 8;
  801cb8:	ff 45 08             	incl   0x8(%ebp)
  801cbb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cc2:	eb 0d                	jmp    801cd1 <strtol+0xa0>
	else if (base == 0)
  801cc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc8:	75 07                	jne    801cd1 <strtol+0xa0>
		base = 10;
  801cca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	3c 2f                	cmp    $0x2f,%al
  801cd8:	7e 19                	jle    801cf3 <strtol+0xc2>
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	8a 00                	mov    (%eax),%al
  801cdf:	3c 39                	cmp    $0x39,%al
  801ce1:	7f 10                	jg     801cf3 <strtol+0xc2>
			dig = *s - '0';
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	8a 00                	mov    (%eax),%al
  801ce8:	0f be c0             	movsbl %al,%eax
  801ceb:	83 e8 30             	sub    $0x30,%eax
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf1:	eb 42                	jmp    801d35 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	8a 00                	mov    (%eax),%al
  801cf8:	3c 60                	cmp    $0x60,%al
  801cfa:	7e 19                	jle    801d15 <strtol+0xe4>
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	8a 00                	mov    (%eax),%al
  801d01:	3c 7a                	cmp    $0x7a,%al
  801d03:	7f 10                	jg     801d15 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	0f be c0             	movsbl %al,%eax
  801d0d:	83 e8 57             	sub    $0x57,%eax
  801d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d13:	eb 20                	jmp    801d35 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	8a 00                	mov    (%eax),%al
  801d1a:	3c 40                	cmp    $0x40,%al
  801d1c:	7e 39                	jle    801d57 <strtol+0x126>
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	8a 00                	mov    (%eax),%al
  801d23:	3c 5a                	cmp    $0x5a,%al
  801d25:	7f 30                	jg     801d57 <strtol+0x126>
			dig = *s - 'A' + 10;
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	8a 00                	mov    (%eax),%al
  801d2c:	0f be c0             	movsbl %al,%eax
  801d2f:	83 e8 37             	sub    $0x37,%eax
  801d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d3b:	7d 19                	jge    801d56 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d3d:	ff 45 08             	incl   0x8(%ebp)
  801d40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d43:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d47:	89 c2                	mov    %eax,%edx
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d51:	e9 7b ff ff ff       	jmp    801cd1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d56:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d5b:	74 08                	je     801d65 <strtol+0x134>
		*endptr = (char *) s;
  801d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d60:	8b 55 08             	mov    0x8(%ebp),%edx
  801d63:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d65:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d69:	74 07                	je     801d72 <strtol+0x141>
  801d6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6e:	f7 d8                	neg    %eax
  801d70:	eb 03                	jmp    801d75 <strtol+0x144>
  801d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <ltostr>:

void
ltostr(long value, char *str)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d84:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d8f:	79 13                	jns    801da4 <ltostr+0x2d>
	{
		neg = 1;
  801d91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d9e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801da1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801dac:	99                   	cltd   
  801dad:	f7 f9                	idiv   %ecx
  801daf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801db2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db5:	8d 50 01             	lea    0x1(%eax),%edx
  801db8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dbb:	89 c2                	mov    %eax,%edx
  801dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc0:	01 d0                	add    %edx,%eax
  801dc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dc5:	83 c2 30             	add    $0x30,%edx
  801dc8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dd2:	f7 e9                	imul   %ecx
  801dd4:	c1 fa 02             	sar    $0x2,%edx
  801dd7:	89 c8                	mov    %ecx,%eax
  801dd9:	c1 f8 1f             	sar    $0x1f,%eax
  801ddc:	29 c2                	sub    %eax,%edx
  801dde:	89 d0                	mov    %edx,%eax
  801de0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801de3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801de7:	75 bb                	jne    801da4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801de9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df3:	48                   	dec    %eax
  801df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dfb:	74 3d                	je     801e3a <ltostr+0xc3>
		start = 1 ;
  801dfd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e04:	eb 34                	jmp    801e3a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0c:	01 d0                	add    %edx,%eax
  801e0e:	8a 00                	mov    (%eax),%al
  801e10:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	01 c8                	add    %ecx,%eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2d:	01 c2                	add    %eax,%edx
  801e2f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e32:	88 02                	mov    %al,(%edx)
		start++ ;
  801e34:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e37:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e40:	7c c4                	jl     801e06 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e42:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	e8 73 fa ff ff       	call   8018d1 <strlen>
  801e5e:	83 c4 04             	add    $0x4,%esp
  801e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	e8 65 fa ff ff       	call   8018d1 <strlen>
  801e6c:	83 c4 04             	add    $0x4,%esp
  801e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e80:	eb 17                	jmp    801e99 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e85:	8b 45 10             	mov    0x10(%ebp),%eax
  801e88:	01 c2                	add    %eax,%edx
  801e8a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	01 c8                	add    %ecx,%eax
  801e92:	8a 00                	mov    (%eax),%al
  801e94:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e96:	ff 45 fc             	incl   -0x4(%ebp)
  801e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e9f:	7c e1                	jl     801e82 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ea1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ea8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801eaf:	eb 1f                	jmp    801ed0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb4:	8d 50 01             	lea    0x1(%eax),%edx
  801eb7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801eba:	89 c2                	mov    %eax,%edx
  801ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebf:	01 c2                	add    %eax,%edx
  801ec1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec7:	01 c8                	add    %ecx,%eax
  801ec9:	8a 00                	mov    (%eax),%al
  801ecb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ecd:	ff 45 f8             	incl   -0x8(%ebp)
  801ed0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ed6:	7c d9                	jl     801eb1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ed8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801edb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ede:	01 d0                	add    %edx,%eax
  801ee0:	c6 00 00             	movb   $0x0,(%eax)
}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  801eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801efe:	8b 45 10             	mov    0x10(%ebp),%eax
  801f01:	01 d0                	add    %edx,%eax
  801f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f09:	eb 0c                	jmp    801f17 <strsplit+0x31>
			*string++ = 0;
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8d 50 01             	lea    0x1(%eax),%edx
  801f11:	89 55 08             	mov    %edx,0x8(%ebp)
  801f14:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	8a 00                	mov    (%eax),%al
  801f1c:	84 c0                	test   %al,%al
  801f1e:	74 18                	je     801f38 <strsplit+0x52>
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8a 00                	mov    (%eax),%al
  801f25:	0f be c0             	movsbl %al,%eax
  801f28:	50                   	push   %eax
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	e8 32 fb ff ff       	call   801a63 <strchr>
  801f31:	83 c4 08             	add    $0x8,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	75 d3                	jne    801f0b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	8a 00                	mov    (%eax),%al
  801f3d:	84 c0                	test   %al,%al
  801f3f:	74 5a                	je     801f9b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f41:	8b 45 14             	mov    0x14(%ebp),%eax
  801f44:	8b 00                	mov    (%eax),%eax
  801f46:	83 f8 0f             	cmp    $0xf,%eax
  801f49:	75 07                	jne    801f52 <strsplit+0x6c>
		{
			return 0;
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f50:	eb 66                	jmp    801fb8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f52:	8b 45 14             	mov    0x14(%ebp),%eax
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	8d 48 01             	lea    0x1(%eax),%ecx
  801f5a:	8b 55 14             	mov    0x14(%ebp),%edx
  801f5d:	89 0a                	mov    %ecx,(%edx)
  801f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f66:	8b 45 10             	mov    0x10(%ebp),%eax
  801f69:	01 c2                	add    %eax,%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f70:	eb 03                	jmp    801f75 <strsplit+0x8f>
			string++;
  801f72:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8a 00                	mov    (%eax),%al
  801f7a:	84 c0                	test   %al,%al
  801f7c:	74 8b                	je     801f09 <strsplit+0x23>
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8a 00                	mov    (%eax),%al
  801f83:	0f be c0             	movsbl %al,%eax
  801f86:	50                   	push   %eax
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	e8 d4 fa ff ff       	call   801a63 <strchr>
  801f8f:	83 c4 08             	add    $0x8,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	74 dc                	je     801f72 <strsplit+0x8c>
			string++;
	}
  801f96:	e9 6e ff ff ff       	jmp    801f09 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f9b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9f:	8b 00                	mov    (%eax),%eax
  801fa1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fab:	01 d0                	add    %edx,%eax
  801fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fb3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	68 28 4f 80 00       	push   $0x804f28
  801fc8:	68 3f 01 00 00       	push   $0x13f
  801fcd:	68 4a 4f 80 00       	push   $0x804f4a
  801fd2:	e8 a9 ef ff ff       	call   800f80 <_panic>

00801fd7 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 e7 0a 00 00       	call   802acf <sys_sbrk>
  801fe8:	83 c4 10             	add    $0x10,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff7:	75 0a                	jne    802003 <malloc+0x16>
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	e9 07 02 00 00       	jmp    80220a <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  802003:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80200a:	8b 55 08             	mov    0x8(%ebp),%edx
  80200d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802010:	01 d0                	add    %edx,%eax
  802012:	48                   	dec    %eax
  802013:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802016:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	f7 75 dc             	divl   -0x24(%ebp)
  802021:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802024:	29 d0                	sub    %edx,%eax
  802026:	c1 e8 0c             	shr    $0xc,%eax
  802029:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80202c:	a1 20 60 80 00       	mov    0x806020,%eax
  802031:	8b 40 78             	mov    0x78(%eax),%eax
  802034:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802039:	29 c2                	sub    %eax,%edx
  80203b:	89 d0                	mov    %edx,%eax
  80203d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802040:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802043:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802048:	c1 e8 0c             	shr    $0xc,%eax
  80204b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80204e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802055:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80205c:	77 42                	ja     8020a0 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80205e:	e8 f0 08 00 00       	call   802953 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 16                	je     80207d <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 30 0e 00 00       	call   802ea2 <alloc_block_FF>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	e9 8a 01 00 00       	jmp    802207 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80207d:	e8 02 09 00 00       	call   802984 <sys_isUHeapPlacementStrategyBESTFIT>
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 84 7d 01 00 00    	je     802207 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 c9 12 00 00       	call   80335e <alloc_block_BF>
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209b:	e9 67 01 00 00       	jmp    802207 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8020a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020a3:	48                   	dec    %eax
  8020a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8020a7:	0f 86 53 01 00 00    	jbe    802200 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8020ad:	a1 20 60 80 00       	mov    0x806020,%eax
  8020b2:	8b 40 78             	mov    0x78(%eax),%eax
  8020b5:	05 00 10 00 00       	add    $0x1000,%eax
  8020ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8020bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8020c4:	e9 de 00 00 00       	jmp    8021a7 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8020c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8020ce:	8b 40 78             	mov    0x78(%eax),%eax
  8020d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d4:	29 c2                	sub    %eax,%edx
  8020d6:	89 d0                	mov    %edx,%eax
  8020d8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020dd:	c1 e8 0c             	shr    $0xc,%eax
  8020e0:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 85 ab 00 00 00    	jne    80219a <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	05 00 10 00 00       	add    $0x1000,%eax
  8020f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8020fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  802101:	eb 47                	jmp    80214a <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  802103:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80210a:	76 0a                	jbe    802116 <malloc+0x129>
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	e9 f4 00 00 00       	jmp    80220a <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  802116:	a1 20 60 80 00       	mov    0x806020,%eax
  80211b:	8b 40 78             	mov    0x78(%eax),%eax
  80211e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802121:	29 c2                	sub    %eax,%edx
  802123:	89 d0                	mov    %edx,%eax
  802125:	2d 00 10 00 00       	sub    $0x1000,%eax
  80212a:	c1 e8 0c             	shr    $0xc,%eax
  80212d:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 08                	je     802140 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  802138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80213e:	eb 5a                	jmp    80219a <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802140:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  802147:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80214a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80214d:	48                   	dec    %eax
  80214e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802151:	77 b0                	ja     802103 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  802153:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80215a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802161:	eb 2f                	jmp    802192 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  802163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802166:	c1 e0 0c             	shl    $0xc,%eax
  802169:	89 c2                	mov    %eax,%edx
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	01 c2                	add    %eax,%edx
  802170:	a1 20 60 80 00       	mov    0x806020,%eax
  802175:	8b 40 78             	mov    0x78(%eax),%eax
  802178:	29 c2                	sub    %eax,%edx
  80217a:	89 d0                	mov    %edx,%eax
  80217c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802181:	c1 e8 0c             	shr    $0xc,%eax
  802184:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
  80218b:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80218f:	ff 45 e0             	incl   -0x20(%ebp)
  802192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802195:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802198:	72 c9                	jb     802163 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80219a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219e:	75 16                	jne    8021b6 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8021a0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8021a7:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8021ae:	0f 86 15 ff ff ff    	jbe    8020c9 <malloc+0xdc>
  8021b4:	eb 01                	jmp    8021b7 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8021b6:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8021b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021bb:	75 07                	jne    8021c4 <malloc+0x1d7>
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	eb 46                	jmp    80220a <malloc+0x21d>
		ptr = (void*)i;
  8021c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8021ca:	a1 20 60 80 00       	mov    0x806020,%eax
  8021cf:	8b 40 78             	mov    0x78(%eax),%eax
  8021d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d5:	29 c2                	sub    %eax,%edx
  8021d7:	89 d0                	mov    %edx,%eax
  8021d9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021de:	c1 e8 0c             	shr    $0xc,%eax
  8021e1:	89 c2                	mov    %eax,%edx
  8021e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e6:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8021ed:	83 ec 08             	sub    $0x8,%esp
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f6:	e8 0b 09 00 00       	call   802b06 <sys_allocate_user_mem>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	eb 07                	jmp    802207 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	eb 03                	jmp    80220a <malloc+0x21d>
	}
	return ptr;
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  802212:	a1 20 60 80 00       	mov    0x806020,%eax
  802217:	8b 40 78             	mov    0x78(%eax),%eax
  80221a:	05 00 10 00 00       	add    $0x1000,%eax
  80221f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  802222:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  802229:	a1 20 60 80 00       	mov    0x806020,%eax
  80222e:	8b 50 78             	mov    0x78(%eax),%edx
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	76 24                	jbe    80225c <free+0x50>
		size = get_block_size(va);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	ff 75 08             	pushl  0x8(%ebp)
  80223e:	e8 df 08 00 00       	call   802b22 <get_block_size>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	e8 12 1b 00 00       	call   803d66 <free_block>
  802254:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802257:	e9 ac 00 00 00       	jmp    802308 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802262:	0f 82 89 00 00 00    	jb     8022f1 <free+0xe5>
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802270:	77 7f                	ja     8022f1 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	a1 20 60 80 00       	mov    0x806020,%eax
  80227a:	8b 40 78             	mov    0x78(%eax),%eax
  80227d:	29 c2                	sub    %eax,%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	2d 00 10 00 00       	sub    $0x1000,%eax
  802286:	c1 e8 0c             	shr    $0xc,%eax
  802289:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  802290:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802296:	c1 e0 0c             	shl    $0xc,%eax
  802299:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80229c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022a3:	eb 2f                	jmp    8022d4 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	c1 e0 0c             	shl    $0xc,%eax
  8022ab:	89 c2                	mov    %eax,%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	01 c2                	add    %eax,%edx
  8022b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8022b7:	8b 40 78             	mov    0x78(%eax),%eax
  8022ba:	29 c2                	sub    %eax,%edx
  8022bc:	89 d0                	mov    %edx,%eax
  8022be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8022c3:	c1 e8 0c             	shr    $0xc,%eax
  8022c6:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  8022cd:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8022d1:	ff 45 f4             	incl   -0xc(%ebp)
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022da:	72 c9                	jb     8022a5 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	83 ec 08             	sub    $0x8,%esp
  8022e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8022e5:	50                   	push   %eax
  8022e6:	e8 ff 07 00 00       	call   802aea <sys_free_user_mem>
  8022eb:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8022ee:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8022ef:	eb 17                	jmp    802308 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	68 58 4f 80 00       	push   $0x804f58
  8022f9:	68 85 00 00 00       	push   $0x85
  8022fe:	68 82 4f 80 00       	push   $0x804f82
  802303:	e8 78 ec ff ff       	call   800f80 <_panic>
	}
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 28             	sub    $0x28,%esp
  802310:	8b 45 10             	mov    0x10(%ebp),%eax
  802313:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80231a:	75 0a                	jne    802326 <smalloc+0x1c>
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	e9 9a 00 00 00       	jmp    8023c0 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802326:	8b 45 0c             	mov    0xc(%ebp),%eax
  802329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802333:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	39 d0                	cmp    %edx,%eax
  80233b:	73 02                	jae    80233f <smalloc+0x35>
  80233d:	89 d0                	mov    %edx,%eax
  80233f:	83 ec 0c             	sub    $0xc,%esp
  802342:	50                   	push   %eax
  802343:	e8 a5 fc ff ff       	call   801fed <malloc>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80234e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802352:	75 07                	jne    80235b <smalloc+0x51>
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	eb 65                	jmp    8023c0 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80235b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80235f:	ff 75 ec             	pushl  -0x14(%ebp)
  802362:	50                   	push   %eax
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	ff 75 08             	pushl  0x8(%ebp)
  802369:	e8 83 03 00 00       	call   8026f1 <sys_createSharedObject>
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802374:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802378:	74 06                	je     802380 <smalloc+0x76>
  80237a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80237e:	75 07                	jne    802387 <smalloc+0x7d>
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	eb 39                	jmp    8023c0 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  802387:	83 ec 08             	sub    $0x8,%esp
  80238a:	ff 75 ec             	pushl  -0x14(%ebp)
  80238d:	68 8e 4f 80 00       	push   $0x804f8e
  802392:	e8 a6 ee ff ff       	call   80123d <cprintf>
  802397:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80239a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80239d:	a1 20 60 80 00       	mov    0x806020,%eax
  8023a2:	8b 40 78             	mov    0x78(%eax),%eax
  8023a5:	29 c2                	sub    %eax,%edx
  8023a7:	89 d0                	mov    %edx,%eax
  8023a9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023ae:	c1 e8 0c             	shr    $0xc,%eax
  8023b1:	89 c2                	mov    %eax,%edx
  8023b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b6:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8023bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8023c8:	83 ec 08             	sub    $0x8,%esp
  8023cb:	ff 75 0c             	pushl  0xc(%ebp)
  8023ce:	ff 75 08             	pushl  0x8(%ebp)
  8023d1:	e8 45 03 00 00       	call   80271b <sys_getSizeOfSharedObject>
  8023d6:	83 c4 10             	add    $0x10,%esp
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8023dc:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8023e0:	75 07                	jne    8023e9 <sget+0x27>
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e7:	eb 5c                	jmp    802445 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	39 d0                	cmp    %edx,%eax
  8023fe:	7d 02                	jge    802402 <sget+0x40>
  802400:	89 d0                	mov    %edx,%eax
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	50                   	push   %eax
  802406:	e8 e2 fb ff ff       	call   801fed <malloc>
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802411:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802415:	75 07                	jne    80241e <sget+0x5c>
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	eb 27                	jmp    802445 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	ff 75 e8             	pushl  -0x18(%ebp)
  802424:	ff 75 0c             	pushl  0xc(%ebp)
  802427:	ff 75 08             	pushl  0x8(%ebp)
  80242a:	e8 09 03 00 00       	call   802738 <sys_getSharedObject>
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802435:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802439:	75 07                	jne    802442 <sget+0x80>
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
  802440:	eb 03                	jmp    802445 <sget+0x83>
	return ptr;
  802442:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80244d:	8b 55 08             	mov    0x8(%ebp),%edx
  802450:	a1 20 60 80 00       	mov    0x806020,%eax
  802455:	8b 40 78             	mov    0x78(%eax),%eax
  802458:	29 c2                	sub    %eax,%edx
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802461:	c1 e8 0c             	shr    $0xc,%eax
  802464:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80246b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80246e:	83 ec 08             	sub    $0x8,%esp
  802471:	ff 75 08             	pushl  0x8(%ebp)
  802474:	ff 75 f4             	pushl  -0xc(%ebp)
  802477:	e8 db 02 00 00       	call   802757 <sys_freeSharedObject>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	68 a0 4f 80 00       	push   $0x804fa0
  802493:	68 dd 00 00 00       	push   $0xdd
  802498:	68 82 4f 80 00       	push   $0x804f82
  80249d:	e8 de ea ff ff       	call   800f80 <_panic>

008024a2 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	68 c6 4f 80 00       	push   $0x804fc6
  8024b0:	68 e9 00 00 00       	push   $0xe9
  8024b5:	68 82 4f 80 00       	push   $0x804f82
  8024ba:	e8 c1 ea ff ff       	call   800f80 <_panic>

008024bf <shrink>:

}
void shrink(uint32 newSize)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 c6 4f 80 00       	push   $0x804fc6
  8024cd:	68 ee 00 00 00       	push   $0xee
  8024d2:	68 82 4f 80 00       	push   $0x804f82
  8024d7:	e8 a4 ea ff ff       	call   800f80 <_panic>

008024dc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 c6 4f 80 00       	push   $0x804fc6
  8024ea:	68 f3 00 00 00       	push   $0xf3
  8024ef:	68 82 4f 80 00       	push   $0x804f82
  8024f4:	e8 87 ea ff ff       	call   800f80 <_panic>

008024f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	57                   	push   %edi
  8024fd:	56                   	push   %esi
  8024fe:	53                   	push   %ebx
  8024ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	8b 55 0c             	mov    0xc(%ebp),%edx
  802508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80250b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802511:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802514:	cd 30                	int    $0x30
  802516:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    

00802524 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	8b 45 10             	mov    0x10(%ebp),%eax
  80252d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802530:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	52                   	push   %edx
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	50                   	push   %eax
  802540:	6a 00                	push   $0x0
  802542:	e8 b2 ff ff ff       	call   8024f9 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
}
  80254a:	90                   	nop
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_cgetc>:

int
sys_cgetc(void)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 02                	push   $0x2
  80255c:	e8 98 ff ff ff       	call   8024f9 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 03                	push   $0x3
  802575:	e8 7f ff ff ff       	call   8024f9 <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
}
  80257d:	90                   	nop
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 04                	push   $0x4
  80258f:	e8 65 ff ff ff       	call   8024f9 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	90                   	nop
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80259d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	52                   	push   %edx
  8025aa:	50                   	push   %eax
  8025ab:	6a 08                	push   $0x8
  8025ad:	e8 47 ff ff ff       	call   8024f9 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	56                   	push   %esi
  8025bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8025bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	56                   	push   %esi
  8025cc:	53                   	push   %ebx
  8025cd:	51                   	push   %ecx
  8025ce:	52                   	push   %edx
  8025cf:	50                   	push   %eax
  8025d0:	6a 09                	push   $0x9
  8025d2:	e8 22 ff ff ff       	call   8024f9 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    

008025e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8025e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	52                   	push   %edx
  8025f1:	50                   	push   %eax
  8025f2:	6a 0a                	push   $0xa
  8025f4:	e8 00 ff ff ff       	call   8024f9 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	ff 75 0c             	pushl  0xc(%ebp)
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	6a 0b                	push   $0xb
  80260f:	e8 e5 fe ff ff       	call   8024f9 <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 0c                	push   $0xc
  802628:	e8 cc fe ff ff       	call   8024f9 <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 0d                	push   $0xd
  802641:	e8 b3 fe ff ff       	call   8024f9 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 0e                	push   $0xe
  80265a:	e8 9a fe ff ff       	call   8024f9 <syscall>
  80265f:	83 c4 18             	add    $0x18,%esp
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 0f                	push   $0xf
  802673:	e8 81 fe ff ff       	call   8024f9 <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 10                	push   $0x10
  80268d:	e8 67 fe ff ff       	call   8024f9 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 11                	push   $0x11
  8026a6:	e8 4e fe ff ff       	call   8024f9 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	90                   	nop
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	50                   	push   %eax
  8026ca:	6a 01                	push   $0x1
  8026cc:	e8 28 fe ff ff       	call   8024f9 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	90                   	nop
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 14                	push   $0x14
  8026e6:	e8 0e fe ff ff       	call   8024f9 <syscall>
  8026eb:	83 c4 18             	add    $0x18,%esp
}
  8026ee:	90                   	nop
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802700:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	6a 00                	push   $0x0
  802709:	51                   	push   %ecx
  80270a:	52                   	push   %edx
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	50                   	push   %eax
  80270f:	6a 15                	push   $0x15
  802711:	e8 e3 fd ff ff       	call   8024f9 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80271e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	52                   	push   %edx
  80272b:	50                   	push   %eax
  80272c:	6a 16                	push   $0x16
  80272e:	e8 c6 fd ff ff       	call   8024f9 <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80273b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80273e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	51                   	push   %ecx
  802749:	52                   	push   %edx
  80274a:	50                   	push   %eax
  80274b:	6a 17                	push   $0x17
  80274d:	e8 a7 fd ff ff       	call   8024f9 <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80275a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	52                   	push   %edx
  802767:	50                   	push   %eax
  802768:	6a 18                	push   $0x18
  80276a:	e8 8a fd ff ff       	call   8024f9 <syscall>
  80276f:	83 c4 18             	add    $0x18,%esp
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	6a 00                	push   $0x0
  80277c:	ff 75 14             	pushl  0x14(%ebp)
  80277f:	ff 75 10             	pushl  0x10(%ebp)
  802782:	ff 75 0c             	pushl  0xc(%ebp)
  802785:	50                   	push   %eax
  802786:	6a 19                	push   $0x19
  802788:	e8 6c fd ff ff       	call   8024f9 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	50                   	push   %eax
  8027a1:	6a 1a                	push   $0x1a
  8027a3:	e8 51 fd ff ff       	call   8024f9 <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
}
  8027ab:	90                   	nop
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	50                   	push   %eax
  8027bd:	6a 1b                	push   $0x1b
  8027bf:	e8 35 fd ff ff       	call   8024f9 <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 05                	push   $0x5
  8027d8:	e8 1c fd ff ff       	call   8024f9 <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 06                	push   $0x6
  8027f1:	e8 03 fd ff ff       	call   8024f9 <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 07                	push   $0x7
  80280a:	e8 ea fc ff ff       	call   8024f9 <syscall>
  80280f:	83 c4 18             	add    $0x18,%esp
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <sys_exit_env>:


void sys_exit_env(void)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 1c                	push   $0x1c
  802823:	e8 d1 fc ff ff       	call   8024f9 <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
}
  80282b:	90                   	nop
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802834:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802837:	8d 50 04             	lea    0x4(%eax),%edx
  80283a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	52                   	push   %edx
  802844:	50                   	push   %eax
  802845:	6a 1d                	push   $0x1d
  802847:	e8 ad fc ff ff       	call   8024f9 <syscall>
  80284c:	83 c4 18             	add    $0x18,%esp
	return result;
  80284f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802852:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802855:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802858:	89 01                	mov    %eax,(%ecx)
  80285a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	c9                   	leave  
  802861:	c2 04 00             	ret    $0x4

00802864 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	ff 75 10             	pushl  0x10(%ebp)
  80286e:	ff 75 0c             	pushl  0xc(%ebp)
  802871:	ff 75 08             	pushl  0x8(%ebp)
  802874:	6a 13                	push   $0x13
  802876:	e8 7e fc ff ff       	call   8024f9 <syscall>
  80287b:	83 c4 18             	add    $0x18,%esp
	return ;
  80287e:	90                   	nop
}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <sys_rcr2>:
uint32 sys_rcr2()
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 1e                	push   $0x1e
  802890:	e8 64 fc ff ff       	call   8024f9 <syscall>
  802895:	83 c4 18             	add    $0x18,%esp
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	50                   	push   %eax
  8028b3:	6a 1f                	push   $0x1f
  8028b5:	e8 3f fc ff ff       	call   8024f9 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8028bd:	90                   	nop
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <rsttst>:
void rsttst()
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 21                	push   $0x21
  8028cf:	e8 25 fc ff ff       	call   8024f9 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d7:	90                   	nop
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8028e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028ed:	52                   	push   %edx
  8028ee:	50                   	push   %eax
  8028ef:	ff 75 10             	pushl  0x10(%ebp)
  8028f2:	ff 75 0c             	pushl  0xc(%ebp)
  8028f5:	ff 75 08             	pushl  0x8(%ebp)
  8028f8:	6a 20                	push   $0x20
  8028fa:	e8 fa fb ff ff       	call   8024f9 <syscall>
  8028ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802902:	90                   	nop
}
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <chktst>:
void chktst(uint32 n)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	ff 75 08             	pushl  0x8(%ebp)
  802913:	6a 22                	push   $0x22
  802915:	e8 df fb ff ff       	call   8024f9 <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
	return ;
  80291d:	90                   	nop
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <inctst>:

void inctst()
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 23                	push   $0x23
  80292f:	e8 c5 fb ff ff       	call   8024f9 <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
	return ;
  802937:	90                   	nop
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <gettst>:
uint32 gettst()
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	6a 24                	push   $0x24
  802949:	e8 ab fb ff ff       	call   8024f9 <syscall>
  80294e:	83 c4 18             	add    $0x18,%esp
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
  802956:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 25                	push   $0x25
  802965:	e8 8f fb ff ff       	call   8024f9 <syscall>
  80296a:	83 c4 18             	add    $0x18,%esp
  80296d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802970:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802974:	75 07                	jne    80297d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802976:	b8 01 00 00 00       	mov    $0x1,%eax
  80297b:	eb 05                	jmp    802982 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 25                	push   $0x25
  802996:	e8 5e fb ff ff       	call   8024f9 <syscall>
  80299b:	83 c4 18             	add    $0x18,%esp
  80299e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029a1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029a5:	75 07                	jne    8029ae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ac:	eb 05                	jmp    8029b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 25                	push   $0x25
  8029c7:	e8 2d fb ff ff       	call   8024f9 <syscall>
  8029cc:	83 c4 18             	add    $0x18,%esp
  8029cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029d2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029d6:	75 07                	jne    8029df <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8029dd:	eb 05                	jmp    8029e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 25                	push   $0x25
  8029f8:	e8 fc fa ff ff       	call   8024f9 <syscall>
  8029fd:	83 c4 18             	add    $0x18,%esp
  802a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a03:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a07:	75 07                	jne    802a10 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a09:	b8 01 00 00 00       	mov    $0x1,%eax
  802a0e:	eb 05                	jmp    802a15 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	ff 75 08             	pushl  0x8(%ebp)
  802a25:	6a 26                	push   $0x26
  802a27:	e8 cd fa ff ff       	call   8024f9 <syscall>
  802a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  802a2f:	90                   	nop
}
  802a30:	c9                   	leave  
  802a31:	c3                   	ret    

00802a32 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	6a 00                	push   $0x0
  802a44:	53                   	push   %ebx
  802a45:	51                   	push   %ecx
  802a46:	52                   	push   %edx
  802a47:	50                   	push   %eax
  802a48:	6a 27                	push   $0x27
  802a4a:	e8 aa fa ff ff       	call   8024f9 <syscall>
  802a4f:	83 c4 18             	add    $0x18,%esp
}
  802a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	52                   	push   %edx
  802a67:	50                   	push   %eax
  802a68:	6a 28                	push   $0x28
  802a6a:	e8 8a fa ff ff       	call   8024f9 <syscall>
  802a6f:	83 c4 18             	add    $0x18,%esp
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802a77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	6a 00                	push   $0x0
  802a82:	51                   	push   %ecx
  802a83:	ff 75 10             	pushl  0x10(%ebp)
  802a86:	52                   	push   %edx
  802a87:	50                   	push   %eax
  802a88:	6a 29                	push   $0x29
  802a8a:	e8 6a fa ff ff       	call   8024f9 <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
}
  802a92:	c9                   	leave  
  802a93:	c3                   	ret    

00802a94 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	ff 75 10             	pushl  0x10(%ebp)
  802a9e:	ff 75 0c             	pushl  0xc(%ebp)
  802aa1:	ff 75 08             	pushl  0x8(%ebp)
  802aa4:	6a 12                	push   $0x12
  802aa6:	e8 4e fa ff ff       	call   8024f9 <syscall>
  802aab:	83 c4 18             	add    $0x18,%esp
	return ;
  802aae:	90                   	nop
}
  802aaf:	c9                   	leave  
  802ab0:	c3                   	ret    

00802ab1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	6a 00                	push   $0x0
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	52                   	push   %edx
  802ac1:	50                   	push   %eax
  802ac2:	6a 2a                	push   $0x2a
  802ac4:	e8 30 fa ff ff       	call   8024f9 <syscall>
  802ac9:	83 c4 18             	add    $0x18,%esp
	return;
  802acc:	90                   	nop
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	50                   	push   %eax
  802ade:	6a 2b                	push   $0x2b
  802ae0:	e8 14 fa ff ff       	call   8024f9 <syscall>
  802ae5:	83 c4 18             	add    $0x18,%esp
}
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    

00802aea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802aed:	6a 00                	push   $0x0
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	ff 75 0c             	pushl  0xc(%ebp)
  802af6:	ff 75 08             	pushl  0x8(%ebp)
  802af9:	6a 2c                	push   $0x2c
  802afb:	e8 f9 f9 ff ff       	call   8024f9 <syscall>
  802b00:	83 c4 18             	add    $0x18,%esp
	return;
  802b03:	90                   	nop
}
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	ff 75 0c             	pushl  0xc(%ebp)
  802b12:	ff 75 08             	pushl  0x8(%ebp)
  802b15:	6a 2d                	push   $0x2d
  802b17:	e8 dd f9 ff ff       	call   8024f9 <syscall>
  802b1c:	83 c4 18             	add    $0x18,%esp
	return;
  802b1f:	90                   	nop
}
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
  802b25:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	83 e8 04             	sub    $0x4,%eax
  802b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	83 e8 04             	sub    $0x4,%eax
  802b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	83 e0 01             	and    $0x1,%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	0f 94 c0             	sete   %al
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
  802b5c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b69:	83 f8 02             	cmp    $0x2,%eax
  802b6c:	74 2b                	je     802b99 <alloc_block+0x40>
  802b6e:	83 f8 02             	cmp    $0x2,%eax
  802b71:	7f 07                	jg     802b7a <alloc_block+0x21>
  802b73:	83 f8 01             	cmp    $0x1,%eax
  802b76:	74 0e                	je     802b86 <alloc_block+0x2d>
  802b78:	eb 58                	jmp    802bd2 <alloc_block+0x79>
  802b7a:	83 f8 03             	cmp    $0x3,%eax
  802b7d:	74 2d                	je     802bac <alloc_block+0x53>
  802b7f:	83 f8 04             	cmp    $0x4,%eax
  802b82:	74 3b                	je     802bbf <alloc_block+0x66>
  802b84:	eb 4c                	jmp    802bd2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	ff 75 08             	pushl  0x8(%ebp)
  802b8c:	e8 11 03 00 00       	call   802ea2 <alloc_block_FF>
  802b91:	83 c4 10             	add    $0x10,%esp
  802b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b97:	eb 4a                	jmp    802be3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802b99:	83 ec 0c             	sub    $0xc,%esp
  802b9c:	ff 75 08             	pushl  0x8(%ebp)
  802b9f:	e8 fa 19 00 00       	call   80459e <alloc_block_NF>
  802ba4:	83 c4 10             	add    $0x10,%esp
  802ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802baa:	eb 37                	jmp    802be3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802bac:	83 ec 0c             	sub    $0xc,%esp
  802baf:	ff 75 08             	pushl  0x8(%ebp)
  802bb2:	e8 a7 07 00 00       	call   80335e <alloc_block_BF>
  802bb7:	83 c4 10             	add    $0x10,%esp
  802bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802bbd:	eb 24                	jmp    802be3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802bbf:	83 ec 0c             	sub    $0xc,%esp
  802bc2:	ff 75 08             	pushl  0x8(%ebp)
  802bc5:	e8 b7 19 00 00       	call   804581 <alloc_block_WF>
  802bca:	83 c4 10             	add    $0x10,%esp
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802bd0:	eb 11                	jmp    802be3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802bd2:	83 ec 0c             	sub    $0xc,%esp
  802bd5:	68 d8 4f 80 00       	push   $0x804fd8
  802bda:	e8 5e e6 ff ff       	call   80123d <cprintf>
  802bdf:	83 c4 10             	add    $0x10,%esp
		break;
  802be2:	90                   	nop
	}
	return va;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802be6:	c9                   	leave  
  802be7:	c3                   	ret    

00802be8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
  802beb:	53                   	push   %ebx
  802bec:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802bef:	83 ec 0c             	sub    $0xc,%esp
  802bf2:	68 f8 4f 80 00       	push   $0x804ff8
  802bf7:	e8 41 e6 ff ff       	call   80123d <cprintf>
  802bfc:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802bff:	83 ec 0c             	sub    $0xc,%esp
  802c02:	68 23 50 80 00       	push   $0x805023
  802c07:	e8 31 e6 ff ff       	call   80123d <cprintf>
  802c0c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c15:	eb 37                	jmp    802c4e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802c17:	83 ec 0c             	sub    $0xc,%esp
  802c1a:	ff 75 f4             	pushl  -0xc(%ebp)
  802c1d:	e8 19 ff ff ff       	call   802b3b <is_free_block>
  802c22:	83 c4 10             	add    $0x10,%esp
  802c25:	0f be d8             	movsbl %al,%ebx
  802c28:	83 ec 0c             	sub    $0xc,%esp
  802c2b:	ff 75 f4             	pushl  -0xc(%ebp)
  802c2e:	e8 ef fe ff ff       	call   802b22 <get_block_size>
  802c33:	83 c4 10             	add    $0x10,%esp
  802c36:	83 ec 04             	sub    $0x4,%esp
  802c39:	53                   	push   %ebx
  802c3a:	50                   	push   %eax
  802c3b:	68 3b 50 80 00       	push   $0x80503b
  802c40:	e8 f8 e5 ff ff       	call   80123d <cprintf>
  802c45:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802c48:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c52:	74 07                	je     802c5b <print_blocks_list+0x73>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	eb 05                	jmp    802c60 <print_blocks_list+0x78>
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	89 45 10             	mov    %eax,0x10(%ebp)
  802c63:	8b 45 10             	mov    0x10(%ebp),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	75 ad                	jne    802c17 <print_blocks_list+0x2f>
  802c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6e:	75 a7                	jne    802c17 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802c70:	83 ec 0c             	sub    $0xc,%esp
  802c73:	68 f8 4f 80 00       	push   $0x804ff8
  802c78:	e8 c0 e5 ff ff       	call   80123d <cprintf>
  802c7d:	83 c4 10             	add    $0x10,%esp

}
  802c80:	90                   	nop
  802c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8f:	83 e0 01             	and    $0x1,%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 03                	je     802c99 <initialize_dynamic_allocator+0x13>
  802c96:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c9d:	0f 84 c7 01 00 00    	je     802e6a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802ca3:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802caa:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802cad:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb3:	01 d0                	add    %edx,%eax
  802cb5:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802cba:	0f 87 ad 01 00 00    	ja     802e6d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	0f 89 a5 01 00 00    	jns    802e70 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd1:	01 d0                	add    %edx,%eax
  802cd3:	83 e8 04             	sub    $0x4,%eax
  802cd6:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802ce2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cea:	e9 87 00 00 00       	jmp    802d76 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	75 14                	jne    802d09 <initialize_dynamic_allocator+0x83>
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	68 53 50 80 00       	push   $0x805053
  802cfd:	6a 79                	push   $0x79
  802cff:	68 71 50 80 00       	push   $0x805071
  802d04:	e8 77 e2 ff ff       	call   800f80 <_panic>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 10                	je     802d22 <initialize_dynamic_allocator+0x9c>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1a:	8b 52 04             	mov    0x4(%edx),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	eb 0b                	jmp    802d2d <initialize_dynamic_allocator+0xa7>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	a3 30 60 80 00       	mov    %eax,0x806030
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0f                	je     802d46 <initialize_dynamic_allocator+0xc0>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d40:	8b 12                	mov    (%edx),%edx
  802d42:	89 10                	mov    %edx,(%eax)
  802d44:	eb 0a                	jmp    802d50 <initialize_dynamic_allocator+0xca>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d63:	a1 38 60 80 00       	mov    0x806038,%eax
  802d68:	48                   	dec    %eax
  802d69:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802d6e:	a1 34 60 80 00       	mov    0x806034,%eax
  802d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7a:	74 07                	je     802d83 <initialize_dynamic_allocator+0xfd>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	eb 05                	jmp    802d88 <initialize_dynamic_allocator+0x102>
  802d83:	b8 00 00 00 00       	mov    $0x0,%eax
  802d88:	a3 34 60 80 00       	mov    %eax,0x806034
  802d8d:	a1 34 60 80 00       	mov    0x806034,%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	0f 85 55 ff ff ff    	jne    802cef <initialize_dynamic_allocator+0x69>
  802d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9e:	0f 85 4b ff ff ff    	jne    802cef <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802db3:	a1 44 60 80 00       	mov    0x806044,%eax
  802db8:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802dbd:	a1 40 60 80 00       	mov    0x806040,%eax
  802dc2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	83 c0 08             	add    $0x8,%eax
  802dce:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	83 c0 04             	add    $0x4,%eax
  802dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dda:	83 ea 08             	sub    $0x8,%edx
  802ddd:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	01 d0                	add    %edx,%eax
  802de7:	83 e8 08             	sub    $0x8,%eax
  802dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ded:	83 ea 08             	sub    $0x8,%edx
  802df0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802e05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e09:	75 17                	jne    802e22 <initialize_dynamic_allocator+0x19c>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 8c 50 80 00       	push   $0x80508c
  802e13:	68 90 00 00 00       	push   $0x90
  802e18:	68 71 50 80 00       	push   $0x805071
  802e1d:	e8 5e e1 ff ff       	call   800f80 <_panic>
  802e22:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	74 0d                	je     802e43 <initialize_dynamic_allocator+0x1bd>
  802e36:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802e3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e3e:	89 50 04             	mov    %edx,0x4(%eax)
  802e41:	eb 08                	jmp    802e4b <initialize_dynamic_allocator+0x1c5>
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	a3 30 60 80 00       	mov    %eax,0x806030
  802e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5d:	a1 38 60 80 00       	mov    0x806038,%eax
  802e62:	40                   	inc    %eax
  802e63:	a3 38 60 80 00       	mov    %eax,0x806038
  802e68:	eb 07                	jmp    802e71 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802e6a:	90                   	nop
  802e6b:	eb 04                	jmp    802e71 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802e6d:	90                   	nop
  802e6e:	eb 01                	jmp    802e71 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802e70:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802e71:	c9                   	leave  
  802e72:	c3                   	ret    

00802e73 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802e73:	55                   	push   %ebp
  802e74:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802e76:	8b 45 10             	mov    0x10(%ebp),%eax
  802e79:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	83 e8 04             	sub    $0x4,%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	83 e0 fe             	and    $0xfffffffe,%eax
  802e92:	8d 50 f8             	lea    -0x8(%eax),%edx
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	01 c2                	add    %eax,%edx
  802e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9d:	89 02                	mov    %eax,(%edx)
}
  802e9f:	90                   	nop
  802ea0:	5d                   	pop    %ebp
  802ea1:	c3                   	ret    

00802ea2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	83 e0 01             	and    $0x1,%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 03                	je     802eb5 <alloc_block_FF+0x13>
  802eb2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802eb5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802eb9:	77 07                	ja     802ec2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ebb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ec2:	a1 24 60 80 00       	mov    0x806024,%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	75 73                	jne    802f3e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	83 c0 10             	add    $0x10,%eax
  802ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ed4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802edb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee1:	01 d0                	add    %edx,%eax
  802ee3:	48                   	dec    %eax
  802ee4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eea:	ba 00 00 00 00       	mov    $0x0,%edx
  802eef:	f7 75 ec             	divl   -0x14(%ebp)
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	29 d0                	sub    %edx,%eax
  802ef7:	c1 e8 0c             	shr    $0xc,%eax
  802efa:	83 ec 0c             	sub    $0xc,%esp
  802efd:	50                   	push   %eax
  802efe:	e8 d4 f0 ff ff       	call   801fd7 <sbrk>
  802f03:	83 c4 10             	add    $0x10,%esp
  802f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f09:	83 ec 0c             	sub    $0xc,%esp
  802f0c:	6a 00                	push   $0x0
  802f0e:	e8 c4 f0 ff ff       	call   801fd7 <sbrk>
  802f13:	83 c4 10             	add    $0x10,%esp
  802f16:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f1f:	83 ec 08             	sub    $0x8,%esp
  802f22:	50                   	push   %eax
  802f23:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f26:	e8 5b fd ff ff       	call   802c86 <initialize_dynamic_allocator>
  802f2b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	68 af 50 80 00       	push   $0x8050af
  802f36:	e8 02 e3 ff ff       	call   80123d <cprintf>
  802f3b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802f3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f42:	75 0a                	jne    802f4e <alloc_block_FF+0xac>
	        return NULL;
  802f44:	b8 00 00 00 00       	mov    $0x0,%eax
  802f49:	e9 0e 04 00 00       	jmp    80335c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f55:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5d:	e9 f3 02 00 00       	jmp    803255 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802f68:	83 ec 0c             	sub    $0xc,%esp
  802f6b:	ff 75 bc             	pushl  -0x44(%ebp)
  802f6e:	e8 af fb ff ff       	call   802b22 <get_block_size>
  802f73:	83 c4 10             	add    $0x10,%esp
  802f76:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	83 c0 08             	add    $0x8,%eax
  802f7f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802f82:	0f 87 c5 02 00 00    	ja     80324d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	83 c0 18             	add    $0x18,%eax
  802f8e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802f91:	0f 87 19 02 00 00    	ja     8031b0 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802f97:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9d:	83 e8 08             	sub    $0x8,%eax
  802fa0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8d 50 08             	lea    0x8(%eax),%edx
  802fa9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fac:	01 d0                	add    %edx,%eax
  802fae:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	83 c0 08             	add    $0x8,%eax
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	6a 01                	push   $0x1
  802fbc:	50                   	push   %eax
  802fbd:	ff 75 bc             	pushl  -0x44(%ebp)
  802fc0:	e8 ae fe ff ff       	call   802e73 <set_block_data>
  802fc5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	75 68                	jne    80303a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fd2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802fd6:	75 17                	jne    802fef <alloc_block_FF+0x14d>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 8c 50 80 00       	push   $0x80508c
  802fe0:	68 d7 00 00 00       	push   $0xd7
  802fe5:	68 71 50 80 00       	push   $0x805071
  802fea:	e8 91 df ff ff       	call   800f80 <_panic>
  802fef:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802ff5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0d                	je     803010 <alloc_block_FF+0x16e>
  803003:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803008:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%eax)
  80300e:	eb 08                	jmp    803018 <alloc_block_FF+0x176>
  803010:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803013:	a3 30 60 80 00       	mov    %eax,0x806030
  803018:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80301b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803020:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302a:	a1 38 60 80 00       	mov    0x806038,%eax
  80302f:	40                   	inc    %eax
  803030:	a3 38 60 80 00       	mov    %eax,0x806038
  803035:	e9 dc 00 00 00       	jmp    803116 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	75 65                	jne    8030a8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803043:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803047:	75 17                	jne    803060 <alloc_block_FF+0x1be>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 c0 50 80 00       	push   $0x8050c0
  803051:	68 db 00 00 00       	push   $0xdb
  803056:	68 71 50 80 00       	push   $0x805071
  80305b:	e8 20 df ff ff       	call   800f80 <_panic>
  803060:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803066:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803069:	89 50 04             	mov    %edx,0x4(%eax)
  80306c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0c                	je     803082 <alloc_block_FF+0x1e0>
  803076:	a1 30 60 80 00       	mov    0x806030,%eax
  80307b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80307e:	89 10                	mov    %edx,(%eax)
  803080:	eb 08                	jmp    80308a <alloc_block_FF+0x1e8>
  803082:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803085:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80308a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80308d:	a3 30 60 80 00       	mov    %eax,0x806030
  803092:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309b:	a1 38 60 80 00       	mov    0x806038,%eax
  8030a0:	40                   	inc    %eax
  8030a1:	a3 38 60 80 00       	mov    %eax,0x806038
  8030a6:	eb 6e                	jmp    803116 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8030a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ac:	74 06                	je     8030b4 <alloc_block_FF+0x212>
  8030ae:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030b2:	75 17                	jne    8030cb <alloc_block_FF+0x229>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 e4 50 80 00       	push   $0x8050e4
  8030bc:	68 df 00 00 00       	push   $0xdf
  8030c1:	68 71 50 80 00       	push   $0x805071
  8030c6:	e8 b5 de ff ff       	call   800f80 <_panic>
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 10                	mov    (%eax),%edx
  8030d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030d3:	89 10                	mov    %edx,(%eax)
  8030d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 0b                	je     8030e9 <alloc_block_FF+0x247>
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030e6:	89 50 04             	mov    %edx,0x4(%eax)
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	75 08                	jne    80310b <alloc_block_FF+0x269>
  803103:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803106:	a3 30 60 80 00       	mov    %eax,0x806030
  80310b:	a1 38 60 80 00       	mov    0x806038,%eax
  803110:	40                   	inc    %eax
  803111:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311a:	75 17                	jne    803133 <alloc_block_FF+0x291>
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 53 50 80 00       	push   $0x805053
  803124:	68 e1 00 00 00       	push   $0xe1
  803129:	68 71 50 80 00       	push   $0x805071
  80312e:	e8 4d de ff ff       	call   800f80 <_panic>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 10                	je     80314c <alloc_block_FF+0x2aa>
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803144:	8b 52 04             	mov    0x4(%edx),%edx
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	eb 0b                	jmp    803157 <alloc_block_FF+0x2b5>
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	a3 30 60 80 00       	mov    %eax,0x806030
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0f                	je     803170 <alloc_block_FF+0x2ce>
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 40 04             	mov    0x4(%eax),%eax
  803167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80316a:	8b 12                	mov    (%edx),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 0a                	jmp    80317a <alloc_block_FF+0x2d8>
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 38 60 80 00       	mov    0x806038,%eax
  803192:	48                   	dec    %eax
  803193:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	6a 00                	push   $0x0
  80319d:	ff 75 b4             	pushl  -0x4c(%ebp)
  8031a0:	ff 75 b0             	pushl  -0x50(%ebp)
  8031a3:	e8 cb fc ff ff       	call   802e73 <set_block_data>
  8031a8:	83 c4 10             	add    $0x10,%esp
  8031ab:	e9 95 00 00 00       	jmp    803245 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8031b0:	83 ec 04             	sub    $0x4,%esp
  8031b3:	6a 01                	push   $0x1
  8031b5:	ff 75 b8             	pushl  -0x48(%ebp)
  8031b8:	ff 75 bc             	pushl  -0x44(%ebp)
  8031bb:	e8 b3 fc ff ff       	call   802e73 <set_block_data>
  8031c0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8031c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c7:	75 17                	jne    8031e0 <alloc_block_FF+0x33e>
  8031c9:	83 ec 04             	sub    $0x4,%esp
  8031cc:	68 53 50 80 00       	push   $0x805053
  8031d1:	68 e8 00 00 00       	push   $0xe8
  8031d6:	68 71 50 80 00       	push   $0x805071
  8031db:	e8 a0 dd ff ff       	call   800f80 <_panic>
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	8b 00                	mov    (%eax),%eax
  8031e5:	85 c0                	test   %eax,%eax
  8031e7:	74 10                	je     8031f9 <alloc_block_FF+0x357>
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	8b 00                	mov    (%eax),%eax
  8031ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f1:	8b 52 04             	mov    0x4(%edx),%edx
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	eb 0b                	jmp    803204 <alloc_block_FF+0x362>
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	a3 30 60 80 00       	mov    %eax,0x806030
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 0f                	je     80321d <alloc_block_FF+0x37b>
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 40 04             	mov    0x4(%eax),%eax
  803214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803217:	8b 12                	mov    (%edx),%edx
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	eb 0a                	jmp    803227 <alloc_block_FF+0x385>
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323a:	a1 38 60 80 00       	mov    0x806038,%eax
  80323f:	48                   	dec    %eax
  803240:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  803245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803248:	e9 0f 01 00 00       	jmp    80335c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80324d:	a1 34 60 80 00       	mov    0x806034,%eax
  803252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803259:	74 07                	je     803262 <alloc_block_FF+0x3c0>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	eb 05                	jmp    803267 <alloc_block_FF+0x3c5>
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
  803267:	a3 34 60 80 00       	mov    %eax,0x806034
  80326c:	a1 34 60 80 00       	mov    0x806034,%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	0f 85 e9 fc ff ff    	jne    802f62 <alloc_block_FF+0xc0>
  803279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327d:	0f 85 df fc ff ff    	jne    802f62 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	83 c0 08             	add    $0x8,%eax
  803289:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80328c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803293:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803296:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803299:	01 d0                	add    %edx,%eax
  80329b:	48                   	dec    %eax
  80329c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80329f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a7:	f7 75 d8             	divl   -0x28(%ebp)
  8032aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ad:	29 d0                	sub    %edx,%eax
  8032af:	c1 e8 0c             	shr    $0xc,%eax
  8032b2:	83 ec 0c             	sub    $0xc,%esp
  8032b5:	50                   	push   %eax
  8032b6:	e8 1c ed ff ff       	call   801fd7 <sbrk>
  8032bb:	83 c4 10             	add    $0x10,%esp
  8032be:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8032c1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8032c5:	75 0a                	jne    8032d1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cc:	e9 8b 00 00 00       	jmp    80335c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032d1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8032d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032de:	01 d0                	add    %edx,%eax
  8032e0:	48                   	dec    %eax
  8032e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8032e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ec:	f7 75 cc             	divl   -0x34(%ebp)
  8032ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f2:	29 d0                	sub    %edx,%eax
  8032f4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803301:	a1 40 60 80 00       	mov    0x806040,%eax
  803306:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80330c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803313:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803316:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	48                   	dec    %eax
  80331c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80331f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803322:	ba 00 00 00 00       	mov    $0x0,%edx
  803327:	f7 75 c4             	divl   -0x3c(%ebp)
  80332a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80332d:	29 d0                	sub    %edx,%eax
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	6a 01                	push   $0x1
  803334:	50                   	push   %eax
  803335:	ff 75 d0             	pushl  -0x30(%ebp)
  803338:	e8 36 fb ff ff       	call   802e73 <set_block_data>
  80333d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803340:	83 ec 0c             	sub    $0xc,%esp
  803343:	ff 75 d0             	pushl  -0x30(%ebp)
  803346:	e8 1b 0a 00 00       	call   803d66 <free_block>
  80334b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80334e:	83 ec 0c             	sub    $0xc,%esp
  803351:	ff 75 08             	pushl  0x8(%ebp)
  803354:	e8 49 fb ff ff       	call   802ea2 <alloc_block_FF>
  803359:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80335c:	c9                   	leave  
  80335d:	c3                   	ret    

0080335e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
  803361:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	83 e0 01             	and    $0x1,%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 03                	je     803371 <alloc_block_BF+0x13>
  80336e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803371:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803375:	77 07                	ja     80337e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803377:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80337e:	a1 24 60 80 00       	mov    0x806024,%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	75 73                	jne    8033fa <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	83 c0 10             	add    $0x10,%eax
  80338d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803390:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803397:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80339a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339d:	01 d0                	add    %edx,%eax
  80339f:	48                   	dec    %eax
  8033a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ab:	f7 75 e0             	divl   -0x20(%ebp)
  8033ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b1:	29 d0                	sub    %edx,%eax
  8033b3:	c1 e8 0c             	shr    $0xc,%eax
  8033b6:	83 ec 0c             	sub    $0xc,%esp
  8033b9:	50                   	push   %eax
  8033ba:	e8 18 ec ff ff       	call   801fd7 <sbrk>
  8033bf:	83 c4 10             	add    $0x10,%esp
  8033c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	6a 00                	push   $0x0
  8033ca:	e8 08 ec ff ff       	call   801fd7 <sbrk>
  8033cf:	83 c4 10             	add    $0x10,%esp
  8033d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8033d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8033db:	83 ec 08             	sub    $0x8,%esp
  8033de:	50                   	push   %eax
  8033df:	ff 75 d8             	pushl  -0x28(%ebp)
  8033e2:	e8 9f f8 ff ff       	call   802c86 <initialize_dynamic_allocator>
  8033e7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8033ea:	83 ec 0c             	sub    $0xc,%esp
  8033ed:	68 af 50 80 00       	push   $0x8050af
  8033f2:	e8 46 de ff ff       	call   80123d <cprintf>
  8033f7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8033fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803401:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803408:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80340f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803416:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80341b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341e:	e9 1d 01 00 00       	jmp    803540 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803429:	83 ec 0c             	sub    $0xc,%esp
  80342c:	ff 75 a8             	pushl  -0x58(%ebp)
  80342f:	e8 ee f6 ff ff       	call   802b22 <get_block_size>
  803434:	83 c4 10             	add    $0x10,%esp
  803437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	83 c0 08             	add    $0x8,%eax
  803440:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803443:	0f 87 ef 00 00 00    	ja     803538 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	83 c0 18             	add    $0x18,%eax
  80344f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803452:	77 1d                	ja     803471 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803457:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80345a:	0f 86 d8 00 00 00    	jbe    803538 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803460:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803463:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803466:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803469:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80346c:	e9 c7 00 00 00       	jmp    803538 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	83 c0 08             	add    $0x8,%eax
  803477:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80347a:	0f 85 9d 00 00 00    	jne    80351d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	6a 01                	push   $0x1
  803485:	ff 75 a4             	pushl  -0x5c(%ebp)
  803488:	ff 75 a8             	pushl  -0x58(%ebp)
  80348b:	e8 e3 f9 ff ff       	call   802e73 <set_block_data>
  803490:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	75 17                	jne    8034b0 <alloc_block_BF+0x152>
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 53 50 80 00       	push   $0x805053
  8034a1:	68 2c 01 00 00       	push   $0x12c
  8034a6:	68 71 50 80 00       	push   $0x805071
  8034ab:	e8 d0 da ff ff       	call   800f80 <_panic>
  8034b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 10                	je     8034c9 <alloc_block_BF+0x16b>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c1:	8b 52 04             	mov    0x4(%edx),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	eb 0b                	jmp    8034d4 <alloc_block_BF+0x176>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 40 04             	mov    0x4(%eax),%eax
  8034cf:	a3 30 60 80 00       	mov    %eax,0x806030
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 40 04             	mov    0x4(%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	74 0f                	je     8034ed <alloc_block_BF+0x18f>
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e7:	8b 12                	mov    (%edx),%edx
  8034e9:	89 10                	mov    %edx,(%eax)
  8034eb:	eb 0a                	jmp    8034f7 <alloc_block_BF+0x199>
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350a:	a1 38 60 80 00       	mov    0x806038,%eax
  80350f:	48                   	dec    %eax
  803510:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803515:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803518:	e9 24 04 00 00       	jmp    803941 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80351d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803520:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803523:	76 13                	jbe    803538 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803525:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80352c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80352f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803532:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803535:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803538:	a1 34 60 80 00       	mov    0x806034,%eax
  80353d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803544:	74 07                	je     80354d <alloc_block_BF+0x1ef>
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	eb 05                	jmp    803552 <alloc_block_BF+0x1f4>
  80354d:	b8 00 00 00 00       	mov    $0x0,%eax
  803552:	a3 34 60 80 00       	mov    %eax,0x806034
  803557:	a1 34 60 80 00       	mov    0x806034,%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	0f 85 bf fe ff ff    	jne    803423 <alloc_block_BF+0xc5>
  803564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803568:	0f 85 b5 fe ff ff    	jne    803423 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80356e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803572:	0f 84 26 02 00 00    	je     80379e <alloc_block_BF+0x440>
  803578:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80357c:	0f 85 1c 02 00 00    	jne    80379e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803585:	2b 45 08             	sub    0x8(%ebp),%eax
  803588:	83 e8 08             	sub    $0x8,%eax
  80358b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	8d 50 08             	lea    0x8(%eax),%edx
  803594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803597:	01 d0                	add    %edx,%eax
  803599:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	83 c0 08             	add    $0x8,%eax
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	6a 01                	push   $0x1
  8035a7:	50                   	push   %eax
  8035a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8035ab:	e8 c3 f8 ff ff       	call   802e73 <set_block_data>
  8035b0:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8035b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b6:	8b 40 04             	mov    0x4(%eax),%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	75 68                	jne    803625 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8035bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035c1:	75 17                	jne    8035da <alloc_block_BF+0x27c>
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	68 8c 50 80 00       	push   $0x80508c
  8035cb:	68 45 01 00 00       	push   $0x145
  8035d0:	68 71 50 80 00       	push   $0x805071
  8035d5:	e8 a6 d9 ff ff       	call   800f80 <_panic>
  8035da:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8035e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035e3:	89 10                	mov    %edx,(%eax)
  8035e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 0d                	je     8035fb <alloc_block_BF+0x29d>
  8035ee:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8035f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035f6:	89 50 04             	mov    %edx,0x4(%eax)
  8035f9:	eb 08                	jmp    803603 <alloc_block_BF+0x2a5>
  8035fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035fe:	a3 30 60 80 00       	mov    %eax,0x806030
  803603:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803606:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80360b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803615:	a1 38 60 80 00       	mov    0x806038,%eax
  80361a:	40                   	inc    %eax
  80361b:	a3 38 60 80 00       	mov    %eax,0x806038
  803620:	e9 dc 00 00 00       	jmp    803701 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	75 65                	jne    803693 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80362e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803632:	75 17                	jne    80364b <alloc_block_BF+0x2ed>
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 c0 50 80 00       	push   $0x8050c0
  80363c:	68 4a 01 00 00       	push   $0x14a
  803641:	68 71 50 80 00       	push   $0x805071
  803646:	e8 35 d9 ff ff       	call   800f80 <_panic>
  80364b:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803651:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803654:	89 50 04             	mov    %edx,0x4(%eax)
  803657:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80365a:	8b 40 04             	mov    0x4(%eax),%eax
  80365d:	85 c0                	test   %eax,%eax
  80365f:	74 0c                	je     80366d <alloc_block_BF+0x30f>
  803661:	a1 30 60 80 00       	mov    0x806030,%eax
  803666:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803669:	89 10                	mov    %edx,(%eax)
  80366b:	eb 08                	jmp    803675 <alloc_block_BF+0x317>
  80366d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803670:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803675:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803678:	a3 30 60 80 00       	mov    %eax,0x806030
  80367d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803686:	a1 38 60 80 00       	mov    0x806038,%eax
  80368b:	40                   	inc    %eax
  80368c:	a3 38 60 80 00       	mov    %eax,0x806038
  803691:	eb 6e                	jmp    803701 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803693:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803697:	74 06                	je     80369f <alloc_block_BF+0x341>
  803699:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80369d:	75 17                	jne    8036b6 <alloc_block_BF+0x358>
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	68 e4 50 80 00       	push   $0x8050e4
  8036a7:	68 4f 01 00 00       	push   $0x14f
  8036ac:	68 71 50 80 00       	push   $0x805071
  8036b1:	e8 ca d8 ff ff       	call   800f80 <_panic>
  8036b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b9:	8b 10                	mov    (%eax),%edx
  8036bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036be:	89 10                	mov    %edx,(%eax)
  8036c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 0b                	je     8036d4 <alloc_block_BF+0x376>
  8036c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cc:	8b 00                	mov    (%eax),%eax
  8036ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036d1:	89 50 04             	mov    %edx,0x4(%eax)
  8036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e2:	89 50 04             	mov    %edx,0x4(%eax)
  8036e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036e8:	8b 00                	mov    (%eax),%eax
  8036ea:	85 c0                	test   %eax,%eax
  8036ec:	75 08                	jne    8036f6 <alloc_block_BF+0x398>
  8036ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f1:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f6:	a1 38 60 80 00       	mov    0x806038,%eax
  8036fb:	40                   	inc    %eax
  8036fc:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803701:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803705:	75 17                	jne    80371e <alloc_block_BF+0x3c0>
  803707:	83 ec 04             	sub    $0x4,%esp
  80370a:	68 53 50 80 00       	push   $0x805053
  80370f:	68 51 01 00 00       	push   $0x151
  803714:	68 71 50 80 00       	push   $0x805071
  803719:	e8 62 d8 ff ff       	call   800f80 <_panic>
  80371e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	85 c0                	test   %eax,%eax
  803725:	74 10                	je     803737 <alloc_block_BF+0x3d9>
  803727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372a:	8b 00                	mov    (%eax),%eax
  80372c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80372f:	8b 52 04             	mov    0x4(%edx),%edx
  803732:	89 50 04             	mov    %edx,0x4(%eax)
  803735:	eb 0b                	jmp    803742 <alloc_block_BF+0x3e4>
  803737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373a:	8b 40 04             	mov    0x4(%eax),%eax
  80373d:	a3 30 60 80 00       	mov    %eax,0x806030
  803742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803745:	8b 40 04             	mov    0x4(%eax),%eax
  803748:	85 c0                	test   %eax,%eax
  80374a:	74 0f                	je     80375b <alloc_block_BF+0x3fd>
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803755:	8b 12                	mov    (%edx),%edx
  803757:	89 10                	mov    %edx,(%eax)
  803759:	eb 0a                	jmp    803765 <alloc_block_BF+0x407>
  80375b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803768:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803778:	a1 38 60 80 00       	mov    0x806038,%eax
  80377d:	48                   	dec    %eax
  80377e:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	6a 00                	push   $0x0
  803788:	ff 75 d0             	pushl  -0x30(%ebp)
  80378b:	ff 75 cc             	pushl  -0x34(%ebp)
  80378e:	e8 e0 f6 ff ff       	call   802e73 <set_block_data>
  803793:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803799:	e9 a3 01 00 00       	jmp    803941 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80379e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8037a2:	0f 85 9d 00 00 00    	jne    803845 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8037a8:	83 ec 04             	sub    $0x4,%esp
  8037ab:	6a 01                	push   $0x1
  8037ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8037b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b3:	e8 bb f6 ff ff       	call   802e73 <set_block_data>
  8037b8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8037bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037bf:	75 17                	jne    8037d8 <alloc_block_BF+0x47a>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 53 50 80 00       	push   $0x805053
  8037c9:	68 58 01 00 00       	push   $0x158
  8037ce:	68 71 50 80 00       	push   $0x805071
  8037d3:	e8 a8 d7 ff ff       	call   800f80 <_panic>
  8037d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	85 c0                	test   %eax,%eax
  8037df:	74 10                	je     8037f1 <alloc_block_BF+0x493>
  8037e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e4:	8b 00                	mov    (%eax),%eax
  8037e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e9:	8b 52 04             	mov    0x4(%edx),%edx
  8037ec:	89 50 04             	mov    %edx,0x4(%eax)
  8037ef:	eb 0b                	jmp    8037fc <alloc_block_BF+0x49e>
  8037f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8037fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ff:	8b 40 04             	mov    0x4(%eax),%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	74 0f                	je     803815 <alloc_block_BF+0x4b7>
  803806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80380f:	8b 12                	mov    (%edx),%edx
  803811:	89 10                	mov    %edx,(%eax)
  803813:	eb 0a                	jmp    80381f <alloc_block_BF+0x4c1>
  803815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803818:	8b 00                	mov    (%eax),%eax
  80381a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80381f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803832:	a1 38 60 80 00       	mov    0x806038,%eax
  803837:	48                   	dec    %eax
  803838:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80383d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803840:	e9 fc 00 00 00       	jmp    803941 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	83 c0 08             	add    $0x8,%eax
  80384b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80384e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803855:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803858:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80385b:	01 d0                	add    %edx,%eax
  80385d:	48                   	dec    %eax
  80385e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803861:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803864:	ba 00 00 00 00       	mov    $0x0,%edx
  803869:	f7 75 c4             	divl   -0x3c(%ebp)
  80386c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80386f:	29 d0                	sub    %edx,%eax
  803871:	c1 e8 0c             	shr    $0xc,%eax
  803874:	83 ec 0c             	sub    $0xc,%esp
  803877:	50                   	push   %eax
  803878:	e8 5a e7 ff ff       	call   801fd7 <sbrk>
  80387d:	83 c4 10             	add    $0x10,%esp
  803880:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803883:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803887:	75 0a                	jne    803893 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803889:	b8 00 00 00 00       	mov    $0x0,%eax
  80388e:	e9 ae 00 00 00       	jmp    803941 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803893:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80389a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80389d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a0:	01 d0                	add    %edx,%eax
  8038a2:	48                   	dec    %eax
  8038a3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8038a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8038a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8038ae:	f7 75 b8             	divl   -0x48(%ebp)
  8038b1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8038b4:	29 d0                	sub    %edx,%eax
  8038b6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8038b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8038bc:	01 d0                	add    %edx,%eax
  8038be:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8038c3:	a1 40 60 80 00       	mov    0x806040,%eax
  8038c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8038ce:	83 ec 0c             	sub    $0xc,%esp
  8038d1:	68 18 51 80 00       	push   $0x805118
  8038d6:	e8 62 d9 ff ff       	call   80123d <cprintf>
  8038db:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8038de:	83 ec 08             	sub    $0x8,%esp
  8038e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8038e4:	68 1d 51 80 00       	push   $0x80511d
  8038e9:	e8 4f d9 ff ff       	call   80123d <cprintf>
  8038ee:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8038f1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8038f8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038fe:	01 d0                	add    %edx,%eax
  803900:	48                   	dec    %eax
  803901:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803904:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803907:	ba 00 00 00 00       	mov    $0x0,%edx
  80390c:	f7 75 b0             	divl   -0x50(%ebp)
  80390f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803912:	29 d0                	sub    %edx,%eax
  803914:	83 ec 04             	sub    $0x4,%esp
  803917:	6a 01                	push   $0x1
  803919:	50                   	push   %eax
  80391a:	ff 75 bc             	pushl  -0x44(%ebp)
  80391d:	e8 51 f5 ff ff       	call   802e73 <set_block_data>
  803922:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803925:	83 ec 0c             	sub    $0xc,%esp
  803928:	ff 75 bc             	pushl  -0x44(%ebp)
  80392b:	e8 36 04 00 00       	call   803d66 <free_block>
  803930:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803933:	83 ec 0c             	sub    $0xc,%esp
  803936:	ff 75 08             	pushl  0x8(%ebp)
  803939:	e8 20 fa ff ff       	call   80335e <alloc_block_BF>
  80393e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803941:	c9                   	leave  
  803942:	c3                   	ret    

00803943 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803943:	55                   	push   %ebp
  803944:	89 e5                	mov    %esp,%ebp
  803946:	53                   	push   %ebx
  803947:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80394a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803958:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80395c:	74 1e                	je     80397c <merging+0x39>
  80395e:	ff 75 08             	pushl  0x8(%ebp)
  803961:	e8 bc f1 ff ff       	call   802b22 <get_block_size>
  803966:	83 c4 04             	add    $0x4,%esp
  803969:	89 c2                	mov    %eax,%edx
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	01 d0                	add    %edx,%eax
  803970:	3b 45 10             	cmp    0x10(%ebp),%eax
  803973:	75 07                	jne    80397c <merging+0x39>
		prev_is_free = 1;
  803975:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80397c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803980:	74 1e                	je     8039a0 <merging+0x5d>
  803982:	ff 75 10             	pushl  0x10(%ebp)
  803985:	e8 98 f1 ff ff       	call   802b22 <get_block_size>
  80398a:	83 c4 04             	add    $0x4,%esp
  80398d:	89 c2                	mov    %eax,%edx
  80398f:	8b 45 10             	mov    0x10(%ebp),%eax
  803992:	01 d0                	add    %edx,%eax
  803994:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803997:	75 07                	jne    8039a0 <merging+0x5d>
		next_is_free = 1;
  803999:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8039a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a4:	0f 84 cc 00 00 00    	je     803a76 <merging+0x133>
  8039aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039ae:	0f 84 c2 00 00 00    	je     803a76 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8039b4:	ff 75 08             	pushl  0x8(%ebp)
  8039b7:	e8 66 f1 ff ff       	call   802b22 <get_block_size>
  8039bc:	83 c4 04             	add    $0x4,%esp
  8039bf:	89 c3                	mov    %eax,%ebx
  8039c1:	ff 75 10             	pushl  0x10(%ebp)
  8039c4:	e8 59 f1 ff ff       	call   802b22 <get_block_size>
  8039c9:	83 c4 04             	add    $0x4,%esp
  8039cc:	01 c3                	add    %eax,%ebx
  8039ce:	ff 75 0c             	pushl  0xc(%ebp)
  8039d1:	e8 4c f1 ff ff       	call   802b22 <get_block_size>
  8039d6:	83 c4 04             	add    $0x4,%esp
  8039d9:	01 d8                	add    %ebx,%eax
  8039db:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8039de:	6a 00                	push   $0x0
  8039e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8039e3:	ff 75 08             	pushl  0x8(%ebp)
  8039e6:	e8 88 f4 ff ff       	call   802e73 <set_block_data>
  8039eb:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8039ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039f2:	75 17                	jne    803a0b <merging+0xc8>
  8039f4:	83 ec 04             	sub    $0x4,%esp
  8039f7:	68 53 50 80 00       	push   $0x805053
  8039fc:	68 7d 01 00 00       	push   $0x17d
  803a01:	68 71 50 80 00       	push   $0x805071
  803a06:	e8 75 d5 ff ff       	call   800f80 <_panic>
  803a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0e:	8b 00                	mov    (%eax),%eax
  803a10:	85 c0                	test   %eax,%eax
  803a12:	74 10                	je     803a24 <merging+0xe1>
  803a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a1c:	8b 52 04             	mov    0x4(%edx),%edx
  803a1f:	89 50 04             	mov    %edx,0x4(%eax)
  803a22:	eb 0b                	jmp    803a2f <merging+0xec>
  803a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a27:	8b 40 04             	mov    0x4(%eax),%eax
  803a2a:	a3 30 60 80 00       	mov    %eax,0x806030
  803a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a32:	8b 40 04             	mov    0x4(%eax),%eax
  803a35:	85 c0                	test   %eax,%eax
  803a37:	74 0f                	je     803a48 <merging+0x105>
  803a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3c:	8b 40 04             	mov    0x4(%eax),%eax
  803a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a42:	8b 12                	mov    (%edx),%edx
  803a44:	89 10                	mov    %edx,(%eax)
  803a46:	eb 0a                	jmp    803a52 <merging+0x10f>
  803a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a65:	a1 38 60 80 00       	mov    0x806038,%eax
  803a6a:	48                   	dec    %eax
  803a6b:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803a70:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803a71:	e9 ea 02 00 00       	jmp    803d60 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7a:	74 3b                	je     803ab7 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803a7c:	83 ec 0c             	sub    $0xc,%esp
  803a7f:	ff 75 08             	pushl  0x8(%ebp)
  803a82:	e8 9b f0 ff ff       	call   802b22 <get_block_size>
  803a87:	83 c4 10             	add    $0x10,%esp
  803a8a:	89 c3                	mov    %eax,%ebx
  803a8c:	83 ec 0c             	sub    $0xc,%esp
  803a8f:	ff 75 10             	pushl  0x10(%ebp)
  803a92:	e8 8b f0 ff ff       	call   802b22 <get_block_size>
  803a97:	83 c4 10             	add    $0x10,%esp
  803a9a:	01 d8                	add    %ebx,%eax
  803a9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803a9f:	83 ec 04             	sub    $0x4,%esp
  803aa2:	6a 00                	push   $0x0
  803aa4:	ff 75 e8             	pushl  -0x18(%ebp)
  803aa7:	ff 75 08             	pushl  0x8(%ebp)
  803aaa:	e8 c4 f3 ff ff       	call   802e73 <set_block_data>
  803aaf:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ab2:	e9 a9 02 00 00       	jmp    803d60 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803ab7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803abb:	0f 84 2d 01 00 00    	je     803bee <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803ac1:	83 ec 0c             	sub    $0xc,%esp
  803ac4:	ff 75 10             	pushl  0x10(%ebp)
  803ac7:	e8 56 f0 ff ff       	call   802b22 <get_block_size>
  803acc:	83 c4 10             	add    $0x10,%esp
  803acf:	89 c3                	mov    %eax,%ebx
  803ad1:	83 ec 0c             	sub    $0xc,%esp
  803ad4:	ff 75 0c             	pushl  0xc(%ebp)
  803ad7:	e8 46 f0 ff ff       	call   802b22 <get_block_size>
  803adc:	83 c4 10             	add    $0x10,%esp
  803adf:	01 d8                	add    %ebx,%eax
  803ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803ae4:	83 ec 04             	sub    $0x4,%esp
  803ae7:	6a 00                	push   $0x0
  803ae9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aec:	ff 75 10             	pushl  0x10(%ebp)
  803aef:	e8 7f f3 ff ff       	call   802e73 <set_block_data>
  803af4:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803af7:	8b 45 10             	mov    0x10(%ebp),%eax
  803afa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b01:	74 06                	je     803b09 <merging+0x1c6>
  803b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b07:	75 17                	jne    803b20 <merging+0x1dd>
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	68 2c 51 80 00       	push   $0x80512c
  803b11:	68 8d 01 00 00       	push   $0x18d
  803b16:	68 71 50 80 00       	push   $0x805071
  803b1b:	e8 60 d4 ff ff       	call   800f80 <_panic>
  803b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b23:	8b 50 04             	mov    0x4(%eax),%edx
  803b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b29:	89 50 04             	mov    %edx,0x4(%eax)
  803b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b32:	89 10                	mov    %edx,(%eax)
  803b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b37:	8b 40 04             	mov    0x4(%eax),%eax
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	74 0d                	je     803b4b <merging+0x208>
  803b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b41:	8b 40 04             	mov    0x4(%eax),%eax
  803b44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b47:	89 10                	mov    %edx,(%eax)
  803b49:	eb 08                	jmp    803b53 <merging+0x210>
  803b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b4e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b59:	89 50 04             	mov    %edx,0x4(%eax)
  803b5c:	a1 38 60 80 00       	mov    0x806038,%eax
  803b61:	40                   	inc    %eax
  803b62:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803b67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b6b:	75 17                	jne    803b84 <merging+0x241>
  803b6d:	83 ec 04             	sub    $0x4,%esp
  803b70:	68 53 50 80 00       	push   $0x805053
  803b75:	68 8e 01 00 00       	push   $0x18e
  803b7a:	68 71 50 80 00       	push   $0x805071
  803b7f:	e8 fc d3 ff ff       	call   800f80 <_panic>
  803b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	74 10                	je     803b9d <merging+0x25a>
  803b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b90:	8b 00                	mov    (%eax),%eax
  803b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b95:	8b 52 04             	mov    0x4(%edx),%edx
  803b98:	89 50 04             	mov    %edx,0x4(%eax)
  803b9b:	eb 0b                	jmp    803ba8 <merging+0x265>
  803b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba0:	8b 40 04             	mov    0x4(%eax),%eax
  803ba3:	a3 30 60 80 00       	mov    %eax,0x806030
  803ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bab:	8b 40 04             	mov    0x4(%eax),%eax
  803bae:	85 c0                	test   %eax,%eax
  803bb0:	74 0f                	je     803bc1 <merging+0x27e>
  803bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb5:	8b 40 04             	mov    0x4(%eax),%eax
  803bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bbb:	8b 12                	mov    (%edx),%edx
  803bbd:	89 10                	mov    %edx,(%eax)
  803bbf:	eb 0a                	jmp    803bcb <merging+0x288>
  803bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bde:	a1 38 60 80 00       	mov    0x806038,%eax
  803be3:	48                   	dec    %eax
  803be4:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803be9:	e9 72 01 00 00       	jmp    803d60 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803bee:	8b 45 10             	mov    0x10(%ebp),%eax
  803bf1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803bf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf8:	74 79                	je     803c73 <merging+0x330>
  803bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bfe:	74 73                	je     803c73 <merging+0x330>
  803c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c04:	74 06                	je     803c0c <merging+0x2c9>
  803c06:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c0a:	75 17                	jne    803c23 <merging+0x2e0>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 e4 50 80 00       	push   $0x8050e4
  803c14:	68 94 01 00 00       	push   $0x194
  803c19:	68 71 50 80 00       	push   $0x805071
  803c1e:	e8 5d d3 ff ff       	call   800f80 <_panic>
  803c23:	8b 45 08             	mov    0x8(%ebp),%eax
  803c26:	8b 10                	mov    (%eax),%edx
  803c28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c2b:	89 10                	mov    %edx,(%eax)
  803c2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c30:	8b 00                	mov    (%eax),%eax
  803c32:	85 c0                	test   %eax,%eax
  803c34:	74 0b                	je     803c41 <merging+0x2fe>
  803c36:	8b 45 08             	mov    0x8(%ebp),%eax
  803c39:	8b 00                	mov    (%eax),%eax
  803c3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c3e:	89 50 04             	mov    %edx,0x4(%eax)
  803c41:	8b 45 08             	mov    0x8(%ebp),%eax
  803c44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c47:	89 10                	mov    %edx,(%eax)
  803c49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4f:	89 50 04             	mov    %edx,0x4(%eax)
  803c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c55:	8b 00                	mov    (%eax),%eax
  803c57:	85 c0                	test   %eax,%eax
  803c59:	75 08                	jne    803c63 <merging+0x320>
  803c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c5e:	a3 30 60 80 00       	mov    %eax,0x806030
  803c63:	a1 38 60 80 00       	mov    0x806038,%eax
  803c68:	40                   	inc    %eax
  803c69:	a3 38 60 80 00       	mov    %eax,0x806038
  803c6e:	e9 ce 00 00 00       	jmp    803d41 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803c73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c77:	74 65                	je     803cde <merging+0x39b>
  803c79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c7d:	75 17                	jne    803c96 <merging+0x353>
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	68 c0 50 80 00       	push   $0x8050c0
  803c87:	68 95 01 00 00       	push   $0x195
  803c8c:	68 71 50 80 00       	push   $0x805071
  803c91:	e8 ea d2 ff ff       	call   800f80 <_panic>
  803c96:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c9f:	89 50 04             	mov    %edx,0x4(%eax)
  803ca2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ca5:	8b 40 04             	mov    0x4(%eax),%eax
  803ca8:	85 c0                	test   %eax,%eax
  803caa:	74 0c                	je     803cb8 <merging+0x375>
  803cac:	a1 30 60 80 00       	mov    0x806030,%eax
  803cb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cb4:	89 10                	mov    %edx,(%eax)
  803cb6:	eb 08                	jmp    803cc0 <merging+0x37d>
  803cb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cbb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803cc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cc3:	a3 30 60 80 00       	mov    %eax,0x806030
  803cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ccb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd1:	a1 38 60 80 00       	mov    0x806038,%eax
  803cd6:	40                   	inc    %eax
  803cd7:	a3 38 60 80 00       	mov    %eax,0x806038
  803cdc:	eb 63                	jmp    803d41 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ce2:	75 17                	jne    803cfb <merging+0x3b8>
  803ce4:	83 ec 04             	sub    $0x4,%esp
  803ce7:	68 8c 50 80 00       	push   $0x80508c
  803cec:	68 98 01 00 00       	push   $0x198
  803cf1:	68 71 50 80 00       	push   $0x805071
  803cf6:	e8 85 d2 ff ff       	call   800f80 <_panic>
  803cfb:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d04:	89 10                	mov    %edx,(%eax)
  803d06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d09:	8b 00                	mov    (%eax),%eax
  803d0b:	85 c0                	test   %eax,%eax
  803d0d:	74 0d                	je     803d1c <merging+0x3d9>
  803d0f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d17:	89 50 04             	mov    %edx,0x4(%eax)
  803d1a:	eb 08                	jmp    803d24 <merging+0x3e1>
  803d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1f:	a3 30 60 80 00       	mov    %eax,0x806030
  803d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d27:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d36:	a1 38 60 80 00       	mov    0x806038,%eax
  803d3b:	40                   	inc    %eax
  803d3c:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803d41:	83 ec 0c             	sub    $0xc,%esp
  803d44:	ff 75 10             	pushl  0x10(%ebp)
  803d47:	e8 d6 ed ff ff       	call   802b22 <get_block_size>
  803d4c:	83 c4 10             	add    $0x10,%esp
  803d4f:	83 ec 04             	sub    $0x4,%esp
  803d52:	6a 00                	push   $0x0
  803d54:	50                   	push   %eax
  803d55:	ff 75 10             	pushl  0x10(%ebp)
  803d58:	e8 16 f1 ff ff       	call   802e73 <set_block_data>
  803d5d:	83 c4 10             	add    $0x10,%esp
	}
}
  803d60:	90                   	nop
  803d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803d64:	c9                   	leave  
  803d65:	c3                   	ret    

00803d66 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803d66:	55                   	push   %ebp
  803d67:	89 e5                	mov    %esp,%ebp
  803d69:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803d6c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d71:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803d74:	a1 30 60 80 00       	mov    0x806030,%eax
  803d79:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d7c:	73 1b                	jae    803d99 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803d7e:	a1 30 60 80 00       	mov    0x806030,%eax
  803d83:	83 ec 04             	sub    $0x4,%esp
  803d86:	ff 75 08             	pushl  0x8(%ebp)
  803d89:	6a 00                	push   $0x0
  803d8b:	50                   	push   %eax
  803d8c:	e8 b2 fb ff ff       	call   803943 <merging>
  803d91:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d94:	e9 8b 00 00 00       	jmp    803e24 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803d99:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803da1:	76 18                	jbe    803dbb <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803da3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803da8:	83 ec 04             	sub    $0x4,%esp
  803dab:	ff 75 08             	pushl  0x8(%ebp)
  803dae:	50                   	push   %eax
  803daf:	6a 00                	push   $0x0
  803db1:	e8 8d fb ff ff       	call   803943 <merging>
  803db6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803db9:	eb 69                	jmp    803e24 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803dbb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dc3:	eb 39                	jmp    803dfe <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dcb:	73 29                	jae    803df6 <free_block+0x90>
  803dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dd5:	76 1f                	jbe    803df6 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dda:	8b 00                	mov    (%eax),%eax
  803ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ddf:	83 ec 04             	sub    $0x4,%esp
  803de2:	ff 75 08             	pushl  0x8(%ebp)
  803de5:	ff 75 f0             	pushl  -0x10(%ebp)
  803de8:	ff 75 f4             	pushl  -0xc(%ebp)
  803deb:	e8 53 fb ff ff       	call   803943 <merging>
  803df0:	83 c4 10             	add    $0x10,%esp
			break;
  803df3:	90                   	nop
		}
	}
}
  803df4:	eb 2e                	jmp    803e24 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803df6:	a1 34 60 80 00       	mov    0x806034,%eax
  803dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e02:	74 07                	je     803e0b <free_block+0xa5>
  803e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e07:	8b 00                	mov    (%eax),%eax
  803e09:	eb 05                	jmp    803e10 <free_block+0xaa>
  803e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e10:	a3 34 60 80 00       	mov    %eax,0x806034
  803e15:	a1 34 60 80 00       	mov    0x806034,%eax
  803e1a:	85 c0                	test   %eax,%eax
  803e1c:	75 a7                	jne    803dc5 <free_block+0x5f>
  803e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e22:	75 a1                	jne    803dc5 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e24:	90                   	nop
  803e25:	c9                   	leave  
  803e26:	c3                   	ret    

00803e27 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803e27:	55                   	push   %ebp
  803e28:	89 e5                	mov    %esp,%ebp
  803e2a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803e2d:	ff 75 08             	pushl  0x8(%ebp)
  803e30:	e8 ed ec ff ff       	call   802b22 <get_block_size>
  803e35:	83 c4 04             	add    $0x4,%esp
  803e38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803e42:	eb 17                	jmp    803e5b <copy_data+0x34>
  803e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e4a:	01 c2                	add    %eax,%edx
  803e4c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e52:	01 c8                	add    %ecx,%eax
  803e54:	8a 00                	mov    (%eax),%al
  803e56:	88 02                	mov    %al,(%edx)
  803e58:	ff 45 fc             	incl   -0x4(%ebp)
  803e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803e61:	72 e1                	jb     803e44 <copy_data+0x1d>
}
  803e63:	90                   	nop
  803e64:	c9                   	leave  
  803e65:	c3                   	ret    

00803e66 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803e66:	55                   	push   %ebp
  803e67:	89 e5                	mov    %esp,%ebp
  803e69:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e70:	75 23                	jne    803e95 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e76:	74 13                	je     803e8b <realloc_block_FF+0x25>
  803e78:	83 ec 0c             	sub    $0xc,%esp
  803e7b:	ff 75 0c             	pushl  0xc(%ebp)
  803e7e:	e8 1f f0 ff ff       	call   802ea2 <alloc_block_FF>
  803e83:	83 c4 10             	add    $0x10,%esp
  803e86:	e9 f4 06 00 00       	jmp    80457f <realloc_block_FF+0x719>
		return NULL;
  803e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e90:	e9 ea 06 00 00       	jmp    80457f <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803e95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e99:	75 18                	jne    803eb3 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803e9b:	83 ec 0c             	sub    $0xc,%esp
  803e9e:	ff 75 08             	pushl  0x8(%ebp)
  803ea1:	e8 c0 fe ff ff       	call   803d66 <free_block>
  803ea6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  803eae:	e9 cc 06 00 00       	jmp    80457f <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803eb3:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803eb7:	77 07                	ja     803ec0 <realloc_block_FF+0x5a>
  803eb9:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ec3:	83 e0 01             	and    $0x1,%eax
  803ec6:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ecc:	83 c0 08             	add    $0x8,%eax
  803ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ed2:	83 ec 0c             	sub    $0xc,%esp
  803ed5:	ff 75 08             	pushl  0x8(%ebp)
  803ed8:	e8 45 ec ff ff       	call   802b22 <get_block_size>
  803edd:	83 c4 10             	add    $0x10,%esp
  803ee0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee6:	83 e8 08             	sub    $0x8,%eax
  803ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803eec:	8b 45 08             	mov    0x8(%ebp),%eax
  803eef:	83 e8 04             	sub    $0x4,%eax
  803ef2:	8b 00                	mov    (%eax),%eax
  803ef4:	83 e0 fe             	and    $0xfffffffe,%eax
  803ef7:	89 c2                	mov    %eax,%edx
  803ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  803efc:	01 d0                	add    %edx,%eax
  803efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803f01:	83 ec 0c             	sub    $0xc,%esp
  803f04:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f07:	e8 16 ec ff ff       	call   802b22 <get_block_size>
  803f0c:	83 c4 10             	add    $0x10,%esp
  803f0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f15:	83 e8 08             	sub    $0x8,%eax
  803f18:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f21:	75 08                	jne    803f2b <realloc_block_FF+0xc5>
	{
		 return va;
  803f23:	8b 45 08             	mov    0x8(%ebp),%eax
  803f26:	e9 54 06 00 00       	jmp    80457f <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f2e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f31:	0f 83 e5 03 00 00    	jae    80431c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3a:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803f40:	83 ec 0c             	sub    $0xc,%esp
  803f43:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f46:	e8 f0 eb ff ff       	call   802b3b <is_free_block>
  803f4b:	83 c4 10             	add    $0x10,%esp
  803f4e:	84 c0                	test   %al,%al
  803f50:	0f 84 3b 01 00 00    	je     804091 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803f56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f5c:	01 d0                	add    %edx,%eax
  803f5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803f61:	83 ec 04             	sub    $0x4,%esp
  803f64:	6a 01                	push   $0x1
  803f66:	ff 75 f0             	pushl  -0x10(%ebp)
  803f69:	ff 75 08             	pushl  0x8(%ebp)
  803f6c:	e8 02 ef ff ff       	call   802e73 <set_block_data>
  803f71:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803f74:	8b 45 08             	mov    0x8(%ebp),%eax
  803f77:	83 e8 04             	sub    $0x4,%eax
  803f7a:	8b 00                	mov    (%eax),%eax
  803f7c:	83 e0 fe             	and    $0xfffffffe,%eax
  803f7f:	89 c2                	mov    %eax,%edx
  803f81:	8b 45 08             	mov    0x8(%ebp),%eax
  803f84:	01 d0                	add    %edx,%eax
  803f86:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803f89:	83 ec 04             	sub    $0x4,%esp
  803f8c:	6a 00                	push   $0x0
  803f8e:	ff 75 cc             	pushl  -0x34(%ebp)
  803f91:	ff 75 c8             	pushl  -0x38(%ebp)
  803f94:	e8 da ee ff ff       	call   802e73 <set_block_data>
  803f99:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fa0:	74 06                	je     803fa8 <realloc_block_FF+0x142>
  803fa2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803fa6:	75 17                	jne    803fbf <realloc_block_FF+0x159>
  803fa8:	83 ec 04             	sub    $0x4,%esp
  803fab:	68 e4 50 80 00       	push   $0x8050e4
  803fb0:	68 f6 01 00 00       	push   $0x1f6
  803fb5:	68 71 50 80 00       	push   $0x805071
  803fba:	e8 c1 cf ff ff       	call   800f80 <_panic>
  803fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc2:	8b 10                	mov    (%eax),%edx
  803fc4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fc7:	89 10                	mov    %edx,(%eax)
  803fc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fcc:	8b 00                	mov    (%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 0b                	je     803fdd <realloc_block_FF+0x177>
  803fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd5:	8b 00                	mov    (%eax),%eax
  803fd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fda:	89 50 04             	mov    %edx,0x4(%eax)
  803fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fe3:	89 10                	mov    %edx,(%eax)
  803fe5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fe8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803feb:	89 50 04             	mov    %edx,0x4(%eax)
  803fee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ff1:	8b 00                	mov    (%eax),%eax
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	75 08                	jne    803fff <realloc_block_FF+0x199>
  803ff7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ffa:	a3 30 60 80 00       	mov    %eax,0x806030
  803fff:	a1 38 60 80 00       	mov    0x806038,%eax
  804004:	40                   	inc    %eax
  804005:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80400a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80400e:	75 17                	jne    804027 <realloc_block_FF+0x1c1>
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	68 53 50 80 00       	push   $0x805053
  804018:	68 f7 01 00 00       	push   $0x1f7
  80401d:	68 71 50 80 00       	push   $0x805071
  804022:	e8 59 cf ff ff       	call   800f80 <_panic>
  804027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402a:	8b 00                	mov    (%eax),%eax
  80402c:	85 c0                	test   %eax,%eax
  80402e:	74 10                	je     804040 <realloc_block_FF+0x1da>
  804030:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804033:	8b 00                	mov    (%eax),%eax
  804035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804038:	8b 52 04             	mov    0x4(%edx),%edx
  80403b:	89 50 04             	mov    %edx,0x4(%eax)
  80403e:	eb 0b                	jmp    80404b <realloc_block_FF+0x1e5>
  804040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804043:	8b 40 04             	mov    0x4(%eax),%eax
  804046:	a3 30 60 80 00       	mov    %eax,0x806030
  80404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404e:	8b 40 04             	mov    0x4(%eax),%eax
  804051:	85 c0                	test   %eax,%eax
  804053:	74 0f                	je     804064 <realloc_block_FF+0x1fe>
  804055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804058:	8b 40 04             	mov    0x4(%eax),%eax
  80405b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80405e:	8b 12                	mov    (%edx),%edx
  804060:	89 10                	mov    %edx,(%eax)
  804062:	eb 0a                	jmp    80406e <realloc_block_FF+0x208>
  804064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804067:	8b 00                	mov    (%eax),%eax
  804069:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80406e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804071:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804081:	a1 38 60 80 00       	mov    0x806038,%eax
  804086:	48                   	dec    %eax
  804087:	a3 38 60 80 00       	mov    %eax,0x806038
  80408c:	e9 83 02 00 00       	jmp    804314 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804091:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804095:	0f 86 69 02 00 00    	jbe    804304 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80409b:	83 ec 04             	sub    $0x4,%esp
  80409e:	6a 01                	push   $0x1
  8040a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8040a3:	ff 75 08             	pushl  0x8(%ebp)
  8040a6:	e8 c8 ed ff ff       	call   802e73 <set_block_data>
  8040ab:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8040ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b1:	83 e8 04             	sub    $0x4,%eax
  8040b4:	8b 00                	mov    (%eax),%eax
  8040b6:	83 e0 fe             	and    $0xfffffffe,%eax
  8040b9:	89 c2                	mov    %eax,%edx
  8040bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040be:	01 d0                	add    %edx,%eax
  8040c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8040c3:	a1 38 60 80 00       	mov    0x806038,%eax
  8040c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8040cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8040cf:	75 68                	jne    804139 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8040d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8040d5:	75 17                	jne    8040ee <realloc_block_FF+0x288>
  8040d7:	83 ec 04             	sub    $0x4,%esp
  8040da:	68 8c 50 80 00       	push   $0x80508c
  8040df:	68 06 02 00 00       	push   $0x206
  8040e4:	68 71 50 80 00       	push   $0x805071
  8040e9:	e8 92 ce ff ff       	call   800f80 <_panic>
  8040ee:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8040f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040f7:	89 10                	mov    %edx,(%eax)
  8040f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040fc:	8b 00                	mov    (%eax),%eax
  8040fe:	85 c0                	test   %eax,%eax
  804100:	74 0d                	je     80410f <realloc_block_FF+0x2a9>
  804102:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804107:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80410a:	89 50 04             	mov    %edx,0x4(%eax)
  80410d:	eb 08                	jmp    804117 <realloc_block_FF+0x2b1>
  80410f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804112:	a3 30 60 80 00       	mov    %eax,0x806030
  804117:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80411a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80411f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804129:	a1 38 60 80 00       	mov    0x806038,%eax
  80412e:	40                   	inc    %eax
  80412f:	a3 38 60 80 00       	mov    %eax,0x806038
  804134:	e9 b0 01 00 00       	jmp    8042e9 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804139:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80413e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804141:	76 68                	jbe    8041ab <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804143:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804147:	75 17                	jne    804160 <realloc_block_FF+0x2fa>
  804149:	83 ec 04             	sub    $0x4,%esp
  80414c:	68 8c 50 80 00       	push   $0x80508c
  804151:	68 0b 02 00 00       	push   $0x20b
  804156:	68 71 50 80 00       	push   $0x805071
  80415b:	e8 20 ce ff ff       	call   800f80 <_panic>
  804160:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804166:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804169:	89 10                	mov    %edx,(%eax)
  80416b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80416e:	8b 00                	mov    (%eax),%eax
  804170:	85 c0                	test   %eax,%eax
  804172:	74 0d                	je     804181 <realloc_block_FF+0x31b>
  804174:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804179:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80417c:	89 50 04             	mov    %edx,0x4(%eax)
  80417f:	eb 08                	jmp    804189 <realloc_block_FF+0x323>
  804181:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804184:	a3 30 60 80 00       	mov    %eax,0x806030
  804189:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80418c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804191:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804194:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80419b:	a1 38 60 80 00       	mov    0x806038,%eax
  8041a0:	40                   	inc    %eax
  8041a1:	a3 38 60 80 00       	mov    %eax,0x806038
  8041a6:	e9 3e 01 00 00       	jmp    8042e9 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8041ab:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8041b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041b3:	73 68                	jae    80421d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041b9:	75 17                	jne    8041d2 <realloc_block_FF+0x36c>
  8041bb:	83 ec 04             	sub    $0x4,%esp
  8041be:	68 c0 50 80 00       	push   $0x8050c0
  8041c3:	68 10 02 00 00       	push   $0x210
  8041c8:	68 71 50 80 00       	push   $0x805071
  8041cd:	e8 ae cd ff ff       	call   800f80 <_panic>
  8041d2:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8041d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041db:	89 50 04             	mov    %edx,0x4(%eax)
  8041de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e1:	8b 40 04             	mov    0x4(%eax),%eax
  8041e4:	85 c0                	test   %eax,%eax
  8041e6:	74 0c                	je     8041f4 <realloc_block_FF+0x38e>
  8041e8:	a1 30 60 80 00       	mov    0x806030,%eax
  8041ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041f0:	89 10                	mov    %edx,(%eax)
  8041f2:	eb 08                	jmp    8041fc <realloc_block_FF+0x396>
  8041f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041ff:	a3 30 60 80 00       	mov    %eax,0x806030
  804204:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804207:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80420d:	a1 38 60 80 00       	mov    0x806038,%eax
  804212:	40                   	inc    %eax
  804213:	a3 38 60 80 00       	mov    %eax,0x806038
  804218:	e9 cc 00 00 00       	jmp    8042e9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80421d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804224:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80422c:	e9 8a 00 00 00       	jmp    8042bb <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804234:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804237:	73 7a                	jae    8042b3 <realloc_block_FF+0x44d>
  804239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80423c:	8b 00                	mov    (%eax),%eax
  80423e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804241:	73 70                	jae    8042b3 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804247:	74 06                	je     80424f <realloc_block_FF+0x3e9>
  804249:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80424d:	75 17                	jne    804266 <realloc_block_FF+0x400>
  80424f:	83 ec 04             	sub    $0x4,%esp
  804252:	68 e4 50 80 00       	push   $0x8050e4
  804257:	68 1a 02 00 00       	push   $0x21a
  80425c:	68 71 50 80 00       	push   $0x805071
  804261:	e8 1a cd ff ff       	call   800f80 <_panic>
  804266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804269:	8b 10                	mov    (%eax),%edx
  80426b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80426e:	89 10                	mov    %edx,(%eax)
  804270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804273:	8b 00                	mov    (%eax),%eax
  804275:	85 c0                	test   %eax,%eax
  804277:	74 0b                	je     804284 <realloc_block_FF+0x41e>
  804279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80427c:	8b 00                	mov    (%eax),%eax
  80427e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804281:	89 50 04             	mov    %edx,0x4(%eax)
  804284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804287:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80428a:	89 10                	mov    %edx,(%eax)
  80428c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80428f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804292:	89 50 04             	mov    %edx,0x4(%eax)
  804295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804298:	8b 00                	mov    (%eax),%eax
  80429a:	85 c0                	test   %eax,%eax
  80429c:	75 08                	jne    8042a6 <realloc_block_FF+0x440>
  80429e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042a1:	a3 30 60 80 00       	mov    %eax,0x806030
  8042a6:	a1 38 60 80 00       	mov    0x806038,%eax
  8042ab:	40                   	inc    %eax
  8042ac:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  8042b1:	eb 36                	jmp    8042e9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8042b3:	a1 34 60 80 00       	mov    0x806034,%eax
  8042b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042bf:	74 07                	je     8042c8 <realloc_block_FF+0x462>
  8042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c4:	8b 00                	mov    (%eax),%eax
  8042c6:	eb 05                	jmp    8042cd <realloc_block_FF+0x467>
  8042c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8042cd:	a3 34 60 80 00       	mov    %eax,0x806034
  8042d2:	a1 34 60 80 00       	mov    0x806034,%eax
  8042d7:	85 c0                	test   %eax,%eax
  8042d9:	0f 85 52 ff ff ff    	jne    804231 <realloc_block_FF+0x3cb>
  8042df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042e3:	0f 85 48 ff ff ff    	jne    804231 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8042e9:	83 ec 04             	sub    $0x4,%esp
  8042ec:	6a 00                	push   $0x0
  8042ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8042f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8042f4:	e8 7a eb ff ff       	call   802e73 <set_block_data>
  8042f9:	83 c4 10             	add    $0x10,%esp
				return va;
  8042fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ff:	e9 7b 02 00 00       	jmp    80457f <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804304:	83 ec 0c             	sub    $0xc,%esp
  804307:	68 61 51 80 00       	push   $0x805161
  80430c:	e8 2c cf ff ff       	call   80123d <cprintf>
  804311:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804314:	8b 45 08             	mov    0x8(%ebp),%eax
  804317:	e9 63 02 00 00       	jmp    80457f <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80431c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80431f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804322:	0f 86 4d 02 00 00    	jbe    804575 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804328:	83 ec 0c             	sub    $0xc,%esp
  80432b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80432e:	e8 08 e8 ff ff       	call   802b3b <is_free_block>
  804333:	83 c4 10             	add    $0x10,%esp
  804336:	84 c0                	test   %al,%al
  804338:	0f 84 37 02 00 00    	je     804575 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80433e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804341:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804344:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804347:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80434a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80434d:	76 38                	jbe    804387 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80434f:	83 ec 0c             	sub    $0xc,%esp
  804352:	ff 75 08             	pushl  0x8(%ebp)
  804355:	e8 0c fa ff ff       	call   803d66 <free_block>
  80435a:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80435d:	83 ec 0c             	sub    $0xc,%esp
  804360:	ff 75 0c             	pushl  0xc(%ebp)
  804363:	e8 3a eb ff ff       	call   802ea2 <alloc_block_FF>
  804368:	83 c4 10             	add    $0x10,%esp
  80436b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80436e:	83 ec 08             	sub    $0x8,%esp
  804371:	ff 75 c0             	pushl  -0x40(%ebp)
  804374:	ff 75 08             	pushl  0x8(%ebp)
  804377:	e8 ab fa ff ff       	call   803e27 <copy_data>
  80437c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80437f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804382:	e9 f8 01 00 00       	jmp    80457f <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80438a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80438d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804390:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804394:	0f 87 a0 00 00 00    	ja     80443a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80439a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80439e:	75 17                	jne    8043b7 <realloc_block_FF+0x551>
  8043a0:	83 ec 04             	sub    $0x4,%esp
  8043a3:	68 53 50 80 00       	push   $0x805053
  8043a8:	68 38 02 00 00       	push   $0x238
  8043ad:	68 71 50 80 00       	push   $0x805071
  8043b2:	e8 c9 cb ff ff       	call   800f80 <_panic>
  8043b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ba:	8b 00                	mov    (%eax),%eax
  8043bc:	85 c0                	test   %eax,%eax
  8043be:	74 10                	je     8043d0 <realloc_block_FF+0x56a>
  8043c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043c8:	8b 52 04             	mov    0x4(%edx),%edx
  8043cb:	89 50 04             	mov    %edx,0x4(%eax)
  8043ce:	eb 0b                	jmp    8043db <realloc_block_FF+0x575>
  8043d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043d3:	8b 40 04             	mov    0x4(%eax),%eax
  8043d6:	a3 30 60 80 00       	mov    %eax,0x806030
  8043db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043de:	8b 40 04             	mov    0x4(%eax),%eax
  8043e1:	85 c0                	test   %eax,%eax
  8043e3:	74 0f                	je     8043f4 <realloc_block_FF+0x58e>
  8043e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e8:	8b 40 04             	mov    0x4(%eax),%eax
  8043eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043ee:	8b 12                	mov    (%edx),%edx
  8043f0:	89 10                	mov    %edx,(%eax)
  8043f2:	eb 0a                	jmp    8043fe <realloc_block_FF+0x598>
  8043f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f7:	8b 00                	mov    (%eax),%eax
  8043f9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80440a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804411:	a1 38 60 80 00       	mov    0x806038,%eax
  804416:	48                   	dec    %eax
  804417:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80441c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80441f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804422:	01 d0                	add    %edx,%eax
  804424:	83 ec 04             	sub    $0x4,%esp
  804427:	6a 01                	push   $0x1
  804429:	50                   	push   %eax
  80442a:	ff 75 08             	pushl  0x8(%ebp)
  80442d:	e8 41 ea ff ff       	call   802e73 <set_block_data>
  804432:	83 c4 10             	add    $0x10,%esp
  804435:	e9 36 01 00 00       	jmp    804570 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80443a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80443d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804440:	01 d0                	add    %edx,%eax
  804442:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804445:	83 ec 04             	sub    $0x4,%esp
  804448:	6a 01                	push   $0x1
  80444a:	ff 75 f0             	pushl  -0x10(%ebp)
  80444d:	ff 75 08             	pushl  0x8(%ebp)
  804450:	e8 1e ea ff ff       	call   802e73 <set_block_data>
  804455:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804458:	8b 45 08             	mov    0x8(%ebp),%eax
  80445b:	83 e8 04             	sub    $0x4,%eax
  80445e:	8b 00                	mov    (%eax),%eax
  804460:	83 e0 fe             	and    $0xfffffffe,%eax
  804463:	89 c2                	mov    %eax,%edx
  804465:	8b 45 08             	mov    0x8(%ebp),%eax
  804468:	01 d0                	add    %edx,%eax
  80446a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80446d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804471:	74 06                	je     804479 <realloc_block_FF+0x613>
  804473:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804477:	75 17                	jne    804490 <realloc_block_FF+0x62a>
  804479:	83 ec 04             	sub    $0x4,%esp
  80447c:	68 e4 50 80 00       	push   $0x8050e4
  804481:	68 44 02 00 00       	push   $0x244
  804486:	68 71 50 80 00       	push   $0x805071
  80448b:	e8 f0 ca ff ff       	call   800f80 <_panic>
  804490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804493:	8b 10                	mov    (%eax),%edx
  804495:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804498:	89 10                	mov    %edx,(%eax)
  80449a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80449d:	8b 00                	mov    (%eax),%eax
  80449f:	85 c0                	test   %eax,%eax
  8044a1:	74 0b                	je     8044ae <realloc_block_FF+0x648>
  8044a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044a6:	8b 00                	mov    (%eax),%eax
  8044a8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8044ab:	89 50 04             	mov    %edx,0x4(%eax)
  8044ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8044b4:	89 10                	mov    %edx,(%eax)
  8044b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044bc:	89 50 04             	mov    %edx,0x4(%eax)
  8044bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044c2:	8b 00                	mov    (%eax),%eax
  8044c4:	85 c0                	test   %eax,%eax
  8044c6:	75 08                	jne    8044d0 <realloc_block_FF+0x66a>
  8044c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044cb:	a3 30 60 80 00       	mov    %eax,0x806030
  8044d0:	a1 38 60 80 00       	mov    0x806038,%eax
  8044d5:	40                   	inc    %eax
  8044d6:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8044db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044df:	75 17                	jne    8044f8 <realloc_block_FF+0x692>
  8044e1:	83 ec 04             	sub    $0x4,%esp
  8044e4:	68 53 50 80 00       	push   $0x805053
  8044e9:	68 45 02 00 00       	push   $0x245
  8044ee:	68 71 50 80 00       	push   $0x805071
  8044f3:	e8 88 ca ff ff       	call   800f80 <_panic>
  8044f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044fb:	8b 00                	mov    (%eax),%eax
  8044fd:	85 c0                	test   %eax,%eax
  8044ff:	74 10                	je     804511 <realloc_block_FF+0x6ab>
  804501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804504:	8b 00                	mov    (%eax),%eax
  804506:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804509:	8b 52 04             	mov    0x4(%edx),%edx
  80450c:	89 50 04             	mov    %edx,0x4(%eax)
  80450f:	eb 0b                	jmp    80451c <realloc_block_FF+0x6b6>
  804511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804514:	8b 40 04             	mov    0x4(%eax),%eax
  804517:	a3 30 60 80 00       	mov    %eax,0x806030
  80451c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80451f:	8b 40 04             	mov    0x4(%eax),%eax
  804522:	85 c0                	test   %eax,%eax
  804524:	74 0f                	je     804535 <realloc_block_FF+0x6cf>
  804526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804529:	8b 40 04             	mov    0x4(%eax),%eax
  80452c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80452f:	8b 12                	mov    (%edx),%edx
  804531:	89 10                	mov    %edx,(%eax)
  804533:	eb 0a                	jmp    80453f <realloc_block_FF+0x6d9>
  804535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804538:	8b 00                	mov    (%eax),%eax
  80453a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80453f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80454b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804552:	a1 38 60 80 00       	mov    0x806038,%eax
  804557:	48                   	dec    %eax
  804558:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80455d:	83 ec 04             	sub    $0x4,%esp
  804560:	6a 00                	push   $0x0
  804562:	ff 75 bc             	pushl  -0x44(%ebp)
  804565:	ff 75 b8             	pushl  -0x48(%ebp)
  804568:	e8 06 e9 ff ff       	call   802e73 <set_block_data>
  80456d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804570:	8b 45 08             	mov    0x8(%ebp),%eax
  804573:	eb 0a                	jmp    80457f <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804575:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80457c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80457f:	c9                   	leave  
  804580:	c3                   	ret    

00804581 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804581:	55                   	push   %ebp
  804582:	89 e5                	mov    %esp,%ebp
  804584:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804587:	83 ec 04             	sub    $0x4,%esp
  80458a:	68 68 51 80 00       	push   $0x805168
  80458f:	68 58 02 00 00       	push   $0x258
  804594:	68 71 50 80 00       	push   $0x805071
  804599:	e8 e2 c9 ff ff       	call   800f80 <_panic>

0080459e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80459e:	55                   	push   %ebp
  80459f:	89 e5                	mov    %esp,%ebp
  8045a1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8045a4:	83 ec 04             	sub    $0x4,%esp
  8045a7:	68 90 51 80 00       	push   $0x805190
  8045ac:	68 61 02 00 00       	push   $0x261
  8045b1:	68 71 50 80 00       	push   $0x805071
  8045b6:	e8 c5 c9 ff ff       	call   800f80 <_panic>
  8045bb:	90                   	nop

008045bc <__udivdi3>:
  8045bc:	55                   	push   %ebp
  8045bd:	57                   	push   %edi
  8045be:	56                   	push   %esi
  8045bf:	53                   	push   %ebx
  8045c0:	83 ec 1c             	sub    $0x1c,%esp
  8045c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8045c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8045cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8045cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8045d3:	89 ca                	mov    %ecx,%edx
  8045d5:	89 f8                	mov    %edi,%eax
  8045d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8045db:	85 f6                	test   %esi,%esi
  8045dd:	75 2d                	jne    80460c <__udivdi3+0x50>
  8045df:	39 cf                	cmp    %ecx,%edi
  8045e1:	77 65                	ja     804648 <__udivdi3+0x8c>
  8045e3:	89 fd                	mov    %edi,%ebp
  8045e5:	85 ff                	test   %edi,%edi
  8045e7:	75 0b                	jne    8045f4 <__udivdi3+0x38>
  8045e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ee:	31 d2                	xor    %edx,%edx
  8045f0:	f7 f7                	div    %edi
  8045f2:	89 c5                	mov    %eax,%ebp
  8045f4:	31 d2                	xor    %edx,%edx
  8045f6:	89 c8                	mov    %ecx,%eax
  8045f8:	f7 f5                	div    %ebp
  8045fa:	89 c1                	mov    %eax,%ecx
  8045fc:	89 d8                	mov    %ebx,%eax
  8045fe:	f7 f5                	div    %ebp
  804600:	89 cf                	mov    %ecx,%edi
  804602:	89 fa                	mov    %edi,%edx
  804604:	83 c4 1c             	add    $0x1c,%esp
  804607:	5b                   	pop    %ebx
  804608:	5e                   	pop    %esi
  804609:	5f                   	pop    %edi
  80460a:	5d                   	pop    %ebp
  80460b:	c3                   	ret    
  80460c:	39 ce                	cmp    %ecx,%esi
  80460e:	77 28                	ja     804638 <__udivdi3+0x7c>
  804610:	0f bd fe             	bsr    %esi,%edi
  804613:	83 f7 1f             	xor    $0x1f,%edi
  804616:	75 40                	jne    804658 <__udivdi3+0x9c>
  804618:	39 ce                	cmp    %ecx,%esi
  80461a:	72 0a                	jb     804626 <__udivdi3+0x6a>
  80461c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804620:	0f 87 9e 00 00 00    	ja     8046c4 <__udivdi3+0x108>
  804626:	b8 01 00 00 00       	mov    $0x1,%eax
  80462b:	89 fa                	mov    %edi,%edx
  80462d:	83 c4 1c             	add    $0x1c,%esp
  804630:	5b                   	pop    %ebx
  804631:	5e                   	pop    %esi
  804632:	5f                   	pop    %edi
  804633:	5d                   	pop    %ebp
  804634:	c3                   	ret    
  804635:	8d 76 00             	lea    0x0(%esi),%esi
  804638:	31 ff                	xor    %edi,%edi
  80463a:	31 c0                	xor    %eax,%eax
  80463c:	89 fa                	mov    %edi,%edx
  80463e:	83 c4 1c             	add    $0x1c,%esp
  804641:	5b                   	pop    %ebx
  804642:	5e                   	pop    %esi
  804643:	5f                   	pop    %edi
  804644:	5d                   	pop    %ebp
  804645:	c3                   	ret    
  804646:	66 90                	xchg   %ax,%ax
  804648:	89 d8                	mov    %ebx,%eax
  80464a:	f7 f7                	div    %edi
  80464c:	31 ff                	xor    %edi,%edi
  80464e:	89 fa                	mov    %edi,%edx
  804650:	83 c4 1c             	add    $0x1c,%esp
  804653:	5b                   	pop    %ebx
  804654:	5e                   	pop    %esi
  804655:	5f                   	pop    %edi
  804656:	5d                   	pop    %ebp
  804657:	c3                   	ret    
  804658:	bd 20 00 00 00       	mov    $0x20,%ebp
  80465d:	89 eb                	mov    %ebp,%ebx
  80465f:	29 fb                	sub    %edi,%ebx
  804661:	89 f9                	mov    %edi,%ecx
  804663:	d3 e6                	shl    %cl,%esi
  804665:	89 c5                	mov    %eax,%ebp
  804667:	88 d9                	mov    %bl,%cl
  804669:	d3 ed                	shr    %cl,%ebp
  80466b:	89 e9                	mov    %ebp,%ecx
  80466d:	09 f1                	or     %esi,%ecx
  80466f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804673:	89 f9                	mov    %edi,%ecx
  804675:	d3 e0                	shl    %cl,%eax
  804677:	89 c5                	mov    %eax,%ebp
  804679:	89 d6                	mov    %edx,%esi
  80467b:	88 d9                	mov    %bl,%cl
  80467d:	d3 ee                	shr    %cl,%esi
  80467f:	89 f9                	mov    %edi,%ecx
  804681:	d3 e2                	shl    %cl,%edx
  804683:	8b 44 24 08          	mov    0x8(%esp),%eax
  804687:	88 d9                	mov    %bl,%cl
  804689:	d3 e8                	shr    %cl,%eax
  80468b:	09 c2                	or     %eax,%edx
  80468d:	89 d0                	mov    %edx,%eax
  80468f:	89 f2                	mov    %esi,%edx
  804691:	f7 74 24 0c          	divl   0xc(%esp)
  804695:	89 d6                	mov    %edx,%esi
  804697:	89 c3                	mov    %eax,%ebx
  804699:	f7 e5                	mul    %ebp
  80469b:	39 d6                	cmp    %edx,%esi
  80469d:	72 19                	jb     8046b8 <__udivdi3+0xfc>
  80469f:	74 0b                	je     8046ac <__udivdi3+0xf0>
  8046a1:	89 d8                	mov    %ebx,%eax
  8046a3:	31 ff                	xor    %edi,%edi
  8046a5:	e9 58 ff ff ff       	jmp    804602 <__udivdi3+0x46>
  8046aa:	66 90                	xchg   %ax,%ax
  8046ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046b0:	89 f9                	mov    %edi,%ecx
  8046b2:	d3 e2                	shl    %cl,%edx
  8046b4:	39 c2                	cmp    %eax,%edx
  8046b6:	73 e9                	jae    8046a1 <__udivdi3+0xe5>
  8046b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8046bb:	31 ff                	xor    %edi,%edi
  8046bd:	e9 40 ff ff ff       	jmp    804602 <__udivdi3+0x46>
  8046c2:	66 90                	xchg   %ax,%ax
  8046c4:	31 c0                	xor    %eax,%eax
  8046c6:	e9 37 ff ff ff       	jmp    804602 <__udivdi3+0x46>
  8046cb:	90                   	nop

008046cc <__umoddi3>:
  8046cc:	55                   	push   %ebp
  8046cd:	57                   	push   %edi
  8046ce:	56                   	push   %esi
  8046cf:	53                   	push   %ebx
  8046d0:	83 ec 1c             	sub    $0x1c,%esp
  8046d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8046d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8046db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8046e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8046e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8046eb:	89 f3                	mov    %esi,%ebx
  8046ed:	89 fa                	mov    %edi,%edx
  8046ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046f3:	89 34 24             	mov    %esi,(%esp)
  8046f6:	85 c0                	test   %eax,%eax
  8046f8:	75 1a                	jne    804714 <__umoddi3+0x48>
  8046fa:	39 f7                	cmp    %esi,%edi
  8046fc:	0f 86 a2 00 00 00    	jbe    8047a4 <__umoddi3+0xd8>
  804702:	89 c8                	mov    %ecx,%eax
  804704:	89 f2                	mov    %esi,%edx
  804706:	f7 f7                	div    %edi
  804708:	89 d0                	mov    %edx,%eax
  80470a:	31 d2                	xor    %edx,%edx
  80470c:	83 c4 1c             	add    $0x1c,%esp
  80470f:	5b                   	pop    %ebx
  804710:	5e                   	pop    %esi
  804711:	5f                   	pop    %edi
  804712:	5d                   	pop    %ebp
  804713:	c3                   	ret    
  804714:	39 f0                	cmp    %esi,%eax
  804716:	0f 87 ac 00 00 00    	ja     8047c8 <__umoddi3+0xfc>
  80471c:	0f bd e8             	bsr    %eax,%ebp
  80471f:	83 f5 1f             	xor    $0x1f,%ebp
  804722:	0f 84 ac 00 00 00    	je     8047d4 <__umoddi3+0x108>
  804728:	bf 20 00 00 00       	mov    $0x20,%edi
  80472d:	29 ef                	sub    %ebp,%edi
  80472f:	89 fe                	mov    %edi,%esi
  804731:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804735:	89 e9                	mov    %ebp,%ecx
  804737:	d3 e0                	shl    %cl,%eax
  804739:	89 d7                	mov    %edx,%edi
  80473b:	89 f1                	mov    %esi,%ecx
  80473d:	d3 ef                	shr    %cl,%edi
  80473f:	09 c7                	or     %eax,%edi
  804741:	89 e9                	mov    %ebp,%ecx
  804743:	d3 e2                	shl    %cl,%edx
  804745:	89 14 24             	mov    %edx,(%esp)
  804748:	89 d8                	mov    %ebx,%eax
  80474a:	d3 e0                	shl    %cl,%eax
  80474c:	89 c2                	mov    %eax,%edx
  80474e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804752:	d3 e0                	shl    %cl,%eax
  804754:	89 44 24 04          	mov    %eax,0x4(%esp)
  804758:	8b 44 24 08          	mov    0x8(%esp),%eax
  80475c:	89 f1                	mov    %esi,%ecx
  80475e:	d3 e8                	shr    %cl,%eax
  804760:	09 d0                	or     %edx,%eax
  804762:	d3 eb                	shr    %cl,%ebx
  804764:	89 da                	mov    %ebx,%edx
  804766:	f7 f7                	div    %edi
  804768:	89 d3                	mov    %edx,%ebx
  80476a:	f7 24 24             	mull   (%esp)
  80476d:	89 c6                	mov    %eax,%esi
  80476f:	89 d1                	mov    %edx,%ecx
  804771:	39 d3                	cmp    %edx,%ebx
  804773:	0f 82 87 00 00 00    	jb     804800 <__umoddi3+0x134>
  804779:	0f 84 91 00 00 00    	je     804810 <__umoddi3+0x144>
  80477f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804783:	29 f2                	sub    %esi,%edx
  804785:	19 cb                	sbb    %ecx,%ebx
  804787:	89 d8                	mov    %ebx,%eax
  804789:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80478d:	d3 e0                	shl    %cl,%eax
  80478f:	89 e9                	mov    %ebp,%ecx
  804791:	d3 ea                	shr    %cl,%edx
  804793:	09 d0                	or     %edx,%eax
  804795:	89 e9                	mov    %ebp,%ecx
  804797:	d3 eb                	shr    %cl,%ebx
  804799:	89 da                	mov    %ebx,%edx
  80479b:	83 c4 1c             	add    $0x1c,%esp
  80479e:	5b                   	pop    %ebx
  80479f:	5e                   	pop    %esi
  8047a0:	5f                   	pop    %edi
  8047a1:	5d                   	pop    %ebp
  8047a2:	c3                   	ret    
  8047a3:	90                   	nop
  8047a4:	89 fd                	mov    %edi,%ebp
  8047a6:	85 ff                	test   %edi,%edi
  8047a8:	75 0b                	jne    8047b5 <__umoddi3+0xe9>
  8047aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8047af:	31 d2                	xor    %edx,%edx
  8047b1:	f7 f7                	div    %edi
  8047b3:	89 c5                	mov    %eax,%ebp
  8047b5:	89 f0                	mov    %esi,%eax
  8047b7:	31 d2                	xor    %edx,%edx
  8047b9:	f7 f5                	div    %ebp
  8047bb:	89 c8                	mov    %ecx,%eax
  8047bd:	f7 f5                	div    %ebp
  8047bf:	89 d0                	mov    %edx,%eax
  8047c1:	e9 44 ff ff ff       	jmp    80470a <__umoddi3+0x3e>
  8047c6:	66 90                	xchg   %ax,%ax
  8047c8:	89 c8                	mov    %ecx,%eax
  8047ca:	89 f2                	mov    %esi,%edx
  8047cc:	83 c4 1c             	add    $0x1c,%esp
  8047cf:	5b                   	pop    %ebx
  8047d0:	5e                   	pop    %esi
  8047d1:	5f                   	pop    %edi
  8047d2:	5d                   	pop    %ebp
  8047d3:	c3                   	ret    
  8047d4:	3b 04 24             	cmp    (%esp),%eax
  8047d7:	72 06                	jb     8047df <__umoddi3+0x113>
  8047d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8047dd:	77 0f                	ja     8047ee <__umoddi3+0x122>
  8047df:	89 f2                	mov    %esi,%edx
  8047e1:	29 f9                	sub    %edi,%ecx
  8047e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8047e7:	89 14 24             	mov    %edx,(%esp)
  8047ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8047f2:	8b 14 24             	mov    (%esp),%edx
  8047f5:	83 c4 1c             	add    $0x1c,%esp
  8047f8:	5b                   	pop    %ebx
  8047f9:	5e                   	pop    %esi
  8047fa:	5f                   	pop    %edi
  8047fb:	5d                   	pop    %ebp
  8047fc:	c3                   	ret    
  8047fd:	8d 76 00             	lea    0x0(%esi),%esi
  804800:	2b 04 24             	sub    (%esp),%eax
  804803:	19 fa                	sbb    %edi,%edx
  804805:	89 d1                	mov    %edx,%ecx
  804807:	89 c6                	mov    %eax,%esi
  804809:	e9 71 ff ff ff       	jmp    80477f <__umoddi3+0xb3>
  80480e:	66 90                	xchg   %ax,%ax
  804810:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804814:	72 ea                	jb     804800 <__umoddi3+0x134>
  804816:	89 d9                	mov    %ebx,%ecx
  804818:	e9 62 ff ff ff       	jmp    80477f <__umoddi3+0xb3>
