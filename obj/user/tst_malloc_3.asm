
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
  800055:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8000a0:	e8 e9 0e 00 00       	call   800f8e <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 4c 1f 00 00       	call   801ffb <malloc>
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
  8000e2:	e8 48 21 00 00       	call   80222f <sys_calculate_free_frames>
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
  8000fe:	e8 77 21 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800103:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 e4 1e 00 00       	call   801ffb <malloc>
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
  800146:	e8 43 0e 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 2a 21 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 38 2a 80 00       	push   $0x802a38
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 bc 29 80 00       	push   $0x8029bc
  800164:	e8 25 0e 00 00       	call   800f8e <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 c1 20 00 00       	call   80222f <sys_calculate_free_frames>
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
  80019e:	e8 8c 20 00 00       	call   80222f <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 68 2a 80 00       	push   $0x802a68
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 bc 29 80 00       	push   $0x8029bc
  8001bb:	e8 ce 0d 00 00       	call   800f8e <_panic>
		int var;
		int found = 0;
  8001c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	e9 82 00 00 00       	jmp    800255 <_main+0x21d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8001d8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800215:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800280:	e8 09 0d 00 00       	call   800f8e <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 f0 1f 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  80028a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800290:	01 c0                	add    %eax,%eax
  800292:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	50                   	push   %eax
  800299:	e8 5d 1d 00 00       	call   801ffb <malloc>
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
  8002e2:	e8 a7 0c 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 8e 1f 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 38 2a 80 00       	push   $0x802a38
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 bc 29 80 00       	push   $0x8029bc
  800300:	e8 89 0c 00 00       	call   800f8e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 25 1f 00 00       	call   80222f <sys_calculate_free_frames>
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
  800343:	e8 e7 1e 00 00       	call   80222f <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 68 2a 80 00       	push   $0x802a68
  800359:	6a 58                	push   $0x58
  80035b:	68 bc 29 80 00       	push   $0x8029bc
  800360:	e8 29 0c 00 00       	call   800f8e <_panic>
		found = 0;
  800365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80036c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800373:	e9 86 00 00 00       	jmp    8003fe <_main+0x3c6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800378:	a1 04 40 80 00       	mov    0x804004,%eax
  80037d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8003ba:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800429:	e8 60 0b 00 00       	call   800f8e <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 47 1e 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800433:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	01 d2                	add    %edx,%edx
  80043d:	01 d0                	add    %edx,%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 b3 1b 00 00       	call   801ffb <malloc>
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
  80048e:	e8 fb 0a 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 e2 1d 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 38 2a 80 00       	push   $0x802a38
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 bc 29 80 00       	push   $0x8029bc
  8004ac:	e8 dd 0a 00 00       	call   800f8e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 79 1d 00 00       	call   80222f <sys_calculate_free_frames>
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
  8004ed:	e8 3d 1d 00 00       	call   80222f <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 68 2a 80 00       	push   $0x802a68
  800503:	6a 6e                	push   $0x6e
  800505:	68 bc 29 80 00       	push   $0x8029bc
  80050a:	e8 7f 0a 00 00       	call   800f8e <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 8f 00 00 00       	jmp    8005b1 <_main+0x579>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 04 40 80 00       	mov    0x804004,%eax
  800527:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800564:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8005dc:	e8 ad 09 00 00       	call   800f8e <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 49 1c 00 00       	call   80222f <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 8c 1c 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  8005ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f4:	89 c2                	mov    %eax,%edx
  8005f6:	01 d2                	add    %edx,%edx
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 f8 19 00 00       	call   801ffb <malloc>
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
  80065d:	e8 2c 09 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 13 1c 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 38 2a 80 00       	push   $0x802a38
  800674:	6a 7e                	push   $0x7e
  800676:	68 bc 29 80 00       	push   $0x8029bc
  80067b:	e8 0e 09 00 00       	call   800f8e <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 f5 1b 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
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
  800699:	e8 5d 19 00 00       	call   801ffb <malloc>
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
  8006fb:	e8 8e 08 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 75 1b 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 38 2a 80 00       	push   $0x802a38
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 bc 29 80 00       	push   $0x8029bc
  80071c:	e8 6d 08 00 00       	call   800f8e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 09 1b 00 00       	call   80222f <sys_calculate_free_frames>
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
  8007c5:	e8 65 1a 00 00       	call   80222f <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 68 2a 80 00       	push   $0x802a68
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 bc 29 80 00       	push   $0x8029bc
  8007e5:	e8 a4 07 00 00       	call   800f8e <_panic>
		found = 0;
  8007ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007f8:	e9 aa 00 00 00       	jmp    8008a7 <_main+0x86f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007fd:	a1 04 40 80 00       	mov    0x804004,%eax
  800802:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  80084e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8008d5:	e8 b4 06 00 00       	call   800f8e <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 50 19 00 00       	call   80222f <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 93 19 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  8008e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	01 d2                	add    %edx,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	83 ec 0c             	sub    $0xc,%esp
  8008f9:	50                   	push   %eax
  8008fa:	e8 fc 16 00 00       	call   801ffb <malloc>
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
  80095c:	e8 2d 06 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 14 19 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 38 2a 80 00       	push   $0x802a38
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 bc 29 80 00       	push   $0x8029bc
  80097d:	e8 0c 06 00 00       	call   800f8e <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 f3 18 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
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
  80099c:	e8 5a 16 00 00       	call   801ffb <malloc>
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
  800a0c:	e8 7d 05 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 64 18 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 38 2a 80 00       	push   $0x802a38
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 bc 29 80 00       	push   $0x8029bc
  800a2d:	e8 5c 05 00 00       	call   800f8e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 f8 17 00 00       	call   80222f <sys_calculate_free_frames>
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
  800aa3:	e8 87 17 00 00       	call   80222f <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 68 2a 80 00       	push   $0x802a68
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 bc 29 80 00       	push   $0x8029bc
  800ac3:	e8 c6 04 00 00       	call   800f8e <_panic>
		found = 0;
  800ac8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ad6:	e9 02 01 00 00       	jmp    800bdd <_main+0xba5>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800adb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800b2c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800b8b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800c0b:	e8 7e 03 00 00       	call   800f8e <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 65 16 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
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
  800c2b:	e8 cb 13 00 00       	call   801ffb <malloc>
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
  800c9d:	e8 ec 02 00 00       	call   800f8e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 d3 15 00 00       	call   80227a <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 38 2a 80 00       	push   $0x802a38
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 bc 29 80 00       	push   $0x8029bc
  800cbe:	e8 cb 02 00 00       	call   800f8e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 67 15 00 00       	call   80222f <sys_calculate_free_frames>
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
  800d17:	e8 13 15 00 00       	call   80222f <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 68 2a 80 00       	push   $0x802a68
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 bc 29 80 00       	push   $0x8029bc
  800d37:	e8 52 02 00 00       	call   800f8e <_panic>
		found = 0;
  800d3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d4a:	e9 a7 00 00 00       	jmp    800df6 <_main+0xdbe>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d4f:	a1 04 40 80 00       	mov    0x804004,%eax
  800d54:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800da0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800e24:	e8 65 01 00 00       	call   800f8e <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 cc 2a 80 00       	push   $0x802acc
  800e31:	e8 15 04 00 00       	call   80124b <cprintf>
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
  800e47:	e8 ac 15 00 00       	call   8023f8 <sys_getenvindex>
  800e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	c1 e0 06             	shl    $0x6,%eax
  800e57:	29 d0                	sub    %edx,%eax
  800e59:	c1 e0 02             	shl    $0x2,%eax
  800e5c:	01 d0                	add    %edx,%eax
  800e5e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e65:	01 c8                	add    %ecx,%eax
  800e67:	c1 e0 03             	shl    $0x3,%eax
  800e6a:	01 d0                	add    %edx,%eax
  800e6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e73:	29 c2                	sub    %eax,%edx
  800e75:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800e84:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e89:	a1 04 40 80 00       	mov    0x804004,%eax
  800e8e:	8a 40 20             	mov    0x20(%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	74 0d                	je     800ea2 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800e95:	a1 04 40 80 00       	mov    0x804004,%eax
  800e9a:	83 c0 20             	add    $0x20,%eax
  800e9d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea6:	7e 0a                	jle    800eb2 <libmain+0x71>
		binaryname = argv[0];
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	ff 75 08             	pushl  0x8(%ebp)
  800ebb:	e8 78 f1 ff ff       	call   800038 <_main>
  800ec0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800ec3:	e8 b4 12 00 00       	call   80217c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 20 2b 80 00       	push   $0x802b20
  800ed0:	e8 76 03 00 00       	call   80124b <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ed8:	a1 04 40 80 00       	mov    0x804004,%eax
  800edd:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800ee3:	a1 04 40 80 00       	mov    0x804004,%eax
  800ee8:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	52                   	push   %edx
  800ef2:	50                   	push   %eax
  800ef3:	68 48 2b 80 00       	push   $0x802b48
  800ef8:	e8 4e 03 00 00       	call   80124b <cprintf>
  800efd:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800f00:	a1 04 40 80 00       	mov    0x804004,%eax
  800f05:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800f0b:	a1 04 40 80 00       	mov    0x804004,%eax
  800f10:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800f16:	a1 04 40 80 00       	mov    0x804004,%eax
  800f1b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800f21:	51                   	push   %ecx
  800f22:	52                   	push   %edx
  800f23:	50                   	push   %eax
  800f24:	68 70 2b 80 00       	push   $0x802b70
  800f29:	e8 1d 03 00 00       	call   80124b <cprintf>
  800f2e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f31:	a1 04 40 80 00       	mov    0x804004,%eax
  800f36:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	50                   	push   %eax
  800f40:	68 c8 2b 80 00       	push   $0x802bc8
  800f45:	e8 01 03 00 00       	call   80124b <cprintf>
  800f4a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	68 20 2b 80 00       	push   $0x802b20
  800f55:	e8 f1 02 00 00       	call   80124b <cprintf>
  800f5a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800f5d:	e8 34 12 00 00       	call   802196 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800f62:	e8 19 00 00 00       	call   800f80 <exit>
}
  800f67:	90                   	nop
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	6a 00                	push   $0x0
  800f75:	e8 4a 14 00 00       	call   8023c4 <sys_destroy_env>
  800f7a:	83 c4 10             	add    $0x10,%esp
}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <exit>:

void
exit(void)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f86:	e8 9f 14 00 00       	call   80242a <sys_exit_env>
}
  800f8b:	90                   	nop
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f94:	8d 45 10             	lea    0x10(%ebp),%eax
  800f97:	83 c0 04             	add    $0x4,%eax
  800f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f9d:	a1 24 40 80 00       	mov    0x804024,%eax
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	74 16                	je     800fbc <_panic+0x2e>
		cprintf("%s: ", argv0);
  800fa6:	a1 24 40 80 00       	mov    0x804024,%eax
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	50                   	push   %eax
  800faf:	68 dc 2b 80 00       	push   $0x802bdc
  800fb4:	e8 92 02 00 00       	call   80124b <cprintf>
  800fb9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fbc:	a1 00 40 80 00       	mov    0x804000,%eax
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	ff 75 08             	pushl  0x8(%ebp)
  800fc7:	50                   	push   %eax
  800fc8:	68 e1 2b 80 00       	push   $0x802be1
  800fcd:	e8 79 02 00 00       	call   80124b <cprintf>
  800fd2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fde:	50                   	push   %eax
  800fdf:	e8 fc 01 00 00       	call   8011e0 <vcprintf>
  800fe4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	6a 00                	push   $0x0
  800fec:	68 fd 2b 80 00       	push   $0x802bfd
  800ff1:	e8 ea 01 00 00       	call   8011e0 <vcprintf>
  800ff6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ff9:	e8 82 ff ff ff       	call   800f80 <exit>

	// should not return here
	while (1) ;
  800ffe:	eb fe                	jmp    800ffe <_panic+0x70>

00801000 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801006:	a1 04 40 80 00       	mov    0x804004,%eax
  80100b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	39 c2                	cmp    %eax,%edx
  801016:	74 14                	je     80102c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	68 00 2c 80 00       	push   $0x802c00
  801020:	6a 26                	push   $0x26
  801022:	68 4c 2c 80 00       	push   $0x802c4c
  801027:	e8 62 ff ff ff       	call   800f8e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80102c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801033:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80103a:	e9 c5 00 00 00       	jmp    801104 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80103f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	85 c0                	test   %eax,%eax
  801052:	75 08                	jne    80105c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801054:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801057:	e9 a5 00 00 00       	jmp    801101 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80105c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801063:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80106a:	eb 69                	jmp    8010d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80106c:	a1 04 40 80 00       	mov    0x804004,%eax
  801071:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801077:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80107a:	89 d0                	mov    %edx,%eax
  80107c:	01 c0                	add    %eax,%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	c1 e0 03             	shl    $0x3,%eax
  801083:	01 c8                	add    %ecx,%eax
  801085:	8a 40 04             	mov    0x4(%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	75 46                	jne    8010d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80108c:	a1 04 40 80 00       	mov    0x804004,%eax
  801091:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801097:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	01 c0                	add    %eax,%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	c1 e0 03             	shl    $0x3,%eax
  8010a3:	01 c8                	add    %ecx,%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	01 c8                	add    %ecx,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010c5:	39 c2                	cmp    %eax,%edx
  8010c7:	75 09                	jne    8010d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010d0:	eb 15                	jmp    8010e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010d2:	ff 45 e8             	incl   -0x18(%ebp)
  8010d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8010da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8010e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010e3:	39 c2                	cmp    %eax,%edx
  8010e5:	77 85                	ja     80106c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010eb:	75 14                	jne    801101 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	68 58 2c 80 00       	push   $0x802c58
  8010f5:	6a 3a                	push   $0x3a
  8010f7:	68 4c 2c 80 00       	push   $0x802c4c
  8010fc:	e8 8d fe ff ff       	call   800f8e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801101:	ff 45 f0             	incl   -0x10(%ebp)
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80110a:	0f 8c 2f ff ff ff    	jl     80103f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801110:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80111e:	eb 26                	jmp    801146 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801120:	a1 04 40 80 00       	mov    0x804004,%eax
  801125:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80112b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80112e:	89 d0                	mov    %edx,%eax
  801130:	01 c0                	add    %eax,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	c1 e0 03             	shl    $0x3,%eax
  801137:	01 c8                	add    %ecx,%eax
  801139:	8a 40 04             	mov    0x4(%eax),%al
  80113c:	3c 01                	cmp    $0x1,%al
  80113e:	75 03                	jne    801143 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801140:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801143:	ff 45 e0             	incl   -0x20(%ebp)
  801146:	a1 04 40 80 00       	mov    0x804004,%eax
  80114b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801154:	39 c2                	cmp    %eax,%edx
  801156:	77 c8                	ja     801120 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80115e:	74 14                	je     801174 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801160:	83 ec 04             	sub    $0x4,%esp
  801163:	68 ac 2c 80 00       	push   $0x802cac
  801168:	6a 44                	push   $0x44
  80116a:	68 4c 2c 80 00       	push   $0x802c4c
  80116f:	e8 1a fe ff ff       	call   800f8e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 48 01             	lea    0x1(%eax),%ecx
  801185:	8b 55 0c             	mov    0xc(%ebp),%edx
  801188:	89 0a                	mov    %ecx,(%edx)
  80118a:	8b 55 08             	mov    0x8(%ebp),%edx
  80118d:	88 d1                	mov    %dl,%cl
  80118f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801192:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 00                	mov    (%eax),%eax
  80119b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a0:	75 2c                	jne    8011ce <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8011a2:	a0 08 40 80 00       	mov    0x804008,%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ad:	8b 12                	mov    (%edx),%edx
  8011af:	89 d1                	mov    %edx,%ecx
  8011b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b4:	83 c2 08             	add    $0x8,%edx
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	50                   	push   %eax
  8011bb:	51                   	push   %ecx
  8011bc:	52                   	push   %edx
  8011bd:	e8 78 0f 00 00       	call   80213a <sys_cputs>
  8011c2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	8b 40 04             	mov    0x4(%eax),%eax
  8011d4:	8d 50 01             	lea    0x1(%eax),%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011dd:	90                   	nop
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011f0:	00 00 00 
	b.cnt = 0;
  8011f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	68 77 11 80 00       	push   $0x801177
  80120f:	e8 11 02 00 00       	call   801425 <vprintfmt>
  801214:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801217:	a0 08 40 80 00       	mov    0x804008,%al
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	50                   	push   %eax
  801229:	52                   	push   %edx
  80122a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801230:	83 c0 08             	add    $0x8,%eax
  801233:	50                   	push   %eax
  801234:	e8 01 0f 00 00       	call   80213a <sys_cputs>
  801239:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80123c:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  801243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801251:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  801258:	8d 45 0c             	lea    0xc(%ebp),%eax
  80125b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 f4             	pushl  -0xc(%ebp)
  801267:	50                   	push   %eax
  801268:	e8 73 ff ff ff       	call   8011e0 <vcprintf>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801273:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80127e:	e8 f9 0e 00 00       	call   80217c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801283:	8d 45 0c             	lea    0xc(%ebp),%eax
  801286:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	50                   	push   %eax
  801293:	e8 48 ff ff ff       	call   8011e0 <vcprintf>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80129e:	e8 f3 0e 00 00       	call   802196 <sys_unlock_cons>
	return cnt;
  8012a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 14             	sub    $0x14,%esp
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8012be:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012c6:	77 55                	ja     80131d <printnum+0x75>
  8012c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012cb:	72 05                	jb     8012d2 <printnum+0x2a>
  8012cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d0:	77 4b                	ja     80131d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8012db:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e0:	52                   	push   %edx
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e8:	e8 4f 14 00 00       	call   80273c <__udivdi3>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	ff 75 20             	pushl  0x20(%ebp)
  8012f6:	53                   	push   %ebx
  8012f7:	ff 75 18             	pushl  0x18(%ebp)
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	ff 75 08             	pushl  0x8(%ebp)
  801302:	e8 a1 ff ff ff       	call   8012a8 <printnum>
  801307:	83 c4 20             	add    $0x20,%esp
  80130a:	eb 1a                	jmp    801326 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80130c:	83 ec 08             	sub    $0x8,%esp
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	ff 75 20             	pushl  0x20(%ebp)
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	ff d0                	call   *%eax
  80131a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80131d:	ff 4d 1c             	decl   0x1c(%ebp)
  801320:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801324:	7f e6                	jg     80130c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801326:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801329:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	53                   	push   %ebx
  801335:	51                   	push   %ecx
  801336:	52                   	push   %edx
  801337:	50                   	push   %eax
  801338:	e8 0f 15 00 00       	call   80284c <__umoddi3>
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	05 14 2f 80 00       	add    $0x802f14,%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	0f be c0             	movsbl %al,%eax
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	50                   	push   %eax
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	ff d0                	call   *%eax
  801356:	83 c4 10             	add    $0x10,%esp
}
  801359:	90                   	nop
  80135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801362:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801366:	7e 1c                	jle    801384 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	8d 50 08             	lea    0x8(%eax),%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 10                	mov    %edx,(%eax)
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	83 e8 08             	sub    $0x8,%eax
  80137d:	8b 50 04             	mov    0x4(%eax),%edx
  801380:	8b 00                	mov    (%eax),%eax
  801382:	eb 40                	jmp    8013c4 <getuint+0x65>
	else if (lflag)
  801384:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801388:	74 1e                	je     8013a8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 50 04             	lea    0x4(%eax),%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 10                	mov    %edx,(%eax)
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8b 00                	mov    (%eax),%eax
  80139c:	83 e8 04             	sub    $0x4,%eax
  80139f:	8b 00                	mov    (%eax),%eax
  8013a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a6:	eb 1c                	jmp    8013c4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8b 00                	mov    (%eax),%eax
  8013ad:	8d 50 04             	lea    0x4(%eax),%edx
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	89 10                	mov    %edx,(%eax)
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	83 e8 04             	sub    $0x4,%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013cd:	7e 1c                	jle    8013eb <getint+0x25>
		return va_arg(*ap, long long);
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	8d 50 08             	lea    0x8(%eax),%edx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	89 10                	mov    %edx,(%eax)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	83 e8 08             	sub    $0x8,%eax
  8013e4:	8b 50 04             	mov    0x4(%eax),%edx
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	eb 38                	jmp    801423 <getint+0x5d>
	else if (lflag)
  8013eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ef:	74 1a                	je     80140b <getint+0x45>
		return va_arg(*ap, long);
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8b 00                	mov    (%eax),%eax
  8013f6:	8d 50 04             	lea    0x4(%eax),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	89 10                	mov    %edx,(%eax)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	83 e8 04             	sub    $0x4,%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	99                   	cltd   
  801409:	eb 18                	jmp    801423 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	8d 50 04             	lea    0x4(%eax),%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	89 10                	mov    %edx,(%eax)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	83 e8 04             	sub    $0x4,%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	99                   	cltd   
}
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80142d:	eb 17                	jmp    801446 <vprintfmt+0x21>
			if (ch == '\0')
  80142f:	85 db                	test   %ebx,%ebx
  801431:	0f 84 c1 03 00 00    	je     8017f8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	53                   	push   %ebx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	ff d0                	call   *%eax
  801443:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	8d 50 01             	lea    0x1(%eax),%edx
  80144c:	89 55 10             	mov    %edx,0x10(%ebp)
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f b6 d8             	movzbl %al,%ebx
  801454:	83 fb 25             	cmp    $0x25,%ebx
  801457:	75 d6                	jne    80142f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801459:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80145d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801464:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80146b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801472:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	8d 50 01             	lea    0x1(%eax),%edx
  80147f:	89 55 10             	mov    %edx,0x10(%ebp)
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f b6 d8             	movzbl %al,%ebx
  801487:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80148a:	83 f8 5b             	cmp    $0x5b,%eax
  80148d:	0f 87 3d 03 00 00    	ja     8017d0 <vprintfmt+0x3ab>
  801493:	8b 04 85 38 2f 80 00 	mov    0x802f38(,%eax,4),%eax
  80149a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80149c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8014a0:	eb d7                	jmp    801479 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014a2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8014a6:	eb d1                	jmp    801479 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b2:	89 d0                	mov    %edx,%eax
  8014b4:	c1 e0 02             	shl    $0x2,%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	01 c0                	add    %eax,%eax
  8014bb:	01 d8                	add    %ebx,%eax
  8014bd:	83 e8 30             	sub    $0x30,%eax
  8014c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014cb:	83 fb 2f             	cmp    $0x2f,%ebx
  8014ce:	7e 3e                	jle    80150e <vprintfmt+0xe9>
  8014d0:	83 fb 39             	cmp    $0x39,%ebx
  8014d3:	7f 39                	jg     80150e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014d5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014d8:	eb d5                	jmp    8014af <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	83 c0 04             	add    $0x4,%eax
  8014e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	83 e8 04             	sub    $0x4,%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014ee:	eb 1f                	jmp    80150f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014f4:	79 83                	jns    801479 <vprintfmt+0x54>
				width = 0;
  8014f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014fd:	e9 77 ff ff ff       	jmp    801479 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801502:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801509:	e9 6b ff ff ff       	jmp    801479 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80150e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80150f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801513:	0f 89 60 ff ff ff    	jns    801479 <vprintfmt+0x54>
				width = precision, precision = -1;
  801519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80151f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801526:	e9 4e ff ff ff       	jmp    801479 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80152b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80152e:	e9 46 ff ff ff       	jmp    801479 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801533:	8b 45 14             	mov    0x14(%ebp),%eax
  801536:	83 c0 04             	add    $0x4,%eax
  801539:	89 45 14             	mov    %eax,0x14(%ebp)
  80153c:	8b 45 14             	mov    0x14(%ebp),%eax
  80153f:	83 e8 04             	sub    $0x4,%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	ff d0                	call   *%eax
  801550:	83 c4 10             	add    $0x10,%esp
			break;
  801553:	e9 9b 02 00 00       	jmp    8017f3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801558:	8b 45 14             	mov    0x14(%ebp),%eax
  80155b:	83 c0 04             	add    $0x4,%eax
  80155e:	89 45 14             	mov    %eax,0x14(%ebp)
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	83 e8 04             	sub    $0x4,%eax
  801567:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801569:	85 db                	test   %ebx,%ebx
  80156b:	79 02                	jns    80156f <vprintfmt+0x14a>
				err = -err;
  80156d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80156f:	83 fb 64             	cmp    $0x64,%ebx
  801572:	7f 0b                	jg     80157f <vprintfmt+0x15a>
  801574:	8b 34 9d 80 2d 80 00 	mov    0x802d80(,%ebx,4),%esi
  80157b:	85 f6                	test   %esi,%esi
  80157d:	75 19                	jne    801598 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80157f:	53                   	push   %ebx
  801580:	68 25 2f 80 00       	push   $0x802f25
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	e8 70 02 00 00       	call   801800 <printfmt>
  801590:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801593:	e9 5b 02 00 00       	jmp    8017f3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801598:	56                   	push   %esi
  801599:	68 2e 2f 80 00       	push   $0x802f2e
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 57 02 00 00       	call   801800 <printfmt>
  8015a9:	83 c4 10             	add    $0x10,%esp
			break;
  8015ac:	e9 42 02 00 00       	jmp    8017f3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b4:	83 c0 04             	add    $0x4,%eax
  8015b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bd:	83 e8 04             	sub    $0x4,%eax
  8015c0:	8b 30                	mov    (%eax),%esi
  8015c2:	85 f6                	test   %esi,%esi
  8015c4:	75 05                	jne    8015cb <vprintfmt+0x1a6>
				p = "(null)";
  8015c6:	be 31 2f 80 00       	mov    $0x802f31,%esi
			if (width > 0 && padc != '-')
  8015cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015cf:	7e 6d                	jle    80163e <vprintfmt+0x219>
  8015d1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015d5:	74 67                	je     80163e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	50                   	push   %eax
  8015de:	56                   	push   %esi
  8015df:	e8 1e 03 00 00       	call   801902 <strnlen>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015ea:	eb 16                	jmp    801602 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015ec:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	50                   	push   %eax
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	ff d0                	call   *%eax
  8015fc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015ff:	ff 4d e4             	decl   -0x1c(%ebp)
  801602:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801606:	7f e4                	jg     8015ec <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801608:	eb 34                	jmp    80163e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80160a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80160e:	74 1c                	je     80162c <vprintfmt+0x207>
  801610:	83 fb 1f             	cmp    $0x1f,%ebx
  801613:	7e 05                	jle    80161a <vprintfmt+0x1f5>
  801615:	83 fb 7e             	cmp    $0x7e,%ebx
  801618:	7e 12                	jle    80162c <vprintfmt+0x207>
					putch('?', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 3f                	push   $0x3f
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	eb 0f                	jmp    80163b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	53                   	push   %ebx
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80163b:	ff 4d e4             	decl   -0x1c(%ebp)
  80163e:	89 f0                	mov    %esi,%eax
  801640:	8d 70 01             	lea    0x1(%eax),%esi
  801643:	8a 00                	mov    (%eax),%al
  801645:	0f be d8             	movsbl %al,%ebx
  801648:	85 db                	test   %ebx,%ebx
  80164a:	74 24                	je     801670 <vprintfmt+0x24b>
  80164c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801650:	78 b8                	js     80160a <vprintfmt+0x1e5>
  801652:	ff 4d e0             	decl   -0x20(%ebp)
  801655:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801659:	79 af                	jns    80160a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80165b:	eb 13                	jmp    801670 <vprintfmt+0x24b>
				putch(' ', putdat);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	6a 20                	push   $0x20
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	ff d0                	call   *%eax
  80166a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80166d:	ff 4d e4             	decl   -0x1c(%ebp)
  801670:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801674:	7f e7                	jg     80165d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801676:	e9 78 01 00 00       	jmp    8017f3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	ff 75 e8             	pushl  -0x18(%ebp)
  801681:	8d 45 14             	lea    0x14(%ebp),%eax
  801684:	50                   	push   %eax
  801685:	e8 3c fd ff ff       	call   8013c6 <getint>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801690:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801699:	85 d2                	test   %edx,%edx
  80169b:	79 23                	jns    8016c0 <vprintfmt+0x29b>
				putch('-', putdat);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	6a 2d                	push   $0x2d
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	ff d0                	call   *%eax
  8016aa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	f7 d8                	neg    %eax
  8016b5:	83 d2 00             	adc    $0x0,%edx
  8016b8:	f7 da                	neg    %edx
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016c7:	e9 bc 00 00 00       	jmp    801788 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	e8 84 fc ff ff       	call   80135f <getuint>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016e4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016eb:	e9 98 00 00 00       	jmp    801788 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	6a 58                	push   $0x58
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	ff d0                	call   *%eax
  8016fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801700:	83 ec 08             	sub    $0x8,%esp
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	6a 58                	push   $0x58
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	ff d0                	call   *%eax
  80170d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	6a 58                	push   $0x58
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	ff d0                	call   *%eax
  80171d:	83 c4 10             	add    $0x10,%esp
			break;
  801720:	e9 ce 00 00 00       	jmp    8017f3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	6a 30                	push   $0x30
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	ff d0                	call   *%eax
  801732:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	6a 78                	push   $0x78
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	ff d0                	call   *%eax
  801742:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	83 c0 04             	add    $0x4,%eax
  80174b:	89 45 14             	mov    %eax,0x14(%ebp)
  80174e:	8b 45 14             	mov    0x14(%ebp),%eax
  801751:	83 e8 04             	sub    $0x4,%eax
  801754:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801760:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801767:	eb 1f                	jmp    801788 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 e8             	pushl  -0x18(%ebp)
  80176f:	8d 45 14             	lea    0x14(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	e8 e7 fb ff ff       	call   80135f <getuint>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80177e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801781:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801788:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80178c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	52                   	push   %edx
  801793:	ff 75 e4             	pushl  -0x1c(%ebp)
  801796:	50                   	push   %eax
  801797:	ff 75 f4             	pushl  -0xc(%ebp)
  80179a:	ff 75 f0             	pushl  -0x10(%ebp)
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	e8 00 fb ff ff       	call   8012a8 <printnum>
  8017a8:	83 c4 20             	add    $0x20,%esp
			break;
  8017ab:	eb 46                	jmp    8017f3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	53                   	push   %ebx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	ff d0                	call   *%eax
  8017b9:	83 c4 10             	add    $0x10,%esp
			break;
  8017bc:	eb 35                	jmp    8017f3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8017be:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8017c5:	eb 2c                	jmp    8017f3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8017c7:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8017ce:	eb 23                	jmp    8017f3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	6a 25                	push   $0x25
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	ff d0                	call   *%eax
  8017dd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017e0:	ff 4d 10             	decl   0x10(%ebp)
  8017e3:	eb 03                	jmp    8017e8 <vprintfmt+0x3c3>
  8017e5:	ff 4d 10             	decl   0x10(%ebp)
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	48                   	dec    %eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	3c 25                	cmp    $0x25,%al
  8017f0:	75 f3                	jne    8017e5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8017f2:	90                   	nop
		}
	}
  8017f3:	e9 35 fc ff ff       	jmp    80142d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017f8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801806:	8d 45 10             	lea    0x10(%ebp),%eax
  801809:	83 c0 04             	add    $0x4,%eax
  80180c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	50                   	push   %eax
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 04 fc ff ff       	call   801425 <vprintfmt>
  801821:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801824:	90                   	nop
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	8b 40 08             	mov    0x8(%eax),%eax
  801830:	8d 50 01             	lea    0x1(%eax),%edx
  801833:	8b 45 0c             	mov    0xc(%ebp),%eax
  801836:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	8b 10                	mov    (%eax),%edx
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	8b 40 04             	mov    0x4(%eax),%eax
  801844:	39 c2                	cmp    %eax,%edx
  801846:	73 12                	jae    80185a <sprintputch+0x33>
		*b->buf++ = ch;
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	8b 00                	mov    (%eax),%eax
  80184d:	8d 48 01             	lea    0x1(%eax),%ecx
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	89 0a                	mov    %ecx,(%edx)
  801855:	8b 55 08             	mov    0x8(%ebp),%edx
  801858:	88 10                	mov    %dl,(%eax)
}
  80185a:	90                   	nop
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	01 d0                	add    %edx,%eax
  801874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801877:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80187e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801882:	74 06                	je     80188a <vsnprintf+0x2d>
  801884:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801888:	7f 07                	jg     801891 <vsnprintf+0x34>
		return -E_INVAL;
  80188a:	b8 03 00 00 00       	mov    $0x3,%eax
  80188f:	eb 20                	jmp    8018b1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801891:	ff 75 14             	pushl  0x14(%ebp)
  801894:	ff 75 10             	pushl  0x10(%ebp)
  801897:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80189a:	50                   	push   %eax
  80189b:	68 27 18 80 00       	push   $0x801827
  8018a0:	e8 80 fb ff ff       	call   801425 <vprintfmt>
  8018a5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8018a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8018bc:	83 c0 04             	add    $0x4,%eax
  8018bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	e8 89 ff ff ff       	call   80185d <vsnprintf>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ec:	eb 06                	jmp    8018f4 <strlen+0x15>
		n++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018f1:	ff 45 08             	incl   0x8(%ebp)
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	84 c0                	test   %al,%al
  8018fb:	75 f1                	jne    8018ee <strlen+0xf>
		n++;
	return n;
  8018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801908:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80190f:	eb 09                	jmp    80191a <strnlen+0x18>
		n++;
  801911:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801914:	ff 45 08             	incl   0x8(%ebp)
  801917:	ff 4d 0c             	decl   0xc(%ebp)
  80191a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80191e:	74 09                	je     801929 <strnlen+0x27>
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	8a 00                	mov    (%eax),%al
  801925:	84 c0                	test   %al,%al
  801927:	75 e8                	jne    801911 <strnlen+0xf>
		n++;
	return n;
  801929:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80193a:	90                   	nop
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8d 50 01             	lea    0x1(%eax),%edx
  801941:	89 55 08             	mov    %edx,0x8(%ebp)
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8d 4a 01             	lea    0x1(%edx),%ecx
  80194a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80194d:	8a 12                	mov    (%edx),%dl
  80194f:	88 10                	mov    %dl,(%eax)
  801951:	8a 00                	mov    (%eax),%al
  801953:	84 c0                	test   %al,%al
  801955:	75 e4                	jne    80193b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801957:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80196f:	eb 1f                	jmp    801990 <strncpy+0x34>
		*dst++ = *src;
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	8d 50 01             	lea    0x1(%eax),%edx
  801977:	89 55 08             	mov    %edx,0x8(%ebp)
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8a 12                	mov    (%edx),%dl
  80197f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801981:	8b 45 0c             	mov    0xc(%ebp),%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	84 c0                	test   %al,%al
  801988:	74 03                	je     80198d <strncpy+0x31>
			src++;
  80198a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80198d:	ff 45 fc             	incl   -0x4(%ebp)
  801990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801993:	3b 45 10             	cmp    0x10(%ebp),%eax
  801996:	72 d9                	jb     801971 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801998:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ad:	74 30                	je     8019df <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019af:	eb 16                	jmp    8019c7 <strlcpy+0x2a>
			*dst++ = *src++;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8d 50 01             	lea    0x1(%eax),%edx
  8019b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019c0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019c3:	8a 12                	mov    (%edx),%dl
  8019c5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019c7:	ff 4d 10             	decl   0x10(%ebp)
  8019ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ce:	74 09                	je     8019d9 <strlcpy+0x3c>
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	84 c0                	test   %al,%al
  8019d7:	75 d8                	jne    8019b1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019df:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e5:	29 c2                	sub    %eax,%edx
  8019e7:	89 d0                	mov    %edx,%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ee:	eb 06                	jmp    8019f6 <strcmp+0xb>
		p++, q++;
  8019f0:	ff 45 08             	incl   0x8(%ebp)
  8019f3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strcmp+0x22>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 e3                	je     8019f0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	0f b6 d0             	movzbl %al,%edx
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	0f b6 c0             	movzbl %al,%eax
  801a1d:	29 c2                	sub    %eax,%edx
  801a1f:	89 d0                	mov    %edx,%eax
}
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a26:	eb 09                	jmp    801a31 <strncmp+0xe>
		n--, p++, q++;
  801a28:	ff 4d 10             	decl   0x10(%ebp)
  801a2b:	ff 45 08             	incl   0x8(%ebp)
  801a2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a35:	74 17                	je     801a4e <strncmp+0x2b>
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	84 c0                	test   %al,%al
  801a3e:	74 0e                	je     801a4e <strncmp+0x2b>
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8a 10                	mov    (%eax),%dl
  801a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a48:	8a 00                	mov    (%eax),%al
  801a4a:	38 c2                	cmp    %al,%dl
  801a4c:	74 da                	je     801a28 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a52:	75 07                	jne    801a5b <strncmp+0x38>
		return 0;
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
  801a59:	eb 14                	jmp    801a6f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	0f b6 d0             	movzbl %al,%edx
  801a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a66:	8a 00                	mov    (%eax),%al
  801a68:	0f b6 c0             	movzbl %al,%eax
  801a6b:	29 c2                	sub    %eax,%edx
  801a6d:	89 d0                	mov    %edx,%eax
}
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a7d:	eb 12                	jmp    801a91 <strchr+0x20>
		if (*s == c)
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a87:	75 05                	jne    801a8e <strchr+0x1d>
			return (char *) s;
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	eb 11                	jmp    801a9f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a8e:	ff 45 08             	incl   0x8(%ebp)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8a 00                	mov    (%eax),%al
  801a96:	84 c0                	test   %al,%al
  801a98:	75 e5                	jne    801a7f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801aad:	eb 0d                	jmp    801abc <strfind+0x1b>
		if (*s == c)
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	8a 00                	mov    (%eax),%al
  801ab4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ab7:	74 0e                	je     801ac7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ab9:	ff 45 08             	incl   0x8(%ebp)
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	8a 00                	mov    (%eax),%al
  801ac1:	84 c0                	test   %al,%al
  801ac3:	75 ea                	jne    801aaf <strfind+0xe>
  801ac5:	eb 01                	jmp    801ac8 <strfind+0x27>
		if (*s == c)
			break;
  801ac7:	90                   	nop
	return (char *) s;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  801adc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801adf:	eb 0e                	jmp    801aef <memset+0x22>
		*p++ = c;
  801ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae4:	8d 50 01             	lea    0x1(%eax),%edx
  801ae7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aef:	ff 4d f8             	decl   -0x8(%ebp)
  801af2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801af6:	79 e9                	jns    801ae1 <memset+0x14>
		*p++ = c;

	return v;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b0f:	eb 16                	jmp    801b27 <memcpy+0x2a>
		*d++ = *s++;
  801b11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b14:	8d 50 01             	lea    0x1(%eax),%edx
  801b17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b20:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b23:	8a 12                	mov    (%edx),%dl
  801b25:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b27:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b2d:	89 55 10             	mov    %edx,0x10(%ebp)
  801b30:	85 c0                	test   %eax,%eax
  801b32:	75 dd                	jne    801b11 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b51:	73 50                	jae    801ba3 <memmove+0x6a>
  801b53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	01 d0                	add    %edx,%eax
  801b5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b5e:	76 43                	jbe    801ba3 <memmove+0x6a>
		s += n;
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b66:	8b 45 10             	mov    0x10(%ebp),%eax
  801b69:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b6c:	eb 10                	jmp    801b7e <memmove+0x45>
			*--d = *--s;
  801b6e:	ff 4d f8             	decl   -0x8(%ebp)
  801b71:	ff 4d fc             	decl   -0x4(%ebp)
  801b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b77:	8a 10                	mov    (%eax),%dl
  801b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b81:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b84:	89 55 10             	mov    %edx,0x10(%ebp)
  801b87:	85 c0                	test   %eax,%eax
  801b89:	75 e3                	jne    801b6e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b8b:	eb 23                	jmp    801bb0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8d 50 01             	lea    0x1(%eax),%edx
  801b93:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b99:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b9c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b9f:	8a 12                	mov    (%edx),%dl
  801ba1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ba9:	89 55 10             	mov    %edx,0x10(%ebp)
  801bac:	85 c0                	test   %eax,%eax
  801bae:	75 dd                	jne    801b8d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bc7:	eb 2a                	jmp    801bf3 <memcmp+0x3e>
		if (*s1 != *s2)
  801bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bcc:	8a 10                	mov    (%eax),%dl
  801bce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd1:	8a 00                	mov    (%eax),%al
  801bd3:	38 c2                	cmp    %al,%dl
  801bd5:	74 16                	je     801bed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bda:	8a 00                	mov    (%eax),%al
  801bdc:	0f b6 d0             	movzbl %al,%edx
  801bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	29 c2                	sub    %eax,%edx
  801be9:	89 d0                	mov    %edx,%eax
  801beb:	eb 18                	jmp    801c05 <memcmp+0x50>
		s1++, s2++;
  801bed:	ff 45 fc             	incl   -0x4(%ebp)
  801bf0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bf9:	89 55 10             	mov    %edx,0x10(%ebp)
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 c9                	jne    801bc9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801c10:	8b 45 10             	mov    0x10(%ebp),%eax
  801c13:	01 d0                	add    %edx,%eax
  801c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c18:	eb 15                	jmp    801c2f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	0f b6 d0             	movzbl %al,%edx
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	0f b6 c0             	movzbl %al,%eax
  801c28:	39 c2                	cmp    %eax,%edx
  801c2a:	74 0d                	je     801c39 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c2c:	ff 45 08             	incl   0x8(%ebp)
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c35:	72 e3                	jb     801c1a <memfind+0x13>
  801c37:	eb 01                	jmp    801c3a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c39:	90                   	nop
	return (void *) s;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c4c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c53:	eb 03                	jmp    801c58 <strtol+0x19>
		s++;
  801c55:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8a 00                	mov    (%eax),%al
  801c5d:	3c 20                	cmp    $0x20,%al
  801c5f:	74 f4                	je     801c55 <strtol+0x16>
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	3c 09                	cmp    $0x9,%al
  801c68:	74 eb                	je     801c55 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3c 2b                	cmp    $0x2b,%al
  801c71:	75 05                	jne    801c78 <strtol+0x39>
		s++;
  801c73:	ff 45 08             	incl   0x8(%ebp)
  801c76:	eb 13                	jmp    801c8b <strtol+0x4c>
	else if (*s == '-')
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	8a 00                	mov    (%eax),%al
  801c7d:	3c 2d                	cmp    $0x2d,%al
  801c7f:	75 0a                	jne    801c8b <strtol+0x4c>
		s++, neg = 1;
  801c81:	ff 45 08             	incl   0x8(%ebp)
  801c84:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c8f:	74 06                	je     801c97 <strtol+0x58>
  801c91:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c95:	75 20                	jne    801cb7 <strtol+0x78>
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	3c 30                	cmp    $0x30,%al
  801c9e:	75 17                	jne    801cb7 <strtol+0x78>
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	40                   	inc    %eax
  801ca4:	8a 00                	mov    (%eax),%al
  801ca6:	3c 78                	cmp    $0x78,%al
  801ca8:	75 0d                	jne    801cb7 <strtol+0x78>
		s += 2, base = 16;
  801caa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801cae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801cb5:	eb 28                	jmp    801cdf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801cb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cbb:	75 15                	jne    801cd2 <strtol+0x93>
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8a 00                	mov    (%eax),%al
  801cc2:	3c 30                	cmp    $0x30,%al
  801cc4:	75 0c                	jne    801cd2 <strtol+0x93>
		s++, base = 8;
  801cc6:	ff 45 08             	incl   0x8(%ebp)
  801cc9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cd0:	eb 0d                	jmp    801cdf <strtol+0xa0>
	else if (base == 0)
  801cd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cd6:	75 07                	jne    801cdf <strtol+0xa0>
		base = 10;
  801cd8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8a 00                	mov    (%eax),%al
  801ce4:	3c 2f                	cmp    $0x2f,%al
  801ce6:	7e 19                	jle    801d01 <strtol+0xc2>
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	8a 00                	mov    (%eax),%al
  801ced:	3c 39                	cmp    $0x39,%al
  801cef:	7f 10                	jg     801d01 <strtol+0xc2>
			dig = *s - '0';
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	8a 00                	mov    (%eax),%al
  801cf6:	0f be c0             	movsbl %al,%eax
  801cf9:	83 e8 30             	sub    $0x30,%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	eb 42                	jmp    801d43 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8a 00                	mov    (%eax),%al
  801d06:	3c 60                	cmp    $0x60,%al
  801d08:	7e 19                	jle    801d23 <strtol+0xe4>
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8a 00                	mov    (%eax),%al
  801d0f:	3c 7a                	cmp    $0x7a,%al
  801d11:	7f 10                	jg     801d23 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8a 00                	mov    (%eax),%al
  801d18:	0f be c0             	movsbl %al,%eax
  801d1b:	83 e8 57             	sub    $0x57,%eax
  801d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d21:	eb 20                	jmp    801d43 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8a 00                	mov    (%eax),%al
  801d28:	3c 40                	cmp    $0x40,%al
  801d2a:	7e 39                	jle    801d65 <strtol+0x126>
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8a 00                	mov    (%eax),%al
  801d31:	3c 5a                	cmp    $0x5a,%al
  801d33:	7f 30                	jg     801d65 <strtol+0x126>
			dig = *s - 'A' + 10;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	8a 00                	mov    (%eax),%al
  801d3a:	0f be c0             	movsbl %al,%eax
  801d3d:	83 e8 37             	sub    $0x37,%eax
  801d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d49:	7d 19                	jge    801d64 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d4b:	ff 45 08             	incl   0x8(%ebp)
  801d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d51:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d55:	89 c2                	mov    %eax,%edx
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d5f:	e9 7b ff ff ff       	jmp    801cdf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d64:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d69:	74 08                	je     801d73 <strtol+0x134>
		*endptr = (char *) s;
  801d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d71:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d73:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d77:	74 07                	je     801d80 <strtol+0x141>
  801d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7c:	f7 d8                	neg    %eax
  801d7e:	eb 03                	jmp    801d83 <strtol+0x144>
  801d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <ltostr>:

void
ltostr(long value, char *str)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d92:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d9d:	79 13                	jns    801db2 <ltostr+0x2d>
	{
		neg = 1;
  801d9f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801dac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801daf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801dba:	99                   	cltd   
  801dbb:	f7 f9                	idiv   %ecx
  801dbd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc3:	8d 50 01             	lea    0x1(%eax),%edx
  801dc6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dc9:	89 c2                	mov    %eax,%edx
  801dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dce:	01 d0                	add    %edx,%eax
  801dd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dd3:	83 c2 30             	add    $0x30,%edx
  801dd6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801de0:	f7 e9                	imul   %ecx
  801de2:	c1 fa 02             	sar    $0x2,%edx
  801de5:	89 c8                	mov    %ecx,%eax
  801de7:	c1 f8 1f             	sar    $0x1f,%eax
  801dea:	29 c2                	sub    %eax,%edx
  801dec:	89 d0                	mov    %edx,%eax
  801dee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801df5:	75 bb                	jne    801db2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e01:	48                   	dec    %eax
  801e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e09:	74 3d                	je     801e48 <ltostr+0xc3>
		start = 1 ;
  801e0b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e12:	eb 34                	jmp    801e48 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	8a 00                	mov    (%eax),%al
  801e1e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	01 c2                	add    %eax,%edx
  801e29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	01 c8                	add    %ecx,%eax
  801e31:	8a 00                	mov    (%eax),%al
  801e33:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3b:	01 c2                	add    %eax,%edx
  801e3d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e40:	88 02                	mov    %al,(%edx)
		start++ ;
  801e42:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e45:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e4e:	7c c4                	jl     801e14 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e50:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e56:	01 d0                	add    %edx,%eax
  801e58:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	e8 73 fa ff ff       	call   8018df <strlen>
  801e6c:	83 c4 04             	add    $0x4,%esp
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e72:	ff 75 0c             	pushl  0xc(%ebp)
  801e75:	e8 65 fa ff ff       	call   8018df <strlen>
  801e7a:	83 c4 04             	add    $0x4,%esp
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e8e:	eb 17                	jmp    801ea7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e93:	8b 45 10             	mov    0x10(%ebp),%eax
  801e96:	01 c2                	add    %eax,%edx
  801e98:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	01 c8                	add    %ecx,%eax
  801ea0:	8a 00                	mov    (%eax),%al
  801ea2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ea4:	ff 45 fc             	incl   -0x4(%ebp)
  801ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eaa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ead:	7c e1                	jl     801e90 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801eaf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801eb6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ebd:	eb 1f                	jmp    801ede <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec2:	8d 50 01             	lea    0x1(%eax),%edx
  801ec5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ec8:	89 c2                	mov    %eax,%edx
  801eca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecd:	01 c2                	add    %eax,%edx
  801ecf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	01 c8                	add    %ecx,%eax
  801ed7:	8a 00                	mov    (%eax),%al
  801ed9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801edb:	ff 45 f8             	incl   -0x8(%ebp)
  801ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ee4:	7c d9                	jl     801ebf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	c6 00 00             	movb   $0x0,(%eax)
}
  801ef1:	90                   	nop
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ef7:	8b 45 14             	mov    0x14(%ebp),%eax
  801efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801f00:	8b 45 14             	mov    0x14(%ebp),%eax
  801f03:	8b 00                	mov    (%eax),%eax
  801f05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	01 d0                	add    %edx,%eax
  801f11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f17:	eb 0c                	jmp    801f25 <strsplit+0x31>
			*string++ = 0;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8d 50 01             	lea    0x1(%eax),%edx
  801f1f:	89 55 08             	mov    %edx,0x8(%ebp)
  801f22:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	8a 00                	mov    (%eax),%al
  801f2a:	84 c0                	test   %al,%al
  801f2c:	74 18                	je     801f46 <strsplit+0x52>
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8a 00                	mov    (%eax),%al
  801f33:	0f be c0             	movsbl %al,%eax
  801f36:	50                   	push   %eax
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	e8 32 fb ff ff       	call   801a71 <strchr>
  801f3f:	83 c4 08             	add    $0x8,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 d3                	jne    801f19 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8a 00                	mov    (%eax),%al
  801f4b:	84 c0                	test   %al,%al
  801f4d:	74 5a                	je     801fa9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	83 f8 0f             	cmp    $0xf,%eax
  801f57:	75 07                	jne    801f60 <strsplit+0x6c>
		{
			return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	eb 66                	jmp    801fc6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f60:	8b 45 14             	mov    0x14(%ebp),%eax
  801f63:	8b 00                	mov    (%eax),%eax
  801f65:	8d 48 01             	lea    0x1(%eax),%ecx
  801f68:	8b 55 14             	mov    0x14(%ebp),%edx
  801f6b:	89 0a                	mov    %ecx,(%edx)
  801f6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f74:	8b 45 10             	mov    0x10(%ebp),%eax
  801f77:	01 c2                	add    %eax,%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f7e:	eb 03                	jmp    801f83 <strsplit+0x8f>
			string++;
  801f80:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	8a 00                	mov    (%eax),%al
  801f88:	84 c0                	test   %al,%al
  801f8a:	74 8b                	je     801f17 <strsplit+0x23>
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	8a 00                	mov    (%eax),%al
  801f91:	0f be c0             	movsbl %al,%eax
  801f94:	50                   	push   %eax
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	e8 d4 fa ff ff       	call   801a71 <strchr>
  801f9d:	83 c4 08             	add    $0x8,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	74 dc                	je     801f80 <strsplit+0x8c>
			string++;
	}
  801fa4:	e9 6e ff ff ff       	jmp    801f17 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fa9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801faa:	8b 45 14             	mov    0x14(%ebp),%eax
  801fad:	8b 00                	mov    (%eax),%eax
  801faf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	68 a8 30 80 00       	push   $0x8030a8
  801fd6:	68 3f 01 00 00       	push   $0x13f
  801fdb:	68 ca 30 80 00       	push   $0x8030ca
  801fe0:	e8 a9 ef ff ff       	call   800f8e <_panic>

00801fe5 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	e8 ef 06 00 00       	call   8026e5 <sys_sbrk>
  801ff6:	83 c4 10             	add    $0x10,%esp
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802005:	75 07                	jne    80200e <malloc+0x13>
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	eb 14                	jmp    802022 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 d8 30 80 00       	push   $0x8030d8
  802016:	6a 1b                	push   $0x1b
  802018:	68 fd 30 80 00       	push   $0x8030fd
  80201d:	e8 6c ef ff ff       	call   800f8e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 0c 31 80 00       	push   $0x80310c
  802032:	6a 29                	push   $0x29
  802034:	68 fd 30 80 00       	push   $0x8030fd
  802039:	e8 50 ef ff ff       	call   800f8e <_panic>

0080203e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 18             	sub    $0x18,%esp
  802044:	8b 45 10             	mov    0x10(%ebp),%eax
  802047:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80204a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80204e:	75 07                	jne    802057 <smalloc+0x19>
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	eb 14                	jmp    80206b <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 30 31 80 00       	push   $0x803130
  80205f:	6a 38                	push   $0x38
  802061:	68 fd 30 80 00       	push   $0x8030fd
  802066:	e8 23 ef ff ff       	call   800f8e <_panic>
	return NULL;
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 58 31 80 00       	push   $0x803158
  80207b:	6a 43                	push   $0x43
  80207d:	68 fd 30 80 00       	push   $0x8030fd
  802082:	e8 07 ef ff ff       	call   800f8e <_panic>

00802087 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	68 7c 31 80 00       	push   $0x80317c
  802095:	6a 5b                	push   $0x5b
  802097:	68 fd 30 80 00       	push   $0x8030fd
  80209c:	e8 ed ee ff ff       	call   800f8e <_panic>

008020a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 a0 31 80 00       	push   $0x8031a0
  8020af:	6a 72                	push   $0x72
  8020b1:	68 fd 30 80 00       	push   $0x8030fd
  8020b6:	e8 d3 ee ff ff       	call   800f8e <_panic>

008020bb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	68 c6 31 80 00       	push   $0x8031c6
  8020c9:	6a 7e                	push   $0x7e
  8020cb:	68 fd 30 80 00       	push   $0x8030fd
  8020d0:	e8 b9 ee ff ff       	call   800f8e <_panic>

008020d5 <shrink>:

}
void shrink(uint32 newSize)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 c6 31 80 00       	push   $0x8031c6
  8020e3:	68 83 00 00 00       	push   $0x83
  8020e8:	68 fd 30 80 00       	push   $0x8030fd
  8020ed:	e8 9c ee ff ff       	call   800f8e <_panic>

008020f2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 c6 31 80 00       	push   $0x8031c6
  802100:	68 88 00 00 00       	push   $0x88
  802105:	68 fd 30 80 00       	push   $0x8030fd
  80210a:	e8 7f ee ff ff       	call   800f8e <_panic>

0080210f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	57                   	push   %edi
  802113:	56                   	push   %esi
  802114:	53                   	push   %ebx
  802115:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802121:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802124:	8b 7d 18             	mov    0x18(%ebp),%edi
  802127:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80212a:	cd 30                	int    $0x30
  80212c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    

0080213a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	8b 45 10             	mov    0x10(%ebp),%eax
  802143:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802146:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	52                   	push   %edx
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	50                   	push   %eax
  802156:	6a 00                	push   $0x0
  802158:	e8 b2 ff ff ff       	call   80210f <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	90                   	nop
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_cgetc>:

int
sys_cgetc(void)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 02                	push   $0x2
  802172:	e8 98 ff ff ff       	call   80210f <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 03                	push   $0x3
  80218b:	e8 7f ff ff ff       	call   80210f <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 04                	push   $0x4
  8021a5:	e8 65 ff ff ff       	call   80210f <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	90                   	nop
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	6a 08                	push   $0x8
  8021c3:	e8 47 ff ff ff       	call   80210f <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8021d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	51                   	push   %ecx
  8021e4:	52                   	push   %edx
  8021e5:	50                   	push   %eax
  8021e6:	6a 09                	push   $0x9
  8021e8:	e8 22 ff ff ff       	call   80210f <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f3:	5b                   	pop    %ebx
  8021f4:	5e                   	pop    %esi
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	52                   	push   %edx
  802207:	50                   	push   %eax
  802208:	6a 0a                	push   $0xa
  80220a:	e8 00 ff ff ff       	call   80210f <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	ff 75 08             	pushl  0x8(%ebp)
  802223:	6a 0b                	push   $0xb
  802225:	e8 e5 fe ff ff       	call   80210f <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 0c                	push   $0xc
  80223e:	e8 cc fe ff ff       	call   80210f <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 0d                	push   $0xd
  802257:	e8 b3 fe ff ff       	call   80210f <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 0e                	push   $0xe
  802270:	e8 9a fe ff ff       	call   80210f <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 0f                	push   $0xf
  802289:	e8 81 fe ff ff       	call   80210f <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	6a 10                	push   $0x10
  8022a3:	e8 67 fe ff ff       	call   80210f <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 11                	push   $0x11
  8022bc:	e8 4e fe ff ff       	call   80210f <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	50                   	push   %eax
  8022e0:	6a 01                	push   $0x1
  8022e2:	e8 28 fe ff ff       	call   80210f <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 14                	push   $0x14
  8022fc:	e8 0e fe ff ff       	call   80210f <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	90                   	nop
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802313:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802316:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	51                   	push   %ecx
  802320:	52                   	push   %edx
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	50                   	push   %eax
  802325:	6a 15                	push   $0x15
  802327:	e8 e3 fd ff ff       	call   80210f <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 16                	push   $0x16
  802344:	e8 c6 fd ff ff       	call   80210f <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802351:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802354:	8b 55 0c             	mov    0xc(%ebp),%edx
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	51                   	push   %ecx
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	6a 17                	push   $0x17
  802363:	e8 a7 fd ff ff       	call   80210f <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802370:	8b 55 0c             	mov    0xc(%ebp),%edx
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	52                   	push   %edx
  80237d:	50                   	push   %eax
  80237e:	6a 18                	push   $0x18
  802380:	e8 8a fd ff ff       	call   80210f <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	ff 75 14             	pushl  0x14(%ebp)
  802395:	ff 75 10             	pushl  0x10(%ebp)
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	50                   	push   %eax
  80239c:	6a 19                	push   $0x19
  80239e:	e8 6c fd ff ff       	call   80210f <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	50                   	push   %eax
  8023b7:	6a 1a                	push   $0x1a
  8023b9:	e8 51 fd ff ff       	call   80210f <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	50                   	push   %eax
  8023d3:	6a 1b                	push   $0x1b
  8023d5:	e8 35 fd ff ff       	call   80210f <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 05                	push   $0x5
  8023ee:	e8 1c fd ff ff       	call   80210f <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 06                	push   $0x6
  802407:	e8 03 fd ff ff       	call   80210f <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 07                	push   $0x7
  802420:	e8 ea fc ff ff       	call   80210f <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_exit_env>:


void sys_exit_env(void)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 1c                	push   $0x1c
  802439:	e8 d1 fc ff ff       	call   80210f <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	90                   	nop
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80244a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244d:	8d 50 04             	lea    0x4(%eax),%edx
  802450:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	52                   	push   %edx
  80245a:	50                   	push   %eax
  80245b:	6a 1d                	push   $0x1d
  80245d:	e8 ad fc ff ff       	call   80210f <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return result;
  802465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802468:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246e:	89 01                	mov    %eax,(%ecx)
  802470:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	c9                   	leave  
  802477:	c2 04 00             	ret    $0x4

0080247a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 13                	push   $0x13
  80248c:	e8 7e fc ff ff       	call   80210f <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_rcr2>:
uint32 sys_rcr2()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 1e                	push   $0x1e
  8024a6:	e8 64 fc ff ff       	call   80210f <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024bc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	50                   	push   %eax
  8024c9:	6a 1f                	push   $0x1f
  8024cb:	e8 3f fc ff ff       	call   80210f <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <rsttst>:
void rsttst()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 21                	push   $0x21
  8024e5:	e8 25 fc ff ff       	call   80210f <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ed:	90                   	nop
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024fc:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	ff 75 10             	pushl  0x10(%ebp)
  802508:	ff 75 0c             	pushl  0xc(%ebp)
  80250b:	ff 75 08             	pushl  0x8(%ebp)
  80250e:	6a 20                	push   $0x20
  802510:	e8 fa fb ff ff       	call   80210f <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return ;
  802518:	90                   	nop
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <chktst>:
void chktst(uint32 n)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	ff 75 08             	pushl  0x8(%ebp)
  802529:	6a 22                	push   $0x22
  80252b:	e8 df fb ff ff       	call   80210f <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
	return ;
  802533:	90                   	nop
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <inctst>:

void inctst()
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 23                	push   $0x23
  802545:	e8 c5 fb ff ff       	call   80210f <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
	return ;
  80254d:	90                   	nop
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <gettst>:
uint32 gettst()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 24                	push   $0x24
  80255f:	e8 ab fb ff ff       	call   80210f <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 25                	push   $0x25
  80257b:	e8 8f fb ff ff       	call   80210f <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
  802583:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802586:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80258a:	75 07                	jne    802593 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80258c:	b8 01 00 00 00       	mov    $0x1,%eax
  802591:	eb 05                	jmp    802598 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 25                	push   $0x25
  8025ac:	e8 5e fb ff ff       	call   80210f <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
  8025b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025bb:	75 07                	jne    8025c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	eb 05                	jmp    8025c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 25                	push   $0x25
  8025dd:	e8 2d fb ff ff       	call   80210f <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
  8025e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025ec:	75 07                	jne    8025f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f3:	eb 05                	jmp    8025fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 25                	push   $0x25
  80260e:	e8 fc fa ff ff       	call   80210f <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
  802616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802619:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80261d:	75 07                	jne    802626 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80261f:	b8 01 00 00 00       	mov    $0x1,%eax
  802624:	eb 05                	jmp    80262b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	ff 75 08             	pushl  0x8(%ebp)
  80263b:	6a 26                	push   $0x26
  80263d:	e8 cd fa ff ff       	call   80210f <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
	return ;
  802645:	90                   	nop
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80264c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802652:	8b 55 0c             	mov    0xc(%ebp),%edx
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	53                   	push   %ebx
  80265b:	51                   	push   %ecx
  80265c:	52                   	push   %edx
  80265d:	50                   	push   %eax
  80265e:	6a 27                	push   $0x27
  802660:	e8 aa fa ff ff       	call   80210f <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
}
  802668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802670:	8b 55 0c             	mov    0xc(%ebp),%edx
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	52                   	push   %edx
  80267d:	50                   	push   %eax
  80267e:	6a 28                	push   $0x28
  802680:	e8 8a fa ff ff       	call   80210f <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80268d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802690:	8b 55 0c             	mov    0xc(%ebp),%edx
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	6a 00                	push   $0x0
  802698:	51                   	push   %ecx
  802699:	ff 75 10             	pushl  0x10(%ebp)
  80269c:	52                   	push   %edx
  80269d:	50                   	push   %eax
  80269e:	6a 29                	push   $0x29
  8026a0:	e8 6a fa ff ff       	call   80210f <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	ff 75 10             	pushl  0x10(%ebp)
  8026b4:	ff 75 0c             	pushl  0xc(%ebp)
  8026b7:	ff 75 08             	pushl  0x8(%ebp)
  8026ba:	6a 12                	push   $0x12
  8026bc:	e8 4e fa ff ff       	call   80210f <syscall>
  8026c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c4:	90                   	nop
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	52                   	push   %edx
  8026d7:	50                   	push   %eax
  8026d8:	6a 2a                	push   $0x2a
  8026da:	e8 30 fa ff ff       	call   80210f <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
	return;
  8026e2:	90                   	nop
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 d6 31 80 00       	push   $0x8031d6
  8026f3:	68 2e 01 00 00       	push   $0x12e
  8026f8:	68 ea 31 80 00       	push   $0x8031ea
  8026fd:	e8 8c e8 ff ff       	call   800f8e <_panic>

00802702 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 d6 31 80 00       	push   $0x8031d6
  802710:	68 35 01 00 00       	push   $0x135
  802715:	68 ea 31 80 00       	push   $0x8031ea
  80271a:	e8 6f e8 ff ff       	call   800f8e <_panic>

0080271f <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	68 d6 31 80 00       	push   $0x8031d6
  80272d:	68 3b 01 00 00       	push   $0x13b
  802732:	68 ea 31 80 00       	push   $0x8031ea
  802737:	e8 52 e8 ff ff       	call   800f8e <_panic>

0080273c <__udivdi3>:
  80273c:	55                   	push   %ebp
  80273d:	57                   	push   %edi
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	83 ec 1c             	sub    $0x1c,%esp
  802743:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802747:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80274b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80274f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802753:	89 ca                	mov    %ecx,%edx
  802755:	89 f8                	mov    %edi,%eax
  802757:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80275b:	85 f6                	test   %esi,%esi
  80275d:	75 2d                	jne    80278c <__udivdi3+0x50>
  80275f:	39 cf                	cmp    %ecx,%edi
  802761:	77 65                	ja     8027c8 <__udivdi3+0x8c>
  802763:	89 fd                	mov    %edi,%ebp
  802765:	85 ff                	test   %edi,%edi
  802767:	75 0b                	jne    802774 <__udivdi3+0x38>
  802769:	b8 01 00 00 00       	mov    $0x1,%eax
  80276e:	31 d2                	xor    %edx,%edx
  802770:	f7 f7                	div    %edi
  802772:	89 c5                	mov    %eax,%ebp
  802774:	31 d2                	xor    %edx,%edx
  802776:	89 c8                	mov    %ecx,%eax
  802778:	f7 f5                	div    %ebp
  80277a:	89 c1                	mov    %eax,%ecx
  80277c:	89 d8                	mov    %ebx,%eax
  80277e:	f7 f5                	div    %ebp
  802780:	89 cf                	mov    %ecx,%edi
  802782:	89 fa                	mov    %edi,%edx
  802784:	83 c4 1c             	add    $0x1c,%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5f                   	pop    %edi
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    
  80278c:	39 ce                	cmp    %ecx,%esi
  80278e:	77 28                	ja     8027b8 <__udivdi3+0x7c>
  802790:	0f bd fe             	bsr    %esi,%edi
  802793:	83 f7 1f             	xor    $0x1f,%edi
  802796:	75 40                	jne    8027d8 <__udivdi3+0x9c>
  802798:	39 ce                	cmp    %ecx,%esi
  80279a:	72 0a                	jb     8027a6 <__udivdi3+0x6a>
  80279c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027a0:	0f 87 9e 00 00 00    	ja     802844 <__udivdi3+0x108>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	83 c4 1c             	add    $0x1c,%esp
  8027b0:	5b                   	pop    %ebx
  8027b1:	5e                   	pop    %esi
  8027b2:	5f                   	pop    %edi
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    
  8027b5:	8d 76 00             	lea    0x0(%esi),%esi
  8027b8:	31 ff                	xor    %edi,%edi
  8027ba:	31 c0                	xor    %eax,%eax
  8027bc:	89 fa                	mov    %edi,%edx
  8027be:	83 c4 1c             	add    $0x1c,%esp
  8027c1:	5b                   	pop    %ebx
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	89 d8                	mov    %ebx,%eax
  8027ca:	f7 f7                	div    %edi
  8027cc:	31 ff                	xor    %edi,%edi
  8027ce:	89 fa                	mov    %edi,%edx
  8027d0:	83 c4 1c             	add    $0x1c,%esp
  8027d3:	5b                   	pop    %ebx
  8027d4:	5e                   	pop    %esi
  8027d5:	5f                   	pop    %edi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    
  8027d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027dd:	89 eb                	mov    %ebp,%ebx
  8027df:	29 fb                	sub    %edi,%ebx
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e6                	shl    %cl,%esi
  8027e5:	89 c5                	mov    %eax,%ebp
  8027e7:	88 d9                	mov    %bl,%cl
  8027e9:	d3 ed                	shr    %cl,%ebp
  8027eb:	89 e9                	mov    %ebp,%ecx
  8027ed:	09 f1                	or     %esi,%ecx
  8027ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027f3:	89 f9                	mov    %edi,%ecx
  8027f5:	d3 e0                	shl    %cl,%eax
  8027f7:	89 c5                	mov    %eax,%ebp
  8027f9:	89 d6                	mov    %edx,%esi
  8027fb:	88 d9                	mov    %bl,%cl
  8027fd:	d3 ee                	shr    %cl,%esi
  8027ff:	89 f9                	mov    %edi,%ecx
  802801:	d3 e2                	shl    %cl,%edx
  802803:	8b 44 24 08          	mov    0x8(%esp),%eax
  802807:	88 d9                	mov    %bl,%cl
  802809:	d3 e8                	shr    %cl,%eax
  80280b:	09 c2                	or     %eax,%edx
  80280d:	89 d0                	mov    %edx,%eax
  80280f:	89 f2                	mov    %esi,%edx
  802811:	f7 74 24 0c          	divl   0xc(%esp)
  802815:	89 d6                	mov    %edx,%esi
  802817:	89 c3                	mov    %eax,%ebx
  802819:	f7 e5                	mul    %ebp
  80281b:	39 d6                	cmp    %edx,%esi
  80281d:	72 19                	jb     802838 <__udivdi3+0xfc>
  80281f:	74 0b                	je     80282c <__udivdi3+0xf0>
  802821:	89 d8                	mov    %ebx,%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 58 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802830:	89 f9                	mov    %edi,%ecx
  802832:	d3 e2                	shl    %cl,%edx
  802834:	39 c2                	cmp    %eax,%edx
  802836:	73 e9                	jae    802821 <__udivdi3+0xe5>
  802838:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80283b:	31 ff                	xor    %edi,%edi
  80283d:	e9 40 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  802842:	66 90                	xchg   %ax,%ax
  802844:	31 c0                	xor    %eax,%eax
  802846:	e9 37 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  80284b:	90                   	nop

0080284c <__umoddi3>:
  80284c:	55                   	push   %ebp
  80284d:	57                   	push   %edi
  80284e:	56                   	push   %esi
  80284f:	53                   	push   %ebx
  802850:	83 ec 1c             	sub    $0x1c,%esp
  802853:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802857:	8b 74 24 34          	mov    0x34(%esp),%esi
  80285b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80285f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802867:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80286b:	89 f3                	mov    %esi,%ebx
  80286d:	89 fa                	mov    %edi,%edx
  80286f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802873:	89 34 24             	mov    %esi,(%esp)
  802876:	85 c0                	test   %eax,%eax
  802878:	75 1a                	jne    802894 <__umoddi3+0x48>
  80287a:	39 f7                	cmp    %esi,%edi
  80287c:	0f 86 a2 00 00 00    	jbe    802924 <__umoddi3+0xd8>
  802882:	89 c8                	mov    %ecx,%eax
  802884:	89 f2                	mov    %esi,%edx
  802886:	f7 f7                	div    %edi
  802888:	89 d0                	mov    %edx,%eax
  80288a:	31 d2                	xor    %edx,%edx
  80288c:	83 c4 1c             	add    $0x1c,%esp
  80288f:	5b                   	pop    %ebx
  802890:	5e                   	pop    %esi
  802891:	5f                   	pop    %edi
  802892:	5d                   	pop    %ebp
  802893:	c3                   	ret    
  802894:	39 f0                	cmp    %esi,%eax
  802896:	0f 87 ac 00 00 00    	ja     802948 <__umoddi3+0xfc>
  80289c:	0f bd e8             	bsr    %eax,%ebp
  80289f:	83 f5 1f             	xor    $0x1f,%ebp
  8028a2:	0f 84 ac 00 00 00    	je     802954 <__umoddi3+0x108>
  8028a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8028ad:	29 ef                	sub    %ebp,%edi
  8028af:	89 fe                	mov    %edi,%esi
  8028b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028b5:	89 e9                	mov    %ebp,%ecx
  8028b7:	d3 e0                	shl    %cl,%eax
  8028b9:	89 d7                	mov    %edx,%edi
  8028bb:	89 f1                	mov    %esi,%ecx
  8028bd:	d3 ef                	shr    %cl,%edi
  8028bf:	09 c7                	or     %eax,%edi
  8028c1:	89 e9                	mov    %ebp,%ecx
  8028c3:	d3 e2                	shl    %cl,%edx
  8028c5:	89 14 24             	mov    %edx,(%esp)
  8028c8:	89 d8                	mov    %ebx,%eax
  8028ca:	d3 e0                	shl    %cl,%eax
  8028cc:	89 c2                	mov    %eax,%edx
  8028ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028d2:	d3 e0                	shl    %cl,%eax
  8028d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028dc:	89 f1                	mov    %esi,%ecx
  8028de:	d3 e8                	shr    %cl,%eax
  8028e0:	09 d0                	or     %edx,%eax
  8028e2:	d3 eb                	shr    %cl,%ebx
  8028e4:	89 da                	mov    %ebx,%edx
  8028e6:	f7 f7                	div    %edi
  8028e8:	89 d3                	mov    %edx,%ebx
  8028ea:	f7 24 24             	mull   (%esp)
  8028ed:	89 c6                	mov    %eax,%esi
  8028ef:	89 d1                	mov    %edx,%ecx
  8028f1:	39 d3                	cmp    %edx,%ebx
  8028f3:	0f 82 87 00 00 00    	jb     802980 <__umoddi3+0x134>
  8028f9:	0f 84 91 00 00 00    	je     802990 <__umoddi3+0x144>
  8028ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802903:	29 f2                	sub    %esi,%edx
  802905:	19 cb                	sbb    %ecx,%ebx
  802907:	89 d8                	mov    %ebx,%eax
  802909:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80290d:	d3 e0                	shl    %cl,%eax
  80290f:	89 e9                	mov    %ebp,%ecx
  802911:	d3 ea                	shr    %cl,%edx
  802913:	09 d0                	or     %edx,%eax
  802915:	89 e9                	mov    %ebp,%ecx
  802917:	d3 eb                	shr    %cl,%ebx
  802919:	89 da                	mov    %ebx,%edx
  80291b:	83 c4 1c             	add    $0x1c,%esp
  80291e:	5b                   	pop    %ebx
  80291f:	5e                   	pop    %esi
  802920:	5f                   	pop    %edi
  802921:	5d                   	pop    %ebp
  802922:	c3                   	ret    
  802923:	90                   	nop
  802924:	89 fd                	mov    %edi,%ebp
  802926:	85 ff                	test   %edi,%edi
  802928:	75 0b                	jne    802935 <__umoddi3+0xe9>
  80292a:	b8 01 00 00 00       	mov    $0x1,%eax
  80292f:	31 d2                	xor    %edx,%edx
  802931:	f7 f7                	div    %edi
  802933:	89 c5                	mov    %eax,%ebp
  802935:	89 f0                	mov    %esi,%eax
  802937:	31 d2                	xor    %edx,%edx
  802939:	f7 f5                	div    %ebp
  80293b:	89 c8                	mov    %ecx,%eax
  80293d:	f7 f5                	div    %ebp
  80293f:	89 d0                	mov    %edx,%eax
  802941:	e9 44 ff ff ff       	jmp    80288a <__umoddi3+0x3e>
  802946:	66 90                	xchg   %ax,%ax
  802948:	89 c8                	mov    %ecx,%eax
  80294a:	89 f2                	mov    %esi,%edx
  80294c:	83 c4 1c             	add    $0x1c,%esp
  80294f:	5b                   	pop    %ebx
  802950:	5e                   	pop    %esi
  802951:	5f                   	pop    %edi
  802952:	5d                   	pop    %ebp
  802953:	c3                   	ret    
  802954:	3b 04 24             	cmp    (%esp),%eax
  802957:	72 06                	jb     80295f <__umoddi3+0x113>
  802959:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80295d:	77 0f                	ja     80296e <__umoddi3+0x122>
  80295f:	89 f2                	mov    %esi,%edx
  802961:	29 f9                	sub    %edi,%ecx
  802963:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802967:	89 14 24             	mov    %edx,(%esp)
  80296a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80296e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802972:	8b 14 24             	mov    (%esp),%edx
  802975:	83 c4 1c             	add    $0x1c,%esp
  802978:	5b                   	pop    %ebx
  802979:	5e                   	pop    %esi
  80297a:	5f                   	pop    %edi
  80297b:	5d                   	pop    %ebp
  80297c:	c3                   	ret    
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	2b 04 24             	sub    (%esp),%eax
  802983:	19 fa                	sbb    %edi,%edx
  802985:	89 d1                	mov    %edx,%ecx
  802987:	89 c6                	mov    %eax,%esi
  802989:	e9 71 ff ff ff       	jmp    8028ff <__umoddi3+0xb3>
  80298e:	66 90                	xchg   %ax,%ax
  802990:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802994:	72 ea                	jb     802980 <__umoddi3+0x134>
  802996:	89 d9                	mov    %ebx,%ecx
  802998:	e9 62 ff ff ff       	jmp    8028ff <__umoddi3+0xb3>
