
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
  800050:	a1 04 40 80 00       	mov    0x804004,%eax
  800055:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800079:	a1 04 40 80 00       	mov    0x804004,%eax
  80007e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800094:	68 a0 29 80 00       	push   $0x8029a0
  800099:	6a 1a                	push   $0x1a
  80009b:	68 bc 29 80 00       	push   $0x8029bc
  8000a0:	e8 d3 0e 00 00       	call   800f78 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 36 1f 00 00       	call   801fe5 <malloc>
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
  8000e2:	e8 32 21 00 00       	call   802219 <sys_calculate_free_frames>
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
  8000fe:	e8 61 21 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800103:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 ce 1e 00 00       	call   801fe5 <malloc>
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
  80013a:	68 d0 29 80 00       	push   $0x8029d0
  80013f:	6a 39                	push   $0x39
  800141:	68 bc 29 80 00       	push   $0x8029bc
  800146:	e8 2d 0e 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 14 21 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 38 2a 80 00       	push   $0x802a38
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 bc 29 80 00       	push   $0x8029bc
  800164:	e8 0f 0e 00 00       	call   800f78 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 ab 20 00 00       	call   802219 <sys_calculate_free_frames>
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
  80019e:	e8 76 20 00 00       	call   802219 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 68 2a 80 00       	push   $0x802a68
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 bc 29 80 00       	push   $0x8029bc
  8001bb:	e8 b8 0d 00 00       	call   800f78 <_panic>
		int var;
		int found = 0;
  8001c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	e9 82 00 00 00       	jmp    800255 <_main+0x21d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8001d8:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800210:	a1 04 40 80 00       	mov    0x804004,%eax
  800215:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800255:	a1 04 40 80 00       	mov    0x804004,%eax
  80025a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800274:	68 ac 2a 80 00       	push   $0x802aac
  800279:	6a 4b                	push   $0x4b
  80027b:	68 bc 29 80 00       	push   $0x8029bc
  800280:	e8 f3 0c 00 00       	call   800f78 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 da 1f 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  80028a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800290:	01 c0                	add    %eax,%eax
  800292:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	50                   	push   %eax
  800299:	e8 47 1d 00 00       	call   801fe5 <malloc>
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
  8002d6:	68 d0 29 80 00       	push   $0x8029d0
  8002db:	6a 50                	push   $0x50
  8002dd:	68 bc 29 80 00       	push   $0x8029bc
  8002e2:	e8 91 0c 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 78 1f 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 38 2a 80 00       	push   $0x802a38
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 bc 29 80 00       	push   $0x8029bc
  800300:	e8 73 0c 00 00       	call   800f78 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 0f 1f 00 00       	call   802219 <sys_calculate_free_frames>
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
  800343:	e8 d1 1e 00 00       	call   802219 <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 68 2a 80 00       	push   $0x802a68
  800359:	6a 58                	push   $0x58
  80035b:	68 bc 29 80 00       	push   $0x8029bc
  800360:	e8 13 0c 00 00       	call   800f78 <_panic>
		found = 0;
  800365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80036c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800373:	e9 86 00 00 00       	jmp    8003fe <_main+0x3c6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800378:	a1 04 40 80 00       	mov    0x804004,%eax
  80037d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8003b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8003ba:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8003fe:	a1 04 40 80 00       	mov    0x804004,%eax
  800403:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  80041d:	68 ac 2a 80 00       	push   $0x802aac
  800422:	6a 61                	push   $0x61
  800424:	68 bc 29 80 00       	push   $0x8029bc
  800429:	e8 4a 0b 00 00       	call   800f78 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 31 1e 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800433:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	01 d2                	add    %edx,%edx
  80043d:	01 d0                	add    %edx,%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 9d 1b 00 00       	call   801fe5 <malloc>
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
  800482:	68 d0 29 80 00       	push   $0x8029d0
  800487:	6a 66                	push   $0x66
  800489:	68 bc 29 80 00       	push   $0x8029bc
  80048e:	e8 e5 0a 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 cc 1d 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 38 2a 80 00       	push   $0x802a38
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 bc 29 80 00       	push   $0x8029bc
  8004ac:	e8 c7 0a 00 00       	call   800f78 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 63 1d 00 00       	call   802219 <sys_calculate_free_frames>
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
  8004ed:	e8 27 1d 00 00       	call   802219 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 68 2a 80 00       	push   $0x802a68
  800503:	6a 6e                	push   $0x6e
  800505:	68 bc 29 80 00       	push   $0x8029bc
  80050a:	e8 69 0a 00 00       	call   800f78 <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 8f 00 00 00       	jmp    8005b1 <_main+0x579>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 04 40 80 00       	mov    0x804004,%eax
  800527:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  80055f:	a1 04 40 80 00       	mov    0x804004,%eax
  800564:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8005b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8005b6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  8005d0:	68 ac 2a 80 00       	push   $0x802aac
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 bc 29 80 00       	push   $0x8029bc
  8005dc:	e8 97 09 00 00       	call   800f78 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 33 1c 00 00       	call   802219 <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 76 1c 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  8005ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f4:	89 c2                	mov    %eax,%edx
  8005f6:	01 d2                	add    %edx,%edx
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 e2 19 00 00       	call   801fe5 <malloc>
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
  800651:	68 d0 29 80 00       	push   $0x8029d0
  800656:	6a 7d                	push   $0x7d
  800658:	68 bc 29 80 00       	push   $0x8029bc
  80065d:	e8 16 09 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 fd 1b 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 38 2a 80 00       	push   $0x802a38
  800674:	6a 7e                	push   $0x7e
  800676:	68 bc 29 80 00       	push   $0x8029bc
  80067b:	e8 f8 08 00 00       	call   800f78 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 df 1b 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
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
  800699:	e8 47 19 00 00       	call   801fe5 <malloc>
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
  8006ec:	68 d0 29 80 00       	push   $0x8029d0
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 bc 29 80 00       	push   $0x8029bc
  8006fb:	e8 78 08 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 5f 1b 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 38 2a 80 00       	push   $0x802a38
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 bc 29 80 00       	push   $0x8029bc
  80071c:	e8 57 08 00 00       	call   800f78 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 f3 1a 00 00       	call   802219 <sys_calculate_free_frames>
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
  8007c5:	e8 4f 1a 00 00       	call   802219 <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 68 2a 80 00       	push   $0x802a68
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 bc 29 80 00       	push   $0x8029bc
  8007e5:	e8 8e 07 00 00       	call   800f78 <_panic>
		found = 0;
  8007ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007f8:	e9 aa 00 00 00       	jmp    8008a7 <_main+0x86f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007fd:	a1 04 40 80 00       	mov    0x804004,%eax
  800802:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800849:	a1 04 40 80 00       	mov    0x804004,%eax
  80084e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8008a7:	a1 04 40 80 00       	mov    0x804004,%eax
  8008ac:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  8008c6:	68 ac 2a 80 00       	push   $0x802aac
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 bc 29 80 00       	push   $0x8029bc
  8008d5:	e8 9e 06 00 00       	call   800f78 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 3a 19 00 00       	call   802219 <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 7d 19 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  8008e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	01 d2                	add    %edx,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	83 ec 0c             	sub    $0xc,%esp
  8008f9:	50                   	push   %eax
  8008fa:	e8 e6 16 00 00       	call   801fe5 <malloc>
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
  80094d:	68 d0 29 80 00       	push   $0x8029d0
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 bc 29 80 00       	push   $0x8029bc
  80095c:	e8 17 06 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 fe 18 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 38 2a 80 00       	push   $0x802a38
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 bc 29 80 00       	push   $0x8029bc
  80097d:	e8 f6 05 00 00       	call   800f78 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 dd 18 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
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
  80099c:	e8 44 16 00 00       	call   801fe5 <malloc>
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
  8009fd:	68 d0 29 80 00       	push   $0x8029d0
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 bc 29 80 00       	push   $0x8029bc
  800a0c:	e8 67 05 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 4e 18 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 38 2a 80 00       	push   $0x802a38
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 bc 29 80 00       	push   $0x8029bc
  800a2d:	e8 46 05 00 00       	call   800f78 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 e2 17 00 00       	call   802219 <sys_calculate_free_frames>
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
  800aa3:	e8 71 17 00 00       	call   802219 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 68 2a 80 00       	push   $0x802a68
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 bc 29 80 00       	push   $0x8029bc
  800ac3:	e8 b0 04 00 00       	call   800f78 <_panic>
		found = 0;
  800ac8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ad6:	e9 02 01 00 00       	jmp    800bdd <_main+0xba5>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800adb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800b27:	a1 04 40 80 00       	mov    0x804004,%eax
  800b2c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800b86:	a1 04 40 80 00       	mov    0x804004,%eax
  800b8b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800bdd:	a1 04 40 80 00       	mov    0x804004,%eax
  800be2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800bfc:	68 ac 2a 80 00       	push   $0x802aac
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 bc 29 80 00       	push   $0x8029bc
  800c0b:	e8 68 03 00 00       	call   800f78 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 4f 16 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
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
  800c2b:	e8 b5 13 00 00       	call   801fe5 <malloc>
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
  800c8e:	68 d0 29 80 00       	push   $0x8029d0
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 bc 29 80 00       	push   $0x8029bc
  800c9d:	e8 d6 02 00 00       	call   800f78 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 bd 15 00 00       	call   802264 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 38 2a 80 00       	push   $0x802a38
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 bc 29 80 00       	push   $0x8029bc
  800cbe:	e8 b5 02 00 00       	call   800f78 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 51 15 00 00       	call   802219 <sys_calculate_free_frames>
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
  800d17:	e8 fd 14 00 00       	call   802219 <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 68 2a 80 00       	push   $0x802a68
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 bc 29 80 00       	push   $0x8029bc
  800d37:	e8 3c 02 00 00       	call   800f78 <_panic>
		found = 0;
  800d3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d4a:	e9 a7 00 00 00       	jmp    800df6 <_main+0xdbe>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d4f:	a1 04 40 80 00       	mov    0x804004,%eax
  800d54:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800d9b:	a1 04 40 80 00       	mov    0x804004,%eax
  800da0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800df6:	a1 04 40 80 00       	mov    0x804004,%eax
  800dfb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800e15:	68 ac 2a 80 00       	push   $0x802aac
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 bc 29 80 00       	push   $0x8029bc
  800e24:	e8 4f 01 00 00       	call   800f78 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 cc 2a 80 00       	push   $0x802acc
  800e31:	e8 ff 03 00 00       	call   801235 <cprintf>
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
  800e47:	e8 96 15 00 00       	call   8023e2 <sys_getenvindex>
  800e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	c1 e0 02             	shl    $0x2,%eax
  800e57:	01 d0                	add    %edx,%eax
  800e59:	01 c0                	add    %eax,%eax
  800e5b:	01 d0                	add    %edx,%eax
  800e5d:	c1 e0 02             	shl    $0x2,%eax
  800e60:	01 d0                	add    %edx,%eax
  800e62:	01 c0                	add    %eax,%eax
  800e64:	01 d0                	add    %edx,%eax
  800e66:	c1 e0 04             	shl    $0x4,%eax
  800e69:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e6e:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e73:	a1 04 40 80 00       	mov    0x804004,%eax
  800e78:	8a 40 20             	mov    0x20(%eax),%al
  800e7b:	84 c0                	test   %al,%al
  800e7d:	74 0d                	je     800e8c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800e7f:	a1 04 40 80 00       	mov    0x804004,%eax
  800e84:	83 c0 20             	add    $0x20,%eax
  800e87:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e90:	7e 0a                	jle    800e9c <libmain+0x5b>
		binaryname = argv[0];
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	8b 00                	mov    (%eax),%eax
  800e97:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800e9c:	83 ec 08             	sub    $0x8,%esp
  800e9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ea2:	ff 75 08             	pushl  0x8(%ebp)
  800ea5:	e8 8e f1 ff ff       	call   800038 <_main>
  800eaa:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800ead:	e8 b4 12 00 00       	call   802166 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	68 20 2b 80 00       	push   $0x802b20
  800eba:	e8 76 03 00 00       	call   801235 <cprintf>
  800ebf:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ec2:	a1 04 40 80 00       	mov    0x804004,%eax
  800ec7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800ecd:	a1 04 40 80 00       	mov    0x804004,%eax
  800ed2:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800ed8:	83 ec 04             	sub    $0x4,%esp
  800edb:	52                   	push   %edx
  800edc:	50                   	push   %eax
  800edd:	68 48 2b 80 00       	push   $0x802b48
  800ee2:	e8 4e 03 00 00       	call   801235 <cprintf>
  800ee7:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eea:	a1 04 40 80 00       	mov    0x804004,%eax
  800eef:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800ef5:	a1 04 40 80 00       	mov    0x804004,%eax
  800efa:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800f00:	a1 04 40 80 00       	mov    0x804004,%eax
  800f05:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800f0b:	51                   	push   %ecx
  800f0c:	52                   	push   %edx
  800f0d:	50                   	push   %eax
  800f0e:	68 70 2b 80 00       	push   $0x802b70
  800f13:	e8 1d 03 00 00       	call   801235 <cprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f1b:	a1 04 40 80 00       	mov    0x804004,%eax
  800f20:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	50                   	push   %eax
  800f2a:	68 c8 2b 80 00       	push   $0x802bc8
  800f2f:	e8 01 03 00 00       	call   801235 <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	68 20 2b 80 00       	push   $0x802b20
  800f3f:	e8 f1 02 00 00       	call   801235 <cprintf>
  800f44:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f47:	e8 34 12 00 00       	call   802180 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800f4c:	e8 19 00 00 00       	call   800f6a <exit>
}
  800f51:	90                   	nop
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	6a 00                	push   $0x0
  800f5f:	e8 4a 14 00 00       	call   8023ae <sys_destroy_env>
  800f64:	83 c4 10             	add    $0x10,%esp
}
  800f67:	90                   	nop
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <exit>:

void
exit(void)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f70:	e8 9f 14 00 00       	call   802414 <sys_exit_env>
}
  800f75:	90                   	nop
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f81:	83 c0 04             	add    $0x4,%eax
  800f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f87:	a1 2c 40 80 00       	mov    0x80402c,%eax
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	74 16                	je     800fa6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f90:	a1 2c 40 80 00       	mov    0x80402c,%eax
  800f95:	83 ec 08             	sub    $0x8,%esp
  800f98:	50                   	push   %eax
  800f99:	68 dc 2b 80 00       	push   $0x802bdc
  800f9e:	e8 92 02 00 00       	call   801235 <cprintf>
  800fa3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fa6:	a1 00 40 80 00       	mov    0x804000,%eax
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	ff 75 08             	pushl  0x8(%ebp)
  800fb1:	50                   	push   %eax
  800fb2:	68 e1 2b 80 00       	push   $0x802be1
  800fb7:	e8 79 02 00 00       	call   801235 <cprintf>
  800fbc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc8:	50                   	push   %eax
  800fc9:	e8 fc 01 00 00       	call   8011ca <vcprintf>
  800fce:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fd1:	83 ec 08             	sub    $0x8,%esp
  800fd4:	6a 00                	push   $0x0
  800fd6:	68 fd 2b 80 00       	push   $0x802bfd
  800fdb:	e8 ea 01 00 00       	call   8011ca <vcprintf>
  800fe0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fe3:	e8 82 ff ff ff       	call   800f6a <exit>

	// should not return here
	while (1) ;
  800fe8:	eb fe                	jmp    800fe8 <_panic+0x70>

00800fea <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ff0:	a1 04 40 80 00       	mov    0x804004,%eax
  800ff5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	39 c2                	cmp    %eax,%edx
  801000:	74 14                	je     801016 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	68 00 2c 80 00       	push   $0x802c00
  80100a:	6a 26                	push   $0x26
  80100c:	68 4c 2c 80 00       	push   $0x802c4c
  801011:	e8 62 ff ff ff       	call   800f78 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80101d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801024:	e9 c5 00 00 00       	jmp    8010ee <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8b 00                	mov    (%eax),%eax
  80103a:	85 c0                	test   %eax,%eax
  80103c:	75 08                	jne    801046 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80103e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801041:	e9 a5 00 00 00       	jmp    8010eb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80104d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801054:	eb 69                	jmp    8010bf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801056:	a1 04 40 80 00       	mov    0x804004,%eax
  80105b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801061:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801064:	89 d0                	mov    %edx,%eax
  801066:	01 c0                	add    %eax,%eax
  801068:	01 d0                	add    %edx,%eax
  80106a:	c1 e0 03             	shl    $0x3,%eax
  80106d:	01 c8                	add    %ecx,%eax
  80106f:	8a 40 04             	mov    0x4(%eax),%al
  801072:	84 c0                	test   %al,%al
  801074:	75 46                	jne    8010bc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801076:	a1 04 40 80 00       	mov    0x804004,%eax
  80107b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801081:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801084:	89 d0                	mov    %edx,%eax
  801086:	01 c0                	add    %eax,%eax
  801088:	01 d0                	add    %edx,%eax
  80108a:	c1 e0 03             	shl    $0x3,%eax
  80108d:	01 c8                	add    %ecx,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80109c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010af:	39 c2                	cmp    %eax,%edx
  8010b1:	75 09                	jne    8010bc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010b3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010ba:	eb 15                	jmp    8010d1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010bc:	ff 45 e8             	incl   -0x18(%ebp)
  8010bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8010c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8010ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010cd:	39 c2                	cmp    %eax,%edx
  8010cf:	77 85                	ja     801056 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010d5:	75 14                	jne    8010eb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010d7:	83 ec 04             	sub    $0x4,%esp
  8010da:	68 58 2c 80 00       	push   $0x802c58
  8010df:	6a 3a                	push   $0x3a
  8010e1:	68 4c 2c 80 00       	push   $0x802c4c
  8010e6:	e8 8d fe ff ff       	call   800f78 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010eb:	ff 45 f0             	incl   -0x10(%ebp)
  8010ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010f4:	0f 8c 2f ff ff ff    	jl     801029 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801101:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801108:	eb 26                	jmp    801130 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80110a:	a1 04 40 80 00       	mov    0x804004,%eax
  80110f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801115:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801118:	89 d0                	mov    %edx,%eax
  80111a:	01 c0                	add    %eax,%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	c1 e0 03             	shl    $0x3,%eax
  801121:	01 c8                	add    %ecx,%eax
  801123:	8a 40 04             	mov    0x4(%eax),%al
  801126:	3c 01                	cmp    $0x1,%al
  801128:	75 03                	jne    80112d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80112a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80112d:	ff 45 e0             	incl   -0x20(%ebp)
  801130:	a1 04 40 80 00       	mov    0x804004,%eax
  801135:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80113b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80113e:	39 c2                	cmp    %eax,%edx
  801140:	77 c8                	ja     80110a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801145:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801148:	74 14                	je     80115e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80114a:	83 ec 04             	sub    $0x4,%esp
  80114d:	68 ac 2c 80 00       	push   $0x802cac
  801152:	6a 44                	push   $0x44
  801154:	68 4c 2c 80 00       	push   $0x802c4c
  801159:	e8 1a fe ff ff       	call   800f78 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80115e:	90                   	nop
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	8d 48 01             	lea    0x1(%eax),%ecx
  80116f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801172:	89 0a                	mov    %ecx,(%edx)
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	88 d1                	mov    %dl,%cl
  801179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8b 00                	mov    (%eax),%eax
  801185:	3d ff 00 00 00       	cmp    $0xff,%eax
  80118a:	75 2c                	jne    8011b8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80118c:	a0 08 40 80 00       	mov    0x804008,%al
  801191:	0f b6 c0             	movzbl %al,%eax
  801194:	8b 55 0c             	mov    0xc(%ebp),%edx
  801197:	8b 12                	mov    (%edx),%edx
  801199:	89 d1                	mov    %edx,%ecx
  80119b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119e:	83 c2 08             	add    $0x8,%edx
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	50                   	push   %eax
  8011a5:	51                   	push   %ecx
  8011a6:	52                   	push   %edx
  8011a7:	e8 78 0f 00 00       	call   802124 <sys_cputs>
  8011ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	8b 40 04             	mov    0x4(%eax),%eax
  8011be:	8d 50 01             	lea    0x1(%eax),%edx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011c7:	90                   	nop
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011da:	00 00 00 
	b.cnt = 0;
  8011dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011e4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	ff 75 08             	pushl  0x8(%ebp)
  8011ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	68 61 11 80 00       	push   $0x801161
  8011f9:	e8 11 02 00 00       	call   80140f <vprintfmt>
  8011fe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801201:	a0 08 40 80 00       	mov    0x804008,%al
  801206:	0f b6 c0             	movzbl %al,%eax
  801209:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	50                   	push   %eax
  801213:	52                   	push   %edx
  801214:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80121a:	83 c0 08             	add    $0x8,%eax
  80121d:	50                   	push   %eax
  80121e:	e8 01 0f 00 00       	call   802124 <sys_cputs>
  801223:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801226:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  80122d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80123b:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  801242:	8d 45 0c             	lea    0xc(%ebp),%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 f4             	pushl  -0xc(%ebp)
  801251:	50                   	push   %eax
  801252:	e8 73 ff ff ff       	call   8011ca <vcprintf>
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80125d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801268:	e8 f9 0e 00 00       	call   802166 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80126d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801270:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	ff 75 f4             	pushl  -0xc(%ebp)
  80127c:	50                   	push   %eax
  80127d:	e8 48 ff ff ff       	call   8011ca <vcprintf>
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801288:	e8 f3 0e 00 00       	call   802180 <sys_unlock_cons>
	return cnt;
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	53                   	push   %ebx
  801296:	83 ec 14             	sub    $0x14,%esp
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8012a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012b0:	77 55                	ja     801307 <printnum+0x75>
  8012b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012b5:	72 05                	jb     8012bc <printnum+0x2a>
  8012b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ba:	77 4b                	ja     801307 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8012c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ca:	52                   	push   %edx
  8012cb:	50                   	push   %eax
  8012cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8012d2:	e8 4d 14 00 00       	call   802724 <__udivdi3>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	ff 75 20             	pushl  0x20(%ebp)
  8012e0:	53                   	push   %ebx
  8012e1:	ff 75 18             	pushl  0x18(%ebp)
  8012e4:	52                   	push   %edx
  8012e5:	50                   	push   %eax
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	e8 a1 ff ff ff       	call   801292 <printnum>
  8012f1:	83 c4 20             	add    $0x20,%esp
  8012f4:	eb 1a                	jmp    801310 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	ff 75 20             	pushl  0x20(%ebp)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	ff d0                	call   *%eax
  801304:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801307:	ff 4d 1c             	decl   0x1c(%ebp)
  80130a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80130e:	7f e6                	jg     8012f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801310:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131e:	53                   	push   %ebx
  80131f:	51                   	push   %ecx
  801320:	52                   	push   %edx
  801321:	50                   	push   %eax
  801322:	e8 0d 15 00 00       	call   802834 <__umoddi3>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	05 14 2f 80 00       	add    $0x802f14,%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	50                   	push   %eax
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	ff d0                	call   *%eax
  801340:	83 c4 10             	add    $0x10,%esp
}
  801343:	90                   	nop
  801344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80134c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801350:	7e 1c                	jle    80136e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8b 00                	mov    (%eax),%eax
  801357:	8d 50 08             	lea    0x8(%eax),%edx
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	89 10                	mov    %edx,(%eax)
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	83 e8 08             	sub    $0x8,%eax
  801367:	8b 50 04             	mov    0x4(%eax),%edx
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	eb 40                	jmp    8013ae <getuint+0x65>
	else if (lflag)
  80136e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801372:	74 1e                	je     801392 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	8d 50 04             	lea    0x4(%eax),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	89 10                	mov    %edx,(%eax)
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	83 e8 04             	sub    $0x4,%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	ba 00 00 00 00       	mov    $0x0,%edx
  801390:	eb 1c                	jmp    8013ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	8d 50 04             	lea    0x4(%eax),%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 10                	mov    %edx,(%eax)
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8b 00                	mov    (%eax),%eax
  8013a4:	83 e8 04             	sub    $0x4,%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013b7:	7e 1c                	jle    8013d5 <getint+0x25>
		return va_arg(*ap, long long);
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	8d 50 08             	lea    0x8(%eax),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	89 10                	mov    %edx,(%eax)
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	83 e8 08             	sub    $0x8,%eax
  8013ce:	8b 50 04             	mov    0x4(%eax),%edx
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	eb 38                	jmp    80140d <getint+0x5d>
	else if (lflag)
  8013d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013d9:	74 1a                	je     8013f5 <getint+0x45>
		return va_arg(*ap, long);
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	8d 50 04             	lea    0x4(%eax),%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 10                	mov    %edx,(%eax)
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	83 e8 04             	sub    $0x4,%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	99                   	cltd   
  8013f3:	eb 18                	jmp    80140d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 50 04             	lea    0x4(%eax),%edx
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	89 10                	mov    %edx,(%eax)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	83 e8 04             	sub    $0x4,%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	99                   	cltd   
}
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    

0080140f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	56                   	push   %esi
  801413:	53                   	push   %ebx
  801414:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	eb 17                	jmp    801430 <vprintfmt+0x21>
			if (ch == '\0')
  801419:	85 db                	test   %ebx,%ebx
  80141b:	0f 84 c1 03 00 00    	je     8017e2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	53                   	push   %ebx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	ff d0                	call   *%eax
  80142d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 10             	mov    %edx,0x10(%ebp)
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f b6 d8             	movzbl %al,%ebx
  80143e:	83 fb 25             	cmp    $0x25,%ebx
  801441:	75 d6                	jne    801419 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801443:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801447:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80144e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801455:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80145c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801463:	8b 45 10             	mov    0x10(%ebp),%eax
  801466:	8d 50 01             	lea    0x1(%eax),%edx
  801469:	89 55 10             	mov    %edx,0x10(%ebp)
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f b6 d8             	movzbl %al,%ebx
  801471:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801474:	83 f8 5b             	cmp    $0x5b,%eax
  801477:	0f 87 3d 03 00 00    	ja     8017ba <vprintfmt+0x3ab>
  80147d:	8b 04 85 38 2f 80 00 	mov    0x802f38(,%eax,4),%eax
  801484:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801486:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80148a:	eb d7                	jmp    801463 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80148c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801490:	eb d1                	jmp    801463 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801492:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801499:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149c:	89 d0                	mov    %edx,%eax
  80149e:	c1 e0 02             	shl    $0x2,%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	01 c0                	add    %eax,%eax
  8014a5:	01 d8                	add    %ebx,%eax
  8014a7:	83 e8 30             	sub    $0x30,%eax
  8014aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8014b8:	7e 3e                	jle    8014f8 <vprintfmt+0xe9>
  8014ba:	83 fb 39             	cmp    $0x39,%ebx
  8014bd:	7f 39                	jg     8014f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014c2:	eb d5                	jmp    801499 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c7:	83 c0 04             	add    $0x4,%eax
  8014ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8014cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d0:	83 e8 04             	sub    $0x4,%eax
  8014d3:	8b 00                	mov    (%eax),%eax
  8014d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014d8:	eb 1f                	jmp    8014f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014de:	79 83                	jns    801463 <vprintfmt+0x54>
				width = 0;
  8014e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014e7:	e9 77 ff ff ff       	jmp    801463 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014f3:	e9 6b ff ff ff       	jmp    801463 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fd:	0f 89 60 ff ff ff    	jns    801463 <vprintfmt+0x54>
				width = precision, precision = -1;
  801503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801509:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801510:	e9 4e ff ff ff       	jmp    801463 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801515:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801518:	e9 46 ff ff ff       	jmp    801463 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80151d:	8b 45 14             	mov    0x14(%ebp),%eax
  801520:	83 c0 04             	add    $0x4,%eax
  801523:	89 45 14             	mov    %eax,0x14(%ebp)
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	83 e8 04             	sub    $0x4,%eax
  80152c:	8b 00                	mov    (%eax),%eax
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	50                   	push   %eax
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	ff d0                	call   *%eax
  80153a:	83 c4 10             	add    $0x10,%esp
			break;
  80153d:	e9 9b 02 00 00       	jmp    8017dd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801542:	8b 45 14             	mov    0x14(%ebp),%eax
  801545:	83 c0 04             	add    $0x4,%eax
  801548:	89 45 14             	mov    %eax,0x14(%ebp)
  80154b:	8b 45 14             	mov    0x14(%ebp),%eax
  80154e:	83 e8 04             	sub    $0x4,%eax
  801551:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801553:	85 db                	test   %ebx,%ebx
  801555:	79 02                	jns    801559 <vprintfmt+0x14a>
				err = -err;
  801557:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801559:	83 fb 64             	cmp    $0x64,%ebx
  80155c:	7f 0b                	jg     801569 <vprintfmt+0x15a>
  80155e:	8b 34 9d 80 2d 80 00 	mov    0x802d80(,%ebx,4),%esi
  801565:	85 f6                	test   %esi,%esi
  801567:	75 19                	jne    801582 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801569:	53                   	push   %ebx
  80156a:	68 25 2f 80 00       	push   $0x802f25
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 70 02 00 00       	call   8017ea <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80157d:	e9 5b 02 00 00       	jmp    8017dd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801582:	56                   	push   %esi
  801583:	68 2e 2f 80 00       	push   $0x802f2e
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	ff 75 08             	pushl  0x8(%ebp)
  80158e:	e8 57 02 00 00       	call   8017ea <printfmt>
  801593:	83 c4 10             	add    $0x10,%esp
			break;
  801596:	e9 42 02 00 00       	jmp    8017dd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80159b:	8b 45 14             	mov    0x14(%ebp),%eax
  80159e:	83 c0 04             	add    $0x4,%eax
  8015a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8015a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a7:	83 e8 04             	sub    $0x4,%eax
  8015aa:	8b 30                	mov    (%eax),%esi
  8015ac:	85 f6                	test   %esi,%esi
  8015ae:	75 05                	jne    8015b5 <vprintfmt+0x1a6>
				p = "(null)";
  8015b0:	be 31 2f 80 00       	mov    $0x802f31,%esi
			if (width > 0 && padc != '-')
  8015b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b9:	7e 6d                	jle    801628 <vprintfmt+0x219>
  8015bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015bf:	74 67                	je     801628 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	50                   	push   %eax
  8015c8:	56                   	push   %esi
  8015c9:	e8 1e 03 00 00       	call   8018ec <strnlen>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015d4:	eb 16                	jmp    8015ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	50                   	push   %eax
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	ff d0                	call   *%eax
  8015e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8015ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f0:	7f e4                	jg     8015d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015f2:	eb 34                	jmp    801628 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015f8:	74 1c                	je     801616 <vprintfmt+0x207>
  8015fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8015fd:	7e 05                	jle    801604 <vprintfmt+0x1f5>
  8015ff:	83 fb 7e             	cmp    $0x7e,%ebx
  801602:	7e 12                	jle    801616 <vprintfmt+0x207>
					putch('?', putdat);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	6a 3f                	push   $0x3f
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	ff d0                	call   *%eax
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	eb 0f                	jmp    801625 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	53                   	push   %ebx
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	ff d0                	call   *%eax
  801622:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801625:	ff 4d e4             	decl   -0x1c(%ebp)
  801628:	89 f0                	mov    %esi,%eax
  80162a:	8d 70 01             	lea    0x1(%eax),%esi
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	0f be d8             	movsbl %al,%ebx
  801632:	85 db                	test   %ebx,%ebx
  801634:	74 24                	je     80165a <vprintfmt+0x24b>
  801636:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80163a:	78 b8                	js     8015f4 <vprintfmt+0x1e5>
  80163c:	ff 4d e0             	decl   -0x20(%ebp)
  80163f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801643:	79 af                	jns    8015f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801645:	eb 13                	jmp    80165a <vprintfmt+0x24b>
				putch(' ', putdat);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	6a 20                	push   $0x20
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	ff d0                	call   *%eax
  801654:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801657:	ff 4d e4             	decl   -0x1c(%ebp)
  80165a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80165e:	7f e7                	jg     801647 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801660:	e9 78 01 00 00       	jmp    8017dd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	ff 75 e8             	pushl  -0x18(%ebp)
  80166b:	8d 45 14             	lea    0x14(%ebp),%eax
  80166e:	50                   	push   %eax
  80166f:	e8 3c fd ff ff       	call   8013b0 <getint>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801683:	85 d2                	test   %edx,%edx
  801685:	79 23                	jns    8016aa <vprintfmt+0x29b>
				putch('-', putdat);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	6a 2d                	push   $0x2d
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	ff d0                	call   *%eax
  801694:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169d:	f7 d8                	neg    %eax
  80169f:	83 d2 00             	adc    $0x0,%edx
  8016a2:	f7 da                	neg    %edx
  8016a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016b1:	e9 bc 00 00 00       	jmp    801772 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8016bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	e8 84 fc ff ff       	call   801349 <getuint>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016d5:	e9 98 00 00 00       	jmp    801772 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016da:	83 ec 08             	sub    $0x8,%esp
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	6a 58                	push   $0x58
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	ff d0                	call   *%eax
  8016e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	6a 58                	push   $0x58
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	ff d0                	call   *%eax
  8016f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	6a 58                	push   $0x58
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	ff d0                	call   *%eax
  801707:	83 c4 10             	add    $0x10,%esp
			break;
  80170a:	e9 ce 00 00 00       	jmp    8017dd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	6a 30                	push   $0x30
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	ff d0                	call   *%eax
  80171c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	6a 78                	push   $0x78
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	ff d0                	call   *%eax
  80172c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	83 c0 04             	add    $0x4,%eax
  801735:	89 45 14             	mov    %eax,0x14(%ebp)
  801738:	8b 45 14             	mov    0x14(%ebp),%eax
  80173b:	83 e8 04             	sub    $0x4,%eax
  80173e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80174a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801751:	eb 1f                	jmp    801772 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	ff 75 e8             	pushl  -0x18(%ebp)
  801759:	8d 45 14             	lea    0x14(%ebp),%eax
  80175c:	50                   	push   %eax
  80175d:	e8 e7 fb ff ff       	call   801349 <getuint>
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801768:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80176b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801772:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	52                   	push   %edx
  80177d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801780:	50                   	push   %eax
  801781:	ff 75 f4             	pushl  -0xc(%ebp)
  801784:	ff 75 f0             	pushl  -0x10(%ebp)
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 00 fb ff ff       	call   801292 <printnum>
  801792:	83 c4 20             	add    $0x20,%esp
			break;
  801795:	eb 46                	jmp    8017dd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801797:	83 ec 08             	sub    $0x8,%esp
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	53                   	push   %ebx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	ff d0                	call   *%eax
  8017a3:	83 c4 10             	add    $0x10,%esp
			break;
  8017a6:	eb 35                	jmp    8017dd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8017a8:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8017af:	eb 2c                	jmp    8017dd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8017b1:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8017b8:	eb 23                	jmp    8017dd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017ba:	83 ec 08             	sub    $0x8,%esp
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	6a 25                	push   $0x25
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	ff d0                	call   *%eax
  8017c7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017ca:	ff 4d 10             	decl   0x10(%ebp)
  8017cd:	eb 03                	jmp    8017d2 <vprintfmt+0x3c3>
  8017cf:	ff 4d 10             	decl   0x10(%ebp)
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	48                   	dec    %eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 25                	cmp    $0x25,%al
  8017da:	75 f3                	jne    8017cf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8017dc:	90                   	nop
		}
	}
  8017dd:	e9 35 fc ff ff       	jmp    801417 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017e2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f3:	83 c0 04             	add    $0x4,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ff:	50                   	push   %eax
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	e8 04 fc ff ff       	call   80140f <vprintfmt>
  80180b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80180e:	90                   	nop
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	8b 40 08             	mov    0x8(%eax),%eax
  80181a:	8d 50 01             	lea    0x1(%eax),%edx
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	8b 10                	mov    (%eax),%edx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8b 40 04             	mov    0x4(%eax),%eax
  80182e:	39 c2                	cmp    %eax,%edx
  801830:	73 12                	jae    801844 <sprintputch+0x33>
		*b->buf++ = ch;
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	8d 48 01             	lea    0x1(%eax),%ecx
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	89 0a                	mov    %ecx,(%edx)
  80183f:	8b 55 08             	mov    0x8(%ebp),%edx
  801842:	88 10                	mov    %dl,(%eax)
}
  801844:	90                   	nop
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	8d 50 ff             	lea    -0x1(%eax),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801868:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80186c:	74 06                	je     801874 <vsnprintf+0x2d>
  80186e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801872:	7f 07                	jg     80187b <vsnprintf+0x34>
		return -E_INVAL;
  801874:	b8 03 00 00 00       	mov    $0x3,%eax
  801879:	eb 20                	jmp    80189b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80187b:	ff 75 14             	pushl  0x14(%ebp)
  80187e:	ff 75 10             	pushl  0x10(%ebp)
  801881:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801884:	50                   	push   %eax
  801885:	68 11 18 80 00       	push   $0x801811
  80188a:	e8 80 fb ff ff       	call   80140f <vprintfmt>
  80188f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801895:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8018a6:	83 c0 04             	add    $0x4,%eax
  8018a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	50                   	push   %eax
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	e8 89 ff ff ff       	call   801847 <vsnprintf>
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018d6:	eb 06                	jmp    8018de <strlen+0x15>
		n++;
  8018d8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018db:	ff 45 08             	incl   0x8(%ebp)
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	84 c0                	test   %al,%al
  8018e5:	75 f1                	jne    8018d8 <strlen+0xf>
		n++;
	return n;
  8018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018f9:	eb 09                	jmp    801904 <strnlen+0x18>
		n++;
  8018fb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018fe:	ff 45 08             	incl   0x8(%ebp)
  801901:	ff 4d 0c             	decl   0xc(%ebp)
  801904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801908:	74 09                	je     801913 <strnlen+0x27>
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8a 00                	mov    (%eax),%al
  80190f:	84 c0                	test   %al,%al
  801911:	75 e8                	jne    8018fb <strnlen+0xf>
		n++;
	return n;
  801913:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801924:	90                   	nop
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8d 50 01             	lea    0x1(%eax),%edx
  80192b:	89 55 08             	mov    %edx,0x8(%ebp)
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8d 4a 01             	lea    0x1(%edx),%ecx
  801934:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801937:	8a 12                	mov    (%edx),%dl
  801939:	88 10                	mov    %dl,(%eax)
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	84 c0                	test   %al,%al
  80193f:	75 e4                	jne    801925 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801941:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801952:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801959:	eb 1f                	jmp    80197a <strncpy+0x34>
		*dst++ = *src;
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 08             	mov    %edx,0x8(%ebp)
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8a 12                	mov    (%edx),%dl
  801969:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	84 c0                	test   %al,%al
  801972:	74 03                	je     801977 <strncpy+0x31>
			src++;
  801974:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801977:	ff 45 fc             	incl   -0x4(%ebp)
  80197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801980:	72 d9                	jb     80195b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801982:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801993:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801997:	74 30                	je     8019c9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801999:	eb 16                	jmp    8019b1 <strlcpy+0x2a>
			*dst++ = *src++;
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8d 50 01             	lea    0x1(%eax),%edx
  8019a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8019a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019ad:	8a 12                	mov    (%edx),%dl
  8019af:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019b1:	ff 4d 10             	decl   0x10(%ebp)
  8019b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b8:	74 09                	je     8019c3 <strlcpy+0x3c>
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	84 c0                	test   %al,%al
  8019c1:	75 d8                	jne    80199b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019cf:	29 c2                	sub    %eax,%edx
  8019d1:	89 d0                	mov    %edx,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019d8:	eb 06                	jmp    8019e0 <strcmp+0xb>
		p++, q++;
  8019da:	ff 45 08             	incl   0x8(%ebp)
  8019dd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	84 c0                	test   %al,%al
  8019e7:	74 0e                	je     8019f7 <strcmp+0x22>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 10                	mov    (%eax),%dl
  8019ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f1:	8a 00                	mov    (%eax),%al
  8019f3:	38 c2                	cmp    %al,%dl
  8019f5:	74 e3                	je     8019da <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	0f b6 d0             	movzbl %al,%edx
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	0f b6 c0             	movzbl %al,%eax
  801a07:	29 c2                	sub    %eax,%edx
  801a09:	89 d0                	mov    %edx,%eax
}
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a10:	eb 09                	jmp    801a1b <strncmp+0xe>
		n--, p++, q++;
  801a12:	ff 4d 10             	decl   0x10(%ebp)
  801a15:	ff 45 08             	incl   0x8(%ebp)
  801a18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1f:	74 17                	je     801a38 <strncmp+0x2b>
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	84 c0                	test   %al,%al
  801a28:	74 0e                	je     801a38 <strncmp+0x2b>
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	8a 10                	mov    (%eax),%dl
  801a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	38 c2                	cmp    %al,%dl
  801a36:	74 da                	je     801a12 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3c:	75 07                	jne    801a45 <strncmp+0x38>
		return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a43:	eb 14                	jmp    801a59 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8a 00                	mov    (%eax),%al
  801a4a:	0f b6 d0             	movzbl %al,%edx
  801a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a50:	8a 00                	mov    (%eax),%al
  801a52:	0f b6 c0             	movzbl %al,%eax
  801a55:	29 c2                	sub    %eax,%edx
  801a57:	89 d0                	mov    %edx,%eax
}
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a67:	eb 12                	jmp    801a7b <strchr+0x20>
		if (*s == c)
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a71:	75 05                	jne    801a78 <strchr+0x1d>
			return (char *) s;
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	eb 11                	jmp    801a89 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 e5                	jne    801a69 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a97:	eb 0d                	jmp    801aa6 <strfind+0x1b>
		if (*s == c)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aa1:	74 0e                	je     801ab1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801aa3:	ff 45 08             	incl   0x8(%ebp)
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	8a 00                	mov    (%eax),%al
  801aab:	84 c0                	test   %al,%al
  801aad:	75 ea                	jne    801a99 <strfind+0xe>
  801aaf:	eb 01                	jmp    801ab2 <strfind+0x27>
		if (*s == c)
			break;
  801ab1:	90                   	nop
	return (char *) s;
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801ac9:	eb 0e                	jmp    801ad9 <memset+0x22>
		*p++ = c;
  801acb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ace:	8d 50 01             	lea    0x1(%eax),%edx
  801ad1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ad9:	ff 4d f8             	decl   -0x8(%ebp)
  801adc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ae0:	79 e9                	jns    801acb <memset+0x14>
		*p++ = c;

	return v;
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801af9:	eb 16                	jmp    801b11 <memcpy+0x2a>
		*d++ = *s++;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	8d 50 01             	lea    0x1(%eax),%edx
  801b01:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b0a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b0d:	8a 12                	mov    (%edx),%dl
  801b0f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b11:	8b 45 10             	mov    0x10(%ebp),%eax
  801b14:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b17:	89 55 10             	mov    %edx,0x10(%ebp)
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	75 dd                	jne    801afb <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b3b:	73 50                	jae    801b8d <memmove+0x6a>
  801b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b40:	8b 45 10             	mov    0x10(%ebp),%eax
  801b43:	01 d0                	add    %edx,%eax
  801b45:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b48:	76 43                	jbe    801b8d <memmove+0x6a>
		s += n;
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b50:	8b 45 10             	mov    0x10(%ebp),%eax
  801b53:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b56:	eb 10                	jmp    801b68 <memmove+0x45>
			*--d = *--s;
  801b58:	ff 4d f8             	decl   -0x8(%ebp)
  801b5b:	ff 4d fc             	decl   -0x4(%ebp)
  801b5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b61:	8a 10                	mov    (%eax),%dl
  801b63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b66:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b68:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b6e:	89 55 10             	mov    %edx,0x10(%ebp)
  801b71:	85 c0                	test   %eax,%eax
  801b73:	75 e3                	jne    801b58 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b75:	eb 23                	jmp    801b9a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7a:	8d 50 01             	lea    0x1(%eax),%edx
  801b7d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b83:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b86:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b89:	8a 12                	mov    (%edx),%dl
  801b8b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b90:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b93:	89 55 10             	mov    %edx,0x10(%ebp)
  801b96:	85 c0                	test   %eax,%eax
  801b98:	75 dd                	jne    801b77 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bae:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bb1:	eb 2a                	jmp    801bdd <memcmp+0x3e>
		if (*s1 != *s2)
  801bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb6:	8a 10                	mov    (%eax),%dl
  801bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbb:	8a 00                	mov    (%eax),%al
  801bbd:	38 c2                	cmp    %al,%dl
  801bbf:	74 16                	je     801bd7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc4:	8a 00                	mov    (%eax),%al
  801bc6:	0f b6 d0             	movzbl %al,%edx
  801bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bcc:	8a 00                	mov    (%eax),%al
  801bce:	0f b6 c0             	movzbl %al,%eax
  801bd1:	29 c2                	sub    %eax,%edx
  801bd3:	89 d0                	mov    %edx,%eax
  801bd5:	eb 18                	jmp    801bef <memcmp+0x50>
		s1++, s2++;
  801bd7:	ff 45 fc             	incl   -0x4(%ebp)
  801bda:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801be0:	8d 50 ff             	lea    -0x1(%eax),%edx
  801be3:	89 55 10             	mov    %edx,0x10(%ebp)
  801be6:	85 c0                	test   %eax,%eax
  801be8:	75 c9                	jne    801bb3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	01 d0                	add    %edx,%eax
  801bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c02:	eb 15                	jmp    801c19 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	8a 00                	mov    (%eax),%al
  801c09:	0f b6 d0             	movzbl %al,%edx
  801c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0f:	0f b6 c0             	movzbl %al,%eax
  801c12:	39 c2                	cmp    %eax,%edx
  801c14:	74 0d                	je     801c23 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c16:	ff 45 08             	incl   0x8(%ebp)
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c1f:	72 e3                	jb     801c04 <memfind+0x13>
  801c21:	eb 01                	jmp    801c24 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c23:	90                   	nop
	return (void *) s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c3d:	eb 03                	jmp    801c42 <strtol+0x19>
		s++;
  801c3f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	8a 00                	mov    (%eax),%al
  801c47:	3c 20                	cmp    $0x20,%al
  801c49:	74 f4                	je     801c3f <strtol+0x16>
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	8a 00                	mov    (%eax),%al
  801c50:	3c 09                	cmp    $0x9,%al
  801c52:	74 eb                	je     801c3f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	8a 00                	mov    (%eax),%al
  801c59:	3c 2b                	cmp    $0x2b,%al
  801c5b:	75 05                	jne    801c62 <strtol+0x39>
		s++;
  801c5d:	ff 45 08             	incl   0x8(%ebp)
  801c60:	eb 13                	jmp    801c75 <strtol+0x4c>
	else if (*s == '-')
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	3c 2d                	cmp    $0x2d,%al
  801c69:	75 0a                	jne    801c75 <strtol+0x4c>
		s++, neg = 1;
  801c6b:	ff 45 08             	incl   0x8(%ebp)
  801c6e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c79:	74 06                	je     801c81 <strtol+0x58>
  801c7b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c7f:	75 20                	jne    801ca1 <strtol+0x78>
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8a 00                	mov    (%eax),%al
  801c86:	3c 30                	cmp    $0x30,%al
  801c88:	75 17                	jne    801ca1 <strtol+0x78>
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	40                   	inc    %eax
  801c8e:	8a 00                	mov    (%eax),%al
  801c90:	3c 78                	cmp    $0x78,%al
  801c92:	75 0d                	jne    801ca1 <strtol+0x78>
		s += 2, base = 16;
  801c94:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c98:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c9f:	eb 28                	jmp    801cc9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ca5:	75 15                	jne    801cbc <strtol+0x93>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 30                	cmp    $0x30,%al
  801cae:	75 0c                	jne    801cbc <strtol+0x93>
		s++, base = 8;
  801cb0:	ff 45 08             	incl   0x8(%ebp)
  801cb3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cba:	eb 0d                	jmp    801cc9 <strtol+0xa0>
	else if (base == 0)
  801cbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc0:	75 07                	jne    801cc9 <strtol+0xa0>
		base = 10;
  801cc2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 2f                	cmp    $0x2f,%al
  801cd0:	7e 19                	jle    801ceb <strtol+0xc2>
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	3c 39                	cmp    $0x39,%al
  801cd9:	7f 10                	jg     801ceb <strtol+0xc2>
			dig = *s - '0';
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	8a 00                	mov    (%eax),%al
  801ce0:	0f be c0             	movsbl %al,%eax
  801ce3:	83 e8 30             	sub    $0x30,%eax
  801ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce9:	eb 42                	jmp    801d2d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 60                	cmp    $0x60,%al
  801cf2:	7e 19                	jle    801d0d <strtol+0xe4>
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	3c 7a                	cmp    $0x7a,%al
  801cfb:	7f 10                	jg     801d0d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	8a 00                	mov    (%eax),%al
  801d02:	0f be c0             	movsbl %al,%eax
  801d05:	83 e8 57             	sub    $0x57,%eax
  801d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0b:	eb 20                	jmp    801d2d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8a 00                	mov    (%eax),%al
  801d12:	3c 40                	cmp    $0x40,%al
  801d14:	7e 39                	jle    801d4f <strtol+0x126>
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	3c 5a                	cmp    $0x5a,%al
  801d1d:	7f 30                	jg     801d4f <strtol+0x126>
			dig = *s - 'A' + 10;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	8a 00                	mov    (%eax),%al
  801d24:	0f be c0             	movsbl %al,%eax
  801d27:	83 e8 37             	sub    $0x37,%eax
  801d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d30:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d33:	7d 19                	jge    801d4e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d35:	ff 45 08             	incl   0x8(%ebp)
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d3f:	89 c2                	mov    %eax,%edx
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	01 d0                	add    %edx,%eax
  801d46:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d49:	e9 7b ff ff ff       	jmp    801cc9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d4e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d53:	74 08                	je     801d5d <strtol+0x134>
		*endptr = (char *) s;
  801d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d58:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d61:	74 07                	je     801d6a <strtol+0x141>
  801d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d66:	f7 d8                	neg    %eax
  801d68:	eb 03                	jmp    801d6d <strtol+0x144>
  801d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <ltostr>:

void
ltostr(long value, char *str)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d87:	79 13                	jns    801d9c <ltostr+0x2d>
	{
		neg = 1;
  801d89:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d96:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d99:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801da4:	99                   	cltd   
  801da5:	f7 f9                	idiv   %ecx
  801da7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dad:	8d 50 01             	lea    0x1(%eax),%edx
  801db0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801db3:	89 c2                	mov    %eax,%edx
  801db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db8:	01 d0                	add    %edx,%eax
  801dba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dbd:	83 c2 30             	add    $0x30,%edx
  801dc0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dca:	f7 e9                	imul   %ecx
  801dcc:	c1 fa 02             	sar    $0x2,%edx
  801dcf:	89 c8                	mov    %ecx,%eax
  801dd1:	c1 f8 1f             	sar    $0x1f,%eax
  801dd4:	29 c2                	sub    %eax,%edx
  801dd6:	89 d0                	mov    %edx,%eax
  801dd8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801ddb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ddf:	75 bb                	jne    801d9c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801de1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801deb:	48                   	dec    %eax
  801dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801def:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801df3:	74 3d                	je     801e32 <ltostr+0xc3>
		start = 1 ;
  801df5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801dfc:	eb 34                	jmp    801e32 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	01 d0                	add    %edx,%eax
  801e06:	8a 00                	mov    (%eax),%al
  801e08:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	01 c2                	add    %eax,%edx
  801e13:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c8                	add    %ecx,%eax
  801e1b:	8a 00                	mov    (%eax),%al
  801e1d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e25:	01 c2                	add    %eax,%edx
  801e27:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e2a:	88 02                	mov    %al,(%edx)
		start++ ;
  801e2c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e2f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e38:	7c c4                	jl     801dfe <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e3a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e40:	01 d0                	add    %edx,%eax
  801e42:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	e8 73 fa ff ff       	call   8018c9 <strlen>
  801e56:	83 c4 04             	add    $0x4,%esp
  801e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	e8 65 fa ff ff       	call   8018c9 <strlen>
  801e64:	83 c4 04             	add    $0x4,%esp
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e78:	eb 17                	jmp    801e91 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	01 c2                	add    %eax,%edx
  801e82:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	01 c8                	add    %ecx,%eax
  801e8a:	8a 00                	mov    (%eax),%al
  801e8c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e8e:	ff 45 fc             	incl   -0x4(%ebp)
  801e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e97:	7c e1                	jl     801e7a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ea0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ea7:	eb 1f                	jmp    801ec8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eac:	8d 50 01             	lea    0x1(%eax),%edx
  801eaf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801eb2:	89 c2                	mov    %eax,%edx
  801eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb7:	01 c2                	add    %eax,%edx
  801eb9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	01 c8                	add    %ecx,%eax
  801ec1:	8a 00                	mov    (%eax),%al
  801ec3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ec5:	ff 45 f8             	incl   -0x8(%ebp)
  801ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ecb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ece:	7c d9                	jl     801ea9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed6:	01 d0                	add    %edx,%eax
  801ed8:	c6 00 00             	movb   $0x0,(%eax)
}
  801edb:	90                   	nop
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ee1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801eea:	8b 45 14             	mov    0x14(%ebp),%eax
  801eed:	8b 00                	mov    (%eax),%eax
  801eef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f01:	eb 0c                	jmp    801f0f <strsplit+0x31>
			*string++ = 0;
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8d 50 01             	lea    0x1(%eax),%edx
  801f09:	89 55 08             	mov    %edx,0x8(%ebp)
  801f0c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	8a 00                	mov    (%eax),%al
  801f14:	84 c0                	test   %al,%al
  801f16:	74 18                	je     801f30 <strsplit+0x52>
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	8a 00                	mov    (%eax),%al
  801f1d:	0f be c0             	movsbl %al,%eax
  801f20:	50                   	push   %eax
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	e8 32 fb ff ff       	call   801a5b <strchr>
  801f29:	83 c4 08             	add    $0x8,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	75 d3                	jne    801f03 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8a 00                	mov    (%eax),%al
  801f35:	84 c0                	test   %al,%al
  801f37:	74 5a                	je     801f93 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f39:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3c:	8b 00                	mov    (%eax),%eax
  801f3e:	83 f8 0f             	cmp    $0xf,%eax
  801f41:	75 07                	jne    801f4a <strsplit+0x6c>
		{
			return 0;
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	eb 66                	jmp    801fb0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4d:	8b 00                	mov    (%eax),%eax
  801f4f:	8d 48 01             	lea    0x1(%eax),%ecx
  801f52:	8b 55 14             	mov    0x14(%ebp),%edx
  801f55:	89 0a                	mov    %ecx,(%edx)
  801f57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f61:	01 c2                	add    %eax,%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f68:	eb 03                	jmp    801f6d <strsplit+0x8f>
			string++;
  801f6a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	8a 00                	mov    (%eax),%al
  801f72:	84 c0                	test   %al,%al
  801f74:	74 8b                	je     801f01 <strsplit+0x23>
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	8a 00                	mov    (%eax),%al
  801f7b:	0f be c0             	movsbl %al,%eax
  801f7e:	50                   	push   %eax
  801f7f:	ff 75 0c             	pushl  0xc(%ebp)
  801f82:	e8 d4 fa ff ff       	call   801a5b <strchr>
  801f87:	83 c4 08             	add    $0x8,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	74 dc                	je     801f6a <strsplit+0x8c>
			string++;
	}
  801f8e:	e9 6e ff ff ff       	jmp    801f01 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f93:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f94:	8b 45 14             	mov    0x14(%ebp),%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 a8 30 80 00       	push   $0x8030a8
  801fc0:	68 3f 01 00 00       	push   $0x13f
  801fc5:	68 ca 30 80 00       	push   $0x8030ca
  801fca:	e8 a9 ef ff ff       	call   800f78 <_panic>

00801fcf <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 ef 06 00 00       	call   8026cf <sys_sbrk>
  801fe0:	83 c4 10             	add    $0x10,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801feb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fef:	75 07                	jne    801ff8 <malloc+0x13>
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff6:	eb 14                	jmp    80200c <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 d8 30 80 00       	push   $0x8030d8
  802000:	6a 1b                	push   $0x1b
  802002:	68 fd 30 80 00       	push   $0x8030fd
  802007:	e8 6c ef ff ff       	call   800f78 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802014:	83 ec 04             	sub    $0x4,%esp
  802017:	68 0c 31 80 00       	push   $0x80310c
  80201c:	6a 29                	push   $0x29
  80201e:	68 fd 30 80 00       	push   $0x8030fd
  802023:	e8 50 ef ff ff       	call   800f78 <_panic>

00802028 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 18             	sub    $0x18,%esp
  80202e:	8b 45 10             	mov    0x10(%ebp),%eax
  802031:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802038:	75 07                	jne    802041 <smalloc+0x19>
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 14                	jmp    802055 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	68 30 31 80 00       	push   $0x803130
  802049:	6a 38                	push   $0x38
  80204b:	68 fd 30 80 00       	push   $0x8030fd
  802050:	e8 23 ef ff ff       	call   800f78 <_panic>
	return NULL;
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	68 58 31 80 00       	push   $0x803158
  802065:	6a 43                	push   $0x43
  802067:	68 fd 30 80 00       	push   $0x8030fd
  80206c:	e8 07 ef ff ff       	call   800f78 <_panic>

00802071 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	68 7c 31 80 00       	push   $0x80317c
  80207f:	6a 5b                	push   $0x5b
  802081:	68 fd 30 80 00       	push   $0x8030fd
  802086:	e8 ed ee ff ff       	call   800f78 <_panic>

0080208b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 a0 31 80 00       	push   $0x8031a0
  802099:	6a 72                	push   $0x72
  80209b:	68 fd 30 80 00       	push   $0x8030fd
  8020a0:	e8 d3 ee ff ff       	call   800f78 <_panic>

008020a5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	68 c6 31 80 00       	push   $0x8031c6
  8020b3:	6a 7e                	push   $0x7e
  8020b5:	68 fd 30 80 00       	push   $0x8030fd
  8020ba:	e8 b9 ee ff ff       	call   800f78 <_panic>

008020bf <shrink>:

}
void shrink(uint32 newSize)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	68 c6 31 80 00       	push   $0x8031c6
  8020cd:	68 83 00 00 00       	push   $0x83
  8020d2:	68 fd 30 80 00       	push   $0x8030fd
  8020d7:	e8 9c ee ff ff       	call   800f78 <_panic>

008020dc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	68 c6 31 80 00       	push   $0x8031c6
  8020ea:	68 88 00 00 00       	push   $0x88
  8020ef:	68 fd 30 80 00       	push   $0x8030fd
  8020f4:	e8 7f ee ff ff       	call   800f78 <_panic>

008020f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	57                   	push   %edi
  8020fd:	56                   	push   %esi
  8020fe:	53                   	push   %ebx
  8020ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80210e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802111:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802114:	cd 30                	int    $0x30
  802116:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5f                   	pop    %edi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    

00802124 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	8b 45 10             	mov    0x10(%ebp),%eax
  80212d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802130:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	52                   	push   %edx
  80213c:	ff 75 0c             	pushl  0xc(%ebp)
  80213f:	50                   	push   %eax
  802140:	6a 00                	push   $0x0
  802142:	e8 b2 ff ff ff       	call   8020f9 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	90                   	nop
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_cgetc>:

int
sys_cgetc(void)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 02                	push   $0x2
  80215c:	e8 98 ff ff ff       	call   8020f9 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 03                	push   $0x3
  802175:	e8 7f ff ff ff       	call   8020f9 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	90                   	nop
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 04                	push   $0x4
  80218f:	e8 65 ff ff ff       	call   8020f9 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	52                   	push   %edx
  8021aa:	50                   	push   %eax
  8021ab:	6a 08                	push   $0x8
  8021ad:	e8 47 ff ff ff       	call   8020f9 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8021bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
  8021cd:	51                   	push   %ecx
  8021ce:	52                   	push   %edx
  8021cf:	50                   	push   %eax
  8021d0:	6a 09                	push   $0x9
  8021d2:	e8 22 ff ff ff       	call   8020f9 <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    

008021e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	52                   	push   %edx
  8021f1:	50                   	push   %eax
  8021f2:	6a 0a                	push   $0xa
  8021f4:	e8 00 ff ff ff       	call   8020f9 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	ff 75 0c             	pushl  0xc(%ebp)
  80220a:	ff 75 08             	pushl  0x8(%ebp)
  80220d:	6a 0b                	push   $0xb
  80220f:	e8 e5 fe ff ff       	call   8020f9 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 0c                	push   $0xc
  802228:	e8 cc fe ff ff       	call   8020f9 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 0d                	push   $0xd
  802241:	e8 b3 fe ff ff       	call   8020f9 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 0e                	push   $0xe
  80225a:	e8 9a fe ff ff       	call   8020f9 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 0f                	push   $0xf
  802273:	e8 81 fe ff ff       	call   8020f9 <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	6a 10                	push   $0x10
  80228d:	e8 67 fe ff ff       	call   8020f9 <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 11                	push   $0x11
  8022a6:	e8 4e fe ff ff       	call   8020f9 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	90                   	nop
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	50                   	push   %eax
  8022ca:	6a 01                	push   $0x1
  8022cc:	e8 28 fe ff ff       	call   8020f9 <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	90                   	nop
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 14                	push   $0x14
  8022e6:	e8 0e fe ff ff       	call   8020f9 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	90                   	nop
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 04             	sub    $0x4,%esp
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802300:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	51                   	push   %ecx
  80230a:	52                   	push   %edx
  80230b:	ff 75 0c             	pushl  0xc(%ebp)
  80230e:	50                   	push   %eax
  80230f:	6a 15                	push   $0x15
  802311:	e8 e3 fd ff ff       	call   8020f9 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80231e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	52                   	push   %edx
  80232b:	50                   	push   %eax
  80232c:	6a 16                	push   $0x16
  80232e:	e8 c6 fd ff ff       	call   8020f9 <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80233b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	51                   	push   %ecx
  802349:	52                   	push   %edx
  80234a:	50                   	push   %eax
  80234b:	6a 17                	push   $0x17
  80234d:	e8 a7 fd ff ff       	call   8020f9 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	52                   	push   %edx
  802367:	50                   	push   %eax
  802368:	6a 18                	push   $0x18
  80236a:	e8 8a fd ff ff       	call   8020f9 <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	6a 00                	push   $0x0
  80237c:	ff 75 14             	pushl  0x14(%ebp)
  80237f:	ff 75 10             	pushl  0x10(%ebp)
  802382:	ff 75 0c             	pushl  0xc(%ebp)
  802385:	50                   	push   %eax
  802386:	6a 19                	push   $0x19
  802388:	e8 6c fd ff ff       	call   8020f9 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	50                   	push   %eax
  8023a1:	6a 1a                	push   $0x1a
  8023a3:	e8 51 fd ff ff       	call   8020f9 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	90                   	nop
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	50                   	push   %eax
  8023bd:	6a 1b                	push   $0x1b
  8023bf:	e8 35 fd ff ff       	call   8020f9 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 05                	push   $0x5
  8023d8:	e8 1c fd ff ff       	call   8020f9 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 06                	push   $0x6
  8023f1:	e8 03 fd ff ff       	call   8020f9 <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 07                	push   $0x7
  80240a:	e8 ea fc ff ff       	call   8020f9 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_exit_env>:


void sys_exit_env(void)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 1c                	push   $0x1c
  802423:	e8 d1 fc ff ff       	call   8020f9 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	90                   	nop
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802434:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802437:	8d 50 04             	lea    0x4(%eax),%edx
  80243a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	52                   	push   %edx
  802444:	50                   	push   %eax
  802445:	6a 1d                	push   $0x1d
  802447:	e8 ad fc ff ff       	call   8020f9 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
	return result;
  80244f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802452:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802455:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802458:	89 01                	mov    %eax,(%ecx)
  80245a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	c9                   	leave  
  802461:	c2 04 00             	ret    $0x4

00802464 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	ff 75 10             	pushl  0x10(%ebp)
  80246e:	ff 75 0c             	pushl  0xc(%ebp)
  802471:	ff 75 08             	pushl  0x8(%ebp)
  802474:	6a 13                	push   $0x13
  802476:	e8 7e fc ff ff       	call   8020f9 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
	return ;
  80247e:	90                   	nop
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_rcr2>:
uint32 sys_rcr2()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 1e                	push   $0x1e
  802490:	e8 64 fc ff ff       	call   8020f9 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	50                   	push   %eax
  8024b3:	6a 1f                	push   $0x1f
  8024b5:	e8 3f fc ff ff       	call   8020f9 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bd:	90                   	nop
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <rsttst>:
void rsttst()
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 21                	push   $0x21
  8024cf:	e8 25 fc ff ff       	call   8020f9 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d7:	90                   	nop
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8024e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024ed:	52                   	push   %edx
  8024ee:	50                   	push   %eax
  8024ef:	ff 75 10             	pushl  0x10(%ebp)
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	ff 75 08             	pushl  0x8(%ebp)
  8024f8:	6a 20                	push   $0x20
  8024fa:	e8 fa fb ff ff       	call   8020f9 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <chktst>:
void chktst(uint32 n)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	ff 75 08             	pushl  0x8(%ebp)
  802513:	6a 22                	push   $0x22
  802515:	e8 df fb ff ff       	call   8020f9 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
	return ;
  80251d:	90                   	nop
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <inctst>:

void inctst()
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 23                	push   $0x23
  80252f:	e8 c5 fb ff ff       	call   8020f9 <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
	return ;
  802537:	90                   	nop
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <gettst>:
uint32 gettst()
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 24                	push   $0x24
  802549:	e8 ab fb ff ff       	call   8020f9 <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 25                	push   $0x25
  802565:	e8 8f fb ff ff       	call   8020f9 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
  80256d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802570:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802574:	75 07                	jne    80257d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802576:	b8 01 00 00 00       	mov    $0x1,%eax
  80257b:	eb 05                	jmp    802582 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 25                	push   $0x25
  802596:	e8 5e fb ff ff       	call   8020f9 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
  80259e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025a1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025a5:	75 07                	jne    8025ae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ac:	eb 05                	jmp    8025b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 25                	push   $0x25
  8025c7:	e8 2d fb ff ff       	call   8020f9 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
  8025cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025d2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025d6:	75 07                	jne    8025df <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8025dd:	eb 05                	jmp    8025e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 25                	push   $0x25
  8025f8:	e8 fc fa ff ff       	call   8020f9 <syscall>
  8025fd:	83 c4 18             	add    $0x18,%esp
  802600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802603:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802607:	75 07                	jne    802610 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802609:	b8 01 00 00 00       	mov    $0x1,%eax
  80260e:	eb 05                	jmp    802615 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	ff 75 08             	pushl  0x8(%ebp)
  802625:	6a 26                	push   $0x26
  802627:	e8 cd fa ff ff       	call   8020f9 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
	return ;
  80262f:	90                   	nop
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802636:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802639:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80263c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	53                   	push   %ebx
  802645:	51                   	push   %ecx
  802646:	52                   	push   %edx
  802647:	50                   	push   %eax
  802648:	6a 27                	push   $0x27
  80264a:	e8 aa fa ff ff       	call   8020f9 <syscall>
  80264f:	83 c4 18             	add    $0x18,%esp
}
  802652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80265a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	52                   	push   %edx
  802667:	50                   	push   %eax
  802668:	6a 28                	push   $0x28
  80266a:	e8 8a fa ff ff       	call   8020f9 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802677:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80267a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	6a 00                	push   $0x0
  802682:	51                   	push   %ecx
  802683:	ff 75 10             	pushl  0x10(%ebp)
  802686:	52                   	push   %edx
  802687:	50                   	push   %eax
  802688:	6a 29                	push   $0x29
  80268a:	e8 6a fa ff ff       	call   8020f9 <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
}
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	ff 75 10             	pushl  0x10(%ebp)
  80269e:	ff 75 0c             	pushl  0xc(%ebp)
  8026a1:	ff 75 08             	pushl  0x8(%ebp)
  8026a4:	6a 12                	push   $0x12
  8026a6:	e8 4e fa ff ff       	call   8020f9 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ae:	90                   	nop
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	52                   	push   %edx
  8026c1:	50                   	push   %eax
  8026c2:	6a 2a                	push   $0x2a
  8026c4:	e8 30 fa ff ff       	call   8020f9 <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
	return;
  8026cc:	90                   	nop
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	50                   	push   %eax
  8026de:	6a 2b                	push   $0x2b
  8026e0:	e8 14 fa ff ff       	call   8020f9 <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
}
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	ff 75 0c             	pushl  0xc(%ebp)
  8026f6:	ff 75 08             	pushl  0x8(%ebp)
  8026f9:	6a 2c                	push   $0x2c
  8026fb:	e8 f9 f9 ff ff       	call   8020f9 <syscall>
  802700:	83 c4 18             	add    $0x18,%esp
	return;
  802703:	90                   	nop
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	ff 75 0c             	pushl  0xc(%ebp)
  802712:	ff 75 08             	pushl  0x8(%ebp)
  802715:	6a 2d                	push   $0x2d
  802717:	e8 dd f9 ff ff       	call   8020f9 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
	return;
  80271f:	90                   	nop
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    
  802722:	66 90                	xchg   %ax,%ax

00802724 <__udivdi3>:
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80272f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802737:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80273b:	89 ca                	mov    %ecx,%edx
  80273d:	89 f8                	mov    %edi,%eax
  80273f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802743:	85 f6                	test   %esi,%esi
  802745:	75 2d                	jne    802774 <__udivdi3+0x50>
  802747:	39 cf                	cmp    %ecx,%edi
  802749:	77 65                	ja     8027b0 <__udivdi3+0x8c>
  80274b:	89 fd                	mov    %edi,%ebp
  80274d:	85 ff                	test   %edi,%edi
  80274f:	75 0b                	jne    80275c <__udivdi3+0x38>
  802751:	b8 01 00 00 00       	mov    $0x1,%eax
  802756:	31 d2                	xor    %edx,%edx
  802758:	f7 f7                	div    %edi
  80275a:	89 c5                	mov    %eax,%ebp
  80275c:	31 d2                	xor    %edx,%edx
  80275e:	89 c8                	mov    %ecx,%eax
  802760:	f7 f5                	div    %ebp
  802762:	89 c1                	mov    %eax,%ecx
  802764:	89 d8                	mov    %ebx,%eax
  802766:	f7 f5                	div    %ebp
  802768:	89 cf                	mov    %ecx,%edi
  80276a:	89 fa                	mov    %edi,%edx
  80276c:	83 c4 1c             	add    $0x1c,%esp
  80276f:	5b                   	pop    %ebx
  802770:	5e                   	pop    %esi
  802771:	5f                   	pop    %edi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    
  802774:	39 ce                	cmp    %ecx,%esi
  802776:	77 28                	ja     8027a0 <__udivdi3+0x7c>
  802778:	0f bd fe             	bsr    %esi,%edi
  80277b:	83 f7 1f             	xor    $0x1f,%edi
  80277e:	75 40                	jne    8027c0 <__udivdi3+0x9c>
  802780:	39 ce                	cmp    %ecx,%esi
  802782:	72 0a                	jb     80278e <__udivdi3+0x6a>
  802784:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802788:	0f 87 9e 00 00 00    	ja     80282c <__udivdi3+0x108>
  80278e:	b8 01 00 00 00       	mov    $0x1,%eax
  802793:	89 fa                	mov    %edi,%edx
  802795:	83 c4 1c             	add    $0x1c,%esp
  802798:	5b                   	pop    %ebx
  802799:	5e                   	pop    %esi
  80279a:	5f                   	pop    %edi
  80279b:	5d                   	pop    %ebp
  80279c:	c3                   	ret    
  80279d:	8d 76 00             	lea    0x0(%esi),%esi
  8027a0:	31 ff                	xor    %edi,%edi
  8027a2:	31 c0                	xor    %eax,%eax
  8027a4:	89 fa                	mov    %edi,%edx
  8027a6:	83 c4 1c             	add    $0x1c,%esp
  8027a9:	5b                   	pop    %ebx
  8027aa:	5e                   	pop    %esi
  8027ab:	5f                   	pop    %edi
  8027ac:	5d                   	pop    %ebp
  8027ad:	c3                   	ret    
  8027ae:	66 90                	xchg   %ax,%ax
  8027b0:	89 d8                	mov    %ebx,%eax
  8027b2:	f7 f7                	div    %edi
  8027b4:	31 ff                	xor    %edi,%edi
  8027b6:	89 fa                	mov    %edi,%edx
  8027b8:	83 c4 1c             	add    $0x1c,%esp
  8027bb:	5b                   	pop    %ebx
  8027bc:	5e                   	pop    %esi
  8027bd:	5f                   	pop    %edi
  8027be:	5d                   	pop    %ebp
  8027bf:	c3                   	ret    
  8027c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027c5:	89 eb                	mov    %ebp,%ebx
  8027c7:	29 fb                	sub    %edi,%ebx
  8027c9:	89 f9                	mov    %edi,%ecx
  8027cb:	d3 e6                	shl    %cl,%esi
  8027cd:	89 c5                	mov    %eax,%ebp
  8027cf:	88 d9                	mov    %bl,%cl
  8027d1:	d3 ed                	shr    %cl,%ebp
  8027d3:	89 e9                	mov    %ebp,%ecx
  8027d5:	09 f1                	or     %esi,%ecx
  8027d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027db:	89 f9                	mov    %edi,%ecx
  8027dd:	d3 e0                	shl    %cl,%eax
  8027df:	89 c5                	mov    %eax,%ebp
  8027e1:	89 d6                	mov    %edx,%esi
  8027e3:	88 d9                	mov    %bl,%cl
  8027e5:	d3 ee                	shr    %cl,%esi
  8027e7:	89 f9                	mov    %edi,%ecx
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027ef:	88 d9                	mov    %bl,%cl
  8027f1:	d3 e8                	shr    %cl,%eax
  8027f3:	09 c2                	or     %eax,%edx
  8027f5:	89 d0                	mov    %edx,%eax
  8027f7:	89 f2                	mov    %esi,%edx
  8027f9:	f7 74 24 0c          	divl   0xc(%esp)
  8027fd:	89 d6                	mov    %edx,%esi
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	f7 e5                	mul    %ebp
  802803:	39 d6                	cmp    %edx,%esi
  802805:	72 19                	jb     802820 <__udivdi3+0xfc>
  802807:	74 0b                	je     802814 <__udivdi3+0xf0>
  802809:	89 d8                	mov    %ebx,%eax
  80280b:	31 ff                	xor    %edi,%edi
  80280d:	e9 58 ff ff ff       	jmp    80276a <__udivdi3+0x46>
  802812:	66 90                	xchg   %ax,%ax
  802814:	8b 54 24 08          	mov    0x8(%esp),%edx
  802818:	89 f9                	mov    %edi,%ecx
  80281a:	d3 e2                	shl    %cl,%edx
  80281c:	39 c2                	cmp    %eax,%edx
  80281e:	73 e9                	jae    802809 <__udivdi3+0xe5>
  802820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 40 ff ff ff       	jmp    80276a <__udivdi3+0x46>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	31 c0                	xor    %eax,%eax
  80282e:	e9 37 ff ff ff       	jmp    80276a <__udivdi3+0x46>
  802833:	90                   	nop

00802834 <__umoddi3>:
  802834:	55                   	push   %ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	83 ec 1c             	sub    $0x1c,%esp
  80283b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80283f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802843:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802847:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80284b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80284f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802853:	89 f3                	mov    %esi,%ebx
  802855:	89 fa                	mov    %edi,%edx
  802857:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80285b:	89 34 24             	mov    %esi,(%esp)
  80285e:	85 c0                	test   %eax,%eax
  802860:	75 1a                	jne    80287c <__umoddi3+0x48>
  802862:	39 f7                	cmp    %esi,%edi
  802864:	0f 86 a2 00 00 00    	jbe    80290c <__umoddi3+0xd8>
  80286a:	89 c8                	mov    %ecx,%eax
  80286c:	89 f2                	mov    %esi,%edx
  80286e:	f7 f7                	div    %edi
  802870:	89 d0                	mov    %edx,%eax
  802872:	31 d2                	xor    %edx,%edx
  802874:	83 c4 1c             	add    $0x1c,%esp
  802877:	5b                   	pop    %ebx
  802878:	5e                   	pop    %esi
  802879:	5f                   	pop    %edi
  80287a:	5d                   	pop    %ebp
  80287b:	c3                   	ret    
  80287c:	39 f0                	cmp    %esi,%eax
  80287e:	0f 87 ac 00 00 00    	ja     802930 <__umoddi3+0xfc>
  802884:	0f bd e8             	bsr    %eax,%ebp
  802887:	83 f5 1f             	xor    $0x1f,%ebp
  80288a:	0f 84 ac 00 00 00    	je     80293c <__umoddi3+0x108>
  802890:	bf 20 00 00 00       	mov    $0x20,%edi
  802895:	29 ef                	sub    %ebp,%edi
  802897:	89 fe                	mov    %edi,%esi
  802899:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80289d:	89 e9                	mov    %ebp,%ecx
  80289f:	d3 e0                	shl    %cl,%eax
  8028a1:	89 d7                	mov    %edx,%edi
  8028a3:	89 f1                	mov    %esi,%ecx
  8028a5:	d3 ef                	shr    %cl,%edi
  8028a7:	09 c7                	or     %eax,%edi
  8028a9:	89 e9                	mov    %ebp,%ecx
  8028ab:	d3 e2                	shl    %cl,%edx
  8028ad:	89 14 24             	mov    %edx,(%esp)
  8028b0:	89 d8                	mov    %ebx,%eax
  8028b2:	d3 e0                	shl    %cl,%eax
  8028b4:	89 c2                	mov    %eax,%edx
  8028b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028ba:	d3 e0                	shl    %cl,%eax
  8028bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028c4:	89 f1                	mov    %esi,%ecx
  8028c6:	d3 e8                	shr    %cl,%eax
  8028c8:	09 d0                	or     %edx,%eax
  8028ca:	d3 eb                	shr    %cl,%ebx
  8028cc:	89 da                	mov    %ebx,%edx
  8028ce:	f7 f7                	div    %edi
  8028d0:	89 d3                	mov    %edx,%ebx
  8028d2:	f7 24 24             	mull   (%esp)
  8028d5:	89 c6                	mov    %eax,%esi
  8028d7:	89 d1                	mov    %edx,%ecx
  8028d9:	39 d3                	cmp    %edx,%ebx
  8028db:	0f 82 87 00 00 00    	jb     802968 <__umoddi3+0x134>
  8028e1:	0f 84 91 00 00 00    	je     802978 <__umoddi3+0x144>
  8028e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028eb:	29 f2                	sub    %esi,%edx
  8028ed:	19 cb                	sbb    %ecx,%ebx
  8028ef:	89 d8                	mov    %ebx,%eax
  8028f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028f5:	d3 e0                	shl    %cl,%eax
  8028f7:	89 e9                	mov    %ebp,%ecx
  8028f9:	d3 ea                	shr    %cl,%edx
  8028fb:	09 d0                	or     %edx,%eax
  8028fd:	89 e9                	mov    %ebp,%ecx
  8028ff:	d3 eb                	shr    %cl,%ebx
  802901:	89 da                	mov    %ebx,%edx
  802903:	83 c4 1c             	add    $0x1c,%esp
  802906:	5b                   	pop    %ebx
  802907:	5e                   	pop    %esi
  802908:	5f                   	pop    %edi
  802909:	5d                   	pop    %ebp
  80290a:	c3                   	ret    
  80290b:	90                   	nop
  80290c:	89 fd                	mov    %edi,%ebp
  80290e:	85 ff                	test   %edi,%edi
  802910:	75 0b                	jne    80291d <__umoddi3+0xe9>
  802912:	b8 01 00 00 00       	mov    $0x1,%eax
  802917:	31 d2                	xor    %edx,%edx
  802919:	f7 f7                	div    %edi
  80291b:	89 c5                	mov    %eax,%ebp
  80291d:	89 f0                	mov    %esi,%eax
  80291f:	31 d2                	xor    %edx,%edx
  802921:	f7 f5                	div    %ebp
  802923:	89 c8                	mov    %ecx,%eax
  802925:	f7 f5                	div    %ebp
  802927:	89 d0                	mov    %edx,%eax
  802929:	e9 44 ff ff ff       	jmp    802872 <__umoddi3+0x3e>
  80292e:	66 90                	xchg   %ax,%ax
  802930:	89 c8                	mov    %ecx,%eax
  802932:	89 f2                	mov    %esi,%edx
  802934:	83 c4 1c             	add    $0x1c,%esp
  802937:	5b                   	pop    %ebx
  802938:	5e                   	pop    %esi
  802939:	5f                   	pop    %edi
  80293a:	5d                   	pop    %ebp
  80293b:	c3                   	ret    
  80293c:	3b 04 24             	cmp    (%esp),%eax
  80293f:	72 06                	jb     802947 <__umoddi3+0x113>
  802941:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802945:	77 0f                	ja     802956 <__umoddi3+0x122>
  802947:	89 f2                	mov    %esi,%edx
  802949:	29 f9                	sub    %edi,%ecx
  80294b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80294f:	89 14 24             	mov    %edx,(%esp)
  802952:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802956:	8b 44 24 04          	mov    0x4(%esp),%eax
  80295a:	8b 14 24             	mov    (%esp),%edx
  80295d:	83 c4 1c             	add    $0x1c,%esp
  802960:	5b                   	pop    %ebx
  802961:	5e                   	pop    %esi
  802962:	5f                   	pop    %edi
  802963:	5d                   	pop    %ebp
  802964:	c3                   	ret    
  802965:	8d 76 00             	lea    0x0(%esi),%esi
  802968:	2b 04 24             	sub    (%esp),%eax
  80296b:	19 fa                	sbb    %edi,%edx
  80296d:	89 d1                	mov    %edx,%ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	e9 71 ff ff ff       	jmp    8028e7 <__umoddi3+0xb3>
  802976:	66 90                	xchg   %ax,%ax
  802978:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80297c:	72 ea                	jb     802968 <__umoddi3+0x134>
  80297e:	89 d9                	mov    %ebx,%ecx
  802980:	e9 62 ff ff ff       	jmp    8028e7 <__umoddi3+0xb3>
