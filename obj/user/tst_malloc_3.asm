
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
  800094:	68 80 47 80 00       	push   $0x804780
  800099:	6a 1a                	push   $0x1a
  80009b:	68 9c 47 80 00       	push   $0x80479c
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
  8000e2:	e8 80 24 00 00       	call   802567 <sys_calculate_free_frames>
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
  8000fe:	e8 af 24 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 b0 47 80 00       	push   $0x8047b0
  80013f:	6a 39                	push   $0x39
  800141:	68 9c 47 80 00       	push   $0x80479c
  800146:	e8 35 0e 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 62 24 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 18 48 80 00       	push   $0x804818
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 9c 47 80 00       	push   $0x80479c
  800164:	e8 17 0e 00 00       	call   800f80 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 f9 23 00 00       	call   802567 <sys_calculate_free_frames>
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
  80019e:	e8 c4 23 00 00       	call   802567 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 48 48 80 00       	push   $0x804848
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 9c 47 80 00       	push   $0x80479c
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
  800274:	68 8c 48 80 00       	push   $0x80488c
  800279:	6a 4b                	push   $0x4b
  80027b:	68 9c 47 80 00       	push   $0x80479c
  800280:	e8 fb 0c 00 00       	call   800f80 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 28 23 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  8002d6:	68 b0 47 80 00       	push   $0x8047b0
  8002db:	6a 50                	push   $0x50
  8002dd:	68 9c 47 80 00       	push   $0x80479c
  8002e2:	e8 99 0c 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 c6 22 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 18 48 80 00       	push   $0x804818
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 9c 47 80 00       	push   $0x80479c
  800300:	e8 7b 0c 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 5d 22 00 00       	call   802567 <sys_calculate_free_frames>
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
  800343:	e8 1f 22 00 00       	call   802567 <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 48 48 80 00       	push   $0x804848
  800359:	6a 58                	push   $0x58
  80035b:	68 9c 47 80 00       	push   $0x80479c
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
  80041d:	68 8c 48 80 00       	push   $0x80488c
  800422:	6a 61                	push   $0x61
  800424:	68 9c 47 80 00       	push   $0x80479c
  800429:	e8 52 0b 00 00       	call   800f80 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 7f 21 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  800482:	68 b0 47 80 00       	push   $0x8047b0
  800487:	6a 66                	push   $0x66
  800489:	68 9c 47 80 00       	push   $0x80479c
  80048e:	e8 ed 0a 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 1a 21 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 18 48 80 00       	push   $0x804818
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 9c 47 80 00       	push   $0x80479c
  8004ac:	e8 cf 0a 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 b1 20 00 00       	call   802567 <sys_calculate_free_frames>
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
  8004ed:	e8 75 20 00 00       	call   802567 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 48 48 80 00       	push   $0x804848
  800503:	6a 6e                	push   $0x6e
  800505:	68 9c 47 80 00       	push   $0x80479c
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
  8005d0:	68 8c 48 80 00       	push   $0x80488c
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 9c 47 80 00       	push   $0x80479c
  8005dc:	e8 9f 09 00 00       	call   800f80 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 81 1f 00 00       	call   802567 <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 c4 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  800651:	68 b0 47 80 00       	push   $0x8047b0
  800656:	6a 7d                	push   $0x7d
  800658:	68 9c 47 80 00       	push   $0x80479c
  80065d:	e8 1e 09 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 4b 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 18 48 80 00       	push   $0x804818
  800674:	6a 7e                	push   $0x7e
  800676:	68 9c 47 80 00       	push   $0x80479c
  80067b:	e8 00 09 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 2d 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  8006ec:	68 b0 47 80 00       	push   $0x8047b0
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 9c 47 80 00       	push   $0x80479c
  8006fb:	e8 80 08 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 ad 1e 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 18 48 80 00       	push   $0x804818
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 9c 47 80 00       	push   $0x80479c
  80071c:	e8 5f 08 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 41 1e 00 00       	call   802567 <sys_calculate_free_frames>
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
  8007c5:	e8 9d 1d 00 00       	call   802567 <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 48 48 80 00       	push   $0x804848
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 9c 47 80 00       	push   $0x80479c
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
  8008c6:	68 8c 48 80 00       	push   $0x80488c
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 9c 47 80 00       	push   $0x80479c
  8008d5:	e8 a6 06 00 00       	call   800f80 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 88 1c 00 00       	call   802567 <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 cb 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  80094d:	68 b0 47 80 00       	push   $0x8047b0
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 9c 47 80 00       	push   $0x80479c
  80095c:	e8 1f 06 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 4c 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 18 48 80 00       	push   $0x804818
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 9c 47 80 00       	push   $0x80479c
  80097d:	e8 fe 05 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 2b 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 b0 47 80 00       	push   $0x8047b0
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 9c 47 80 00       	push   $0x80479c
  800a0c:	e8 6f 05 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 9c 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 18 48 80 00       	push   $0x804818
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 9c 47 80 00       	push   $0x80479c
  800a2d:	e8 4e 05 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 30 1b 00 00       	call   802567 <sys_calculate_free_frames>
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
  800aa3:	e8 bf 1a 00 00       	call   802567 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 48 48 80 00       	push   $0x804848
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 9c 47 80 00       	push   $0x80479c
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
  800bfc:	68 8c 48 80 00       	push   $0x80488c
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 9c 47 80 00       	push   $0x80479c
  800c0b:	e8 70 03 00 00       	call   800f80 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 9d 19 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
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
  800c8e:	68 b0 47 80 00       	push   $0x8047b0
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 9c 47 80 00       	push   $0x80479c
  800c9d:	e8 de 02 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 0b 19 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 18 48 80 00       	push   $0x804818
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 9c 47 80 00       	push   $0x80479c
  800cbe:	e8 bd 02 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 9f 18 00 00       	call   802567 <sys_calculate_free_frames>
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
  800d17:	e8 4b 18 00 00       	call   802567 <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 48 48 80 00       	push   $0x804848
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 9c 47 80 00       	push   $0x80479c
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
  800e15:	68 8c 48 80 00       	push   $0x80488c
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 9c 47 80 00       	push   $0x80479c
  800e24:	e8 57 01 00 00       	call   800f80 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 ac 48 80 00       	push   $0x8048ac
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
  800e47:	e8 e4 18 00 00       	call   802730 <sys_getenvindex>
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
  800eb5:	e8 fa 15 00 00       	call   8024b4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	68 00 49 80 00       	push   $0x804900
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
  800ee5:	68 28 49 80 00       	push   $0x804928
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
  800f16:	68 50 49 80 00       	push   $0x804950
  800f1b:	e8 1d 03 00 00       	call   80123d <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f23:	a1 20 60 80 00       	mov    0x806020,%eax
  800f28:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	50                   	push   %eax
  800f32:	68 a8 49 80 00       	push   $0x8049a8
  800f37:	e8 01 03 00 00       	call   80123d <cprintf>
  800f3c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	68 00 49 80 00       	push   $0x804900
  800f47:	e8 f1 02 00 00       	call   80123d <cprintf>
  800f4c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f4f:	e8 7a 15 00 00       	call   8024ce <sys_unlock_cons>
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
  800f67:	e8 90 17 00 00       	call   8026fc <sys_destroy_env>
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
  800f78:	e8 e5 17 00 00       	call   802762 <sys_exit_env>
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
  800fa1:	68 bc 49 80 00       	push   $0x8049bc
  800fa6:	e8 92 02 00 00       	call   80123d <cprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fae:	a1 00 60 80 00       	mov    0x806000,%eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	68 c1 49 80 00       	push   $0x8049c1
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
  800fde:	68 dd 49 80 00       	push   $0x8049dd
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
  80100d:	68 e0 49 80 00       	push   $0x8049e0
  801012:	6a 26                	push   $0x26
  801014:	68 2c 4a 80 00       	push   $0x804a2c
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
  8010e2:	68 38 4a 80 00       	push   $0x804a38
  8010e7:	6a 3a                	push   $0x3a
  8010e9:	68 2c 4a 80 00       	push   $0x804a2c
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
  801155:	68 8c 4a 80 00       	push   $0x804a8c
  80115a:	6a 44                	push   $0x44
  80115c:	68 2c 4a 80 00       	push   $0x804a2c
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
  8011af:	e8 be 12 00 00       	call   802472 <sys_cputs>
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
  801226:	e8 47 12 00 00       	call   802472 <sys_cputs>
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
  801270:	e8 3f 12 00 00       	call   8024b4 <sys_lock_cons>
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
  801290:	e8 39 12 00 00       	call   8024ce <sys_unlock_cons>
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
  8012da:	e8 2d 32 00 00       	call   80450c <__udivdi3>
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
  80132a:	e8 ed 32 00 00       	call   80461c <__umoddi3>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	05 f4 4c 80 00       	add    $0x804cf4,%eax
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
  801485:	8b 04 85 18 4d 80 00 	mov    0x804d18(,%eax,4),%eax
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
  801566:	8b 34 9d 60 4b 80 00 	mov    0x804b60(,%ebx,4),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 19                	jne    80158a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801571:	53                   	push   %ebx
  801572:	68 05 4d 80 00       	push   $0x804d05
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
  80158b:	68 0e 4d 80 00       	push   $0x804d0e
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
  8015b8:	be 11 4d 80 00       	mov    $0x804d11,%esi
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
  801fc3:	68 88 4e 80 00       	push   $0x804e88
  801fc8:	68 3f 01 00 00       	push   $0x13f
  801fcd:	68 aa 4e 80 00       	push   $0x804eaa
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
  801fe3:	e8 35 0a 00 00       	call   802a1d <sys_sbrk>
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
  80205e:	e8 3e 08 00 00       	call   8028a1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 16                	je     80207d <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 7e 0d 00 00       	call   802df0 <alloc_block_FF>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	e9 8a 01 00 00       	jmp    802207 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80207d:	e8 50 08 00 00       	call   8028d2 <sys_isUHeapPlacementStrategyBESTFIT>
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 84 7d 01 00 00    	je     802207 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 17 12 00 00       	call   8032ac <alloc_block_BF>
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
  8021f6:	e8 59 08 00 00       	call   802a54 <sys_allocate_user_mem>
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
  80223e:	e8 2d 08 00 00       	call   802a70 <get_block_size>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	e8 60 1a 00 00       	call   803cb4 <free_block>
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
  8022e6:	e8 4d 07 00 00       	call   802a38 <sys_free_user_mem>
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
  8022f4:	68 b8 4e 80 00       	push   $0x804eb8
  8022f9:	68 84 00 00 00       	push   $0x84
  8022fe:	68 e2 4e 80 00       	push   $0x804ee2
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
  802366:	e8 d4 02 00 00       	call   80263f <sys_createSharedObject>
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
  802387:	68 ee 4e 80 00       	push   $0x804eee
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
  80239c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 f4 4e 80 00       	push   $0x804ef4
  8023a7:	68 a4 00 00 00       	push   $0xa4
  8023ac:	68 e2 4e 80 00       	push   $0x804ee2
  8023b1:	e8 ca eb ff ff       	call   800f80 <_panic>

008023b6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 18 4f 80 00       	push   $0x804f18
  8023c4:	68 bc 00 00 00       	push   $0xbc
  8023c9:	68 e2 4e 80 00       	push   $0x804ee2
  8023ce:	e8 ad eb ff ff       	call   800f80 <_panic>

008023d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	68 3c 4f 80 00       	push   $0x804f3c
  8023e1:	68 d3 00 00 00       	push   $0xd3
  8023e6:	68 e2 4e 80 00       	push   $0x804ee2
  8023eb:	e8 90 eb ff ff       	call   800f80 <_panic>

008023f0 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	68 62 4f 80 00       	push   $0x804f62
  8023fe:	68 df 00 00 00       	push   $0xdf
  802403:	68 e2 4e 80 00       	push   $0x804ee2
  802408:	e8 73 eb ff ff       	call   800f80 <_panic>

0080240d <shrink>:

}
void shrink(uint32 newSize)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	68 62 4f 80 00       	push   $0x804f62
  80241b:	68 e4 00 00 00       	push   $0xe4
  802420:	68 e2 4e 80 00       	push   $0x804ee2
  802425:	e8 56 eb ff ff       	call   800f80 <_panic>

0080242a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 62 4f 80 00       	push   $0x804f62
  802438:	68 e9 00 00 00       	push   $0xe9
  80243d:	68 e2 4e 80 00       	push   $0x804ee2
  802442:	e8 39 eb ff ff       	call   800f80 <_panic>

00802447 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	57                   	push   %edi
  80244b:	56                   	push   %esi
  80244c:	53                   	push   %ebx
  80244d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	8b 55 0c             	mov    0xc(%ebp),%edx
  802456:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802459:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80245c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80245f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802462:	cd 30                	int    $0x30
  802464:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	8b 45 10             	mov    0x10(%ebp),%eax
  80247b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80247e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	52                   	push   %edx
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	50                   	push   %eax
  80248e:	6a 00                	push   $0x0
  802490:	e8 b2 ff ff ff       	call   802447 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	90                   	nop
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_cgetc>:

int
sys_cgetc(void)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 02                	push   $0x2
  8024aa:	e8 98 ff ff ff       	call   802447 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 03                	push   $0x3
  8024c3:	e8 7f ff ff ff       	call   802447 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
}
  8024cb:	90                   	nop
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 04                	push   $0x4
  8024dd:	e8 65 ff ff ff       	call   802447 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	90                   	nop
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 08                	push   $0x8
  8024fb:	e8 47 ff ff ff       	call   802447 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80250a:	8b 75 18             	mov    0x18(%ebp),%esi
  80250d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802510:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802513:	8b 55 0c             	mov    0xc(%ebp),%edx
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	56                   	push   %esi
  80251a:	53                   	push   %ebx
  80251b:	51                   	push   %ecx
  80251c:	52                   	push   %edx
  80251d:	50                   	push   %eax
  80251e:	6a 09                	push   $0x9
  802520:	e8 22 ff ff ff       	call   802447 <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5d                   	pop    %ebp
  80252e:	c3                   	ret    

0080252f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802532:	8b 55 0c             	mov    0xc(%ebp),%edx
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	52                   	push   %edx
  80253f:	50                   	push   %eax
  802540:	6a 0a                	push   $0xa
  802542:	e8 00 ff ff ff       	call   802447 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
}
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	ff 75 0c             	pushl  0xc(%ebp)
  802558:	ff 75 08             	pushl  0x8(%ebp)
  80255b:	6a 0b                	push   $0xb
  80255d:	e8 e5 fe ff ff       	call   802447 <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 0c                	push   $0xc
  802576:	e8 cc fe ff ff       	call   802447 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 0d                	push   $0xd
  80258f:	e8 b3 fe ff ff       	call   802447 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 0e                	push   $0xe
  8025a8:	e8 9a fe ff ff       	call   802447 <syscall>
  8025ad:	83 c4 18             	add    $0x18,%esp
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 0f                	push   $0xf
  8025c1:	e8 81 fe ff ff       	call   802447 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	ff 75 08             	pushl  0x8(%ebp)
  8025d9:	6a 10                	push   $0x10
  8025db:	e8 67 fe ff ff       	call   802447 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 11                	push   $0x11
  8025f4:	e8 4e fe ff ff       	call   802447 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	90                   	nop
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <sys_cputc>:

void
sys_cputc(const char c)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80260b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	50                   	push   %eax
  802618:	6a 01                	push   $0x1
  80261a:	e8 28 fe ff ff       	call   802447 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	90                   	nop
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 14                	push   $0x14
  802634:	e8 0e fe ff ff       	call   802447 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
}
  80263c:	90                   	nop
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	8b 45 10             	mov    0x10(%ebp),%eax
  802648:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80264b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80264e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	51                   	push   %ecx
  802658:	52                   	push   %edx
  802659:	ff 75 0c             	pushl  0xc(%ebp)
  80265c:	50                   	push   %eax
  80265d:	6a 15                	push   $0x15
  80265f:	e8 e3 fd ff ff       	call   802447 <syscall>
  802664:	83 c4 18             	add    $0x18,%esp
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80266c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	52                   	push   %edx
  802679:	50                   	push   %eax
  80267a:	6a 16                	push   $0x16
  80267c:	e8 c6 fd ff ff       	call   802447 <syscall>
  802681:	83 c4 18             	add    $0x18,%esp
}
  802684:	c9                   	leave  
  802685:	c3                   	ret    

00802686 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802689:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80268c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	51                   	push   %ecx
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	6a 17                	push   $0x17
  80269b:	e8 a7 fd ff ff       	call   802447 <syscall>
  8026a0:	83 c4 18             	add    $0x18,%esp
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	52                   	push   %edx
  8026b5:	50                   	push   %eax
  8026b6:	6a 18                	push   $0x18
  8026b8:	e8 8a fd ff ff       	call   802447 <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	6a 00                	push   $0x0
  8026ca:	ff 75 14             	pushl  0x14(%ebp)
  8026cd:	ff 75 10             	pushl  0x10(%ebp)
  8026d0:	ff 75 0c             	pushl  0xc(%ebp)
  8026d3:	50                   	push   %eax
  8026d4:	6a 19                	push   $0x19
  8026d6:	e8 6c fd ff ff       	call   802447 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	50                   	push   %eax
  8026ef:	6a 1a                	push   $0x1a
  8026f1:	e8 51 fd ff ff       	call   802447 <syscall>
  8026f6:	83 c4 18             	add    $0x18,%esp
}
  8026f9:	90                   	nop
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	50                   	push   %eax
  80270b:	6a 1b                	push   $0x1b
  80270d:	e8 35 fd ff ff       	call   802447 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 05                	push   $0x5
  802726:	e8 1c fd ff ff       	call   802447 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 06                	push   $0x6
  80273f:	e8 03 fd ff ff       	call   802447 <syscall>
  802744:	83 c4 18             	add    $0x18,%esp
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 07                	push   $0x7
  802758:	e8 ea fc ff ff       	call   802447 <syscall>
  80275d:	83 c4 18             	add    $0x18,%esp
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sys_exit_env>:


void sys_exit_env(void)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 1c                	push   $0x1c
  802771:	e8 d1 fc ff ff       	call   802447 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
}
  802779:	90                   	nop
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802782:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802785:	8d 50 04             	lea    0x4(%eax),%edx
  802788:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	52                   	push   %edx
  802792:	50                   	push   %eax
  802793:	6a 1d                	push   $0x1d
  802795:	e8 ad fc ff ff       	call   802447 <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
	return result;
  80279d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027a6:	89 01                	mov    %eax,(%ecx)
  8027a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	c9                   	leave  
  8027af:	c2 04 00             	ret    $0x4

008027b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	ff 75 10             	pushl  0x10(%ebp)
  8027bc:	ff 75 0c             	pushl  0xc(%ebp)
  8027bf:	ff 75 08             	pushl  0x8(%ebp)
  8027c2:	6a 13                	push   $0x13
  8027c4:	e8 7e fc ff ff       	call   802447 <syscall>
  8027c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cc:	90                   	nop
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 1e                	push   $0x1e
  8027de:	e8 64 fc ff ff       	call   802447 <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	50                   	push   %eax
  802801:	6a 1f                	push   $0x1f
  802803:	e8 3f fc ff ff       	call   802447 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
	return ;
  80280b:	90                   	nop
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <rsttst>:
void rsttst()
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 21                	push   $0x21
  80281d:	e8 25 fc ff ff       	call   802447 <syscall>
  802822:	83 c4 18             	add    $0x18,%esp
	return ;
  802825:	90                   	nop
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	8b 45 14             	mov    0x14(%ebp),%eax
  802831:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802834:	8b 55 18             	mov    0x18(%ebp),%edx
  802837:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80283b:	52                   	push   %edx
  80283c:	50                   	push   %eax
  80283d:	ff 75 10             	pushl  0x10(%ebp)
  802840:	ff 75 0c             	pushl  0xc(%ebp)
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	6a 20                	push   $0x20
  802848:	e8 fa fb ff ff       	call   802447 <syscall>
  80284d:	83 c4 18             	add    $0x18,%esp
	return ;
  802850:	90                   	nop
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <chktst>:
void chktst(uint32 n)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	ff 75 08             	pushl  0x8(%ebp)
  802861:	6a 22                	push   $0x22
  802863:	e8 df fb ff ff       	call   802447 <syscall>
  802868:	83 c4 18             	add    $0x18,%esp
	return ;
  80286b:	90                   	nop
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <inctst>:

void inctst()
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 23                	push   $0x23
  80287d:	e8 c5 fb ff ff       	call   802447 <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
	return ;
  802885:	90                   	nop
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <gettst>:
uint32 gettst()
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 24                	push   $0x24
  802897:	e8 ab fb ff ff       	call   802447 <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 25                	push   $0x25
  8028b3:	e8 8f fb ff ff       	call   802447 <syscall>
  8028b8:	83 c4 18             	add    $0x18,%esp
  8028bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028be:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028c2:	75 07                	jne    8028cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c9:	eb 05                	jmp    8028d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 25                	push   $0x25
  8028e4:	e8 5e fb ff ff       	call   802447 <syscall>
  8028e9:	83 c4 18             	add    $0x18,%esp
  8028ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028ef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028f3:	75 07                	jne    8028fc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fa:	eb 05                	jmp    802901 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
  802906:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 25                	push   $0x25
  802915:	e8 2d fb ff ff       	call   802447 <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
  80291d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802920:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802924:	75 07                	jne    80292d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802926:	b8 01 00 00 00       	mov    $0x1,%eax
  80292b:	eb 05                	jmp    802932 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 25                	push   $0x25
  802946:	e8 fc fa ff ff       	call   802447 <syscall>
  80294b:	83 c4 18             	add    $0x18,%esp
  80294e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802951:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802955:	75 07                	jne    80295e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802957:	b8 01 00 00 00       	mov    $0x1,%eax
  80295c:	eb 05                	jmp    802963 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80295e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802963:	c9                   	leave  
  802964:	c3                   	ret    

00802965 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	ff 75 08             	pushl  0x8(%ebp)
  802973:	6a 26                	push   $0x26
  802975:	e8 cd fa ff ff       	call   802447 <syscall>
  80297a:	83 c4 18             	add    $0x18,%esp
	return ;
  80297d:	90                   	nop
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
  802983:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802984:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802987:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80298a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	6a 00                	push   $0x0
  802992:	53                   	push   %ebx
  802993:	51                   	push   %ecx
  802994:	52                   	push   %edx
  802995:	50                   	push   %eax
  802996:	6a 27                	push   $0x27
  802998:	e8 aa fa ff ff       	call   802447 <syscall>
  80299d:	83 c4 18             	add    $0x18,%esp
}
  8029a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	52                   	push   %edx
  8029b5:	50                   	push   %eax
  8029b6:	6a 28                	push   $0x28
  8029b8:	e8 8a fa ff ff       	call   802447 <syscall>
  8029bd:	83 c4 18             	add    $0x18,%esp
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8029c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	6a 00                	push   $0x0
  8029d0:	51                   	push   %ecx
  8029d1:	ff 75 10             	pushl  0x10(%ebp)
  8029d4:	52                   	push   %edx
  8029d5:	50                   	push   %eax
  8029d6:	6a 29                	push   $0x29
  8029d8:	e8 6a fa ff ff       	call   802447 <syscall>
  8029dd:	83 c4 18             	add    $0x18,%esp
}
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	ff 75 10             	pushl  0x10(%ebp)
  8029ec:	ff 75 0c             	pushl  0xc(%ebp)
  8029ef:	ff 75 08             	pushl  0x8(%ebp)
  8029f2:	6a 12                	push   $0x12
  8029f4:	e8 4e fa ff ff       	call   802447 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fc:	90                   	nop
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	52                   	push   %edx
  802a0f:	50                   	push   %eax
  802a10:	6a 2a                	push   $0x2a
  802a12:	e8 30 fa ff ff       	call   802447 <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
	return;
  802a1a:	90                   	nop
}
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	50                   	push   %eax
  802a2c:	6a 2b                	push   $0x2b
  802a2e:	e8 14 fa ff ff       	call   802447 <syscall>
  802a33:	83 c4 18             	add    $0x18,%esp
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	ff 75 0c             	pushl  0xc(%ebp)
  802a44:	ff 75 08             	pushl  0x8(%ebp)
  802a47:	6a 2c                	push   $0x2c
  802a49:	e8 f9 f9 ff ff       	call   802447 <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
	return;
  802a51:	90                   	nop
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	ff 75 0c             	pushl  0xc(%ebp)
  802a60:	ff 75 08             	pushl  0x8(%ebp)
  802a63:	6a 2d                	push   $0x2d
  802a65:	e8 dd f9 ff ff       	call   802447 <syscall>
  802a6a:	83 c4 18             	add    $0x18,%esp
	return;
  802a6d:	90                   	nop
}
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
  802a73:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	83 e8 04             	sub    $0x4,%eax
  802a7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	83 e8 04             	sub    $0x4,%eax
  802a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	83 e0 01             	and    $0x1,%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	0f 94 c0             	sete   %al
}
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    

00802aa7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802aa7:	55                   	push   %ebp
  802aa8:	89 e5                	mov    %esp,%ebp
  802aaa:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab7:	83 f8 02             	cmp    $0x2,%eax
  802aba:	74 2b                	je     802ae7 <alloc_block+0x40>
  802abc:	83 f8 02             	cmp    $0x2,%eax
  802abf:	7f 07                	jg     802ac8 <alloc_block+0x21>
  802ac1:	83 f8 01             	cmp    $0x1,%eax
  802ac4:	74 0e                	je     802ad4 <alloc_block+0x2d>
  802ac6:	eb 58                	jmp    802b20 <alloc_block+0x79>
  802ac8:	83 f8 03             	cmp    $0x3,%eax
  802acb:	74 2d                	je     802afa <alloc_block+0x53>
  802acd:	83 f8 04             	cmp    $0x4,%eax
  802ad0:	74 3b                	je     802b0d <alloc_block+0x66>
  802ad2:	eb 4c                	jmp    802b20 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802ad4:	83 ec 0c             	sub    $0xc,%esp
  802ad7:	ff 75 08             	pushl  0x8(%ebp)
  802ada:	e8 11 03 00 00       	call   802df0 <alloc_block_FF>
  802adf:	83 c4 10             	add    $0x10,%esp
  802ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ae5:	eb 4a                	jmp    802b31 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ae7:	83 ec 0c             	sub    $0xc,%esp
  802aea:	ff 75 08             	pushl  0x8(%ebp)
  802aed:	e8 fa 19 00 00       	call   8044ec <alloc_block_NF>
  802af2:	83 c4 10             	add    $0x10,%esp
  802af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802af8:	eb 37                	jmp    802b31 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802afa:	83 ec 0c             	sub    $0xc,%esp
  802afd:	ff 75 08             	pushl  0x8(%ebp)
  802b00:	e8 a7 07 00 00       	call   8032ac <alloc_block_BF>
  802b05:	83 c4 10             	add    $0x10,%esp
  802b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b0b:	eb 24                	jmp    802b31 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802b0d:	83 ec 0c             	sub    $0xc,%esp
  802b10:	ff 75 08             	pushl  0x8(%ebp)
  802b13:	e8 b7 19 00 00       	call   8044cf <alloc_block_WF>
  802b18:	83 c4 10             	add    $0x10,%esp
  802b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b1e:	eb 11                	jmp    802b31 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802b20:	83 ec 0c             	sub    $0xc,%esp
  802b23:	68 74 4f 80 00       	push   $0x804f74
  802b28:	e8 10 e7 ff ff       	call   80123d <cprintf>
  802b2d:	83 c4 10             	add    $0x10,%esp
		break;
  802b30:	90                   	nop
	}
	return va;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	53                   	push   %ebx
  802b3a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802b3d:	83 ec 0c             	sub    $0xc,%esp
  802b40:	68 94 4f 80 00       	push   $0x804f94
  802b45:	e8 f3 e6 ff ff       	call   80123d <cprintf>
  802b4a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802b4d:	83 ec 0c             	sub    $0xc,%esp
  802b50:	68 bf 4f 80 00       	push   $0x804fbf
  802b55:	e8 e3 e6 ff ff       	call   80123d <cprintf>
  802b5a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	eb 37                	jmp    802b9c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802b65:	83 ec 0c             	sub    $0xc,%esp
  802b68:	ff 75 f4             	pushl  -0xc(%ebp)
  802b6b:	e8 19 ff ff ff       	call   802a89 <is_free_block>
  802b70:	83 c4 10             	add    $0x10,%esp
  802b73:	0f be d8             	movsbl %al,%ebx
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	ff 75 f4             	pushl  -0xc(%ebp)
  802b7c:	e8 ef fe ff ff       	call   802a70 <get_block_size>
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	53                   	push   %ebx
  802b88:	50                   	push   %eax
  802b89:	68 d7 4f 80 00       	push   $0x804fd7
  802b8e:	e8 aa e6 ff ff       	call   80123d <cprintf>
  802b93:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802b96:	8b 45 10             	mov    0x10(%ebp),%eax
  802b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	74 07                	je     802ba9 <print_blocks_list+0x73>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	eb 05                	jmp    802bae <print_blocks_list+0x78>
  802ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bae:	89 45 10             	mov    %eax,0x10(%ebp)
  802bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	75 ad                	jne    802b65 <print_blocks_list+0x2f>
  802bb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbc:	75 a7                	jne    802b65 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802bbe:	83 ec 0c             	sub    $0xc,%esp
  802bc1:	68 94 4f 80 00       	push   $0x804f94
  802bc6:	e8 72 e6 ff ff       	call   80123d <cprintf>
  802bcb:	83 c4 10             	add    $0x10,%esp

}
  802bce:	90                   	nop
  802bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bd2:	c9                   	leave  
  802bd3:	c3                   	ret    

00802bd4 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802bd4:	55                   	push   %ebp
  802bd5:	89 e5                	mov    %esp,%ebp
  802bd7:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bdd:	83 e0 01             	and    $0x1,%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 03                	je     802be7 <initialize_dynamic_allocator+0x13>
  802be4:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802beb:	0f 84 c7 01 00 00    	je     802db8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802bf1:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802bf8:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c01:	01 d0                	add    %edx,%eax
  802c03:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802c08:	0f 87 ad 01 00 00    	ja     802dbb <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	0f 89 a5 01 00 00    	jns    802dbe <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802c19:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1f:	01 d0                	add    %edx,%eax
  802c21:	83 e8 04             	sub    $0x4,%eax
  802c24:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802c29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802c30:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c38:	e9 87 00 00 00       	jmp    802cc4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	75 14                	jne    802c57 <initialize_dynamic_allocator+0x83>
  802c43:	83 ec 04             	sub    $0x4,%esp
  802c46:	68 ef 4f 80 00       	push   $0x804fef
  802c4b:	6a 79                	push   $0x79
  802c4d:	68 0d 50 80 00       	push   $0x80500d
  802c52:	e8 29 e3 ff ff       	call   800f80 <_panic>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	74 10                	je     802c70 <initialize_dynamic_allocator+0x9c>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c68:	8b 52 04             	mov    0x4(%edx),%edx
  802c6b:	89 50 04             	mov    %edx,0x4(%eax)
  802c6e:	eb 0b                	jmp    802c7b <initialize_dynamic_allocator+0xa7>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	a3 30 60 80 00       	mov    %eax,0x806030
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 0f                	je     802c94 <initialize_dynamic_allocator+0xc0>
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8e:	8b 12                	mov    (%edx),%edx
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	eb 0a                	jmp    802c9e <initialize_dynamic_allocator+0xca>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb1:	a1 38 60 80 00       	mov    0x806038,%eax
  802cb6:	48                   	dec    %eax
  802cb7:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802cbc:	a1 34 60 80 00       	mov    0x806034,%eax
  802cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc8:	74 07                	je     802cd1 <initialize_dynamic_allocator+0xfd>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	eb 05                	jmp    802cd6 <initialize_dynamic_allocator+0x102>
  802cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd6:	a3 34 60 80 00       	mov    %eax,0x806034
  802cdb:	a1 34 60 80 00       	mov    0x806034,%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	0f 85 55 ff ff ff    	jne    802c3d <initialize_dynamic_allocator+0x69>
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cec:	0f 85 4b ff ff ff    	jne    802c3d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802d01:	a1 44 60 80 00       	mov    0x806044,%eax
  802d06:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802d0b:	a1 40 60 80 00       	mov    0x806040,%eax
  802d10:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	83 c0 08             	add    $0x8,%eax
  802d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	83 c0 04             	add    $0x4,%eax
  802d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d28:	83 ea 08             	sub    $0x8,%edx
  802d2b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	01 d0                	add    %edx,%eax
  802d35:	83 e8 08             	sub    $0x8,%eax
  802d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3b:	83 ea 08             	sub    $0x8,%edx
  802d3e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d57:	75 17                	jne    802d70 <initialize_dynamic_allocator+0x19c>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 28 50 80 00       	push   $0x805028
  802d61:	68 90 00 00 00       	push   $0x90
  802d66:	68 0d 50 80 00       	push   $0x80500d
  802d6b:	e8 10 e2 ff ff       	call   800f80 <_panic>
  802d70:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <initialize_dynamic_allocator+0x1bd>
  802d84:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802d89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 08                	jmp    802d99 <initialize_dynamic_allocator+0x1c5>
  802d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d94:	a3 30 60 80 00       	mov    %eax,0x806030
  802d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 38 60 80 00       	mov    0x806038,%eax
  802db0:	40                   	inc    %eax
  802db1:	a3 38 60 80 00       	mov    %eax,0x806038
  802db6:	eb 07                	jmp    802dbf <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802db8:	90                   	nop
  802db9:	eb 04                	jmp    802dbf <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802dbb:	90                   	nop
  802dbc:	eb 01                	jmp    802dbf <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802dbe:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802dbf:	c9                   	leave  
  802dc0:	c3                   	ret    

00802dc1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  802dc7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd3:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	83 e8 04             	sub    $0x4,%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	83 e0 fe             	and    $0xfffffffe,%eax
  802de0:	8d 50 f8             	lea    -0x8(%eax),%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802deb:	89 02                	mov    %eax,(%edx)
}
  802ded:	90                   	nop
  802dee:	5d                   	pop    %ebp
  802def:	c3                   	ret    

00802df0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	83 e0 01             	and    $0x1,%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 03                	je     802e03 <alloc_block_FF+0x13>
  802e00:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e03:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e07:	77 07                	ja     802e10 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e09:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e10:	a1 24 60 80 00       	mov    0x806024,%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	75 73                	jne    802e8c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	83 c0 10             	add    $0x10,%eax
  802e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e22:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802e29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	01 d0                	add    %edx,%eax
  802e31:	48                   	dec    %eax
  802e32:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e38:	ba 00 00 00 00       	mov    $0x0,%edx
  802e3d:	f7 75 ec             	divl   -0x14(%ebp)
  802e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e43:	29 d0                	sub    %edx,%eax
  802e45:	c1 e8 0c             	shr    $0xc,%eax
  802e48:	83 ec 0c             	sub    $0xc,%esp
  802e4b:	50                   	push   %eax
  802e4c:	e8 86 f1 ff ff       	call   801fd7 <sbrk>
  802e51:	83 c4 10             	add    $0x10,%esp
  802e54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e57:	83 ec 0c             	sub    $0xc,%esp
  802e5a:	6a 00                	push   $0x0
  802e5c:	e8 76 f1 ff ff       	call   801fd7 <sbrk>
  802e61:	83 c4 10             	add    $0x10,%esp
  802e64:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802e6d:	83 ec 08             	sub    $0x8,%esp
  802e70:	50                   	push   %eax
  802e71:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e74:	e8 5b fd ff ff       	call   802bd4 <initialize_dynamic_allocator>
  802e79:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	68 4b 50 80 00       	push   $0x80504b
  802e84:	e8 b4 e3 ff ff       	call   80123d <cprintf>
  802e89:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802e8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e90:	75 0a                	jne    802e9c <alloc_block_FF+0xac>
	        return NULL;
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
  802e97:	e9 0e 04 00 00       	jmp    8032aa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802e9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ea3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eab:	e9 f3 02 00 00       	jmp    8031a3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	ff 75 bc             	pushl  -0x44(%ebp)
  802ebc:	e8 af fb ff ff       	call   802a70 <get_block_size>
  802ec1:	83 c4 10             	add    $0x10,%esp
  802ec4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	83 c0 08             	add    $0x8,%eax
  802ecd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ed0:	0f 87 c5 02 00 00    	ja     80319b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	83 c0 18             	add    $0x18,%eax
  802edc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802edf:	0f 87 19 02 00 00    	ja     8030fe <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ee5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ee8:	2b 45 08             	sub    0x8(%ebp),%eax
  802eeb:	83 e8 08             	sub    $0x8,%eax
  802eee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8d 50 08             	lea    0x8(%eax),%edx
  802ef7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802efa:	01 d0                	add    %edx,%eax
  802efc:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	83 c0 08             	add    $0x8,%eax
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	6a 01                	push   $0x1
  802f0a:	50                   	push   %eax
  802f0b:	ff 75 bc             	pushl  -0x44(%ebp)
  802f0e:	e8 ae fe ff ff       	call   802dc1 <set_block_data>
  802f13:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	75 68                	jne    802f88 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f20:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802f24:	75 17                	jne    802f3d <alloc_block_FF+0x14d>
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 28 50 80 00       	push   $0x805028
  802f2e:	68 d7 00 00 00       	push   $0xd7
  802f33:	68 0d 50 80 00       	push   $0x80500d
  802f38:	e8 43 e0 ff ff       	call   800f80 <_panic>
  802f3d:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802f43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f46:	89 10                	mov    %edx,(%eax)
  802f48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0d                	je     802f5e <alloc_block_FF+0x16e>
  802f51:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f56:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	eb 08                	jmp    802f66 <alloc_block_FF+0x176>
  802f5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f61:	a3 30 60 80 00       	mov    %eax,0x806030
  802f66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f69:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f78:	a1 38 60 80 00       	mov    0x806038,%eax
  802f7d:	40                   	inc    %eax
  802f7e:	a3 38 60 80 00       	mov    %eax,0x806038
  802f83:	e9 dc 00 00 00       	jmp    803064 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	75 65                	jne    802ff6 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f91:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802f95:	75 17                	jne    802fae <alloc_block_FF+0x1be>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 5c 50 80 00       	push   $0x80505c
  802f9f:	68 db 00 00 00       	push   $0xdb
  802fa4:	68 0d 50 80 00       	push   $0x80500d
  802fa9:	e8 d2 df ff ff       	call   800f80 <_panic>
  802fae:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802fb4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fb7:	89 50 04             	mov    %edx,0x4(%eax)
  802fba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 0c                	je     802fd0 <alloc_block_FF+0x1e0>
  802fc4:	a1 30 60 80 00       	mov    0x806030,%eax
  802fc9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802fcc:	89 10                	mov    %edx,(%eax)
  802fce:	eb 08                	jmp    802fd8 <alloc_block_FF+0x1e8>
  802fd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fd3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802fd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fdb:	a3 30 60 80 00       	mov    %eax,0x806030
  802fe0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe9:	a1 38 60 80 00       	mov    0x806038,%eax
  802fee:	40                   	inc    %eax
  802fef:	a3 38 60 80 00       	mov    %eax,0x806038
  802ff4:	eb 6e                	jmp    803064 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	74 06                	je     803002 <alloc_block_FF+0x212>
  802ffc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803000:	75 17                	jne    803019 <alloc_block_FF+0x229>
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 80 50 80 00       	push   $0x805080
  80300a:	68 df 00 00 00       	push   $0xdf
  80300f:	68 0d 50 80 00       	push   $0x80500d
  803014:	e8 67 df ff ff       	call   800f80 <_panic>
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 10                	mov    (%eax),%edx
  80301e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803021:	89 10                	mov    %edx,(%eax)
  803023:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0b                	je     803037 <alloc_block_FF+0x247>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803034:	89 50 04             	mov    %edx,0x4(%eax)
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80303d:	89 10                	mov    %edx,(%eax)
  80303f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	75 08                	jne    803059 <alloc_block_FF+0x269>
  803051:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803054:	a3 30 60 80 00       	mov    %eax,0x806030
  803059:	a1 38 60 80 00       	mov    0x806038,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	75 17                	jne    803081 <alloc_block_FF+0x291>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 ef 4f 80 00       	push   $0x804fef
  803072:	68 e1 00 00 00       	push   $0xe1
  803077:	68 0d 50 80 00       	push   $0x80500d
  80307c:	e8 ff de ff ff       	call   800f80 <_panic>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 10                	je     80309a <alloc_block_FF+0x2aa>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803092:	8b 52 04             	mov    0x4(%edx),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 0b                	jmp    8030a5 <alloc_block_FF+0x2b5>
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	a3 30 60 80 00       	mov    %eax,0x806030
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 0f                	je     8030be <alloc_block_FF+0x2ce>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b8:	8b 12                	mov    (%edx),%edx
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	eb 0a                	jmp    8030c8 <alloc_block_FF+0x2d8>
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 38 60 80 00       	mov    0x806038,%eax
  8030e0:	48                   	dec    %eax
  8030e1:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8030e6:	83 ec 04             	sub    $0x4,%esp
  8030e9:	6a 00                	push   $0x0
  8030eb:	ff 75 b4             	pushl  -0x4c(%ebp)
  8030ee:	ff 75 b0             	pushl  -0x50(%ebp)
  8030f1:	e8 cb fc ff ff       	call   802dc1 <set_block_data>
  8030f6:	83 c4 10             	add    $0x10,%esp
  8030f9:	e9 95 00 00 00       	jmp    803193 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	6a 01                	push   $0x1
  803103:	ff 75 b8             	pushl  -0x48(%ebp)
  803106:	ff 75 bc             	pushl  -0x44(%ebp)
  803109:	e8 b3 fc ff ff       	call   802dc1 <set_block_data>
  80310e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	75 17                	jne    80312e <alloc_block_FF+0x33e>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 ef 4f 80 00       	push   $0x804fef
  80311f:	68 e8 00 00 00       	push   $0xe8
  803124:	68 0d 50 80 00       	push   $0x80500d
  803129:	e8 52 de ff ff       	call   800f80 <_panic>
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 10                	je     803147 <alloc_block_FF+0x357>
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313f:	8b 52 04             	mov    0x4(%edx),%edx
  803142:	89 50 04             	mov    %edx,0x4(%eax)
  803145:	eb 0b                	jmp    803152 <alloc_block_FF+0x362>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	a3 30 60 80 00       	mov    %eax,0x806030
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 0f                	je     80316b <alloc_block_FF+0x37b>
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803165:	8b 12                	mov    (%edx),%edx
  803167:	89 10                	mov    %edx,(%eax)
  803169:	eb 0a                	jmp    803175 <alloc_block_FF+0x385>
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 38 60 80 00       	mov    0x806038,%eax
  80318d:	48                   	dec    %eax
  80318e:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  803193:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803196:	e9 0f 01 00 00       	jmp    8032aa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80319b:	a1 34 60 80 00       	mov    0x806034,%eax
  8031a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a7:	74 07                	je     8031b0 <alloc_block_FF+0x3c0>
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	eb 05                	jmp    8031b5 <alloc_block_FF+0x3c5>
  8031b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b5:	a3 34 60 80 00       	mov    %eax,0x806034
  8031ba:	a1 34 60 80 00       	mov    0x806034,%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	0f 85 e9 fc ff ff    	jne    802eb0 <alloc_block_FF+0xc0>
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	0f 85 df fc ff ff    	jne    802eb0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	83 c0 08             	add    $0x8,%eax
  8031d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031da:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8031e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031e7:	01 d0                	add    %edx,%eax
  8031e9:	48                   	dec    %eax
  8031ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8031ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f5:	f7 75 d8             	divl   -0x28(%ebp)
  8031f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031fb:	29 d0                	sub    %edx,%eax
  8031fd:	c1 e8 0c             	shr    $0xc,%eax
  803200:	83 ec 0c             	sub    $0xc,%esp
  803203:	50                   	push   %eax
  803204:	e8 ce ed ff ff       	call   801fd7 <sbrk>
  803209:	83 c4 10             	add    $0x10,%esp
  80320c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80320f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803213:	75 0a                	jne    80321f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803215:	b8 00 00 00 00       	mov    $0x0,%eax
  80321a:	e9 8b 00 00 00       	jmp    8032aa <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80321f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803226:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803229:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	48                   	dec    %eax
  80322f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803232:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803235:	ba 00 00 00 00       	mov    $0x0,%edx
  80323a:	f7 75 cc             	divl   -0x34(%ebp)
  80323d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803240:	29 d0                	sub    %edx,%eax
  803242:	8d 50 fc             	lea    -0x4(%eax),%edx
  803245:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803248:	01 d0                	add    %edx,%eax
  80324a:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  80324f:	a1 40 60 80 00       	mov    0x806040,%eax
  803254:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80325a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803261:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803264:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803267:	01 d0                	add    %edx,%eax
  803269:	48                   	dec    %eax
  80326a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80326d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803270:	ba 00 00 00 00       	mov    $0x0,%edx
  803275:	f7 75 c4             	divl   -0x3c(%ebp)
  803278:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80327b:	29 d0                	sub    %edx,%eax
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	6a 01                	push   $0x1
  803282:	50                   	push   %eax
  803283:	ff 75 d0             	pushl  -0x30(%ebp)
  803286:	e8 36 fb ff ff       	call   802dc1 <set_block_data>
  80328b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80328e:	83 ec 0c             	sub    $0xc,%esp
  803291:	ff 75 d0             	pushl  -0x30(%ebp)
  803294:	e8 1b 0a 00 00       	call   803cb4 <free_block>
  803299:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80329c:	83 ec 0c             	sub    $0xc,%esp
  80329f:	ff 75 08             	pushl  0x8(%ebp)
  8032a2:	e8 49 fb ff ff       	call   802df0 <alloc_block_FF>
  8032a7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8032aa:	c9                   	leave  
  8032ab:	c3                   	ret    

008032ac <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8032ac:	55                   	push   %ebp
  8032ad:	89 e5                	mov    %esp,%ebp
  8032af:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	83 e0 01             	and    $0x1,%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 03                	je     8032bf <alloc_block_BF+0x13>
  8032bc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8032bf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8032c3:	77 07                	ja     8032cc <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8032c5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8032cc:	a1 24 60 80 00       	mov    0x806024,%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	75 73                	jne    803348 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	83 c0 10             	add    $0x10,%eax
  8032db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8032de:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8032e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032eb:	01 d0                	add    %edx,%eax
  8032ed:	48                   	dec    %eax
  8032ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032f9:	f7 75 e0             	divl   -0x20(%ebp)
  8032fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ff:	29 d0                	sub    %edx,%eax
  803301:	c1 e8 0c             	shr    $0xc,%eax
  803304:	83 ec 0c             	sub    $0xc,%esp
  803307:	50                   	push   %eax
  803308:	e8 ca ec ff ff       	call   801fd7 <sbrk>
  80330d:	83 c4 10             	add    $0x10,%esp
  803310:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803313:	83 ec 0c             	sub    $0xc,%esp
  803316:	6a 00                	push   $0x0
  803318:	e8 ba ec ff ff       	call   801fd7 <sbrk>
  80331d:	83 c4 10             	add    $0x10,%esp
  803320:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803323:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803326:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803329:	83 ec 08             	sub    $0x8,%esp
  80332c:	50                   	push   %eax
  80332d:	ff 75 d8             	pushl  -0x28(%ebp)
  803330:	e8 9f f8 ff ff       	call   802bd4 <initialize_dynamic_allocator>
  803335:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803338:	83 ec 0c             	sub    $0xc,%esp
  80333b:	68 4b 50 80 00       	push   $0x80504b
  803340:	e8 f8 de ff ff       	call   80123d <cprintf>
  803345:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80334f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803356:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80335d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803364:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336c:	e9 1d 01 00 00       	jmp    80348e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803377:	83 ec 0c             	sub    $0xc,%esp
  80337a:	ff 75 a8             	pushl  -0x58(%ebp)
  80337d:	e8 ee f6 ff ff       	call   802a70 <get_block_size>
  803382:	83 c4 10             	add    $0x10,%esp
  803385:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	83 c0 08             	add    $0x8,%eax
  80338e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803391:	0f 87 ef 00 00 00    	ja     803486 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	83 c0 18             	add    $0x18,%eax
  80339d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8033a0:	77 1d                	ja     8033bf <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8033a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8033a8:	0f 86 d8 00 00 00    	jbe    803486 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8033ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8033b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8033b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8033b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8033ba:	e9 c7 00 00 00       	jmp    803486 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	83 c0 08             	add    $0x8,%eax
  8033c5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8033c8:	0f 85 9d 00 00 00    	jne    80346b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	6a 01                	push   $0x1
  8033d3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8033d6:	ff 75 a8             	pushl  -0x58(%ebp)
  8033d9:	e8 e3 f9 ff ff       	call   802dc1 <set_block_data>
  8033de:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8033e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e5:	75 17                	jne    8033fe <alloc_block_BF+0x152>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 ef 4f 80 00       	push   $0x804fef
  8033ef:	68 2c 01 00 00       	push   $0x12c
  8033f4:	68 0d 50 80 00       	push   $0x80500d
  8033f9:	e8 82 db ff ff       	call   800f80 <_panic>
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 10                	je     803417 <alloc_block_BF+0x16b>
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	8b 00                	mov    (%eax),%eax
  80340c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340f:	8b 52 04             	mov    0x4(%edx),%edx
  803412:	89 50 04             	mov    %edx,0x4(%eax)
  803415:	eb 0b                	jmp    803422 <alloc_block_BF+0x176>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	a3 30 60 80 00       	mov    %eax,0x806030
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 40 04             	mov    0x4(%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0f                	je     80343b <alloc_block_BF+0x18f>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 40 04             	mov    0x4(%eax),%eax
  803432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803435:	8b 12                	mov    (%edx),%edx
  803437:	89 10                	mov    %edx,(%eax)
  803439:	eb 0a                	jmp    803445 <alloc_block_BF+0x199>
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 00                	mov    (%eax),%eax
  803440:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803458:	a1 38 60 80 00       	mov    0x806038,%eax
  80345d:	48                   	dec    %eax
  80345e:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803463:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803466:	e9 24 04 00 00       	jmp    80388f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80346b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803471:	76 13                	jbe    803486 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803473:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80347a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80347d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803480:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803483:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803486:	a1 34 60 80 00       	mov    0x806034,%eax
  80348b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803492:	74 07                	je     80349b <alloc_block_BF+0x1ef>
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	eb 05                	jmp    8034a0 <alloc_block_BF+0x1f4>
  80349b:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a0:	a3 34 60 80 00       	mov    %eax,0x806034
  8034a5:	a1 34 60 80 00       	mov    0x806034,%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	0f 85 bf fe ff ff    	jne    803371 <alloc_block_BF+0xc5>
  8034b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b6:	0f 85 b5 fe ff ff    	jne    803371 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8034bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034c0:	0f 84 26 02 00 00    	je     8036ec <alloc_block_BF+0x440>
  8034c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ca:	0f 85 1c 02 00 00    	jne    8036ec <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8034d6:	83 e8 08             	sub    $0x8,%eax
  8034d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	8d 50 08             	lea    0x8(%eax),%edx
  8034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e5:	01 d0                	add    %edx,%eax
  8034e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	83 c0 08             	add    $0x8,%eax
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	6a 01                	push   $0x1
  8034f5:	50                   	push   %eax
  8034f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f9:	e8 c3 f8 ff ff       	call   802dc1 <set_block_data>
  8034fe:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	75 68                	jne    803573 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80350b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80350f:	75 17                	jne    803528 <alloc_block_BF+0x27c>
  803511:	83 ec 04             	sub    $0x4,%esp
  803514:	68 28 50 80 00       	push   $0x805028
  803519:	68 45 01 00 00       	push   $0x145
  80351e:	68 0d 50 80 00       	push   $0x80500d
  803523:	e8 58 da ff ff       	call   800f80 <_panic>
  803528:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80352e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803531:	89 10                	mov    %edx,(%eax)
  803533:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 0d                	je     803549 <alloc_block_BF+0x29d>
  80353c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803541:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803544:	89 50 04             	mov    %edx,0x4(%eax)
  803547:	eb 08                	jmp    803551 <alloc_block_BF+0x2a5>
  803549:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80354c:	a3 30 60 80 00       	mov    %eax,0x806030
  803551:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803554:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803559:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80355c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803563:	a1 38 60 80 00       	mov    0x806038,%eax
  803568:	40                   	inc    %eax
  803569:	a3 38 60 80 00       	mov    %eax,0x806038
  80356e:	e9 dc 00 00 00       	jmp    80364f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	75 65                	jne    8035e1 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80357c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803580:	75 17                	jne    803599 <alloc_block_BF+0x2ed>
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	68 5c 50 80 00       	push   $0x80505c
  80358a:	68 4a 01 00 00       	push   $0x14a
  80358f:	68 0d 50 80 00       	push   $0x80500d
  803594:	e8 e7 d9 ff ff       	call   800f80 <_panic>
  803599:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80359f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035a2:	89 50 04             	mov    %edx,0x4(%eax)
  8035a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035a8:	8b 40 04             	mov    0x4(%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	74 0c                	je     8035bb <alloc_block_BF+0x30f>
  8035af:	a1 30 60 80 00       	mov    0x806030,%eax
  8035b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035b7:	89 10                	mov    %edx,(%eax)
  8035b9:	eb 08                	jmp    8035c3 <alloc_block_BF+0x317>
  8035bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035be:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8035c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c6:	a3 30 60 80 00       	mov    %eax,0x806030
  8035cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d4:	a1 38 60 80 00       	mov    0x806038,%eax
  8035d9:	40                   	inc    %eax
  8035da:	a3 38 60 80 00       	mov    %eax,0x806038
  8035df:	eb 6e                	jmp    80364f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8035e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035e5:	74 06                	je     8035ed <alloc_block_BF+0x341>
  8035e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035eb:	75 17                	jne    803604 <alloc_block_BF+0x358>
  8035ed:	83 ec 04             	sub    $0x4,%esp
  8035f0:	68 80 50 80 00       	push   $0x805080
  8035f5:	68 4f 01 00 00       	push   $0x14f
  8035fa:	68 0d 50 80 00       	push   $0x80500d
  8035ff:	e8 7c d9 ff ff       	call   800f80 <_panic>
  803604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803607:	8b 10                	mov    (%eax),%edx
  803609:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80360c:	89 10                	mov    %edx,(%eax)
  80360e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	74 0b                	je     803622 <alloc_block_BF+0x376>
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80361f:	89 50 04             	mov    %edx,0x4(%eax)
  803622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803625:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803628:	89 10                	mov    %edx,(%eax)
  80362a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80362d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803630:	89 50 04             	mov    %edx,0x4(%eax)
  803633:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	75 08                	jne    803644 <alloc_block_BF+0x398>
  80363c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80363f:	a3 30 60 80 00       	mov    %eax,0x806030
  803644:	a1 38 60 80 00       	mov    0x806038,%eax
  803649:	40                   	inc    %eax
  80364a:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80364f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803653:	75 17                	jne    80366c <alloc_block_BF+0x3c0>
  803655:	83 ec 04             	sub    $0x4,%esp
  803658:	68 ef 4f 80 00       	push   $0x804fef
  80365d:	68 51 01 00 00       	push   $0x151
  803662:	68 0d 50 80 00       	push   $0x80500d
  803667:	e8 14 d9 ff ff       	call   800f80 <_panic>
  80366c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	85 c0                	test   %eax,%eax
  803673:	74 10                	je     803685 <alloc_block_BF+0x3d9>
  803675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803678:	8b 00                	mov    (%eax),%eax
  80367a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367d:	8b 52 04             	mov    0x4(%edx),%edx
  803680:	89 50 04             	mov    %edx,0x4(%eax)
  803683:	eb 0b                	jmp    803690 <alloc_block_BF+0x3e4>
  803685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803688:	8b 40 04             	mov    0x4(%eax),%eax
  80368b:	a3 30 60 80 00       	mov    %eax,0x806030
  803690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0f                	je     8036a9 <alloc_block_BF+0x3fd>
  80369a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369d:	8b 40 04             	mov    0x4(%eax),%eax
  8036a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a3:	8b 12                	mov    (%edx),%edx
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	eb 0a                	jmp    8036b3 <alloc_block_BF+0x407>
  8036a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8036b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c6:	a1 38 60 80 00       	mov    0x806038,%eax
  8036cb:	48                   	dec    %eax
  8036cc:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	6a 00                	push   $0x0
  8036d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8036d9:	ff 75 cc             	pushl  -0x34(%ebp)
  8036dc:	e8 e0 f6 ff ff       	call   802dc1 <set_block_data>
  8036e1:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8036e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e7:	e9 a3 01 00 00       	jmp    80388f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8036ec:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8036f0:	0f 85 9d 00 00 00    	jne    803793 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	6a 01                	push   $0x1
  8036fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8036fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803701:	e8 bb f6 ff ff       	call   802dc1 <set_block_data>
  803706:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80370d:	75 17                	jne    803726 <alloc_block_BF+0x47a>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 ef 4f 80 00       	push   $0x804fef
  803717:	68 58 01 00 00       	push   $0x158
  80371c:	68 0d 50 80 00       	push   $0x80500d
  803721:	e8 5a d8 ff ff       	call   800f80 <_panic>
  803726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	74 10                	je     80373f <alloc_block_BF+0x493>
  80372f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803737:	8b 52 04             	mov    0x4(%edx),%edx
  80373a:	89 50 04             	mov    %edx,0x4(%eax)
  80373d:	eb 0b                	jmp    80374a <alloc_block_BF+0x49e>
  80373f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803742:	8b 40 04             	mov    0x4(%eax),%eax
  803745:	a3 30 60 80 00       	mov    %eax,0x806030
  80374a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374d:	8b 40 04             	mov    0x4(%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 0f                	je     803763 <alloc_block_BF+0x4b7>
  803754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803757:	8b 40 04             	mov    0x4(%eax),%eax
  80375a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80375d:	8b 12                	mov    (%edx),%edx
  80375f:	89 10                	mov    %edx,(%eax)
  803761:	eb 0a                	jmp    80376d <alloc_block_BF+0x4c1>
  803763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803779:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803780:	a1 38 60 80 00       	mov    0x806038,%eax
  803785:	48                   	dec    %eax
  803786:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378e:	e9 fc 00 00 00       	jmp    80388f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	83 c0 08             	add    $0x8,%eax
  803799:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80379c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8037a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037a9:	01 d0                	add    %edx,%eax
  8037ab:	48                   	dec    %eax
  8037ac:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8037af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8037b7:	f7 75 c4             	divl   -0x3c(%ebp)
  8037ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037bd:	29 d0                	sub    %edx,%eax
  8037bf:	c1 e8 0c             	shr    $0xc,%eax
  8037c2:	83 ec 0c             	sub    $0xc,%esp
  8037c5:	50                   	push   %eax
  8037c6:	e8 0c e8 ff ff       	call   801fd7 <sbrk>
  8037cb:	83 c4 10             	add    $0x10,%esp
  8037ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8037d1:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8037d5:	75 0a                	jne    8037e1 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8037d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dc:	e9 ae 00 00 00       	jmp    80388f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8037e1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8037e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ee:	01 d0                	add    %edx,%eax
  8037f0:	48                   	dec    %eax
  8037f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8037f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8037f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8037fc:	f7 75 b8             	divl   -0x48(%ebp)
  8037ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803802:	29 d0                	sub    %edx,%eax
  803804:	8d 50 fc             	lea    -0x4(%eax),%edx
  803807:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80380a:	01 d0                	add    %edx,%eax
  80380c:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803811:	a1 40 60 80 00       	mov    0x806040,%eax
  803816:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80381c:	83 ec 0c             	sub    $0xc,%esp
  80381f:	68 b4 50 80 00       	push   $0x8050b4
  803824:	e8 14 da ff ff       	call   80123d <cprintf>
  803829:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80382c:	83 ec 08             	sub    $0x8,%esp
  80382f:	ff 75 bc             	pushl  -0x44(%ebp)
  803832:	68 b9 50 80 00       	push   $0x8050b9
  803837:	e8 01 da ff ff       	call   80123d <cprintf>
  80383c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80383f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803846:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803849:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80384c:	01 d0                	add    %edx,%eax
  80384e:	48                   	dec    %eax
  80384f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803852:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803855:	ba 00 00 00 00       	mov    $0x0,%edx
  80385a:	f7 75 b0             	divl   -0x50(%ebp)
  80385d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803860:	29 d0                	sub    %edx,%eax
  803862:	83 ec 04             	sub    $0x4,%esp
  803865:	6a 01                	push   $0x1
  803867:	50                   	push   %eax
  803868:	ff 75 bc             	pushl  -0x44(%ebp)
  80386b:	e8 51 f5 ff ff       	call   802dc1 <set_block_data>
  803870:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803873:	83 ec 0c             	sub    $0xc,%esp
  803876:	ff 75 bc             	pushl  -0x44(%ebp)
  803879:	e8 36 04 00 00       	call   803cb4 <free_block>
  80387e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803881:	83 ec 0c             	sub    $0xc,%esp
  803884:	ff 75 08             	pushl  0x8(%ebp)
  803887:	e8 20 fa ff ff       	call   8032ac <alloc_block_BF>
  80388c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80388f:	c9                   	leave  
  803890:	c3                   	ret    

00803891 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803891:	55                   	push   %ebp
  803892:	89 e5                	mov    %esp,%ebp
  803894:	53                   	push   %ebx
  803895:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80389f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8038a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038aa:	74 1e                	je     8038ca <merging+0x39>
  8038ac:	ff 75 08             	pushl  0x8(%ebp)
  8038af:	e8 bc f1 ff ff       	call   802a70 <get_block_size>
  8038b4:	83 c4 04             	add    $0x4,%esp
  8038b7:	89 c2                	mov    %eax,%edx
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	01 d0                	add    %edx,%eax
  8038be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8038c1:	75 07                	jne    8038ca <merging+0x39>
		prev_is_free = 1;
  8038c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8038ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038ce:	74 1e                	je     8038ee <merging+0x5d>
  8038d0:	ff 75 10             	pushl  0x10(%ebp)
  8038d3:	e8 98 f1 ff ff       	call   802a70 <get_block_size>
  8038d8:	83 c4 04             	add    $0x4,%esp
  8038db:	89 c2                	mov    %eax,%edx
  8038dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8038e0:	01 d0                	add    %edx,%eax
  8038e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038e5:	75 07                	jne    8038ee <merging+0x5d>
		next_is_free = 1;
  8038e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8038ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f2:	0f 84 cc 00 00 00    	je     8039c4 <merging+0x133>
  8038f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038fc:	0f 84 c2 00 00 00    	je     8039c4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803902:	ff 75 08             	pushl  0x8(%ebp)
  803905:	e8 66 f1 ff ff       	call   802a70 <get_block_size>
  80390a:	83 c4 04             	add    $0x4,%esp
  80390d:	89 c3                	mov    %eax,%ebx
  80390f:	ff 75 10             	pushl  0x10(%ebp)
  803912:	e8 59 f1 ff ff       	call   802a70 <get_block_size>
  803917:	83 c4 04             	add    $0x4,%esp
  80391a:	01 c3                	add    %eax,%ebx
  80391c:	ff 75 0c             	pushl  0xc(%ebp)
  80391f:	e8 4c f1 ff ff       	call   802a70 <get_block_size>
  803924:	83 c4 04             	add    $0x4,%esp
  803927:	01 d8                	add    %ebx,%eax
  803929:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80392c:	6a 00                	push   $0x0
  80392e:	ff 75 ec             	pushl  -0x14(%ebp)
  803931:	ff 75 08             	pushl  0x8(%ebp)
  803934:	e8 88 f4 ff ff       	call   802dc1 <set_block_data>
  803939:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80393c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803940:	75 17                	jne    803959 <merging+0xc8>
  803942:	83 ec 04             	sub    $0x4,%esp
  803945:	68 ef 4f 80 00       	push   $0x804fef
  80394a:	68 7d 01 00 00       	push   $0x17d
  80394f:	68 0d 50 80 00       	push   $0x80500d
  803954:	e8 27 d6 ff ff       	call   800f80 <_panic>
  803959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	85 c0                	test   %eax,%eax
  803960:	74 10                	je     803972 <merging+0xe1>
  803962:	8b 45 0c             	mov    0xc(%ebp),%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80396a:	8b 52 04             	mov    0x4(%edx),%edx
  80396d:	89 50 04             	mov    %edx,0x4(%eax)
  803970:	eb 0b                	jmp    80397d <merging+0xec>
  803972:	8b 45 0c             	mov    0xc(%ebp),%eax
  803975:	8b 40 04             	mov    0x4(%eax),%eax
  803978:	a3 30 60 80 00       	mov    %eax,0x806030
  80397d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803980:	8b 40 04             	mov    0x4(%eax),%eax
  803983:	85 c0                	test   %eax,%eax
  803985:	74 0f                	je     803996 <merging+0x105>
  803987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398a:	8b 40 04             	mov    0x4(%eax),%eax
  80398d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803990:	8b 12                	mov    (%edx),%edx
  803992:	89 10                	mov    %edx,(%eax)
  803994:	eb 0a                	jmp    8039a0 <merging+0x10f>
  803996:	8b 45 0c             	mov    0xc(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b3:	a1 38 60 80 00       	mov    0x806038,%eax
  8039b8:	48                   	dec    %eax
  8039b9:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8039be:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8039bf:	e9 ea 02 00 00       	jmp    803cae <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8039c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c8:	74 3b                	je     803a05 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8039ca:	83 ec 0c             	sub    $0xc,%esp
  8039cd:	ff 75 08             	pushl  0x8(%ebp)
  8039d0:	e8 9b f0 ff ff       	call   802a70 <get_block_size>
  8039d5:	83 c4 10             	add    $0x10,%esp
  8039d8:	89 c3                	mov    %eax,%ebx
  8039da:	83 ec 0c             	sub    $0xc,%esp
  8039dd:	ff 75 10             	pushl  0x10(%ebp)
  8039e0:	e8 8b f0 ff ff       	call   802a70 <get_block_size>
  8039e5:	83 c4 10             	add    $0x10,%esp
  8039e8:	01 d8                	add    %ebx,%eax
  8039ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	6a 00                	push   $0x0
  8039f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8039f5:	ff 75 08             	pushl  0x8(%ebp)
  8039f8:	e8 c4 f3 ff ff       	call   802dc1 <set_block_data>
  8039fd:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803a00:	e9 a9 02 00 00       	jmp    803cae <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a09:	0f 84 2d 01 00 00    	je     803b3c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803a0f:	83 ec 0c             	sub    $0xc,%esp
  803a12:	ff 75 10             	pushl  0x10(%ebp)
  803a15:	e8 56 f0 ff ff       	call   802a70 <get_block_size>
  803a1a:	83 c4 10             	add    $0x10,%esp
  803a1d:	89 c3                	mov    %eax,%ebx
  803a1f:	83 ec 0c             	sub    $0xc,%esp
  803a22:	ff 75 0c             	pushl  0xc(%ebp)
  803a25:	e8 46 f0 ff ff       	call   802a70 <get_block_size>
  803a2a:	83 c4 10             	add    $0x10,%esp
  803a2d:	01 d8                	add    %ebx,%eax
  803a2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803a32:	83 ec 04             	sub    $0x4,%esp
  803a35:	6a 00                	push   $0x0
  803a37:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a3a:	ff 75 10             	pushl  0x10(%ebp)
  803a3d:	e8 7f f3 ff ff       	call   802dc1 <set_block_data>
  803a42:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803a45:	8b 45 10             	mov    0x10(%ebp),%eax
  803a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803a4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a4f:	74 06                	je     803a57 <merging+0x1c6>
  803a51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a55:	75 17                	jne    803a6e <merging+0x1dd>
  803a57:	83 ec 04             	sub    $0x4,%esp
  803a5a:	68 c8 50 80 00       	push   $0x8050c8
  803a5f:	68 8d 01 00 00       	push   $0x18d
  803a64:	68 0d 50 80 00       	push   $0x80500d
  803a69:	e8 12 d5 ff ff       	call   800f80 <_panic>
  803a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a71:	8b 50 04             	mov    0x4(%eax),%edx
  803a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a77:	89 50 04             	mov    %edx,0x4(%eax)
  803a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a80:	89 10                	mov    %edx,(%eax)
  803a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a85:	8b 40 04             	mov    0x4(%eax),%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	74 0d                	je     803a99 <merging+0x208>
  803a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8f:	8b 40 04             	mov    0x4(%eax),%eax
  803a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a95:	89 10                	mov    %edx,(%eax)
  803a97:	eb 08                	jmp    803aa1 <merging+0x210>
  803a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a9c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aa7:	89 50 04             	mov    %edx,0x4(%eax)
  803aaa:	a1 38 60 80 00       	mov    0x806038,%eax
  803aaf:	40                   	inc    %eax
  803ab0:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803ab5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ab9:	75 17                	jne    803ad2 <merging+0x241>
  803abb:	83 ec 04             	sub    $0x4,%esp
  803abe:	68 ef 4f 80 00       	push   $0x804fef
  803ac3:	68 8e 01 00 00       	push   $0x18e
  803ac8:	68 0d 50 80 00       	push   $0x80500d
  803acd:	e8 ae d4 ff ff       	call   800f80 <_panic>
  803ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad5:	8b 00                	mov    (%eax),%eax
  803ad7:	85 c0                	test   %eax,%eax
  803ad9:	74 10                	je     803aeb <merging+0x25a>
  803adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ae3:	8b 52 04             	mov    0x4(%edx),%edx
  803ae6:	89 50 04             	mov    %edx,0x4(%eax)
  803ae9:	eb 0b                	jmp    803af6 <merging+0x265>
  803aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aee:	8b 40 04             	mov    0x4(%eax),%eax
  803af1:	a3 30 60 80 00       	mov    %eax,0x806030
  803af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af9:	8b 40 04             	mov    0x4(%eax),%eax
  803afc:	85 c0                	test   %eax,%eax
  803afe:	74 0f                	je     803b0f <merging+0x27e>
  803b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b03:	8b 40 04             	mov    0x4(%eax),%eax
  803b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b09:	8b 12                	mov    (%edx),%edx
  803b0b:	89 10                	mov    %edx,(%eax)
  803b0d:	eb 0a                	jmp    803b19 <merging+0x288>
  803b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2c:	a1 38 60 80 00       	mov    0x806038,%eax
  803b31:	48                   	dec    %eax
  803b32:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b37:	e9 72 01 00 00       	jmp    803cae <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  803b3f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803b42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b46:	74 79                	je     803bc1 <merging+0x330>
  803b48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b4c:	74 73                	je     803bc1 <merging+0x330>
  803b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b52:	74 06                	je     803b5a <merging+0x2c9>
  803b54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b58:	75 17                	jne    803b71 <merging+0x2e0>
  803b5a:	83 ec 04             	sub    $0x4,%esp
  803b5d:	68 80 50 80 00       	push   $0x805080
  803b62:	68 94 01 00 00       	push   $0x194
  803b67:	68 0d 50 80 00       	push   $0x80500d
  803b6c:	e8 0f d4 ff ff       	call   800f80 <_panic>
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	8b 10                	mov    (%eax),%edx
  803b76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b79:	89 10                	mov    %edx,(%eax)
  803b7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	85 c0                	test   %eax,%eax
  803b82:	74 0b                	je     803b8f <merging+0x2fe>
  803b84:	8b 45 08             	mov    0x8(%ebp),%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b8c:	89 50 04             	mov    %edx,0x4(%eax)
  803b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b95:	89 10                	mov    %edx,(%eax)
  803b97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba3:	8b 00                	mov    (%eax),%eax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	75 08                	jne    803bb1 <merging+0x320>
  803ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bac:	a3 30 60 80 00       	mov    %eax,0x806030
  803bb1:	a1 38 60 80 00       	mov    0x806038,%eax
  803bb6:	40                   	inc    %eax
  803bb7:	a3 38 60 80 00       	mov    %eax,0x806038
  803bbc:	e9 ce 00 00 00       	jmp    803c8f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803bc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bc5:	74 65                	je     803c2c <merging+0x39b>
  803bc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803bcb:	75 17                	jne    803be4 <merging+0x353>
  803bcd:	83 ec 04             	sub    $0x4,%esp
  803bd0:	68 5c 50 80 00       	push   $0x80505c
  803bd5:	68 95 01 00 00       	push   $0x195
  803bda:	68 0d 50 80 00       	push   $0x80500d
  803bdf:	e8 9c d3 ff ff       	call   800f80 <_panic>
  803be4:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803bea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bed:	89 50 04             	mov    %edx,0x4(%eax)
  803bf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bf3:	8b 40 04             	mov    0x4(%eax),%eax
  803bf6:	85 c0                	test   %eax,%eax
  803bf8:	74 0c                	je     803c06 <merging+0x375>
  803bfa:	a1 30 60 80 00       	mov    0x806030,%eax
  803bff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c02:	89 10                	mov    %edx,(%eax)
  803c04:	eb 08                	jmp    803c0e <merging+0x37d>
  803c06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c09:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c11:	a3 30 60 80 00       	mov    %eax,0x806030
  803c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1f:	a1 38 60 80 00       	mov    0x806038,%eax
  803c24:	40                   	inc    %eax
  803c25:	a3 38 60 80 00       	mov    %eax,0x806038
  803c2a:	eb 63                	jmp    803c8f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803c2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c30:	75 17                	jne    803c49 <merging+0x3b8>
  803c32:	83 ec 04             	sub    $0x4,%esp
  803c35:	68 28 50 80 00       	push   $0x805028
  803c3a:	68 98 01 00 00       	push   $0x198
  803c3f:	68 0d 50 80 00       	push   $0x80500d
  803c44:	e8 37 d3 ff ff       	call   800f80 <_panic>
  803c49:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c52:	89 10                	mov    %edx,(%eax)
  803c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	85 c0                	test   %eax,%eax
  803c5b:	74 0d                	je     803c6a <merging+0x3d9>
  803c5d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803c62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c65:	89 50 04             	mov    %edx,0x4(%eax)
  803c68:	eb 08                	jmp    803c72 <merging+0x3e1>
  803c6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c6d:	a3 30 60 80 00       	mov    %eax,0x806030
  803c72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c75:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c84:	a1 38 60 80 00       	mov    0x806038,%eax
  803c89:	40                   	inc    %eax
  803c8a:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803c8f:	83 ec 0c             	sub    $0xc,%esp
  803c92:	ff 75 10             	pushl  0x10(%ebp)
  803c95:	e8 d6 ed ff ff       	call   802a70 <get_block_size>
  803c9a:	83 c4 10             	add    $0x10,%esp
  803c9d:	83 ec 04             	sub    $0x4,%esp
  803ca0:	6a 00                	push   $0x0
  803ca2:	50                   	push   %eax
  803ca3:	ff 75 10             	pushl  0x10(%ebp)
  803ca6:	e8 16 f1 ff ff       	call   802dc1 <set_block_data>
  803cab:	83 c4 10             	add    $0x10,%esp
	}
}
  803cae:	90                   	nop
  803caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803cb2:	c9                   	leave  
  803cb3:	c3                   	ret    

00803cb4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803cb4:	55                   	push   %ebp
  803cb5:	89 e5                	mov    %esp,%ebp
  803cb7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803cba:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803cc2:	a1 30 60 80 00       	mov    0x806030,%eax
  803cc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cca:	73 1b                	jae    803ce7 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803ccc:	a1 30 60 80 00       	mov    0x806030,%eax
  803cd1:	83 ec 04             	sub    $0x4,%esp
  803cd4:	ff 75 08             	pushl  0x8(%ebp)
  803cd7:	6a 00                	push   $0x0
  803cd9:	50                   	push   %eax
  803cda:	e8 b2 fb ff ff       	call   803891 <merging>
  803cdf:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ce2:	e9 8b 00 00 00       	jmp    803d72 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803ce7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cef:	76 18                	jbe    803d09 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803cf1:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cf6:	83 ec 04             	sub    $0x4,%esp
  803cf9:	ff 75 08             	pushl  0x8(%ebp)
  803cfc:	50                   	push   %eax
  803cfd:	6a 00                	push   $0x0
  803cff:	e8 8d fb ff ff       	call   803891 <merging>
  803d04:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d07:	eb 69                	jmp    803d72 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803d09:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d11:	eb 39                	jmp    803d4c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d16:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d19:	73 29                	jae    803d44 <free_block+0x90>
  803d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1e:	8b 00                	mov    (%eax),%eax
  803d20:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d23:	76 1f                	jbe    803d44 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803d2d:	83 ec 04             	sub    $0x4,%esp
  803d30:	ff 75 08             	pushl  0x8(%ebp)
  803d33:	ff 75 f0             	pushl  -0x10(%ebp)
  803d36:	ff 75 f4             	pushl  -0xc(%ebp)
  803d39:	e8 53 fb ff ff       	call   803891 <merging>
  803d3e:	83 c4 10             	add    $0x10,%esp
			break;
  803d41:	90                   	nop
		}
	}
}
  803d42:	eb 2e                	jmp    803d72 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803d44:	a1 34 60 80 00       	mov    0x806034,%eax
  803d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d50:	74 07                	je     803d59 <free_block+0xa5>
  803d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	eb 05                	jmp    803d5e <free_block+0xaa>
  803d59:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5e:	a3 34 60 80 00       	mov    %eax,0x806034
  803d63:	a1 34 60 80 00       	mov    0x806034,%eax
  803d68:	85 c0                	test   %eax,%eax
  803d6a:	75 a7                	jne    803d13 <free_block+0x5f>
  803d6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d70:	75 a1                	jne    803d13 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d72:	90                   	nop
  803d73:	c9                   	leave  
  803d74:	c3                   	ret    

00803d75 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803d75:	55                   	push   %ebp
  803d76:	89 e5                	mov    %esp,%ebp
  803d78:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803d7b:	ff 75 08             	pushl  0x8(%ebp)
  803d7e:	e8 ed ec ff ff       	call   802a70 <get_block_size>
  803d83:	83 c4 04             	add    $0x4,%esp
  803d86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803d89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803d90:	eb 17                	jmp    803da9 <copy_data+0x34>
  803d92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d98:	01 c2                	add    %eax,%edx
  803d9a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803da0:	01 c8                	add    %ecx,%eax
  803da2:	8a 00                	mov    (%eax),%al
  803da4:	88 02                	mov    %al,(%edx)
  803da6:	ff 45 fc             	incl   -0x4(%ebp)
  803da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803dac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803daf:	72 e1                	jb     803d92 <copy_data+0x1d>
}
  803db1:	90                   	nop
  803db2:	c9                   	leave  
  803db3:	c3                   	ret    

00803db4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803db4:	55                   	push   %ebp
  803db5:	89 e5                	mov    %esp,%ebp
  803db7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dbe:	75 23                	jne    803de3 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803dc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803dc4:	74 13                	je     803dd9 <realloc_block_FF+0x25>
  803dc6:	83 ec 0c             	sub    $0xc,%esp
  803dc9:	ff 75 0c             	pushl  0xc(%ebp)
  803dcc:	e8 1f f0 ff ff       	call   802df0 <alloc_block_FF>
  803dd1:	83 c4 10             	add    $0x10,%esp
  803dd4:	e9 f4 06 00 00       	jmp    8044cd <realloc_block_FF+0x719>
		return NULL;
  803dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dde:	e9 ea 06 00 00       	jmp    8044cd <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803de7:	75 18                	jne    803e01 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803de9:	83 ec 0c             	sub    $0xc,%esp
  803dec:	ff 75 08             	pushl  0x8(%ebp)
  803def:	e8 c0 fe ff ff       	call   803cb4 <free_block>
  803df4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803df7:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfc:	e9 cc 06 00 00       	jmp    8044cd <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803e01:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803e05:	77 07                	ja     803e0e <realloc_block_FF+0x5a>
  803e07:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e11:	83 e0 01             	and    $0x1,%eax
  803e14:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e1a:	83 c0 08             	add    $0x8,%eax
  803e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803e20:	83 ec 0c             	sub    $0xc,%esp
  803e23:	ff 75 08             	pushl  0x8(%ebp)
  803e26:	e8 45 ec ff ff       	call   802a70 <get_block_size>
  803e2b:	83 c4 10             	add    $0x10,%esp
  803e2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e34:	83 e8 08             	sub    $0x8,%eax
  803e37:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3d:	83 e8 04             	sub    $0x4,%eax
  803e40:	8b 00                	mov    (%eax),%eax
  803e42:	83 e0 fe             	and    $0xfffffffe,%eax
  803e45:	89 c2                	mov    %eax,%edx
  803e47:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4a:	01 d0                	add    %edx,%eax
  803e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803e4f:	83 ec 0c             	sub    $0xc,%esp
  803e52:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e55:	e8 16 ec ff ff       	call   802a70 <get_block_size>
  803e5a:	83 c4 10             	add    $0x10,%esp
  803e5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e63:	83 e8 08             	sub    $0x8,%eax
  803e66:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e6f:	75 08                	jne    803e79 <realloc_block_FF+0xc5>
	{
		 return va;
  803e71:	8b 45 08             	mov    0x8(%ebp),%eax
  803e74:	e9 54 06 00 00       	jmp    8044cd <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e7c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e7f:	0f 83 e5 03 00 00    	jae    80426a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e88:	2b 45 0c             	sub    0xc(%ebp),%eax
  803e8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803e8e:	83 ec 0c             	sub    $0xc,%esp
  803e91:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e94:	e8 f0 eb ff ff       	call   802a89 <is_free_block>
  803e99:	83 c4 10             	add    $0x10,%esp
  803e9c:	84 c0                	test   %al,%al
  803e9e:	0f 84 3b 01 00 00    	je     803fdf <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803ea4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ea7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803eaa:	01 d0                	add    %edx,%eax
  803eac:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803eaf:	83 ec 04             	sub    $0x4,%esp
  803eb2:	6a 01                	push   $0x1
  803eb4:	ff 75 f0             	pushl  -0x10(%ebp)
  803eb7:	ff 75 08             	pushl  0x8(%ebp)
  803eba:	e8 02 ef ff ff       	call   802dc1 <set_block_data>
  803ebf:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec5:	83 e8 04             	sub    $0x4,%eax
  803ec8:	8b 00                	mov    (%eax),%eax
  803eca:	83 e0 fe             	and    $0xfffffffe,%eax
  803ecd:	89 c2                	mov    %eax,%edx
  803ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed2:	01 d0                	add    %edx,%eax
  803ed4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803ed7:	83 ec 04             	sub    $0x4,%esp
  803eda:	6a 00                	push   $0x0
  803edc:	ff 75 cc             	pushl  -0x34(%ebp)
  803edf:	ff 75 c8             	pushl  -0x38(%ebp)
  803ee2:	e8 da ee ff ff       	call   802dc1 <set_block_data>
  803ee7:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803eea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eee:	74 06                	je     803ef6 <realloc_block_FF+0x142>
  803ef0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ef4:	75 17                	jne    803f0d <realloc_block_FF+0x159>
  803ef6:	83 ec 04             	sub    $0x4,%esp
  803ef9:	68 80 50 80 00       	push   $0x805080
  803efe:	68 f6 01 00 00       	push   $0x1f6
  803f03:	68 0d 50 80 00       	push   $0x80500d
  803f08:	e8 73 d0 ff ff       	call   800f80 <_panic>
  803f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f10:	8b 10                	mov    (%eax),%edx
  803f12:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f15:	89 10                	mov    %edx,(%eax)
  803f17:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f1a:	8b 00                	mov    (%eax),%eax
  803f1c:	85 c0                	test   %eax,%eax
  803f1e:	74 0b                	je     803f2b <realloc_block_FF+0x177>
  803f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f23:	8b 00                	mov    (%eax),%eax
  803f25:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f28:	89 50 04             	mov    %edx,0x4(%eax)
  803f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f31:	89 10                	mov    %edx,(%eax)
  803f33:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f39:	89 50 04             	mov    %edx,0x4(%eax)
  803f3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f3f:	8b 00                	mov    (%eax),%eax
  803f41:	85 c0                	test   %eax,%eax
  803f43:	75 08                	jne    803f4d <realloc_block_FF+0x199>
  803f45:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f48:	a3 30 60 80 00       	mov    %eax,0x806030
  803f4d:	a1 38 60 80 00       	mov    0x806038,%eax
  803f52:	40                   	inc    %eax
  803f53:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f5c:	75 17                	jne    803f75 <realloc_block_FF+0x1c1>
  803f5e:	83 ec 04             	sub    $0x4,%esp
  803f61:	68 ef 4f 80 00       	push   $0x804fef
  803f66:	68 f7 01 00 00       	push   $0x1f7
  803f6b:	68 0d 50 80 00       	push   $0x80500d
  803f70:	e8 0b d0 ff ff       	call   800f80 <_panic>
  803f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f78:	8b 00                	mov    (%eax),%eax
  803f7a:	85 c0                	test   %eax,%eax
  803f7c:	74 10                	je     803f8e <realloc_block_FF+0x1da>
  803f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f81:	8b 00                	mov    (%eax),%eax
  803f83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f86:	8b 52 04             	mov    0x4(%edx),%edx
  803f89:	89 50 04             	mov    %edx,0x4(%eax)
  803f8c:	eb 0b                	jmp    803f99 <realloc_block_FF+0x1e5>
  803f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f91:	8b 40 04             	mov    0x4(%eax),%eax
  803f94:	a3 30 60 80 00       	mov    %eax,0x806030
  803f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9c:	8b 40 04             	mov    0x4(%eax),%eax
  803f9f:	85 c0                	test   %eax,%eax
  803fa1:	74 0f                	je     803fb2 <realloc_block_FF+0x1fe>
  803fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa6:	8b 40 04             	mov    0x4(%eax),%eax
  803fa9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fac:	8b 12                	mov    (%edx),%edx
  803fae:	89 10                	mov    %edx,(%eax)
  803fb0:	eb 0a                	jmp    803fbc <realloc_block_FF+0x208>
  803fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb5:	8b 00                	mov    (%eax),%eax
  803fb7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fcf:	a1 38 60 80 00       	mov    0x806038,%eax
  803fd4:	48                   	dec    %eax
  803fd5:	a3 38 60 80 00       	mov    %eax,0x806038
  803fda:	e9 83 02 00 00       	jmp    804262 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803fdf:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803fe3:	0f 86 69 02 00 00    	jbe    804252 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803fe9:	83 ec 04             	sub    $0x4,%esp
  803fec:	6a 01                	push   $0x1
  803fee:	ff 75 f0             	pushl  -0x10(%ebp)
  803ff1:	ff 75 08             	pushl  0x8(%ebp)
  803ff4:	e8 c8 ed ff ff       	call   802dc1 <set_block_data>
  803ff9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fff:	83 e8 04             	sub    $0x4,%eax
  804002:	8b 00                	mov    (%eax),%eax
  804004:	83 e0 fe             	and    $0xfffffffe,%eax
  804007:	89 c2                	mov    %eax,%edx
  804009:	8b 45 08             	mov    0x8(%ebp),%eax
  80400c:	01 d0                	add    %edx,%eax
  80400e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804011:	a1 38 60 80 00       	mov    0x806038,%eax
  804016:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804019:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80401d:	75 68                	jne    804087 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80401f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804023:	75 17                	jne    80403c <realloc_block_FF+0x288>
  804025:	83 ec 04             	sub    $0x4,%esp
  804028:	68 28 50 80 00       	push   $0x805028
  80402d:	68 06 02 00 00       	push   $0x206
  804032:	68 0d 50 80 00       	push   $0x80500d
  804037:	e8 44 cf ff ff       	call   800f80 <_panic>
  80403c:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804042:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804045:	89 10                	mov    %edx,(%eax)
  804047:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80404a:	8b 00                	mov    (%eax),%eax
  80404c:	85 c0                	test   %eax,%eax
  80404e:	74 0d                	je     80405d <realloc_block_FF+0x2a9>
  804050:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804055:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804058:	89 50 04             	mov    %edx,0x4(%eax)
  80405b:	eb 08                	jmp    804065 <realloc_block_FF+0x2b1>
  80405d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804060:	a3 30 60 80 00       	mov    %eax,0x806030
  804065:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804068:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80406d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804077:	a1 38 60 80 00       	mov    0x806038,%eax
  80407c:	40                   	inc    %eax
  80407d:	a3 38 60 80 00       	mov    %eax,0x806038
  804082:	e9 b0 01 00 00       	jmp    804237 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804087:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80408c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80408f:	76 68                	jbe    8040f9 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804091:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804095:	75 17                	jne    8040ae <realloc_block_FF+0x2fa>
  804097:	83 ec 04             	sub    $0x4,%esp
  80409a:	68 28 50 80 00       	push   $0x805028
  80409f:	68 0b 02 00 00       	push   $0x20b
  8040a4:	68 0d 50 80 00       	push   $0x80500d
  8040a9:	e8 d2 ce ff ff       	call   800f80 <_panic>
  8040ae:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8040b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040b7:	89 10                	mov    %edx,(%eax)
  8040b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040bc:	8b 00                	mov    (%eax),%eax
  8040be:	85 c0                	test   %eax,%eax
  8040c0:	74 0d                	je     8040cf <realloc_block_FF+0x31b>
  8040c2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8040c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8040ca:	89 50 04             	mov    %edx,0x4(%eax)
  8040cd:	eb 08                	jmp    8040d7 <realloc_block_FF+0x323>
  8040cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040d2:	a3 30 60 80 00       	mov    %eax,0x806030
  8040d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040da:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e9:	a1 38 60 80 00       	mov    0x806038,%eax
  8040ee:	40                   	inc    %eax
  8040ef:	a3 38 60 80 00       	mov    %eax,0x806038
  8040f4:	e9 3e 01 00 00       	jmp    804237 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8040f9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8040fe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804101:	73 68                	jae    80416b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804103:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804107:	75 17                	jne    804120 <realloc_block_FF+0x36c>
  804109:	83 ec 04             	sub    $0x4,%esp
  80410c:	68 5c 50 80 00       	push   $0x80505c
  804111:	68 10 02 00 00       	push   $0x210
  804116:	68 0d 50 80 00       	push   $0x80500d
  80411b:	e8 60 ce ff ff       	call   800f80 <_panic>
  804120:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804129:	89 50 04             	mov    %edx,0x4(%eax)
  80412c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80412f:	8b 40 04             	mov    0x4(%eax),%eax
  804132:	85 c0                	test   %eax,%eax
  804134:	74 0c                	je     804142 <realloc_block_FF+0x38e>
  804136:	a1 30 60 80 00       	mov    0x806030,%eax
  80413b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80413e:	89 10                	mov    %edx,(%eax)
  804140:	eb 08                	jmp    80414a <realloc_block_FF+0x396>
  804142:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804145:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80414a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80414d:	a3 30 60 80 00       	mov    %eax,0x806030
  804152:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80415b:	a1 38 60 80 00       	mov    0x806038,%eax
  804160:	40                   	inc    %eax
  804161:	a3 38 60 80 00       	mov    %eax,0x806038
  804166:	e9 cc 00 00 00       	jmp    804237 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80416b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804172:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80417a:	e9 8a 00 00 00       	jmp    804209 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804182:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804185:	73 7a                	jae    804201 <realloc_block_FF+0x44d>
  804187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80418a:	8b 00                	mov    (%eax),%eax
  80418c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80418f:	73 70                	jae    804201 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804195:	74 06                	je     80419d <realloc_block_FF+0x3e9>
  804197:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80419b:	75 17                	jne    8041b4 <realloc_block_FF+0x400>
  80419d:	83 ec 04             	sub    $0x4,%esp
  8041a0:	68 80 50 80 00       	push   $0x805080
  8041a5:	68 1a 02 00 00       	push   $0x21a
  8041aa:	68 0d 50 80 00       	push   $0x80500d
  8041af:	e8 cc cd ff ff       	call   800f80 <_panic>
  8041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b7:	8b 10                	mov    (%eax),%edx
  8041b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041bc:	89 10                	mov    %edx,(%eax)
  8041be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c1:	8b 00                	mov    (%eax),%eax
  8041c3:	85 c0                	test   %eax,%eax
  8041c5:	74 0b                	je     8041d2 <realloc_block_FF+0x41e>
  8041c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ca:	8b 00                	mov    (%eax),%eax
  8041cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041cf:	89 50 04             	mov    %edx,0x4(%eax)
  8041d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041d8:	89 10                	mov    %edx,(%eax)
  8041da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041e0:	89 50 04             	mov    %edx,0x4(%eax)
  8041e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e6:	8b 00                	mov    (%eax),%eax
  8041e8:	85 c0                	test   %eax,%eax
  8041ea:	75 08                	jne    8041f4 <realloc_block_FF+0x440>
  8041ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041ef:	a3 30 60 80 00       	mov    %eax,0x806030
  8041f4:	a1 38 60 80 00       	mov    0x806038,%eax
  8041f9:	40                   	inc    %eax
  8041fa:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  8041ff:	eb 36                	jmp    804237 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804201:	a1 34 60 80 00       	mov    0x806034,%eax
  804206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80420d:	74 07                	je     804216 <realloc_block_FF+0x462>
  80420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804212:	8b 00                	mov    (%eax),%eax
  804214:	eb 05                	jmp    80421b <realloc_block_FF+0x467>
  804216:	b8 00 00 00 00       	mov    $0x0,%eax
  80421b:	a3 34 60 80 00       	mov    %eax,0x806034
  804220:	a1 34 60 80 00       	mov    0x806034,%eax
  804225:	85 c0                	test   %eax,%eax
  804227:	0f 85 52 ff ff ff    	jne    80417f <realloc_block_FF+0x3cb>
  80422d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804231:	0f 85 48 ff ff ff    	jne    80417f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804237:	83 ec 04             	sub    $0x4,%esp
  80423a:	6a 00                	push   $0x0
  80423c:	ff 75 d8             	pushl  -0x28(%ebp)
  80423f:	ff 75 d4             	pushl  -0x2c(%ebp)
  804242:	e8 7a eb ff ff       	call   802dc1 <set_block_data>
  804247:	83 c4 10             	add    $0x10,%esp
				return va;
  80424a:	8b 45 08             	mov    0x8(%ebp),%eax
  80424d:	e9 7b 02 00 00       	jmp    8044cd <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804252:	83 ec 0c             	sub    $0xc,%esp
  804255:	68 fd 50 80 00       	push   $0x8050fd
  80425a:	e8 de cf ff ff       	call   80123d <cprintf>
  80425f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804262:	8b 45 08             	mov    0x8(%ebp),%eax
  804265:	e9 63 02 00 00       	jmp    8044cd <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80426a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80426d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804270:	0f 86 4d 02 00 00    	jbe    8044c3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804276:	83 ec 0c             	sub    $0xc,%esp
  804279:	ff 75 e4             	pushl  -0x1c(%ebp)
  80427c:	e8 08 e8 ff ff       	call   802a89 <is_free_block>
  804281:	83 c4 10             	add    $0x10,%esp
  804284:	84 c0                	test   %al,%al
  804286:	0f 84 37 02 00 00    	je     8044c3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80428c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80428f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804292:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804295:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804298:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80429b:	76 38                	jbe    8042d5 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80429d:	83 ec 0c             	sub    $0xc,%esp
  8042a0:	ff 75 08             	pushl  0x8(%ebp)
  8042a3:	e8 0c fa ff ff       	call   803cb4 <free_block>
  8042a8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8042ab:	83 ec 0c             	sub    $0xc,%esp
  8042ae:	ff 75 0c             	pushl  0xc(%ebp)
  8042b1:	e8 3a eb ff ff       	call   802df0 <alloc_block_FF>
  8042b6:	83 c4 10             	add    $0x10,%esp
  8042b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8042bc:	83 ec 08             	sub    $0x8,%esp
  8042bf:	ff 75 c0             	pushl  -0x40(%ebp)
  8042c2:	ff 75 08             	pushl  0x8(%ebp)
  8042c5:	e8 ab fa ff ff       	call   803d75 <copy_data>
  8042ca:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8042cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8042d0:	e9 f8 01 00 00       	jmp    8044cd <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8042d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042d8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8042db:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8042de:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8042e2:	0f 87 a0 00 00 00    	ja     804388 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8042e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042ec:	75 17                	jne    804305 <realloc_block_FF+0x551>
  8042ee:	83 ec 04             	sub    $0x4,%esp
  8042f1:	68 ef 4f 80 00       	push   $0x804fef
  8042f6:	68 38 02 00 00       	push   $0x238
  8042fb:	68 0d 50 80 00       	push   $0x80500d
  804300:	e8 7b cc ff ff       	call   800f80 <_panic>
  804305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804308:	8b 00                	mov    (%eax),%eax
  80430a:	85 c0                	test   %eax,%eax
  80430c:	74 10                	je     80431e <realloc_block_FF+0x56a>
  80430e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804311:	8b 00                	mov    (%eax),%eax
  804313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804316:	8b 52 04             	mov    0x4(%edx),%edx
  804319:	89 50 04             	mov    %edx,0x4(%eax)
  80431c:	eb 0b                	jmp    804329 <realloc_block_FF+0x575>
  80431e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804321:	8b 40 04             	mov    0x4(%eax),%eax
  804324:	a3 30 60 80 00       	mov    %eax,0x806030
  804329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432c:	8b 40 04             	mov    0x4(%eax),%eax
  80432f:	85 c0                	test   %eax,%eax
  804331:	74 0f                	je     804342 <realloc_block_FF+0x58e>
  804333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804336:	8b 40 04             	mov    0x4(%eax),%eax
  804339:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80433c:	8b 12                	mov    (%edx),%edx
  80433e:	89 10                	mov    %edx,(%eax)
  804340:	eb 0a                	jmp    80434c <realloc_block_FF+0x598>
  804342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804345:	8b 00                	mov    (%eax),%eax
  804347:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80434c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80434f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80435f:	a1 38 60 80 00       	mov    0x806038,%eax
  804364:	48                   	dec    %eax
  804365:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80436a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80436d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804370:	01 d0                	add    %edx,%eax
  804372:	83 ec 04             	sub    $0x4,%esp
  804375:	6a 01                	push   $0x1
  804377:	50                   	push   %eax
  804378:	ff 75 08             	pushl  0x8(%ebp)
  80437b:	e8 41 ea ff ff       	call   802dc1 <set_block_data>
  804380:	83 c4 10             	add    $0x10,%esp
  804383:	e9 36 01 00 00       	jmp    8044be <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804388:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80438b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80438e:	01 d0                	add    %edx,%eax
  804390:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804393:	83 ec 04             	sub    $0x4,%esp
  804396:	6a 01                	push   $0x1
  804398:	ff 75 f0             	pushl  -0x10(%ebp)
  80439b:	ff 75 08             	pushl  0x8(%ebp)
  80439e:	e8 1e ea ff ff       	call   802dc1 <set_block_data>
  8043a3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8043a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a9:	83 e8 04             	sub    $0x4,%eax
  8043ac:	8b 00                	mov    (%eax),%eax
  8043ae:	83 e0 fe             	and    $0xfffffffe,%eax
  8043b1:	89 c2                	mov    %eax,%edx
  8043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b6:	01 d0                	add    %edx,%eax
  8043b8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8043bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8043bf:	74 06                	je     8043c7 <realloc_block_FF+0x613>
  8043c1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8043c5:	75 17                	jne    8043de <realloc_block_FF+0x62a>
  8043c7:	83 ec 04             	sub    $0x4,%esp
  8043ca:	68 80 50 80 00       	push   $0x805080
  8043cf:	68 44 02 00 00       	push   $0x244
  8043d4:	68 0d 50 80 00       	push   $0x80500d
  8043d9:	e8 a2 cb ff ff       	call   800f80 <_panic>
  8043de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e1:	8b 10                	mov    (%eax),%edx
  8043e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8043e6:	89 10                	mov    %edx,(%eax)
  8043e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8043eb:	8b 00                	mov    (%eax),%eax
  8043ed:	85 c0                	test   %eax,%eax
  8043ef:	74 0b                	je     8043fc <realloc_block_FF+0x648>
  8043f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f4:	8b 00                	mov    (%eax),%eax
  8043f6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8043f9:	89 50 04             	mov    %edx,0x4(%eax)
  8043fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ff:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804402:	89 10                	mov    %edx,(%eax)
  804404:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804407:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80440a:	89 50 04             	mov    %edx,0x4(%eax)
  80440d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804410:	8b 00                	mov    (%eax),%eax
  804412:	85 c0                	test   %eax,%eax
  804414:	75 08                	jne    80441e <realloc_block_FF+0x66a>
  804416:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804419:	a3 30 60 80 00       	mov    %eax,0x806030
  80441e:	a1 38 60 80 00       	mov    0x806038,%eax
  804423:	40                   	inc    %eax
  804424:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804429:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80442d:	75 17                	jne    804446 <realloc_block_FF+0x692>
  80442f:	83 ec 04             	sub    $0x4,%esp
  804432:	68 ef 4f 80 00       	push   $0x804fef
  804437:	68 45 02 00 00       	push   $0x245
  80443c:	68 0d 50 80 00       	push   $0x80500d
  804441:	e8 3a cb ff ff       	call   800f80 <_panic>
  804446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804449:	8b 00                	mov    (%eax),%eax
  80444b:	85 c0                	test   %eax,%eax
  80444d:	74 10                	je     80445f <realloc_block_FF+0x6ab>
  80444f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804452:	8b 00                	mov    (%eax),%eax
  804454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804457:	8b 52 04             	mov    0x4(%edx),%edx
  80445a:	89 50 04             	mov    %edx,0x4(%eax)
  80445d:	eb 0b                	jmp    80446a <realloc_block_FF+0x6b6>
  80445f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804462:	8b 40 04             	mov    0x4(%eax),%eax
  804465:	a3 30 60 80 00       	mov    %eax,0x806030
  80446a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80446d:	8b 40 04             	mov    0x4(%eax),%eax
  804470:	85 c0                	test   %eax,%eax
  804472:	74 0f                	je     804483 <realloc_block_FF+0x6cf>
  804474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804477:	8b 40 04             	mov    0x4(%eax),%eax
  80447a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80447d:	8b 12                	mov    (%edx),%edx
  80447f:	89 10                	mov    %edx,(%eax)
  804481:	eb 0a                	jmp    80448d <realloc_block_FF+0x6d9>
  804483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804486:	8b 00                	mov    (%eax),%eax
  804488:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80448d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044a0:	a1 38 60 80 00       	mov    0x806038,%eax
  8044a5:	48                   	dec    %eax
  8044a6:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  8044ab:	83 ec 04             	sub    $0x4,%esp
  8044ae:	6a 00                	push   $0x0
  8044b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8044b3:	ff 75 b8             	pushl  -0x48(%ebp)
  8044b6:	e8 06 e9 ff ff       	call   802dc1 <set_block_data>
  8044bb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8044be:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c1:	eb 0a                	jmp    8044cd <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8044c3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8044ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8044cd:	c9                   	leave  
  8044ce:	c3                   	ret    

008044cf <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8044cf:	55                   	push   %ebp
  8044d0:	89 e5                	mov    %esp,%ebp
  8044d2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8044d5:	83 ec 04             	sub    $0x4,%esp
  8044d8:	68 04 51 80 00       	push   $0x805104
  8044dd:	68 58 02 00 00       	push   $0x258
  8044e2:	68 0d 50 80 00       	push   $0x80500d
  8044e7:	e8 94 ca ff ff       	call   800f80 <_panic>

008044ec <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8044ec:	55                   	push   %ebp
  8044ed:	89 e5                	mov    %esp,%ebp
  8044ef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8044f2:	83 ec 04             	sub    $0x4,%esp
  8044f5:	68 2c 51 80 00       	push   $0x80512c
  8044fa:	68 61 02 00 00       	push   $0x261
  8044ff:	68 0d 50 80 00       	push   $0x80500d
  804504:	e8 77 ca ff ff       	call   800f80 <_panic>
  804509:	66 90                	xchg   %ax,%ax
  80450b:	90                   	nop

0080450c <__udivdi3>:
  80450c:	55                   	push   %ebp
  80450d:	57                   	push   %edi
  80450e:	56                   	push   %esi
  80450f:	53                   	push   %ebx
  804510:	83 ec 1c             	sub    $0x1c,%esp
  804513:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804517:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80451b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80451f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804523:	89 ca                	mov    %ecx,%edx
  804525:	89 f8                	mov    %edi,%eax
  804527:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80452b:	85 f6                	test   %esi,%esi
  80452d:	75 2d                	jne    80455c <__udivdi3+0x50>
  80452f:	39 cf                	cmp    %ecx,%edi
  804531:	77 65                	ja     804598 <__udivdi3+0x8c>
  804533:	89 fd                	mov    %edi,%ebp
  804535:	85 ff                	test   %edi,%edi
  804537:	75 0b                	jne    804544 <__udivdi3+0x38>
  804539:	b8 01 00 00 00       	mov    $0x1,%eax
  80453e:	31 d2                	xor    %edx,%edx
  804540:	f7 f7                	div    %edi
  804542:	89 c5                	mov    %eax,%ebp
  804544:	31 d2                	xor    %edx,%edx
  804546:	89 c8                	mov    %ecx,%eax
  804548:	f7 f5                	div    %ebp
  80454a:	89 c1                	mov    %eax,%ecx
  80454c:	89 d8                	mov    %ebx,%eax
  80454e:	f7 f5                	div    %ebp
  804550:	89 cf                	mov    %ecx,%edi
  804552:	89 fa                	mov    %edi,%edx
  804554:	83 c4 1c             	add    $0x1c,%esp
  804557:	5b                   	pop    %ebx
  804558:	5e                   	pop    %esi
  804559:	5f                   	pop    %edi
  80455a:	5d                   	pop    %ebp
  80455b:	c3                   	ret    
  80455c:	39 ce                	cmp    %ecx,%esi
  80455e:	77 28                	ja     804588 <__udivdi3+0x7c>
  804560:	0f bd fe             	bsr    %esi,%edi
  804563:	83 f7 1f             	xor    $0x1f,%edi
  804566:	75 40                	jne    8045a8 <__udivdi3+0x9c>
  804568:	39 ce                	cmp    %ecx,%esi
  80456a:	72 0a                	jb     804576 <__udivdi3+0x6a>
  80456c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804570:	0f 87 9e 00 00 00    	ja     804614 <__udivdi3+0x108>
  804576:	b8 01 00 00 00       	mov    $0x1,%eax
  80457b:	89 fa                	mov    %edi,%edx
  80457d:	83 c4 1c             	add    $0x1c,%esp
  804580:	5b                   	pop    %ebx
  804581:	5e                   	pop    %esi
  804582:	5f                   	pop    %edi
  804583:	5d                   	pop    %ebp
  804584:	c3                   	ret    
  804585:	8d 76 00             	lea    0x0(%esi),%esi
  804588:	31 ff                	xor    %edi,%edi
  80458a:	31 c0                	xor    %eax,%eax
  80458c:	89 fa                	mov    %edi,%edx
  80458e:	83 c4 1c             	add    $0x1c,%esp
  804591:	5b                   	pop    %ebx
  804592:	5e                   	pop    %esi
  804593:	5f                   	pop    %edi
  804594:	5d                   	pop    %ebp
  804595:	c3                   	ret    
  804596:	66 90                	xchg   %ax,%ax
  804598:	89 d8                	mov    %ebx,%eax
  80459a:	f7 f7                	div    %edi
  80459c:	31 ff                	xor    %edi,%edi
  80459e:	89 fa                	mov    %edi,%edx
  8045a0:	83 c4 1c             	add    $0x1c,%esp
  8045a3:	5b                   	pop    %ebx
  8045a4:	5e                   	pop    %esi
  8045a5:	5f                   	pop    %edi
  8045a6:	5d                   	pop    %ebp
  8045a7:	c3                   	ret    
  8045a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8045ad:	89 eb                	mov    %ebp,%ebx
  8045af:	29 fb                	sub    %edi,%ebx
  8045b1:	89 f9                	mov    %edi,%ecx
  8045b3:	d3 e6                	shl    %cl,%esi
  8045b5:	89 c5                	mov    %eax,%ebp
  8045b7:	88 d9                	mov    %bl,%cl
  8045b9:	d3 ed                	shr    %cl,%ebp
  8045bb:	89 e9                	mov    %ebp,%ecx
  8045bd:	09 f1                	or     %esi,%ecx
  8045bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045c3:	89 f9                	mov    %edi,%ecx
  8045c5:	d3 e0                	shl    %cl,%eax
  8045c7:	89 c5                	mov    %eax,%ebp
  8045c9:	89 d6                	mov    %edx,%esi
  8045cb:	88 d9                	mov    %bl,%cl
  8045cd:	d3 ee                	shr    %cl,%esi
  8045cf:	89 f9                	mov    %edi,%ecx
  8045d1:	d3 e2                	shl    %cl,%edx
  8045d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045d7:	88 d9                	mov    %bl,%cl
  8045d9:	d3 e8                	shr    %cl,%eax
  8045db:	09 c2                	or     %eax,%edx
  8045dd:	89 d0                	mov    %edx,%eax
  8045df:	89 f2                	mov    %esi,%edx
  8045e1:	f7 74 24 0c          	divl   0xc(%esp)
  8045e5:	89 d6                	mov    %edx,%esi
  8045e7:	89 c3                	mov    %eax,%ebx
  8045e9:	f7 e5                	mul    %ebp
  8045eb:	39 d6                	cmp    %edx,%esi
  8045ed:	72 19                	jb     804608 <__udivdi3+0xfc>
  8045ef:	74 0b                	je     8045fc <__udivdi3+0xf0>
  8045f1:	89 d8                	mov    %ebx,%eax
  8045f3:	31 ff                	xor    %edi,%edi
  8045f5:	e9 58 ff ff ff       	jmp    804552 <__udivdi3+0x46>
  8045fa:	66 90                	xchg   %ax,%ax
  8045fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804600:	89 f9                	mov    %edi,%ecx
  804602:	d3 e2                	shl    %cl,%edx
  804604:	39 c2                	cmp    %eax,%edx
  804606:	73 e9                	jae    8045f1 <__udivdi3+0xe5>
  804608:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80460b:	31 ff                	xor    %edi,%edi
  80460d:	e9 40 ff ff ff       	jmp    804552 <__udivdi3+0x46>
  804612:	66 90                	xchg   %ax,%ax
  804614:	31 c0                	xor    %eax,%eax
  804616:	e9 37 ff ff ff       	jmp    804552 <__udivdi3+0x46>
  80461b:	90                   	nop

0080461c <__umoddi3>:
  80461c:	55                   	push   %ebp
  80461d:	57                   	push   %edi
  80461e:	56                   	push   %esi
  80461f:	53                   	push   %ebx
  804620:	83 ec 1c             	sub    $0x1c,%esp
  804623:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804627:	8b 74 24 34          	mov    0x34(%esp),%esi
  80462b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80462f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804633:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804637:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80463b:	89 f3                	mov    %esi,%ebx
  80463d:	89 fa                	mov    %edi,%edx
  80463f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804643:	89 34 24             	mov    %esi,(%esp)
  804646:	85 c0                	test   %eax,%eax
  804648:	75 1a                	jne    804664 <__umoddi3+0x48>
  80464a:	39 f7                	cmp    %esi,%edi
  80464c:	0f 86 a2 00 00 00    	jbe    8046f4 <__umoddi3+0xd8>
  804652:	89 c8                	mov    %ecx,%eax
  804654:	89 f2                	mov    %esi,%edx
  804656:	f7 f7                	div    %edi
  804658:	89 d0                	mov    %edx,%eax
  80465a:	31 d2                	xor    %edx,%edx
  80465c:	83 c4 1c             	add    $0x1c,%esp
  80465f:	5b                   	pop    %ebx
  804660:	5e                   	pop    %esi
  804661:	5f                   	pop    %edi
  804662:	5d                   	pop    %ebp
  804663:	c3                   	ret    
  804664:	39 f0                	cmp    %esi,%eax
  804666:	0f 87 ac 00 00 00    	ja     804718 <__umoddi3+0xfc>
  80466c:	0f bd e8             	bsr    %eax,%ebp
  80466f:	83 f5 1f             	xor    $0x1f,%ebp
  804672:	0f 84 ac 00 00 00    	je     804724 <__umoddi3+0x108>
  804678:	bf 20 00 00 00       	mov    $0x20,%edi
  80467d:	29 ef                	sub    %ebp,%edi
  80467f:	89 fe                	mov    %edi,%esi
  804681:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804685:	89 e9                	mov    %ebp,%ecx
  804687:	d3 e0                	shl    %cl,%eax
  804689:	89 d7                	mov    %edx,%edi
  80468b:	89 f1                	mov    %esi,%ecx
  80468d:	d3 ef                	shr    %cl,%edi
  80468f:	09 c7                	or     %eax,%edi
  804691:	89 e9                	mov    %ebp,%ecx
  804693:	d3 e2                	shl    %cl,%edx
  804695:	89 14 24             	mov    %edx,(%esp)
  804698:	89 d8                	mov    %ebx,%eax
  80469a:	d3 e0                	shl    %cl,%eax
  80469c:	89 c2                	mov    %eax,%edx
  80469e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046a2:	d3 e0                	shl    %cl,%eax
  8046a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046ac:	89 f1                	mov    %esi,%ecx
  8046ae:	d3 e8                	shr    %cl,%eax
  8046b0:	09 d0                	or     %edx,%eax
  8046b2:	d3 eb                	shr    %cl,%ebx
  8046b4:	89 da                	mov    %ebx,%edx
  8046b6:	f7 f7                	div    %edi
  8046b8:	89 d3                	mov    %edx,%ebx
  8046ba:	f7 24 24             	mull   (%esp)
  8046bd:	89 c6                	mov    %eax,%esi
  8046bf:	89 d1                	mov    %edx,%ecx
  8046c1:	39 d3                	cmp    %edx,%ebx
  8046c3:	0f 82 87 00 00 00    	jb     804750 <__umoddi3+0x134>
  8046c9:	0f 84 91 00 00 00    	je     804760 <__umoddi3+0x144>
  8046cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8046d3:	29 f2                	sub    %esi,%edx
  8046d5:	19 cb                	sbb    %ecx,%ebx
  8046d7:	89 d8                	mov    %ebx,%eax
  8046d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8046dd:	d3 e0                	shl    %cl,%eax
  8046df:	89 e9                	mov    %ebp,%ecx
  8046e1:	d3 ea                	shr    %cl,%edx
  8046e3:	09 d0                	or     %edx,%eax
  8046e5:	89 e9                	mov    %ebp,%ecx
  8046e7:	d3 eb                	shr    %cl,%ebx
  8046e9:	89 da                	mov    %ebx,%edx
  8046eb:	83 c4 1c             	add    $0x1c,%esp
  8046ee:	5b                   	pop    %ebx
  8046ef:	5e                   	pop    %esi
  8046f0:	5f                   	pop    %edi
  8046f1:	5d                   	pop    %ebp
  8046f2:	c3                   	ret    
  8046f3:	90                   	nop
  8046f4:	89 fd                	mov    %edi,%ebp
  8046f6:	85 ff                	test   %edi,%edi
  8046f8:	75 0b                	jne    804705 <__umoddi3+0xe9>
  8046fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8046ff:	31 d2                	xor    %edx,%edx
  804701:	f7 f7                	div    %edi
  804703:	89 c5                	mov    %eax,%ebp
  804705:	89 f0                	mov    %esi,%eax
  804707:	31 d2                	xor    %edx,%edx
  804709:	f7 f5                	div    %ebp
  80470b:	89 c8                	mov    %ecx,%eax
  80470d:	f7 f5                	div    %ebp
  80470f:	89 d0                	mov    %edx,%eax
  804711:	e9 44 ff ff ff       	jmp    80465a <__umoddi3+0x3e>
  804716:	66 90                	xchg   %ax,%ax
  804718:	89 c8                	mov    %ecx,%eax
  80471a:	89 f2                	mov    %esi,%edx
  80471c:	83 c4 1c             	add    $0x1c,%esp
  80471f:	5b                   	pop    %ebx
  804720:	5e                   	pop    %esi
  804721:	5f                   	pop    %edi
  804722:	5d                   	pop    %ebp
  804723:	c3                   	ret    
  804724:	3b 04 24             	cmp    (%esp),%eax
  804727:	72 06                	jb     80472f <__umoddi3+0x113>
  804729:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80472d:	77 0f                	ja     80473e <__umoddi3+0x122>
  80472f:	89 f2                	mov    %esi,%edx
  804731:	29 f9                	sub    %edi,%ecx
  804733:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804737:	89 14 24             	mov    %edx,(%esp)
  80473a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80473e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804742:	8b 14 24             	mov    (%esp),%edx
  804745:	83 c4 1c             	add    $0x1c,%esp
  804748:	5b                   	pop    %ebx
  804749:	5e                   	pop    %esi
  80474a:	5f                   	pop    %edi
  80474b:	5d                   	pop    %ebp
  80474c:	c3                   	ret    
  80474d:	8d 76 00             	lea    0x0(%esi),%esi
  804750:	2b 04 24             	sub    (%esp),%eax
  804753:	19 fa                	sbb    %edi,%edx
  804755:	89 d1                	mov    %edx,%ecx
  804757:	89 c6                	mov    %eax,%esi
  804759:	e9 71 ff ff ff       	jmp    8046cf <__umoddi3+0xb3>
  80475e:	66 90                	xchg   %ax,%ax
  804760:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804764:	72 ea                	jb     804750 <__umoddi3+0x134>
  804766:	89 d9                	mov    %ebx,%ecx
  804768:	e9 62 ff ff ff       	jmp    8046cf <__umoddi3+0xb3>
