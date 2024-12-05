
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
  800094:	68 00 48 80 00       	push   $0x804800
  800099:	6a 1a                	push   $0x1a
  80009b:	68 1c 48 80 00       	push   $0x80481c
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
  8000e2:	e8 43 25 00 00       	call   80262a <sys_calculate_free_frames>
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
  8000fe:	e8 72 25 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 30 48 80 00       	push   $0x804830
  80013f:	6a 39                	push   $0x39
  800141:	68 1c 48 80 00       	push   $0x80481c
  800146:	e8 35 0e 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 25 25 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 98 48 80 00       	push   $0x804898
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 1c 48 80 00       	push   $0x80481c
  800164:	e8 17 0e 00 00       	call   800f80 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 bc 24 00 00       	call   80262a <sys_calculate_free_frames>
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
  80019e:	e8 87 24 00 00       	call   80262a <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 c8 48 80 00       	push   $0x8048c8
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 1c 48 80 00       	push   $0x80481c
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
  800274:	68 0c 49 80 00       	push   $0x80490c
  800279:	6a 4b                	push   $0x4b
  80027b:	68 1c 48 80 00       	push   $0x80481c
  800280:	e8 fb 0c 00 00       	call   800f80 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 eb 23 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  8002d6:	68 30 48 80 00       	push   $0x804830
  8002db:	6a 50                	push   $0x50
  8002dd:	68 1c 48 80 00       	push   $0x80481c
  8002e2:	e8 99 0c 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 89 23 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 98 48 80 00       	push   $0x804898
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 1c 48 80 00       	push   $0x80481c
  800300:	e8 7b 0c 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 20 23 00 00       	call   80262a <sys_calculate_free_frames>
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
  800343:	e8 e2 22 00 00       	call   80262a <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 c8 48 80 00       	push   $0x8048c8
  800359:	6a 58                	push   $0x58
  80035b:	68 1c 48 80 00       	push   $0x80481c
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
  80041d:	68 0c 49 80 00       	push   $0x80490c
  800422:	6a 61                	push   $0x61
  800424:	68 1c 48 80 00       	push   $0x80481c
  800429:	e8 52 0b 00 00       	call   800f80 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 42 22 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  800482:	68 30 48 80 00       	push   $0x804830
  800487:	6a 66                	push   $0x66
  800489:	68 1c 48 80 00       	push   $0x80481c
  80048e:	e8 ed 0a 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 dd 21 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 98 48 80 00       	push   $0x804898
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 1c 48 80 00       	push   $0x80481c
  8004ac:	e8 cf 0a 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 74 21 00 00       	call   80262a <sys_calculate_free_frames>
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
  8004ed:	e8 38 21 00 00       	call   80262a <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 c8 48 80 00       	push   $0x8048c8
  800503:	6a 6e                	push   $0x6e
  800505:	68 1c 48 80 00       	push   $0x80481c
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
  8005d0:	68 0c 49 80 00       	push   $0x80490c
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 1c 48 80 00       	push   $0x80481c
  8005dc:	e8 9f 09 00 00       	call   800f80 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 44 20 00 00       	call   80262a <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 87 20 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  800651:	68 30 48 80 00       	push   $0x804830
  800656:	6a 7d                	push   $0x7d
  800658:	68 1c 48 80 00       	push   $0x80481c
  80065d:	e8 1e 09 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 0e 20 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 98 48 80 00       	push   $0x804898
  800674:	6a 7e                	push   $0x7e
  800676:	68 1c 48 80 00       	push   $0x80481c
  80067b:	e8 00 09 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 f0 1f 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  8006ec:	68 30 48 80 00       	push   $0x804830
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 1c 48 80 00       	push   $0x80481c
  8006fb:	e8 80 08 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 70 1f 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 98 48 80 00       	push   $0x804898
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 1c 48 80 00       	push   $0x80481c
  80071c:	e8 5f 08 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 04 1f 00 00       	call   80262a <sys_calculate_free_frames>
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
  8007c5:	e8 60 1e 00 00       	call   80262a <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 c8 48 80 00       	push   $0x8048c8
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 1c 48 80 00       	push   $0x80481c
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
  8008c6:	68 0c 49 80 00       	push   $0x80490c
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 1c 48 80 00       	push   $0x80481c
  8008d5:	e8 a6 06 00 00       	call   800f80 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 4b 1d 00 00       	call   80262a <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 8e 1d 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  80094d:	68 30 48 80 00       	push   $0x804830
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 1c 48 80 00       	push   $0x80481c
  80095c:	e8 1f 06 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 0f 1d 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 98 48 80 00       	push   $0x804898
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 1c 48 80 00       	push   $0x80481c
  80097d:	e8 fe 05 00 00       	call   800f80 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 ee 1c 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 30 48 80 00       	push   $0x804830
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 1c 48 80 00       	push   $0x80481c
  800a0c:	e8 6f 05 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 5f 1c 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 98 48 80 00       	push   $0x804898
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 1c 48 80 00       	push   $0x80481c
  800a2d:	e8 4e 05 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 f3 1b 00 00       	call   80262a <sys_calculate_free_frames>
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
  800aa3:	e8 82 1b 00 00       	call   80262a <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 c8 48 80 00       	push   $0x8048c8
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 1c 48 80 00       	push   $0x80481c
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
  800bfc:	68 0c 49 80 00       	push   $0x80490c
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 1c 48 80 00       	push   $0x80481c
  800c0b:	e8 70 03 00 00       	call   800f80 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 60 1a 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
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
  800c8e:	68 30 48 80 00       	push   $0x804830
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 1c 48 80 00       	push   $0x80481c
  800c9d:	e8 de 02 00 00       	call   800f80 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 ce 19 00 00       	call   802675 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 98 48 80 00       	push   $0x804898
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 1c 48 80 00       	push   $0x80481c
  800cbe:	e8 bd 02 00 00       	call   800f80 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 62 19 00 00       	call   80262a <sys_calculate_free_frames>
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
  800d17:	e8 0e 19 00 00       	call   80262a <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 c8 48 80 00       	push   $0x8048c8
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 1c 48 80 00       	push   $0x80481c
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
  800e15:	68 0c 49 80 00       	push   $0x80490c
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 1c 48 80 00       	push   $0x80481c
  800e24:	e8 57 01 00 00       	call   800f80 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 2c 49 80 00       	push   $0x80492c
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
  800e47:	e8 a7 19 00 00       	call   8027f3 <sys_getenvindex>
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
  800eb5:	e8 bd 16 00 00       	call   802577 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	68 80 49 80 00       	push   $0x804980
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
  800ee5:	68 a8 49 80 00       	push   $0x8049a8
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
  800f16:	68 d0 49 80 00       	push   $0x8049d0
  800f1b:	e8 1d 03 00 00       	call   80123d <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f23:	a1 20 60 80 00       	mov    0x806020,%eax
  800f28:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	50                   	push   %eax
  800f32:	68 28 4a 80 00       	push   $0x804a28
  800f37:	e8 01 03 00 00       	call   80123d <cprintf>
  800f3c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	68 80 49 80 00       	push   $0x804980
  800f47:	e8 f1 02 00 00       	call   80123d <cprintf>
  800f4c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f4f:	e8 3d 16 00 00       	call   802591 <sys_unlock_cons>
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
  800f67:	e8 53 18 00 00       	call   8027bf <sys_destroy_env>
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
  800f78:	e8 a8 18 00 00       	call   802825 <sys_exit_env>
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
  800fa1:	68 3c 4a 80 00       	push   $0x804a3c
  800fa6:	e8 92 02 00 00       	call   80123d <cprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fae:	a1 00 60 80 00       	mov    0x806000,%eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	ff 75 08             	pushl  0x8(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	68 41 4a 80 00       	push   $0x804a41
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
  800fde:	68 5d 4a 80 00       	push   $0x804a5d
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
  80100d:	68 60 4a 80 00       	push   $0x804a60
  801012:	6a 26                	push   $0x26
  801014:	68 ac 4a 80 00       	push   $0x804aac
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
  8010e2:	68 b8 4a 80 00       	push   $0x804ab8
  8010e7:	6a 3a                	push   $0x3a
  8010e9:	68 ac 4a 80 00       	push   $0x804aac
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
  801155:	68 0c 4b 80 00       	push   $0x804b0c
  80115a:	6a 44                	push   $0x44
  80115c:	68 ac 4a 80 00       	push   $0x804aac
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
  8011af:	e8 81 13 00 00       	call   802535 <sys_cputs>
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
  801226:	e8 0a 13 00 00       	call   802535 <sys_cputs>
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
  801270:	e8 02 13 00 00       	call   802577 <sys_lock_cons>
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
  801290:	e8 fc 12 00 00       	call   802591 <sys_unlock_cons>
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
  8012da:	e8 bd 32 00 00       	call   80459c <__udivdi3>
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
  80132a:	e8 7d 33 00 00       	call   8046ac <__umoddi3>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	05 74 4d 80 00       	add    $0x804d74,%eax
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
  801485:	8b 04 85 98 4d 80 00 	mov    0x804d98(,%eax,4),%eax
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
  801566:	8b 34 9d e0 4b 80 00 	mov    0x804be0(,%ebx,4),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 19                	jne    80158a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801571:	53                   	push   %ebx
  801572:	68 85 4d 80 00       	push   $0x804d85
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
  80158b:	68 8e 4d 80 00       	push   $0x804d8e
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
  8015b8:	be 91 4d 80 00       	mov    $0x804d91,%esi
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
  801fc3:	68 08 4f 80 00       	push   $0x804f08
  801fc8:	68 3f 01 00 00       	push   $0x13f
  801fcd:	68 2a 4f 80 00       	push   $0x804f2a
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
  801fe3:	e8 f8 0a 00 00       	call   802ae0 <sys_sbrk>
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
  80205e:	e8 01 09 00 00       	call   802964 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 16                	je     80207d <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 41 0e 00 00       	call   802eb3 <alloc_block_FF>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	e9 8a 01 00 00       	jmp    802207 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80207d:	e8 13 09 00 00       	call   802995 <sys_isUHeapPlacementStrategyBESTFIT>
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 84 7d 01 00 00    	je     802207 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 da 12 00 00       	call   80336f <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	05 00 10 00 00       	add    $0x1000,%eax
  8020f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8020fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  80219a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219e:	75 16                	jne    8021b6 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8021a0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8021a7:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8021ae:	0f 86 15 ff ff ff    	jbe    8020c9 <malloc+0xdc>
  8021b4:	eb 01                	jmp    8021b7 <malloc+0x1ca>
				}
				

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
  8021f6:	e8 1c 09 00 00       	call   802b17 <sys_allocate_user_mem>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	eb 07                	jmp    802207 <malloc+0x21a>
		
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
  80223e:	e8 f0 08 00 00       	call   802b33 <get_block_size>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	e8 00 1b 00 00       	call   803d54 <free_block>
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
  802289:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  8022c6:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  8022cd:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	83 ec 08             	sub    $0x8,%esp
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	e8 1a 08 00 00       	call   802afb <sys_free_user_mem>
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
  8022f4:	68 38 4f 80 00       	push   $0x804f38
  8022f9:	68 87 00 00 00       	push   $0x87
  8022fe:	68 62 4f 80 00       	push   $0x804f62
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
  802322:	e9 87 00 00 00       	jmp    8023ae <smalloc+0xa3>
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
  802353:	75 07                	jne    80235c <smalloc+0x51>
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	eb 52                	jmp    8023ae <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80235c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802360:	ff 75 ec             	pushl  -0x14(%ebp)
  802363:	50                   	push   %eax
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	e8 93 03 00 00       	call   802702 <sys_createSharedObject>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802375:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802379:	74 06                	je     802381 <smalloc+0x76>
  80237b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80237f:	75 07                	jne    802388 <smalloc+0x7d>
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	eb 26                	jmp    8023ae <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802388:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80238b:	a1 20 60 80 00       	mov    0x806020,%eax
  802390:	8b 40 78             	mov    0x78(%eax),%eax
  802393:	29 c2                	sub    %eax,%edx
  802395:	89 d0                	mov    %edx,%eax
  802397:	2d 00 10 00 00       	sub    $0x1000,%eax
  80239c:	c1 e8 0c             	shr    $0xc,%eax
  80239f:	89 c2                	mov    %eax,%edx
  8023a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a4:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8023ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8023b6:	83 ec 08             	sub    $0x8,%esp
  8023b9:	ff 75 0c             	pushl  0xc(%ebp)
  8023bc:	ff 75 08             	pushl  0x8(%ebp)
  8023bf:	e8 68 03 00 00       	call   80272c <sys_getSizeOfSharedObject>
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8023ca:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8023ce:	75 07                	jne    8023d7 <sget+0x27>
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	eb 7f                	jmp    802456 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023dd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	39 d0                	cmp    %edx,%eax
  8023ec:	73 02                	jae    8023f0 <sget+0x40>
  8023ee:	89 d0                	mov    %edx,%eax
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	50                   	push   %eax
  8023f4:	e8 f4 fb ff ff       	call   801fed <malloc>
  8023f9:	83 c4 10             	add    $0x10,%esp
  8023fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8023ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802403:	75 07                	jne    80240c <sget+0x5c>
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	eb 4a                	jmp    802456 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	ff 75 e8             	pushl  -0x18(%ebp)
  802412:	ff 75 0c             	pushl  0xc(%ebp)
  802415:	ff 75 08             	pushl  0x8(%ebp)
  802418:	e8 2c 03 00 00       	call   802749 <sys_getSharedObject>
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802423:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802426:	a1 20 60 80 00       	mov    0x806020,%eax
  80242b:	8b 40 78             	mov    0x78(%eax),%eax
  80242e:	29 c2                	sub    %eax,%edx
  802430:	89 d0                	mov    %edx,%eax
  802432:	2d 00 10 00 00       	sub    $0x1000,%eax
  802437:	c1 e8 0c             	shr    $0xc,%eax
  80243a:	89 c2                	mov    %eax,%edx
  80243c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243f:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802446:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80244a:	75 07                	jne    802453 <sget+0xa3>
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	eb 03                	jmp    802456 <sget+0xa6>
	return ptr;
  802453:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80245e:	8b 55 08             	mov    0x8(%ebp),%edx
  802461:	a1 20 60 80 00       	mov    0x806020,%eax
  802466:	8b 40 78             	mov    0x78(%eax),%eax
  802469:	29 c2                	sub    %eax,%edx
  80246b:	89 d0                	mov    %edx,%eax
  80246d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802472:	c1 e8 0c             	shr    $0xc,%eax
  802475:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80247f:	83 ec 08             	sub    $0x8,%esp
  802482:	ff 75 08             	pushl  0x8(%ebp)
  802485:	ff 75 f4             	pushl  -0xc(%ebp)
  802488:	e8 db 02 00 00       	call   802768 <sys_freeSharedObject>
  80248d:	83 c4 10             	add    $0x10,%esp
  802490:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802493:	90                   	nop
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 70 4f 80 00       	push   $0x804f70
  8024a4:	68 e4 00 00 00       	push   $0xe4
  8024a9:	68 62 4f 80 00       	push   $0x804f62
  8024ae:	e8 cd ea ff ff       	call   800f80 <_panic>

008024b3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	68 96 4f 80 00       	push   $0x804f96
  8024c1:	68 f0 00 00 00       	push   $0xf0
  8024c6:	68 62 4f 80 00       	push   $0x804f62
  8024cb:	e8 b0 ea ff ff       	call   800f80 <_panic>

008024d0 <shrink>:

}
void shrink(uint32 newSize)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	68 96 4f 80 00       	push   $0x804f96
  8024de:	68 f5 00 00 00       	push   $0xf5
  8024e3:	68 62 4f 80 00       	push   $0x804f62
  8024e8:	e8 93 ea ff ff       	call   800f80 <_panic>

008024ed <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	68 96 4f 80 00       	push   $0x804f96
  8024fb:	68 fa 00 00 00       	push   $0xfa
  802500:	68 62 4f 80 00       	push   $0x804f62
  802505:	e8 76 ea ff ff       	call   800f80 <_panic>

0080250a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	57                   	push   %edi
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	8b 55 0c             	mov    0xc(%ebp),%edx
  802519:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80251c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80251f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802522:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802525:	cd 30                	int    $0x30
  802527:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    

00802535 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802541:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	52                   	push   %edx
  80254d:	ff 75 0c             	pushl  0xc(%ebp)
  802550:	50                   	push   %eax
  802551:	6a 00                	push   $0x0
  802553:	e8 b2 ff ff ff       	call   80250a <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	90                   	nop
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <sys_cgetc>:

int
sys_cgetc(void)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 02                	push   $0x2
  80256d:	e8 98 ff ff ff       	call   80250a <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 03                	push   $0x3
  802586:	e8 7f ff ff ff       	call   80250a <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	90                   	nop
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 04                	push   $0x4
  8025a0:	e8 65 ff ff ff       	call   80250a <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	90                   	nop
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	52                   	push   %edx
  8025bb:	50                   	push   %eax
  8025bc:	6a 08                	push   $0x8
  8025be:	e8 47 ff ff ff       	call   80250a <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	56                   	push   %esi
  8025cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8025d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	56                   	push   %esi
  8025dd:	53                   	push   %ebx
  8025de:	51                   	push   %ecx
  8025df:	52                   	push   %edx
  8025e0:	50                   	push   %eax
  8025e1:	6a 09                	push   $0x9
  8025e3:	e8 22 ff ff ff       	call   80250a <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
}
  8025eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ee:	5b                   	pop    %ebx
  8025ef:	5e                   	pop    %esi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    

008025f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8025f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	52                   	push   %edx
  802602:	50                   	push   %eax
  802603:	6a 0a                	push   $0xa
  802605:	e8 00 ff ff ff       	call   80250a <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	ff 75 0c             	pushl  0xc(%ebp)
  80261b:	ff 75 08             	pushl  0x8(%ebp)
  80261e:	6a 0b                	push   $0xb
  802620:	e8 e5 fe ff ff       	call   80250a <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 0c                	push   $0xc
  802639:	e8 cc fe ff ff       	call   80250a <syscall>
  80263e:	83 c4 18             	add    $0x18,%esp
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 0d                	push   $0xd
  802652:	e8 b3 fe ff ff       	call   80250a <syscall>
  802657:	83 c4 18             	add    $0x18,%esp
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 0e                	push   $0xe
  80266b:	e8 9a fe ff ff       	call   80250a <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 0f                	push   $0xf
  802684:	e8 81 fe ff ff       	call   80250a <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	ff 75 08             	pushl  0x8(%ebp)
  80269c:	6a 10                	push   $0x10
  80269e:	e8 67 fe ff ff       	call   80250a <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 11                	push   $0x11
  8026b7:	e8 4e fe ff ff       	call   80250a <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
}
  8026bf:	90                   	nop
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 04             	sub    $0x4,%esp
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	50                   	push   %eax
  8026db:	6a 01                	push   $0x1
  8026dd:	e8 28 fe ff ff       	call   80250a <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
}
  8026e5:	90                   	nop
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 14                	push   $0x14
  8026f7:	e8 0e fe ff ff       	call   80250a <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	90                   	nop
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 04             	sub    $0x4,%esp
  802708:	8b 45 10             	mov    0x10(%ebp),%eax
  80270b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80270e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802711:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	6a 00                	push   $0x0
  80271a:	51                   	push   %ecx
  80271b:	52                   	push   %edx
  80271c:	ff 75 0c             	pushl  0xc(%ebp)
  80271f:	50                   	push   %eax
  802720:	6a 15                	push   $0x15
  802722:	e8 e3 fd ff ff       	call   80250a <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80272f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	52                   	push   %edx
  80273c:	50                   	push   %eax
  80273d:	6a 16                	push   $0x16
  80273f:	e8 c6 fd ff ff       	call   80250a <syscall>
  802744:	83 c4 18             	add    $0x18,%esp
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80274c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	51                   	push   %ecx
  80275a:	52                   	push   %edx
  80275b:	50                   	push   %eax
  80275c:	6a 17                	push   $0x17
  80275e:	e8 a7 fd ff ff       	call   80250a <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80276b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	52                   	push   %edx
  802778:	50                   	push   %eax
  802779:	6a 18                	push   $0x18
  80277b:	e8 8a fd ff ff       	call   80250a <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	6a 00                	push   $0x0
  80278d:	ff 75 14             	pushl  0x14(%ebp)
  802790:	ff 75 10             	pushl  0x10(%ebp)
  802793:	ff 75 0c             	pushl  0xc(%ebp)
  802796:	50                   	push   %eax
  802797:	6a 19                	push   $0x19
  802799:	e8 6c fd ff ff       	call   80250a <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	50                   	push   %eax
  8027b2:	6a 1a                	push   $0x1a
  8027b4:	e8 51 fd ff ff       	call   80250a <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
}
  8027bc:	90                   	nop
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	50                   	push   %eax
  8027ce:	6a 1b                	push   $0x1b
  8027d0:	e8 35 fd ff ff       	call   80250a <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 05                	push   $0x5
  8027e9:	e8 1c fd ff ff       	call   80250a <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 06                	push   $0x6
  802802:	e8 03 fd ff ff       	call   80250a <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 07                	push   $0x7
  80281b:	e8 ea fc ff ff       	call   80250a <syscall>
  802820:	83 c4 18             	add    $0x18,%esp
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_exit_env>:


void sys_exit_env(void)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 1c                	push   $0x1c
  802834:	e8 d1 fc ff ff       	call   80250a <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
}
  80283c:	90                   	nop
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802845:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802848:	8d 50 04             	lea    0x4(%eax),%edx
  80284b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	52                   	push   %edx
  802855:	50                   	push   %eax
  802856:	6a 1d                	push   $0x1d
  802858:	e8 ad fc ff ff       	call   80250a <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
	return result;
  802860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802863:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802866:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802869:	89 01                	mov    %eax,(%ecx)
  80286b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	c9                   	leave  
  802872:	c2 04 00             	ret    $0x4

00802875 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	ff 75 10             	pushl  0x10(%ebp)
  80287f:	ff 75 0c             	pushl  0xc(%ebp)
  802882:	ff 75 08             	pushl  0x8(%ebp)
  802885:	6a 13                	push   $0x13
  802887:	e8 7e fc ff ff       	call   80250a <syscall>
  80288c:	83 c4 18             	add    $0x18,%esp
	return ;
  80288f:	90                   	nop
}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <sys_rcr2>:
uint32 sys_rcr2()
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 1e                	push   $0x1e
  8028a1:	e8 64 fc ff ff       	call   80250a <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 00                	push   $0x0
  8028c3:	50                   	push   %eax
  8028c4:	6a 1f                	push   $0x1f
  8028c6:	e8 3f fc ff ff       	call   80250a <syscall>
  8028cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ce:	90                   	nop
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <rsttst>:
void rsttst()
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 21                	push   $0x21
  8028e0:	e8 25 fc ff ff       	call   80250a <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e8:	90                   	nop
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8028fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028fe:	52                   	push   %edx
  8028ff:	50                   	push   %eax
  802900:	ff 75 10             	pushl  0x10(%ebp)
  802903:	ff 75 0c             	pushl  0xc(%ebp)
  802906:	ff 75 08             	pushl  0x8(%ebp)
  802909:	6a 20                	push   $0x20
  80290b:	e8 fa fb ff ff       	call   80250a <syscall>
  802910:	83 c4 18             	add    $0x18,%esp
	return ;
  802913:	90                   	nop
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <chktst>:
void chktst(uint32 n)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	ff 75 08             	pushl  0x8(%ebp)
  802924:	6a 22                	push   $0x22
  802926:	e8 df fb ff ff       	call   80250a <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
	return ;
  80292e:	90                   	nop
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <inctst>:

void inctst()
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 23                	push   $0x23
  802940:	e8 c5 fb ff ff       	call   80250a <syscall>
  802945:	83 c4 18             	add    $0x18,%esp
	return ;
  802948:	90                   	nop
}
  802949:	c9                   	leave  
  80294a:	c3                   	ret    

0080294b <gettst>:
uint32 gettst()
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 24                	push   $0x24
  80295a:	e8 ab fb ff ff       	call   80250a <syscall>
  80295f:	83 c4 18             	add    $0x18,%esp
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 25                	push   $0x25
  802976:	e8 8f fb ff ff       	call   80250a <syscall>
  80297b:	83 c4 18             	add    $0x18,%esp
  80297e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802981:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802985:	75 07                	jne    80298e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802987:	b8 01 00 00 00       	mov    $0x1,%eax
  80298c:	eb 05                	jmp    802993 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 25                	push   $0x25
  8029a7:	e8 5e fb ff ff       	call   80250a <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
  8029af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029b6:	75 07                	jne    8029bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bd:	eb 05                	jmp    8029c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    

008029c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 25                	push   $0x25
  8029d8:	e8 2d fb ff ff       	call   80250a <syscall>
  8029dd:	83 c4 18             	add    $0x18,%esp
  8029e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029e7:	75 07                	jne    8029f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ee:	eb 05                	jmp    8029f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 25                	push   $0x25
  802a09:	e8 fc fa ff ff       	call   80250a <syscall>
  802a0e:	83 c4 18             	add    $0x18,%esp
  802a11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a14:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a18:	75 07                	jne    802a21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1f:	eb 05                	jmp    802a26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	ff 75 08             	pushl  0x8(%ebp)
  802a36:	6a 26                	push   $0x26
  802a38:	e8 cd fa ff ff       	call   80250a <syscall>
  802a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  802a40:	90                   	nop
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	6a 00                	push   $0x0
  802a55:	53                   	push   %ebx
  802a56:	51                   	push   %ecx
  802a57:	52                   	push   %edx
  802a58:	50                   	push   %eax
  802a59:	6a 27                	push   $0x27
  802a5b:	e8 aa fa ff ff       	call   80250a <syscall>
  802a60:	83 c4 18             	add    $0x18,%esp
}
  802a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    

00802a68 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	52                   	push   %edx
  802a78:	50                   	push   %eax
  802a79:	6a 28                	push   $0x28
  802a7b:	e8 8a fa ff ff       	call   80250a <syscall>
  802a80:	83 c4 18             	add    $0x18,%esp
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802a88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	6a 00                	push   $0x0
  802a93:	51                   	push   %ecx
  802a94:	ff 75 10             	pushl  0x10(%ebp)
  802a97:	52                   	push   %edx
  802a98:	50                   	push   %eax
  802a99:	6a 29                	push   $0x29
  802a9b:	e8 6a fa ff ff       	call   80250a <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
}
  802aa3:	c9                   	leave  
  802aa4:	c3                   	ret    

00802aa5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	ff 75 10             	pushl  0x10(%ebp)
  802aaf:	ff 75 0c             	pushl  0xc(%ebp)
  802ab2:	ff 75 08             	pushl  0x8(%ebp)
  802ab5:	6a 12                	push   $0x12
  802ab7:	e8 4e fa ff ff       	call   80250a <syscall>
  802abc:	83 c4 18             	add    $0x18,%esp
	return ;
  802abf:	90                   	nop
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	52                   	push   %edx
  802ad2:	50                   	push   %eax
  802ad3:	6a 2a                	push   $0x2a
  802ad5:	e8 30 fa ff ff       	call   80250a <syscall>
  802ada:	83 c4 18             	add    $0x18,%esp
	return;
  802add:	90                   	nop
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 00                	push   $0x0
  802aec:	6a 00                	push   $0x0
  802aee:	50                   	push   %eax
  802aef:	6a 2b                	push   $0x2b
  802af1:	e8 14 fa ff ff       	call   80250a <syscall>
  802af6:	83 c4 18             	add    $0x18,%esp
}
  802af9:	c9                   	leave  
  802afa:	c3                   	ret    

00802afb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802afb:	55                   	push   %ebp
  802afc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802afe:	6a 00                	push   $0x0
  802b00:	6a 00                	push   $0x0
  802b02:	6a 00                	push   $0x0
  802b04:	ff 75 0c             	pushl  0xc(%ebp)
  802b07:	ff 75 08             	pushl  0x8(%ebp)
  802b0a:	6a 2c                	push   $0x2c
  802b0c:	e8 f9 f9 ff ff       	call   80250a <syscall>
  802b11:	83 c4 18             	add    $0x18,%esp
	return;
  802b14:	90                   	nop
}
  802b15:	c9                   	leave  
  802b16:	c3                   	ret    

00802b17 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	ff 75 0c             	pushl  0xc(%ebp)
  802b23:	ff 75 08             	pushl  0x8(%ebp)
  802b26:	6a 2d                	push   $0x2d
  802b28:	e8 dd f9 ff ff       	call   80250a <syscall>
  802b2d:	83 c4 18             	add    $0x18,%esp
	return;
  802b30:	90                   	nop
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
  802b36:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	83 e8 04             	sub    $0x4,%eax
  802b3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	83 e8 04             	sub    $0x4,%eax
  802b58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	83 e0 01             	and    $0x1,%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	0f 94 c0             	sete   %al
}
  802b68:	c9                   	leave  
  802b69:	c3                   	ret    

00802b6a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802b6a:	55                   	push   %ebp
  802b6b:	89 e5                	mov    %esp,%ebp
  802b6d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7a:	83 f8 02             	cmp    $0x2,%eax
  802b7d:	74 2b                	je     802baa <alloc_block+0x40>
  802b7f:	83 f8 02             	cmp    $0x2,%eax
  802b82:	7f 07                	jg     802b8b <alloc_block+0x21>
  802b84:	83 f8 01             	cmp    $0x1,%eax
  802b87:	74 0e                	je     802b97 <alloc_block+0x2d>
  802b89:	eb 58                	jmp    802be3 <alloc_block+0x79>
  802b8b:	83 f8 03             	cmp    $0x3,%eax
  802b8e:	74 2d                	je     802bbd <alloc_block+0x53>
  802b90:	83 f8 04             	cmp    $0x4,%eax
  802b93:	74 3b                	je     802bd0 <alloc_block+0x66>
  802b95:	eb 4c                	jmp    802be3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802b97:	83 ec 0c             	sub    $0xc,%esp
  802b9a:	ff 75 08             	pushl  0x8(%ebp)
  802b9d:	e8 11 03 00 00       	call   802eb3 <alloc_block_FF>
  802ba2:	83 c4 10             	add    $0x10,%esp
  802ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ba8:	eb 4a                	jmp    802bf4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802baa:	83 ec 0c             	sub    $0xc,%esp
  802bad:	ff 75 08             	pushl  0x8(%ebp)
  802bb0:	e8 c7 19 00 00       	call   80457c <alloc_block_NF>
  802bb5:	83 c4 10             	add    $0x10,%esp
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802bbb:	eb 37                	jmp    802bf4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff 75 08             	pushl  0x8(%ebp)
  802bc3:	e8 a7 07 00 00       	call   80336f <alloc_block_BF>
  802bc8:	83 c4 10             	add    $0x10,%esp
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802bce:	eb 24                	jmp    802bf4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	ff 75 08             	pushl  0x8(%ebp)
  802bd6:	e8 84 19 00 00       	call   80455f <alloc_block_WF>
  802bdb:	83 c4 10             	add    $0x10,%esp
  802bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802be1:	eb 11                	jmp    802bf4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	68 a8 4f 80 00       	push   $0x804fa8
  802beb:	e8 4d e6 ff ff       	call   80123d <cprintf>
  802bf0:	83 c4 10             	add    $0x10,%esp
		break;
  802bf3:	90                   	nop
	}
	return va;
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802bf7:	c9                   	leave  
  802bf8:	c3                   	ret    

00802bf9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802bf9:	55                   	push   %ebp
  802bfa:	89 e5                	mov    %esp,%ebp
  802bfc:	53                   	push   %ebx
  802bfd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802c00:	83 ec 0c             	sub    $0xc,%esp
  802c03:	68 c8 4f 80 00       	push   $0x804fc8
  802c08:	e8 30 e6 ff ff       	call   80123d <cprintf>
  802c0d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	68 f3 4f 80 00       	push   $0x804ff3
  802c18:	e8 20 e6 ff ff       	call   80123d <cprintf>
  802c1d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c26:	eb 37                	jmp    802c5f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802c28:	83 ec 0c             	sub    $0xc,%esp
  802c2b:	ff 75 f4             	pushl  -0xc(%ebp)
  802c2e:	e8 19 ff ff ff       	call   802b4c <is_free_block>
  802c33:	83 c4 10             	add    $0x10,%esp
  802c36:	0f be d8             	movsbl %al,%ebx
  802c39:	83 ec 0c             	sub    $0xc,%esp
  802c3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3f:	e8 ef fe ff ff       	call   802b33 <get_block_size>
  802c44:	83 c4 10             	add    $0x10,%esp
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	53                   	push   %ebx
  802c4b:	50                   	push   %eax
  802c4c:	68 0b 50 80 00       	push   $0x80500b
  802c51:	e8 e7 e5 ff ff       	call   80123d <cprintf>
  802c56:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802c59:	8b 45 10             	mov    0x10(%ebp),%eax
  802c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	74 07                	je     802c6c <print_blocks_list+0x73>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	eb 05                	jmp    802c71 <print_blocks_list+0x78>
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	89 45 10             	mov    %eax,0x10(%ebp)
  802c74:	8b 45 10             	mov    0x10(%ebp),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	75 ad                	jne    802c28 <print_blocks_list+0x2f>
  802c7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7f:	75 a7                	jne    802c28 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802c81:	83 ec 0c             	sub    $0xc,%esp
  802c84:	68 c8 4f 80 00       	push   $0x804fc8
  802c89:	e8 af e5 ff ff       	call   80123d <cprintf>
  802c8e:	83 c4 10             	add    $0x10,%esp

}
  802c91:	90                   	nop
  802c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c95:	c9                   	leave  
  802c96:	c3                   	ret    

00802c97 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
  802c9a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca0:	83 e0 01             	and    $0x1,%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 03                	je     802caa <initialize_dynamic_allocator+0x13>
  802ca7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cae:	0f 84 c7 01 00 00    	je     802e7b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802cb4:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802cbb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc4:	01 d0                	add    %edx,%eax
  802cc6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ccb:	0f 87 ad 01 00 00    	ja     802e7e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	0f 89 a5 01 00 00    	jns    802e81 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	83 e8 04             	sub    $0x4,%eax
  802ce7:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802cec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802cf3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cfb:	e9 87 00 00 00       	jmp    802d87 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d04:	75 14                	jne    802d1a <initialize_dynamic_allocator+0x83>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 23 50 80 00       	push   $0x805023
  802d0e:	6a 79                	push   $0x79
  802d10:	68 41 50 80 00       	push   $0x805041
  802d15:	e8 66 e2 ff ff       	call   800f80 <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <initialize_dynamic_allocator+0x9c>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <initialize_dynamic_allocator+0xa7>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 30 60 80 00       	mov    %eax,0x806030
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <initialize_dynamic_allocator+0xc0>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <initialize_dynamic_allocator+0xca>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 38 60 80 00       	mov    0x806038,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802d7f:	a1 34 60 80 00       	mov    0x806034,%eax
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	74 07                	je     802d94 <initialize_dynamic_allocator+0xfd>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	eb 05                	jmp    802d99 <initialize_dynamic_allocator+0x102>
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
  802d99:	a3 34 60 80 00       	mov    %eax,0x806034
  802d9e:	a1 34 60 80 00       	mov    0x806034,%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	0f 85 55 ff ff ff    	jne    802d00 <initialize_dynamic_allocator+0x69>
  802dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daf:	0f 85 4b ff ff ff    	jne    802d00 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802dc4:	a1 44 60 80 00       	mov    0x806044,%eax
  802dc9:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802dce:	a1 40 60 80 00       	mov    0x806040,%eax
  802dd3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	83 c0 08             	add    $0x8,%eax
  802ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	83 c0 04             	add    $0x4,%eax
  802de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802deb:	83 ea 08             	sub    $0x8,%edx
  802dee:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802df0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	01 d0                	add    %edx,%eax
  802df8:	83 e8 08             	sub    $0x8,%eax
  802dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dfe:	83 ea 08             	sub    $0x8,%edx
  802e01:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802e16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e1a:	75 17                	jne    802e33 <initialize_dynamic_allocator+0x19c>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 5c 50 80 00       	push   $0x80505c
  802e24:	68 90 00 00 00       	push   $0x90
  802e29:	68 41 50 80 00       	push   $0x805041
  802e2e:	e8 4d e1 ff ff       	call   800f80 <_panic>
  802e33:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0d                	je     802e54 <initialize_dynamic_allocator+0x1bd>
  802e47:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802e4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	eb 08                	jmp    802e5c <initialize_dynamic_allocator+0x1c5>
  802e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e57:	a3 30 60 80 00       	mov    %eax,0x806030
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 38 60 80 00       	mov    0x806038,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 38 60 80 00       	mov    %eax,0x806038
  802e79:	eb 07                	jmp    802e82 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802e7b:	90                   	nop
  802e7c:	eb 04                	jmp    802e82 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802e7e:	90                   	nop
  802e7f:	eb 01                	jmp    802e82 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802e81:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802e87:	8b 45 10             	mov    0x10(%ebp),%eax
  802e8a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e96:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	83 e8 04             	sub    $0x4,%eax
  802e9e:	8b 00                	mov    (%eax),%eax
  802ea0:	83 e0 fe             	and    $0xfffffffe,%eax
  802ea3:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eae:	89 02                	mov    %eax,(%edx)
}
  802eb0:	90                   	nop
  802eb1:	5d                   	pop    %ebp
  802eb2:	c3                   	ret    

00802eb3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
  802eb6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	83 e0 01             	and    $0x1,%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 03                	je     802ec6 <alloc_block_FF+0x13>
  802ec3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ec6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802eca:	77 07                	ja     802ed3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ecc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ed3:	a1 24 60 80 00       	mov    0x806024,%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	75 73                	jne    802f4f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	83 c0 10             	add    $0x10,%eax
  802ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ee5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	01 d0                	add    %edx,%eax
  802ef4:	48                   	dec    %eax
  802ef5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efb:	ba 00 00 00 00       	mov    $0x0,%edx
  802f00:	f7 75 ec             	divl   -0x14(%ebp)
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	29 d0                	sub    %edx,%eax
  802f08:	c1 e8 0c             	shr    $0xc,%eax
  802f0b:	83 ec 0c             	sub    $0xc,%esp
  802f0e:	50                   	push   %eax
  802f0f:	e8 c3 f0 ff ff       	call   801fd7 <sbrk>
  802f14:	83 c4 10             	add    $0x10,%esp
  802f17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f1a:	83 ec 0c             	sub    $0xc,%esp
  802f1d:	6a 00                	push   $0x0
  802f1f:	e8 b3 f0 ff ff       	call   801fd7 <sbrk>
  802f24:	83 c4 10             	add    $0x10,%esp
  802f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f30:	83 ec 08             	sub    $0x8,%esp
  802f33:	50                   	push   %eax
  802f34:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f37:	e8 5b fd ff ff       	call   802c97 <initialize_dynamic_allocator>
  802f3c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f3f:	83 ec 0c             	sub    $0xc,%esp
  802f42:	68 7f 50 80 00       	push   $0x80507f
  802f47:	e8 f1 e2 ff ff       	call   80123d <cprintf>
  802f4c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802f4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f53:	75 0a                	jne    802f5f <alloc_block_FF+0xac>
	        return NULL;
  802f55:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5a:	e9 0e 04 00 00       	jmp    80336d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802f5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f66:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6e:	e9 f3 02 00 00       	jmp    803266 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	ff 75 bc             	pushl  -0x44(%ebp)
  802f7f:	e8 af fb ff ff       	call   802b33 <get_block_size>
  802f84:	83 c4 10             	add    $0x10,%esp
  802f87:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	83 c0 08             	add    $0x8,%eax
  802f90:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802f93:	0f 87 c5 02 00 00    	ja     80325e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	83 c0 18             	add    $0x18,%eax
  802f9f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802fa2:	0f 87 19 02 00 00    	ja     8031c1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802fa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802fab:	2b 45 08             	sub    0x8(%ebp),%eax
  802fae:	83 e8 08             	sub    $0x8,%eax
  802fb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8d 50 08             	lea    0x8(%eax),%edx
  802fba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fbd:	01 d0                	add    %edx,%eax
  802fbf:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	83 c0 08             	add    $0x8,%eax
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	6a 01                	push   $0x1
  802fcd:	50                   	push   %eax
  802fce:	ff 75 bc             	pushl  -0x44(%ebp)
  802fd1:	e8 ae fe ff ff       	call   802e84 <set_block_data>
  802fd6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	75 68                	jne    80304b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fe3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802fe7:	75 17                	jne    803000 <alloc_block_FF+0x14d>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 5c 50 80 00       	push   $0x80505c
  802ff1:	68 d7 00 00 00       	push   $0xd7
  802ff6:	68 41 50 80 00       	push   $0x805041
  802ffb:	e8 80 df ff ff       	call   800f80 <_panic>
  803000:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803006:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803009:	89 10                	mov    %edx,(%eax)
  80300b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0d                	je     803021 <alloc_block_FF+0x16e>
  803014:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803019:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80301c:	89 50 04             	mov    %edx,0x4(%eax)
  80301f:	eb 08                	jmp    803029 <alloc_block_FF+0x176>
  803021:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803024:	a3 30 60 80 00       	mov    %eax,0x806030
  803029:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80302c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803031:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303b:	a1 38 60 80 00       	mov    0x806038,%eax
  803040:	40                   	inc    %eax
  803041:	a3 38 60 80 00       	mov    %eax,0x806038
  803046:	e9 dc 00 00 00       	jmp    803127 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	75 65                	jne    8030b9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803054:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803058:	75 17                	jne    803071 <alloc_block_FF+0x1be>
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	68 90 50 80 00       	push   $0x805090
  803062:	68 db 00 00 00       	push   $0xdb
  803067:	68 41 50 80 00       	push   $0x805041
  80306c:	e8 0f df ff ff       	call   800f80 <_panic>
  803071:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803077:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80307a:	89 50 04             	mov    %edx,0x4(%eax)
  80307d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0c                	je     803093 <alloc_block_FF+0x1e0>
  803087:	a1 30 60 80 00       	mov    0x806030,%eax
  80308c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80308f:	89 10                	mov    %edx,(%eax)
  803091:	eb 08                	jmp    80309b <alloc_block_FF+0x1e8>
  803093:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803096:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80309b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80309e:	a3 30 60 80 00       	mov    %eax,0x806030
  8030a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ac:	a1 38 60 80 00       	mov    0x806038,%eax
  8030b1:	40                   	inc    %eax
  8030b2:	a3 38 60 80 00       	mov    %eax,0x806038
  8030b7:	eb 6e                	jmp    803127 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	74 06                	je     8030c5 <alloc_block_FF+0x212>
  8030bf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030c3:	75 17                	jne    8030dc <alloc_block_FF+0x229>
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	68 b4 50 80 00       	push   $0x8050b4
  8030cd:	68 df 00 00 00       	push   $0xdf
  8030d2:	68 41 50 80 00       	push   $0x805041
  8030d7:	e8 a4 de ff ff       	call   800f80 <_panic>
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 10                	mov    (%eax),%edx
  8030e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0b                	je     8030fa <alloc_block_FF+0x247>
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803100:	89 10                	mov    %edx,(%eax)
  803102:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	75 08                	jne    80311c <alloc_block_FF+0x269>
  803114:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803117:	a3 30 60 80 00       	mov    %eax,0x806030
  80311c:	a1 38 60 80 00       	mov    0x806038,%eax
  803121:	40                   	inc    %eax
  803122:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312b:	75 17                	jne    803144 <alloc_block_FF+0x291>
  80312d:	83 ec 04             	sub    $0x4,%esp
  803130:	68 23 50 80 00       	push   $0x805023
  803135:	68 e1 00 00 00       	push   $0xe1
  80313a:	68 41 50 80 00       	push   $0x805041
  80313f:	e8 3c de ff ff       	call   800f80 <_panic>
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 10                	je     80315d <alloc_block_FF+0x2aa>
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803155:	8b 52 04             	mov    0x4(%edx),%edx
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	eb 0b                	jmp    803168 <alloc_block_FF+0x2b5>
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	a3 30 60 80 00       	mov    %eax,0x806030
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 40 04             	mov    0x4(%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 0f                	je     803181 <alloc_block_FF+0x2ce>
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 40 04             	mov    0x4(%eax),%eax
  803178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317b:	8b 12                	mov    (%edx),%edx
  80317d:	89 10                	mov    %edx,(%eax)
  80317f:	eb 0a                	jmp    80318b <alloc_block_FF+0x2d8>
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319e:	a1 38 60 80 00       	mov    0x806038,%eax
  8031a3:	48                   	dec    %eax
  8031a4:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	6a 00                	push   $0x0
  8031ae:	ff 75 b4             	pushl  -0x4c(%ebp)
  8031b1:	ff 75 b0             	pushl  -0x50(%ebp)
  8031b4:	e8 cb fc ff ff       	call   802e84 <set_block_data>
  8031b9:	83 c4 10             	add    $0x10,%esp
  8031bc:	e9 95 00 00 00       	jmp    803256 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8031c1:	83 ec 04             	sub    $0x4,%esp
  8031c4:	6a 01                	push   $0x1
  8031c6:	ff 75 b8             	pushl  -0x48(%ebp)
  8031c9:	ff 75 bc             	pushl  -0x44(%ebp)
  8031cc:	e8 b3 fc ff ff       	call   802e84 <set_block_data>
  8031d1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d8:	75 17                	jne    8031f1 <alloc_block_FF+0x33e>
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	68 23 50 80 00       	push   $0x805023
  8031e2:	68 e8 00 00 00       	push   $0xe8
  8031e7:	68 41 50 80 00       	push   $0x805041
  8031ec:	e8 8f dd ff ff       	call   800f80 <_panic>
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	74 10                	je     80320a <alloc_block_FF+0x357>
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803202:	8b 52 04             	mov    0x4(%edx),%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	eb 0b                	jmp    803215 <alloc_block_FF+0x362>
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 40 04             	mov    0x4(%eax),%eax
  803210:	a3 30 60 80 00       	mov    %eax,0x806030
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0f                	je     80322e <alloc_block_FF+0x37b>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803228:	8b 12                	mov    (%edx),%edx
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	eb 0a                	jmp    803238 <alloc_block_FF+0x385>
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 38 60 80 00       	mov    0x806038,%eax
  803250:	48                   	dec    %eax
  803251:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  803256:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803259:	e9 0f 01 00 00       	jmp    80336d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80325e:	a1 34 60 80 00       	mov    0x806034,%eax
  803263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326a:	74 07                	je     803273 <alloc_block_FF+0x3c0>
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	eb 05                	jmp    803278 <alloc_block_FF+0x3c5>
  803273:	b8 00 00 00 00       	mov    $0x0,%eax
  803278:	a3 34 60 80 00       	mov    %eax,0x806034
  80327d:	a1 34 60 80 00       	mov    0x806034,%eax
  803282:	85 c0                	test   %eax,%eax
  803284:	0f 85 e9 fc ff ff    	jne    802f73 <alloc_block_FF+0xc0>
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	0f 85 df fc ff ff    	jne    802f73 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	83 c0 08             	add    $0x8,%eax
  80329a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80329d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8032a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032aa:	01 d0                	add    %edx,%eax
  8032ac:	48                   	dec    %eax
  8032ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8032b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8032b8:	f7 75 d8             	divl   -0x28(%ebp)
  8032bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032be:	29 d0                	sub    %edx,%eax
  8032c0:	c1 e8 0c             	shr    $0xc,%eax
  8032c3:	83 ec 0c             	sub    $0xc,%esp
  8032c6:	50                   	push   %eax
  8032c7:	e8 0b ed ff ff       	call   801fd7 <sbrk>
  8032cc:	83 c4 10             	add    $0x10,%esp
  8032cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8032d2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8032d6:	75 0a                	jne    8032e2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dd:	e9 8b 00 00 00       	jmp    80336d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032e2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8032e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ef:	01 d0                	add    %edx,%eax
  8032f1:	48                   	dec    %eax
  8032f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8032f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032fd:	f7 75 cc             	divl   -0x34(%ebp)
  803300:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803303:	29 d0                	sub    %edx,%eax
  803305:	8d 50 fc             	lea    -0x4(%eax),%edx
  803308:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803312:	a1 40 60 80 00       	mov    0x806040,%eax
  803317:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80331d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803324:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803327:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80332a:	01 d0                	add    %edx,%eax
  80332c:	48                   	dec    %eax
  80332d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803330:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803333:	ba 00 00 00 00       	mov    $0x0,%edx
  803338:	f7 75 c4             	divl   -0x3c(%ebp)
  80333b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80333e:	29 d0                	sub    %edx,%eax
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	6a 01                	push   $0x1
  803345:	50                   	push   %eax
  803346:	ff 75 d0             	pushl  -0x30(%ebp)
  803349:	e8 36 fb ff ff       	call   802e84 <set_block_data>
  80334e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803351:	83 ec 0c             	sub    $0xc,%esp
  803354:	ff 75 d0             	pushl  -0x30(%ebp)
  803357:	e8 f8 09 00 00       	call   803d54 <free_block>
  80335c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80335f:	83 ec 0c             	sub    $0xc,%esp
  803362:	ff 75 08             	pushl  0x8(%ebp)
  803365:	e8 49 fb ff ff       	call   802eb3 <alloc_block_FF>
  80336a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	83 e0 01             	and    $0x1,%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 03                	je     803382 <alloc_block_BF+0x13>
  80337f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803382:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803386:	77 07                	ja     80338f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803388:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80338f:	a1 24 60 80 00       	mov    0x806024,%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	75 73                	jne    80340b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	83 c0 10             	add    $0x10,%eax
  80339e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8033a1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8033a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ae:	01 d0                	add    %edx,%eax
  8033b0:	48                   	dec    %eax
  8033b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8033bc:	f7 75 e0             	divl   -0x20(%ebp)
  8033bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033c2:	29 d0                	sub    %edx,%eax
  8033c4:	c1 e8 0c             	shr    $0xc,%eax
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	50                   	push   %eax
  8033cb:	e8 07 ec ff ff       	call   801fd7 <sbrk>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8033d6:	83 ec 0c             	sub    $0xc,%esp
  8033d9:	6a 00                	push   $0x0
  8033db:	e8 f7 eb ff ff       	call   801fd7 <sbrk>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8033e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8033ec:	83 ec 08             	sub    $0x8,%esp
  8033ef:	50                   	push   %eax
  8033f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8033f3:	e8 9f f8 ff ff       	call   802c97 <initialize_dynamic_allocator>
  8033f8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8033fb:	83 ec 0c             	sub    $0xc,%esp
  8033fe:	68 7f 50 80 00       	push   $0x80507f
  803403:	e8 35 de ff ff       	call   80123d <cprintf>
  803408:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80340b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803419:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803420:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803427:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80342c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80342f:	e9 1d 01 00 00       	jmp    803551 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80343a:	83 ec 0c             	sub    $0xc,%esp
  80343d:	ff 75 a8             	pushl  -0x58(%ebp)
  803440:	e8 ee f6 ff ff       	call   802b33 <get_block_size>
  803445:	83 c4 10             	add    $0x10,%esp
  803448:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	83 c0 08             	add    $0x8,%eax
  803451:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803454:	0f 87 ef 00 00 00    	ja     803549 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	83 c0 18             	add    $0x18,%eax
  803460:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803463:	77 1d                	ja     803482 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803468:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80346b:	0f 86 d8 00 00 00    	jbe    803549 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803471:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803474:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803477:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80347a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80347d:	e9 c7 00 00 00       	jmp    803549 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	83 c0 08             	add    $0x8,%eax
  803488:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80348b:	0f 85 9d 00 00 00    	jne    80352e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	6a 01                	push   $0x1
  803496:	ff 75 a4             	pushl  -0x5c(%ebp)
  803499:	ff 75 a8             	pushl  -0x58(%ebp)
  80349c:	e8 e3 f9 ff ff       	call   802e84 <set_block_data>
  8034a1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	75 17                	jne    8034c1 <alloc_block_BF+0x152>
  8034aa:	83 ec 04             	sub    $0x4,%esp
  8034ad:	68 23 50 80 00       	push   $0x805023
  8034b2:	68 2c 01 00 00       	push   $0x12c
  8034b7:	68 41 50 80 00       	push   $0x805041
  8034bc:	e8 bf da ff ff       	call   800f80 <_panic>
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 10                	je     8034da <alloc_block_BF+0x16b>
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d2:	8b 52 04             	mov    0x4(%edx),%edx
  8034d5:	89 50 04             	mov    %edx,0x4(%eax)
  8034d8:	eb 0b                	jmp    8034e5 <alloc_block_BF+0x176>
  8034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dd:	8b 40 04             	mov    0x4(%eax),%eax
  8034e0:	a3 30 60 80 00       	mov    %eax,0x806030
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	85 c0                	test   %eax,%eax
  8034ed:	74 0f                	je     8034fe <alloc_block_BF+0x18f>
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f8:	8b 12                	mov    (%edx),%edx
  8034fa:	89 10                	mov    %edx,(%eax)
  8034fc:	eb 0a                	jmp    803508 <alloc_block_BF+0x199>
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351b:	a1 38 60 80 00       	mov    0x806038,%eax
  803520:	48                   	dec    %eax
  803521:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803526:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803529:	e9 01 04 00 00       	jmp    80392f <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80352e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803531:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803534:	76 13                	jbe    803549 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803536:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80353d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803540:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803543:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803546:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803549:	a1 34 60 80 00       	mov    0x806034,%eax
  80354e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803555:	74 07                	je     80355e <alloc_block_BF+0x1ef>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	eb 05                	jmp    803563 <alloc_block_BF+0x1f4>
  80355e:	b8 00 00 00 00       	mov    $0x0,%eax
  803563:	a3 34 60 80 00       	mov    %eax,0x806034
  803568:	a1 34 60 80 00       	mov    0x806034,%eax
  80356d:	85 c0                	test   %eax,%eax
  80356f:	0f 85 bf fe ff ff    	jne    803434 <alloc_block_BF+0xc5>
  803575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803579:	0f 85 b5 fe ff ff    	jne    803434 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80357f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803583:	0f 84 26 02 00 00    	je     8037af <alloc_block_BF+0x440>
  803589:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80358d:	0f 85 1c 02 00 00    	jne    8037af <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803596:	2b 45 08             	sub    0x8(%ebp),%eax
  803599:	83 e8 08             	sub    $0x8,%eax
  80359c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	8d 50 08             	lea    0x8(%eax),%edx
  8035a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a8:	01 d0                	add    %edx,%eax
  8035aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	83 c0 08             	add    $0x8,%eax
  8035b3:	83 ec 04             	sub    $0x4,%esp
  8035b6:	6a 01                	push   $0x1
  8035b8:	50                   	push   %eax
  8035b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8035bc:	e8 c3 f8 ff ff       	call   802e84 <set_block_data>
  8035c1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8035c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	75 68                	jne    803636 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8035ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035d2:	75 17                	jne    8035eb <alloc_block_BF+0x27c>
  8035d4:	83 ec 04             	sub    $0x4,%esp
  8035d7:	68 5c 50 80 00       	push   $0x80505c
  8035dc:	68 45 01 00 00       	push   $0x145
  8035e1:	68 41 50 80 00       	push   $0x805041
  8035e6:	e8 95 d9 ff ff       	call   800f80 <_panic>
  8035eb:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8035f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 0d                	je     80360c <alloc_block_BF+0x29d>
  8035ff:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803604:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803607:	89 50 04             	mov    %edx,0x4(%eax)
  80360a:	eb 08                	jmp    803614 <alloc_block_BF+0x2a5>
  80360c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80360f:	a3 30 60 80 00       	mov    %eax,0x806030
  803614:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803617:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80361c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80361f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803626:	a1 38 60 80 00       	mov    0x806038,%eax
  80362b:	40                   	inc    %eax
  80362c:	a3 38 60 80 00       	mov    %eax,0x806038
  803631:	e9 dc 00 00 00       	jmp    803712 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803639:	8b 00                	mov    (%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	75 65                	jne    8036a4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80363f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803643:	75 17                	jne    80365c <alloc_block_BF+0x2ed>
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	68 90 50 80 00       	push   $0x805090
  80364d:	68 4a 01 00 00       	push   $0x14a
  803652:	68 41 50 80 00       	push   $0x805041
  803657:	e8 24 d9 ff ff       	call   800f80 <_panic>
  80365c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803662:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80366b:	8b 40 04             	mov    0x4(%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 0c                	je     80367e <alloc_block_BF+0x30f>
  803672:	a1 30 60 80 00       	mov    0x806030,%eax
  803677:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	eb 08                	jmp    803686 <alloc_block_BF+0x317>
  80367e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803681:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803686:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803689:	a3 30 60 80 00       	mov    %eax,0x806030
  80368e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803697:	a1 38 60 80 00       	mov    0x806038,%eax
  80369c:	40                   	inc    %eax
  80369d:	a3 38 60 80 00       	mov    %eax,0x806038
  8036a2:	eb 6e                	jmp    803712 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8036a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a8:	74 06                	je     8036b0 <alloc_block_BF+0x341>
  8036aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036ae:	75 17                	jne    8036c7 <alloc_block_BF+0x358>
  8036b0:	83 ec 04             	sub    $0x4,%esp
  8036b3:	68 b4 50 80 00       	push   $0x8050b4
  8036b8:	68 4f 01 00 00       	push   $0x14f
  8036bd:	68 41 50 80 00       	push   $0x805041
  8036c2:	e8 b9 d8 ff ff       	call   800f80 <_panic>
  8036c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ca:	8b 10                	mov    (%eax),%edx
  8036cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036cf:	89 10                	mov    %edx,(%eax)
  8036d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	74 0b                	je     8036e5 <alloc_block_BF+0x376>
  8036da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036e2:	89 50 04             	mov    %edx,0x4(%eax)
  8036e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
  8036f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	75 08                	jne    803707 <alloc_block_BF+0x398>
  8036ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803702:	a3 30 60 80 00       	mov    %eax,0x806030
  803707:	a1 38 60 80 00       	mov    0x806038,%eax
  80370c:	40                   	inc    %eax
  80370d:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803712:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803716:	75 17                	jne    80372f <alloc_block_BF+0x3c0>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 23 50 80 00       	push   $0x805023
  803720:	68 51 01 00 00       	push   $0x151
  803725:	68 41 50 80 00       	push   $0x805041
  80372a:	e8 51 d8 ff ff       	call   800f80 <_panic>
  80372f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	74 10                	je     803748 <alloc_block_BF+0x3d9>
  803738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803740:	8b 52 04             	mov    0x4(%edx),%edx
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	eb 0b                	jmp    803753 <alloc_block_BF+0x3e4>
  803748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374b:	8b 40 04             	mov    0x4(%eax),%eax
  80374e:	a3 30 60 80 00       	mov    %eax,0x806030
  803753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803756:	8b 40 04             	mov    0x4(%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 0f                	je     80376c <alloc_block_BF+0x3fd>
  80375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803760:	8b 40 04             	mov    0x4(%eax),%eax
  803763:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803766:	8b 12                	mov    (%edx),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	eb 0a                	jmp    803776 <alloc_block_BF+0x407>
  80376c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803789:	a1 38 60 80 00       	mov    0x806038,%eax
  80378e:	48                   	dec    %eax
  80378f:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803794:	83 ec 04             	sub    $0x4,%esp
  803797:	6a 00                	push   $0x0
  803799:	ff 75 d0             	pushl  -0x30(%ebp)
  80379c:	ff 75 cc             	pushl  -0x34(%ebp)
  80379f:	e8 e0 f6 ff ff       	call   802e84 <set_block_data>
  8037a4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8037a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037aa:	e9 80 01 00 00       	jmp    80392f <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8037af:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8037b3:	0f 85 9d 00 00 00    	jne    803856 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8037b9:	83 ec 04             	sub    $0x4,%esp
  8037bc:	6a 01                	push   $0x1
  8037be:	ff 75 ec             	pushl  -0x14(%ebp)
  8037c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c4:	e8 bb f6 ff ff       	call   802e84 <set_block_data>
  8037c9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8037cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037d0:	75 17                	jne    8037e9 <alloc_block_BF+0x47a>
  8037d2:	83 ec 04             	sub    $0x4,%esp
  8037d5:	68 23 50 80 00       	push   $0x805023
  8037da:	68 58 01 00 00       	push   $0x158
  8037df:	68 41 50 80 00       	push   $0x805041
  8037e4:	e8 97 d7 ff ff       	call   800f80 <_panic>
  8037e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ec:	8b 00                	mov    (%eax),%eax
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	74 10                	je     803802 <alloc_block_BF+0x493>
  8037f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037fa:	8b 52 04             	mov    0x4(%edx),%edx
  8037fd:	89 50 04             	mov    %edx,0x4(%eax)
  803800:	eb 0b                	jmp    80380d <alloc_block_BF+0x49e>
  803802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803805:	8b 40 04             	mov    0x4(%eax),%eax
  803808:	a3 30 60 80 00       	mov    %eax,0x806030
  80380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803810:	8b 40 04             	mov    0x4(%eax),%eax
  803813:	85 c0                	test   %eax,%eax
  803815:	74 0f                	je     803826 <alloc_block_BF+0x4b7>
  803817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381a:	8b 40 04             	mov    0x4(%eax),%eax
  80381d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803820:	8b 12                	mov    (%edx),%edx
  803822:	89 10                	mov    %edx,(%eax)
  803824:	eb 0a                	jmp    803830 <alloc_block_BF+0x4c1>
  803826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803843:	a1 38 60 80 00       	mov    0x806038,%eax
  803848:	48                   	dec    %eax
  803849:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80384e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803851:	e9 d9 00 00 00       	jmp    80392f <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803856:	8b 45 08             	mov    0x8(%ebp),%eax
  803859:	83 c0 08             	add    $0x8,%eax
  80385c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80385f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803866:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803869:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80386c:	01 d0                	add    %edx,%eax
  80386e:	48                   	dec    %eax
  80386f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803872:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803875:	ba 00 00 00 00       	mov    $0x0,%edx
  80387a:	f7 75 c4             	divl   -0x3c(%ebp)
  80387d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803880:	29 d0                	sub    %edx,%eax
  803882:	c1 e8 0c             	shr    $0xc,%eax
  803885:	83 ec 0c             	sub    $0xc,%esp
  803888:	50                   	push   %eax
  803889:	e8 49 e7 ff ff       	call   801fd7 <sbrk>
  80388e:	83 c4 10             	add    $0x10,%esp
  803891:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803894:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803898:	75 0a                	jne    8038a4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80389a:	b8 00 00 00 00       	mov    $0x0,%eax
  80389f:	e9 8b 00 00 00       	jmp    80392f <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8038a4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8038ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b1:	01 d0                	add    %edx,%eax
  8038b3:	48                   	dec    %eax
  8038b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8038b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8038ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8038bf:	f7 75 b8             	divl   -0x48(%ebp)
  8038c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8038c5:	29 d0                	sub    %edx,%eax
  8038c7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8038ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8038cd:	01 d0                	add    %edx,%eax
  8038cf:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8038d4:	a1 40 60 80 00       	mov    0x806040,%eax
  8038d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8038df:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8038e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038ec:	01 d0                	add    %edx,%eax
  8038ee:	48                   	dec    %eax
  8038ef:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8038f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8038f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8038fa:	f7 75 b0             	divl   -0x50(%ebp)
  8038fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803900:	29 d0                	sub    %edx,%eax
  803902:	83 ec 04             	sub    $0x4,%esp
  803905:	6a 01                	push   $0x1
  803907:	50                   	push   %eax
  803908:	ff 75 bc             	pushl  -0x44(%ebp)
  80390b:	e8 74 f5 ff ff       	call   802e84 <set_block_data>
  803910:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803913:	83 ec 0c             	sub    $0xc,%esp
  803916:	ff 75 bc             	pushl  -0x44(%ebp)
  803919:	e8 36 04 00 00       	call   803d54 <free_block>
  80391e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803921:	83 ec 0c             	sub    $0xc,%esp
  803924:	ff 75 08             	pushl  0x8(%ebp)
  803927:	e8 43 fa ff ff       	call   80336f <alloc_block_BF>
  80392c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80392f:	c9                   	leave  
  803930:	c3                   	ret    

00803931 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803931:	55                   	push   %ebp
  803932:	89 e5                	mov    %esp,%ebp
  803934:	53                   	push   %ebx
  803935:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80393f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803946:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80394a:	74 1e                	je     80396a <merging+0x39>
  80394c:	ff 75 08             	pushl  0x8(%ebp)
  80394f:	e8 df f1 ff ff       	call   802b33 <get_block_size>
  803954:	83 c4 04             	add    $0x4,%esp
  803957:	89 c2                	mov    %eax,%edx
  803959:	8b 45 08             	mov    0x8(%ebp),%eax
  80395c:	01 d0                	add    %edx,%eax
  80395e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803961:	75 07                	jne    80396a <merging+0x39>
		prev_is_free = 1;
  803963:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80396a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80396e:	74 1e                	je     80398e <merging+0x5d>
  803970:	ff 75 10             	pushl  0x10(%ebp)
  803973:	e8 bb f1 ff ff       	call   802b33 <get_block_size>
  803978:	83 c4 04             	add    $0x4,%esp
  80397b:	89 c2                	mov    %eax,%edx
  80397d:	8b 45 10             	mov    0x10(%ebp),%eax
  803980:	01 d0                	add    %edx,%eax
  803982:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803985:	75 07                	jne    80398e <merging+0x5d>
		next_is_free = 1;
  803987:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80398e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803992:	0f 84 cc 00 00 00    	je     803a64 <merging+0x133>
  803998:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80399c:	0f 84 c2 00 00 00    	je     803a64 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8039a2:	ff 75 08             	pushl  0x8(%ebp)
  8039a5:	e8 89 f1 ff ff       	call   802b33 <get_block_size>
  8039aa:	83 c4 04             	add    $0x4,%esp
  8039ad:	89 c3                	mov    %eax,%ebx
  8039af:	ff 75 10             	pushl  0x10(%ebp)
  8039b2:	e8 7c f1 ff ff       	call   802b33 <get_block_size>
  8039b7:	83 c4 04             	add    $0x4,%esp
  8039ba:	01 c3                	add    %eax,%ebx
  8039bc:	ff 75 0c             	pushl  0xc(%ebp)
  8039bf:	e8 6f f1 ff ff       	call   802b33 <get_block_size>
  8039c4:	83 c4 04             	add    $0x4,%esp
  8039c7:	01 d8                	add    %ebx,%eax
  8039c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8039cc:	6a 00                	push   $0x0
  8039ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8039d1:	ff 75 08             	pushl  0x8(%ebp)
  8039d4:	e8 ab f4 ff ff       	call   802e84 <set_block_data>
  8039d9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8039dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039e0:	75 17                	jne    8039f9 <merging+0xc8>
  8039e2:	83 ec 04             	sub    $0x4,%esp
  8039e5:	68 23 50 80 00       	push   $0x805023
  8039ea:	68 7d 01 00 00       	push   $0x17d
  8039ef:	68 41 50 80 00       	push   $0x805041
  8039f4:	e8 87 d5 ff ff       	call   800f80 <_panic>
  8039f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039fc:	8b 00                	mov    (%eax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	74 10                	je     803a12 <merging+0xe1>
  803a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a05:	8b 00                	mov    (%eax),%eax
  803a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a0a:	8b 52 04             	mov    0x4(%edx),%edx
  803a0d:	89 50 04             	mov    %edx,0x4(%eax)
  803a10:	eb 0b                	jmp    803a1d <merging+0xec>
  803a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a15:	8b 40 04             	mov    0x4(%eax),%eax
  803a18:	a3 30 60 80 00       	mov    %eax,0x806030
  803a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a20:	8b 40 04             	mov    0x4(%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 0f                	je     803a36 <merging+0x105>
  803a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a2a:	8b 40 04             	mov    0x4(%eax),%eax
  803a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a30:	8b 12                	mov    (%edx),%edx
  803a32:	89 10                	mov    %edx,(%eax)
  803a34:	eb 0a                	jmp    803a40 <merging+0x10f>
  803a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a53:	a1 38 60 80 00       	mov    0x806038,%eax
  803a58:	48                   	dec    %eax
  803a59:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803a5e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803a5f:	e9 ea 02 00 00       	jmp    803d4e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a68:	74 3b                	je     803aa5 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803a6a:	83 ec 0c             	sub    $0xc,%esp
  803a6d:	ff 75 08             	pushl  0x8(%ebp)
  803a70:	e8 be f0 ff ff       	call   802b33 <get_block_size>
  803a75:	83 c4 10             	add    $0x10,%esp
  803a78:	89 c3                	mov    %eax,%ebx
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	ff 75 10             	pushl  0x10(%ebp)
  803a80:	e8 ae f0 ff ff       	call   802b33 <get_block_size>
  803a85:	83 c4 10             	add    $0x10,%esp
  803a88:	01 d8                	add    %ebx,%eax
  803a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803a8d:	83 ec 04             	sub    $0x4,%esp
  803a90:	6a 00                	push   $0x0
  803a92:	ff 75 e8             	pushl  -0x18(%ebp)
  803a95:	ff 75 08             	pushl  0x8(%ebp)
  803a98:	e8 e7 f3 ff ff       	call   802e84 <set_block_data>
  803a9d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803aa0:	e9 a9 02 00 00       	jmp    803d4e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803aa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aa9:	0f 84 2d 01 00 00    	je     803bdc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803aaf:	83 ec 0c             	sub    $0xc,%esp
  803ab2:	ff 75 10             	pushl  0x10(%ebp)
  803ab5:	e8 79 f0 ff ff       	call   802b33 <get_block_size>
  803aba:	83 c4 10             	add    $0x10,%esp
  803abd:	89 c3                	mov    %eax,%ebx
  803abf:	83 ec 0c             	sub    $0xc,%esp
  803ac2:	ff 75 0c             	pushl  0xc(%ebp)
  803ac5:	e8 69 f0 ff ff       	call   802b33 <get_block_size>
  803aca:	83 c4 10             	add    $0x10,%esp
  803acd:	01 d8                	add    %ebx,%eax
  803acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803ad2:	83 ec 04             	sub    $0x4,%esp
  803ad5:	6a 00                	push   $0x0
  803ad7:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ada:	ff 75 10             	pushl  0x10(%ebp)
  803add:	e8 a2 f3 ff ff       	call   802e84 <set_block_data>
  803ae2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  803ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803aeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803aef:	74 06                	je     803af7 <merging+0x1c6>
  803af1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803af5:	75 17                	jne    803b0e <merging+0x1dd>
  803af7:	83 ec 04             	sub    $0x4,%esp
  803afa:	68 e8 50 80 00       	push   $0x8050e8
  803aff:	68 8d 01 00 00       	push   $0x18d
  803b04:	68 41 50 80 00       	push   $0x805041
  803b09:	e8 72 d4 ff ff       	call   800f80 <_panic>
  803b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b11:	8b 50 04             	mov    0x4(%eax),%edx
  803b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b17:	89 50 04             	mov    %edx,0x4(%eax)
  803b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b20:	89 10                	mov    %edx,(%eax)
  803b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b25:	8b 40 04             	mov    0x4(%eax),%eax
  803b28:	85 c0                	test   %eax,%eax
  803b2a:	74 0d                	je     803b39 <merging+0x208>
  803b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2f:	8b 40 04             	mov    0x4(%eax),%eax
  803b32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b35:	89 10                	mov    %edx,(%eax)
  803b37:	eb 08                	jmp    803b41 <merging+0x210>
  803b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b3c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b47:	89 50 04             	mov    %edx,0x4(%eax)
  803b4a:	a1 38 60 80 00       	mov    0x806038,%eax
  803b4f:	40                   	inc    %eax
  803b50:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803b55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b59:	75 17                	jne    803b72 <merging+0x241>
  803b5b:	83 ec 04             	sub    $0x4,%esp
  803b5e:	68 23 50 80 00       	push   $0x805023
  803b63:	68 8e 01 00 00       	push   $0x18e
  803b68:	68 41 50 80 00       	push   $0x805041
  803b6d:	e8 0e d4 ff ff       	call   800f80 <_panic>
  803b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b75:	8b 00                	mov    (%eax),%eax
  803b77:	85 c0                	test   %eax,%eax
  803b79:	74 10                	je     803b8b <merging+0x25a>
  803b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b83:	8b 52 04             	mov    0x4(%edx),%edx
  803b86:	89 50 04             	mov    %edx,0x4(%eax)
  803b89:	eb 0b                	jmp    803b96 <merging+0x265>
  803b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b8e:	8b 40 04             	mov    0x4(%eax),%eax
  803b91:	a3 30 60 80 00       	mov    %eax,0x806030
  803b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b99:	8b 40 04             	mov    0x4(%eax),%eax
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	74 0f                	je     803baf <merging+0x27e>
  803ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba3:	8b 40 04             	mov    0x4(%eax),%eax
  803ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ba9:	8b 12                	mov    (%edx),%edx
  803bab:	89 10                	mov    %edx,(%eax)
  803bad:	eb 0a                	jmp    803bb9 <merging+0x288>
  803baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb2:	8b 00                	mov    (%eax),%eax
  803bb4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bcc:	a1 38 60 80 00       	mov    0x806038,%eax
  803bd1:	48                   	dec    %eax
  803bd2:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bd7:	e9 72 01 00 00       	jmp    803d4e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  803bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803be6:	74 79                	je     803c61 <merging+0x330>
  803be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bec:	74 73                	je     803c61 <merging+0x330>
  803bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf2:	74 06                	je     803bfa <merging+0x2c9>
  803bf4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803bf8:	75 17                	jne    803c11 <merging+0x2e0>
  803bfa:	83 ec 04             	sub    $0x4,%esp
  803bfd:	68 b4 50 80 00       	push   $0x8050b4
  803c02:	68 94 01 00 00       	push   $0x194
  803c07:	68 41 50 80 00       	push   $0x805041
  803c0c:	e8 6f d3 ff ff       	call   800f80 <_panic>
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	8b 10                	mov    (%eax),%edx
  803c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c19:	89 10                	mov    %edx,(%eax)
  803c1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c1e:	8b 00                	mov    (%eax),%eax
  803c20:	85 c0                	test   %eax,%eax
  803c22:	74 0b                	je     803c2f <merging+0x2fe>
  803c24:	8b 45 08             	mov    0x8(%ebp),%eax
  803c27:	8b 00                	mov    (%eax),%eax
  803c29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c2c:	89 50 04             	mov    %edx,0x4(%eax)
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c35:	89 10                	mov    %edx,(%eax)
  803c37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c3d:	89 50 04             	mov    %edx,0x4(%eax)
  803c40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c43:	8b 00                	mov    (%eax),%eax
  803c45:	85 c0                	test   %eax,%eax
  803c47:	75 08                	jne    803c51 <merging+0x320>
  803c49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c4c:	a3 30 60 80 00       	mov    %eax,0x806030
  803c51:	a1 38 60 80 00       	mov    0x806038,%eax
  803c56:	40                   	inc    %eax
  803c57:	a3 38 60 80 00       	mov    %eax,0x806038
  803c5c:	e9 ce 00 00 00       	jmp    803d2f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803c61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c65:	74 65                	je     803ccc <merging+0x39b>
  803c67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c6b:	75 17                	jne    803c84 <merging+0x353>
  803c6d:	83 ec 04             	sub    $0x4,%esp
  803c70:	68 90 50 80 00       	push   $0x805090
  803c75:	68 95 01 00 00       	push   $0x195
  803c7a:	68 41 50 80 00       	push   $0x805041
  803c7f:	e8 fc d2 ff ff       	call   800f80 <_panic>
  803c84:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8d:	89 50 04             	mov    %edx,0x4(%eax)
  803c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c93:	8b 40 04             	mov    0x4(%eax),%eax
  803c96:	85 c0                	test   %eax,%eax
  803c98:	74 0c                	je     803ca6 <merging+0x375>
  803c9a:	a1 30 60 80 00       	mov    0x806030,%eax
  803c9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ca2:	89 10                	mov    %edx,(%eax)
  803ca4:	eb 08                	jmp    803cae <merging+0x37d>
  803ca6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ca9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb1:	a3 30 60 80 00       	mov    %eax,0x806030
  803cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cbf:	a1 38 60 80 00       	mov    0x806038,%eax
  803cc4:	40                   	inc    %eax
  803cc5:	a3 38 60 80 00       	mov    %eax,0x806038
  803cca:	eb 63                	jmp    803d2f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803ccc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cd0:	75 17                	jne    803ce9 <merging+0x3b8>
  803cd2:	83 ec 04             	sub    $0x4,%esp
  803cd5:	68 5c 50 80 00       	push   $0x80505c
  803cda:	68 98 01 00 00       	push   $0x198
  803cdf:	68 41 50 80 00       	push   $0x805041
  803ce4:	e8 97 d2 ff ff       	call   800f80 <_panic>
  803ce9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803cef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf2:	89 10                	mov    %edx,(%eax)
  803cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	85 c0                	test   %eax,%eax
  803cfb:	74 0d                	je     803d0a <merging+0x3d9>
  803cfd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d05:	89 50 04             	mov    %edx,0x4(%eax)
  803d08:	eb 08                	jmp    803d12 <merging+0x3e1>
  803d0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d0d:	a3 30 60 80 00       	mov    %eax,0x806030
  803d12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d15:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d24:	a1 38 60 80 00       	mov    0x806038,%eax
  803d29:	40                   	inc    %eax
  803d2a:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803d2f:	83 ec 0c             	sub    $0xc,%esp
  803d32:	ff 75 10             	pushl  0x10(%ebp)
  803d35:	e8 f9 ed ff ff       	call   802b33 <get_block_size>
  803d3a:	83 c4 10             	add    $0x10,%esp
  803d3d:	83 ec 04             	sub    $0x4,%esp
  803d40:	6a 00                	push   $0x0
  803d42:	50                   	push   %eax
  803d43:	ff 75 10             	pushl  0x10(%ebp)
  803d46:	e8 39 f1 ff ff       	call   802e84 <set_block_data>
  803d4b:	83 c4 10             	add    $0x10,%esp
	}
}
  803d4e:	90                   	nop
  803d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803d52:	c9                   	leave  
  803d53:	c3                   	ret    

00803d54 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803d54:	55                   	push   %ebp
  803d55:	89 e5                	mov    %esp,%ebp
  803d57:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803d5a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803d62:	a1 30 60 80 00       	mov    0x806030,%eax
  803d67:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d6a:	73 1b                	jae    803d87 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803d6c:	a1 30 60 80 00       	mov    0x806030,%eax
  803d71:	83 ec 04             	sub    $0x4,%esp
  803d74:	ff 75 08             	pushl  0x8(%ebp)
  803d77:	6a 00                	push   $0x0
  803d79:	50                   	push   %eax
  803d7a:	e8 b2 fb ff ff       	call   803931 <merging>
  803d7f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803d82:	e9 8b 00 00 00       	jmp    803e12 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803d87:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d8f:	76 18                	jbe    803da9 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803d91:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d96:	83 ec 04             	sub    $0x4,%esp
  803d99:	ff 75 08             	pushl  0x8(%ebp)
  803d9c:	50                   	push   %eax
  803d9d:	6a 00                	push   $0x0
  803d9f:	e8 8d fb ff ff       	call   803931 <merging>
  803da4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803da7:	eb 69                	jmp    803e12 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803da9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803db1:	eb 39                	jmp    803dec <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803db9:	73 29                	jae    803de4 <free_block+0x90>
  803dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbe:	8b 00                	mov    (%eax),%eax
  803dc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dc3:	76 1f                	jbe    803de4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	8b 00                	mov    (%eax),%eax
  803dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803dcd:	83 ec 04             	sub    $0x4,%esp
  803dd0:	ff 75 08             	pushl  0x8(%ebp)
  803dd3:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd6:	ff 75 f4             	pushl  -0xc(%ebp)
  803dd9:	e8 53 fb ff ff       	call   803931 <merging>
  803dde:	83 c4 10             	add    $0x10,%esp
			break;
  803de1:	90                   	nop
		}
	}
}
  803de2:	eb 2e                	jmp    803e12 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803de4:	a1 34 60 80 00       	mov    0x806034,%eax
  803de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df0:	74 07                	je     803df9 <free_block+0xa5>
  803df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df5:	8b 00                	mov    (%eax),%eax
  803df7:	eb 05                	jmp    803dfe <free_block+0xaa>
  803df9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfe:	a3 34 60 80 00       	mov    %eax,0x806034
  803e03:	a1 34 60 80 00       	mov    0x806034,%eax
  803e08:	85 c0                	test   %eax,%eax
  803e0a:	75 a7                	jne    803db3 <free_block+0x5f>
  803e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e10:	75 a1                	jne    803db3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e12:	90                   	nop
  803e13:	c9                   	leave  
  803e14:	c3                   	ret    

00803e15 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803e15:	55                   	push   %ebp
  803e16:	89 e5                	mov    %esp,%ebp
  803e18:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803e1b:	ff 75 08             	pushl  0x8(%ebp)
  803e1e:	e8 10 ed ff ff       	call   802b33 <get_block_size>
  803e23:	83 c4 04             	add    $0x4,%esp
  803e26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803e29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803e30:	eb 17                	jmp    803e49 <copy_data+0x34>
  803e32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e38:	01 c2                	add    %eax,%edx
  803e3a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e40:	01 c8                	add    %ecx,%eax
  803e42:	8a 00                	mov    (%eax),%al
  803e44:	88 02                	mov    %al,(%edx)
  803e46:	ff 45 fc             	incl   -0x4(%ebp)
  803e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803e4f:	72 e1                	jb     803e32 <copy_data+0x1d>
}
  803e51:	90                   	nop
  803e52:	c9                   	leave  
  803e53:	c3                   	ret    

00803e54 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803e54:	55                   	push   %ebp
  803e55:	89 e5                	mov    %esp,%ebp
  803e57:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e5e:	75 23                	jne    803e83 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803e60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e64:	74 13                	je     803e79 <realloc_block_FF+0x25>
  803e66:	83 ec 0c             	sub    $0xc,%esp
  803e69:	ff 75 0c             	pushl  0xc(%ebp)
  803e6c:	e8 42 f0 ff ff       	call   802eb3 <alloc_block_FF>
  803e71:	83 c4 10             	add    $0x10,%esp
  803e74:	e9 e4 06 00 00       	jmp    80455d <realloc_block_FF+0x709>
		return NULL;
  803e79:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7e:	e9 da 06 00 00       	jmp    80455d <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e87:	75 18                	jne    803ea1 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803e89:	83 ec 0c             	sub    $0xc,%esp
  803e8c:	ff 75 08             	pushl  0x8(%ebp)
  803e8f:	e8 c0 fe ff ff       	call   803d54 <free_block>
  803e94:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803e97:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9c:	e9 bc 06 00 00       	jmp    80455d <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803ea1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ea5:	77 07                	ja     803eae <realloc_block_FF+0x5a>
  803ea7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb1:	83 e0 01             	and    $0x1,%eax
  803eb4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eba:	83 c0 08             	add    $0x8,%eax
  803ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ec0:	83 ec 0c             	sub    $0xc,%esp
  803ec3:	ff 75 08             	pushl  0x8(%ebp)
  803ec6:	e8 68 ec ff ff       	call   802b33 <get_block_size>
  803ecb:	83 c4 10             	add    $0x10,%esp
  803ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed4:	83 e8 08             	sub    $0x8,%eax
  803ed7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803eda:	8b 45 08             	mov    0x8(%ebp),%eax
  803edd:	83 e8 04             	sub    $0x4,%eax
  803ee0:	8b 00                	mov    (%eax),%eax
  803ee2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ee5:	89 c2                	mov    %eax,%edx
  803ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eea:	01 d0                	add    %edx,%eax
  803eec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803eef:	83 ec 0c             	sub    $0xc,%esp
  803ef2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ef5:	e8 39 ec ff ff       	call   802b33 <get_block_size>
  803efa:	83 c4 10             	add    $0x10,%esp
  803efd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f03:	83 e8 08             	sub    $0x8,%eax
  803f06:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f0f:	75 08                	jne    803f19 <realloc_block_FF+0xc5>
	{
		 return va;
  803f11:	8b 45 08             	mov    0x8(%ebp),%eax
  803f14:	e9 44 06 00 00       	jmp    80455d <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f1f:	0f 83 d5 03 00 00    	jae    8042fa <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f28:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803f2e:	83 ec 0c             	sub    $0xc,%esp
  803f31:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f34:	e8 13 ec ff ff       	call   802b4c <is_free_block>
  803f39:	83 c4 10             	add    $0x10,%esp
  803f3c:	84 c0                	test   %al,%al
  803f3e:	0f 84 3b 01 00 00    	je     80407f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f4a:	01 d0                	add    %edx,%eax
  803f4c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803f4f:	83 ec 04             	sub    $0x4,%esp
  803f52:	6a 01                	push   $0x1
  803f54:	ff 75 f0             	pushl  -0x10(%ebp)
  803f57:	ff 75 08             	pushl  0x8(%ebp)
  803f5a:	e8 25 ef ff ff       	call   802e84 <set_block_data>
  803f5f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803f62:	8b 45 08             	mov    0x8(%ebp),%eax
  803f65:	83 e8 04             	sub    $0x4,%eax
  803f68:	8b 00                	mov    (%eax),%eax
  803f6a:	83 e0 fe             	and    $0xfffffffe,%eax
  803f6d:	89 c2                	mov    %eax,%edx
  803f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f72:	01 d0                	add    %edx,%eax
  803f74:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803f77:	83 ec 04             	sub    $0x4,%esp
  803f7a:	6a 00                	push   $0x0
  803f7c:	ff 75 cc             	pushl  -0x34(%ebp)
  803f7f:	ff 75 c8             	pushl  -0x38(%ebp)
  803f82:	e8 fd ee ff ff       	call   802e84 <set_block_data>
  803f87:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f8e:	74 06                	je     803f96 <realloc_block_FF+0x142>
  803f90:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803f94:	75 17                	jne    803fad <realloc_block_FF+0x159>
  803f96:	83 ec 04             	sub    $0x4,%esp
  803f99:	68 b4 50 80 00       	push   $0x8050b4
  803f9e:	68 f6 01 00 00       	push   $0x1f6
  803fa3:	68 41 50 80 00       	push   $0x805041
  803fa8:	e8 d3 cf ff ff       	call   800f80 <_panic>
  803fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb0:	8b 10                	mov    (%eax),%edx
  803fb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fb5:	89 10                	mov    %edx,(%eax)
  803fb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fba:	8b 00                	mov    (%eax),%eax
  803fbc:	85 c0                	test   %eax,%eax
  803fbe:	74 0b                	je     803fcb <realloc_block_FF+0x177>
  803fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc3:	8b 00                	mov    (%eax),%eax
  803fc5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fc8:	89 50 04             	mov    %edx,0x4(%eax)
  803fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fd1:	89 10                	mov    %edx,(%eax)
  803fd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd9:	89 50 04             	mov    %edx,0x4(%eax)
  803fdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fdf:	8b 00                	mov    (%eax),%eax
  803fe1:	85 c0                	test   %eax,%eax
  803fe3:	75 08                	jne    803fed <realloc_block_FF+0x199>
  803fe5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fe8:	a3 30 60 80 00       	mov    %eax,0x806030
  803fed:	a1 38 60 80 00       	mov    0x806038,%eax
  803ff2:	40                   	inc    %eax
  803ff3:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ffc:	75 17                	jne    804015 <realloc_block_FF+0x1c1>
  803ffe:	83 ec 04             	sub    $0x4,%esp
  804001:	68 23 50 80 00       	push   $0x805023
  804006:	68 f7 01 00 00       	push   $0x1f7
  80400b:	68 41 50 80 00       	push   $0x805041
  804010:	e8 6b cf ff ff       	call   800f80 <_panic>
  804015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804018:	8b 00                	mov    (%eax),%eax
  80401a:	85 c0                	test   %eax,%eax
  80401c:	74 10                	je     80402e <realloc_block_FF+0x1da>
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804026:	8b 52 04             	mov    0x4(%edx),%edx
  804029:	89 50 04             	mov    %edx,0x4(%eax)
  80402c:	eb 0b                	jmp    804039 <realloc_block_FF+0x1e5>
  80402e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804031:	8b 40 04             	mov    0x4(%eax),%eax
  804034:	a3 30 60 80 00       	mov    %eax,0x806030
  804039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403c:	8b 40 04             	mov    0x4(%eax),%eax
  80403f:	85 c0                	test   %eax,%eax
  804041:	74 0f                	je     804052 <realloc_block_FF+0x1fe>
  804043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804046:	8b 40 04             	mov    0x4(%eax),%eax
  804049:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404c:	8b 12                	mov    (%edx),%edx
  80404e:	89 10                	mov    %edx,(%eax)
  804050:	eb 0a                	jmp    80405c <realloc_block_FF+0x208>
  804052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804055:	8b 00                	mov    (%eax),%eax
  804057:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80405c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804068:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80406f:	a1 38 60 80 00       	mov    0x806038,%eax
  804074:	48                   	dec    %eax
  804075:	a3 38 60 80 00       	mov    %eax,0x806038
  80407a:	e9 73 02 00 00       	jmp    8042f2 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80407f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804083:	0f 86 69 02 00 00    	jbe    8042f2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804089:	83 ec 04             	sub    $0x4,%esp
  80408c:	6a 01                	push   $0x1
  80408e:	ff 75 f0             	pushl  -0x10(%ebp)
  804091:	ff 75 08             	pushl  0x8(%ebp)
  804094:	e8 eb ed ff ff       	call   802e84 <set_block_data>
  804099:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80409c:	8b 45 08             	mov    0x8(%ebp),%eax
  80409f:	83 e8 04             	sub    $0x4,%eax
  8040a2:	8b 00                	mov    (%eax),%eax
  8040a4:	83 e0 fe             	and    $0xfffffffe,%eax
  8040a7:	89 c2                	mov    %eax,%edx
  8040a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ac:	01 d0                	add    %edx,%eax
  8040ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8040b1:	a1 38 60 80 00       	mov    0x806038,%eax
  8040b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8040b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8040bd:	75 68                	jne    804127 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8040bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8040c3:	75 17                	jne    8040dc <realloc_block_FF+0x288>
  8040c5:	83 ec 04             	sub    $0x4,%esp
  8040c8:	68 5c 50 80 00       	push   $0x80505c
  8040cd:	68 06 02 00 00       	push   $0x206
  8040d2:	68 41 50 80 00       	push   $0x805041
  8040d7:	e8 a4 ce ff ff       	call   800f80 <_panic>
  8040dc:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8040e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040e5:	89 10                	mov    %edx,(%eax)
  8040e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040ea:	8b 00                	mov    (%eax),%eax
  8040ec:	85 c0                	test   %eax,%eax
  8040ee:	74 0d                	je     8040fd <realloc_block_FF+0x2a9>
  8040f0:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8040f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8040f8:	89 50 04             	mov    %edx,0x4(%eax)
  8040fb:	eb 08                	jmp    804105 <realloc_block_FF+0x2b1>
  8040fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804100:	a3 30 60 80 00       	mov    %eax,0x806030
  804105:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804108:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80410d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804110:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804117:	a1 38 60 80 00       	mov    0x806038,%eax
  80411c:	40                   	inc    %eax
  80411d:	a3 38 60 80 00       	mov    %eax,0x806038
  804122:	e9 b0 01 00 00       	jmp    8042d7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804127:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80412c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80412f:	76 68                	jbe    804199 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804131:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804135:	75 17                	jne    80414e <realloc_block_FF+0x2fa>
  804137:	83 ec 04             	sub    $0x4,%esp
  80413a:	68 5c 50 80 00       	push   $0x80505c
  80413f:	68 0b 02 00 00       	push   $0x20b
  804144:	68 41 50 80 00       	push   $0x805041
  804149:	e8 32 ce ff ff       	call   800f80 <_panic>
  80414e:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804154:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804157:	89 10                	mov    %edx,(%eax)
  804159:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80415c:	8b 00                	mov    (%eax),%eax
  80415e:	85 c0                	test   %eax,%eax
  804160:	74 0d                	je     80416f <realloc_block_FF+0x31b>
  804162:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804167:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80416a:	89 50 04             	mov    %edx,0x4(%eax)
  80416d:	eb 08                	jmp    804177 <realloc_block_FF+0x323>
  80416f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804172:	a3 30 60 80 00       	mov    %eax,0x806030
  804177:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80417a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80417f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804189:	a1 38 60 80 00       	mov    0x806038,%eax
  80418e:	40                   	inc    %eax
  80418f:	a3 38 60 80 00       	mov    %eax,0x806038
  804194:	e9 3e 01 00 00       	jmp    8042d7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804199:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80419e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041a1:	73 68                	jae    80420b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041a7:	75 17                	jne    8041c0 <realloc_block_FF+0x36c>
  8041a9:	83 ec 04             	sub    $0x4,%esp
  8041ac:	68 90 50 80 00       	push   $0x805090
  8041b1:	68 10 02 00 00       	push   $0x210
  8041b6:	68 41 50 80 00       	push   $0x805041
  8041bb:	e8 c0 cd ff ff       	call   800f80 <_panic>
  8041c0:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8041c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c9:	89 50 04             	mov    %edx,0x4(%eax)
  8041cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041cf:	8b 40 04             	mov    0x4(%eax),%eax
  8041d2:	85 c0                	test   %eax,%eax
  8041d4:	74 0c                	je     8041e2 <realloc_block_FF+0x38e>
  8041d6:	a1 30 60 80 00       	mov    0x806030,%eax
  8041db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041de:	89 10                	mov    %edx,(%eax)
  8041e0:	eb 08                	jmp    8041ea <realloc_block_FF+0x396>
  8041e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041ed:	a3 30 60 80 00       	mov    %eax,0x806030
  8041f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041fb:	a1 38 60 80 00       	mov    0x806038,%eax
  804200:	40                   	inc    %eax
  804201:	a3 38 60 80 00       	mov    %eax,0x806038
  804206:	e9 cc 00 00 00       	jmp    8042d7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80420b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804212:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80421a:	e9 8a 00 00 00       	jmp    8042a9 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80421f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804222:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804225:	73 7a                	jae    8042a1 <realloc_block_FF+0x44d>
  804227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422a:	8b 00                	mov    (%eax),%eax
  80422c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80422f:	73 70                	jae    8042a1 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804235:	74 06                	je     80423d <realloc_block_FF+0x3e9>
  804237:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80423b:	75 17                	jne    804254 <realloc_block_FF+0x400>
  80423d:	83 ec 04             	sub    $0x4,%esp
  804240:	68 b4 50 80 00       	push   $0x8050b4
  804245:	68 1a 02 00 00       	push   $0x21a
  80424a:	68 41 50 80 00       	push   $0x805041
  80424f:	e8 2c cd ff ff       	call   800f80 <_panic>
  804254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804257:	8b 10                	mov    (%eax),%edx
  804259:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80425c:	89 10                	mov    %edx,(%eax)
  80425e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804261:	8b 00                	mov    (%eax),%eax
  804263:	85 c0                	test   %eax,%eax
  804265:	74 0b                	je     804272 <realloc_block_FF+0x41e>
  804267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426a:	8b 00                	mov    (%eax),%eax
  80426c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80426f:	89 50 04             	mov    %edx,0x4(%eax)
  804272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804275:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804278:	89 10                	mov    %edx,(%eax)
  80427a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80427d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804280:	89 50 04             	mov    %edx,0x4(%eax)
  804283:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804286:	8b 00                	mov    (%eax),%eax
  804288:	85 c0                	test   %eax,%eax
  80428a:	75 08                	jne    804294 <realloc_block_FF+0x440>
  80428c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80428f:	a3 30 60 80 00       	mov    %eax,0x806030
  804294:	a1 38 60 80 00       	mov    0x806038,%eax
  804299:	40                   	inc    %eax
  80429a:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  80429f:	eb 36                	jmp    8042d7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8042a1:	a1 34 60 80 00       	mov    0x806034,%eax
  8042a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ad:	74 07                	je     8042b6 <realloc_block_FF+0x462>
  8042af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b2:	8b 00                	mov    (%eax),%eax
  8042b4:	eb 05                	jmp    8042bb <realloc_block_FF+0x467>
  8042b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042bb:	a3 34 60 80 00       	mov    %eax,0x806034
  8042c0:	a1 34 60 80 00       	mov    0x806034,%eax
  8042c5:	85 c0                	test   %eax,%eax
  8042c7:	0f 85 52 ff ff ff    	jne    80421f <realloc_block_FF+0x3cb>
  8042cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042d1:	0f 85 48 ff ff ff    	jne    80421f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8042d7:	83 ec 04             	sub    $0x4,%esp
  8042da:	6a 00                	push   $0x0
  8042dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8042df:	ff 75 d4             	pushl  -0x2c(%ebp)
  8042e2:	e8 9d eb ff ff       	call   802e84 <set_block_data>
  8042e7:	83 c4 10             	add    $0x10,%esp
				return va;
  8042ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ed:	e9 6b 02 00 00       	jmp    80455d <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8042f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f5:	e9 63 02 00 00       	jmp    80455d <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8042fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804300:	0f 86 4d 02 00 00    	jbe    804553 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  804306:	83 ec 0c             	sub    $0xc,%esp
  804309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80430c:	e8 3b e8 ff ff       	call   802b4c <is_free_block>
  804311:	83 c4 10             	add    $0x10,%esp
  804314:	84 c0                	test   %al,%al
  804316:	0f 84 37 02 00 00    	je     804553 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80431c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80431f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804322:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804325:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804328:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80432b:	76 38                	jbe    804365 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80432d:	83 ec 0c             	sub    $0xc,%esp
  804330:	ff 75 0c             	pushl  0xc(%ebp)
  804333:	e8 7b eb ff ff       	call   802eb3 <alloc_block_FF>
  804338:	83 c4 10             	add    $0x10,%esp
  80433b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80433e:	83 ec 08             	sub    $0x8,%esp
  804341:	ff 75 c0             	pushl  -0x40(%ebp)
  804344:	ff 75 08             	pushl  0x8(%ebp)
  804347:	e8 c9 fa ff ff       	call   803e15 <copy_data>
  80434c:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80434f:	83 ec 0c             	sub    $0xc,%esp
  804352:	ff 75 08             	pushl  0x8(%ebp)
  804355:	e8 fa f9 ff ff       	call   803d54 <free_block>
  80435a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80435d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804360:	e9 f8 01 00 00       	jmp    80455d <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804368:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80436b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80436e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804372:	0f 87 a0 00 00 00    	ja     804418 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804378:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80437c:	75 17                	jne    804395 <realloc_block_FF+0x541>
  80437e:	83 ec 04             	sub    $0x4,%esp
  804381:	68 23 50 80 00       	push   $0x805023
  804386:	68 38 02 00 00       	push   $0x238
  80438b:	68 41 50 80 00       	push   $0x805041
  804390:	e8 eb cb ff ff       	call   800f80 <_panic>
  804395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804398:	8b 00                	mov    (%eax),%eax
  80439a:	85 c0                	test   %eax,%eax
  80439c:	74 10                	je     8043ae <realloc_block_FF+0x55a>
  80439e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043a1:	8b 00                	mov    (%eax),%eax
  8043a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043a6:	8b 52 04             	mov    0x4(%edx),%edx
  8043a9:	89 50 04             	mov    %edx,0x4(%eax)
  8043ac:	eb 0b                	jmp    8043b9 <realloc_block_FF+0x565>
  8043ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043b1:	8b 40 04             	mov    0x4(%eax),%eax
  8043b4:	a3 30 60 80 00       	mov    %eax,0x806030
  8043b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043bc:	8b 40 04             	mov    0x4(%eax),%eax
  8043bf:	85 c0                	test   %eax,%eax
  8043c1:	74 0f                	je     8043d2 <realloc_block_FF+0x57e>
  8043c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043c6:	8b 40 04             	mov    0x4(%eax),%eax
  8043c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043cc:	8b 12                	mov    (%edx),%edx
  8043ce:	89 10                	mov    %edx,(%eax)
  8043d0:	eb 0a                	jmp    8043dc <realloc_block_FF+0x588>
  8043d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043d5:	8b 00                	mov    (%eax),%eax
  8043d7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043ef:	a1 38 60 80 00       	mov    0x806038,%eax
  8043f4:	48                   	dec    %eax
  8043f5:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8043fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804400:	01 d0                	add    %edx,%eax
  804402:	83 ec 04             	sub    $0x4,%esp
  804405:	6a 01                	push   $0x1
  804407:	50                   	push   %eax
  804408:	ff 75 08             	pushl  0x8(%ebp)
  80440b:	e8 74 ea ff ff       	call   802e84 <set_block_data>
  804410:	83 c4 10             	add    $0x10,%esp
  804413:	e9 36 01 00 00       	jmp    80454e <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804418:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80441b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80441e:	01 d0                	add    %edx,%eax
  804420:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804423:	83 ec 04             	sub    $0x4,%esp
  804426:	6a 01                	push   $0x1
  804428:	ff 75 f0             	pushl  -0x10(%ebp)
  80442b:	ff 75 08             	pushl  0x8(%ebp)
  80442e:	e8 51 ea ff ff       	call   802e84 <set_block_data>
  804433:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804436:	8b 45 08             	mov    0x8(%ebp),%eax
  804439:	83 e8 04             	sub    $0x4,%eax
  80443c:	8b 00                	mov    (%eax),%eax
  80443e:	83 e0 fe             	and    $0xfffffffe,%eax
  804441:	89 c2                	mov    %eax,%edx
  804443:	8b 45 08             	mov    0x8(%ebp),%eax
  804446:	01 d0                	add    %edx,%eax
  804448:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80444b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80444f:	74 06                	je     804457 <realloc_block_FF+0x603>
  804451:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804455:	75 17                	jne    80446e <realloc_block_FF+0x61a>
  804457:	83 ec 04             	sub    $0x4,%esp
  80445a:	68 b4 50 80 00       	push   $0x8050b4
  80445f:	68 44 02 00 00       	push   $0x244
  804464:	68 41 50 80 00       	push   $0x805041
  804469:	e8 12 cb ff ff       	call   800f80 <_panic>
  80446e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804471:	8b 10                	mov    (%eax),%edx
  804473:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804476:	89 10                	mov    %edx,(%eax)
  804478:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80447b:	8b 00                	mov    (%eax),%eax
  80447d:	85 c0                	test   %eax,%eax
  80447f:	74 0b                	je     80448c <realloc_block_FF+0x638>
  804481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804484:	8b 00                	mov    (%eax),%eax
  804486:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804489:	89 50 04             	mov    %edx,0x4(%eax)
  80448c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80448f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804492:	89 10                	mov    %edx,(%eax)
  804494:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804497:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80449a:	89 50 04             	mov    %edx,0x4(%eax)
  80449d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044a0:	8b 00                	mov    (%eax),%eax
  8044a2:	85 c0                	test   %eax,%eax
  8044a4:	75 08                	jne    8044ae <realloc_block_FF+0x65a>
  8044a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044a9:	a3 30 60 80 00       	mov    %eax,0x806030
  8044ae:	a1 38 60 80 00       	mov    0x806038,%eax
  8044b3:	40                   	inc    %eax
  8044b4:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8044b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044bd:	75 17                	jne    8044d6 <realloc_block_FF+0x682>
  8044bf:	83 ec 04             	sub    $0x4,%esp
  8044c2:	68 23 50 80 00       	push   $0x805023
  8044c7:	68 45 02 00 00       	push   $0x245
  8044cc:	68 41 50 80 00       	push   $0x805041
  8044d1:	e8 aa ca ff ff       	call   800f80 <_panic>
  8044d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d9:	8b 00                	mov    (%eax),%eax
  8044db:	85 c0                	test   %eax,%eax
  8044dd:	74 10                	je     8044ef <realloc_block_FF+0x69b>
  8044df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e2:	8b 00                	mov    (%eax),%eax
  8044e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044e7:	8b 52 04             	mov    0x4(%edx),%edx
  8044ea:	89 50 04             	mov    %edx,0x4(%eax)
  8044ed:	eb 0b                	jmp    8044fa <realloc_block_FF+0x6a6>
  8044ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f2:	8b 40 04             	mov    0x4(%eax),%eax
  8044f5:	a3 30 60 80 00       	mov    %eax,0x806030
  8044fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044fd:	8b 40 04             	mov    0x4(%eax),%eax
  804500:	85 c0                	test   %eax,%eax
  804502:	74 0f                	je     804513 <realloc_block_FF+0x6bf>
  804504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804507:	8b 40 04             	mov    0x4(%eax),%eax
  80450a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80450d:	8b 12                	mov    (%edx),%edx
  80450f:	89 10                	mov    %edx,(%eax)
  804511:	eb 0a                	jmp    80451d <realloc_block_FF+0x6c9>
  804513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804516:	8b 00                	mov    (%eax),%eax
  804518:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80451d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804529:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804530:	a1 38 60 80 00       	mov    0x806038,%eax
  804535:	48                   	dec    %eax
  804536:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80453b:	83 ec 04             	sub    $0x4,%esp
  80453e:	6a 00                	push   $0x0
  804540:	ff 75 bc             	pushl  -0x44(%ebp)
  804543:	ff 75 b8             	pushl  -0x48(%ebp)
  804546:	e8 39 e9 ff ff       	call   802e84 <set_block_data>
  80454b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80454e:	8b 45 08             	mov    0x8(%ebp),%eax
  804551:	eb 0a                	jmp    80455d <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804553:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80455a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80455d:	c9                   	leave  
  80455e:	c3                   	ret    

0080455f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80455f:	55                   	push   %ebp
  804560:	89 e5                	mov    %esp,%ebp
  804562:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804565:	83 ec 04             	sub    $0x4,%esp
  804568:	68 20 51 80 00       	push   $0x805120
  80456d:	68 58 02 00 00       	push   $0x258
  804572:	68 41 50 80 00       	push   $0x805041
  804577:	e8 04 ca ff ff       	call   800f80 <_panic>

0080457c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80457c:	55                   	push   %ebp
  80457d:	89 e5                	mov    %esp,%ebp
  80457f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804582:	83 ec 04             	sub    $0x4,%esp
  804585:	68 48 51 80 00       	push   $0x805148
  80458a:	68 61 02 00 00       	push   $0x261
  80458f:	68 41 50 80 00       	push   $0x805041
  804594:	e8 e7 c9 ff ff       	call   800f80 <_panic>
  804599:	66 90                	xchg   %ax,%ax
  80459b:	90                   	nop

0080459c <__udivdi3>:
  80459c:	55                   	push   %ebp
  80459d:	57                   	push   %edi
  80459e:	56                   	push   %esi
  80459f:	53                   	push   %ebx
  8045a0:	83 ec 1c             	sub    $0x1c,%esp
  8045a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8045a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8045ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8045af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8045b3:	89 ca                	mov    %ecx,%edx
  8045b5:	89 f8                	mov    %edi,%eax
  8045b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8045bb:	85 f6                	test   %esi,%esi
  8045bd:	75 2d                	jne    8045ec <__udivdi3+0x50>
  8045bf:	39 cf                	cmp    %ecx,%edi
  8045c1:	77 65                	ja     804628 <__udivdi3+0x8c>
  8045c3:	89 fd                	mov    %edi,%ebp
  8045c5:	85 ff                	test   %edi,%edi
  8045c7:	75 0b                	jne    8045d4 <__udivdi3+0x38>
  8045c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ce:	31 d2                	xor    %edx,%edx
  8045d0:	f7 f7                	div    %edi
  8045d2:	89 c5                	mov    %eax,%ebp
  8045d4:	31 d2                	xor    %edx,%edx
  8045d6:	89 c8                	mov    %ecx,%eax
  8045d8:	f7 f5                	div    %ebp
  8045da:	89 c1                	mov    %eax,%ecx
  8045dc:	89 d8                	mov    %ebx,%eax
  8045de:	f7 f5                	div    %ebp
  8045e0:	89 cf                	mov    %ecx,%edi
  8045e2:	89 fa                	mov    %edi,%edx
  8045e4:	83 c4 1c             	add    $0x1c,%esp
  8045e7:	5b                   	pop    %ebx
  8045e8:	5e                   	pop    %esi
  8045e9:	5f                   	pop    %edi
  8045ea:	5d                   	pop    %ebp
  8045eb:	c3                   	ret    
  8045ec:	39 ce                	cmp    %ecx,%esi
  8045ee:	77 28                	ja     804618 <__udivdi3+0x7c>
  8045f0:	0f bd fe             	bsr    %esi,%edi
  8045f3:	83 f7 1f             	xor    $0x1f,%edi
  8045f6:	75 40                	jne    804638 <__udivdi3+0x9c>
  8045f8:	39 ce                	cmp    %ecx,%esi
  8045fa:	72 0a                	jb     804606 <__udivdi3+0x6a>
  8045fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804600:	0f 87 9e 00 00 00    	ja     8046a4 <__udivdi3+0x108>
  804606:	b8 01 00 00 00       	mov    $0x1,%eax
  80460b:	89 fa                	mov    %edi,%edx
  80460d:	83 c4 1c             	add    $0x1c,%esp
  804610:	5b                   	pop    %ebx
  804611:	5e                   	pop    %esi
  804612:	5f                   	pop    %edi
  804613:	5d                   	pop    %ebp
  804614:	c3                   	ret    
  804615:	8d 76 00             	lea    0x0(%esi),%esi
  804618:	31 ff                	xor    %edi,%edi
  80461a:	31 c0                	xor    %eax,%eax
  80461c:	89 fa                	mov    %edi,%edx
  80461e:	83 c4 1c             	add    $0x1c,%esp
  804621:	5b                   	pop    %ebx
  804622:	5e                   	pop    %esi
  804623:	5f                   	pop    %edi
  804624:	5d                   	pop    %ebp
  804625:	c3                   	ret    
  804626:	66 90                	xchg   %ax,%ax
  804628:	89 d8                	mov    %ebx,%eax
  80462a:	f7 f7                	div    %edi
  80462c:	31 ff                	xor    %edi,%edi
  80462e:	89 fa                	mov    %edi,%edx
  804630:	83 c4 1c             	add    $0x1c,%esp
  804633:	5b                   	pop    %ebx
  804634:	5e                   	pop    %esi
  804635:	5f                   	pop    %edi
  804636:	5d                   	pop    %ebp
  804637:	c3                   	ret    
  804638:	bd 20 00 00 00       	mov    $0x20,%ebp
  80463d:	89 eb                	mov    %ebp,%ebx
  80463f:	29 fb                	sub    %edi,%ebx
  804641:	89 f9                	mov    %edi,%ecx
  804643:	d3 e6                	shl    %cl,%esi
  804645:	89 c5                	mov    %eax,%ebp
  804647:	88 d9                	mov    %bl,%cl
  804649:	d3 ed                	shr    %cl,%ebp
  80464b:	89 e9                	mov    %ebp,%ecx
  80464d:	09 f1                	or     %esi,%ecx
  80464f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804653:	89 f9                	mov    %edi,%ecx
  804655:	d3 e0                	shl    %cl,%eax
  804657:	89 c5                	mov    %eax,%ebp
  804659:	89 d6                	mov    %edx,%esi
  80465b:	88 d9                	mov    %bl,%cl
  80465d:	d3 ee                	shr    %cl,%esi
  80465f:	89 f9                	mov    %edi,%ecx
  804661:	d3 e2                	shl    %cl,%edx
  804663:	8b 44 24 08          	mov    0x8(%esp),%eax
  804667:	88 d9                	mov    %bl,%cl
  804669:	d3 e8                	shr    %cl,%eax
  80466b:	09 c2                	or     %eax,%edx
  80466d:	89 d0                	mov    %edx,%eax
  80466f:	89 f2                	mov    %esi,%edx
  804671:	f7 74 24 0c          	divl   0xc(%esp)
  804675:	89 d6                	mov    %edx,%esi
  804677:	89 c3                	mov    %eax,%ebx
  804679:	f7 e5                	mul    %ebp
  80467b:	39 d6                	cmp    %edx,%esi
  80467d:	72 19                	jb     804698 <__udivdi3+0xfc>
  80467f:	74 0b                	je     80468c <__udivdi3+0xf0>
  804681:	89 d8                	mov    %ebx,%eax
  804683:	31 ff                	xor    %edi,%edi
  804685:	e9 58 ff ff ff       	jmp    8045e2 <__udivdi3+0x46>
  80468a:	66 90                	xchg   %ax,%ax
  80468c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804690:	89 f9                	mov    %edi,%ecx
  804692:	d3 e2                	shl    %cl,%edx
  804694:	39 c2                	cmp    %eax,%edx
  804696:	73 e9                	jae    804681 <__udivdi3+0xe5>
  804698:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80469b:	31 ff                	xor    %edi,%edi
  80469d:	e9 40 ff ff ff       	jmp    8045e2 <__udivdi3+0x46>
  8046a2:	66 90                	xchg   %ax,%ax
  8046a4:	31 c0                	xor    %eax,%eax
  8046a6:	e9 37 ff ff ff       	jmp    8045e2 <__udivdi3+0x46>
  8046ab:	90                   	nop

008046ac <__umoddi3>:
  8046ac:	55                   	push   %ebp
  8046ad:	57                   	push   %edi
  8046ae:	56                   	push   %esi
  8046af:	53                   	push   %ebx
  8046b0:	83 ec 1c             	sub    $0x1c,%esp
  8046b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8046b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8046bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8046c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8046c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8046cb:	89 f3                	mov    %esi,%ebx
  8046cd:	89 fa                	mov    %edi,%edx
  8046cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046d3:	89 34 24             	mov    %esi,(%esp)
  8046d6:	85 c0                	test   %eax,%eax
  8046d8:	75 1a                	jne    8046f4 <__umoddi3+0x48>
  8046da:	39 f7                	cmp    %esi,%edi
  8046dc:	0f 86 a2 00 00 00    	jbe    804784 <__umoddi3+0xd8>
  8046e2:	89 c8                	mov    %ecx,%eax
  8046e4:	89 f2                	mov    %esi,%edx
  8046e6:	f7 f7                	div    %edi
  8046e8:	89 d0                	mov    %edx,%eax
  8046ea:	31 d2                	xor    %edx,%edx
  8046ec:	83 c4 1c             	add    $0x1c,%esp
  8046ef:	5b                   	pop    %ebx
  8046f0:	5e                   	pop    %esi
  8046f1:	5f                   	pop    %edi
  8046f2:	5d                   	pop    %ebp
  8046f3:	c3                   	ret    
  8046f4:	39 f0                	cmp    %esi,%eax
  8046f6:	0f 87 ac 00 00 00    	ja     8047a8 <__umoddi3+0xfc>
  8046fc:	0f bd e8             	bsr    %eax,%ebp
  8046ff:	83 f5 1f             	xor    $0x1f,%ebp
  804702:	0f 84 ac 00 00 00    	je     8047b4 <__umoddi3+0x108>
  804708:	bf 20 00 00 00       	mov    $0x20,%edi
  80470d:	29 ef                	sub    %ebp,%edi
  80470f:	89 fe                	mov    %edi,%esi
  804711:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804715:	89 e9                	mov    %ebp,%ecx
  804717:	d3 e0                	shl    %cl,%eax
  804719:	89 d7                	mov    %edx,%edi
  80471b:	89 f1                	mov    %esi,%ecx
  80471d:	d3 ef                	shr    %cl,%edi
  80471f:	09 c7                	or     %eax,%edi
  804721:	89 e9                	mov    %ebp,%ecx
  804723:	d3 e2                	shl    %cl,%edx
  804725:	89 14 24             	mov    %edx,(%esp)
  804728:	89 d8                	mov    %ebx,%eax
  80472a:	d3 e0                	shl    %cl,%eax
  80472c:	89 c2                	mov    %eax,%edx
  80472e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804732:	d3 e0                	shl    %cl,%eax
  804734:	89 44 24 04          	mov    %eax,0x4(%esp)
  804738:	8b 44 24 08          	mov    0x8(%esp),%eax
  80473c:	89 f1                	mov    %esi,%ecx
  80473e:	d3 e8                	shr    %cl,%eax
  804740:	09 d0                	or     %edx,%eax
  804742:	d3 eb                	shr    %cl,%ebx
  804744:	89 da                	mov    %ebx,%edx
  804746:	f7 f7                	div    %edi
  804748:	89 d3                	mov    %edx,%ebx
  80474a:	f7 24 24             	mull   (%esp)
  80474d:	89 c6                	mov    %eax,%esi
  80474f:	89 d1                	mov    %edx,%ecx
  804751:	39 d3                	cmp    %edx,%ebx
  804753:	0f 82 87 00 00 00    	jb     8047e0 <__umoddi3+0x134>
  804759:	0f 84 91 00 00 00    	je     8047f0 <__umoddi3+0x144>
  80475f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804763:	29 f2                	sub    %esi,%edx
  804765:	19 cb                	sbb    %ecx,%ebx
  804767:	89 d8                	mov    %ebx,%eax
  804769:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80476d:	d3 e0                	shl    %cl,%eax
  80476f:	89 e9                	mov    %ebp,%ecx
  804771:	d3 ea                	shr    %cl,%edx
  804773:	09 d0                	or     %edx,%eax
  804775:	89 e9                	mov    %ebp,%ecx
  804777:	d3 eb                	shr    %cl,%ebx
  804779:	89 da                	mov    %ebx,%edx
  80477b:	83 c4 1c             	add    $0x1c,%esp
  80477e:	5b                   	pop    %ebx
  80477f:	5e                   	pop    %esi
  804780:	5f                   	pop    %edi
  804781:	5d                   	pop    %ebp
  804782:	c3                   	ret    
  804783:	90                   	nop
  804784:	89 fd                	mov    %edi,%ebp
  804786:	85 ff                	test   %edi,%edi
  804788:	75 0b                	jne    804795 <__umoddi3+0xe9>
  80478a:	b8 01 00 00 00       	mov    $0x1,%eax
  80478f:	31 d2                	xor    %edx,%edx
  804791:	f7 f7                	div    %edi
  804793:	89 c5                	mov    %eax,%ebp
  804795:	89 f0                	mov    %esi,%eax
  804797:	31 d2                	xor    %edx,%edx
  804799:	f7 f5                	div    %ebp
  80479b:	89 c8                	mov    %ecx,%eax
  80479d:	f7 f5                	div    %ebp
  80479f:	89 d0                	mov    %edx,%eax
  8047a1:	e9 44 ff ff ff       	jmp    8046ea <__umoddi3+0x3e>
  8047a6:	66 90                	xchg   %ax,%ax
  8047a8:	89 c8                	mov    %ecx,%eax
  8047aa:	89 f2                	mov    %esi,%edx
  8047ac:	83 c4 1c             	add    $0x1c,%esp
  8047af:	5b                   	pop    %ebx
  8047b0:	5e                   	pop    %esi
  8047b1:	5f                   	pop    %edi
  8047b2:	5d                   	pop    %ebp
  8047b3:	c3                   	ret    
  8047b4:	3b 04 24             	cmp    (%esp),%eax
  8047b7:	72 06                	jb     8047bf <__umoddi3+0x113>
  8047b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8047bd:	77 0f                	ja     8047ce <__umoddi3+0x122>
  8047bf:	89 f2                	mov    %esi,%edx
  8047c1:	29 f9                	sub    %edi,%ecx
  8047c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8047c7:	89 14 24             	mov    %edx,(%esp)
  8047ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8047d2:	8b 14 24             	mov    (%esp),%edx
  8047d5:	83 c4 1c             	add    $0x1c,%esp
  8047d8:	5b                   	pop    %ebx
  8047d9:	5e                   	pop    %esi
  8047da:	5f                   	pop    %edi
  8047db:	5d                   	pop    %ebp
  8047dc:	c3                   	ret    
  8047dd:	8d 76 00             	lea    0x0(%esi),%esi
  8047e0:	2b 04 24             	sub    (%esp),%eax
  8047e3:	19 fa                	sbb    %edi,%edx
  8047e5:	89 d1                	mov    %edx,%ecx
  8047e7:	89 c6                	mov    %eax,%esi
  8047e9:	e9 71 ff ff ff       	jmp    80475f <__umoddi3+0xb3>
  8047ee:	66 90                	xchg   %ax,%ax
  8047f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047f4:	72 ea                	jb     8047e0 <__umoddi3+0x134>
  8047f6:	89 d9                	mov    %ebx,%ecx
  8047f8:	e9 62 ff ff ff       	jmp    80475f <__umoddi3+0xb3>
