
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
  800094:	68 20 49 80 00       	push   $0x804920
  800099:	6a 1a                	push   $0x1a
  80009b:	68 3c 49 80 00       	push   $0x80493c
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
  8000e2:	e8 30 26 00 00       	call   802717 <sys_calculate_free_frames>
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
  8000fe:	e8 5f 26 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 50 49 80 00       	push   $0x804950
  80013f:	6a 39                	push   $0x39
  800141:	68 3c 49 80 00       	push   $0x80493c
  800146:	e8 35 0e 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 12 26 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 b8 49 80 00       	push   $0x8049b8
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 3c 49 80 00       	push   $0x80493c
  800164:	e8 17 0e 00 00       	call   800f80 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 a9 25 00 00       	call   802717 <sys_calculate_free_frames>
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
  80019e:	e8 74 25 00 00       	call   802717 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 e8 49 80 00       	push   $0x8049e8
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 3c 49 80 00       	push   $0x80493c
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
  800274:	68 2c 4a 80 00       	push   $0x804a2c
  800279:	6a 4b                	push   $0x4b
  80027b:	68 3c 49 80 00       	push   $0x80493c
  800280:	e8 fb 0c 00 00       	call   800f80 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 d8 24 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  8002d6:	68 50 49 80 00       	push   $0x804950
  8002db:	6a 50                	push   $0x50
  8002dd:	68 3c 49 80 00       	push   $0x80493c
  8002e2:	e8 99 0c 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 76 24 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 b8 49 80 00       	push   $0x8049b8
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 3c 49 80 00       	push   $0x80493c
  800300:	e8 7b 0c 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 0d 24 00 00       	call   802717 <sys_calculate_free_frames>
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
  800343:	e8 cf 23 00 00       	call   802717 <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 e8 49 80 00       	push   $0x8049e8
  800359:	6a 58                	push   $0x58
  80035b:	68 3c 49 80 00       	push   $0x80493c
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
  80041d:	68 2c 4a 80 00       	push   $0x804a2c
  800422:	6a 61                	push   $0x61
  800424:	68 3c 49 80 00       	push   $0x80493c
  800429:	e8 52 0b 00 00       	call   800f80 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 2f 23 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  800482:	68 50 49 80 00       	push   $0x804950
  800487:	6a 66                	push   $0x66
  800489:	68 3c 49 80 00       	push   $0x80493c
  80048e:	e8 ed 0a 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 ca 22 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 b8 49 80 00       	push   $0x8049b8
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 3c 49 80 00       	push   $0x80493c
  8004ac:	e8 cf 0a 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 61 22 00 00       	call   802717 <sys_calculate_free_frames>
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
  8004ed:	e8 25 22 00 00       	call   802717 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 e8 49 80 00       	push   $0x8049e8
  800503:	6a 6e                	push   $0x6e
  800505:	68 3c 49 80 00       	push   $0x80493c
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
  8005d0:	68 2c 4a 80 00       	push   $0x804a2c
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 3c 49 80 00       	push   $0x80493c
  8005dc:	e8 9f 09 00 00       	call   800f80 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 31 21 00 00       	call   802717 <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 74 21 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  800651:	68 50 49 80 00       	push   $0x804950
  800656:	6a 7d                	push   $0x7d
  800658:	68 3c 49 80 00       	push   $0x80493c
  80065d:	e8 1e 09 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 fb 20 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 b8 49 80 00       	push   $0x8049b8
  800674:	6a 7e                	push   $0x7e
  800676:	68 3c 49 80 00       	push   $0x80493c
  80067b:	e8 00 09 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 dd 20 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  8006ec:	68 50 49 80 00       	push   $0x804950
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 3c 49 80 00       	push   $0x80493c
  8006fb:	e8 80 08 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 5d 20 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 b8 49 80 00       	push   $0x8049b8
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 3c 49 80 00       	push   $0x80493c
  80071c:	e8 5f 08 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 f1 1f 00 00       	call   802717 <sys_calculate_free_frames>
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
  8007c5:	e8 4d 1f 00 00       	call   802717 <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 e8 49 80 00       	push   $0x8049e8
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 3c 49 80 00       	push   $0x80493c
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
  8008c6:	68 2c 4a 80 00       	push   $0x804a2c
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 3c 49 80 00       	push   $0x80493c
  8008d5:	e8 a6 06 00 00       	call   800f80 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 38 1e 00 00       	call   802717 <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 7b 1e 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  80094d:	68 50 49 80 00       	push   $0x804950
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 3c 49 80 00       	push   $0x80493c
  80095c:	e8 1f 06 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 fc 1d 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 b8 49 80 00       	push   $0x8049b8
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 3c 49 80 00       	push   $0x80493c
  80097d:	e8 fe 05 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 db 1d 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 50 49 80 00       	push   $0x804950
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 3c 49 80 00       	push   $0x80493c
  800a0c:	e8 6f 05 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 4c 1d 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 b8 49 80 00       	push   $0x8049b8
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 3c 49 80 00       	push   $0x80493c
  800a2d:	e8 4e 05 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 e0 1c 00 00       	call   802717 <sys_calculate_free_frames>
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
  800aa3:	e8 6f 1c 00 00       	call   802717 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 e8 49 80 00       	push   $0x8049e8
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 3c 49 80 00       	push   $0x80493c
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
  800bfc:	68 2c 4a 80 00       	push   $0x804a2c
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 3c 49 80 00       	push   $0x80493c
  800c0b:	e8 70 03 00 00       	call   800f80 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 4d 1b 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
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
  800c8e:	68 50 49 80 00       	push   $0x804950
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 3c 49 80 00       	push   $0x80493c
  800c9d:	e8 de 02 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 bb 1a 00 00       	call   802762 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 b8 49 80 00       	push   $0x8049b8
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 3c 49 80 00       	push   $0x80493c
  800cbe:	e8 bd 02 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 4f 1a 00 00       	call   802717 <sys_calculate_free_frames>
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
  800d17:	e8 fb 19 00 00       	call   802717 <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 e8 49 80 00       	push   $0x8049e8
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 3c 49 80 00       	push   $0x80493c
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
  800e15:	68 2c 4a 80 00       	push   $0x804a2c
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 3c 49 80 00       	push   $0x80493c
  800e24:	e8 57 01 00 00       	call   800f80 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 4c 4a 80 00       	push   $0x804a4c
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
  800e47:	e8 94 1a 00 00       	call   8028e0 <sys_getenvindex>
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
  800eb5:	e8 aa 17 00 00       	call   802664 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	68 a0 4a 80 00       	push   $0x804aa0
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
  800ee5:	68 c8 4a 80 00       	push   $0x804ac8
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
  800f16:	68 f0 4a 80 00       	push   $0x804af0
  800f1b:	e8 1d 03 00 00       	call   80123d <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f23:	a1 20 60 80 00       	mov    0x806020,%eax
  800f28:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	50                   	push   %eax
  800f32:	68 48 4b 80 00       	push   $0x804b48
  800f37:	e8 01 03 00 00       	call   80123d <cprintf>
  800f3c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	68 a0 4a 80 00       	push   $0x804aa0
  800f47:	e8 f1 02 00 00       	call   80123d <cprintf>
  800f4c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f4f:	e8 2a 17 00 00       	call   80267e <sys_unlock_cons>
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
  800f67:	e8 40 19 00 00       	call   8028ac <sys_destroy_env>
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
  800f78:	e8 95 19 00 00       	call   802912 <sys_exit_env>
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
  800f8f:	a1 50 60 80 00       	mov    0x806050,%eax
  800f94:	85 c0                	test   %eax,%eax
  800f96:	74 16                	je     800fae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f98:	a1 50 60 80 00       	mov    0x806050,%eax
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	50                   	push   %eax
  800fa1:	68 5c 4b 80 00       	push   $0x804b5c
  800fa6:	e8 92 02 00 00       	call   80123d <cprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fae:	a1 00 60 80 00       	mov    0x806000,%eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	68 61 4b 80 00       	push   $0x804b61
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
  800fde:	68 7d 4b 80 00       	push   $0x804b7d
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
  80100d:	68 80 4b 80 00       	push   $0x804b80
  801012:	6a 26                	push   $0x26
  801014:	68 cc 4b 80 00       	push   $0x804bcc
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
  8010e2:	68 d8 4b 80 00       	push   $0x804bd8
  8010e7:	6a 3a                	push   $0x3a
  8010e9:	68 cc 4b 80 00       	push   $0x804bcc
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
  801155:	68 2c 4c 80 00       	push   $0x804c2c
  80115a:	6a 44                	push   $0x44
  80115c:	68 cc 4b 80 00       	push   $0x804bcc
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
  801194:	a0 2c 60 80 00       	mov    0x80602c,%al
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
  8011af:	e8 6e 14 00 00       	call   802622 <sys_cputs>
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
  801209:	a0 2c 60 80 00       	mov    0x80602c,%al
  80120e:	0f b6 c0             	movzbl %al,%eax
  801211:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	50                   	push   %eax
  80121b:	52                   	push   %edx
  80121c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801222:	83 c0 08             	add    $0x8,%eax
  801225:	50                   	push   %eax
  801226:	e8 f7 13 00 00       	call   802622 <sys_cputs>
  80122b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80122e:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
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
  801243:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  801270:	e8 ef 13 00 00       	call   802664 <sys_lock_cons>
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
  801290:	e8 e9 13 00 00       	call   80267e <sys_unlock_cons>
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
  8012da:	e8 dd 33 00 00       	call   8046bc <__udivdi3>
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
  80132a:	e8 9d 34 00 00       	call   8047cc <__umoddi3>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	05 94 4e 80 00       	add    $0x804e94,%eax
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
  801485:	8b 04 85 b8 4e 80 00 	mov    0x804eb8(,%eax,4),%eax
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
  801566:	8b 34 9d 00 4d 80 00 	mov    0x804d00(,%ebx,4),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 19                	jne    80158a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801571:	53                   	push   %ebx
  801572:	68 a5 4e 80 00       	push   $0x804ea5
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
  80158b:	68 ae 4e 80 00       	push   $0x804eae
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
  8015b8:	be b1 4e 80 00       	mov    $0x804eb1,%esi
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
  8017b0:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
			break;
  8017b7:	eb 2c                	jmp    8017e5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8017b9:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  801fc3:	68 28 50 80 00       	push   $0x805028
  801fc8:	68 3f 01 00 00       	push   $0x13f
  801fcd:	68 4a 50 80 00       	push   $0x80504a
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
  801fe3:	e8 e5 0b 00 00       	call   802bcd <sys_sbrk>
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
  80205e:	e8 ee 09 00 00       	call   802a51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 16                	je     80207d <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 2e 0f 00 00       	call   802fa0 <alloc_block_FF>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	e9 8a 01 00 00       	jmp    802207 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80207d:	e8 00 0a 00 00       	call   802a82 <sys_isUHeapPlacementStrategyBESTFIT>
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 84 7d 01 00 00    	je     802207 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 c7 13 00 00       	call   80345c <alloc_block_BF>
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
  8020e0:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
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
  80212d:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
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
  802184:	c7 04 85 60 a0 08 01 	movl   $0x1,0x108a060(,%eax,4)
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
  8021e6:	89 04 95 60 a0 10 01 	mov    %eax,0x110a060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8021ed:	83 ec 08             	sub    $0x8,%esp
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f6:	e8 09 0a 00 00       	call   802c04 <sys_allocate_user_mem>
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
  80223e:	e8 dd 09 00 00       	call   802c20 <get_block_size>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	e8 10 1c 00 00       	call   803e64 <free_block>
  802254:	83 c4 10             	add    $0x10,%esp
		}

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
  802289:	8b 04 85 60 a0 10 01 	mov    0x110a060(,%eax,4),%eax
  802290:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802296:	c1 e0 0c             	shl    $0xc,%eax
  802299:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80229c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022a3:	eb 42                	jmp    8022e7 <free+0xdb>
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
  8022c6:	c7 04 85 60 a0 08 01 	movl   $0x0,0x108a060(,%eax,4)
  8022cd:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	83 ec 08             	sub    $0x8,%esp
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	e8 07 09 00 00       	call   802be8 <sys_free_user_mem>
  8022e1:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8022e4:	ff 45 f4             	incl   -0xc(%ebp)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022ed:	72 b6                	jb     8022a5 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8022ef:	eb 17                	jmp    802308 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	68 58 50 80 00       	push   $0x805058
  8022f9:	68 88 00 00 00       	push   $0x88
  8022fe:	68 82 50 80 00       	push   $0x805082
  802303:	e8 78 ec ff ff       	call   800f80 <_panic>
	}
}
  802308:	90                   	nop
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 28             	sub    $0x28,%esp
  802311:	8b 45 10             	mov    0x10(%ebp),%eax
  802314:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802317:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80231b:	75 0a                	jne    802327 <smalloc+0x1c>
  80231d:	b8 00 00 00 00       	mov    $0x0,%eax
  802322:	e9 ec 00 00 00       	jmp    802413 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	39 d0                	cmp    %edx,%eax
  80233c:	73 02                	jae    802340 <smalloc+0x35>
  80233e:	89 d0                	mov    %edx,%eax
  802340:	83 ec 0c             	sub    $0xc,%esp
  802343:	50                   	push   %eax
  802344:	e8 a4 fc ff ff       	call   801fed <malloc>
  802349:	83 c4 10             	add    $0x10,%esp
  80234c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80234f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802353:	75 0a                	jne    80235f <smalloc+0x54>
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	e9 b4 00 00 00       	jmp    802413 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80235f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802363:	ff 75 ec             	pushl  -0x14(%ebp)
  802366:	50                   	push   %eax
  802367:	ff 75 0c             	pushl  0xc(%ebp)
  80236a:	ff 75 08             	pushl  0x8(%ebp)
  80236d:	e8 7d 04 00 00       	call   8027ef <sys_createSharedObject>
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802378:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80237c:	74 06                	je     802384 <smalloc+0x79>
  80237e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802382:	75 0a                	jne    80238e <smalloc+0x83>
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
  802389:	e9 85 00 00 00       	jmp    802413 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80238e:	83 ec 08             	sub    $0x8,%esp
  802391:	ff 75 ec             	pushl  -0x14(%ebp)
  802394:	68 8e 50 80 00       	push   $0x80508e
  802399:	e8 9f ee ff ff       	call   80123d <cprintf>
  80239e:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8023a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023a4:	a1 20 60 80 00       	mov    0x806020,%eax
  8023a9:	8b 40 78             	mov    0x78(%eax),%eax
  8023ac:	29 c2                	sub    %eax,%edx
  8023ae:	89 d0                	mov    %edx,%eax
  8023b0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023b5:	c1 e8 0c             	shr    $0xc,%eax
  8023b8:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8023be:	42                   	inc    %edx
  8023bf:	89 15 24 60 80 00    	mov    %edx,0x806024
  8023c5:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8023cb:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8023d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d5:	a1 20 60 80 00       	mov    0x806020,%eax
  8023da:	8b 40 78             	mov    0x78(%eax),%eax
  8023dd:	29 c2                	sub    %eax,%edx
  8023df:	89 d0                	mov    %edx,%eax
  8023e1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023e6:	c1 e8 0c             	shr    $0xc,%eax
  8023e9:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  8023f0:	a1 20 60 80 00       	mov    0x806020,%eax
  8023f5:	8b 50 10             	mov    0x10(%eax),%edx
  8023f8:	89 c8                	mov    %ecx,%eax
  8023fa:	c1 e0 02             	shl    $0x2,%eax
  8023fd:	89 c1                	mov    %eax,%ecx
  8023ff:	c1 e1 09             	shl    $0x9,%ecx
  802402:	01 c8                	add    %ecx,%eax
  802404:	01 c2                	add    %eax,%edx
  802406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802409:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80241b:	83 ec 08             	sub    $0x8,%esp
  80241e:	ff 75 0c             	pushl  0xc(%ebp)
  802421:	ff 75 08             	pushl  0x8(%ebp)
  802424:	e8 f0 03 00 00       	call   802819 <sys_getSizeOfSharedObject>
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80242f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802433:	75 0a                	jne    80243f <sget+0x2a>
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	e9 e7 00 00 00       	jmp    802526 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802445:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80244c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	39 d0                	cmp    %edx,%eax
  802454:	73 02                	jae    802458 <sget+0x43>
  802456:	89 d0                	mov    %edx,%eax
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	50                   	push   %eax
  80245c:	e8 8c fb ff ff       	call   801fed <malloc>
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802467:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80246b:	75 0a                	jne    802477 <sget+0x62>
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
  802472:	e9 af 00 00 00       	jmp    802526 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	ff 75 e8             	pushl  -0x18(%ebp)
  80247d:	ff 75 0c             	pushl  0xc(%ebp)
  802480:	ff 75 08             	pushl  0x8(%ebp)
  802483:	e8 ae 03 00 00       	call   802836 <sys_getSharedObject>
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80248e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802491:	a1 20 60 80 00       	mov    0x806020,%eax
  802496:	8b 40 78             	mov    0x78(%eax),%eax
  802499:	29 c2                	sub    %eax,%edx
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024a2:	c1 e8 0c             	shr    $0xc,%eax
  8024a5:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8024ab:	42                   	inc    %edx
  8024ac:	89 15 24 60 80 00    	mov    %edx,0x806024
  8024b2:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8024b8:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8024bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8024c7:	8b 40 78             	mov    0x78(%eax),%eax
  8024ca:	29 c2                	sub    %eax,%edx
  8024cc:	89 d0                	mov    %edx,%eax
  8024ce:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024d3:	c1 e8 0c             	shr    $0xc,%eax
  8024d6:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  8024dd:	a1 20 60 80 00       	mov    0x806020,%eax
  8024e2:	8b 50 10             	mov    0x10(%eax),%edx
  8024e5:	89 c8                	mov    %ecx,%eax
  8024e7:	c1 e0 02             	shl    $0x2,%eax
  8024ea:	89 c1                	mov    %eax,%ecx
  8024ec:	c1 e1 09             	shl    $0x9,%ecx
  8024ef:	01 c8                	add    %ecx,%eax
  8024f1:	01 c2                	add    %eax,%edx
  8024f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f6:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  8024fd:	a1 20 60 80 00       	mov    0x806020,%eax
  802502:	8b 40 10             	mov    0x10(%eax),%eax
  802505:	83 ec 08             	sub    $0x8,%esp
  802508:	50                   	push   %eax
  802509:	68 9d 50 80 00       	push   $0x80509d
  80250e:	e8 2a ed ff ff       	call   80123d <cprintf>
  802513:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802516:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80251a:	75 07                	jne    802523 <sget+0x10e>
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
  802521:	eb 03                	jmp    802526 <sget+0x111>
	return ptr;
  802523:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80252e:	8b 55 08             	mov    0x8(%ebp),%edx
  802531:	a1 20 60 80 00       	mov    0x806020,%eax
  802536:	8b 40 78             	mov    0x78(%eax),%eax
  802539:	29 c2                	sub    %eax,%edx
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802542:	c1 e8 0c             	shr    $0xc,%eax
  802545:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  80254c:	a1 20 60 80 00       	mov    0x806020,%eax
  802551:	8b 50 10             	mov    0x10(%eax),%edx
  802554:	89 c8                	mov    %ecx,%eax
  802556:	c1 e0 02             	shl    $0x2,%eax
  802559:	89 c1                	mov    %eax,%ecx
  80255b:	c1 e1 09             	shl    $0x9,%ecx
  80255e:	01 c8                	add    %ecx,%eax
  802560:	01 d0                	add    %edx,%eax
  802562:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802569:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80256c:	83 ec 08             	sub    $0x8,%esp
  80256f:	ff 75 08             	pushl  0x8(%ebp)
  802572:	ff 75 f4             	pushl  -0xc(%ebp)
  802575:	e8 db 02 00 00       	call   802855 <sys_freeSharedObject>
  80257a:	83 c4 10             	add    $0x10,%esp
  80257d:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802580:	90                   	nop
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 ac 50 80 00       	push   $0x8050ac
  802591:	68 e5 00 00 00       	push   $0xe5
  802596:	68 82 50 80 00       	push   $0x805082
  80259b:	e8 e0 e9 ff ff       	call   800f80 <_panic>

008025a0 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025a6:	83 ec 04             	sub    $0x4,%esp
  8025a9:	68 d2 50 80 00       	push   $0x8050d2
  8025ae:	68 f1 00 00 00       	push   $0xf1
  8025b3:	68 82 50 80 00       	push   $0x805082
  8025b8:	e8 c3 e9 ff ff       	call   800f80 <_panic>

008025bd <shrink>:

}
void shrink(uint32 newSize)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 d2 50 80 00       	push   $0x8050d2
  8025cb:	68 f6 00 00 00       	push   $0xf6
  8025d0:	68 82 50 80 00       	push   $0x805082
  8025d5:	e8 a6 e9 ff ff       	call   800f80 <_panic>

008025da <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 d2 50 80 00       	push   $0x8050d2
  8025e8:	68 fb 00 00 00       	push   $0xfb
  8025ed:	68 82 50 80 00       	push   $0x805082
  8025f2:	e8 89 e9 ff ff       	call   800f80 <_panic>

008025f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	57                   	push   %edi
  8025fb:	56                   	push   %esi
  8025fc:	53                   	push   %ebx
  8025fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	8b 55 0c             	mov    0xc(%ebp),%edx
  802606:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802609:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80260c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80260f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802612:	cd 30                	int    $0x30
  802614:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80261a:	83 c4 10             	add    $0x10,%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5f                   	pop    %edi
  802620:	5d                   	pop    %ebp
  802621:	c3                   	ret    

00802622 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 04             	sub    $0x4,%esp
  802628:	8b 45 10             	mov    0x10(%ebp),%eax
  80262b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80262e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	52                   	push   %edx
  80263a:	ff 75 0c             	pushl  0xc(%ebp)
  80263d:	50                   	push   %eax
  80263e:	6a 00                	push   $0x0
  802640:	e8 b2 ff ff ff       	call   8025f7 <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
}
  802648:	90                   	nop
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_cgetc>:

int
sys_cgetc(void)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 02                	push   $0x2
  80265a:	e8 98 ff ff ff       	call   8025f7 <syscall>
  80265f:	83 c4 18             	add    $0x18,%esp
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 03                	push   $0x3
  802673:	e8 7f ff ff ff       	call   8025f7 <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	90                   	nop
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 04                	push   $0x4
  80268d:	e8 65 ff ff ff       	call   8025f7 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
}
  802695:	90                   	nop
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80269b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	52                   	push   %edx
  8026a8:	50                   	push   %eax
  8026a9:	6a 08                	push   $0x8
  8026ab:	e8 47 ff ff ff       	call   8025f7 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	56                   	push   %esi
  8026b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8026bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	56                   	push   %esi
  8026ca:	53                   	push   %ebx
  8026cb:	51                   	push   %ecx
  8026cc:	52                   	push   %edx
  8026cd:	50                   	push   %eax
  8026ce:	6a 09                	push   $0x9
  8026d0:	e8 22 ff ff ff       	call   8025f7 <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026db:	5b                   	pop    %ebx
  8026dc:	5e                   	pop    %esi
  8026dd:	5d                   	pop    %ebp
  8026de:	c3                   	ret    

008026df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	52                   	push   %edx
  8026ef:	50                   	push   %eax
  8026f0:	6a 0a                	push   $0xa
  8026f2:	e8 00 ff ff ff       	call   8025f7 <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	ff 75 0c             	pushl  0xc(%ebp)
  802708:	ff 75 08             	pushl  0x8(%ebp)
  80270b:	6a 0b                	push   $0xb
  80270d:	e8 e5 fe ff ff       	call   8025f7 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 0c                	push   $0xc
  802726:	e8 cc fe ff ff       	call   8025f7 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 0d                	push   $0xd
  80273f:	e8 b3 fe ff ff       	call   8025f7 <syscall>
  802744:	83 c4 18             	add    $0x18,%esp
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 0e                	push   $0xe
  802758:	e8 9a fe ff ff       	call   8025f7 <syscall>
  80275d:	83 c4 18             	add    $0x18,%esp
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 0f                	push   $0xf
  802771:	e8 81 fe ff ff       	call   8025f7 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	6a 10                	push   $0x10
  80278b:	e8 67 fe ff ff       	call   8025f7 <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 11                	push   $0x11
  8027a4:	e8 4e fe ff ff       	call   8025f7 <syscall>
  8027a9:	83 c4 18             	add    $0x18,%esp
}
  8027ac:	90                   	nop
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <sys_cputc>:

void
sys_cputc(const char c)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 04             	sub    $0x4,%esp
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	50                   	push   %eax
  8027c8:	6a 01                	push   $0x1
  8027ca:	e8 28 fe ff ff       	call   8025f7 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	90                   	nop
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 14                	push   $0x14
  8027e4:	e8 0e fe ff ff       	call   8025f7 <syscall>
  8027e9:	83 c4 18             	add    $0x18,%esp
}
  8027ec:	90                   	nop
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	6a 00                	push   $0x0
  802807:	51                   	push   %ecx
  802808:	52                   	push   %edx
  802809:	ff 75 0c             	pushl  0xc(%ebp)
  80280c:	50                   	push   %eax
  80280d:	6a 15                	push   $0x15
  80280f:	e8 e3 fd ff ff       	call   8025f7 <syscall>
  802814:	83 c4 18             	add    $0x18,%esp
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	52                   	push   %edx
  802829:	50                   	push   %eax
  80282a:	6a 16                	push   $0x16
  80282c:	e8 c6 fd ff ff       	call   8025f7 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80283c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	51                   	push   %ecx
  802847:	52                   	push   %edx
  802848:	50                   	push   %eax
  802849:	6a 17                	push   $0x17
  80284b:	e8 a7 fd ff ff       	call   8025f7 <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
}
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	52                   	push   %edx
  802865:	50                   	push   %eax
  802866:	6a 18                	push   $0x18
  802868:	e8 8a fd ff ff       	call   8025f7 <syscall>
  80286d:	83 c4 18             	add    $0x18,%esp
}
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	6a 00                	push   $0x0
  80287a:	ff 75 14             	pushl  0x14(%ebp)
  80287d:	ff 75 10             	pushl  0x10(%ebp)
  802880:	ff 75 0c             	pushl  0xc(%ebp)
  802883:	50                   	push   %eax
  802884:	6a 19                	push   $0x19
  802886:	e8 6c fd ff ff       	call   8025f7 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	50                   	push   %eax
  80289f:	6a 1a                	push   $0x1a
  8028a1:	e8 51 fd ff ff       	call   8025f7 <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
}
  8028a9:	90                   	nop
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	50                   	push   %eax
  8028bb:	6a 1b                	push   $0x1b
  8028bd:	e8 35 fd ff ff       	call   8025f7 <syscall>
  8028c2:	83 c4 18             	add    $0x18,%esp
}
  8028c5:	c9                   	leave  
  8028c6:	c3                   	ret    

008028c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028c7:	55                   	push   %ebp
  8028c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 05                	push   $0x5
  8028d6:	e8 1c fd ff ff       	call   8025f7 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 06                	push   $0x6
  8028ef:	e8 03 fd ff ff       	call   8025f7 <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 07                	push   $0x7
  802908:	e8 ea fc ff ff       	call   8025f7 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <sys_exit_env>:


void sys_exit_env(void)
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 1c                	push   $0x1c
  802921:	e8 d1 fc ff ff       	call   8025f7 <syscall>
  802926:	83 c4 18             	add    $0x18,%esp
}
  802929:	90                   	nop
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802932:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802935:	8d 50 04             	lea    0x4(%eax),%edx
  802938:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	52                   	push   %edx
  802942:	50                   	push   %eax
  802943:	6a 1d                	push   $0x1d
  802945:	e8 ad fc ff ff       	call   8025f7 <syscall>
  80294a:	83 c4 18             	add    $0x18,%esp
	return result;
  80294d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802950:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802953:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802956:	89 01                	mov    %eax,(%ecx)
  802958:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	c9                   	leave  
  80295f:	c2 04 00             	ret    $0x4

00802962 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	ff 75 10             	pushl  0x10(%ebp)
  80296c:	ff 75 0c             	pushl  0xc(%ebp)
  80296f:	ff 75 08             	pushl  0x8(%ebp)
  802972:	6a 13                	push   $0x13
  802974:	e8 7e fc ff ff       	call   8025f7 <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
	return ;
  80297c:	90                   	nop
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <sys_rcr2>:
uint32 sys_rcr2()
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	6a 00                	push   $0x0
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 1e                	push   $0x1e
  80298e:	e8 64 fc ff ff       	call   8025f7 <syscall>
  802993:	83 c4 18             	add    $0x18,%esp
}
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
  80299b:	83 ec 04             	sub    $0x4,%esp
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029a4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	50                   	push   %eax
  8029b1:	6a 1f                	push   $0x1f
  8029b3:	e8 3f fc ff ff       	call   8025f7 <syscall>
  8029b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8029bb:	90                   	nop
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <rsttst>:
void rsttst()
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 21                	push   $0x21
  8029cd:	e8 25 fc ff ff       	call   8025f7 <syscall>
  8029d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d5:	90                   	nop
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	8b 45 14             	mov    0x14(%ebp),%eax
  8029e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8029e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029eb:	52                   	push   %edx
  8029ec:	50                   	push   %eax
  8029ed:	ff 75 10             	pushl  0x10(%ebp)
  8029f0:	ff 75 0c             	pushl  0xc(%ebp)
  8029f3:	ff 75 08             	pushl  0x8(%ebp)
  8029f6:	6a 20                	push   $0x20
  8029f8:	e8 fa fb ff ff       	call   8025f7 <syscall>
  8029fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802a00:	90                   	nop
}
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <chktst>:
void chktst(uint32 n)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	ff 75 08             	pushl  0x8(%ebp)
  802a11:	6a 22                	push   $0x22
  802a13:	e8 df fb ff ff       	call   8025f7 <syscall>
  802a18:	83 c4 18             	add    $0x18,%esp
	return ;
  802a1b:	90                   	nop
}
  802a1c:	c9                   	leave  
  802a1d:	c3                   	ret    

00802a1e <inctst>:

void inctst()
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 23                	push   $0x23
  802a2d:	e8 c5 fb ff ff       	call   8025f7 <syscall>
  802a32:	83 c4 18             	add    $0x18,%esp
	return ;
  802a35:	90                   	nop
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <gettst>:
uint32 gettst()
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 24                	push   $0x24
  802a47:	e8 ab fb ff ff       	call   8025f7 <syscall>
  802a4c:	83 c4 18             	add    $0x18,%esp
}
  802a4f:	c9                   	leave  
  802a50:	c3                   	ret    

00802a51 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a51:	55                   	push   %ebp
  802a52:	89 e5                	mov    %esp,%ebp
  802a54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 25                	push   $0x25
  802a63:	e8 8f fb ff ff       	call   8025f7 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
  802a6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a6e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a72:	75 07                	jne    802a7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a74:	b8 01 00 00 00       	mov    $0x1,%eax
  802a79:	eb 05                	jmp    802a80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
  802a85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 25                	push   $0x25
  802a94:	e8 5e fb ff ff       	call   8025f7 <syscall>
  802a99:	83 c4 18             	add    $0x18,%esp
  802a9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a9f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802aa3:	75 07                	jne    802aac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802aa5:	b8 01 00 00 00       	mov    $0x1,%eax
  802aaa:	eb 05                	jmp    802ab1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 25                	push   $0x25
  802ac5:	e8 2d fb ff ff       	call   8025f7 <syscall>
  802aca:	83 c4 18             	add    $0x18,%esp
  802acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802ad0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802ad4:	75 07                	jne    802add <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  802adb:	eb 05                	jmp    802ae2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

00802ae4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
  802ae7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aea:	6a 00                	push   $0x0
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 25                	push   $0x25
  802af6:	e8 fc fa ff ff       	call   8025f7 <syscall>
  802afb:	83 c4 18             	add    $0x18,%esp
  802afe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b01:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b05:	75 07                	jne    802b0e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b07:	b8 01 00 00 00       	mov    $0x1,%eax
  802b0c:	eb 05                	jmp    802b13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b13:	c9                   	leave  
  802b14:	c3                   	ret    

00802b15 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	ff 75 08             	pushl  0x8(%ebp)
  802b23:	6a 26                	push   $0x26
  802b25:	e8 cd fa ff ff       	call   8025f7 <syscall>
  802b2a:	83 c4 18             	add    $0x18,%esp
	return ;
  802b2d:	90                   	nop
}
  802b2e:	c9                   	leave  
  802b2f:	c3                   	ret    

00802b30 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	6a 00                	push   $0x0
  802b42:	53                   	push   %ebx
  802b43:	51                   	push   %ecx
  802b44:	52                   	push   %edx
  802b45:	50                   	push   %eax
  802b46:	6a 27                	push   $0x27
  802b48:	e8 aa fa ff ff       	call   8025f7 <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
}
  802b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	52                   	push   %edx
  802b65:	50                   	push   %eax
  802b66:	6a 28                	push   $0x28
  802b68:	e8 8a fa ff ff       	call   8025f7 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
}
  802b70:	c9                   	leave  
  802b71:	c3                   	ret    

00802b72 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b72:	55                   	push   %ebp
  802b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	6a 00                	push   $0x0
  802b80:	51                   	push   %ecx
  802b81:	ff 75 10             	pushl  0x10(%ebp)
  802b84:	52                   	push   %edx
  802b85:	50                   	push   %eax
  802b86:	6a 29                	push   $0x29
  802b88:	e8 6a fa ff ff       	call   8025f7 <syscall>
  802b8d:	83 c4 18             	add    $0x18,%esp
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    

00802b92 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	ff 75 10             	pushl  0x10(%ebp)
  802b9c:	ff 75 0c             	pushl  0xc(%ebp)
  802b9f:	ff 75 08             	pushl  0x8(%ebp)
  802ba2:	6a 12                	push   $0x12
  802ba4:	e8 4e fa ff ff       	call   8025f7 <syscall>
  802ba9:	83 c4 18             	add    $0x18,%esp
	return ;
  802bac:	90                   	nop
}
  802bad:	c9                   	leave  
  802bae:	c3                   	ret    

00802baf <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802baf:	55                   	push   %ebp
  802bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	52                   	push   %edx
  802bbf:	50                   	push   %eax
  802bc0:	6a 2a                	push   $0x2a
  802bc2:	e8 30 fa ff ff       	call   8025f7 <syscall>
  802bc7:	83 c4 18             	add    $0x18,%esp
	return;
  802bca:	90                   	nop
}
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    

00802bcd <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802bcd:	55                   	push   %ebp
  802bce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	50                   	push   %eax
  802bdc:	6a 2b                	push   $0x2b
  802bde:	e8 14 fa ff ff       	call   8025f7 <syscall>
  802be3:	83 c4 18             	add    $0x18,%esp
}
  802be6:	c9                   	leave  
  802be7:	c3                   	ret    

00802be8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	ff 75 0c             	pushl  0xc(%ebp)
  802bf4:	ff 75 08             	pushl  0x8(%ebp)
  802bf7:	6a 2c                	push   $0x2c
  802bf9:	e8 f9 f9 ff ff       	call   8025f7 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
	return;
  802c01:	90                   	nop
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	ff 75 0c             	pushl  0xc(%ebp)
  802c10:	ff 75 08             	pushl  0x8(%ebp)
  802c13:	6a 2d                	push   $0x2d
  802c15:	e8 dd f9 ff ff       	call   8025f7 <syscall>
  802c1a:	83 c4 18             	add    $0x18,%esp
	return;
  802c1d:	90                   	nop
}
  802c1e:	c9                   	leave  
  802c1f:	c3                   	ret    

00802c20 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	83 e8 04             	sub    $0x4,%eax
  802c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c37:	c9                   	leave  
  802c38:	c3                   	ret    

00802c39 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c39:	55                   	push   %ebp
  802c3a:	89 e5                	mov    %esp,%ebp
  802c3c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	83 e8 04             	sub    $0x4,%eax
  802c45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	83 e0 01             	and    $0x1,%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	0f 94 c0             	sete   %al
}
  802c55:	c9                   	leave  
  802c56:	c3                   	ret    

00802c57 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
  802c5a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c67:	83 f8 02             	cmp    $0x2,%eax
  802c6a:	74 2b                	je     802c97 <alloc_block+0x40>
  802c6c:	83 f8 02             	cmp    $0x2,%eax
  802c6f:	7f 07                	jg     802c78 <alloc_block+0x21>
  802c71:	83 f8 01             	cmp    $0x1,%eax
  802c74:	74 0e                	je     802c84 <alloc_block+0x2d>
  802c76:	eb 58                	jmp    802cd0 <alloc_block+0x79>
  802c78:	83 f8 03             	cmp    $0x3,%eax
  802c7b:	74 2d                	je     802caa <alloc_block+0x53>
  802c7d:	83 f8 04             	cmp    $0x4,%eax
  802c80:	74 3b                	je     802cbd <alloc_block+0x66>
  802c82:	eb 4c                	jmp    802cd0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c84:	83 ec 0c             	sub    $0xc,%esp
  802c87:	ff 75 08             	pushl  0x8(%ebp)
  802c8a:	e8 11 03 00 00       	call   802fa0 <alloc_block_FF>
  802c8f:	83 c4 10             	add    $0x10,%esp
  802c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c95:	eb 4a                	jmp    802ce1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	e8 fa 19 00 00       	call   80469c <alloc_block_NF>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ca8:	eb 37                	jmp    802ce1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802caa:	83 ec 0c             	sub    $0xc,%esp
  802cad:	ff 75 08             	pushl  0x8(%ebp)
  802cb0:	e8 a7 07 00 00       	call   80345c <alloc_block_BF>
  802cb5:	83 c4 10             	add    $0x10,%esp
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cbb:	eb 24                	jmp    802ce1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	ff 75 08             	pushl  0x8(%ebp)
  802cc3:	e8 b7 19 00 00       	call   80467f <alloc_block_WF>
  802cc8:	83 c4 10             	add    $0x10,%esp
  802ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cce:	eb 11                	jmp    802ce1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802cd0:	83 ec 0c             	sub    $0xc,%esp
  802cd3:	68 e4 50 80 00       	push   $0x8050e4
  802cd8:	e8 60 e5 ff ff       	call   80123d <cprintf>
  802cdd:	83 c4 10             	add    $0x10,%esp
		break;
  802ce0:	90                   	nop
	}
	return va;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	53                   	push   %ebx
  802cea:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	68 04 51 80 00       	push   $0x805104
  802cf5:	e8 43 e5 ff ff       	call   80123d <cprintf>
  802cfa:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802cfd:	83 ec 0c             	sub    $0xc,%esp
  802d00:	68 2f 51 80 00       	push   $0x80512f
  802d05:	e8 33 e5 ff ff       	call   80123d <cprintf>
  802d0a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d13:	eb 37                	jmp    802d4c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802d15:	83 ec 0c             	sub    $0xc,%esp
  802d18:	ff 75 f4             	pushl  -0xc(%ebp)
  802d1b:	e8 19 ff ff ff       	call   802c39 <is_free_block>
  802d20:	83 c4 10             	add    $0x10,%esp
  802d23:	0f be d8             	movsbl %al,%ebx
  802d26:	83 ec 0c             	sub    $0xc,%esp
  802d29:	ff 75 f4             	pushl  -0xc(%ebp)
  802d2c:	e8 ef fe ff ff       	call   802c20 <get_block_size>
  802d31:	83 c4 10             	add    $0x10,%esp
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	53                   	push   %ebx
  802d38:	50                   	push   %eax
  802d39:	68 47 51 80 00       	push   $0x805147
  802d3e:	e8 fa e4 ff ff       	call   80123d <cprintf>
  802d43:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d46:	8b 45 10             	mov    0x10(%ebp),%eax
  802d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d50:	74 07                	je     802d59 <print_blocks_list+0x73>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	eb 05                	jmp    802d5e <print_blocks_list+0x78>
  802d59:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5e:	89 45 10             	mov    %eax,0x10(%ebp)
  802d61:	8b 45 10             	mov    0x10(%ebp),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	75 ad                	jne    802d15 <print_blocks_list+0x2f>
  802d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6c:	75 a7                	jne    802d15 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	68 04 51 80 00       	push   $0x805104
  802d76:	e8 c2 e4 ff ff       	call   80123d <cprintf>
  802d7b:	83 c4 10             	add    $0x10,%esp

}
  802d7e:	90                   	nop
  802d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d82:	c9                   	leave  
  802d83:	c3                   	ret    

00802d84 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802d84:	55                   	push   %ebp
  802d85:	89 e5                	mov    %esp,%ebp
  802d87:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8d:	83 e0 01             	and    $0x1,%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 03                	je     802d97 <initialize_dynamic_allocator+0x13>
  802d94:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802d97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d9b:	0f 84 c7 01 00 00    	je     802f68 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802da1:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802da8:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802dab:	8b 55 08             	mov    0x8(%ebp),%edx
  802dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db1:	01 d0                	add    %edx,%eax
  802db3:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802db8:	0f 87 ad 01 00 00    	ja     802f6b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	0f 89 a5 01 00 00    	jns    802f6e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcf:	01 d0                	add    %edx,%eax
  802dd1:	83 e8 04             	sub    $0x4,%eax
  802dd4:	a3 48 60 80 00       	mov    %eax,0x806048
     struct BlockElement * element = NULL;
  802dd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802de0:	a1 30 60 80 00       	mov    0x806030,%eax
  802de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de8:	e9 87 00 00 00       	jmp    802e74 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df1:	75 14                	jne    802e07 <initialize_dynamic_allocator+0x83>
  802df3:	83 ec 04             	sub    $0x4,%esp
  802df6:	68 5f 51 80 00       	push   $0x80515f
  802dfb:	6a 79                	push   $0x79
  802dfd:	68 7d 51 80 00       	push   $0x80517d
  802e02:	e8 79 e1 ff ff       	call   800f80 <_panic>
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 10                	je     802e20 <initialize_dynamic_allocator+0x9c>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e18:	8b 52 04             	mov    0x4(%edx),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	eb 0b                	jmp    802e2b <initialize_dynamic_allocator+0xa7>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	a3 34 60 80 00       	mov    %eax,0x806034
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 04             	mov    0x4(%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 0f                	je     802e44 <initialize_dynamic_allocator+0xc0>
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3e:	8b 12                	mov    (%edx),%edx
  802e40:	89 10                	mov    %edx,(%eax)
  802e42:	eb 0a                	jmp    802e4e <initialize_dynamic_allocator+0xca>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	a3 30 60 80 00       	mov    %eax,0x806030
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e61:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802e66:	48                   	dec    %eax
  802e67:	a3 3c 60 80 00       	mov    %eax,0x80603c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802e6c:	a1 38 60 80 00       	mov    0x806038,%eax
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e78:	74 07                	je     802e81 <initialize_dynamic_allocator+0xfd>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	eb 05                	jmp    802e86 <initialize_dynamic_allocator+0x102>
  802e81:	b8 00 00 00 00       	mov    $0x0,%eax
  802e86:	a3 38 60 80 00       	mov    %eax,0x806038
  802e8b:	a1 38 60 80 00       	mov    0x806038,%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	0f 85 55 ff ff ff    	jne    802ded <initialize_dynamic_allocator+0x69>
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9c:	0f 85 4b ff ff ff    	jne    802ded <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802eb1:	a1 48 60 80 00       	mov    0x806048,%eax
  802eb6:	a3 44 60 80 00       	mov    %eax,0x806044
    end_block->info = 1;
  802ebb:	a1 44 60 80 00       	mov    0x806044,%eax
  802ec0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	83 c0 08             	add    $0x8,%eax
  802ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	83 c0 04             	add    $0x4,%eax
  802ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed8:	83 ea 08             	sub    $0x8,%edx
  802edb:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	01 d0                	add    %edx,%eax
  802ee5:	83 e8 08             	sub    $0x8,%eax
  802ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eeb:	83 ea 08             	sub    $0x8,%edx
  802eee:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802f03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f07:	75 17                	jne    802f20 <initialize_dynamic_allocator+0x19c>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 98 51 80 00       	push   $0x805198
  802f11:	68 90 00 00 00       	push   $0x90
  802f16:	68 7d 51 80 00       	push   $0x80517d
  802f1b:	e8 60 e0 ff ff       	call   800f80 <_panic>
  802f20:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0d                	je     802f41 <initialize_dynamic_allocator+0x1bd>
  802f34:	a1 30 60 80 00       	mov    0x806030,%eax
  802f39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 08                	jmp    802f49 <initialize_dynamic_allocator+0x1c5>
  802f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f44:	a3 34 60 80 00       	mov    %eax,0x806034
  802f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4c:	a3 30 60 80 00       	mov    %eax,0x806030
  802f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802f66:	eb 07                	jmp    802f6f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f68:	90                   	nop
  802f69:	eb 04                	jmp    802f6f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802f6b:	90                   	nop
  802f6c:	eb 01                	jmp    802f6f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802f6e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802f6f:	c9                   	leave  
  802f70:	c3                   	ret    

00802f71 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802f74:	8b 45 10             	mov    0x10(%ebp),%eax
  802f77:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f83:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	83 e8 04             	sub    $0x4,%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	83 e0 fe             	and    $0xfffffffe,%eax
  802f90:	8d 50 f8             	lea    -0x8(%eax),%edx
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	01 c2                	add    %eax,%edx
  802f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9b:	89 02                	mov    %eax,(%edx)
}
  802f9d:	90                   	nop
  802f9e:	5d                   	pop    %ebp
  802f9f:	c3                   	ret    

00802fa0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
  802fa3:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	83 e0 01             	and    $0x1,%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	74 03                	je     802fb3 <alloc_block_FF+0x13>
  802fb0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fb3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fb7:	77 07                	ja     802fc0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fb9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802fc0:	a1 28 60 80 00       	mov    0x806028,%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	75 73                	jne    80303c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	83 c0 10             	add    $0x10,%eax
  802fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802fd2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802fd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdf:	01 d0                	add    %edx,%eax
  802fe1:	48                   	dec    %eax
  802fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	ba 00 00 00 00       	mov    $0x0,%edx
  802fed:	f7 75 ec             	divl   -0x14(%ebp)
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	29 d0                	sub    %edx,%eax
  802ff5:	c1 e8 0c             	shr    $0xc,%eax
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	50                   	push   %eax
  802ffc:	e8 d6 ef ff ff       	call   801fd7 <sbrk>
  803001:	83 c4 10             	add    $0x10,%esp
  803004:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	6a 00                	push   $0x0
  80300c:	e8 c6 ef ff ff       	call   801fd7 <sbrk>
  803011:	83 c4 10             	add    $0x10,%esp
  803014:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803017:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80301d:	83 ec 08             	sub    $0x8,%esp
  803020:	50                   	push   %eax
  803021:	ff 75 e4             	pushl  -0x1c(%ebp)
  803024:	e8 5b fd ff ff       	call   802d84 <initialize_dynamic_allocator>
  803029:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80302c:	83 ec 0c             	sub    $0xc,%esp
  80302f:	68 bb 51 80 00       	push   $0x8051bb
  803034:	e8 04 e2 ff ff       	call   80123d <cprintf>
  803039:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80303c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803040:	75 0a                	jne    80304c <alloc_block_FF+0xac>
	        return NULL;
  803042:	b8 00 00 00 00       	mov    $0x0,%eax
  803047:	e9 0e 04 00 00       	jmp    80345a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80304c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803053:	a1 30 60 80 00       	mov    0x806030,%eax
  803058:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305b:	e9 f3 02 00 00       	jmp    803353 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803066:	83 ec 0c             	sub    $0xc,%esp
  803069:	ff 75 bc             	pushl  -0x44(%ebp)
  80306c:	e8 af fb ff ff       	call   802c20 <get_block_size>
  803071:	83 c4 10             	add    $0x10,%esp
  803074:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	83 c0 08             	add    $0x8,%eax
  80307d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803080:	0f 87 c5 02 00 00    	ja     80334b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	83 c0 18             	add    $0x18,%eax
  80308c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80308f:	0f 87 19 02 00 00    	ja     8032ae <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803095:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803098:	2b 45 08             	sub    0x8(%ebp),%eax
  80309b:	83 e8 08             	sub    $0x8,%eax
  80309e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	8d 50 08             	lea    0x8(%eax),%edx
  8030a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030aa:	01 d0                	add    %edx,%eax
  8030ac:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	83 c0 08             	add    $0x8,%eax
  8030b5:	83 ec 04             	sub    $0x4,%esp
  8030b8:	6a 01                	push   $0x1
  8030ba:	50                   	push   %eax
  8030bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8030be:	e8 ae fe ff ff       	call   802f71 <set_block_data>
  8030c3:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	75 68                	jne    803138 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030d0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030d4:	75 17                	jne    8030ed <alloc_block_FF+0x14d>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 98 51 80 00       	push   $0x805198
  8030de:	68 d7 00 00 00       	push   $0xd7
  8030e3:	68 7d 51 80 00       	push   $0x80517d
  8030e8:	e8 93 de ff ff       	call   800f80 <_panic>
  8030ed:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8030f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030f6:	89 10                	mov    %edx,(%eax)
  8030f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	74 0d                	je     80310e <alloc_block_FF+0x16e>
  803101:	a1 30 60 80 00       	mov    0x806030,%eax
  803106:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803109:	89 50 04             	mov    %edx,0x4(%eax)
  80310c:	eb 08                	jmp    803116 <alloc_block_FF+0x176>
  80310e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803111:	a3 34 60 80 00       	mov    %eax,0x806034
  803116:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803119:	a3 30 60 80 00       	mov    %eax,0x806030
  80311e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803121:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803128:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803133:	e9 dc 00 00 00       	jmp    803214 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	75 65                	jne    8031a6 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803141:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803145:	75 17                	jne    80315e <alloc_block_FF+0x1be>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 cc 51 80 00       	push   $0x8051cc
  80314f:	68 db 00 00 00       	push   $0xdb
  803154:	68 7d 51 80 00       	push   $0x80517d
  803159:	e8 22 de ff ff       	call   800f80 <_panic>
  80315e:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803164:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 0c                	je     803180 <alloc_block_FF+0x1e0>
  803174:	a1 34 60 80 00       	mov    0x806034,%eax
  803179:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	eb 08                	jmp    803188 <alloc_block_FF+0x1e8>
  803180:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803183:	a3 30 60 80 00       	mov    %eax,0x806030
  803188:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80318b:	a3 34 60 80 00       	mov    %eax,0x806034
  803190:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803199:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8031a4:	eb 6e                	jmp    803214 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8031a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031aa:	74 06                	je     8031b2 <alloc_block_FF+0x212>
  8031ac:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031b0:	75 17                	jne    8031c9 <alloc_block_FF+0x229>
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	68 f0 51 80 00       	push   $0x8051f0
  8031ba:	68 df 00 00 00       	push   $0xdf
  8031bf:	68 7d 51 80 00       	push   $0x80517d
  8031c4:	e8 b7 dd ff ff       	call   800f80 <_panic>
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 10                	mov    (%eax),%edx
  8031ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d1:	89 10                	mov    %edx,(%eax)
  8031d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 0b                	je     8031e7 <alloc_block_FF+0x247>
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031e4:	89 50 04             	mov    %edx,0x4(%eax)
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	75 08                	jne    803209 <alloc_block_FF+0x269>
  803201:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803204:	a3 34 60 80 00       	mov    %eax,0x806034
  803209:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80320e:	40                   	inc    %eax
  80320f:	a3 3c 60 80 00       	mov    %eax,0x80603c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803218:	75 17                	jne    803231 <alloc_block_FF+0x291>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 5f 51 80 00       	push   $0x80515f
  803222:	68 e1 00 00 00       	push   $0xe1
  803227:	68 7d 51 80 00       	push   $0x80517d
  80322c:	e8 4f dd ff ff       	call   800f80 <_panic>
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 00                	mov    (%eax),%eax
  803236:	85 c0                	test   %eax,%eax
  803238:	74 10                	je     80324a <alloc_block_FF+0x2aa>
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803242:	8b 52 04             	mov    0x4(%edx),%edx
  803245:	89 50 04             	mov    %edx,0x4(%eax)
  803248:	eb 0b                	jmp    803255 <alloc_block_FF+0x2b5>
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	a3 34 60 80 00       	mov    %eax,0x806034
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 40 04             	mov    0x4(%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 0f                	je     80326e <alloc_block_FF+0x2ce>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 40 04             	mov    0x4(%eax),%eax
  803265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803268:	8b 12                	mov    (%edx),%edx
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	eb 0a                	jmp    803278 <alloc_block_FF+0x2d8>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	a3 30 60 80 00       	mov    %eax,0x806030
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803290:	48                   	dec    %eax
  803291:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(new_block_va, remaining_size, 0);
  803296:	83 ec 04             	sub    $0x4,%esp
  803299:	6a 00                	push   $0x0
  80329b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80329e:	ff 75 b0             	pushl  -0x50(%ebp)
  8032a1:	e8 cb fc ff ff       	call   802f71 <set_block_data>
  8032a6:	83 c4 10             	add    $0x10,%esp
  8032a9:	e9 95 00 00 00       	jmp    803343 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	6a 01                	push   $0x1
  8032b3:	ff 75 b8             	pushl  -0x48(%ebp)
  8032b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8032b9:	e8 b3 fc ff ff       	call   802f71 <set_block_data>
  8032be:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8032c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c5:	75 17                	jne    8032de <alloc_block_FF+0x33e>
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	68 5f 51 80 00       	push   $0x80515f
  8032cf:	68 e8 00 00 00       	push   $0xe8
  8032d4:	68 7d 51 80 00       	push   $0x80517d
  8032d9:	e8 a2 dc ff ff       	call   800f80 <_panic>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	74 10                	je     8032f7 <alloc_block_FF+0x357>
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ef:	8b 52 04             	mov    0x4(%edx),%edx
  8032f2:	89 50 04             	mov    %edx,0x4(%eax)
  8032f5:	eb 0b                	jmp    803302 <alloc_block_FF+0x362>
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	a3 34 60 80 00       	mov    %eax,0x806034
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	85 c0                	test   %eax,%eax
  80330a:	74 0f                	je     80331b <alloc_block_FF+0x37b>
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 04             	mov    0x4(%eax),%eax
  803312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803315:	8b 12                	mov    (%edx),%edx
  803317:	89 10                	mov    %edx,(%eax)
  803319:	eb 0a                	jmp    803325 <alloc_block_FF+0x385>
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	a3 30 60 80 00       	mov    %eax,0x806030
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803338:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80333d:	48                   	dec    %eax
  80333e:	a3 3c 60 80 00       	mov    %eax,0x80603c
	            }
	            return va;
  803343:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803346:	e9 0f 01 00 00       	jmp    80345a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80334b:	a1 38 60 80 00       	mov    0x806038,%eax
  803350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803357:	74 07                	je     803360 <alloc_block_FF+0x3c0>
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	eb 05                	jmp    803365 <alloc_block_FF+0x3c5>
  803360:	b8 00 00 00 00       	mov    $0x0,%eax
  803365:	a3 38 60 80 00       	mov    %eax,0x806038
  80336a:	a1 38 60 80 00       	mov    0x806038,%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	0f 85 e9 fc ff ff    	jne    803060 <alloc_block_FF+0xc0>
  803377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337b:	0f 85 df fc ff ff    	jne    803060 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	83 c0 08             	add    $0x8,%eax
  803387:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80338a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803391:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803397:	01 d0                	add    %edx,%eax
  803399:	48                   	dec    %eax
  80339a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80339d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8033a5:	f7 75 d8             	divl   -0x28(%ebp)
  8033a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ab:	29 d0                	sub    %edx,%eax
  8033ad:	c1 e8 0c             	shr    $0xc,%eax
  8033b0:	83 ec 0c             	sub    $0xc,%esp
  8033b3:	50                   	push   %eax
  8033b4:	e8 1e ec ff ff       	call   801fd7 <sbrk>
  8033b9:	83 c4 10             	add    $0x10,%esp
  8033bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8033bf:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8033c3:	75 0a                	jne    8033cf <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8033c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ca:	e9 8b 00 00 00       	jmp    80345a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033cf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8033d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033dc:	01 d0                	add    %edx,%eax
  8033de:	48                   	dec    %eax
  8033df:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8033e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ea:	f7 75 cc             	divl   -0x34(%ebp)
  8033ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f0:	29 d0                	sub    %edx,%eax
  8033f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033f8:	01 d0                	add    %edx,%eax
  8033fa:	a3 44 60 80 00       	mov    %eax,0x806044
			end_block->info = 1;
  8033ff:	a1 44 60 80 00       	mov    0x806044,%eax
  803404:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80340a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803411:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803414:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803417:	01 d0                	add    %edx,%eax
  803419:	48                   	dec    %eax
  80341a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80341d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803420:	ba 00 00 00 00       	mov    $0x0,%edx
  803425:	f7 75 c4             	divl   -0x3c(%ebp)
  803428:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80342b:	29 d0                	sub    %edx,%eax
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	6a 01                	push   $0x1
  803432:	50                   	push   %eax
  803433:	ff 75 d0             	pushl  -0x30(%ebp)
  803436:	e8 36 fb ff ff       	call   802f71 <set_block_data>
  80343b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80343e:	83 ec 0c             	sub    $0xc,%esp
  803441:	ff 75 d0             	pushl  -0x30(%ebp)
  803444:	e8 1b 0a 00 00       	call   803e64 <free_block>
  803449:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80344c:	83 ec 0c             	sub    $0xc,%esp
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	e8 49 fb ff ff       	call   802fa0 <alloc_block_FF>
  803457:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
  80345f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	83 e0 01             	and    $0x1,%eax
  803468:	85 c0                	test   %eax,%eax
  80346a:	74 03                	je     80346f <alloc_block_BF+0x13>
  80346c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80346f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803473:	77 07                	ja     80347c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803475:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80347c:	a1 28 60 80 00       	mov    0x806028,%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	75 73                	jne    8034f8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	83 c0 10             	add    $0x10,%eax
  80348b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80348e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803495:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349b:	01 d0                	add    %edx,%eax
  80349d:	48                   	dec    %eax
  80349e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a9:	f7 75 e0             	divl   -0x20(%ebp)
  8034ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034af:	29 d0                	sub    %edx,%eax
  8034b1:	c1 e8 0c             	shr    $0xc,%eax
  8034b4:	83 ec 0c             	sub    $0xc,%esp
  8034b7:	50                   	push   %eax
  8034b8:	e8 1a eb ff ff       	call   801fd7 <sbrk>
  8034bd:	83 c4 10             	add    $0x10,%esp
  8034c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034c3:	83 ec 0c             	sub    $0xc,%esp
  8034c6:	6a 00                	push   $0x0
  8034c8:	e8 0a eb ff ff       	call   801fd7 <sbrk>
  8034cd:	83 c4 10             	add    $0x10,%esp
  8034d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8034d9:	83 ec 08             	sub    $0x8,%esp
  8034dc:	50                   	push   %eax
  8034dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8034e0:	e8 9f f8 ff ff       	call   802d84 <initialize_dynamic_allocator>
  8034e5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8034e8:	83 ec 0c             	sub    $0xc,%esp
  8034eb:	68 bb 51 80 00       	push   $0x8051bb
  8034f0:	e8 48 dd ff ff       	call   80123d <cprintf>
  8034f5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8034f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8034ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803506:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80350d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803514:	a1 30 60 80 00       	mov    0x806030,%eax
  803519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351c:	e9 1d 01 00 00       	jmp    80363e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803527:	83 ec 0c             	sub    $0xc,%esp
  80352a:	ff 75 a8             	pushl  -0x58(%ebp)
  80352d:	e8 ee f6 ff ff       	call   802c20 <get_block_size>
  803532:	83 c4 10             	add    $0x10,%esp
  803535:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	83 c0 08             	add    $0x8,%eax
  80353e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803541:	0f 87 ef 00 00 00    	ja     803636 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	83 c0 18             	add    $0x18,%eax
  80354d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803550:	77 1d                	ja     80356f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803558:	0f 86 d8 00 00 00    	jbe    803636 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80355e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803561:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803564:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80356a:	e9 c7 00 00 00       	jmp    803636 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	83 c0 08             	add    $0x8,%eax
  803575:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803578:	0f 85 9d 00 00 00    	jne    80361b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80357e:	83 ec 04             	sub    $0x4,%esp
  803581:	6a 01                	push   $0x1
  803583:	ff 75 a4             	pushl  -0x5c(%ebp)
  803586:	ff 75 a8             	pushl  -0x58(%ebp)
  803589:	e8 e3 f9 ff ff       	call   802f71 <set_block_data>
  80358e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803595:	75 17                	jne    8035ae <alloc_block_BF+0x152>
  803597:	83 ec 04             	sub    $0x4,%esp
  80359a:	68 5f 51 80 00       	push   $0x80515f
  80359f:	68 2c 01 00 00       	push   $0x12c
  8035a4:	68 7d 51 80 00       	push   $0x80517d
  8035a9:	e8 d2 d9 ff ff       	call   800f80 <_panic>
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	74 10                	je     8035c7 <alloc_block_BF+0x16b>
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035bf:	8b 52 04             	mov    0x4(%edx),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%eax)
  8035c5:	eb 0b                	jmp    8035d2 <alloc_block_BF+0x176>
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 40 04             	mov    0x4(%eax),%eax
  8035cd:	a3 34 60 80 00       	mov    %eax,0x806034
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 04             	mov    0x4(%eax),%eax
  8035d8:	85 c0                	test   %eax,%eax
  8035da:	74 0f                	je     8035eb <alloc_block_BF+0x18f>
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	8b 40 04             	mov    0x4(%eax),%eax
  8035e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e5:	8b 12                	mov    (%edx),%edx
  8035e7:	89 10                	mov    %edx,(%eax)
  8035e9:	eb 0a                	jmp    8035f5 <alloc_block_BF+0x199>
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	a3 30 60 80 00       	mov    %eax,0x806030
  8035f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803608:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80360d:	48                   	dec    %eax
  80360e:	a3 3c 60 80 00       	mov    %eax,0x80603c
					return va;
  803613:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803616:	e9 24 04 00 00       	jmp    803a3f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80361b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803621:	76 13                	jbe    803636 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803623:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80362a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803630:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803633:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803636:	a1 38 60 80 00       	mov    0x806038,%eax
  80363b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80363e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803642:	74 07                	je     80364b <alloc_block_BF+0x1ef>
  803644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	eb 05                	jmp    803650 <alloc_block_BF+0x1f4>
  80364b:	b8 00 00 00 00       	mov    $0x0,%eax
  803650:	a3 38 60 80 00       	mov    %eax,0x806038
  803655:	a1 38 60 80 00       	mov    0x806038,%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	0f 85 bf fe ff ff    	jne    803521 <alloc_block_BF+0xc5>
  803662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803666:	0f 85 b5 fe ff ff    	jne    803521 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80366c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803670:	0f 84 26 02 00 00    	je     80389c <alloc_block_BF+0x440>
  803676:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80367a:	0f 85 1c 02 00 00    	jne    80389c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803683:	2b 45 08             	sub    0x8(%ebp),%eax
  803686:	83 e8 08             	sub    $0x8,%eax
  803689:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	8d 50 08             	lea    0x8(%eax),%edx
  803692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803695:	01 d0                	add    %edx,%eax
  803697:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	83 c0 08             	add    $0x8,%eax
  8036a0:	83 ec 04             	sub    $0x4,%esp
  8036a3:	6a 01                	push   $0x1
  8036a5:	50                   	push   %eax
  8036a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8036a9:	e8 c3 f8 ff ff       	call   802f71 <set_block_data>
  8036ae:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b4:	8b 40 04             	mov    0x4(%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	75 68                	jne    803723 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036bf:	75 17                	jne    8036d8 <alloc_block_BF+0x27c>
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	68 98 51 80 00       	push   $0x805198
  8036c9:	68 45 01 00 00       	push   $0x145
  8036ce:	68 7d 51 80 00       	push   $0x80517d
  8036d3:	e8 a8 d8 ff ff       	call   800f80 <_panic>
  8036d8:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8036de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036e1:	89 10                	mov    %edx,(%eax)
  8036e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 0d                	je     8036f9 <alloc_block_BF+0x29d>
  8036ec:	a1 30 60 80 00       	mov    0x806030,%eax
  8036f1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	eb 08                	jmp    803701 <alloc_block_BF+0x2a5>
  8036f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036fc:	a3 34 60 80 00       	mov    %eax,0x806034
  803701:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803704:	a3 30 60 80 00       	mov    %eax,0x806030
  803709:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803718:	40                   	inc    %eax
  803719:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80371e:	e9 dc 00 00 00       	jmp    8037ff <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	75 65                	jne    803791 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80372c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803730:	75 17                	jne    803749 <alloc_block_BF+0x2ed>
  803732:	83 ec 04             	sub    $0x4,%esp
  803735:	68 cc 51 80 00       	push   $0x8051cc
  80373a:	68 4a 01 00 00       	push   $0x14a
  80373f:	68 7d 51 80 00       	push   $0x80517d
  803744:	e8 37 d8 ff ff       	call   800f80 <_panic>
  803749:	8b 15 34 60 80 00    	mov    0x806034,%edx
  80374f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803752:	89 50 04             	mov    %edx,0x4(%eax)
  803755:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	85 c0                	test   %eax,%eax
  80375d:	74 0c                	je     80376b <alloc_block_BF+0x30f>
  80375f:	a1 34 60 80 00       	mov    0x806034,%eax
  803764:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803767:	89 10                	mov    %edx,(%eax)
  803769:	eb 08                	jmp    803773 <alloc_block_BF+0x317>
  80376b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80376e:	a3 30 60 80 00       	mov    %eax,0x806030
  803773:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803776:	a3 34 60 80 00       	mov    %eax,0x806034
  80377b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80377e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803784:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803789:	40                   	inc    %eax
  80378a:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80378f:	eb 6e                	jmp    8037ff <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803795:	74 06                	je     80379d <alloc_block_BF+0x341>
  803797:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80379b:	75 17                	jne    8037b4 <alloc_block_BF+0x358>
  80379d:	83 ec 04             	sub    $0x4,%esp
  8037a0:	68 f0 51 80 00       	push   $0x8051f0
  8037a5:	68 4f 01 00 00       	push   $0x14f
  8037aa:	68 7d 51 80 00       	push   $0x80517d
  8037af:	e8 cc d7 ff ff       	call   800f80 <_panic>
  8037b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b7:	8b 10                	mov    (%eax),%edx
  8037b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037bc:	89 10                	mov    %edx,(%eax)
  8037be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0b                	je     8037d2 <alloc_block_BF+0x376>
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037d8:	89 10                	mov    %edx,(%eax)
  8037da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	75 08                	jne    8037f4 <alloc_block_BF+0x398>
  8037ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ef:	a3 34 60 80 00       	mov    %eax,0x806034
  8037f4:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8037f9:	40                   	inc    %eax
  8037fa:	a3 3c 60 80 00       	mov    %eax,0x80603c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8037ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803803:	75 17                	jne    80381c <alloc_block_BF+0x3c0>
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	68 5f 51 80 00       	push   $0x80515f
  80380d:	68 51 01 00 00       	push   $0x151
  803812:	68 7d 51 80 00       	push   $0x80517d
  803817:	e8 64 d7 ff ff       	call   800f80 <_panic>
  80381c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	85 c0                	test   %eax,%eax
  803823:	74 10                	je     803835 <alloc_block_BF+0x3d9>
  803825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80382d:	8b 52 04             	mov    0x4(%edx),%edx
  803830:	89 50 04             	mov    %edx,0x4(%eax)
  803833:	eb 0b                	jmp    803840 <alloc_block_BF+0x3e4>
  803835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	a3 34 60 80 00       	mov    %eax,0x806034
  803840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803843:	8b 40 04             	mov    0x4(%eax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	74 0f                	je     803859 <alloc_block_BF+0x3fd>
  80384a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384d:	8b 40 04             	mov    0x4(%eax),%eax
  803850:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803853:	8b 12                	mov    (%edx),%edx
  803855:	89 10                	mov    %edx,(%eax)
  803857:	eb 0a                	jmp    803863 <alloc_block_BF+0x407>
  803859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385c:	8b 00                	mov    (%eax),%eax
  80385e:	a3 30 60 80 00       	mov    %eax,0x806030
  803863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803866:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803876:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80387b:	48                   	dec    %eax
  80387c:	a3 3c 60 80 00       	mov    %eax,0x80603c
			set_block_data(new_block_va, remaining_size, 0);
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	6a 00                	push   $0x0
  803886:	ff 75 d0             	pushl  -0x30(%ebp)
  803889:	ff 75 cc             	pushl  -0x34(%ebp)
  80388c:	e8 e0 f6 ff ff       	call   802f71 <set_block_data>
  803891:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803897:	e9 a3 01 00 00       	jmp    803a3f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80389c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8038a0:	0f 85 9d 00 00 00    	jne    803943 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8038a6:	83 ec 04             	sub    $0x4,%esp
  8038a9:	6a 01                	push   $0x1
  8038ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8038ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b1:	e8 bb f6 ff ff       	call   802f71 <set_block_data>
  8038b6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8038b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038bd:	75 17                	jne    8038d6 <alloc_block_BF+0x47a>
  8038bf:	83 ec 04             	sub    $0x4,%esp
  8038c2:	68 5f 51 80 00       	push   $0x80515f
  8038c7:	68 58 01 00 00       	push   $0x158
  8038cc:	68 7d 51 80 00       	push   $0x80517d
  8038d1:	e8 aa d6 ff ff       	call   800f80 <_panic>
  8038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	74 10                	je     8038ef <alloc_block_BF+0x493>
  8038df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ea:	89 50 04             	mov    %edx,0x4(%eax)
  8038ed:	eb 0b                	jmp    8038fa <alloc_block_BF+0x49e>
  8038ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f2:	8b 40 04             	mov    0x4(%eax),%eax
  8038f5:	a3 34 60 80 00       	mov    %eax,0x806034
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	8b 40 04             	mov    0x4(%eax),%eax
  803900:	85 c0                	test   %eax,%eax
  803902:	74 0f                	je     803913 <alloc_block_BF+0x4b7>
  803904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80390d:	8b 12                	mov    (%edx),%edx
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	eb 0a                	jmp    80391d <alloc_block_BF+0x4c1>
  803913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	a3 30 60 80 00       	mov    %eax,0x806030
  80391d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803930:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803935:	48                   	dec    %eax
  803936:	a3 3c 60 80 00       	mov    %eax,0x80603c
		return best_va;
  80393b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393e:	e9 fc 00 00 00       	jmp    803a3f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	83 c0 08             	add    $0x8,%eax
  803949:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80394c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803953:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803956:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803959:	01 d0                	add    %edx,%eax
  80395b:	48                   	dec    %eax
  80395c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80395f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803962:	ba 00 00 00 00       	mov    $0x0,%edx
  803967:	f7 75 c4             	divl   -0x3c(%ebp)
  80396a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80396d:	29 d0                	sub    %edx,%eax
  80396f:	c1 e8 0c             	shr    $0xc,%eax
  803972:	83 ec 0c             	sub    $0xc,%esp
  803975:	50                   	push   %eax
  803976:	e8 5c e6 ff ff       	call   801fd7 <sbrk>
  80397b:	83 c4 10             	add    $0x10,%esp
  80397e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803981:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803985:	75 0a                	jne    803991 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803987:	b8 00 00 00 00       	mov    $0x0,%eax
  80398c:	e9 ae 00 00 00       	jmp    803a3f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803991:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803998:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80399b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80399e:	01 d0                	add    %edx,%eax
  8039a0:	48                   	dec    %eax
  8039a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8039a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8039ac:	f7 75 b8             	divl   -0x48(%ebp)
  8039af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039b2:	29 d0                	sub    %edx,%eax
  8039b4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8039b7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8039ba:	01 d0                	add    %edx,%eax
  8039bc:	a3 44 60 80 00       	mov    %eax,0x806044
				end_block->info = 1;
  8039c1:	a1 44 60 80 00       	mov    0x806044,%eax
  8039c6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8039cc:	83 ec 0c             	sub    $0xc,%esp
  8039cf:	68 24 52 80 00       	push   $0x805224
  8039d4:	e8 64 d8 ff ff       	call   80123d <cprintf>
  8039d9:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8039dc:	83 ec 08             	sub    $0x8,%esp
  8039df:	ff 75 bc             	pushl  -0x44(%ebp)
  8039e2:	68 29 52 80 00       	push   $0x805229
  8039e7:	e8 51 d8 ff ff       	call   80123d <cprintf>
  8039ec:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8039ef:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8039f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039fc:	01 d0                	add    %edx,%eax
  8039fe:	48                   	dec    %eax
  8039ff:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a02:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a05:	ba 00 00 00 00       	mov    $0x0,%edx
  803a0a:	f7 75 b0             	divl   -0x50(%ebp)
  803a0d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a10:	29 d0                	sub    %edx,%eax
  803a12:	83 ec 04             	sub    $0x4,%esp
  803a15:	6a 01                	push   $0x1
  803a17:	50                   	push   %eax
  803a18:	ff 75 bc             	pushl  -0x44(%ebp)
  803a1b:	e8 51 f5 ff ff       	call   802f71 <set_block_data>
  803a20:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803a23:	83 ec 0c             	sub    $0xc,%esp
  803a26:	ff 75 bc             	pushl  -0x44(%ebp)
  803a29:	e8 36 04 00 00       	call   803e64 <free_block>
  803a2e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803a31:	83 ec 0c             	sub    $0xc,%esp
  803a34:	ff 75 08             	pushl  0x8(%ebp)
  803a37:	e8 20 fa ff ff       	call   80345c <alloc_block_BF>
  803a3c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a3f:	c9                   	leave  
  803a40:	c3                   	ret    

00803a41 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a41:	55                   	push   %ebp
  803a42:	89 e5                	mov    %esp,%ebp
  803a44:	53                   	push   %ebx
  803a45:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5a:	74 1e                	je     803a7a <merging+0x39>
  803a5c:	ff 75 08             	pushl  0x8(%ebp)
  803a5f:	e8 bc f1 ff ff       	call   802c20 <get_block_size>
  803a64:	83 c4 04             	add    $0x4,%esp
  803a67:	89 c2                	mov    %eax,%edx
  803a69:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6c:	01 d0                	add    %edx,%eax
  803a6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803a71:	75 07                	jne    803a7a <merging+0x39>
		prev_is_free = 1;
  803a73:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803a7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a7e:	74 1e                	je     803a9e <merging+0x5d>
  803a80:	ff 75 10             	pushl  0x10(%ebp)
  803a83:	e8 98 f1 ff ff       	call   802c20 <get_block_size>
  803a88:	83 c4 04             	add    $0x4,%esp
  803a8b:	89 c2                	mov    %eax,%edx
  803a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  803a90:	01 d0                	add    %edx,%eax
  803a92:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a95:	75 07                	jne    803a9e <merging+0x5d>
		next_is_free = 1;
  803a97:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa2:	0f 84 cc 00 00 00    	je     803b74 <merging+0x133>
  803aa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aac:	0f 84 c2 00 00 00    	je     803b74 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803ab2:	ff 75 08             	pushl  0x8(%ebp)
  803ab5:	e8 66 f1 ff ff       	call   802c20 <get_block_size>
  803aba:	83 c4 04             	add    $0x4,%esp
  803abd:	89 c3                	mov    %eax,%ebx
  803abf:	ff 75 10             	pushl  0x10(%ebp)
  803ac2:	e8 59 f1 ff ff       	call   802c20 <get_block_size>
  803ac7:	83 c4 04             	add    $0x4,%esp
  803aca:	01 c3                	add    %eax,%ebx
  803acc:	ff 75 0c             	pushl  0xc(%ebp)
  803acf:	e8 4c f1 ff ff       	call   802c20 <get_block_size>
  803ad4:	83 c4 04             	add    $0x4,%esp
  803ad7:	01 d8                	add    %ebx,%eax
  803ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803adc:	6a 00                	push   $0x0
  803ade:	ff 75 ec             	pushl  -0x14(%ebp)
  803ae1:	ff 75 08             	pushl  0x8(%ebp)
  803ae4:	e8 88 f4 ff ff       	call   802f71 <set_block_data>
  803ae9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803aec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803af0:	75 17                	jne    803b09 <merging+0xc8>
  803af2:	83 ec 04             	sub    $0x4,%esp
  803af5:	68 5f 51 80 00       	push   $0x80515f
  803afa:	68 7d 01 00 00       	push   $0x17d
  803aff:	68 7d 51 80 00       	push   $0x80517d
  803b04:	e8 77 d4 ff ff       	call   800f80 <_panic>
  803b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	74 10                	je     803b22 <merging+0xe1>
  803b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b15:	8b 00                	mov    (%eax),%eax
  803b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b1a:	8b 52 04             	mov    0x4(%edx),%edx
  803b1d:	89 50 04             	mov    %edx,0x4(%eax)
  803b20:	eb 0b                	jmp    803b2d <merging+0xec>
  803b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b25:	8b 40 04             	mov    0x4(%eax),%eax
  803b28:	a3 34 60 80 00       	mov    %eax,0x806034
  803b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b30:	8b 40 04             	mov    0x4(%eax),%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	74 0f                	je     803b46 <merging+0x105>
  803b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3a:	8b 40 04             	mov    0x4(%eax),%eax
  803b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b40:	8b 12                	mov    (%edx),%edx
  803b42:	89 10                	mov    %edx,(%eax)
  803b44:	eb 0a                	jmp    803b50 <merging+0x10f>
  803b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b49:	8b 00                	mov    (%eax),%eax
  803b4b:	a3 30 60 80 00       	mov    %eax,0x806030
  803b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b63:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803b68:	48                   	dec    %eax
  803b69:	a3 3c 60 80 00       	mov    %eax,0x80603c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803b6e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b6f:	e9 ea 02 00 00       	jmp    803e5e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b78:	74 3b                	je     803bb5 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803b7a:	83 ec 0c             	sub    $0xc,%esp
  803b7d:	ff 75 08             	pushl  0x8(%ebp)
  803b80:	e8 9b f0 ff ff       	call   802c20 <get_block_size>
  803b85:	83 c4 10             	add    $0x10,%esp
  803b88:	89 c3                	mov    %eax,%ebx
  803b8a:	83 ec 0c             	sub    $0xc,%esp
  803b8d:	ff 75 10             	pushl  0x10(%ebp)
  803b90:	e8 8b f0 ff ff       	call   802c20 <get_block_size>
  803b95:	83 c4 10             	add    $0x10,%esp
  803b98:	01 d8                	add    %ebx,%eax
  803b9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b9d:	83 ec 04             	sub    $0x4,%esp
  803ba0:	6a 00                	push   $0x0
  803ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  803ba5:	ff 75 08             	pushl  0x8(%ebp)
  803ba8:	e8 c4 f3 ff ff       	call   802f71 <set_block_data>
  803bad:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bb0:	e9 a9 02 00 00       	jmp    803e5e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bb9:	0f 84 2d 01 00 00    	je     803cec <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803bbf:	83 ec 0c             	sub    $0xc,%esp
  803bc2:	ff 75 10             	pushl  0x10(%ebp)
  803bc5:	e8 56 f0 ff ff       	call   802c20 <get_block_size>
  803bca:	83 c4 10             	add    $0x10,%esp
  803bcd:	89 c3                	mov    %eax,%ebx
  803bcf:	83 ec 0c             	sub    $0xc,%esp
  803bd2:	ff 75 0c             	pushl  0xc(%ebp)
  803bd5:	e8 46 f0 ff ff       	call   802c20 <get_block_size>
  803bda:	83 c4 10             	add    $0x10,%esp
  803bdd:	01 d8                	add    %ebx,%eax
  803bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803be2:	83 ec 04             	sub    $0x4,%esp
  803be5:	6a 00                	push   $0x0
  803be7:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bea:	ff 75 10             	pushl  0x10(%ebp)
  803bed:	e8 7f f3 ff ff       	call   802f71 <set_block_data>
  803bf2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  803bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803bfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bff:	74 06                	je     803c07 <merging+0x1c6>
  803c01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c05:	75 17                	jne    803c1e <merging+0x1dd>
  803c07:	83 ec 04             	sub    $0x4,%esp
  803c0a:	68 38 52 80 00       	push   $0x805238
  803c0f:	68 8d 01 00 00       	push   $0x18d
  803c14:	68 7d 51 80 00       	push   $0x80517d
  803c19:	e8 62 d3 ff ff       	call   800f80 <_panic>
  803c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c21:	8b 50 04             	mov    0x4(%eax),%edx
  803c24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c27:	89 50 04             	mov    %edx,0x4(%eax)
  803c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c30:	89 10                	mov    %edx,(%eax)
  803c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c35:	8b 40 04             	mov    0x4(%eax),%eax
  803c38:	85 c0                	test   %eax,%eax
  803c3a:	74 0d                	je     803c49 <merging+0x208>
  803c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c3f:	8b 40 04             	mov    0x4(%eax),%eax
  803c42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c45:	89 10                	mov    %edx,(%eax)
  803c47:	eb 08                	jmp    803c51 <merging+0x210>
  803c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c4c:	a3 30 60 80 00       	mov    %eax,0x806030
  803c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c57:	89 50 04             	mov    %edx,0x4(%eax)
  803c5a:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803c5f:	40                   	inc    %eax
  803c60:	a3 3c 60 80 00       	mov    %eax,0x80603c
		LIST_REMOVE(&freeBlocksList, next_block);
  803c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c69:	75 17                	jne    803c82 <merging+0x241>
  803c6b:	83 ec 04             	sub    $0x4,%esp
  803c6e:	68 5f 51 80 00       	push   $0x80515f
  803c73:	68 8e 01 00 00       	push   $0x18e
  803c78:	68 7d 51 80 00       	push   $0x80517d
  803c7d:	e8 fe d2 ff ff       	call   800f80 <_panic>
  803c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	74 10                	je     803c9b <merging+0x25a>
  803c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c93:	8b 52 04             	mov    0x4(%edx),%edx
  803c96:	89 50 04             	mov    %edx,0x4(%eax)
  803c99:	eb 0b                	jmp    803ca6 <merging+0x265>
  803c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	a3 34 60 80 00       	mov    %eax,0x806034
  803ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ca9:	8b 40 04             	mov    0x4(%eax),%eax
  803cac:	85 c0                	test   %eax,%eax
  803cae:	74 0f                	je     803cbf <merging+0x27e>
  803cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb3:	8b 40 04             	mov    0x4(%eax),%eax
  803cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cb9:	8b 12                	mov    (%edx),%edx
  803cbb:	89 10                	mov    %edx,(%eax)
  803cbd:	eb 0a                	jmp    803cc9 <merging+0x288>
  803cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	a3 30 60 80 00       	mov    %eax,0x806030
  803cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdc:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803ce1:	48                   	dec    %eax
  803ce2:	a3 3c 60 80 00       	mov    %eax,0x80603c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ce7:	e9 72 01 00 00       	jmp    803e5e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803cec:	8b 45 10             	mov    0x10(%ebp),%eax
  803cef:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cf6:	74 79                	je     803d71 <merging+0x330>
  803cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cfc:	74 73                	je     803d71 <merging+0x330>
  803cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d02:	74 06                	je     803d0a <merging+0x2c9>
  803d04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d08:	75 17                	jne    803d21 <merging+0x2e0>
  803d0a:	83 ec 04             	sub    $0x4,%esp
  803d0d:	68 f0 51 80 00       	push   $0x8051f0
  803d12:	68 94 01 00 00       	push   $0x194
  803d17:	68 7d 51 80 00       	push   $0x80517d
  803d1c:	e8 5f d2 ff ff       	call   800f80 <_panic>
  803d21:	8b 45 08             	mov    0x8(%ebp),%eax
  803d24:	8b 10                	mov    (%eax),%edx
  803d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d29:	89 10                	mov    %edx,(%eax)
  803d2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2e:	8b 00                	mov    (%eax),%eax
  803d30:	85 c0                	test   %eax,%eax
  803d32:	74 0b                	je     803d3f <merging+0x2fe>
  803d34:	8b 45 08             	mov    0x8(%ebp),%eax
  803d37:	8b 00                	mov    (%eax),%eax
  803d39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d3c:	89 50 04             	mov    %edx,0x4(%eax)
  803d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d45:	89 10                	mov    %edx,(%eax)
  803d47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  803d4d:	89 50 04             	mov    %edx,0x4(%eax)
  803d50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d53:	8b 00                	mov    (%eax),%eax
  803d55:	85 c0                	test   %eax,%eax
  803d57:	75 08                	jne    803d61 <merging+0x320>
  803d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5c:	a3 34 60 80 00       	mov    %eax,0x806034
  803d61:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803d66:	40                   	inc    %eax
  803d67:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803d6c:	e9 ce 00 00 00       	jmp    803e3f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d75:	74 65                	je     803ddc <merging+0x39b>
  803d77:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d7b:	75 17                	jne    803d94 <merging+0x353>
  803d7d:	83 ec 04             	sub    $0x4,%esp
  803d80:	68 cc 51 80 00       	push   $0x8051cc
  803d85:	68 95 01 00 00       	push   $0x195
  803d8a:	68 7d 51 80 00       	push   $0x80517d
  803d8f:	e8 ec d1 ff ff       	call   800f80 <_panic>
  803d94:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803d9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9d:	89 50 04             	mov    %edx,0x4(%eax)
  803da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da3:	8b 40 04             	mov    0x4(%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	74 0c                	je     803db6 <merging+0x375>
  803daa:	a1 34 60 80 00       	mov    0x806034,%eax
  803daf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803db2:	89 10                	mov    %edx,(%eax)
  803db4:	eb 08                	jmp    803dbe <merging+0x37d>
  803db6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db9:	a3 30 60 80 00       	mov    %eax,0x806030
  803dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc1:	a3 34 60 80 00       	mov    %eax,0x806034
  803dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dcf:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803dd4:	40                   	inc    %eax
  803dd5:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803dda:	eb 63                	jmp    803e3f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803ddc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803de0:	75 17                	jne    803df9 <merging+0x3b8>
  803de2:	83 ec 04             	sub    $0x4,%esp
  803de5:	68 98 51 80 00       	push   $0x805198
  803dea:	68 98 01 00 00       	push   $0x198
  803def:	68 7d 51 80 00       	push   $0x80517d
  803df4:	e8 87 d1 ff ff       	call   800f80 <_panic>
  803df9:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803dff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e02:	89 10                	mov    %edx,(%eax)
  803e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e07:	8b 00                	mov    (%eax),%eax
  803e09:	85 c0                	test   %eax,%eax
  803e0b:	74 0d                	je     803e1a <merging+0x3d9>
  803e0d:	a1 30 60 80 00       	mov    0x806030,%eax
  803e12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e15:	89 50 04             	mov    %edx,0x4(%eax)
  803e18:	eb 08                	jmp    803e22 <merging+0x3e1>
  803e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1d:	a3 34 60 80 00       	mov    %eax,0x806034
  803e22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e25:	a3 30 60 80 00       	mov    %eax,0x806030
  803e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e34:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e39:	40                   	inc    %eax
  803e3a:	a3 3c 60 80 00       	mov    %eax,0x80603c
		}
		set_block_data(va, get_block_size(va), 0);
  803e3f:	83 ec 0c             	sub    $0xc,%esp
  803e42:	ff 75 10             	pushl  0x10(%ebp)
  803e45:	e8 d6 ed ff ff       	call   802c20 <get_block_size>
  803e4a:	83 c4 10             	add    $0x10,%esp
  803e4d:	83 ec 04             	sub    $0x4,%esp
  803e50:	6a 00                	push   $0x0
  803e52:	50                   	push   %eax
  803e53:	ff 75 10             	pushl  0x10(%ebp)
  803e56:	e8 16 f1 ff ff       	call   802f71 <set_block_data>
  803e5b:	83 c4 10             	add    $0x10,%esp
	}
}
  803e5e:	90                   	nop
  803e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e62:	c9                   	leave  
  803e63:	c3                   	ret    

00803e64 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e64:	55                   	push   %ebp
  803e65:	89 e5                	mov    %esp,%ebp
  803e67:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803e6a:	a1 30 60 80 00       	mov    0x806030,%eax
  803e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803e72:	a1 34 60 80 00       	mov    0x806034,%eax
  803e77:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e7a:	73 1b                	jae    803e97 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803e7c:	a1 34 60 80 00       	mov    0x806034,%eax
  803e81:	83 ec 04             	sub    $0x4,%esp
  803e84:	ff 75 08             	pushl  0x8(%ebp)
  803e87:	6a 00                	push   $0x0
  803e89:	50                   	push   %eax
  803e8a:	e8 b2 fb ff ff       	call   803a41 <merging>
  803e8f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e92:	e9 8b 00 00 00       	jmp    803f22 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803e97:	a1 30 60 80 00       	mov    0x806030,%eax
  803e9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e9f:	76 18                	jbe    803eb9 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ea1:	a1 30 60 80 00       	mov    0x806030,%eax
  803ea6:	83 ec 04             	sub    $0x4,%esp
  803ea9:	ff 75 08             	pushl  0x8(%ebp)
  803eac:	50                   	push   %eax
  803ead:	6a 00                	push   $0x0
  803eaf:	e8 8d fb ff ff       	call   803a41 <merging>
  803eb4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803eb7:	eb 69                	jmp    803f22 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803eb9:	a1 30 60 80 00       	mov    0x806030,%eax
  803ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ec1:	eb 39                	jmp    803efc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ec9:	73 29                	jae    803ef4 <free_block+0x90>
  803ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ed3:	76 1f                	jbe    803ef4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed8:	8b 00                	mov    (%eax),%eax
  803eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803edd:	83 ec 04             	sub    $0x4,%esp
  803ee0:	ff 75 08             	pushl  0x8(%ebp)
  803ee3:	ff 75 f0             	pushl  -0x10(%ebp)
  803ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  803ee9:	e8 53 fb ff ff       	call   803a41 <merging>
  803eee:	83 c4 10             	add    $0x10,%esp
			break;
  803ef1:	90                   	nop
		}
	}
}
  803ef2:	eb 2e                	jmp    803f22 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ef4:	a1 38 60 80 00       	mov    0x806038,%eax
  803ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f00:	74 07                	je     803f09 <free_block+0xa5>
  803f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f05:	8b 00                	mov    (%eax),%eax
  803f07:	eb 05                	jmp    803f0e <free_block+0xaa>
  803f09:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0e:	a3 38 60 80 00       	mov    %eax,0x806038
  803f13:	a1 38 60 80 00       	mov    0x806038,%eax
  803f18:	85 c0                	test   %eax,%eax
  803f1a:	75 a7                	jne    803ec3 <free_block+0x5f>
  803f1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f20:	75 a1                	jne    803ec3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f22:	90                   	nop
  803f23:	c9                   	leave  
  803f24:	c3                   	ret    

00803f25 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803f25:	55                   	push   %ebp
  803f26:	89 e5                	mov    %esp,%ebp
  803f28:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803f2b:	ff 75 08             	pushl  0x8(%ebp)
  803f2e:	e8 ed ec ff ff       	call   802c20 <get_block_size>
  803f33:	83 c4 04             	add    $0x4,%esp
  803f36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f40:	eb 17                	jmp    803f59 <copy_data+0x34>
  803f42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f48:	01 c2                	add    %eax,%edx
  803f4a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f50:	01 c8                	add    %ecx,%eax
  803f52:	8a 00                	mov    (%eax),%al
  803f54:	88 02                	mov    %al,(%edx)
  803f56:	ff 45 fc             	incl   -0x4(%ebp)
  803f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f5f:	72 e1                	jb     803f42 <copy_data+0x1d>
}
  803f61:	90                   	nop
  803f62:	c9                   	leave  
  803f63:	c3                   	ret    

00803f64 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f64:	55                   	push   %ebp
  803f65:	89 e5                	mov    %esp,%ebp
  803f67:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803f6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f6e:	75 23                	jne    803f93 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803f70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f74:	74 13                	je     803f89 <realloc_block_FF+0x25>
  803f76:	83 ec 0c             	sub    $0xc,%esp
  803f79:	ff 75 0c             	pushl  0xc(%ebp)
  803f7c:	e8 1f f0 ff ff       	call   802fa0 <alloc_block_FF>
  803f81:	83 c4 10             	add    $0x10,%esp
  803f84:	e9 f4 06 00 00       	jmp    80467d <realloc_block_FF+0x719>
		return NULL;
  803f89:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8e:	e9 ea 06 00 00       	jmp    80467d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803f93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f97:	75 18                	jne    803fb1 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803f99:	83 ec 0c             	sub    $0xc,%esp
  803f9c:	ff 75 08             	pushl  0x8(%ebp)
  803f9f:	e8 c0 fe ff ff       	call   803e64 <free_block>
  803fa4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fac:	e9 cc 06 00 00       	jmp    80467d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803fb1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803fb5:	77 07                	ja     803fbe <realloc_block_FF+0x5a>
  803fb7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc1:	83 e0 01             	and    $0x1,%eax
  803fc4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fca:	83 c0 08             	add    $0x8,%eax
  803fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803fd0:	83 ec 0c             	sub    $0xc,%esp
  803fd3:	ff 75 08             	pushl  0x8(%ebp)
  803fd6:	e8 45 ec ff ff       	call   802c20 <get_block_size>
  803fdb:	83 c4 10             	add    $0x10,%esp
  803fde:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fe4:	83 e8 08             	sub    $0x8,%eax
  803fe7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803fea:	8b 45 08             	mov    0x8(%ebp),%eax
  803fed:	83 e8 04             	sub    $0x4,%eax
  803ff0:	8b 00                	mov    (%eax),%eax
  803ff2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ff5:	89 c2                	mov    %eax,%edx
  803ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffa:	01 d0                	add    %edx,%eax
  803ffc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803fff:	83 ec 0c             	sub    $0xc,%esp
  804002:	ff 75 e4             	pushl  -0x1c(%ebp)
  804005:	e8 16 ec ff ff       	call   802c20 <get_block_size>
  80400a:	83 c4 10             	add    $0x10,%esp
  80400d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804010:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804013:	83 e8 08             	sub    $0x8,%eax
  804016:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80401c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80401f:	75 08                	jne    804029 <realloc_block_FF+0xc5>
	{
		 return va;
  804021:	8b 45 08             	mov    0x8(%ebp),%eax
  804024:	e9 54 06 00 00       	jmp    80467d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80402f:	0f 83 e5 03 00 00    	jae    80441a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804038:	2b 45 0c             	sub    0xc(%ebp),%eax
  80403b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80403e:	83 ec 0c             	sub    $0xc,%esp
  804041:	ff 75 e4             	pushl  -0x1c(%ebp)
  804044:	e8 f0 eb ff ff       	call   802c39 <is_free_block>
  804049:	83 c4 10             	add    $0x10,%esp
  80404c:	84 c0                	test   %al,%al
  80404e:	0f 84 3b 01 00 00    	je     80418f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804054:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804057:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80405a:	01 d0                	add    %edx,%eax
  80405c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80405f:	83 ec 04             	sub    $0x4,%esp
  804062:	6a 01                	push   $0x1
  804064:	ff 75 f0             	pushl  -0x10(%ebp)
  804067:	ff 75 08             	pushl  0x8(%ebp)
  80406a:	e8 02 ef ff ff       	call   802f71 <set_block_data>
  80406f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804072:	8b 45 08             	mov    0x8(%ebp),%eax
  804075:	83 e8 04             	sub    $0x4,%eax
  804078:	8b 00                	mov    (%eax),%eax
  80407a:	83 e0 fe             	and    $0xfffffffe,%eax
  80407d:	89 c2                	mov    %eax,%edx
  80407f:	8b 45 08             	mov    0x8(%ebp),%eax
  804082:	01 d0                	add    %edx,%eax
  804084:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804087:	83 ec 04             	sub    $0x4,%esp
  80408a:	6a 00                	push   $0x0
  80408c:	ff 75 cc             	pushl  -0x34(%ebp)
  80408f:	ff 75 c8             	pushl  -0x38(%ebp)
  804092:	e8 da ee ff ff       	call   802f71 <set_block_data>
  804097:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80409a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80409e:	74 06                	je     8040a6 <realloc_block_FF+0x142>
  8040a0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8040a4:	75 17                	jne    8040bd <realloc_block_FF+0x159>
  8040a6:	83 ec 04             	sub    $0x4,%esp
  8040a9:	68 f0 51 80 00       	push   $0x8051f0
  8040ae:	68 f6 01 00 00       	push   $0x1f6
  8040b3:	68 7d 51 80 00       	push   $0x80517d
  8040b8:	e8 c3 ce ff ff       	call   800f80 <_panic>
  8040bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c0:	8b 10                	mov    (%eax),%edx
  8040c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040c5:	89 10                	mov    %edx,(%eax)
  8040c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040ca:	8b 00                	mov    (%eax),%eax
  8040cc:	85 c0                	test   %eax,%eax
  8040ce:	74 0b                	je     8040db <realloc_block_FF+0x177>
  8040d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d3:	8b 00                	mov    (%eax),%eax
  8040d5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040d8:	89 50 04             	mov    %edx,0x4(%eax)
  8040db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040de:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040e1:	89 10                	mov    %edx,(%eax)
  8040e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040e9:	89 50 04             	mov    %edx,0x4(%eax)
  8040ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040ef:	8b 00                	mov    (%eax),%eax
  8040f1:	85 c0                	test   %eax,%eax
  8040f3:	75 08                	jne    8040fd <realloc_block_FF+0x199>
  8040f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040f8:	a3 34 60 80 00       	mov    %eax,0x806034
  8040fd:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804102:	40                   	inc    %eax
  804103:	a3 3c 60 80 00       	mov    %eax,0x80603c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804108:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80410c:	75 17                	jne    804125 <realloc_block_FF+0x1c1>
  80410e:	83 ec 04             	sub    $0x4,%esp
  804111:	68 5f 51 80 00       	push   $0x80515f
  804116:	68 f7 01 00 00       	push   $0x1f7
  80411b:	68 7d 51 80 00       	push   $0x80517d
  804120:	e8 5b ce ff ff       	call   800f80 <_panic>
  804125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804128:	8b 00                	mov    (%eax),%eax
  80412a:	85 c0                	test   %eax,%eax
  80412c:	74 10                	je     80413e <realloc_block_FF+0x1da>
  80412e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804131:	8b 00                	mov    (%eax),%eax
  804133:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804136:	8b 52 04             	mov    0x4(%edx),%edx
  804139:	89 50 04             	mov    %edx,0x4(%eax)
  80413c:	eb 0b                	jmp    804149 <realloc_block_FF+0x1e5>
  80413e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804141:	8b 40 04             	mov    0x4(%eax),%eax
  804144:	a3 34 60 80 00       	mov    %eax,0x806034
  804149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414c:	8b 40 04             	mov    0x4(%eax),%eax
  80414f:	85 c0                	test   %eax,%eax
  804151:	74 0f                	je     804162 <realloc_block_FF+0x1fe>
  804153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804156:	8b 40 04             	mov    0x4(%eax),%eax
  804159:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80415c:	8b 12                	mov    (%edx),%edx
  80415e:	89 10                	mov    %edx,(%eax)
  804160:	eb 0a                	jmp    80416c <realloc_block_FF+0x208>
  804162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804165:	8b 00                	mov    (%eax),%eax
  804167:	a3 30 60 80 00       	mov    %eax,0x806030
  80416c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80416f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80417f:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804184:	48                   	dec    %eax
  804185:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80418a:	e9 83 02 00 00       	jmp    804412 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80418f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804193:	0f 86 69 02 00 00    	jbe    804402 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804199:	83 ec 04             	sub    $0x4,%esp
  80419c:	6a 01                	push   $0x1
  80419e:	ff 75 f0             	pushl  -0x10(%ebp)
  8041a1:	ff 75 08             	pushl  0x8(%ebp)
  8041a4:	e8 c8 ed ff ff       	call   802f71 <set_block_data>
  8041a9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8041af:	83 e8 04             	sub    $0x4,%eax
  8041b2:	8b 00                	mov    (%eax),%eax
  8041b4:	83 e0 fe             	and    $0xfffffffe,%eax
  8041b7:	89 c2                	mov    %eax,%edx
  8041b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bc:	01 d0                	add    %edx,%eax
  8041be:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8041c1:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8041c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8041c9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8041cd:	75 68                	jne    804237 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041d3:	75 17                	jne    8041ec <realloc_block_FF+0x288>
  8041d5:	83 ec 04             	sub    $0x4,%esp
  8041d8:	68 98 51 80 00       	push   $0x805198
  8041dd:	68 06 02 00 00       	push   $0x206
  8041e2:	68 7d 51 80 00       	push   $0x80517d
  8041e7:	e8 94 cd ff ff       	call   800f80 <_panic>
  8041ec:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8041f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f5:	89 10                	mov    %edx,(%eax)
  8041f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041fa:	8b 00                	mov    (%eax),%eax
  8041fc:	85 c0                	test   %eax,%eax
  8041fe:	74 0d                	je     80420d <realloc_block_FF+0x2a9>
  804200:	a1 30 60 80 00       	mov    0x806030,%eax
  804205:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804208:	89 50 04             	mov    %edx,0x4(%eax)
  80420b:	eb 08                	jmp    804215 <realloc_block_FF+0x2b1>
  80420d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804210:	a3 34 60 80 00       	mov    %eax,0x806034
  804215:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804218:	a3 30 60 80 00       	mov    %eax,0x806030
  80421d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804220:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804227:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80422c:	40                   	inc    %eax
  80422d:	a3 3c 60 80 00       	mov    %eax,0x80603c
  804232:	e9 b0 01 00 00       	jmp    8043e7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804237:	a1 30 60 80 00       	mov    0x806030,%eax
  80423c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80423f:	76 68                	jbe    8042a9 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804241:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804245:	75 17                	jne    80425e <realloc_block_FF+0x2fa>
  804247:	83 ec 04             	sub    $0x4,%esp
  80424a:	68 98 51 80 00       	push   $0x805198
  80424f:	68 0b 02 00 00       	push   $0x20b
  804254:	68 7d 51 80 00       	push   $0x80517d
  804259:	e8 22 cd ff ff       	call   800f80 <_panic>
  80425e:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804264:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804267:	89 10                	mov    %edx,(%eax)
  804269:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80426c:	8b 00                	mov    (%eax),%eax
  80426e:	85 c0                	test   %eax,%eax
  804270:	74 0d                	je     80427f <realloc_block_FF+0x31b>
  804272:	a1 30 60 80 00       	mov    0x806030,%eax
  804277:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80427a:	89 50 04             	mov    %edx,0x4(%eax)
  80427d:	eb 08                	jmp    804287 <realloc_block_FF+0x323>
  80427f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804282:	a3 34 60 80 00       	mov    %eax,0x806034
  804287:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80428a:	a3 30 60 80 00       	mov    %eax,0x806030
  80428f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804299:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80429e:	40                   	inc    %eax
  80429f:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8042a4:	e9 3e 01 00 00       	jmp    8043e7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8042a9:	a1 30 60 80 00       	mov    0x806030,%eax
  8042ae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042b1:	73 68                	jae    80431b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042b7:	75 17                	jne    8042d0 <realloc_block_FF+0x36c>
  8042b9:	83 ec 04             	sub    $0x4,%esp
  8042bc:	68 cc 51 80 00       	push   $0x8051cc
  8042c1:	68 10 02 00 00       	push   $0x210
  8042c6:	68 7d 51 80 00       	push   $0x80517d
  8042cb:	e8 b0 cc ff ff       	call   800f80 <_panic>
  8042d0:	8b 15 34 60 80 00    	mov    0x806034,%edx
  8042d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042d9:	89 50 04             	mov    %edx,0x4(%eax)
  8042dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042df:	8b 40 04             	mov    0x4(%eax),%eax
  8042e2:	85 c0                	test   %eax,%eax
  8042e4:	74 0c                	je     8042f2 <realloc_block_FF+0x38e>
  8042e6:	a1 34 60 80 00       	mov    0x806034,%eax
  8042eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042ee:	89 10                	mov    %edx,(%eax)
  8042f0:	eb 08                	jmp    8042fa <realloc_block_FF+0x396>
  8042f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f5:	a3 30 60 80 00       	mov    %eax,0x806030
  8042fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042fd:	a3 34 60 80 00       	mov    %eax,0x806034
  804302:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80430b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804310:	40                   	inc    %eax
  804311:	a3 3c 60 80 00       	mov    %eax,0x80603c
  804316:	e9 cc 00 00 00       	jmp    8043e7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80431b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804322:	a1 30 60 80 00       	mov    0x806030,%eax
  804327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80432a:	e9 8a 00 00 00       	jmp    8043b9 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80432f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804332:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804335:	73 7a                	jae    8043b1 <realloc_block_FF+0x44d>
  804337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433a:	8b 00                	mov    (%eax),%eax
  80433c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80433f:	73 70                	jae    8043b1 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804345:	74 06                	je     80434d <realloc_block_FF+0x3e9>
  804347:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80434b:	75 17                	jne    804364 <realloc_block_FF+0x400>
  80434d:	83 ec 04             	sub    $0x4,%esp
  804350:	68 f0 51 80 00       	push   $0x8051f0
  804355:	68 1a 02 00 00       	push   $0x21a
  80435a:	68 7d 51 80 00       	push   $0x80517d
  80435f:	e8 1c cc ff ff       	call   800f80 <_panic>
  804364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804367:	8b 10                	mov    (%eax),%edx
  804369:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80436c:	89 10                	mov    %edx,(%eax)
  80436e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804371:	8b 00                	mov    (%eax),%eax
  804373:	85 c0                	test   %eax,%eax
  804375:	74 0b                	je     804382 <realloc_block_FF+0x41e>
  804377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437a:	8b 00                	mov    (%eax),%eax
  80437c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80437f:	89 50 04             	mov    %edx,0x4(%eax)
  804382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804385:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804388:	89 10                	mov    %edx,(%eax)
  80438a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80438d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804390:	89 50 04             	mov    %edx,0x4(%eax)
  804393:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804396:	8b 00                	mov    (%eax),%eax
  804398:	85 c0                	test   %eax,%eax
  80439a:	75 08                	jne    8043a4 <realloc_block_FF+0x440>
  80439c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80439f:	a3 34 60 80 00       	mov    %eax,0x806034
  8043a4:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8043a9:	40                   	inc    %eax
  8043aa:	a3 3c 60 80 00       	mov    %eax,0x80603c
							break;
  8043af:	eb 36                	jmp    8043e7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8043b1:	a1 38 60 80 00       	mov    0x806038,%eax
  8043b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043bd:	74 07                	je     8043c6 <realloc_block_FF+0x462>
  8043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c2:	8b 00                	mov    (%eax),%eax
  8043c4:	eb 05                	jmp    8043cb <realloc_block_FF+0x467>
  8043c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043cb:	a3 38 60 80 00       	mov    %eax,0x806038
  8043d0:	a1 38 60 80 00       	mov    0x806038,%eax
  8043d5:	85 c0                	test   %eax,%eax
  8043d7:	0f 85 52 ff ff ff    	jne    80432f <realloc_block_FF+0x3cb>
  8043dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043e1:	0f 85 48 ff ff ff    	jne    80432f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8043e7:	83 ec 04             	sub    $0x4,%esp
  8043ea:	6a 00                	push   $0x0
  8043ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8043ef:	ff 75 d4             	pushl  -0x2c(%ebp)
  8043f2:	e8 7a eb ff ff       	call   802f71 <set_block_data>
  8043f7:	83 c4 10             	add    $0x10,%esp
				return va;
  8043fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8043fd:	e9 7b 02 00 00       	jmp    80467d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804402:	83 ec 0c             	sub    $0xc,%esp
  804405:	68 6d 52 80 00       	push   $0x80526d
  80440a:	e8 2e ce ff ff       	call   80123d <cprintf>
  80440f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804412:	8b 45 08             	mov    0x8(%ebp),%eax
  804415:	e9 63 02 00 00       	jmp    80467d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80441a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80441d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804420:	0f 86 4d 02 00 00    	jbe    804673 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804426:	83 ec 0c             	sub    $0xc,%esp
  804429:	ff 75 e4             	pushl  -0x1c(%ebp)
  80442c:	e8 08 e8 ff ff       	call   802c39 <is_free_block>
  804431:	83 c4 10             	add    $0x10,%esp
  804434:	84 c0                	test   %al,%al
  804436:	0f 84 37 02 00 00    	je     804673 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80443c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80443f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804442:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804445:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804448:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80444b:	76 38                	jbe    804485 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80444d:	83 ec 0c             	sub    $0xc,%esp
  804450:	ff 75 08             	pushl  0x8(%ebp)
  804453:	e8 0c fa ff ff       	call   803e64 <free_block>
  804458:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80445b:	83 ec 0c             	sub    $0xc,%esp
  80445e:	ff 75 0c             	pushl  0xc(%ebp)
  804461:	e8 3a eb ff ff       	call   802fa0 <alloc_block_FF>
  804466:	83 c4 10             	add    $0x10,%esp
  804469:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80446c:	83 ec 08             	sub    $0x8,%esp
  80446f:	ff 75 c0             	pushl  -0x40(%ebp)
  804472:	ff 75 08             	pushl  0x8(%ebp)
  804475:	e8 ab fa ff ff       	call   803f25 <copy_data>
  80447a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80447d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804480:	e9 f8 01 00 00       	jmp    80467d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804488:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80448b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80448e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804492:	0f 87 a0 00 00 00    	ja     804538 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804498:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80449c:	75 17                	jne    8044b5 <realloc_block_FF+0x551>
  80449e:	83 ec 04             	sub    $0x4,%esp
  8044a1:	68 5f 51 80 00       	push   $0x80515f
  8044a6:	68 38 02 00 00       	push   $0x238
  8044ab:	68 7d 51 80 00       	push   $0x80517d
  8044b0:	e8 cb ca ff ff       	call   800f80 <_panic>
  8044b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b8:	8b 00                	mov    (%eax),%eax
  8044ba:	85 c0                	test   %eax,%eax
  8044bc:	74 10                	je     8044ce <realloc_block_FF+0x56a>
  8044be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044c1:	8b 00                	mov    (%eax),%eax
  8044c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044c6:	8b 52 04             	mov    0x4(%edx),%edx
  8044c9:	89 50 04             	mov    %edx,0x4(%eax)
  8044cc:	eb 0b                	jmp    8044d9 <realloc_block_FF+0x575>
  8044ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d1:	8b 40 04             	mov    0x4(%eax),%eax
  8044d4:	a3 34 60 80 00       	mov    %eax,0x806034
  8044d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044dc:	8b 40 04             	mov    0x4(%eax),%eax
  8044df:	85 c0                	test   %eax,%eax
  8044e1:	74 0f                	je     8044f2 <realloc_block_FF+0x58e>
  8044e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e6:	8b 40 04             	mov    0x4(%eax),%eax
  8044e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044ec:	8b 12                	mov    (%edx),%edx
  8044ee:	89 10                	mov    %edx,(%eax)
  8044f0:	eb 0a                	jmp    8044fc <realloc_block_FF+0x598>
  8044f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f5:	8b 00                	mov    (%eax),%eax
  8044f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8044fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804508:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80450f:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804514:	48                   	dec    %eax
  804515:	a3 3c 60 80 00       	mov    %eax,0x80603c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80451a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80451d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804520:	01 d0                	add    %edx,%eax
  804522:	83 ec 04             	sub    $0x4,%esp
  804525:	6a 01                	push   $0x1
  804527:	50                   	push   %eax
  804528:	ff 75 08             	pushl  0x8(%ebp)
  80452b:	e8 41 ea ff ff       	call   802f71 <set_block_data>
  804530:	83 c4 10             	add    $0x10,%esp
  804533:	e9 36 01 00 00       	jmp    80466e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804538:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80453b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80453e:	01 d0                	add    %edx,%eax
  804540:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804543:	83 ec 04             	sub    $0x4,%esp
  804546:	6a 01                	push   $0x1
  804548:	ff 75 f0             	pushl  -0x10(%ebp)
  80454b:	ff 75 08             	pushl  0x8(%ebp)
  80454e:	e8 1e ea ff ff       	call   802f71 <set_block_data>
  804553:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804556:	8b 45 08             	mov    0x8(%ebp),%eax
  804559:	83 e8 04             	sub    $0x4,%eax
  80455c:	8b 00                	mov    (%eax),%eax
  80455e:	83 e0 fe             	and    $0xfffffffe,%eax
  804561:	89 c2                	mov    %eax,%edx
  804563:	8b 45 08             	mov    0x8(%ebp),%eax
  804566:	01 d0                	add    %edx,%eax
  804568:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80456b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80456f:	74 06                	je     804577 <realloc_block_FF+0x613>
  804571:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804575:	75 17                	jne    80458e <realloc_block_FF+0x62a>
  804577:	83 ec 04             	sub    $0x4,%esp
  80457a:	68 f0 51 80 00       	push   $0x8051f0
  80457f:	68 44 02 00 00       	push   $0x244
  804584:	68 7d 51 80 00       	push   $0x80517d
  804589:	e8 f2 c9 ff ff       	call   800f80 <_panic>
  80458e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804591:	8b 10                	mov    (%eax),%edx
  804593:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804596:	89 10                	mov    %edx,(%eax)
  804598:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80459b:	8b 00                	mov    (%eax),%eax
  80459d:	85 c0                	test   %eax,%eax
  80459f:	74 0b                	je     8045ac <realloc_block_FF+0x648>
  8045a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045a4:	8b 00                	mov    (%eax),%eax
  8045a6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045a9:	89 50 04             	mov    %edx,0x4(%eax)
  8045ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045af:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045b2:	89 10                	mov    %edx,(%eax)
  8045b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045ba:	89 50 04             	mov    %edx,0x4(%eax)
  8045bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045c0:	8b 00                	mov    (%eax),%eax
  8045c2:	85 c0                	test   %eax,%eax
  8045c4:	75 08                	jne    8045ce <realloc_block_FF+0x66a>
  8045c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045c9:	a3 34 60 80 00       	mov    %eax,0x806034
  8045ce:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8045d3:	40                   	inc    %eax
  8045d4:	a3 3c 60 80 00       	mov    %eax,0x80603c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045dd:	75 17                	jne    8045f6 <realloc_block_FF+0x692>
  8045df:	83 ec 04             	sub    $0x4,%esp
  8045e2:	68 5f 51 80 00       	push   $0x80515f
  8045e7:	68 45 02 00 00       	push   $0x245
  8045ec:	68 7d 51 80 00       	push   $0x80517d
  8045f1:	e8 8a c9 ff ff       	call   800f80 <_panic>
  8045f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f9:	8b 00                	mov    (%eax),%eax
  8045fb:	85 c0                	test   %eax,%eax
  8045fd:	74 10                	je     80460f <realloc_block_FF+0x6ab>
  8045ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804602:	8b 00                	mov    (%eax),%eax
  804604:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804607:	8b 52 04             	mov    0x4(%edx),%edx
  80460a:	89 50 04             	mov    %edx,0x4(%eax)
  80460d:	eb 0b                	jmp    80461a <realloc_block_FF+0x6b6>
  80460f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804612:	8b 40 04             	mov    0x4(%eax),%eax
  804615:	a3 34 60 80 00       	mov    %eax,0x806034
  80461a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80461d:	8b 40 04             	mov    0x4(%eax),%eax
  804620:	85 c0                	test   %eax,%eax
  804622:	74 0f                	je     804633 <realloc_block_FF+0x6cf>
  804624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804627:	8b 40 04             	mov    0x4(%eax),%eax
  80462a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80462d:	8b 12                	mov    (%edx),%edx
  80462f:	89 10                	mov    %edx,(%eax)
  804631:	eb 0a                	jmp    80463d <realloc_block_FF+0x6d9>
  804633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804636:	8b 00                	mov    (%eax),%eax
  804638:	a3 30 60 80 00       	mov    %eax,0x806030
  80463d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804650:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804655:	48                   	dec    %eax
  804656:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(next_new_va, remaining_size, 0);
  80465b:	83 ec 04             	sub    $0x4,%esp
  80465e:	6a 00                	push   $0x0
  804660:	ff 75 bc             	pushl  -0x44(%ebp)
  804663:	ff 75 b8             	pushl  -0x48(%ebp)
  804666:	e8 06 e9 ff ff       	call   802f71 <set_block_data>
  80466b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80466e:	8b 45 08             	mov    0x8(%ebp),%eax
  804671:	eb 0a                	jmp    80467d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804673:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80467a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80467d:	c9                   	leave  
  80467e:	c3                   	ret    

0080467f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80467f:	55                   	push   %ebp
  804680:	89 e5                	mov    %esp,%ebp
  804682:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804685:	83 ec 04             	sub    $0x4,%esp
  804688:	68 74 52 80 00       	push   $0x805274
  80468d:	68 58 02 00 00       	push   $0x258
  804692:	68 7d 51 80 00       	push   $0x80517d
  804697:	e8 e4 c8 ff ff       	call   800f80 <_panic>

0080469c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80469c:	55                   	push   %ebp
  80469d:	89 e5                	mov    %esp,%ebp
  80469f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8046a2:	83 ec 04             	sub    $0x4,%esp
  8046a5:	68 9c 52 80 00       	push   $0x80529c
  8046aa:	68 61 02 00 00       	push   $0x261
  8046af:	68 7d 51 80 00       	push   $0x80517d
  8046b4:	e8 c7 c8 ff ff       	call   800f80 <_panic>
  8046b9:	66 90                	xchg   %ax,%ax
  8046bb:	90                   	nop

008046bc <__udivdi3>:
  8046bc:	55                   	push   %ebp
  8046bd:	57                   	push   %edi
  8046be:	56                   	push   %esi
  8046bf:	53                   	push   %ebx
  8046c0:	83 ec 1c             	sub    $0x1c,%esp
  8046c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8046d3:	89 ca                	mov    %ecx,%edx
  8046d5:	89 f8                	mov    %edi,%eax
  8046d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046db:	85 f6                	test   %esi,%esi
  8046dd:	75 2d                	jne    80470c <__udivdi3+0x50>
  8046df:	39 cf                	cmp    %ecx,%edi
  8046e1:	77 65                	ja     804748 <__udivdi3+0x8c>
  8046e3:	89 fd                	mov    %edi,%ebp
  8046e5:	85 ff                	test   %edi,%edi
  8046e7:	75 0b                	jne    8046f4 <__udivdi3+0x38>
  8046e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8046ee:	31 d2                	xor    %edx,%edx
  8046f0:	f7 f7                	div    %edi
  8046f2:	89 c5                	mov    %eax,%ebp
  8046f4:	31 d2                	xor    %edx,%edx
  8046f6:	89 c8                	mov    %ecx,%eax
  8046f8:	f7 f5                	div    %ebp
  8046fa:	89 c1                	mov    %eax,%ecx
  8046fc:	89 d8                	mov    %ebx,%eax
  8046fe:	f7 f5                	div    %ebp
  804700:	89 cf                	mov    %ecx,%edi
  804702:	89 fa                	mov    %edi,%edx
  804704:	83 c4 1c             	add    $0x1c,%esp
  804707:	5b                   	pop    %ebx
  804708:	5e                   	pop    %esi
  804709:	5f                   	pop    %edi
  80470a:	5d                   	pop    %ebp
  80470b:	c3                   	ret    
  80470c:	39 ce                	cmp    %ecx,%esi
  80470e:	77 28                	ja     804738 <__udivdi3+0x7c>
  804710:	0f bd fe             	bsr    %esi,%edi
  804713:	83 f7 1f             	xor    $0x1f,%edi
  804716:	75 40                	jne    804758 <__udivdi3+0x9c>
  804718:	39 ce                	cmp    %ecx,%esi
  80471a:	72 0a                	jb     804726 <__udivdi3+0x6a>
  80471c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804720:	0f 87 9e 00 00 00    	ja     8047c4 <__udivdi3+0x108>
  804726:	b8 01 00 00 00       	mov    $0x1,%eax
  80472b:	89 fa                	mov    %edi,%edx
  80472d:	83 c4 1c             	add    $0x1c,%esp
  804730:	5b                   	pop    %ebx
  804731:	5e                   	pop    %esi
  804732:	5f                   	pop    %edi
  804733:	5d                   	pop    %ebp
  804734:	c3                   	ret    
  804735:	8d 76 00             	lea    0x0(%esi),%esi
  804738:	31 ff                	xor    %edi,%edi
  80473a:	31 c0                	xor    %eax,%eax
  80473c:	89 fa                	mov    %edi,%edx
  80473e:	83 c4 1c             	add    $0x1c,%esp
  804741:	5b                   	pop    %ebx
  804742:	5e                   	pop    %esi
  804743:	5f                   	pop    %edi
  804744:	5d                   	pop    %ebp
  804745:	c3                   	ret    
  804746:	66 90                	xchg   %ax,%ax
  804748:	89 d8                	mov    %ebx,%eax
  80474a:	f7 f7                	div    %edi
  80474c:	31 ff                	xor    %edi,%edi
  80474e:	89 fa                	mov    %edi,%edx
  804750:	83 c4 1c             	add    $0x1c,%esp
  804753:	5b                   	pop    %ebx
  804754:	5e                   	pop    %esi
  804755:	5f                   	pop    %edi
  804756:	5d                   	pop    %ebp
  804757:	c3                   	ret    
  804758:	bd 20 00 00 00       	mov    $0x20,%ebp
  80475d:	89 eb                	mov    %ebp,%ebx
  80475f:	29 fb                	sub    %edi,%ebx
  804761:	89 f9                	mov    %edi,%ecx
  804763:	d3 e6                	shl    %cl,%esi
  804765:	89 c5                	mov    %eax,%ebp
  804767:	88 d9                	mov    %bl,%cl
  804769:	d3 ed                	shr    %cl,%ebp
  80476b:	89 e9                	mov    %ebp,%ecx
  80476d:	09 f1                	or     %esi,%ecx
  80476f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804773:	89 f9                	mov    %edi,%ecx
  804775:	d3 e0                	shl    %cl,%eax
  804777:	89 c5                	mov    %eax,%ebp
  804779:	89 d6                	mov    %edx,%esi
  80477b:	88 d9                	mov    %bl,%cl
  80477d:	d3 ee                	shr    %cl,%esi
  80477f:	89 f9                	mov    %edi,%ecx
  804781:	d3 e2                	shl    %cl,%edx
  804783:	8b 44 24 08          	mov    0x8(%esp),%eax
  804787:	88 d9                	mov    %bl,%cl
  804789:	d3 e8                	shr    %cl,%eax
  80478b:	09 c2                	or     %eax,%edx
  80478d:	89 d0                	mov    %edx,%eax
  80478f:	89 f2                	mov    %esi,%edx
  804791:	f7 74 24 0c          	divl   0xc(%esp)
  804795:	89 d6                	mov    %edx,%esi
  804797:	89 c3                	mov    %eax,%ebx
  804799:	f7 e5                	mul    %ebp
  80479b:	39 d6                	cmp    %edx,%esi
  80479d:	72 19                	jb     8047b8 <__udivdi3+0xfc>
  80479f:	74 0b                	je     8047ac <__udivdi3+0xf0>
  8047a1:	89 d8                	mov    %ebx,%eax
  8047a3:	31 ff                	xor    %edi,%edi
  8047a5:	e9 58 ff ff ff       	jmp    804702 <__udivdi3+0x46>
  8047aa:	66 90                	xchg   %ax,%ax
  8047ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047b0:	89 f9                	mov    %edi,%ecx
  8047b2:	d3 e2                	shl    %cl,%edx
  8047b4:	39 c2                	cmp    %eax,%edx
  8047b6:	73 e9                	jae    8047a1 <__udivdi3+0xe5>
  8047b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047bb:	31 ff                	xor    %edi,%edi
  8047bd:	e9 40 ff ff ff       	jmp    804702 <__udivdi3+0x46>
  8047c2:	66 90                	xchg   %ax,%ax
  8047c4:	31 c0                	xor    %eax,%eax
  8047c6:	e9 37 ff ff ff       	jmp    804702 <__udivdi3+0x46>
  8047cb:	90                   	nop

008047cc <__umoddi3>:
  8047cc:	55                   	push   %ebp
  8047cd:	57                   	push   %edi
  8047ce:	56                   	push   %esi
  8047cf:	53                   	push   %ebx
  8047d0:	83 ec 1c             	sub    $0x1c,%esp
  8047d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8047d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047eb:	89 f3                	mov    %esi,%ebx
  8047ed:	89 fa                	mov    %edi,%edx
  8047ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047f3:	89 34 24             	mov    %esi,(%esp)
  8047f6:	85 c0                	test   %eax,%eax
  8047f8:	75 1a                	jne    804814 <__umoddi3+0x48>
  8047fa:	39 f7                	cmp    %esi,%edi
  8047fc:	0f 86 a2 00 00 00    	jbe    8048a4 <__umoddi3+0xd8>
  804802:	89 c8                	mov    %ecx,%eax
  804804:	89 f2                	mov    %esi,%edx
  804806:	f7 f7                	div    %edi
  804808:	89 d0                	mov    %edx,%eax
  80480a:	31 d2                	xor    %edx,%edx
  80480c:	83 c4 1c             	add    $0x1c,%esp
  80480f:	5b                   	pop    %ebx
  804810:	5e                   	pop    %esi
  804811:	5f                   	pop    %edi
  804812:	5d                   	pop    %ebp
  804813:	c3                   	ret    
  804814:	39 f0                	cmp    %esi,%eax
  804816:	0f 87 ac 00 00 00    	ja     8048c8 <__umoddi3+0xfc>
  80481c:	0f bd e8             	bsr    %eax,%ebp
  80481f:	83 f5 1f             	xor    $0x1f,%ebp
  804822:	0f 84 ac 00 00 00    	je     8048d4 <__umoddi3+0x108>
  804828:	bf 20 00 00 00       	mov    $0x20,%edi
  80482d:	29 ef                	sub    %ebp,%edi
  80482f:	89 fe                	mov    %edi,%esi
  804831:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804835:	89 e9                	mov    %ebp,%ecx
  804837:	d3 e0                	shl    %cl,%eax
  804839:	89 d7                	mov    %edx,%edi
  80483b:	89 f1                	mov    %esi,%ecx
  80483d:	d3 ef                	shr    %cl,%edi
  80483f:	09 c7                	or     %eax,%edi
  804841:	89 e9                	mov    %ebp,%ecx
  804843:	d3 e2                	shl    %cl,%edx
  804845:	89 14 24             	mov    %edx,(%esp)
  804848:	89 d8                	mov    %ebx,%eax
  80484a:	d3 e0                	shl    %cl,%eax
  80484c:	89 c2                	mov    %eax,%edx
  80484e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804852:	d3 e0                	shl    %cl,%eax
  804854:	89 44 24 04          	mov    %eax,0x4(%esp)
  804858:	8b 44 24 08          	mov    0x8(%esp),%eax
  80485c:	89 f1                	mov    %esi,%ecx
  80485e:	d3 e8                	shr    %cl,%eax
  804860:	09 d0                	or     %edx,%eax
  804862:	d3 eb                	shr    %cl,%ebx
  804864:	89 da                	mov    %ebx,%edx
  804866:	f7 f7                	div    %edi
  804868:	89 d3                	mov    %edx,%ebx
  80486a:	f7 24 24             	mull   (%esp)
  80486d:	89 c6                	mov    %eax,%esi
  80486f:	89 d1                	mov    %edx,%ecx
  804871:	39 d3                	cmp    %edx,%ebx
  804873:	0f 82 87 00 00 00    	jb     804900 <__umoddi3+0x134>
  804879:	0f 84 91 00 00 00    	je     804910 <__umoddi3+0x144>
  80487f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804883:	29 f2                	sub    %esi,%edx
  804885:	19 cb                	sbb    %ecx,%ebx
  804887:	89 d8                	mov    %ebx,%eax
  804889:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80488d:	d3 e0                	shl    %cl,%eax
  80488f:	89 e9                	mov    %ebp,%ecx
  804891:	d3 ea                	shr    %cl,%edx
  804893:	09 d0                	or     %edx,%eax
  804895:	89 e9                	mov    %ebp,%ecx
  804897:	d3 eb                	shr    %cl,%ebx
  804899:	89 da                	mov    %ebx,%edx
  80489b:	83 c4 1c             	add    $0x1c,%esp
  80489e:	5b                   	pop    %ebx
  80489f:	5e                   	pop    %esi
  8048a0:	5f                   	pop    %edi
  8048a1:	5d                   	pop    %ebp
  8048a2:	c3                   	ret    
  8048a3:	90                   	nop
  8048a4:	89 fd                	mov    %edi,%ebp
  8048a6:	85 ff                	test   %edi,%edi
  8048a8:	75 0b                	jne    8048b5 <__umoddi3+0xe9>
  8048aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8048af:	31 d2                	xor    %edx,%edx
  8048b1:	f7 f7                	div    %edi
  8048b3:	89 c5                	mov    %eax,%ebp
  8048b5:	89 f0                	mov    %esi,%eax
  8048b7:	31 d2                	xor    %edx,%edx
  8048b9:	f7 f5                	div    %ebp
  8048bb:	89 c8                	mov    %ecx,%eax
  8048bd:	f7 f5                	div    %ebp
  8048bf:	89 d0                	mov    %edx,%eax
  8048c1:	e9 44 ff ff ff       	jmp    80480a <__umoddi3+0x3e>
  8048c6:	66 90                	xchg   %ax,%ax
  8048c8:	89 c8                	mov    %ecx,%eax
  8048ca:	89 f2                	mov    %esi,%edx
  8048cc:	83 c4 1c             	add    $0x1c,%esp
  8048cf:	5b                   	pop    %ebx
  8048d0:	5e                   	pop    %esi
  8048d1:	5f                   	pop    %edi
  8048d2:	5d                   	pop    %ebp
  8048d3:	c3                   	ret    
  8048d4:	3b 04 24             	cmp    (%esp),%eax
  8048d7:	72 06                	jb     8048df <__umoddi3+0x113>
  8048d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048dd:	77 0f                	ja     8048ee <__umoddi3+0x122>
  8048df:	89 f2                	mov    %esi,%edx
  8048e1:	29 f9                	sub    %edi,%ecx
  8048e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048e7:	89 14 24             	mov    %edx,(%esp)
  8048ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048f2:	8b 14 24             	mov    (%esp),%edx
  8048f5:	83 c4 1c             	add    $0x1c,%esp
  8048f8:	5b                   	pop    %ebx
  8048f9:	5e                   	pop    %esi
  8048fa:	5f                   	pop    %edi
  8048fb:	5d                   	pop    %ebp
  8048fc:	c3                   	ret    
  8048fd:	8d 76 00             	lea    0x0(%esi),%esi
  804900:	2b 04 24             	sub    (%esp),%eax
  804903:	19 fa                	sbb    %edi,%edx
  804905:	89 d1                	mov    %edx,%ecx
  804907:	89 c6                	mov    %eax,%esi
  804909:	e9 71 ff ff ff       	jmp    80487f <__umoddi3+0xb3>
  80490e:	66 90                	xchg   %ax,%ax
  804910:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804914:	72 ea                	jb     804900 <__umoddi3+0x134>
  804916:	89 d9                	mov    %ebx,%ecx
  804918:	e9 62 ff ff ff       	jmp    80487f <__umoddi3+0xb3>
