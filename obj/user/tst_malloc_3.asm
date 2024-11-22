
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
  800094:	68 e0 47 80 00       	push   $0x8047e0
  800099:	6a 1a                	push   $0x1a
  80009b:	68 fc 47 80 00       	push   $0x8047fc
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
  8000e2:	e8 e8 24 00 00       	call   8025cf <sys_calculate_free_frames>
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
  8000fe:	e8 17 25 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  80013a:	68 10 48 80 00       	push   $0x804810
  80013f:	6a 39                	push   $0x39
  800141:	68 fc 47 80 00       	push   $0x8047fc
  800146:	e8 35 0e 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 ca 24 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 78 48 80 00       	push   $0x804878
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 fc 47 80 00       	push   $0x8047fc
  800164:	e8 17 0e 00 00       	call   800f80 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 61 24 00 00       	call   8025cf <sys_calculate_free_frames>
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
  80019e:	e8 2c 24 00 00       	call   8025cf <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 a8 48 80 00       	push   $0x8048a8
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 fc 47 80 00       	push   $0x8047fc
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
  800274:	68 ec 48 80 00       	push   $0x8048ec
  800279:	6a 4b                	push   $0x4b
  80027b:	68 fc 47 80 00       	push   $0x8047fc
  800280:	e8 fb 0c 00 00       	call   800f80 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 90 23 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  8002d6:	68 10 48 80 00       	push   $0x804810
  8002db:	6a 50                	push   $0x50
  8002dd:	68 fc 47 80 00       	push   $0x8047fc
  8002e2:	e8 99 0c 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 2e 23 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 78 48 80 00       	push   $0x804878
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 fc 47 80 00       	push   $0x8047fc
  800300:	e8 7b 0c 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 c5 22 00 00       	call   8025cf <sys_calculate_free_frames>
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
  800343:	e8 87 22 00 00       	call   8025cf <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 a8 48 80 00       	push   $0x8048a8
  800359:	6a 58                	push   $0x58
  80035b:	68 fc 47 80 00       	push   $0x8047fc
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
  80041d:	68 ec 48 80 00       	push   $0x8048ec
  800422:	6a 61                	push   $0x61
  800424:	68 fc 47 80 00       	push   $0x8047fc
  800429:	e8 52 0b 00 00       	call   800f80 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 e7 21 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  800482:	68 10 48 80 00       	push   $0x804810
  800487:	6a 66                	push   $0x66
  800489:	68 fc 47 80 00       	push   $0x8047fc
  80048e:	e8 ed 0a 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 82 21 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 78 48 80 00       	push   $0x804878
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 fc 47 80 00       	push   $0x8047fc
  8004ac:	e8 cf 0a 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 19 21 00 00       	call   8025cf <sys_calculate_free_frames>
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
  8004ed:	e8 dd 20 00 00       	call   8025cf <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 a8 48 80 00       	push   $0x8048a8
  800503:	6a 6e                	push   $0x6e
  800505:	68 fc 47 80 00       	push   $0x8047fc
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
  8005d0:	68 ec 48 80 00       	push   $0x8048ec
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 fc 47 80 00       	push   $0x8047fc
  8005dc:	e8 9f 09 00 00       	call   800f80 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 e9 1f 00 00       	call   8025cf <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 2c 20 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  800651:	68 10 48 80 00       	push   $0x804810
  800656:	6a 7d                	push   $0x7d
  800658:	68 fc 47 80 00       	push   $0x8047fc
  80065d:	e8 1e 09 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 b3 1f 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 78 48 80 00       	push   $0x804878
  800674:	6a 7e                	push   $0x7e
  800676:	68 fc 47 80 00       	push   $0x8047fc
  80067b:	e8 00 09 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 95 1f 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  8006ec:	68 10 48 80 00       	push   $0x804810
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 fc 47 80 00       	push   $0x8047fc
  8006fb:	e8 80 08 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 15 1f 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 78 48 80 00       	push   $0x804878
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 fc 47 80 00       	push   $0x8047fc
  80071c:	e8 5f 08 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 a9 1e 00 00       	call   8025cf <sys_calculate_free_frames>
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
  8007c5:	e8 05 1e 00 00       	call   8025cf <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 a8 48 80 00       	push   $0x8048a8
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 fc 47 80 00       	push   $0x8047fc
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
  8008c6:	68 ec 48 80 00       	push   $0x8048ec
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 fc 47 80 00       	push   $0x8047fc
  8008d5:	e8 a6 06 00 00       	call   800f80 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 f0 1c 00 00       	call   8025cf <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 33 1d 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  80094d:	68 10 48 80 00       	push   $0x804810
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 fc 47 80 00       	push   $0x8047fc
  80095c:	e8 1f 06 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 b4 1c 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 78 48 80 00       	push   $0x804878
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 fc 47 80 00       	push   $0x8047fc
  80097d:	e8 fe 05 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 93 1c 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 10 48 80 00       	push   $0x804810
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 fc 47 80 00       	push   $0x8047fc
  800a0c:	e8 6f 05 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 04 1c 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 78 48 80 00       	push   $0x804878
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 fc 47 80 00       	push   $0x8047fc
  800a2d:	e8 4e 05 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 98 1b 00 00       	call   8025cf <sys_calculate_free_frames>
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
  800aa3:	e8 27 1b 00 00       	call   8025cf <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 a8 48 80 00       	push   $0x8048a8
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 fc 47 80 00       	push   $0x8047fc
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
  800bfc:	68 ec 48 80 00       	push   $0x8048ec
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 fc 47 80 00       	push   $0x8047fc
  800c0b:	e8 70 03 00 00       	call   800f80 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 05 1a 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
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
  800c8e:	68 10 48 80 00       	push   $0x804810
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 fc 47 80 00       	push   $0x8047fc
  800c9d:	e8 de 02 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 73 19 00 00       	call   80261a <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 78 48 80 00       	push   $0x804878
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 fc 47 80 00       	push   $0x8047fc
  800cbe:	e8 bd 02 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 07 19 00 00       	call   8025cf <sys_calculate_free_frames>
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
  800d17:	e8 b3 18 00 00       	call   8025cf <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 a8 48 80 00       	push   $0x8048a8
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 fc 47 80 00       	push   $0x8047fc
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
  800e15:	68 ec 48 80 00       	push   $0x8048ec
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 fc 47 80 00       	push   $0x8047fc
  800e24:	e8 57 01 00 00       	call   800f80 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 0c 49 80 00       	push   $0x80490c
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
  800e47:	e8 4c 19 00 00       	call   802798 <sys_getenvindex>
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
  800eb5:	e8 62 16 00 00       	call   80251c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	68 60 49 80 00       	push   $0x804960
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
  800ee5:	68 88 49 80 00       	push   $0x804988
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
  800f16:	68 b0 49 80 00       	push   $0x8049b0
  800f1b:	e8 1d 03 00 00       	call   80123d <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f23:	a1 20 60 80 00       	mov    0x806020,%eax
  800f28:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	50                   	push   %eax
  800f32:	68 08 4a 80 00       	push   $0x804a08
  800f37:	e8 01 03 00 00       	call   80123d <cprintf>
  800f3c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	68 60 49 80 00       	push   $0x804960
  800f47:	e8 f1 02 00 00       	call   80123d <cprintf>
  800f4c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f4f:	e8 e2 15 00 00       	call   802536 <sys_unlock_cons>
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
  800f67:	e8 f8 17 00 00       	call   802764 <sys_destroy_env>
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
  800f78:	e8 4d 18 00 00       	call   8027ca <sys_exit_env>
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
  800fa1:	68 1c 4a 80 00       	push   $0x804a1c
  800fa6:	e8 92 02 00 00       	call   80123d <cprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fae:	a1 00 60 80 00       	mov    0x806000,%eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	68 21 4a 80 00       	push   $0x804a21
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
  800fde:	68 3d 4a 80 00       	push   $0x804a3d
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
  80100d:	68 40 4a 80 00       	push   $0x804a40
  801012:	6a 26                	push   $0x26
  801014:	68 8c 4a 80 00       	push   $0x804a8c
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
  8010e2:	68 98 4a 80 00       	push   $0x804a98
  8010e7:	6a 3a                	push   $0x3a
  8010e9:	68 8c 4a 80 00       	push   $0x804a8c
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
  801155:	68 ec 4a 80 00       	push   $0x804aec
  80115a:	6a 44                	push   $0x44
  80115c:	68 8c 4a 80 00       	push   $0x804a8c
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
  8011af:	e8 26 13 00 00       	call   8024da <sys_cputs>
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
  801226:	e8 af 12 00 00       	call   8024da <sys_cputs>
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
  801270:	e8 a7 12 00 00       	call   80251c <sys_lock_cons>
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
  801290:	e8 a1 12 00 00       	call   802536 <sys_unlock_cons>
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
  8012da:	e8 95 32 00 00       	call   804574 <__udivdi3>
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
  80132a:	e8 55 33 00 00       	call   804684 <__umoddi3>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	05 54 4d 80 00       	add    $0x804d54,%eax
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
  801485:	8b 04 85 78 4d 80 00 	mov    0x804d78(,%eax,4),%eax
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
  801566:	8b 34 9d c0 4b 80 00 	mov    0x804bc0(,%ebx,4),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 19                	jne    80158a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801571:	53                   	push   %ebx
  801572:	68 65 4d 80 00       	push   $0x804d65
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
  80158b:	68 6e 4d 80 00       	push   $0x804d6e
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
  8015b8:	be 71 4d 80 00       	mov    $0x804d71,%esi
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
  801fc3:	68 e8 4e 80 00       	push   $0x804ee8
  801fc8:	68 3f 01 00 00       	push   $0x13f
  801fcd:	68 0a 4f 80 00       	push   $0x804f0a
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
  801fe3:	e8 9d 0a 00 00       	call   802a85 <sys_sbrk>
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
  80205e:	e8 a6 08 00 00       	call   802909 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 16                	je     80207d <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 e6 0d 00 00       	call   802e58 <alloc_block_FF>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	e9 8a 01 00 00       	jmp    802207 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80207d:	e8 b8 08 00 00       	call   80293a <sys_isUHeapPlacementStrategyBESTFIT>
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 84 7d 01 00 00    	je     802207 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 7f 12 00 00       	call   803314 <alloc_block_BF>
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
  8020e0:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  80212d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  802184:	c7 04 85 60 60 80 00 	movl   $0x1,0x806060(,%eax,4)
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
  8021e6:	89 04 95 60 60 88 00 	mov    %eax,0x886060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8021ed:	83 ec 08             	sub    $0x8,%esp
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f6:	e8 c1 08 00 00       	call   802abc <sys_allocate_user_mem>
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
  80223e:	e8 95 08 00 00       	call   802ad8 <get_block_size>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	e8 c8 1a 00 00       	call   803d1c <free_block>
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
  802289:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  8022c6:	c7 04 85 60 60 80 00 	movl   $0x0,0x806060(,%eax,4)
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
  8022e6:	e8 b5 07 00 00       	call   802aa0 <sys_free_user_mem>
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
  8022f4:	68 18 4f 80 00       	push   $0x804f18
  8022f9:	68 84 00 00 00       	push   $0x84
  8022fe:	68 42 4f 80 00       	push   $0x804f42
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
  80231a:	75 07                	jne    802323 <smalloc+0x19>
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	eb 74                	jmp    802397 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802323:	8b 45 0c             	mov    0xc(%ebp),%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802329:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802330:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	39 d0                	cmp    %edx,%eax
  802338:	73 02                	jae    80233c <smalloc+0x32>
  80233a:	89 d0                	mov    %edx,%eax
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	50                   	push   %eax
  802340:	e8 a8 fc ff ff       	call   801fed <malloc>
  802345:	83 c4 10             	add    $0x10,%esp
  802348:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80234b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80234f:	75 07                	jne    802358 <smalloc+0x4e>
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
  802356:	eb 3f                	jmp    802397 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802358:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80235c:	ff 75 ec             	pushl  -0x14(%ebp)
  80235f:	50                   	push   %eax
  802360:	ff 75 0c             	pushl  0xc(%ebp)
  802363:	ff 75 08             	pushl  0x8(%ebp)
  802366:	e8 3c 03 00 00       	call   8026a7 <sys_createSharedObject>
  80236b:	83 c4 10             	add    $0x10,%esp
  80236e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802371:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802375:	74 06                	je     80237d <smalloc+0x73>
  802377:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80237b:	75 07                	jne    802384 <smalloc+0x7a>
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	eb 13                	jmp    802397 <smalloc+0x8d>
	 cprintf("153\n");
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	68 4e 4f 80 00       	push   $0x804f4e
  80238c:	e8 ac ee ff ff       	call   80123d <cprintf>
  802391:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  802394:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80239f:	83 ec 08             	sub    $0x8,%esp
  8023a2:	ff 75 0c             	pushl  0xc(%ebp)
  8023a5:	ff 75 08             	pushl  0x8(%ebp)
  8023a8:	e8 24 03 00 00       	call   8026d1 <sys_getSizeOfSharedObject>
  8023ad:	83 c4 10             	add    $0x10,%esp
  8023b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8023b3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8023b7:	75 07                	jne    8023c0 <sget+0x27>
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023be:	eb 5c                	jmp    80241c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023c6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d3:	39 d0                	cmp    %edx,%eax
  8023d5:	7d 02                	jge    8023d9 <sget+0x40>
  8023d7:	89 d0                	mov    %edx,%eax
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	50                   	push   %eax
  8023dd:	e8 0b fc ff ff       	call   801fed <malloc>
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8023e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023ec:	75 07                	jne    8023f5 <sget+0x5c>
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f3:	eb 27                	jmp    80241c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	ff 75 08             	pushl  0x8(%ebp)
  802401:	e8 e8 02 00 00       	call   8026ee <sys_getSharedObject>
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80240c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802410:	75 07                	jne    802419 <sget+0x80>
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
  802417:	eb 03                	jmp    80241c <sget+0x83>
	return ptr;
  802419:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 54 4f 80 00       	push   $0x804f54
  80242c:	68 c2 00 00 00       	push   $0xc2
  802431:	68 42 4f 80 00       	push   $0x804f42
  802436:	e8 45 eb ff ff       	call   800f80 <_panic>

0080243b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 78 4f 80 00       	push   $0x804f78
  802449:	68 d9 00 00 00       	push   $0xd9
  80244e:	68 42 4f 80 00       	push   $0x804f42
  802453:	e8 28 eb ff ff       	call   800f80 <_panic>

00802458 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 9e 4f 80 00       	push   $0x804f9e
  802466:	68 e5 00 00 00       	push   $0xe5
  80246b:	68 42 4f 80 00       	push   $0x804f42
  802470:	e8 0b eb ff ff       	call   800f80 <_panic>

00802475 <shrink>:

}
void shrink(uint32 newSize)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 9e 4f 80 00       	push   $0x804f9e
  802483:	68 ea 00 00 00       	push   $0xea
  802488:	68 42 4f 80 00       	push   $0x804f42
  80248d:	e8 ee ea ff ff       	call   800f80 <_panic>

00802492 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 9e 4f 80 00       	push   $0x804f9e
  8024a0:	68 ef 00 00 00       	push   $0xef
  8024a5:	68 42 4f 80 00       	push   $0x804f42
  8024aa:	e8 d1 ea ff ff       	call   800f80 <_panic>

008024af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	57                   	push   %edi
  8024b3:	56                   	push   %esi
  8024b4:	53                   	push   %ebx
  8024b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024ca:	cd 30                	int    $0x30
  8024cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	5b                   	pop    %ebx
  8024d6:	5e                   	pop    %esi
  8024d7:	5f                   	pop    %edi
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    

008024da <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8024e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	52                   	push   %edx
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	50                   	push   %eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	e8 b2 ff ff ff       	call   8024af <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
}
  802500:	90                   	nop
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_cgetc>:

int
sys_cgetc(void)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 02                	push   $0x2
  802512:	e8 98 ff ff ff       	call   8024af <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 03                	push   $0x3
  80252b:	e8 7f ff ff ff       	call   8024af <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
}
  802533:	90                   	nop
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 04                	push   $0x4
  802545:	e8 65 ff ff ff       	call   8024af <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	90                   	nop
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802553:	8b 55 0c             	mov    0xc(%ebp),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	52                   	push   %edx
  802560:	50                   	push   %eax
  802561:	6a 08                	push   $0x8
  802563:	e8 47 ff ff ff       	call   8024af <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	56                   	push   %esi
  802571:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802572:	8b 75 18             	mov    0x18(%ebp),%esi
  802575:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802578:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	56                   	push   %esi
  802582:	53                   	push   %ebx
  802583:	51                   	push   %ecx
  802584:	52                   	push   %edx
  802585:	50                   	push   %eax
  802586:	6a 09                	push   $0x9
  802588:	e8 22 ff ff ff       	call   8024af <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
}
  802590:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80259a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	52                   	push   %edx
  8025a7:	50                   	push   %eax
  8025a8:	6a 0a                	push   $0xa
  8025aa:	e8 00 ff ff ff       	call   8024af <syscall>
  8025af:	83 c4 18             	add    $0x18,%esp
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	ff 75 0c             	pushl  0xc(%ebp)
  8025c0:	ff 75 08             	pushl  0x8(%ebp)
  8025c3:	6a 0b                	push   $0xb
  8025c5:	e8 e5 fe ff ff       	call   8024af <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 0c                	push   $0xc
  8025de:	e8 cc fe ff ff       	call   8024af <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 0d                	push   $0xd
  8025f7:	e8 b3 fe ff ff       	call   8024af <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 0e                	push   $0xe
  802610:	e8 9a fe ff ff       	call   8024af <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 0f                	push   $0xf
  802629:	e8 81 fe ff ff       	call   8024af <syscall>
  80262e:	83 c4 18             	add    $0x18,%esp
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	ff 75 08             	pushl  0x8(%ebp)
  802641:	6a 10                	push   $0x10
  802643:	e8 67 fe ff ff       	call   8024af <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 11                	push   $0x11
  80265c:	e8 4e fe ff ff       	call   8024af <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	90                   	nop
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <sys_cputc>:

void
sys_cputc(const char c)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802673:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	50                   	push   %eax
  802680:	6a 01                	push   $0x1
  802682:	e8 28 fe ff ff       	call   8024af <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	90                   	nop
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 14                	push   $0x14
  80269c:	e8 0e fe ff ff       	call   8024af <syscall>
  8026a1:	83 c4 18             	add    $0x18,%esp
}
  8026a4:	90                   	nop
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	6a 00                	push   $0x0
  8026bf:	51                   	push   %ecx
  8026c0:	52                   	push   %edx
  8026c1:	ff 75 0c             	pushl  0xc(%ebp)
  8026c4:	50                   	push   %eax
  8026c5:	6a 15                	push   $0x15
  8026c7:	e8 e3 fd ff ff       	call   8024af <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8026d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	52                   	push   %edx
  8026e1:	50                   	push   %eax
  8026e2:	6a 16                	push   $0x16
  8026e4:	e8 c6 fd ff ff       	call   8024af <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8026f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	51                   	push   %ecx
  8026ff:	52                   	push   %edx
  802700:	50                   	push   %eax
  802701:	6a 17                	push   $0x17
  802703:	e8 a7 fd ff ff       	call   8024af <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802710:	8b 55 0c             	mov    0xc(%ebp),%edx
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	52                   	push   %edx
  80271d:	50                   	push   %eax
  80271e:	6a 18                	push   $0x18
  802720:	e8 8a fd ff ff       	call   8024af <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	6a 00                	push   $0x0
  802732:	ff 75 14             	pushl  0x14(%ebp)
  802735:	ff 75 10             	pushl  0x10(%ebp)
  802738:	ff 75 0c             	pushl  0xc(%ebp)
  80273b:	50                   	push   %eax
  80273c:	6a 19                	push   $0x19
  80273e:	e8 6c fd ff ff       	call   8024af <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	50                   	push   %eax
  802757:	6a 1a                	push   $0x1a
  802759:	e8 51 fd ff ff       	call   8024af <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	90                   	nop
  802762:	c9                   	leave  
  802763:	c3                   	ret    

00802764 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	50                   	push   %eax
  802773:	6a 1b                	push   $0x1b
  802775:	e8 35 fd ff ff       	call   8024af <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 05                	push   $0x5
  80278e:	e8 1c fd ff ff       	call   8024af <syscall>
  802793:	83 c4 18             	add    $0x18,%esp
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 06                	push   $0x6
  8027a7:	e8 03 fd ff ff       	call   8024af <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 07                	push   $0x7
  8027c0:	e8 ea fc ff ff       	call   8024af <syscall>
  8027c5:	83 c4 18             	add    $0x18,%esp
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <sys_exit_env>:


void sys_exit_env(void)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 1c                	push   $0x1c
  8027d9:	e8 d1 fc ff ff       	call   8024af <syscall>
  8027de:	83 c4 18             	add    $0x18,%esp
}
  8027e1:	90                   	nop
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8027ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027ed:	8d 50 04             	lea    0x4(%eax),%edx
  8027f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	52                   	push   %edx
  8027fa:	50                   	push   %eax
  8027fb:	6a 1d                	push   $0x1d
  8027fd:	e8 ad fc ff ff       	call   8024af <syscall>
  802802:	83 c4 18             	add    $0x18,%esp
	return result;
  802805:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802808:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80280b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80280e:	89 01                	mov    %eax,(%ecx)
  802810:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	c9                   	leave  
  802817:	c2 04 00             	ret    $0x4

0080281a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	ff 75 10             	pushl  0x10(%ebp)
  802824:	ff 75 0c             	pushl  0xc(%ebp)
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	6a 13                	push   $0x13
  80282c:	e8 7e fc ff ff       	call   8024af <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return ;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <sys_rcr2>:
uint32 sys_rcr2()
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 1e                	push   $0x1e
  802846:	e8 64 fc ff ff       	call   8024af <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
}
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    

00802850 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80285c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	50                   	push   %eax
  802869:	6a 1f                	push   $0x1f
  80286b:	e8 3f fc ff ff       	call   8024af <syscall>
  802870:	83 c4 18             	add    $0x18,%esp
	return ;
  802873:	90                   	nop
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <rsttst>:
void rsttst()
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 21                	push   $0x21
  802885:	e8 25 fc ff ff       	call   8024af <syscall>
  80288a:	83 c4 18             	add    $0x18,%esp
	return ;
  80288d:	90                   	nop
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	8b 45 14             	mov    0x14(%ebp),%eax
  802899:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80289c:	8b 55 18             	mov    0x18(%ebp),%edx
  80289f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028a3:	52                   	push   %edx
  8028a4:	50                   	push   %eax
  8028a5:	ff 75 10             	pushl  0x10(%ebp)
  8028a8:	ff 75 0c             	pushl  0xc(%ebp)
  8028ab:	ff 75 08             	pushl  0x8(%ebp)
  8028ae:	6a 20                	push   $0x20
  8028b0:	e8 fa fb ff ff       	call   8024af <syscall>
  8028b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b8:	90                   	nop
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <chktst>:
void chktst(uint32 n)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	ff 75 08             	pushl  0x8(%ebp)
  8028c9:	6a 22                	push   $0x22
  8028cb:	e8 df fb ff ff       	call   8024af <syscall>
  8028d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d3:	90                   	nop
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <inctst>:

void inctst()
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 23                	push   $0x23
  8028e5:	e8 c5 fb ff ff       	call   8024af <syscall>
  8028ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ed:	90                   	nop
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <gettst>:
uint32 gettst()
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 24                	push   $0x24
  8028ff:	e8 ab fb ff ff       	call   8024af <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 25                	push   $0x25
  80291b:	e8 8f fb ff ff       	call   8024af <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
  802923:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802926:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80292a:	75 07                	jne    802933 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80292c:	b8 01 00 00 00       	mov    $0x1,%eax
  802931:	eb 05                	jmp    802938 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 25                	push   $0x25
  80294c:	e8 5e fb ff ff       	call   8024af <syscall>
  802951:	83 c4 18             	add    $0x18,%esp
  802954:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802957:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80295b:	75 07                	jne    802964 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80295d:	b8 01 00 00 00       	mov    $0x1,%eax
  802962:	eb 05                	jmp    802969 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 25                	push   $0x25
  80297d:	e8 2d fb ff ff       	call   8024af <syscall>
  802982:	83 c4 18             	add    $0x18,%esp
  802985:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802988:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80298c:	75 07                	jne    802995 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	eb 05                	jmp    80299a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 25                	push   $0x25
  8029ae:	e8 fc fa ff ff       	call   8024af <syscall>
  8029b3:	83 c4 18             	add    $0x18,%esp
  8029b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029bd:	75 07                	jne    8029c6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c4:	eb 05                	jmp    8029cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	ff 75 08             	pushl  0x8(%ebp)
  8029db:	6a 26                	push   $0x26
  8029dd:	e8 cd fa ff ff       	call   8024af <syscall>
  8029e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e5:	90                   	nop
}
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
  8029eb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8029ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	6a 00                	push   $0x0
  8029fa:	53                   	push   %ebx
  8029fb:	51                   	push   %ecx
  8029fc:	52                   	push   %edx
  8029fd:	50                   	push   %eax
  8029fe:	6a 27                	push   $0x27
  802a00:	e8 aa fa ff ff       	call   8024af <syscall>
  802a05:	83 c4 18             	add    $0x18,%esp
}
  802a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a0b:	c9                   	leave  
  802a0c:	c3                   	ret    

00802a0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	52                   	push   %edx
  802a1d:	50                   	push   %eax
  802a1e:	6a 28                	push   $0x28
  802a20:	e8 8a fa ff ff       	call   8024af <syscall>
  802a25:	83 c4 18             	add    $0x18,%esp
}
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802a2d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	6a 00                	push   $0x0
  802a38:	51                   	push   %ecx
  802a39:	ff 75 10             	pushl  0x10(%ebp)
  802a3c:	52                   	push   %edx
  802a3d:	50                   	push   %eax
  802a3e:	6a 29                	push   $0x29
  802a40:	e8 6a fa ff ff       	call   8024af <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
}
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	ff 75 10             	pushl  0x10(%ebp)
  802a54:	ff 75 0c             	pushl  0xc(%ebp)
  802a57:	ff 75 08             	pushl  0x8(%ebp)
  802a5a:	6a 12                	push   $0x12
  802a5c:	e8 4e fa ff ff       	call   8024af <syscall>
  802a61:	83 c4 18             	add    $0x18,%esp
	return ;
  802a64:	90                   	nop
}
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	52                   	push   %edx
  802a77:	50                   	push   %eax
  802a78:	6a 2a                	push   $0x2a
  802a7a:	e8 30 fa ff ff       	call   8024af <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
	return;
  802a82:	90                   	nop
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	50                   	push   %eax
  802a94:	6a 2b                	push   $0x2b
  802a96:	e8 14 fa ff ff       	call   8024af <syscall>
  802a9b:	83 c4 18             	add    $0x18,%esp
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	ff 75 0c             	pushl  0xc(%ebp)
  802aac:	ff 75 08             	pushl  0x8(%ebp)
  802aaf:	6a 2c                	push   $0x2c
  802ab1:	e8 f9 f9 ff ff       	call   8024af <syscall>
  802ab6:	83 c4 18             	add    $0x18,%esp
	return;
  802ab9:	90                   	nop
}
  802aba:	c9                   	leave  
  802abb:	c3                   	ret    

00802abc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802abc:	55                   	push   %ebp
  802abd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 00                	push   $0x0
  802ac5:	ff 75 0c             	pushl  0xc(%ebp)
  802ac8:	ff 75 08             	pushl  0x8(%ebp)
  802acb:	6a 2d                	push   $0x2d
  802acd:	e8 dd f9 ff ff       	call   8024af <syscall>
  802ad2:	83 c4 18             	add    $0x18,%esp
	return;
  802ad5:	90                   	nop
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	83 e8 04             	sub    $0x4,%eax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802aef:	c9                   	leave  
  802af0:	c3                   	ret    

00802af1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802af1:	55                   	push   %ebp
  802af2:	89 e5                	mov    %esp,%ebp
  802af4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	83 e8 04             	sub    $0x4,%eax
  802afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	83 e0 01             	and    $0x1,%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	0f 94 c0             	sete   %al
}
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b1f:	83 f8 02             	cmp    $0x2,%eax
  802b22:	74 2b                	je     802b4f <alloc_block+0x40>
  802b24:	83 f8 02             	cmp    $0x2,%eax
  802b27:	7f 07                	jg     802b30 <alloc_block+0x21>
  802b29:	83 f8 01             	cmp    $0x1,%eax
  802b2c:	74 0e                	je     802b3c <alloc_block+0x2d>
  802b2e:	eb 58                	jmp    802b88 <alloc_block+0x79>
  802b30:	83 f8 03             	cmp    $0x3,%eax
  802b33:	74 2d                	je     802b62 <alloc_block+0x53>
  802b35:	83 f8 04             	cmp    $0x4,%eax
  802b38:	74 3b                	je     802b75 <alloc_block+0x66>
  802b3a:	eb 4c                	jmp    802b88 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802b3c:	83 ec 0c             	sub    $0xc,%esp
  802b3f:	ff 75 08             	pushl  0x8(%ebp)
  802b42:	e8 11 03 00 00       	call   802e58 <alloc_block_FF>
  802b47:	83 c4 10             	add    $0x10,%esp
  802b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b4d:	eb 4a                	jmp    802b99 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	ff 75 08             	pushl  0x8(%ebp)
  802b55:	e8 fa 19 00 00       	call   804554 <alloc_block_NF>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b60:	eb 37                	jmp    802b99 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802b62:	83 ec 0c             	sub    $0xc,%esp
  802b65:	ff 75 08             	pushl  0x8(%ebp)
  802b68:	e8 a7 07 00 00       	call   803314 <alloc_block_BF>
  802b6d:	83 c4 10             	add    $0x10,%esp
  802b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b73:	eb 24                	jmp    802b99 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	e8 b7 19 00 00       	call   804537 <alloc_block_WF>
  802b80:	83 c4 10             	add    $0x10,%esp
  802b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b86:	eb 11                	jmp    802b99 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	68 b0 4f 80 00       	push   $0x804fb0
  802b90:	e8 a8 e6 ff ff       	call   80123d <cprintf>
  802b95:	83 c4 10             	add    $0x10,%esp
		break;
  802b98:	90                   	nop
	}
	return va;
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b9c:	c9                   	leave  
  802b9d:	c3                   	ret    

00802b9e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802b9e:	55                   	push   %ebp
  802b9f:	89 e5                	mov    %esp,%ebp
  802ba1:	53                   	push   %ebx
  802ba2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ba5:	83 ec 0c             	sub    $0xc,%esp
  802ba8:	68 d0 4f 80 00       	push   $0x804fd0
  802bad:	e8 8b e6 ff ff       	call   80123d <cprintf>
  802bb2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802bb5:	83 ec 0c             	sub    $0xc,%esp
  802bb8:	68 fb 4f 80 00       	push   $0x804ffb
  802bbd:	e8 7b e6 ff ff       	call   80123d <cprintf>
  802bc2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bcb:	eb 37                	jmp    802c04 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802bcd:	83 ec 0c             	sub    $0xc,%esp
  802bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  802bd3:	e8 19 ff ff ff       	call   802af1 <is_free_block>
  802bd8:	83 c4 10             	add    $0x10,%esp
  802bdb:	0f be d8             	movsbl %al,%ebx
  802bde:	83 ec 0c             	sub    $0xc,%esp
  802be1:	ff 75 f4             	pushl  -0xc(%ebp)
  802be4:	e8 ef fe ff ff       	call   802ad8 <get_block_size>
  802be9:	83 c4 10             	add    $0x10,%esp
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	53                   	push   %ebx
  802bf0:	50                   	push   %eax
  802bf1:	68 13 50 80 00       	push   $0x805013
  802bf6:	e8 42 e6 ff ff       	call   80123d <cprintf>
  802bfb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  802c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	74 07                	je     802c11 <print_blocks_list+0x73>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	eb 05                	jmp    802c16 <print_blocks_list+0x78>
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	89 45 10             	mov    %eax,0x10(%ebp)
  802c19:	8b 45 10             	mov    0x10(%ebp),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	75 ad                	jne    802bcd <print_blocks_list+0x2f>
  802c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c24:	75 a7                	jne    802bcd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802c26:	83 ec 0c             	sub    $0xc,%esp
  802c29:	68 d0 4f 80 00       	push   $0x804fd0
  802c2e:	e8 0a e6 ff ff       	call   80123d <cprintf>
  802c33:	83 c4 10             	add    $0x10,%esp

}
  802c36:	90                   	nop
  802c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
  802c3f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c45:	83 e0 01             	and    $0x1,%eax
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	74 03                	je     802c4f <initialize_dynamic_allocator+0x13>
  802c4c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802c4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c53:	0f 84 c7 01 00 00    	je     802e20 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802c59:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802c60:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802c63:	8b 55 08             	mov    0x8(%ebp),%edx
  802c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802c70:	0f 87 ad 01 00 00    	ja     802e23 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	0f 89 a5 01 00 00    	jns    802e26 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c87:	01 d0                	add    %edx,%eax
  802c89:	83 e8 04             	sub    $0x4,%eax
  802c8c:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802c91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802c98:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca0:	e9 87 00 00 00       	jmp    802d2c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca9:	75 14                	jne    802cbf <initialize_dynamic_allocator+0x83>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 2b 50 80 00       	push   $0x80502b
  802cb3:	6a 79                	push   $0x79
  802cb5:	68 49 50 80 00       	push   $0x805049
  802cba:	e8 c1 e2 ff ff       	call   800f80 <_panic>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 10                	je     802cd8 <initialize_dynamic_allocator+0x9c>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd0:	8b 52 04             	mov    0x4(%edx),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
  802cd6:	eb 0b                	jmp    802ce3 <initialize_dynamic_allocator+0xa7>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	a3 30 60 80 00       	mov    %eax,0x806030
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0f                	je     802cfc <initialize_dynamic_allocator+0xc0>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf6:	8b 12                	mov    (%edx),%edx
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	eb 0a                	jmp    802d06 <initialize_dynamic_allocator+0xca>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d19:	a1 38 60 80 00       	mov    0x806038,%eax
  802d1e:	48                   	dec    %eax
  802d1f:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802d24:	a1 34 60 80 00       	mov    0x806034,%eax
  802d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d30:	74 07                	je     802d39 <initialize_dynamic_allocator+0xfd>
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	eb 05                	jmp    802d3e <initialize_dynamic_allocator+0x102>
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3e:	a3 34 60 80 00       	mov    %eax,0x806034
  802d43:	a1 34 60 80 00       	mov    0x806034,%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	0f 85 55 ff ff ff    	jne    802ca5 <initialize_dynamic_allocator+0x69>
  802d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d54:	0f 85 4b ff ff ff    	jne    802ca5 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802d69:	a1 44 60 80 00       	mov    0x806044,%eax
  802d6e:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802d73:	a1 40 60 80 00       	mov    0x806040,%eax
  802d78:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	83 c0 08             	add    $0x8,%eax
  802d84:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	83 c0 04             	add    $0x4,%eax
  802d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d90:	83 ea 08             	sub    $0x8,%edx
  802d93:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	01 d0                	add    %edx,%eax
  802d9d:	83 e8 08             	sub    $0x8,%eax
  802da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da3:	83 ea 08             	sub    $0x8,%edx
  802da6:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802dbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dbf:	75 17                	jne    802dd8 <initialize_dynamic_allocator+0x19c>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 64 50 80 00       	push   $0x805064
  802dc9:	68 90 00 00 00       	push   $0x90
  802dce:	68 49 50 80 00       	push   $0x805049
  802dd3:	e8 a8 e1 ff ff       	call   800f80 <_panic>
  802dd8:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	89 10                	mov    %edx,(%eax)
  802de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0d                	je     802df9 <initialize_dynamic_allocator+0x1bd>
  802dec:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802df1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	eb 08                	jmp    802e01 <initialize_dynamic_allocator+0x1c5>
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	a3 30 60 80 00       	mov    %eax,0x806030
  802e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e04:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 38 60 80 00       	mov    0x806038,%eax
  802e18:	40                   	inc    %eax
  802e19:	a3 38 60 80 00       	mov    %eax,0x806038
  802e1e:	eb 07                	jmp    802e27 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802e20:	90                   	nop
  802e21:	eb 04                	jmp    802e27 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802e23:	90                   	nop
  802e24:	eb 01                	jmp    802e27 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802e26:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802e27:	c9                   	leave  
  802e28:	c3                   	ret    

00802e29 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e2f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	83 e8 04             	sub    $0x4,%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	83 e0 fe             	and    $0xfffffffe,%eax
  802e48:	8d 50 f8             	lea    -0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e53:	89 02                	mov    %eax,(%edx)
}
  802e55:	90                   	nop
  802e56:	5d                   	pop    %ebp
  802e57:	c3                   	ret    

00802e58 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
  802e5b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	83 e0 01             	and    $0x1,%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 03                	je     802e6b <alloc_block_FF+0x13>
  802e68:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e6b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e6f:	77 07                	ja     802e78 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e71:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e78:	a1 24 60 80 00       	mov    0x806024,%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	75 73                	jne    802ef4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	83 c0 10             	add    $0x10,%eax
  802e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e8a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802e91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e97:	01 d0                	add    %edx,%eax
  802e99:	48                   	dec    %eax
  802e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea5:	f7 75 ec             	divl   -0x14(%ebp)
  802ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eab:	29 d0                	sub    %edx,%eax
  802ead:	c1 e8 0c             	shr    $0xc,%eax
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	50                   	push   %eax
  802eb4:	e8 1e f1 ff ff       	call   801fd7 <sbrk>
  802eb9:	83 c4 10             	add    $0x10,%esp
  802ebc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ebf:	83 ec 0c             	sub    $0xc,%esp
  802ec2:	6a 00                	push   $0x0
  802ec4:	e8 0e f1 ff ff       	call   801fd7 <sbrk>
  802ec9:	83 c4 10             	add    $0x10,%esp
  802ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ecf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ed5:	83 ec 08             	sub    $0x8,%esp
  802ed8:	50                   	push   %eax
  802ed9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802edc:	e8 5b fd ff ff       	call   802c3c <initialize_dynamic_allocator>
  802ee1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ee4:	83 ec 0c             	sub    $0xc,%esp
  802ee7:	68 87 50 80 00       	push   $0x805087
  802eec:	e8 4c e3 ff ff       	call   80123d <cprintf>
  802ef1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef8:	75 0a                	jne    802f04 <alloc_block_FF+0xac>
	        return NULL;
  802efa:	b8 00 00 00 00       	mov    $0x0,%eax
  802eff:	e9 0e 04 00 00       	jmp    803312 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802f04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f0b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f13:	e9 f3 02 00 00       	jmp    80320b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 bc             	pushl  -0x44(%ebp)
  802f24:	e8 af fb ff ff       	call   802ad8 <get_block_size>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	83 c0 08             	add    $0x8,%eax
  802f35:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802f38:	0f 87 c5 02 00 00    	ja     803203 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	83 c0 18             	add    $0x18,%eax
  802f44:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802f47:	0f 87 19 02 00 00    	ja     803166 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802f4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f50:	2b 45 08             	sub    0x8(%ebp),%eax
  802f53:	83 e8 08             	sub    $0x8,%eax
  802f56:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8d 50 08             	lea    0x8(%eax),%edx
  802f5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f62:	01 d0                	add    %edx,%eax
  802f64:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	83 c0 08             	add    $0x8,%eax
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	6a 01                	push   $0x1
  802f72:	50                   	push   %eax
  802f73:	ff 75 bc             	pushl  -0x44(%ebp)
  802f76:	e8 ae fe ff ff       	call   802e29 <set_block_data>
  802f7b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	85 c0                	test   %eax,%eax
  802f86:	75 68                	jne    802ff0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f88:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802f8c:	75 17                	jne    802fa5 <alloc_block_FF+0x14d>
  802f8e:	83 ec 04             	sub    $0x4,%esp
  802f91:	68 64 50 80 00       	push   $0x805064
  802f96:	68 d7 00 00 00       	push   $0xd7
  802f9b:	68 49 50 80 00       	push   $0x805049
  802fa0:	e8 db df ff ff       	call   800f80 <_panic>
  802fa5:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802fab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fae:	89 10                	mov    %edx,(%eax)
  802fb0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0d                	je     802fc6 <alloc_block_FF+0x16e>
  802fb9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802fbe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	eb 08                	jmp    802fce <alloc_block_FF+0x176>
  802fc6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fc9:	a3 30 60 80 00       	mov    %eax,0x806030
  802fce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fd1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802fd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe0:	a1 38 60 80 00       	mov    0x806038,%eax
  802fe5:	40                   	inc    %eax
  802fe6:	a3 38 60 80 00       	mov    %eax,0x806038
  802feb:	e9 dc 00 00 00       	jmp    8030cc <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	75 65                	jne    80305e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ff9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ffd:	75 17                	jne    803016 <alloc_block_FF+0x1be>
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	68 98 50 80 00       	push   $0x805098
  803007:	68 db 00 00 00       	push   $0xdb
  80300c:	68 49 50 80 00       	push   $0x805049
  803011:	e8 6a df ff ff       	call   800f80 <_panic>
  803016:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80301c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0c                	je     803038 <alloc_block_FF+0x1e0>
  80302c:	a1 30 60 80 00       	mov    0x806030,%eax
  803031:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803034:	89 10                	mov    %edx,(%eax)
  803036:	eb 08                	jmp    803040 <alloc_block_FF+0x1e8>
  803038:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80303b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803040:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803043:	a3 30 60 80 00       	mov    %eax,0x806030
  803048:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80304b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803051:	a1 38 60 80 00       	mov    0x806038,%eax
  803056:	40                   	inc    %eax
  803057:	a3 38 60 80 00       	mov    %eax,0x806038
  80305c:	eb 6e                	jmp    8030cc <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	74 06                	je     80306a <alloc_block_FF+0x212>
  803064:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803068:	75 17                	jne    803081 <alloc_block_FF+0x229>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 bc 50 80 00       	push   $0x8050bc
  803072:	68 df 00 00 00       	push   $0xdf
  803077:	68 49 50 80 00       	push   $0x805049
  80307c:	e8 ff de ff ff       	call   800f80 <_panic>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 10                	mov    (%eax),%edx
  803086:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0b                	je     80309f <alloc_block_FF+0x247>
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	75 08                	jne    8030c1 <alloc_block_FF+0x269>
  8030b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030bc:	a3 30 60 80 00       	mov    %eax,0x806030
  8030c1:	a1 38 60 80 00       	mov    0x806038,%eax
  8030c6:	40                   	inc    %eax
  8030c7:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8030cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d0:	75 17                	jne    8030e9 <alloc_block_FF+0x291>
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	68 2b 50 80 00       	push   $0x80502b
  8030da:	68 e1 00 00 00       	push   $0xe1
  8030df:	68 49 50 80 00       	push   $0x805049
  8030e4:	e8 97 de ff ff       	call   800f80 <_panic>
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	74 10                	je     803102 <alloc_block_FF+0x2aa>
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030fa:	8b 52 04             	mov    0x4(%edx),%edx
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	eb 0b                	jmp    80310d <alloc_block_FF+0x2b5>
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 40 04             	mov    0x4(%eax),%eax
  803108:	a3 30 60 80 00       	mov    %eax,0x806030
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 40 04             	mov    0x4(%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0f                	je     803126 <alloc_block_FF+0x2ce>
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 04             	mov    0x4(%eax),%eax
  80311d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803120:	8b 12                	mov    (%edx),%edx
  803122:	89 10                	mov    %edx,(%eax)
  803124:	eb 0a                	jmp    803130 <alloc_block_FF+0x2d8>
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803143:	a1 38 60 80 00       	mov    0x806038,%eax
  803148:	48                   	dec    %eax
  803149:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	6a 00                	push   $0x0
  803153:	ff 75 b4             	pushl  -0x4c(%ebp)
  803156:	ff 75 b0             	pushl  -0x50(%ebp)
  803159:	e8 cb fc ff ff       	call   802e29 <set_block_data>
  80315e:	83 c4 10             	add    $0x10,%esp
  803161:	e9 95 00 00 00       	jmp    8031fb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	6a 01                	push   $0x1
  80316b:	ff 75 b8             	pushl  -0x48(%ebp)
  80316e:	ff 75 bc             	pushl  -0x44(%ebp)
  803171:	e8 b3 fc ff ff       	call   802e29 <set_block_data>
  803176:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317d:	75 17                	jne    803196 <alloc_block_FF+0x33e>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 2b 50 80 00       	push   $0x80502b
  803187:	68 e8 00 00 00       	push   $0xe8
  80318c:	68 49 50 80 00       	push   $0x805049
  803191:	e8 ea dd ff ff       	call   800f80 <_panic>
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 10                	je     8031af <alloc_block_FF+0x357>
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a7:	8b 52 04             	mov    0x4(%edx),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%eax)
  8031ad:	eb 0b                	jmp    8031ba <alloc_block_FF+0x362>
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	a3 30 60 80 00       	mov    %eax,0x806030
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 0f                	je     8031d3 <alloc_block_FF+0x37b>
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cd:	8b 12                	mov    (%edx),%edx
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	eb 0a                	jmp    8031dd <alloc_block_FF+0x385>
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 38 60 80 00       	mov    0x806038,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  8031fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031fe:	e9 0f 01 00 00       	jmp    803312 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803203:	a1 34 60 80 00       	mov    0x806034,%eax
  803208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320f:	74 07                	je     803218 <alloc_block_FF+0x3c0>
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	eb 05                	jmp    80321d <alloc_block_FF+0x3c5>
  803218:	b8 00 00 00 00       	mov    $0x0,%eax
  80321d:	a3 34 60 80 00       	mov    %eax,0x806034
  803222:	a1 34 60 80 00       	mov    0x806034,%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	0f 85 e9 fc ff ff    	jne    802f18 <alloc_block_FF+0xc0>
  80322f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803233:	0f 85 df fc ff ff    	jne    802f18 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	83 c0 08             	add    $0x8,%eax
  80323f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803242:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803249:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80324f:	01 d0                	add    %edx,%eax
  803251:	48                   	dec    %eax
  803252:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803255:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803258:	ba 00 00 00 00       	mov    $0x0,%edx
  80325d:	f7 75 d8             	divl   -0x28(%ebp)
  803260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803263:	29 d0                	sub    %edx,%eax
  803265:	c1 e8 0c             	shr    $0xc,%eax
  803268:	83 ec 0c             	sub    $0xc,%esp
  80326b:	50                   	push   %eax
  80326c:	e8 66 ed ff ff       	call   801fd7 <sbrk>
  803271:	83 c4 10             	add    $0x10,%esp
  803274:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803277:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80327b:	75 0a                	jne    803287 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80327d:	b8 00 00 00 00       	mov    $0x0,%eax
  803282:	e9 8b 00 00 00       	jmp    803312 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803287:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80328e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803291:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803294:	01 d0                	add    %edx,%eax
  803296:	48                   	dec    %eax
  803297:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80329a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80329d:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a2:	f7 75 cc             	divl   -0x34(%ebp)
  8032a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a8:	29 d0                	sub    %edx,%eax
  8032aa:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032b0:	01 d0                	add    %edx,%eax
  8032b2:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8032b7:	a1 40 60 80 00       	mov    0x806040,%eax
  8032bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032c2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032cf:	01 d0                	add    %edx,%eax
  8032d1:	48                   	dec    %eax
  8032d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032dd:	f7 75 c4             	divl   -0x3c(%ebp)
  8032e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032e3:	29 d0                	sub    %edx,%eax
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	6a 01                	push   $0x1
  8032ea:	50                   	push   %eax
  8032eb:	ff 75 d0             	pushl  -0x30(%ebp)
  8032ee:	e8 36 fb ff ff       	call   802e29 <set_block_data>
  8032f3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8032f6:	83 ec 0c             	sub    $0xc,%esp
  8032f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8032fc:	e8 1b 0a 00 00       	call   803d1c <free_block>
  803301:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803304:	83 ec 0c             	sub    $0xc,%esp
  803307:	ff 75 08             	pushl  0x8(%ebp)
  80330a:	e8 49 fb ff ff       	call   802e58 <alloc_block_FF>
  80330f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803312:	c9                   	leave  
  803313:	c3                   	ret    

00803314 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803314:	55                   	push   %ebp
  803315:	89 e5                	mov    %esp,%ebp
  803317:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	83 e0 01             	and    $0x1,%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 03                	je     803327 <alloc_block_BF+0x13>
  803324:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803327:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80332b:	77 07                	ja     803334 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80332d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803334:	a1 24 60 80 00       	mov    0x806024,%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	75 73                	jne    8033b0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	83 c0 10             	add    $0x10,%eax
  803343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803346:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80334d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803353:	01 d0                	add    %edx,%eax
  803355:	48                   	dec    %eax
  803356:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335c:	ba 00 00 00 00       	mov    $0x0,%edx
  803361:	f7 75 e0             	divl   -0x20(%ebp)
  803364:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803367:	29 d0                	sub    %edx,%eax
  803369:	c1 e8 0c             	shr    $0xc,%eax
  80336c:	83 ec 0c             	sub    $0xc,%esp
  80336f:	50                   	push   %eax
  803370:	e8 62 ec ff ff       	call   801fd7 <sbrk>
  803375:	83 c4 10             	add    $0x10,%esp
  803378:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80337b:	83 ec 0c             	sub    $0xc,%esp
  80337e:	6a 00                	push   $0x0
  803380:	e8 52 ec ff ff       	call   801fd7 <sbrk>
  803385:	83 c4 10             	add    $0x10,%esp
  803388:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80338b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803391:	83 ec 08             	sub    $0x8,%esp
  803394:	50                   	push   %eax
  803395:	ff 75 d8             	pushl  -0x28(%ebp)
  803398:	e8 9f f8 ff ff       	call   802c3c <initialize_dynamic_allocator>
  80339d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8033a0:	83 ec 0c             	sub    $0xc,%esp
  8033a3:	68 87 50 80 00       	push   $0x805087
  8033a8:	e8 90 de ff ff       	call   80123d <cprintf>
  8033ad:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8033b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8033b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8033be:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8033c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8033cc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8033d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d4:	e9 1d 01 00 00       	jmp    8034f6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8033df:	83 ec 0c             	sub    $0xc,%esp
  8033e2:	ff 75 a8             	pushl  -0x58(%ebp)
  8033e5:	e8 ee f6 ff ff       	call   802ad8 <get_block_size>
  8033ea:	83 c4 10             	add    $0x10,%esp
  8033ed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	83 c0 08             	add    $0x8,%eax
  8033f6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8033f9:	0f 87 ef 00 00 00    	ja     8034ee <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	83 c0 18             	add    $0x18,%eax
  803405:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803408:	77 1d                	ja     803427 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803410:	0f 86 d8 00 00 00    	jbe    8034ee <alloc_block_BF+0x1da>
				{
					best_va = va;
  803416:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803419:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80341c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80341f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803422:	e9 c7 00 00 00       	jmp    8034ee <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	83 c0 08             	add    $0x8,%eax
  80342d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803430:	0f 85 9d 00 00 00    	jne    8034d3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803436:	83 ec 04             	sub    $0x4,%esp
  803439:	6a 01                	push   $0x1
  80343b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80343e:	ff 75 a8             	pushl  -0x58(%ebp)
  803441:	e8 e3 f9 ff ff       	call   802e29 <set_block_data>
  803446:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344d:	75 17                	jne    803466 <alloc_block_BF+0x152>
  80344f:	83 ec 04             	sub    $0x4,%esp
  803452:	68 2b 50 80 00       	push   $0x80502b
  803457:	68 2c 01 00 00       	push   $0x12c
  80345c:	68 49 50 80 00       	push   $0x805049
  803461:	e8 1a db ff ff       	call   800f80 <_panic>
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 10                	je     80347f <alloc_block_BF+0x16b>
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803477:	8b 52 04             	mov    0x4(%edx),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	eb 0b                	jmp    80348a <alloc_block_BF+0x176>
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	a3 30 60 80 00       	mov    %eax,0x806030
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 40 04             	mov    0x4(%eax),%eax
  803490:	85 c0                	test   %eax,%eax
  803492:	74 0f                	je     8034a3 <alloc_block_BF+0x18f>
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 40 04             	mov    0x4(%eax),%eax
  80349a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349d:	8b 12                	mov    (%edx),%edx
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	eb 0a                	jmp    8034ad <alloc_block_BF+0x199>
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 38 60 80 00       	mov    0x806038,%eax
  8034c5:	48                   	dec    %eax
  8034c6:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  8034cb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8034ce:	e9 24 04 00 00       	jmp    8038f7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8034d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034d9:	76 13                	jbe    8034ee <alloc_block_BF+0x1da>
					{
						internal = 1;
  8034db:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8034e2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8034e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8034e8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8034eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8034ee:	a1 34 60 80 00       	mov    0x806034,%eax
  8034f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034fa:	74 07                	je     803503 <alloc_block_BF+0x1ef>
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	eb 05                	jmp    803508 <alloc_block_BF+0x1f4>
  803503:	b8 00 00 00 00       	mov    $0x0,%eax
  803508:	a3 34 60 80 00       	mov    %eax,0x806034
  80350d:	a1 34 60 80 00       	mov    0x806034,%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	0f 85 bf fe ff ff    	jne    8033d9 <alloc_block_BF+0xc5>
  80351a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351e:	0f 85 b5 fe ff ff    	jne    8033d9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803524:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803528:	0f 84 26 02 00 00    	je     803754 <alloc_block_BF+0x440>
  80352e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803532:	0f 85 1c 02 00 00    	jne    803754 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353b:	2b 45 08             	sub    0x8(%ebp),%eax
  80353e:	83 e8 08             	sub    $0x8,%eax
  803541:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	8d 50 08             	lea    0x8(%eax),%edx
  80354a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354d:	01 d0                	add    %edx,%eax
  80354f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	83 c0 08             	add    $0x8,%eax
  803558:	83 ec 04             	sub    $0x4,%esp
  80355b:	6a 01                	push   $0x1
  80355d:	50                   	push   %eax
  80355e:	ff 75 f0             	pushl  -0x10(%ebp)
  803561:	e8 c3 f8 ff ff       	call   802e29 <set_block_data>
  803566:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356c:	8b 40 04             	mov    0x4(%eax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	75 68                	jne    8035db <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803573:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803577:	75 17                	jne    803590 <alloc_block_BF+0x27c>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 64 50 80 00       	push   $0x805064
  803581:	68 45 01 00 00       	push   $0x145
  803586:	68 49 50 80 00       	push   $0x805049
  80358b:	e8 f0 d9 ff ff       	call   800f80 <_panic>
  803590:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803596:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 0d                	je     8035b1 <alloc_block_BF+0x29d>
  8035a4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8035a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 08                	jmp    8035b9 <alloc_block_BF+0x2a5>
  8035b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035b4:	a3 30 60 80 00       	mov    %eax,0x806030
  8035b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035bc:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8035c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 38 60 80 00       	mov    0x806038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 60 80 00       	mov    %eax,0x806038
  8035d6:	e9 dc 00 00 00       	jmp    8036b7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8035db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	75 65                	jne    803649 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8035e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035e8:	75 17                	jne    803601 <alloc_block_BF+0x2ed>
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	68 98 50 80 00       	push   $0x805098
  8035f2:	68 4a 01 00 00       	push   $0x14a
  8035f7:	68 49 50 80 00       	push   $0x805049
  8035fc:	e8 7f d9 ff ff       	call   800f80 <_panic>
  803601:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803607:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	74 0c                	je     803623 <alloc_block_BF+0x30f>
  803617:	a1 30 60 80 00       	mov    0x806030,%eax
  80361c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80361f:	89 10                	mov    %edx,(%eax)
  803621:	eb 08                	jmp    80362b <alloc_block_BF+0x317>
  803623:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803626:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80362b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80362e:	a3 30 60 80 00       	mov    %eax,0x806030
  803633:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363c:	a1 38 60 80 00       	mov    0x806038,%eax
  803641:	40                   	inc    %eax
  803642:	a3 38 60 80 00       	mov    %eax,0x806038
  803647:	eb 6e                	jmp    8036b7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803649:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80364d:	74 06                	je     803655 <alloc_block_BF+0x341>
  80364f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803653:	75 17                	jne    80366c <alloc_block_BF+0x358>
  803655:	83 ec 04             	sub    $0x4,%esp
  803658:	68 bc 50 80 00       	push   $0x8050bc
  80365d:	68 4f 01 00 00       	push   $0x14f
  803662:	68 49 50 80 00       	push   $0x805049
  803667:	e8 14 d9 ff ff       	call   800f80 <_panic>
  80366c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366f:	8b 10                	mov    (%eax),%edx
  803671:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803674:	89 10                	mov    %edx,(%eax)
  803676:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0b                	je     80368a <alloc_block_BF+0x376>
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803690:	89 10                	mov    %edx,(%eax)
  803692:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803695:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803698:	89 50 04             	mov    %edx,0x4(%eax)
  80369b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	75 08                	jne    8036ac <alloc_block_BF+0x398>
  8036a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036a7:	a3 30 60 80 00       	mov    %eax,0x806030
  8036ac:	a1 38 60 80 00       	mov    0x806038,%eax
  8036b1:	40                   	inc    %eax
  8036b2:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8036b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036bb:	75 17                	jne    8036d4 <alloc_block_BF+0x3c0>
  8036bd:	83 ec 04             	sub    $0x4,%esp
  8036c0:	68 2b 50 80 00       	push   $0x80502b
  8036c5:	68 51 01 00 00       	push   $0x151
  8036ca:	68 49 50 80 00       	push   $0x805049
  8036cf:	e8 ac d8 ff ff       	call   800f80 <_panic>
  8036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	74 10                	je     8036ed <alloc_block_BF+0x3d9>
  8036dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e5:	8b 52 04             	mov    0x4(%edx),%edx
  8036e8:	89 50 04             	mov    %edx,0x4(%eax)
  8036eb:	eb 0b                	jmp    8036f8 <alloc_block_BF+0x3e4>
  8036ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f0:	8b 40 04             	mov    0x4(%eax),%eax
  8036f3:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fb:	8b 40 04             	mov    0x4(%eax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 0f                	je     803711 <alloc_block_BF+0x3fd>
  803702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803705:	8b 40 04             	mov    0x4(%eax),%eax
  803708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370b:	8b 12                	mov    (%edx),%edx
  80370d:	89 10                	mov    %edx,(%eax)
  80370f:	eb 0a                	jmp    80371b <alloc_block_BF+0x407>
  803711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803727:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372e:	a1 38 60 80 00       	mov    0x806038,%eax
  803733:	48                   	dec    %eax
  803734:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	6a 00                	push   $0x0
  80373e:	ff 75 d0             	pushl  -0x30(%ebp)
  803741:	ff 75 cc             	pushl  -0x34(%ebp)
  803744:	e8 e0 f6 ff ff       	call   802e29 <set_block_data>
  803749:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	e9 a3 01 00 00       	jmp    8038f7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803754:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803758:	0f 85 9d 00 00 00    	jne    8037fb <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	6a 01                	push   $0x1
  803763:	ff 75 ec             	pushl  -0x14(%ebp)
  803766:	ff 75 f0             	pushl  -0x10(%ebp)
  803769:	e8 bb f6 ff ff       	call   802e29 <set_block_data>
  80376e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803775:	75 17                	jne    80378e <alloc_block_BF+0x47a>
  803777:	83 ec 04             	sub    $0x4,%esp
  80377a:	68 2b 50 80 00       	push   $0x80502b
  80377f:	68 58 01 00 00       	push   $0x158
  803784:	68 49 50 80 00       	push   $0x805049
  803789:	e8 f2 d7 ff ff       	call   800f80 <_panic>
  80378e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	85 c0                	test   %eax,%eax
  803795:	74 10                	je     8037a7 <alloc_block_BF+0x493>
  803797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80379f:	8b 52 04             	mov    0x4(%edx),%edx
  8037a2:	89 50 04             	mov    %edx,0x4(%eax)
  8037a5:	eb 0b                	jmp    8037b2 <alloc_block_BF+0x49e>
  8037a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037aa:	8b 40 04             	mov    0x4(%eax),%eax
  8037ad:	a3 30 60 80 00       	mov    %eax,0x806030
  8037b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	85 c0                	test   %eax,%eax
  8037ba:	74 0f                	je     8037cb <alloc_block_BF+0x4b7>
  8037bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bf:	8b 40 04             	mov    0x4(%eax),%eax
  8037c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c5:	8b 12                	mov    (%edx),%edx
  8037c7:	89 10                	mov    %edx,(%eax)
  8037c9:	eb 0a                	jmp    8037d5 <alloc_block_BF+0x4c1>
  8037cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ce:	8b 00                	mov    (%eax),%eax
  8037d0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e8:	a1 38 60 80 00       	mov    0x806038,%eax
  8037ed:	48                   	dec    %eax
  8037ee:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  8037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f6:	e9 fc 00 00 00       	jmp    8038f7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	83 c0 08             	add    $0x8,%eax
  803801:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803804:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80380b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80380e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803811:	01 d0                	add    %edx,%eax
  803813:	48                   	dec    %eax
  803814:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803817:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80381a:	ba 00 00 00 00       	mov    $0x0,%edx
  80381f:	f7 75 c4             	divl   -0x3c(%ebp)
  803822:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803825:	29 d0                	sub    %edx,%eax
  803827:	c1 e8 0c             	shr    $0xc,%eax
  80382a:	83 ec 0c             	sub    $0xc,%esp
  80382d:	50                   	push   %eax
  80382e:	e8 a4 e7 ff ff       	call   801fd7 <sbrk>
  803833:	83 c4 10             	add    $0x10,%esp
  803836:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803839:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80383d:	75 0a                	jne    803849 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80383f:	b8 00 00 00 00       	mov    $0x0,%eax
  803844:	e9 ae 00 00 00       	jmp    8038f7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803849:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803850:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803853:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803856:	01 d0                	add    %edx,%eax
  803858:	48                   	dec    %eax
  803859:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80385c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80385f:	ba 00 00 00 00       	mov    $0x0,%edx
  803864:	f7 75 b8             	divl   -0x48(%ebp)
  803867:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80386a:	29 d0                	sub    %edx,%eax
  80386c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80386f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803872:	01 d0                	add    %edx,%eax
  803874:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803879:	a1 40 60 80 00       	mov    0x806040,%eax
  80387e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803884:	83 ec 0c             	sub    $0xc,%esp
  803887:	68 f0 50 80 00       	push   $0x8050f0
  80388c:	e8 ac d9 ff ff       	call   80123d <cprintf>
  803891:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803894:	83 ec 08             	sub    $0x8,%esp
  803897:	ff 75 bc             	pushl  -0x44(%ebp)
  80389a:	68 f5 50 80 00       	push   $0x8050f5
  80389f:	e8 99 d9 ff ff       	call   80123d <cprintf>
  8038a4:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8038a7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8038ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038b4:	01 d0                	add    %edx,%eax
  8038b6:	48                   	dec    %eax
  8038b7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8038ba:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8038bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8038c2:	f7 75 b0             	divl   -0x50(%ebp)
  8038c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8038c8:	29 d0                	sub    %edx,%eax
  8038ca:	83 ec 04             	sub    $0x4,%esp
  8038cd:	6a 01                	push   $0x1
  8038cf:	50                   	push   %eax
  8038d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8038d3:	e8 51 f5 ff ff       	call   802e29 <set_block_data>
  8038d8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8038db:	83 ec 0c             	sub    $0xc,%esp
  8038de:	ff 75 bc             	pushl  -0x44(%ebp)
  8038e1:	e8 36 04 00 00       	call   803d1c <free_block>
  8038e6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8038e9:	83 ec 0c             	sub    $0xc,%esp
  8038ec:	ff 75 08             	pushl  0x8(%ebp)
  8038ef:	e8 20 fa ff ff       	call   803314 <alloc_block_BF>
  8038f4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8038f7:	c9                   	leave  
  8038f8:	c3                   	ret    

008038f9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8038f9:	55                   	push   %ebp
  8038fa:	89 e5                	mov    %esp,%ebp
  8038fc:	53                   	push   %ebx
  8038fd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803907:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80390e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803912:	74 1e                	je     803932 <merging+0x39>
  803914:	ff 75 08             	pushl  0x8(%ebp)
  803917:	e8 bc f1 ff ff       	call   802ad8 <get_block_size>
  80391c:	83 c4 04             	add    $0x4,%esp
  80391f:	89 c2                	mov    %eax,%edx
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	01 d0                	add    %edx,%eax
  803926:	3b 45 10             	cmp    0x10(%ebp),%eax
  803929:	75 07                	jne    803932 <merging+0x39>
		prev_is_free = 1;
  80392b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803932:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803936:	74 1e                	je     803956 <merging+0x5d>
  803938:	ff 75 10             	pushl  0x10(%ebp)
  80393b:	e8 98 f1 ff ff       	call   802ad8 <get_block_size>
  803940:	83 c4 04             	add    $0x4,%esp
  803943:	89 c2                	mov    %eax,%edx
  803945:	8b 45 10             	mov    0x10(%ebp),%eax
  803948:	01 d0                	add    %edx,%eax
  80394a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80394d:	75 07                	jne    803956 <merging+0x5d>
		next_is_free = 1;
  80394f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395a:	0f 84 cc 00 00 00    	je     803a2c <merging+0x133>
  803960:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803964:	0f 84 c2 00 00 00    	je     803a2c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80396a:	ff 75 08             	pushl  0x8(%ebp)
  80396d:	e8 66 f1 ff ff       	call   802ad8 <get_block_size>
  803972:	83 c4 04             	add    $0x4,%esp
  803975:	89 c3                	mov    %eax,%ebx
  803977:	ff 75 10             	pushl  0x10(%ebp)
  80397a:	e8 59 f1 ff ff       	call   802ad8 <get_block_size>
  80397f:	83 c4 04             	add    $0x4,%esp
  803982:	01 c3                	add    %eax,%ebx
  803984:	ff 75 0c             	pushl  0xc(%ebp)
  803987:	e8 4c f1 ff ff       	call   802ad8 <get_block_size>
  80398c:	83 c4 04             	add    $0x4,%esp
  80398f:	01 d8                	add    %ebx,%eax
  803991:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803994:	6a 00                	push   $0x0
  803996:	ff 75 ec             	pushl  -0x14(%ebp)
  803999:	ff 75 08             	pushl  0x8(%ebp)
  80399c:	e8 88 f4 ff ff       	call   802e29 <set_block_data>
  8039a1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8039a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039a8:	75 17                	jne    8039c1 <merging+0xc8>
  8039aa:	83 ec 04             	sub    $0x4,%esp
  8039ad:	68 2b 50 80 00       	push   $0x80502b
  8039b2:	68 7d 01 00 00       	push   $0x17d
  8039b7:	68 49 50 80 00       	push   $0x805049
  8039bc:	e8 bf d5 ff ff       	call   800f80 <_panic>
  8039c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 10                	je     8039da <merging+0xe1>
  8039ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cd:	8b 00                	mov    (%eax),%eax
  8039cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d2:	8b 52 04             	mov    0x4(%edx),%edx
  8039d5:	89 50 04             	mov    %edx,0x4(%eax)
  8039d8:	eb 0b                	jmp    8039e5 <merging+0xec>
  8039da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039dd:	8b 40 04             	mov    0x4(%eax),%eax
  8039e0:	a3 30 60 80 00       	mov    %eax,0x806030
  8039e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e8:	8b 40 04             	mov    0x4(%eax),%eax
  8039eb:	85 c0                	test   %eax,%eax
  8039ed:	74 0f                	je     8039fe <merging+0x105>
  8039ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f2:	8b 40 04             	mov    0x4(%eax),%eax
  8039f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f8:	8b 12                	mov    (%edx),%edx
  8039fa:	89 10                	mov    %edx,(%eax)
  8039fc:	eb 0a                	jmp    803a08 <merging+0x10f>
  8039fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1b:	a1 38 60 80 00       	mov    0x806038,%eax
  803a20:	48                   	dec    %eax
  803a21:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803a26:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803a27:	e9 ea 02 00 00       	jmp    803d16 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a30:	74 3b                	je     803a6d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803a32:	83 ec 0c             	sub    $0xc,%esp
  803a35:	ff 75 08             	pushl  0x8(%ebp)
  803a38:	e8 9b f0 ff ff       	call   802ad8 <get_block_size>
  803a3d:	83 c4 10             	add    $0x10,%esp
  803a40:	89 c3                	mov    %eax,%ebx
  803a42:	83 ec 0c             	sub    $0xc,%esp
  803a45:	ff 75 10             	pushl  0x10(%ebp)
  803a48:	e8 8b f0 ff ff       	call   802ad8 <get_block_size>
  803a4d:	83 c4 10             	add    $0x10,%esp
  803a50:	01 d8                	add    %ebx,%eax
  803a52:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803a55:	83 ec 04             	sub    $0x4,%esp
  803a58:	6a 00                	push   $0x0
  803a5a:	ff 75 e8             	pushl  -0x18(%ebp)
  803a5d:	ff 75 08             	pushl  0x8(%ebp)
  803a60:	e8 c4 f3 ff ff       	call   802e29 <set_block_data>
  803a65:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803a68:	e9 a9 02 00 00       	jmp    803d16 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803a6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a71:	0f 84 2d 01 00 00    	je     803ba4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803a77:	83 ec 0c             	sub    $0xc,%esp
  803a7a:	ff 75 10             	pushl  0x10(%ebp)
  803a7d:	e8 56 f0 ff ff       	call   802ad8 <get_block_size>
  803a82:	83 c4 10             	add    $0x10,%esp
  803a85:	89 c3                	mov    %eax,%ebx
  803a87:	83 ec 0c             	sub    $0xc,%esp
  803a8a:	ff 75 0c             	pushl  0xc(%ebp)
  803a8d:	e8 46 f0 ff ff       	call   802ad8 <get_block_size>
  803a92:	83 c4 10             	add    $0x10,%esp
  803a95:	01 d8                	add    %ebx,%eax
  803a97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803a9a:	83 ec 04             	sub    $0x4,%esp
  803a9d:	6a 00                	push   $0x0
  803a9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aa2:	ff 75 10             	pushl  0x10(%ebp)
  803aa5:	e8 7f f3 ff ff       	call   802e29 <set_block_data>
  803aaa:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803aad:	8b 45 10             	mov    0x10(%ebp),%eax
  803ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803ab3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ab7:	74 06                	je     803abf <merging+0x1c6>
  803ab9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803abd:	75 17                	jne    803ad6 <merging+0x1dd>
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	68 04 51 80 00       	push   $0x805104
  803ac7:	68 8d 01 00 00       	push   $0x18d
  803acc:	68 49 50 80 00       	push   $0x805049
  803ad1:	e8 aa d4 ff ff       	call   800f80 <_panic>
  803ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad9:	8b 50 04             	mov    0x4(%eax),%edx
  803adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803adf:	89 50 04             	mov    %edx,0x4(%eax)
  803ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ae8:	89 10                	mov    %edx,(%eax)
  803aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aed:	8b 40 04             	mov    0x4(%eax),%eax
  803af0:	85 c0                	test   %eax,%eax
  803af2:	74 0d                	je     803b01 <merging+0x208>
  803af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af7:	8b 40 04             	mov    0x4(%eax),%eax
  803afa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803afd:	89 10                	mov    %edx,(%eax)
  803aff:	eb 08                	jmp    803b09 <merging+0x210>
  803b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b04:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b0f:	89 50 04             	mov    %edx,0x4(%eax)
  803b12:	a1 38 60 80 00       	mov    0x806038,%eax
  803b17:	40                   	inc    %eax
  803b18:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803b1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b21:	75 17                	jne    803b3a <merging+0x241>
  803b23:	83 ec 04             	sub    $0x4,%esp
  803b26:	68 2b 50 80 00       	push   $0x80502b
  803b2b:	68 8e 01 00 00       	push   $0x18e
  803b30:	68 49 50 80 00       	push   $0x805049
  803b35:	e8 46 d4 ff ff       	call   800f80 <_panic>
  803b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3d:	8b 00                	mov    (%eax),%eax
  803b3f:	85 c0                	test   %eax,%eax
  803b41:	74 10                	je     803b53 <merging+0x25a>
  803b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b46:	8b 00                	mov    (%eax),%eax
  803b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b4b:	8b 52 04             	mov    0x4(%edx),%edx
  803b4e:	89 50 04             	mov    %edx,0x4(%eax)
  803b51:	eb 0b                	jmp    803b5e <merging+0x265>
  803b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b56:	8b 40 04             	mov    0x4(%eax),%eax
  803b59:	a3 30 60 80 00       	mov    %eax,0x806030
  803b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b61:	8b 40 04             	mov    0x4(%eax),%eax
  803b64:	85 c0                	test   %eax,%eax
  803b66:	74 0f                	je     803b77 <merging+0x27e>
  803b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6b:	8b 40 04             	mov    0x4(%eax),%eax
  803b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b71:	8b 12                	mov    (%edx),%edx
  803b73:	89 10                	mov    %edx,(%eax)
  803b75:	eb 0a                	jmp    803b81 <merging+0x288>
  803b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7a:	8b 00                	mov    (%eax),%eax
  803b7c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b94:	a1 38 60 80 00       	mov    0x806038,%eax
  803b99:	48                   	dec    %eax
  803b9a:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b9f:	e9 72 01 00 00       	jmp    803d16 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  803ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803baa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bae:	74 79                	je     803c29 <merging+0x330>
  803bb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bb4:	74 73                	je     803c29 <merging+0x330>
  803bb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bba:	74 06                	je     803bc2 <merging+0x2c9>
  803bbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803bc0:	75 17                	jne    803bd9 <merging+0x2e0>
  803bc2:	83 ec 04             	sub    $0x4,%esp
  803bc5:	68 bc 50 80 00       	push   $0x8050bc
  803bca:	68 94 01 00 00       	push   $0x194
  803bcf:	68 49 50 80 00       	push   $0x805049
  803bd4:	e8 a7 d3 ff ff       	call   800f80 <_panic>
  803bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdc:	8b 10                	mov    (%eax),%edx
  803bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 0b                	je     803bf7 <merging+0x2fe>
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bf4:	89 50 04             	mov    %edx,0x4(%eax)
  803bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bfd:	89 10                	mov    %edx,(%eax)
  803bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c02:	8b 55 08             	mov    0x8(%ebp),%edx
  803c05:	89 50 04             	mov    %edx,0x4(%eax)
  803c08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c0b:	8b 00                	mov    (%eax),%eax
  803c0d:	85 c0                	test   %eax,%eax
  803c0f:	75 08                	jne    803c19 <merging+0x320>
  803c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c14:	a3 30 60 80 00       	mov    %eax,0x806030
  803c19:	a1 38 60 80 00       	mov    0x806038,%eax
  803c1e:	40                   	inc    %eax
  803c1f:	a3 38 60 80 00       	mov    %eax,0x806038
  803c24:	e9 ce 00 00 00       	jmp    803cf7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803c29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c2d:	74 65                	je     803c94 <merging+0x39b>
  803c2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c33:	75 17                	jne    803c4c <merging+0x353>
  803c35:	83 ec 04             	sub    $0x4,%esp
  803c38:	68 98 50 80 00       	push   $0x805098
  803c3d:	68 95 01 00 00       	push   $0x195
  803c42:	68 49 50 80 00       	push   $0x805049
  803c47:	e8 34 d3 ff ff       	call   800f80 <_panic>
  803c4c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c55:	89 50 04             	mov    %edx,0x4(%eax)
  803c58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c5b:	8b 40 04             	mov    0x4(%eax),%eax
  803c5e:	85 c0                	test   %eax,%eax
  803c60:	74 0c                	je     803c6e <merging+0x375>
  803c62:	a1 30 60 80 00       	mov    0x806030,%eax
  803c67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c6a:	89 10                	mov    %edx,(%eax)
  803c6c:	eb 08                	jmp    803c76 <merging+0x37d>
  803c6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c71:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c79:	a3 30 60 80 00       	mov    %eax,0x806030
  803c7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c87:	a1 38 60 80 00       	mov    0x806038,%eax
  803c8c:	40                   	inc    %eax
  803c8d:	a3 38 60 80 00       	mov    %eax,0x806038
  803c92:	eb 63                	jmp    803cf7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803c94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c98:	75 17                	jne    803cb1 <merging+0x3b8>
  803c9a:	83 ec 04             	sub    $0x4,%esp
  803c9d:	68 64 50 80 00       	push   $0x805064
  803ca2:	68 98 01 00 00       	push   $0x198
  803ca7:	68 49 50 80 00       	push   $0x805049
  803cac:	e8 cf d2 ff ff       	call   800f80 <_panic>
  803cb1:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803cb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cba:	89 10                	mov    %edx,(%eax)
  803cbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cbf:	8b 00                	mov    (%eax),%eax
  803cc1:	85 c0                	test   %eax,%eax
  803cc3:	74 0d                	je     803cd2 <merging+0x3d9>
  803cc5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ccd:	89 50 04             	mov    %edx,0x4(%eax)
  803cd0:	eb 08                	jmp    803cda <merging+0x3e1>
  803cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cd5:	a3 30 60 80 00       	mov    %eax,0x806030
  803cda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cdd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ce2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cec:	a1 38 60 80 00       	mov    0x806038,%eax
  803cf1:	40                   	inc    %eax
  803cf2:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803cf7:	83 ec 0c             	sub    $0xc,%esp
  803cfa:	ff 75 10             	pushl  0x10(%ebp)
  803cfd:	e8 d6 ed ff ff       	call   802ad8 <get_block_size>
  803d02:	83 c4 10             	add    $0x10,%esp
  803d05:	83 ec 04             	sub    $0x4,%esp
  803d08:	6a 00                	push   $0x0
  803d0a:	50                   	push   %eax
  803d0b:	ff 75 10             	pushl  0x10(%ebp)
  803d0e:	e8 16 f1 ff ff       	call   802e29 <set_block_data>
  803d13:	83 c4 10             	add    $0x10,%esp
	}
}
  803d16:	90                   	nop
  803d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803d1a:	c9                   	leave  
  803d1b:	c3                   	ret    

00803d1c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803d1c:	55                   	push   %ebp
  803d1d:	89 e5                	mov    %esp,%ebp
  803d1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803d22:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d27:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803d2a:	a1 30 60 80 00       	mov    0x806030,%eax
  803d2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d32:	73 1b                	jae    803d4f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803d34:	a1 30 60 80 00       	mov    0x806030,%eax
  803d39:	83 ec 04             	sub    $0x4,%esp
  803d3c:	ff 75 08             	pushl  0x8(%ebp)
  803d3f:	6a 00                	push   $0x0
  803d41:	50                   	push   %eax
  803d42:	e8 b2 fb ff ff       	call   8038f9 <merging>
  803d47:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d4a:	e9 8b 00 00 00       	jmp    803dda <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803d4f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d54:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d57:	76 18                	jbe    803d71 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803d59:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d5e:	83 ec 04             	sub    $0x4,%esp
  803d61:	ff 75 08             	pushl  0x8(%ebp)
  803d64:	50                   	push   %eax
  803d65:	6a 00                	push   $0x0
  803d67:	e8 8d fb ff ff       	call   8038f9 <merging>
  803d6c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d6f:	eb 69                	jmp    803dda <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803d71:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d79:	eb 39                	jmp    803db4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d81:	73 29                	jae    803dac <free_block+0x90>
  803d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d86:	8b 00                	mov    (%eax),%eax
  803d88:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d8b:	76 1f                	jbe    803dac <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803d95:	83 ec 04             	sub    $0x4,%esp
  803d98:	ff 75 08             	pushl  0x8(%ebp)
  803d9b:	ff 75 f0             	pushl  -0x10(%ebp)
  803d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  803da1:	e8 53 fb ff ff       	call   8038f9 <merging>
  803da6:	83 c4 10             	add    $0x10,%esp
			break;
  803da9:	90                   	nop
		}
	}
}
  803daa:	eb 2e                	jmp    803dda <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803dac:	a1 34 60 80 00       	mov    0x806034,%eax
  803db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db8:	74 07                	je     803dc1 <free_block+0xa5>
  803dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbd:	8b 00                	mov    (%eax),%eax
  803dbf:	eb 05                	jmp    803dc6 <free_block+0xaa>
  803dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc6:	a3 34 60 80 00       	mov    %eax,0x806034
  803dcb:	a1 34 60 80 00       	mov    0x806034,%eax
  803dd0:	85 c0                	test   %eax,%eax
  803dd2:	75 a7                	jne    803d7b <free_block+0x5f>
  803dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dd8:	75 a1                	jne    803d7b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803dda:	90                   	nop
  803ddb:	c9                   	leave  
  803ddc:	c3                   	ret    

00803ddd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803ddd:	55                   	push   %ebp
  803dde:	89 e5                	mov    %esp,%ebp
  803de0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803de3:	ff 75 08             	pushl  0x8(%ebp)
  803de6:	e8 ed ec ff ff       	call   802ad8 <get_block_size>
  803deb:	83 c4 04             	add    $0x4,%esp
  803dee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803df8:	eb 17                	jmp    803e11 <copy_data+0x34>
  803dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e00:	01 c2                	add    %eax,%edx
  803e02:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803e05:	8b 45 08             	mov    0x8(%ebp),%eax
  803e08:	01 c8                	add    %ecx,%eax
  803e0a:	8a 00                	mov    (%eax),%al
  803e0c:	88 02                	mov    %al,(%edx)
  803e0e:	ff 45 fc             	incl   -0x4(%ebp)
  803e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803e17:	72 e1                	jb     803dfa <copy_data+0x1d>
}
  803e19:	90                   	nop
  803e1a:	c9                   	leave  
  803e1b:	c3                   	ret    

00803e1c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803e1c:	55                   	push   %ebp
  803e1d:	89 e5                	mov    %esp,%ebp
  803e1f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803e22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e26:	75 23                	jne    803e4b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803e28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e2c:	74 13                	je     803e41 <realloc_block_FF+0x25>
  803e2e:	83 ec 0c             	sub    $0xc,%esp
  803e31:	ff 75 0c             	pushl  0xc(%ebp)
  803e34:	e8 1f f0 ff ff       	call   802e58 <alloc_block_FF>
  803e39:	83 c4 10             	add    $0x10,%esp
  803e3c:	e9 f4 06 00 00       	jmp    804535 <realloc_block_FF+0x719>
		return NULL;
  803e41:	b8 00 00 00 00       	mov    $0x0,%eax
  803e46:	e9 ea 06 00 00       	jmp    804535 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e4f:	75 18                	jne    803e69 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803e51:	83 ec 0c             	sub    $0xc,%esp
  803e54:	ff 75 08             	pushl  0x8(%ebp)
  803e57:	e8 c0 fe ff ff       	call   803d1c <free_block>
  803e5c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e64:	e9 cc 06 00 00       	jmp    804535 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803e69:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803e6d:	77 07                	ja     803e76 <realloc_block_FF+0x5a>
  803e6f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e79:	83 e0 01             	and    $0x1,%eax
  803e7c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e82:	83 c0 08             	add    $0x8,%eax
  803e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803e88:	83 ec 0c             	sub    $0xc,%esp
  803e8b:	ff 75 08             	pushl  0x8(%ebp)
  803e8e:	e8 45 ec ff ff       	call   802ad8 <get_block_size>
  803e93:	83 c4 10             	add    $0x10,%esp
  803e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9c:	83 e8 08             	sub    $0x8,%eax
  803e9f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea5:	83 e8 04             	sub    $0x4,%eax
  803ea8:	8b 00                	mov    (%eax),%eax
  803eaa:	83 e0 fe             	and    $0xfffffffe,%eax
  803ead:	89 c2                	mov    %eax,%edx
  803eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb2:	01 d0                	add    %edx,%eax
  803eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803eb7:	83 ec 0c             	sub    $0xc,%esp
  803eba:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ebd:	e8 16 ec ff ff       	call   802ad8 <get_block_size>
  803ec2:	83 c4 10             	add    $0x10,%esp
  803ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ecb:	83 e8 08             	sub    $0x8,%eax
  803ece:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ed4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ed7:	75 08                	jne    803ee1 <realloc_block_FF+0xc5>
	{
		 return va;
  803ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  803edc:	e9 54 06 00 00       	jmp    804535 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ee7:	0f 83 e5 03 00 00    	jae    8042d2 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef0:	2b 45 0c             	sub    0xc(%ebp),%eax
  803ef3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ef6:	83 ec 0c             	sub    $0xc,%esp
  803ef9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803efc:	e8 f0 eb ff ff       	call   802af1 <is_free_block>
  803f01:	83 c4 10             	add    $0x10,%esp
  803f04:	84 c0                	test   %al,%al
  803f06:	0f 84 3b 01 00 00    	je     804047 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803f0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f12:	01 d0                	add    %edx,%eax
  803f14:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803f17:	83 ec 04             	sub    $0x4,%esp
  803f1a:	6a 01                	push   $0x1
  803f1c:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1f:	ff 75 08             	pushl  0x8(%ebp)
  803f22:	e8 02 ef ff ff       	call   802e29 <set_block_data>
  803f27:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2d:	83 e8 04             	sub    $0x4,%eax
  803f30:	8b 00                	mov    (%eax),%eax
  803f32:	83 e0 fe             	and    $0xfffffffe,%eax
  803f35:	89 c2                	mov    %eax,%edx
  803f37:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3a:	01 d0                	add    %edx,%eax
  803f3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803f3f:	83 ec 04             	sub    $0x4,%esp
  803f42:	6a 00                	push   $0x0
  803f44:	ff 75 cc             	pushl  -0x34(%ebp)
  803f47:	ff 75 c8             	pushl  -0x38(%ebp)
  803f4a:	e8 da ee ff ff       	call   802e29 <set_block_data>
  803f4f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f56:	74 06                	je     803f5e <realloc_block_FF+0x142>
  803f58:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803f5c:	75 17                	jne    803f75 <realloc_block_FF+0x159>
  803f5e:	83 ec 04             	sub    $0x4,%esp
  803f61:	68 bc 50 80 00       	push   $0x8050bc
  803f66:	68 f6 01 00 00       	push   $0x1f6
  803f6b:	68 49 50 80 00       	push   $0x805049
  803f70:	e8 0b d0 ff ff       	call   800f80 <_panic>
  803f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f78:	8b 10                	mov    (%eax),%edx
  803f7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f7d:	89 10                	mov    %edx,(%eax)
  803f7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f82:	8b 00                	mov    (%eax),%eax
  803f84:	85 c0                	test   %eax,%eax
  803f86:	74 0b                	je     803f93 <realloc_block_FF+0x177>
  803f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8b:	8b 00                	mov    (%eax),%eax
  803f8d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f90:	89 50 04             	mov    %edx,0x4(%eax)
  803f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f96:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f99:	89 10                	mov    %edx,(%eax)
  803f9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fa1:	89 50 04             	mov    %edx,0x4(%eax)
  803fa4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fa7:	8b 00                	mov    (%eax),%eax
  803fa9:	85 c0                	test   %eax,%eax
  803fab:	75 08                	jne    803fb5 <realloc_block_FF+0x199>
  803fad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fb0:	a3 30 60 80 00       	mov    %eax,0x806030
  803fb5:	a1 38 60 80 00       	mov    0x806038,%eax
  803fba:	40                   	inc    %eax
  803fbb:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fc4:	75 17                	jne    803fdd <realloc_block_FF+0x1c1>
  803fc6:	83 ec 04             	sub    $0x4,%esp
  803fc9:	68 2b 50 80 00       	push   $0x80502b
  803fce:	68 f7 01 00 00       	push   $0x1f7
  803fd3:	68 49 50 80 00       	push   $0x805049
  803fd8:	e8 a3 cf ff ff       	call   800f80 <_panic>
  803fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe0:	8b 00                	mov    (%eax),%eax
  803fe2:	85 c0                	test   %eax,%eax
  803fe4:	74 10                	je     803ff6 <realloc_block_FF+0x1da>
  803fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe9:	8b 00                	mov    (%eax),%eax
  803feb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fee:	8b 52 04             	mov    0x4(%edx),%edx
  803ff1:	89 50 04             	mov    %edx,0x4(%eax)
  803ff4:	eb 0b                	jmp    804001 <realloc_block_FF+0x1e5>
  803ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff9:	8b 40 04             	mov    0x4(%eax),%eax
  803ffc:	a3 30 60 80 00       	mov    %eax,0x806030
  804001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804004:	8b 40 04             	mov    0x4(%eax),%eax
  804007:	85 c0                	test   %eax,%eax
  804009:	74 0f                	je     80401a <realloc_block_FF+0x1fe>
  80400b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400e:	8b 40 04             	mov    0x4(%eax),%eax
  804011:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804014:	8b 12                	mov    (%edx),%edx
  804016:	89 10                	mov    %edx,(%eax)
  804018:	eb 0a                	jmp    804024 <realloc_block_FF+0x208>
  80401a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401d:	8b 00                	mov    (%eax),%eax
  80401f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804027:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80402d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804037:	a1 38 60 80 00       	mov    0x806038,%eax
  80403c:	48                   	dec    %eax
  80403d:	a3 38 60 80 00       	mov    %eax,0x806038
  804042:	e9 83 02 00 00       	jmp    8042ca <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804047:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80404b:	0f 86 69 02 00 00    	jbe    8042ba <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804051:	83 ec 04             	sub    $0x4,%esp
  804054:	6a 01                	push   $0x1
  804056:	ff 75 f0             	pushl  -0x10(%ebp)
  804059:	ff 75 08             	pushl  0x8(%ebp)
  80405c:	e8 c8 ed ff ff       	call   802e29 <set_block_data>
  804061:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804064:	8b 45 08             	mov    0x8(%ebp),%eax
  804067:	83 e8 04             	sub    $0x4,%eax
  80406a:	8b 00                	mov    (%eax),%eax
  80406c:	83 e0 fe             	and    $0xfffffffe,%eax
  80406f:	89 c2                	mov    %eax,%edx
  804071:	8b 45 08             	mov    0x8(%ebp),%eax
  804074:	01 d0                	add    %edx,%eax
  804076:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804079:	a1 38 60 80 00       	mov    0x806038,%eax
  80407e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804081:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804085:	75 68                	jne    8040ef <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804087:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80408b:	75 17                	jne    8040a4 <realloc_block_FF+0x288>
  80408d:	83 ec 04             	sub    $0x4,%esp
  804090:	68 64 50 80 00       	push   $0x805064
  804095:	68 06 02 00 00       	push   $0x206
  80409a:	68 49 50 80 00       	push   $0x805049
  80409f:	e8 dc ce ff ff       	call   800f80 <_panic>
  8040a4:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8040aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040ad:	89 10                	mov    %edx,(%eax)
  8040af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040b2:	8b 00                	mov    (%eax),%eax
  8040b4:	85 c0                	test   %eax,%eax
  8040b6:	74 0d                	je     8040c5 <realloc_block_FF+0x2a9>
  8040b8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8040bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8040c0:	89 50 04             	mov    %edx,0x4(%eax)
  8040c3:	eb 08                	jmp    8040cd <realloc_block_FF+0x2b1>
  8040c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040c8:	a3 30 60 80 00       	mov    %eax,0x806030
  8040cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040d0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040df:	a1 38 60 80 00       	mov    0x806038,%eax
  8040e4:	40                   	inc    %eax
  8040e5:	a3 38 60 80 00       	mov    %eax,0x806038
  8040ea:	e9 b0 01 00 00       	jmp    80429f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8040ef:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8040f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8040f7:	76 68                	jbe    804161 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8040f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8040fd:	75 17                	jne    804116 <realloc_block_FF+0x2fa>
  8040ff:	83 ec 04             	sub    $0x4,%esp
  804102:	68 64 50 80 00       	push   $0x805064
  804107:	68 0b 02 00 00       	push   $0x20b
  80410c:	68 49 50 80 00       	push   $0x805049
  804111:	e8 6a ce ff ff       	call   800f80 <_panic>
  804116:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80411c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80411f:	89 10                	mov    %edx,(%eax)
  804121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804124:	8b 00                	mov    (%eax),%eax
  804126:	85 c0                	test   %eax,%eax
  804128:	74 0d                	je     804137 <realloc_block_FF+0x31b>
  80412a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80412f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804132:	89 50 04             	mov    %edx,0x4(%eax)
  804135:	eb 08                	jmp    80413f <realloc_block_FF+0x323>
  804137:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80413a:	a3 30 60 80 00       	mov    %eax,0x806030
  80413f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804142:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804147:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80414a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804151:	a1 38 60 80 00       	mov    0x806038,%eax
  804156:	40                   	inc    %eax
  804157:	a3 38 60 80 00       	mov    %eax,0x806038
  80415c:	e9 3e 01 00 00       	jmp    80429f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804161:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804166:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804169:	73 68                	jae    8041d3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80416b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80416f:	75 17                	jne    804188 <realloc_block_FF+0x36c>
  804171:	83 ec 04             	sub    $0x4,%esp
  804174:	68 98 50 80 00       	push   $0x805098
  804179:	68 10 02 00 00       	push   $0x210
  80417e:	68 49 50 80 00       	push   $0x805049
  804183:	e8 f8 cd ff ff       	call   800f80 <_panic>
  804188:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80418e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804191:	89 50 04             	mov    %edx,0x4(%eax)
  804194:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804197:	8b 40 04             	mov    0x4(%eax),%eax
  80419a:	85 c0                	test   %eax,%eax
  80419c:	74 0c                	je     8041aa <realloc_block_FF+0x38e>
  80419e:	a1 30 60 80 00       	mov    0x806030,%eax
  8041a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041a6:	89 10                	mov    %edx,(%eax)
  8041a8:	eb 08                	jmp    8041b2 <realloc_block_FF+0x396>
  8041aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041ad:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041b5:	a3 30 60 80 00       	mov    %eax,0x806030
  8041ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041c3:	a1 38 60 80 00       	mov    0x806038,%eax
  8041c8:	40                   	inc    %eax
  8041c9:	a3 38 60 80 00       	mov    %eax,0x806038
  8041ce:	e9 cc 00 00 00       	jmp    80429f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8041d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8041da:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8041df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041e2:	e9 8a 00 00 00       	jmp    804271 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041ed:	73 7a                	jae    804269 <realloc_block_FF+0x44d>
  8041ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f2:	8b 00                	mov    (%eax),%eax
  8041f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041f7:	73 70                	jae    804269 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8041f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041fd:	74 06                	je     804205 <realloc_block_FF+0x3e9>
  8041ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804203:	75 17                	jne    80421c <realloc_block_FF+0x400>
  804205:	83 ec 04             	sub    $0x4,%esp
  804208:	68 bc 50 80 00       	push   $0x8050bc
  80420d:	68 1a 02 00 00       	push   $0x21a
  804212:	68 49 50 80 00       	push   $0x805049
  804217:	e8 64 cd ff ff       	call   800f80 <_panic>
  80421c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421f:	8b 10                	mov    (%eax),%edx
  804221:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804224:	89 10                	mov    %edx,(%eax)
  804226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804229:	8b 00                	mov    (%eax),%eax
  80422b:	85 c0                	test   %eax,%eax
  80422d:	74 0b                	je     80423a <realloc_block_FF+0x41e>
  80422f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804232:	8b 00                	mov    (%eax),%eax
  804234:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804237:	89 50 04             	mov    %edx,0x4(%eax)
  80423a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80423d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804240:	89 10                	mov    %edx,(%eax)
  804242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804248:	89 50 04             	mov    %edx,0x4(%eax)
  80424b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80424e:	8b 00                	mov    (%eax),%eax
  804250:	85 c0                	test   %eax,%eax
  804252:	75 08                	jne    80425c <realloc_block_FF+0x440>
  804254:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804257:	a3 30 60 80 00       	mov    %eax,0x806030
  80425c:	a1 38 60 80 00       	mov    0x806038,%eax
  804261:	40                   	inc    %eax
  804262:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  804267:	eb 36                	jmp    80429f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804269:	a1 34 60 80 00       	mov    0x806034,%eax
  80426e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804275:	74 07                	je     80427e <realloc_block_FF+0x462>
  804277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80427a:	8b 00                	mov    (%eax),%eax
  80427c:	eb 05                	jmp    804283 <realloc_block_FF+0x467>
  80427e:	b8 00 00 00 00       	mov    $0x0,%eax
  804283:	a3 34 60 80 00       	mov    %eax,0x806034
  804288:	a1 34 60 80 00       	mov    0x806034,%eax
  80428d:	85 c0                	test   %eax,%eax
  80428f:	0f 85 52 ff ff ff    	jne    8041e7 <realloc_block_FF+0x3cb>
  804295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804299:	0f 85 48 ff ff ff    	jne    8041e7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80429f:	83 ec 04             	sub    $0x4,%esp
  8042a2:	6a 00                	push   $0x0
  8042a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8042a7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8042aa:	e8 7a eb ff ff       	call   802e29 <set_block_data>
  8042af:	83 c4 10             	add    $0x10,%esp
				return va;
  8042b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b5:	e9 7b 02 00 00       	jmp    804535 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8042ba:	83 ec 0c             	sub    $0xc,%esp
  8042bd:	68 39 51 80 00       	push   $0x805139
  8042c2:	e8 76 cf ff ff       	call   80123d <cprintf>
  8042c7:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8042ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8042cd:	e9 63 02 00 00       	jmp    804535 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8042d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8042d8:	0f 86 4d 02 00 00    	jbe    80452b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8042de:	83 ec 0c             	sub    $0xc,%esp
  8042e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8042e4:	e8 08 e8 ff ff       	call   802af1 <is_free_block>
  8042e9:	83 c4 10             	add    $0x10,%esp
  8042ec:	84 c0                	test   %al,%al
  8042ee:	0f 84 37 02 00 00    	je     80452b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8042f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8042fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8042fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804300:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804303:	76 38                	jbe    80433d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804305:	83 ec 0c             	sub    $0xc,%esp
  804308:	ff 75 08             	pushl  0x8(%ebp)
  80430b:	e8 0c fa ff ff       	call   803d1c <free_block>
  804310:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804313:	83 ec 0c             	sub    $0xc,%esp
  804316:	ff 75 0c             	pushl  0xc(%ebp)
  804319:	e8 3a eb ff ff       	call   802e58 <alloc_block_FF>
  80431e:	83 c4 10             	add    $0x10,%esp
  804321:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804324:	83 ec 08             	sub    $0x8,%esp
  804327:	ff 75 c0             	pushl  -0x40(%ebp)
  80432a:	ff 75 08             	pushl  0x8(%ebp)
  80432d:	e8 ab fa ff ff       	call   803ddd <copy_data>
  804332:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804335:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804338:	e9 f8 01 00 00       	jmp    804535 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80433d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804340:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804343:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804346:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80434a:	0f 87 a0 00 00 00    	ja     8043f0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804350:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804354:	75 17                	jne    80436d <realloc_block_FF+0x551>
  804356:	83 ec 04             	sub    $0x4,%esp
  804359:	68 2b 50 80 00       	push   $0x80502b
  80435e:	68 38 02 00 00       	push   $0x238
  804363:	68 49 50 80 00       	push   $0x805049
  804368:	e8 13 cc ff ff       	call   800f80 <_panic>
  80436d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804370:	8b 00                	mov    (%eax),%eax
  804372:	85 c0                	test   %eax,%eax
  804374:	74 10                	je     804386 <realloc_block_FF+0x56a>
  804376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804379:	8b 00                	mov    (%eax),%eax
  80437b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80437e:	8b 52 04             	mov    0x4(%edx),%edx
  804381:	89 50 04             	mov    %edx,0x4(%eax)
  804384:	eb 0b                	jmp    804391 <realloc_block_FF+0x575>
  804386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804389:	8b 40 04             	mov    0x4(%eax),%eax
  80438c:	a3 30 60 80 00       	mov    %eax,0x806030
  804391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804394:	8b 40 04             	mov    0x4(%eax),%eax
  804397:	85 c0                	test   %eax,%eax
  804399:	74 0f                	je     8043aa <realloc_block_FF+0x58e>
  80439b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80439e:	8b 40 04             	mov    0x4(%eax),%eax
  8043a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043a4:	8b 12                	mov    (%edx),%edx
  8043a6:	89 10                	mov    %edx,(%eax)
  8043a8:	eb 0a                	jmp    8043b4 <realloc_block_FF+0x598>
  8043aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ad:	8b 00                	mov    (%eax),%eax
  8043af:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043c7:	a1 38 60 80 00       	mov    0x806038,%eax
  8043cc:	48                   	dec    %eax
  8043cd:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8043d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043d8:	01 d0                	add    %edx,%eax
  8043da:	83 ec 04             	sub    $0x4,%esp
  8043dd:	6a 01                	push   $0x1
  8043df:	50                   	push   %eax
  8043e0:	ff 75 08             	pushl  0x8(%ebp)
  8043e3:	e8 41 ea ff ff       	call   802e29 <set_block_data>
  8043e8:	83 c4 10             	add    $0x10,%esp
  8043eb:	e9 36 01 00 00       	jmp    804526 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8043f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8043f6:	01 d0                	add    %edx,%eax
  8043f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8043fb:	83 ec 04             	sub    $0x4,%esp
  8043fe:	6a 01                	push   $0x1
  804400:	ff 75 f0             	pushl  -0x10(%ebp)
  804403:	ff 75 08             	pushl  0x8(%ebp)
  804406:	e8 1e ea ff ff       	call   802e29 <set_block_data>
  80440b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80440e:	8b 45 08             	mov    0x8(%ebp),%eax
  804411:	83 e8 04             	sub    $0x4,%eax
  804414:	8b 00                	mov    (%eax),%eax
  804416:	83 e0 fe             	and    $0xfffffffe,%eax
  804419:	89 c2                	mov    %eax,%edx
  80441b:	8b 45 08             	mov    0x8(%ebp),%eax
  80441e:	01 d0                	add    %edx,%eax
  804420:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804423:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804427:	74 06                	je     80442f <realloc_block_FF+0x613>
  804429:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80442d:	75 17                	jne    804446 <realloc_block_FF+0x62a>
  80442f:	83 ec 04             	sub    $0x4,%esp
  804432:	68 bc 50 80 00       	push   $0x8050bc
  804437:	68 44 02 00 00       	push   $0x244
  80443c:	68 49 50 80 00       	push   $0x805049
  804441:	e8 3a cb ff ff       	call   800f80 <_panic>
  804446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804449:	8b 10                	mov    (%eax),%edx
  80444b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80444e:	89 10                	mov    %edx,(%eax)
  804450:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804453:	8b 00                	mov    (%eax),%eax
  804455:	85 c0                	test   %eax,%eax
  804457:	74 0b                	je     804464 <realloc_block_FF+0x648>
  804459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80445c:	8b 00                	mov    (%eax),%eax
  80445e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804461:	89 50 04             	mov    %edx,0x4(%eax)
  804464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804467:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80446a:	89 10                	mov    %edx,(%eax)
  80446c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80446f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804472:	89 50 04             	mov    %edx,0x4(%eax)
  804475:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804478:	8b 00                	mov    (%eax),%eax
  80447a:	85 c0                	test   %eax,%eax
  80447c:	75 08                	jne    804486 <realloc_block_FF+0x66a>
  80447e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804481:	a3 30 60 80 00       	mov    %eax,0x806030
  804486:	a1 38 60 80 00       	mov    0x806038,%eax
  80448b:	40                   	inc    %eax
  80448c:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804491:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804495:	75 17                	jne    8044ae <realloc_block_FF+0x692>
  804497:	83 ec 04             	sub    $0x4,%esp
  80449a:	68 2b 50 80 00       	push   $0x80502b
  80449f:	68 45 02 00 00       	push   $0x245
  8044a4:	68 49 50 80 00       	push   $0x805049
  8044a9:	e8 d2 ca ff ff       	call   800f80 <_panic>
  8044ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b1:	8b 00                	mov    (%eax),%eax
  8044b3:	85 c0                	test   %eax,%eax
  8044b5:	74 10                	je     8044c7 <realloc_block_FF+0x6ab>
  8044b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ba:	8b 00                	mov    (%eax),%eax
  8044bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044bf:	8b 52 04             	mov    0x4(%edx),%edx
  8044c2:	89 50 04             	mov    %edx,0x4(%eax)
  8044c5:	eb 0b                	jmp    8044d2 <realloc_block_FF+0x6b6>
  8044c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ca:	8b 40 04             	mov    0x4(%eax),%eax
  8044cd:	a3 30 60 80 00       	mov    %eax,0x806030
  8044d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d5:	8b 40 04             	mov    0x4(%eax),%eax
  8044d8:	85 c0                	test   %eax,%eax
  8044da:	74 0f                	je     8044eb <realloc_block_FF+0x6cf>
  8044dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044df:	8b 40 04             	mov    0x4(%eax),%eax
  8044e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044e5:	8b 12                	mov    (%edx),%edx
  8044e7:	89 10                	mov    %edx,(%eax)
  8044e9:	eb 0a                	jmp    8044f5 <realloc_block_FF+0x6d9>
  8044eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ee:	8b 00                	mov    (%eax),%eax
  8044f0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8044f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804501:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804508:	a1 38 60 80 00       	mov    0x806038,%eax
  80450d:	48                   	dec    %eax
  80450e:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804513:	83 ec 04             	sub    $0x4,%esp
  804516:	6a 00                	push   $0x0
  804518:	ff 75 bc             	pushl  -0x44(%ebp)
  80451b:	ff 75 b8             	pushl  -0x48(%ebp)
  80451e:	e8 06 e9 ff ff       	call   802e29 <set_block_data>
  804523:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804526:	8b 45 08             	mov    0x8(%ebp),%eax
  804529:	eb 0a                	jmp    804535 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80452b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804532:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804535:	c9                   	leave  
  804536:	c3                   	ret    

00804537 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804537:	55                   	push   %ebp
  804538:	89 e5                	mov    %esp,%ebp
  80453a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80453d:	83 ec 04             	sub    $0x4,%esp
  804540:	68 40 51 80 00       	push   $0x805140
  804545:	68 58 02 00 00       	push   $0x258
  80454a:	68 49 50 80 00       	push   $0x805049
  80454f:	e8 2c ca ff ff       	call   800f80 <_panic>

00804554 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804554:	55                   	push   %ebp
  804555:	89 e5                	mov    %esp,%ebp
  804557:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80455a:	83 ec 04             	sub    $0x4,%esp
  80455d:	68 68 51 80 00       	push   $0x805168
  804562:	68 61 02 00 00       	push   $0x261
  804567:	68 49 50 80 00       	push   $0x805049
  80456c:	e8 0f ca ff ff       	call   800f80 <_panic>
  804571:	66 90                	xchg   %ax,%ax
  804573:	90                   	nop

00804574 <__udivdi3>:
  804574:	55                   	push   %ebp
  804575:	57                   	push   %edi
  804576:	56                   	push   %esi
  804577:	53                   	push   %ebx
  804578:	83 ec 1c             	sub    $0x1c,%esp
  80457b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80457f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804587:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80458b:	89 ca                	mov    %ecx,%edx
  80458d:	89 f8                	mov    %edi,%eax
  80458f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804593:	85 f6                	test   %esi,%esi
  804595:	75 2d                	jne    8045c4 <__udivdi3+0x50>
  804597:	39 cf                	cmp    %ecx,%edi
  804599:	77 65                	ja     804600 <__udivdi3+0x8c>
  80459b:	89 fd                	mov    %edi,%ebp
  80459d:	85 ff                	test   %edi,%edi
  80459f:	75 0b                	jne    8045ac <__udivdi3+0x38>
  8045a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8045a6:	31 d2                	xor    %edx,%edx
  8045a8:	f7 f7                	div    %edi
  8045aa:	89 c5                	mov    %eax,%ebp
  8045ac:	31 d2                	xor    %edx,%edx
  8045ae:	89 c8                	mov    %ecx,%eax
  8045b0:	f7 f5                	div    %ebp
  8045b2:	89 c1                	mov    %eax,%ecx
  8045b4:	89 d8                	mov    %ebx,%eax
  8045b6:	f7 f5                	div    %ebp
  8045b8:	89 cf                	mov    %ecx,%edi
  8045ba:	89 fa                	mov    %edi,%edx
  8045bc:	83 c4 1c             	add    $0x1c,%esp
  8045bf:	5b                   	pop    %ebx
  8045c0:	5e                   	pop    %esi
  8045c1:	5f                   	pop    %edi
  8045c2:	5d                   	pop    %ebp
  8045c3:	c3                   	ret    
  8045c4:	39 ce                	cmp    %ecx,%esi
  8045c6:	77 28                	ja     8045f0 <__udivdi3+0x7c>
  8045c8:	0f bd fe             	bsr    %esi,%edi
  8045cb:	83 f7 1f             	xor    $0x1f,%edi
  8045ce:	75 40                	jne    804610 <__udivdi3+0x9c>
  8045d0:	39 ce                	cmp    %ecx,%esi
  8045d2:	72 0a                	jb     8045de <__udivdi3+0x6a>
  8045d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045d8:	0f 87 9e 00 00 00    	ja     80467c <__udivdi3+0x108>
  8045de:	b8 01 00 00 00       	mov    $0x1,%eax
  8045e3:	89 fa                	mov    %edi,%edx
  8045e5:	83 c4 1c             	add    $0x1c,%esp
  8045e8:	5b                   	pop    %ebx
  8045e9:	5e                   	pop    %esi
  8045ea:	5f                   	pop    %edi
  8045eb:	5d                   	pop    %ebp
  8045ec:	c3                   	ret    
  8045ed:	8d 76 00             	lea    0x0(%esi),%esi
  8045f0:	31 ff                	xor    %edi,%edi
  8045f2:	31 c0                	xor    %eax,%eax
  8045f4:	89 fa                	mov    %edi,%edx
  8045f6:	83 c4 1c             	add    $0x1c,%esp
  8045f9:	5b                   	pop    %ebx
  8045fa:	5e                   	pop    %esi
  8045fb:	5f                   	pop    %edi
  8045fc:	5d                   	pop    %ebp
  8045fd:	c3                   	ret    
  8045fe:	66 90                	xchg   %ax,%ax
  804600:	89 d8                	mov    %ebx,%eax
  804602:	f7 f7                	div    %edi
  804604:	31 ff                	xor    %edi,%edi
  804606:	89 fa                	mov    %edi,%edx
  804608:	83 c4 1c             	add    $0x1c,%esp
  80460b:	5b                   	pop    %ebx
  80460c:	5e                   	pop    %esi
  80460d:	5f                   	pop    %edi
  80460e:	5d                   	pop    %ebp
  80460f:	c3                   	ret    
  804610:	bd 20 00 00 00       	mov    $0x20,%ebp
  804615:	89 eb                	mov    %ebp,%ebx
  804617:	29 fb                	sub    %edi,%ebx
  804619:	89 f9                	mov    %edi,%ecx
  80461b:	d3 e6                	shl    %cl,%esi
  80461d:	89 c5                	mov    %eax,%ebp
  80461f:	88 d9                	mov    %bl,%cl
  804621:	d3 ed                	shr    %cl,%ebp
  804623:	89 e9                	mov    %ebp,%ecx
  804625:	09 f1                	or     %esi,%ecx
  804627:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80462b:	89 f9                	mov    %edi,%ecx
  80462d:	d3 e0                	shl    %cl,%eax
  80462f:	89 c5                	mov    %eax,%ebp
  804631:	89 d6                	mov    %edx,%esi
  804633:	88 d9                	mov    %bl,%cl
  804635:	d3 ee                	shr    %cl,%esi
  804637:	89 f9                	mov    %edi,%ecx
  804639:	d3 e2                	shl    %cl,%edx
  80463b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80463f:	88 d9                	mov    %bl,%cl
  804641:	d3 e8                	shr    %cl,%eax
  804643:	09 c2                	or     %eax,%edx
  804645:	89 d0                	mov    %edx,%eax
  804647:	89 f2                	mov    %esi,%edx
  804649:	f7 74 24 0c          	divl   0xc(%esp)
  80464d:	89 d6                	mov    %edx,%esi
  80464f:	89 c3                	mov    %eax,%ebx
  804651:	f7 e5                	mul    %ebp
  804653:	39 d6                	cmp    %edx,%esi
  804655:	72 19                	jb     804670 <__udivdi3+0xfc>
  804657:	74 0b                	je     804664 <__udivdi3+0xf0>
  804659:	89 d8                	mov    %ebx,%eax
  80465b:	31 ff                	xor    %edi,%edi
  80465d:	e9 58 ff ff ff       	jmp    8045ba <__udivdi3+0x46>
  804662:	66 90                	xchg   %ax,%ax
  804664:	8b 54 24 08          	mov    0x8(%esp),%edx
  804668:	89 f9                	mov    %edi,%ecx
  80466a:	d3 e2                	shl    %cl,%edx
  80466c:	39 c2                	cmp    %eax,%edx
  80466e:	73 e9                	jae    804659 <__udivdi3+0xe5>
  804670:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804673:	31 ff                	xor    %edi,%edi
  804675:	e9 40 ff ff ff       	jmp    8045ba <__udivdi3+0x46>
  80467a:	66 90                	xchg   %ax,%ax
  80467c:	31 c0                	xor    %eax,%eax
  80467e:	e9 37 ff ff ff       	jmp    8045ba <__udivdi3+0x46>
  804683:	90                   	nop

00804684 <__umoddi3>:
  804684:	55                   	push   %ebp
  804685:	57                   	push   %edi
  804686:	56                   	push   %esi
  804687:	53                   	push   %ebx
  804688:	83 ec 1c             	sub    $0x1c,%esp
  80468b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80468f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804697:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80469b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80469f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8046a3:	89 f3                	mov    %esi,%ebx
  8046a5:	89 fa                	mov    %edi,%edx
  8046a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046ab:	89 34 24             	mov    %esi,(%esp)
  8046ae:	85 c0                	test   %eax,%eax
  8046b0:	75 1a                	jne    8046cc <__umoddi3+0x48>
  8046b2:	39 f7                	cmp    %esi,%edi
  8046b4:	0f 86 a2 00 00 00    	jbe    80475c <__umoddi3+0xd8>
  8046ba:	89 c8                	mov    %ecx,%eax
  8046bc:	89 f2                	mov    %esi,%edx
  8046be:	f7 f7                	div    %edi
  8046c0:	89 d0                	mov    %edx,%eax
  8046c2:	31 d2                	xor    %edx,%edx
  8046c4:	83 c4 1c             	add    $0x1c,%esp
  8046c7:	5b                   	pop    %ebx
  8046c8:	5e                   	pop    %esi
  8046c9:	5f                   	pop    %edi
  8046ca:	5d                   	pop    %ebp
  8046cb:	c3                   	ret    
  8046cc:	39 f0                	cmp    %esi,%eax
  8046ce:	0f 87 ac 00 00 00    	ja     804780 <__umoddi3+0xfc>
  8046d4:	0f bd e8             	bsr    %eax,%ebp
  8046d7:	83 f5 1f             	xor    $0x1f,%ebp
  8046da:	0f 84 ac 00 00 00    	je     80478c <__umoddi3+0x108>
  8046e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8046e5:	29 ef                	sub    %ebp,%edi
  8046e7:	89 fe                	mov    %edi,%esi
  8046e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8046ed:	89 e9                	mov    %ebp,%ecx
  8046ef:	d3 e0                	shl    %cl,%eax
  8046f1:	89 d7                	mov    %edx,%edi
  8046f3:	89 f1                	mov    %esi,%ecx
  8046f5:	d3 ef                	shr    %cl,%edi
  8046f7:	09 c7                	or     %eax,%edi
  8046f9:	89 e9                	mov    %ebp,%ecx
  8046fb:	d3 e2                	shl    %cl,%edx
  8046fd:	89 14 24             	mov    %edx,(%esp)
  804700:	89 d8                	mov    %ebx,%eax
  804702:	d3 e0                	shl    %cl,%eax
  804704:	89 c2                	mov    %eax,%edx
  804706:	8b 44 24 08          	mov    0x8(%esp),%eax
  80470a:	d3 e0                	shl    %cl,%eax
  80470c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804710:	8b 44 24 08          	mov    0x8(%esp),%eax
  804714:	89 f1                	mov    %esi,%ecx
  804716:	d3 e8                	shr    %cl,%eax
  804718:	09 d0                	or     %edx,%eax
  80471a:	d3 eb                	shr    %cl,%ebx
  80471c:	89 da                	mov    %ebx,%edx
  80471e:	f7 f7                	div    %edi
  804720:	89 d3                	mov    %edx,%ebx
  804722:	f7 24 24             	mull   (%esp)
  804725:	89 c6                	mov    %eax,%esi
  804727:	89 d1                	mov    %edx,%ecx
  804729:	39 d3                	cmp    %edx,%ebx
  80472b:	0f 82 87 00 00 00    	jb     8047b8 <__umoddi3+0x134>
  804731:	0f 84 91 00 00 00    	je     8047c8 <__umoddi3+0x144>
  804737:	8b 54 24 04          	mov    0x4(%esp),%edx
  80473b:	29 f2                	sub    %esi,%edx
  80473d:	19 cb                	sbb    %ecx,%ebx
  80473f:	89 d8                	mov    %ebx,%eax
  804741:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804745:	d3 e0                	shl    %cl,%eax
  804747:	89 e9                	mov    %ebp,%ecx
  804749:	d3 ea                	shr    %cl,%edx
  80474b:	09 d0                	or     %edx,%eax
  80474d:	89 e9                	mov    %ebp,%ecx
  80474f:	d3 eb                	shr    %cl,%ebx
  804751:	89 da                	mov    %ebx,%edx
  804753:	83 c4 1c             	add    $0x1c,%esp
  804756:	5b                   	pop    %ebx
  804757:	5e                   	pop    %esi
  804758:	5f                   	pop    %edi
  804759:	5d                   	pop    %ebp
  80475a:	c3                   	ret    
  80475b:	90                   	nop
  80475c:	89 fd                	mov    %edi,%ebp
  80475e:	85 ff                	test   %edi,%edi
  804760:	75 0b                	jne    80476d <__umoddi3+0xe9>
  804762:	b8 01 00 00 00       	mov    $0x1,%eax
  804767:	31 d2                	xor    %edx,%edx
  804769:	f7 f7                	div    %edi
  80476b:	89 c5                	mov    %eax,%ebp
  80476d:	89 f0                	mov    %esi,%eax
  80476f:	31 d2                	xor    %edx,%edx
  804771:	f7 f5                	div    %ebp
  804773:	89 c8                	mov    %ecx,%eax
  804775:	f7 f5                	div    %ebp
  804777:	89 d0                	mov    %edx,%eax
  804779:	e9 44 ff ff ff       	jmp    8046c2 <__umoddi3+0x3e>
  80477e:	66 90                	xchg   %ax,%ax
  804780:	89 c8                	mov    %ecx,%eax
  804782:	89 f2                	mov    %esi,%edx
  804784:	83 c4 1c             	add    $0x1c,%esp
  804787:	5b                   	pop    %ebx
  804788:	5e                   	pop    %esi
  804789:	5f                   	pop    %edi
  80478a:	5d                   	pop    %ebp
  80478b:	c3                   	ret    
  80478c:	3b 04 24             	cmp    (%esp),%eax
  80478f:	72 06                	jb     804797 <__umoddi3+0x113>
  804791:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804795:	77 0f                	ja     8047a6 <__umoddi3+0x122>
  804797:	89 f2                	mov    %esi,%edx
  804799:	29 f9                	sub    %edi,%ecx
  80479b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80479f:	89 14 24             	mov    %edx,(%esp)
  8047a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8047aa:	8b 14 24             	mov    (%esp),%edx
  8047ad:	83 c4 1c             	add    $0x1c,%esp
  8047b0:	5b                   	pop    %ebx
  8047b1:	5e                   	pop    %esi
  8047b2:	5f                   	pop    %edi
  8047b3:	5d                   	pop    %ebp
  8047b4:	c3                   	ret    
  8047b5:	8d 76 00             	lea    0x0(%esi),%esi
  8047b8:	2b 04 24             	sub    (%esp),%eax
  8047bb:	19 fa                	sbb    %edi,%edx
  8047bd:	89 d1                	mov    %edx,%ecx
  8047bf:	89 c6                	mov    %eax,%esi
  8047c1:	e9 71 ff ff ff       	jmp    804737 <__umoddi3+0xb3>
  8047c6:	66 90                	xchg   %ax,%ax
  8047c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047cc:	72 ea                	jb     8047b8 <__umoddi3+0x134>
  8047ce:	89 d9                	mov    %ebx,%ecx
  8047d0:	e9 62 ff ff ff       	jmp    804737 <__umoddi3+0xb3>
