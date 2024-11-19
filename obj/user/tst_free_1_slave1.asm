
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 b7 02 00 00       	call   8002ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/
#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 04 30 80 00       	mov    0x803004,%eax
  800048:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004e:	a1 04 30 80 00       	mov    0x803004,%eax
  800053:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 40 1e 80 00       	push   $0x801e40
  800065:	6a 11                	push   $0x11
  800067:	68 5c 1e 80 00       	push   $0x801e5c
  80006c:	e8 b3 03 00 00       	call   800424 <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 04 16 00 00       	call   8016c5 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 47 16 00 00       	call   801710 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 b4 13 00 00       	call   801491 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 78 1e 80 00       	push   $0x801e78
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 5c 1e 80 00       	push   $0x801e5c
  800100:	e8 1f 03 00 00       	call   800424 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 06 16 00 00       	call   801710 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 1e 80 00       	push   $0x801ea8
  800117:	6a 33                	push   $0x33
  800119:	68 5c 1e 80 00       	push   $0x801e5c
  80011e:	e8 01 03 00 00       	call   800424 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 9d 15 00 00       	call   8016c5 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 61 15 00 00       	call   8016c5 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 d8 1e 80 00       	push   $0x801ed8
  800181:	6a 3d                	push   $0x3d
  800183:	68 5c 1e 80 00       	push   $0x801e5c
  800188:	e8 97 02 00 00       	call   800424 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 54 19 00 00       	call   801b20 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 1f 80 00       	push   $0x801f54
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 5c 1e 80 00       	push   $0x801e5c
  8001e7:	e8 38 02 00 00       	call   800424 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 d4 14 00 00       	call   8016c5 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 17 15 00 00       	call   801710 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 af 12 00 00       	call   8014ba <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 fd 14 00 00       	call   801710 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 1f 80 00       	push   $0x801f74
  800220:	6a 4e                	push   $0x4e
  800222:	68 5c 1e 80 00       	push   $0x801e5c
  800227:	e8 f8 01 00 00       	call   800424 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 94 14 00 00       	call   8016c5 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 1f 80 00       	push   $0x801fb0
  800247:	6a 4f                	push   $0x4f
  800249:	68 5c 1e 80 00       	push   $0x801e5c
  80024e:	e8 d1 01 00 00       	call   800424 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 8e 18 00 00       	call   801b20 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 1f 80 00       	push   $0x801ffc
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 5c 1e 80 00       	push   $0x801e5c
  8002ad:	e8 72 01 00 00       	call   800424 <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 15 17 00 00       	call   8019cc <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 29 17 00 00       	call   8019e6 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002cd:	01 c2                	add    %eax,%edx
  8002cf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002d2:	88 02                	mov    %al,(%edx)
		inctst();
  8002d4:	e8 f3 16 00 00       	call   8019cc <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 20 20 80 00       	push   $0x802020
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 5c 1e 80 00       	push   $0x801e5c
  8002e8:	e8 37 01 00 00       	call   800424 <_panic>

008002ed <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002f3:	e8 96 15 00 00       	call   80188e <sys_getenvindex>
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002fe:	89 d0                	mov    %edx,%eax
  800300:	c1 e0 02             	shl    $0x2,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	01 c0                	add    %eax,%eax
  800307:	01 d0                	add    %edx,%eax
  800309:	c1 e0 02             	shl    $0x2,%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	01 c0                	add    %eax,%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	c1 e0 04             	shl    $0x4,%eax
  800315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80031a:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80031f:	a1 04 30 80 00       	mov    0x803004,%eax
  800324:	8a 40 20             	mov    0x20(%eax),%al
  800327:	84 c0                	test   %al,%al
  800329:	74 0d                	je     800338 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80032b:	a1 04 30 80 00       	mov    0x803004,%eax
  800330:	83 c0 20             	add    $0x20,%eax
  800333:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033c:	7e 0a                	jle    800348 <libmain+0x5b>
		binaryname = argv[0];
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	8b 00                	mov    (%eax),%eax
  800343:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	ff 75 0c             	pushl  0xc(%ebp)
  80034e:	ff 75 08             	pushl  0x8(%ebp)
  800351:	e8 e2 fc ff ff       	call   800038 <_main>
  800356:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800359:	e8 b4 12 00 00       	call   801612 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	68 84 20 80 00       	push   $0x802084
  800366:	e8 76 03 00 00       	call   8006e1 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80036e:	a1 04 30 80 00       	mov    0x803004,%eax
  800373:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800379:	a1 04 30 80 00       	mov    0x803004,%eax
  80037e:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	52                   	push   %edx
  800388:	50                   	push   %eax
  800389:	68 ac 20 80 00       	push   $0x8020ac
  80038e:	e8 4e 03 00 00       	call   8006e1 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800396:	a1 04 30 80 00       	mov    0x803004,%eax
  80039b:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8003a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8003a6:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8003ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8003b1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8003b7:	51                   	push   %ecx
  8003b8:	52                   	push   %edx
  8003b9:	50                   	push   %eax
  8003ba:	68 d4 20 80 00       	push   $0x8020d4
  8003bf:	e8 1d 03 00 00       	call   8006e1 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8003cc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	50                   	push   %eax
  8003d6:	68 2c 21 80 00       	push   $0x80212c
  8003db:	e8 01 03 00 00       	call   8006e1 <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	68 84 20 80 00       	push   $0x802084
  8003eb:	e8 f1 02 00 00       	call   8006e1 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f3:	e8 34 12 00 00       	call   80162c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003f8:	e8 19 00 00 00       	call   800416 <exit>
}
  8003fd:	90                   	nop
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	6a 00                	push   $0x0
  80040b:	e8 4a 14 00 00       	call   80185a <sys_destroy_env>
  800410:	83 c4 10             	add    $0x10,%esp
}
  800413:	90                   	nop
  800414:	c9                   	leave  
  800415:	c3                   	ret    

00800416 <exit>:

void
exit(void)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80041c:	e8 9f 14 00 00       	call   8018c0 <sys_exit_env>
}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80042a:	8d 45 10             	lea    0x10(%ebp),%eax
  80042d:	83 c0 04             	add    $0x4,%eax
  800430:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800433:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800438:	85 c0                	test   %eax,%eax
  80043a:	74 16                	je     800452 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80043c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	50                   	push   %eax
  800445:	68 40 21 80 00       	push   $0x802140
  80044a:	e8 92 02 00 00       	call   8006e1 <cprintf>
  80044f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800452:	a1 00 30 80 00       	mov    0x803000,%eax
  800457:	ff 75 0c             	pushl  0xc(%ebp)
  80045a:	ff 75 08             	pushl  0x8(%ebp)
  80045d:	50                   	push   %eax
  80045e:	68 45 21 80 00       	push   $0x802145
  800463:	e8 79 02 00 00       	call   8006e1 <cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80046b:	8b 45 10             	mov    0x10(%ebp),%eax
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 f4             	pushl  -0xc(%ebp)
  800474:	50                   	push   %eax
  800475:	e8 fc 01 00 00       	call   800676 <vcprintf>
  80047a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	6a 00                	push   $0x0
  800482:	68 61 21 80 00       	push   $0x802161
  800487:	e8 ea 01 00 00       	call   800676 <vcprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80048f:	e8 82 ff ff ff       	call   800416 <exit>

	// should not return here
	while (1) ;
  800494:	eb fe                	jmp    800494 <_panic+0x70>

00800496 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80049c:	a1 04 30 80 00       	mov    0x803004,%eax
  8004a1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004aa:	39 c2                	cmp    %eax,%edx
  8004ac:	74 14                	je     8004c2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	68 64 21 80 00       	push   $0x802164
  8004b6:	6a 26                	push   $0x26
  8004b8:	68 b0 21 80 00       	push   $0x8021b0
  8004bd:	e8 62 ff ff ff       	call   800424 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d0:	e9 c5 00 00 00       	jmp    80059a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	85 c0                	test   %eax,%eax
  8004e8:	75 08                	jne    8004f2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004ea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ed:	e9 a5 00 00 00       	jmp    800597 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800500:	eb 69                	jmp    80056b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800502:	a1 04 30 80 00       	mov    0x803004,%eax
  800507:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80050d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800510:	89 d0                	mov    %edx,%eax
  800512:	01 c0                	add    %eax,%eax
  800514:	01 d0                	add    %edx,%eax
  800516:	c1 e0 03             	shl    $0x3,%eax
  800519:	01 c8                	add    %ecx,%eax
  80051b:	8a 40 04             	mov    0x4(%eax),%al
  80051e:	84 c0                	test   %al,%al
  800520:	75 46                	jne    800568 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800522:	a1 04 30 80 00       	mov    0x803004,%eax
  800527:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80052d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800540:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800548:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	01 c8                	add    %ecx,%eax
  800559:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	75 09                	jne    800568 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80055f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800566:	eb 15                	jmp    80057d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800568:	ff 45 e8             	incl   -0x18(%ebp)
  80056b:	a1 04 30 80 00       	mov    0x803004,%eax
  800570:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	77 85                	ja     800502 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80057d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800581:	75 14                	jne    800597 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800583:	83 ec 04             	sub    $0x4,%esp
  800586:	68 bc 21 80 00       	push   $0x8021bc
  80058b:	6a 3a                	push   $0x3a
  80058d:	68 b0 21 80 00       	push   $0x8021b0
  800592:	e8 8d fe ff ff       	call   800424 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800597:	ff 45 f0             	incl   -0x10(%ebp)
  80059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a0:	0f 8c 2f ff ff ff    	jl     8004d5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005b4:	eb 26                	jmp    8005dc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8005bb:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8005c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8a 40 04             	mov    0x4(%eax),%al
  8005d2:	3c 01                	cmp    $0x1,%al
  8005d4:	75 03                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005d6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d9:	ff 45 e0             	incl   -0x20(%ebp)
  8005dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8005e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ea:	39 c2                	cmp    %eax,%edx
  8005ec:	77 c8                	ja     8005b6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005f4:	74 14                	je     80060a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005f6:	83 ec 04             	sub    $0x4,%esp
  8005f9:	68 10 22 80 00       	push   $0x802210
  8005fe:	6a 44                	push   $0x44
  800600:	68 b0 21 80 00       	push   $0x8021b0
  800605:	e8 1a fe ff ff       	call   800424 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80060a:	90                   	nop
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    

0080060d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800613:	8b 45 0c             	mov    0xc(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	8d 48 01             	lea    0x1(%eax),%ecx
  80061b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061e:	89 0a                	mov    %ecx,(%edx)
  800620:	8b 55 08             	mov    0x8(%ebp),%edx
  800623:	88 d1                	mov    %dl,%cl
  800625:	8b 55 0c             	mov    0xc(%ebp),%edx
  800628:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80062c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	3d ff 00 00 00       	cmp    $0xff,%eax
  800636:	75 2c                	jne    800664 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800638:	a0 08 30 80 00       	mov    0x803008,%al
  80063d:	0f b6 c0             	movzbl %al,%eax
  800640:	8b 55 0c             	mov    0xc(%ebp),%edx
  800643:	8b 12                	mov    (%edx),%edx
  800645:	89 d1                	mov    %edx,%ecx
  800647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064a:	83 c2 08             	add    $0x8,%edx
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	50                   	push   %eax
  800651:	51                   	push   %ecx
  800652:	52                   	push   %edx
  800653:	e8 78 0f 00 00       	call   8015d0 <sys_cputs>
  800658:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80065b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	8b 40 04             	mov    0x4(%eax),%eax
  80066a:	8d 50 01             	lea    0x1(%eax),%edx
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	89 50 04             	mov    %edx,0x4(%eax)
}
  800673:	90                   	nop
  800674:	c9                   	leave  
  800675:	c3                   	ret    

00800676 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80067f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800686:	00 00 00 
	b.cnt = 0;
  800689:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800690:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	ff 75 08             	pushl  0x8(%ebp)
  800699:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80069f:	50                   	push   %eax
  8006a0:	68 0d 06 80 00       	push   $0x80060d
  8006a5:	e8 11 02 00 00       	call   8008bb <vprintfmt>
  8006aa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006ad:	a0 08 30 80 00       	mov    0x803008,%al
  8006b2:	0f b6 c0             	movzbl %al,%eax
  8006b5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	50                   	push   %eax
  8006bf:	52                   	push   %edx
  8006c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c6:	83 c0 08             	add    $0x8,%eax
  8006c9:	50                   	push   %eax
  8006ca:	e8 01 0f 00 00       	call   8015d0 <sys_cputs>
  8006cf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006d2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8006d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006e7:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	e8 73 ff ff ff       	call   800676 <vcprintf>
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800709:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070c:	c9                   	leave  
  80070d:	c3                   	ret    

0080070e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800714:	e8 f9 0e 00 00       	call   801612 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800719:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 f4             	pushl  -0xc(%ebp)
  800728:	50                   	push   %eax
  800729:	e8 48 ff ff ff       	call   800676 <vcprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800734:	e8 f3 0e 00 00       	call   80162c <sys_unlock_cons>
	return cnt;
  800739:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073c:	c9                   	leave  
  80073d:	c3                   	ret    

0080073e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	53                   	push   %ebx
  800742:	83 ec 14             	sub    $0x14,%esp
  800745:	8b 45 10             	mov    0x10(%ebp),%eax
  800748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800751:	8b 45 18             	mov    0x18(%ebp),%eax
  800754:	ba 00 00 00 00       	mov    $0x0,%edx
  800759:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80075c:	77 55                	ja     8007b3 <printnum+0x75>
  80075e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800761:	72 05                	jb     800768 <printnum+0x2a>
  800763:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800766:	77 4b                	ja     8007b3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800768:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80076b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076e:	8b 45 18             	mov    0x18(%ebp),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
  800776:	52                   	push   %edx
  800777:	50                   	push   %eax
  800778:	ff 75 f4             	pushl  -0xc(%ebp)
  80077b:	ff 75 f0             	pushl  -0x10(%ebp)
  80077e:	e8 4d 14 00 00       	call   801bd0 <__udivdi3>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	83 ec 04             	sub    $0x4,%esp
  800789:	ff 75 20             	pushl  0x20(%ebp)
  80078c:	53                   	push   %ebx
  80078d:	ff 75 18             	pushl  0x18(%ebp)
  800790:	52                   	push   %edx
  800791:	50                   	push   %eax
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	ff 75 08             	pushl  0x8(%ebp)
  800798:	e8 a1 ff ff ff       	call   80073e <printnum>
  80079d:	83 c4 20             	add    $0x20,%esp
  8007a0:	eb 1a                	jmp    8007bc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 20             	pushl  0x20(%ebp)
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b3:	ff 4d 1c             	decl   0x1c(%ebp)
  8007b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007ba:	7f e6                	jg     8007a2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	53                   	push   %ebx
  8007cb:	51                   	push   %ecx
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	e8 0d 15 00 00       	call   801ce0 <__umoddi3>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	05 74 24 80 00       	add    $0x802474,%eax
  8007db:	8a 00                	mov    (%eax),%al
  8007dd:	0f be c0             	movsbl %al,%eax
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	50                   	push   %eax
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	ff d0                	call   *%eax
  8007ec:	83 c4 10             	add    $0x10,%esp
}
  8007ef:	90                   	nop
  8007f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007fc:	7e 1c                	jle    80081a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	8d 50 08             	lea    0x8(%eax),%edx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	89 10                	mov    %edx,(%eax)
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	83 e8 08             	sub    $0x8,%eax
  800813:	8b 50 04             	mov    0x4(%eax),%edx
  800816:	8b 00                	mov    (%eax),%eax
  800818:	eb 40                	jmp    80085a <getuint+0x65>
	else if (lflag)
  80081a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80081e:	74 1e                	je     80083e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	8d 50 04             	lea    0x4(%eax),%edx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	89 10                	mov    %edx,(%eax)
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	83 e8 04             	sub    $0x4,%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	ba 00 00 00 00       	mov    $0x0,%edx
  80083c:	eb 1c                	jmp    80085a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	8d 50 04             	lea    0x4(%eax),%edx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	89 10                	mov    %edx,(%eax)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	83 e8 04             	sub    $0x4,%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80085f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800863:	7e 1c                	jle    800881 <getint+0x25>
		return va_arg(*ap, long long);
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	8d 50 08             	lea    0x8(%eax),%edx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	89 10                	mov    %edx,(%eax)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	83 e8 08             	sub    $0x8,%eax
  80087a:	8b 50 04             	mov    0x4(%eax),%edx
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	eb 38                	jmp    8008b9 <getint+0x5d>
	else if (lflag)
  800881:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800885:	74 1a                	je     8008a1 <getint+0x45>
		return va_arg(*ap, long);
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8d 50 04             	lea    0x4(%eax),%edx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	89 10                	mov    %edx,(%eax)
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	83 e8 04             	sub    $0x4,%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	99                   	cltd   
  80089f:	eb 18                	jmp    8008b9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	8d 50 04             	lea    0x4(%eax),%edx
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	89 10                	mov    %edx,(%eax)
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	83 e8 04             	sub    $0x4,%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	99                   	cltd   
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c3:	eb 17                	jmp    8008dc <vprintfmt+0x21>
			if (ch == '\0')
  8008c5:	85 db                	test   %ebx,%ebx
  8008c7:	0f 84 c1 03 00 00    	je     800c8e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	53                   	push   %ebx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	ff d0                	call   *%eax
  8008d9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	8d 50 01             	lea    0x1(%eax),%edx
  8008e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e5:	8a 00                	mov    (%eax),%al
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	83 fb 25             	cmp    $0x25,%ebx
  8008ed:	75 d6                	jne    8008c5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ef:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008f3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800901:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800908:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	8d 50 01             	lea    0x1(%eax),%edx
  800915:	89 55 10             	mov    %edx,0x10(%ebp)
  800918:	8a 00                	mov    (%eax),%al
  80091a:	0f b6 d8             	movzbl %al,%ebx
  80091d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800920:	83 f8 5b             	cmp    $0x5b,%eax
  800923:	0f 87 3d 03 00 00    	ja     800c66 <vprintfmt+0x3ab>
  800929:	8b 04 85 98 24 80 00 	mov    0x802498(,%eax,4),%eax
  800930:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800932:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800936:	eb d7                	jmp    80090f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800938:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80093c:	eb d1                	jmp    80090f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800948:	89 d0                	mov    %edx,%eax
  80094a:	c1 e0 02             	shl    $0x2,%eax
  80094d:	01 d0                	add    %edx,%eax
  80094f:	01 c0                	add    %eax,%eax
  800951:	01 d8                	add    %ebx,%eax
  800953:	83 e8 30             	sub    $0x30,%eax
  800956:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800959:	8b 45 10             	mov    0x10(%ebp),%eax
  80095c:	8a 00                	mov    (%eax),%al
  80095e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800961:	83 fb 2f             	cmp    $0x2f,%ebx
  800964:	7e 3e                	jle    8009a4 <vprintfmt+0xe9>
  800966:	83 fb 39             	cmp    $0x39,%ebx
  800969:	7f 39                	jg     8009a4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096e:	eb d5                	jmp    800945 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	83 c0 04             	add    $0x4,%eax
  800976:	89 45 14             	mov    %eax,0x14(%ebp)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	83 e8 04             	sub    $0x4,%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800984:	eb 1f                	jmp    8009a5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800986:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098a:	79 83                	jns    80090f <vprintfmt+0x54>
				width = 0;
  80098c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800993:	e9 77 ff ff ff       	jmp    80090f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800998:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80099f:	e9 6b ff ff ff       	jmp    80090f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a9:	0f 89 60 ff ff ff    	jns    80090f <vprintfmt+0x54>
				width = precision, precision = -1;
  8009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009bc:	e9 4e ff ff ff       	jmp    80090f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009c4:	e9 46 ff ff ff       	jmp    80090f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 c0 04             	add    $0x4,%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	83 e8 04             	sub    $0x4,%eax
  8009d8:	8b 00                	mov    (%eax),%eax
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	50                   	push   %eax
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			break;
  8009e9:	e9 9b 02 00 00       	jmp    800c89 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	83 c0 04             	add    $0x4,%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	83 e8 04             	sub    $0x4,%eax
  8009fd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ff:	85 db                	test   %ebx,%ebx
  800a01:	79 02                	jns    800a05 <vprintfmt+0x14a>
				err = -err;
  800a03:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a05:	83 fb 64             	cmp    $0x64,%ebx
  800a08:	7f 0b                	jg     800a15 <vprintfmt+0x15a>
  800a0a:	8b 34 9d e0 22 80 00 	mov    0x8022e0(,%ebx,4),%esi
  800a11:	85 f6                	test   %esi,%esi
  800a13:	75 19                	jne    800a2e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a15:	53                   	push   %ebx
  800a16:	68 85 24 80 00       	push   $0x802485
  800a1b:	ff 75 0c             	pushl  0xc(%ebp)
  800a1e:	ff 75 08             	pushl  0x8(%ebp)
  800a21:	e8 70 02 00 00       	call   800c96 <printfmt>
  800a26:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a29:	e9 5b 02 00 00       	jmp    800c89 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a2e:	56                   	push   %esi
  800a2f:	68 8e 24 80 00       	push   $0x80248e
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 57 02 00 00       	call   800c96 <printfmt>
  800a3f:	83 c4 10             	add    $0x10,%esp
			break;
  800a42:	e9 42 02 00 00       	jmp    800c89 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 c0 04             	add    $0x4,%eax
  800a4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	83 e8 04             	sub    $0x4,%eax
  800a56:	8b 30                	mov    (%eax),%esi
  800a58:	85 f6                	test   %esi,%esi
  800a5a:	75 05                	jne    800a61 <vprintfmt+0x1a6>
				p = "(null)";
  800a5c:	be 91 24 80 00       	mov    $0x802491,%esi
			if (width > 0 && padc != '-')
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a65:	7e 6d                	jle    800ad4 <vprintfmt+0x219>
  800a67:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a6b:	74 67                	je     800ad4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	50                   	push   %eax
  800a74:	56                   	push   %esi
  800a75:	e8 1e 03 00 00       	call   800d98 <strnlen>
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a80:	eb 16                	jmp    800a98 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a82:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a95:	ff 4d e4             	decl   -0x1c(%ebp)
  800a98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9c:	7f e4                	jg     800a82 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9e:	eb 34                	jmp    800ad4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aa0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aa4:	74 1c                	je     800ac2 <vprintfmt+0x207>
  800aa6:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa9:	7e 05                	jle    800ab0 <vprintfmt+0x1f5>
  800aab:	83 fb 7e             	cmp    $0x7e,%ebx
  800aae:	7e 12                	jle    800ac2 <vprintfmt+0x207>
					putch('?', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 3f                	push   $0x3f
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	eb 0f                	jmp    800ad1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad4:	89 f0                	mov    %esi,%eax
  800ad6:	8d 70 01             	lea    0x1(%eax),%esi
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	0f be d8             	movsbl %al,%ebx
  800ade:	85 db                	test   %ebx,%ebx
  800ae0:	74 24                	je     800b06 <vprintfmt+0x24b>
  800ae2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae6:	78 b8                	js     800aa0 <vprintfmt+0x1e5>
  800ae8:	ff 4d e0             	decl   -0x20(%ebp)
  800aeb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aef:	79 af                	jns    800aa0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af1:	eb 13                	jmp    800b06 <vprintfmt+0x24b>
				putch(' ', putdat);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	6a 20                	push   $0x20
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	ff d0                	call   *%eax
  800b00:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b03:	ff 4d e4             	decl   -0x1c(%ebp)
  800b06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0a:	7f e7                	jg     800af3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b0c:	e9 78 01 00 00       	jmp    800c89 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 e8             	pushl  -0x18(%ebp)
  800b17:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1a:	50                   	push   %eax
  800b1b:	e8 3c fd ff ff       	call   80085c <getint>
  800b20:	83 c4 10             	add    $0x10,%esp
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2f:	85 d2                	test   %edx,%edx
  800b31:	79 23                	jns    800b56 <vprintfmt+0x29b>
				putch('-', putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	6a 2d                	push   $0x2d
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b49:	f7 d8                	neg    %eax
  800b4b:	83 d2 00             	adc    $0x0,%edx
  800b4e:	f7 da                	neg    %edx
  800b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5d:	e9 bc 00 00 00       	jmp    800c1e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 84 fc ff ff       	call   8007f5 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b81:	e9 98 00 00 00       	jmp    800c1e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 58                	push   $0x58
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 58                	push   $0x58
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 58                	push   $0x58
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			break;
  800bb6:	e9 ce 00 00 00       	jmp    800c89 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	6a 30                	push   $0x30
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	6a 78                	push   $0x78
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 14             	mov    %eax,0x14(%ebp)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	83 e8 04             	sub    $0x4,%eax
  800bea:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bf6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bfd:	eb 1f                	jmp    800c1e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	ff 75 e8             	pushl  -0x18(%ebp)
  800c05:	8d 45 14             	lea    0x14(%ebp),%eax
  800c08:	50                   	push   %eax
  800c09:	e8 e7 fb ff ff       	call   8007f5 <getuint>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c17:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c25:	83 ec 04             	sub    $0x4,%esp
  800c28:	52                   	push   %edx
  800c29:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c30:	ff 75 f0             	pushl  -0x10(%ebp)
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	ff 75 08             	pushl  0x8(%ebp)
  800c39:	e8 00 fb ff ff       	call   80073e <printnum>
  800c3e:	83 c4 20             	add    $0x20,%esp
			break;
  800c41:	eb 46                	jmp    800c89 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	53                   	push   %ebx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			break;
  800c52:	eb 35                	jmp    800c89 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c54:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c5b:	eb 2c                	jmp    800c89 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c5d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c64:	eb 23                	jmp    800c89 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 25                	push   $0x25
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c76:	ff 4d 10             	decl   0x10(%ebp)
  800c79:	eb 03                	jmp    800c7e <vprintfmt+0x3c3>
  800c7b:	ff 4d 10             	decl   0x10(%ebp)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	48                   	dec    %eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	3c 25                	cmp    $0x25,%al
  800c86:	75 f3                	jne    800c7b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c88:	90                   	nop
		}
	}
  800c89:	e9 35 fc ff ff       	jmp    8008c3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c8e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c9c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cab:	50                   	push   %eax
  800cac:	ff 75 0c             	pushl  0xc(%ebp)
  800caf:	ff 75 08             	pushl  0x8(%ebp)
  800cb2:	e8 04 fc ff ff       	call   8008bb <vprintfmt>
  800cb7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cba:	90                   	nop
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8b 40 08             	mov    0x8(%eax),%eax
  800cc6:	8d 50 01             	lea    0x1(%eax),%edx
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	8b 10                	mov    (%eax),%edx
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8b 40 04             	mov    0x4(%eax),%eax
  800cda:	39 c2                	cmp    %eax,%edx
  800cdc:	73 12                	jae    800cf0 <sprintputch+0x33>
		*b->buf++ = ch;
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	8b 00                	mov    (%eax),%eax
  800ce3:	8d 48 01             	lea    0x1(%eax),%ecx
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	89 0a                	mov    %ecx,(%edx)
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	88 10                	mov    %dl,(%eax)
}
  800cf0:	90                   	nop
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	01 d0                	add    %edx,%eax
  800d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d18:	74 06                	je     800d20 <vsnprintf+0x2d>
  800d1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1e:	7f 07                	jg     800d27 <vsnprintf+0x34>
		return -E_INVAL;
  800d20:	b8 03 00 00 00       	mov    $0x3,%eax
  800d25:	eb 20                	jmp    800d47 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d27:	ff 75 14             	pushl  0x14(%ebp)
  800d2a:	ff 75 10             	pushl  0x10(%ebp)
  800d2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d30:	50                   	push   %eax
  800d31:	68 bd 0c 80 00       	push   $0x800cbd
  800d36:	e8 80 fb ff ff       	call   8008bb <vprintfmt>
  800d3b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d41:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 89 ff ff ff       	call   800cf3 <vsnprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
  800d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d82:	eb 06                	jmp    800d8a <strlen+0x15>
		n++;
  800d84:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 f1                	jne    800d84 <strlen+0xf>
		n++;
	return n;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da5:	eb 09                	jmp    800db0 <strnlen+0x18>
		n++;
  800da7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 4d 0c             	decl   0xc(%ebp)
  800db0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db4:	74 09                	je     800dbf <strnlen+0x27>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e8                	jne    800da7 <strnlen+0xf>
		n++;
	return n;
  800dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dd0:	90                   	nop
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8d 50 01             	lea    0x1(%eax),%edx
  800dd7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de3:	8a 12                	mov    (%edx),%dl
  800de5:	88 10                	mov    %dl,(%eax)
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 e4                	jne    800dd1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e05:	eb 1f                	jmp    800e26 <strncpy+0x34>
		*dst++ = *src;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8d 50 01             	lea    0x1(%eax),%edx
  800e0d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e13:	8a 12                	mov    (%edx),%dl
  800e15:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	74 03                	je     800e23 <strncpy+0x31>
			src++;
  800e20:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2c:	72 d9                	jb     800e07 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e43:	74 30                	je     800e75 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e45:	eb 16                	jmp    800e5d <strlcpy+0x2a>
			*dst++ = *src++;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8d 50 01             	lea    0x1(%eax),%edx
  800e4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e53:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e56:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e59:	8a 12                	mov    (%edx),%dl
  800e5b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e5d:	ff 4d 10             	decl   0x10(%ebp)
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 09                	je     800e6f <strlcpy+0x3c>
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 d8                	jne    800e47 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7b:	29 c2                	sub    %eax,%edx
  800e7d:	89 d0                	mov    %edx,%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e84:	eb 06                	jmp    800e8c <strcmp+0xb>
		p++, q++;
  800e86:	ff 45 08             	incl   0x8(%ebp)
  800e89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	74 0e                	je     800ea3 <strcmp+0x22>
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 10                	mov    (%eax),%dl
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	38 c2                	cmp    %al,%dl
  800ea1:	74 e3                	je     800e86 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	0f b6 d0             	movzbl %al,%edx
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	0f b6 c0             	movzbl %al,%eax
  800eb3:	29 c2                	sub    %eax,%edx
  800eb5:	89 d0                	mov    %edx,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ebc:	eb 09                	jmp    800ec7 <strncmp+0xe>
		n--, p++, q++;
  800ebe:	ff 4d 10             	decl   0x10(%ebp)
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ec7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecb:	74 17                	je     800ee4 <strncmp+0x2b>
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	84 c0                	test   %al,%al
  800ed4:	74 0e                	je     800ee4 <strncmp+0x2b>
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 da                	je     800ebe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee8:	75 07                	jne    800ef1 <strncmp+0x38>
		return 0;
  800eea:	b8 00 00 00 00       	mov    $0x0,%eax
  800eef:	eb 14                	jmp    800f05 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	0f b6 d0             	movzbl %al,%edx
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	29 c2                	sub    %eax,%edx
  800f03:	89 d0                	mov    %edx,%eax
}
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 04             	sub    $0x4,%esp
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f13:	eb 12                	jmp    800f27 <strchr+0x20>
		if (*s == c)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f1d:	75 05                	jne    800f24 <strchr+0x1d>
			return (char *) s;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	eb 11                	jmp    800f35 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	75 e5                	jne    800f15 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f43:	eb 0d                	jmp    800f52 <strfind+0x1b>
		if (*s == c)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f4d:	74 0e                	je     800f5d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	84 c0                	test   %al,%al
  800f59:	75 ea                	jne    800f45 <strfind+0xe>
  800f5b:	eb 01                	jmp    800f5e <strfind+0x27>
		if (*s == c)
			break;
  800f5d:	90                   	nop
	return (char *) s;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f75:	eb 0e                	jmp    800f85 <memset+0x22>
		*p++ = c;
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f85:	ff 4d f8             	decl   -0x8(%ebp)
  800f88:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f8c:	79 e9                	jns    800f77 <memset+0x14>
		*p++ = c;

	return v;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fa5:	eb 16                	jmp    800fbd <memcpy+0x2a>
		*d++ = *s++;
  800fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faa:	8d 50 01             	lea    0x1(%eax),%edx
  800fad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb9:	8a 12                	mov    (%edx),%dl
  800fbb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	75 dd                	jne    800fa7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe7:	73 50                	jae    801039 <memmove+0x6a>
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff4:	76 43                	jbe    801039 <memmove+0x6a>
		s += n;
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fff:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801002:	eb 10                	jmp    801014 <memmove+0x45>
			*--d = *--s;
  801004:	ff 4d f8             	decl   -0x8(%ebp)
  801007:	ff 4d fc             	decl   -0x4(%ebp)
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	8a 10                	mov    (%eax),%dl
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101a:	89 55 10             	mov    %edx,0x10(%ebp)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	75 e3                	jne    801004 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801021:	eb 23                	jmp    801046 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80105d:	eb 2a                	jmp    801089 <memcmp+0x3e>
		if (*s1 != *s2)
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801062:	8a 10                	mov    (%eax),%dl
  801064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	38 c2                	cmp    %al,%dl
  80106b:	74 16                	je     801083 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80106d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f b6 c0             	movzbl %al,%eax
  80107d:	29 c2                	sub    %eax,%edx
  80107f:	89 d0                	mov    %edx,%eax
  801081:	eb 18                	jmp    80109b <memcmp+0x50>
		s1++, s2++;
  801083:	ff 45 fc             	incl   -0x4(%ebp)
  801086:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108f:	89 55 10             	mov    %edx,0x10(%ebp)
  801092:	85 c0                	test   %eax,%eax
  801094:	75 c9                	jne    80105f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	01 d0                	add    %edx,%eax
  8010ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010ae:	eb 15                	jmp    8010c5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	0f b6 d0             	movzbl %al,%edx
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	0f b6 c0             	movzbl %al,%eax
  8010be:	39 c2                	cmp    %eax,%edx
  8010c0:	74 0d                	je     8010cf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c2:	ff 45 08             	incl   0x8(%ebp)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010cb:	72 e3                	jb     8010b0 <memfind+0x13>
  8010cd:	eb 01                	jmp    8010d0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010cf:	90                   	nop
	return (void *) s;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e9:	eb 03                	jmp    8010ee <strtol+0x19>
		s++;
  8010eb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 20                	cmp    $0x20,%al
  8010f5:	74 f4                	je     8010eb <strtol+0x16>
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 09                	cmp    $0x9,%al
  8010fe:	74 eb                	je     8010eb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 2b                	cmp    $0x2b,%al
  801107:	75 05                	jne    80110e <strtol+0x39>
		s++;
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	eb 13                	jmp    801121 <strtol+0x4c>
	else if (*s == '-')
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 2d                	cmp    $0x2d,%al
  801115:	75 0a                	jne    801121 <strtol+0x4c>
		s++, neg = 1;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801121:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801125:	74 06                	je     80112d <strtol+0x58>
  801127:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80112b:	75 20                	jne    80114d <strtol+0x78>
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 30                	cmp    $0x30,%al
  801134:	75 17                	jne    80114d <strtol+0x78>
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	40                   	inc    %eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 78                	cmp    $0x78,%al
  80113e:	75 0d                	jne    80114d <strtol+0x78>
		s += 2, base = 16;
  801140:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801144:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80114b:	eb 28                	jmp    801175 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80114d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801151:	75 15                	jne    801168 <strtol+0x93>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 30                	cmp    $0x30,%al
  80115a:	75 0c                	jne    801168 <strtol+0x93>
		s++, base = 8;
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801166:	eb 0d                	jmp    801175 <strtol+0xa0>
	else if (base == 0)
  801168:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116c:	75 07                	jne    801175 <strtol+0xa0>
		base = 10;
  80116e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 2f                	cmp    $0x2f,%al
  80117c:	7e 19                	jle    801197 <strtol+0xc2>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 39                	cmp    $0x39,%al
  801185:	7f 10                	jg     801197 <strtol+0xc2>
			dig = *s - '0';
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	83 e8 30             	sub    $0x30,%eax
  801192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801195:	eb 42                	jmp    8011d9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 60                	cmp    $0x60,%al
  80119e:	7e 19                	jle    8011b9 <strtol+0xe4>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 7a                	cmp    $0x7a,%al
  8011a7:	7f 10                	jg     8011b9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 57             	sub    $0x57,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b7:	eb 20                	jmp    8011d9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 40                	cmp    $0x40,%al
  8011c0:	7e 39                	jle    8011fb <strtol+0x126>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 5a                	cmp    $0x5a,%al
  8011c9:	7f 30                	jg     8011fb <strtol+0x126>
			dig = *s - 'A' + 10;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	83 e8 37             	sub    $0x37,%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011df:	7d 19                	jge    8011fa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011eb:	89 c2                	mov    %eax,%edx
  8011ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f5:	e9 7b ff ff ff       	jmp    801175 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011fa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ff:	74 08                	je     801209 <strtol+0x134>
		*endptr = (char *) s;
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801209:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120d:	74 07                	je     801216 <strtol+0x141>
  80120f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801212:	f7 d8                	neg    %eax
  801214:	eb 03                	jmp    801219 <strtol+0x144>
  801216:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <ltostr>:

void
ltostr(long value, char *str)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801228:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80122f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801233:	79 13                	jns    801248 <ltostr+0x2d>
	{
		neg = 1;
  801235:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801242:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801245:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801250:	99                   	cltd   
  801251:	f7 f9                	idiv   %ecx
  801253:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80125f:	89 c2                	mov    %eax,%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801269:	83 c2 30             	add    $0x30,%edx
  80126c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80126e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801271:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801276:	f7 e9                	imul   %ecx
  801278:	c1 fa 02             	sar    $0x2,%edx
  80127b:	89 c8                	mov    %ecx,%eax
  80127d:	c1 f8 1f             	sar    $0x1f,%eax
  801280:	29 c2                	sub    %eax,%edx
  801282:	89 d0                	mov    %edx,%eax
  801284:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128b:	75 bb                	jne    801248 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80128d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801297:	48                   	dec    %eax
  801298:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80129b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129f:	74 3d                	je     8012de <ltostr+0xc3>
		start = 1 ;
  8012a1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012a8:	eb 34                	jmp    8012de <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	01 c2                	add    %eax,%edx
  8012bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 c8                	add    %ecx,%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d1:	01 c2                	add    %eax,%edx
  8012d3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012d6:	88 02                	mov    %al,(%edx)
		start++ ;
  8012d8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012db:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e4:	7c c4                	jl     8012aa <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012f1:	90                   	nop
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	e8 73 fa ff ff       	call   800d75 <strlen>
  801302:	83 c4 04             	add    $0x4,%esp
  801305:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	e8 65 fa ff ff       	call   800d75 <strlen>
  801310:	83 c4 04             	add    $0x4,%esp
  801313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80131d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801324:	eb 17                	jmp    80133d <strcconcat+0x49>
		final[s] = str1[s] ;
  801326:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 c2                	add    %eax,%edx
  80132e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	01 c8                	add    %ecx,%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80133a:	ff 45 fc             	incl   -0x4(%ebp)
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801343:	7c e1                	jl     801326 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801345:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80134c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801353:	eb 1f                	jmp    801374 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801358:	8d 50 01             	lea    0x1(%eax),%edx
  80135b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80135e:	89 c2                	mov    %eax,%edx
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	01 c2                	add    %eax,%edx
  801365:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 c8                	add    %ecx,%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801371:	ff 45 f8             	incl   -0x8(%ebp)
  801374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801377:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137a:	7c d9                	jl     801355 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80137c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137f:	8b 45 10             	mov    0x10(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	c6 00 00             	movb   $0x0,(%eax)
}
  801387:	90                   	nop
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80138d:	8b 45 14             	mov    0x14(%ebp),%eax
  801390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801396:	8b 45 14             	mov    0x14(%ebp),%eax
  801399:	8b 00                	mov    (%eax),%eax
  80139b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ad:	eb 0c                	jmp    8013bb <strsplit+0x31>
			*string++ = 0;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8d 50 01             	lea    0x1(%eax),%edx
  8013b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	84 c0                	test   %al,%al
  8013c2:	74 18                	je     8013dc <strsplit+0x52>
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	0f be c0             	movsbl %al,%eax
  8013cc:	50                   	push   %eax
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	e8 32 fb ff ff       	call   800f07 <strchr>
  8013d5:	83 c4 08             	add    $0x8,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	75 d3                	jne    8013af <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 5a                	je     80143f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	8b 00                	mov    (%eax),%eax
  8013ea:	83 f8 0f             	cmp    $0xf,%eax
  8013ed:	75 07                	jne    8013f6 <strsplit+0x6c>
		{
			return 0;
  8013ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f4:	eb 66                	jmp    80145c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8013fe:	8b 55 14             	mov    0x14(%ebp),%edx
  801401:	89 0a                	mov    %ecx,(%edx)
  801403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140a:	8b 45 10             	mov    0x10(%ebp),%eax
  80140d:	01 c2                	add    %eax,%edx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801414:	eb 03                	jmp    801419 <strsplit+0x8f>
			string++;
  801416:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	84 c0                	test   %al,%al
  801420:	74 8b                	je     8013ad <strsplit+0x23>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	0f be c0             	movsbl %al,%eax
  80142a:	50                   	push   %eax
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	e8 d4 fa ff ff       	call   800f07 <strchr>
  801433:	83 c4 08             	add    $0x8,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	74 dc                	je     801416 <strsplit+0x8c>
			string++;
	}
  80143a:	e9 6e ff ff ff       	jmp    8013ad <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80143f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801440:	8b 45 14             	mov    0x14(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80144c:	8b 45 10             	mov    0x10(%ebp),%eax
  80144f:	01 d0                	add    %edx,%eax
  801451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801457:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	68 08 26 80 00       	push   $0x802608
  80146c:	68 3f 01 00 00       	push   $0x13f
  801471:	68 2a 26 80 00       	push   $0x80262a
  801476:	e8 a9 ef ff ff       	call   800424 <_panic>

0080147b <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801481:	83 ec 0c             	sub    $0xc,%esp
  801484:	ff 75 08             	pushl  0x8(%ebp)
  801487:	e8 ef 06 00 00       	call   801b7b <sys_sbrk>
  80148c:	83 c4 10             	add    $0x10,%esp
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149b:	75 07                	jne    8014a4 <malloc+0x13>
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a2:	eb 14                	jmp    8014b8 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	68 38 26 80 00       	push   $0x802638
  8014ac:	6a 1b                	push   $0x1b
  8014ae:	68 5d 26 80 00       	push   $0x80265d
  8014b3:	e8 6c ef ff ff       	call   800424 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 6c 26 80 00       	push   $0x80266c
  8014c8:	6a 29                	push   $0x29
  8014ca:	68 5d 26 80 00       	push   $0x80265d
  8014cf:	e8 50 ef ff ff       	call   800424 <_panic>

008014d4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 18             	sub    $0x18,%esp
  8014da:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dd:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e4:	75 07                	jne    8014ed <smalloc+0x19>
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	eb 14                	jmp    801501 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 90 26 80 00       	push   $0x802690
  8014f5:	6a 38                	push   $0x38
  8014f7:	68 5d 26 80 00       	push   $0x80265d
  8014fc:	e8 23 ef ff ff       	call   800424 <_panic>
	return NULL;
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 b8 26 80 00       	push   $0x8026b8
  801511:	6a 43                	push   $0x43
  801513:	68 5d 26 80 00       	push   $0x80265d
  801518:	e8 07 ef ff ff       	call   800424 <_panic>

0080151d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	68 dc 26 80 00       	push   $0x8026dc
  80152b:	6a 5b                	push   $0x5b
  80152d:	68 5d 26 80 00       	push   $0x80265d
  801532:	e8 ed ee ff ff       	call   800424 <_panic>

00801537 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	68 00 27 80 00       	push   $0x802700
  801545:	6a 72                	push   $0x72
  801547:	68 5d 26 80 00       	push   $0x80265d
  80154c:	e8 d3 ee ff ff       	call   800424 <_panic>

00801551 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 26 27 80 00       	push   $0x802726
  80155f:	6a 7e                	push   $0x7e
  801561:	68 5d 26 80 00       	push   $0x80265d
  801566:	e8 b9 ee ff ff       	call   800424 <_panic>

0080156b <shrink>:

}
void shrink(uint32 newSize)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	68 26 27 80 00       	push   $0x802726
  801579:	68 83 00 00 00       	push   $0x83
  80157e:	68 5d 26 80 00       	push   $0x80265d
  801583:	e8 9c ee ff ff       	call   800424 <_panic>

00801588 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	68 26 27 80 00       	push   $0x802726
  801596:	68 88 00 00 00       	push   $0x88
  80159b:	68 5d 26 80 00       	push   $0x80265d
  8015a0:	e8 7f ee ff ff       	call   800424 <_panic>

008015a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	57                   	push   %edi
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015c0:	cd 30                	int    $0x30
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5f                   	pop    %edi
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	52                   	push   %edx
  8015e8:	ff 75 0c             	pushl  0xc(%ebp)
  8015eb:	50                   	push   %eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 b2 ff ff ff       	call   8015a5 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 02                	push   $0x2
  801608:	e8 98 ff ff ff       	call   8015a5 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 03                	push   $0x3
  801621:	e8 7f ff ff ff       	call   8015a5 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 04                	push   $0x4
  80163b:	e8 65 ff ff ff       	call   8015a5 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	52                   	push   %edx
  801656:	50                   	push   %eax
  801657:	6a 08                	push   $0x8
  801659:	e8 47 ff ff ff       	call   8015a5 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801668:	8b 75 18             	mov    0x18(%ebp),%esi
  80166b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801671:	8b 55 0c             	mov    0xc(%ebp),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	56                   	push   %esi
  801678:	53                   	push   %ebx
  801679:	51                   	push   %ecx
  80167a:	52                   	push   %edx
  80167b:	50                   	push   %eax
  80167c:	6a 09                	push   $0x9
  80167e:	e8 22 ff ff ff       	call   8015a5 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801689:	5b                   	pop    %ebx
  80168a:	5e                   	pop    %esi
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	52                   	push   %edx
  80169d:	50                   	push   %eax
  80169e:	6a 0a                	push   $0xa
  8016a0:	e8 00 ff ff ff       	call   8015a5 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	ff 75 08             	pushl  0x8(%ebp)
  8016b9:	6a 0b                	push   $0xb
  8016bb:	e8 e5 fe ff ff       	call   8015a5 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 0c                	push   $0xc
  8016d4:	e8 cc fe ff ff       	call   8015a5 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0d                	push   $0xd
  8016ed:	e8 b3 fe ff ff       	call   8015a5 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0e                	push   $0xe
  801706:	e8 9a fe ff ff       	call   8015a5 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 0f                	push   $0xf
  80171f:	e8 81 fe ff ff       	call   8015a5 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	ff 75 08             	pushl  0x8(%ebp)
  801737:	6a 10                	push   $0x10
  801739:	e8 67 fe ff ff       	call   8015a5 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 11                	push   $0x11
  801752:	e8 4e fe ff ff       	call   8015a5 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	90                   	nop
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_cputc>:

void
sys_cputc(const char c)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801769:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	50                   	push   %eax
  801776:	6a 01                	push   $0x1
  801778:	e8 28 fe ff ff       	call   8015a5 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 14                	push   $0x14
  801792:	e8 0e fe ff ff       	call   8015a5 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017a9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	51                   	push   %ecx
  8017b6:	52                   	push   %edx
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	50                   	push   %eax
  8017bb:	6a 15                	push   $0x15
  8017bd:	e8 e3 fd ff ff       	call   8015a5 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 16                	push   $0x16
  8017da:	e8 c6 fd ff ff       	call   8015a5 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	51                   	push   %ecx
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 17                	push   $0x17
  8017f9:	e8 a7 fd ff ff       	call   8015a5 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801806:	8b 55 0c             	mov    0xc(%ebp),%edx
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	52                   	push   %edx
  801813:	50                   	push   %eax
  801814:	6a 18                	push   $0x18
  801816:	e8 8a fd ff ff       	call   8015a5 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	ff 75 14             	pushl  0x14(%ebp)
  80182b:	ff 75 10             	pushl  0x10(%ebp)
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	50                   	push   %eax
  801832:	6a 19                	push   $0x19
  801834:	e8 6c fd ff ff       	call   8015a5 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	50                   	push   %eax
  80184d:	6a 1a                	push   $0x1a
  80184f:	e8 51 fd ff ff       	call   8015a5 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	50                   	push   %eax
  801869:	6a 1b                	push   $0x1b
  80186b:	e8 35 fd ff ff       	call   8015a5 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 05                	push   $0x5
  801884:	e8 1c fd ff ff       	call   8015a5 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 06                	push   $0x6
  80189d:	e8 03 fd ff ff       	call   8015a5 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 07                	push   $0x7
  8018b6:	e8 ea fc ff ff       	call   8015a5 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_exit_env>:


void sys_exit_env(void)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 1c                	push   $0x1c
  8018cf:	e8 d1 fc ff ff       	call   8015a5 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e3:	8d 50 04             	lea    0x4(%eax),%edx
  8018e6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	6a 1d                	push   $0x1d
  8018f3:	e8 ad fc ff ff       	call   8015a5 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
	return result;
  8018fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801901:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801904:	89 01                	mov    %eax,(%ecx)
  801906:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	c9                   	leave  
  80190d:	c2 04 00             	ret    $0x4

00801910 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	6a 13                	push   $0x13
  801922:	e8 7e fc ff ff       	call   8015a5 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return ;
  80192a:	90                   	nop
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_rcr2>:
uint32 sys_rcr2()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 1e                	push   $0x1e
  80193c:	e8 64 fc ff ff       	call   8015a5 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801952:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	50                   	push   %eax
  80195f:	6a 1f                	push   $0x1f
  801961:	e8 3f fc ff ff       	call   8015a5 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return ;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <rsttst>:
void rsttst()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 21                	push   $0x21
  80197b:	e8 25 fc ff ff       	call   8015a5 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return ;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	8b 45 14             	mov    0x14(%ebp),%eax
  80198f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801992:	8b 55 18             	mov    0x18(%ebp),%edx
  801995:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 20                	push   $0x20
  8019a6:	e8 fa fb ff ff       	call   8015a5 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <chktst>:
void chktst(uint32 n)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	6a 22                	push   $0x22
  8019c1:	e8 df fb ff ff       	call   8015a5 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c9:	90                   	nop
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <inctst>:

void inctst()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 23                	push   $0x23
  8019db:	e8 c5 fb ff ff       	call   8015a5 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <gettst>:
uint32 gettst()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 24                	push   $0x24
  8019f5:	e8 ab fb ff ff       	call   8015a5 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 25                	push   $0x25
  801a11:	e8 8f fb ff ff       	call   8015a5 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
  801a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a1c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a20:	75 07                	jne    801a29 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	eb 05                	jmp    801a2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 25                	push   $0x25
  801a42:	e8 5e fb ff ff       	call   8015a5 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
  801a4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a4d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a51:	75 07                	jne    801a5a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a53:	b8 01 00 00 00       	mov    $0x1,%eax
  801a58:	eb 05                	jmp    801a5f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 25                	push   $0x25
  801a73:	e8 2d fb ff ff       	call   8015a5 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
  801a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a7e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a82:	75 07                	jne    801a8b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a84:	b8 01 00 00 00       	mov    $0x1,%eax
  801a89:	eb 05                	jmp    801a90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 25                	push   $0x25
  801aa4:	e8 fc fa ff ff       	call   8015a5 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
  801aac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aaf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ab3:	75 07                	jne    801abc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aba:	eb 05                	jmp    801ac1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 26                	push   $0x26
  801ad3:	e8 cd fa ff ff       	call   8015a5 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ae2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	53                   	push   %ebx
  801af1:	51                   	push   %ecx
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 27                	push   $0x27
  801af6:	e8 aa fa ff ff       	call   8015a5 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	6a 28                	push   $0x28
  801b16:	e8 8a fa ff ff       	call   8015a5 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	51                   	push   %ecx
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 29                	push   $0x29
  801b36:	e8 6a fa ff ff       	call   8015a5 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 10             	pushl  0x10(%ebp)
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	6a 12                	push   $0x12
  801b52:	e8 4e fa ff ff       	call   8015a5 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 2a                	push   $0x2a
  801b70:	e8 30 fa ff ff       	call   8015a5 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return;
  801b78:	90                   	nop
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	50                   	push   %eax
  801b8a:	6a 2b                	push   $0x2b
  801b8c:	e8 14 fa ff ff       	call   8015a5 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 2c                	push   $0x2c
  801ba7:	e8 f9 f9 ff ff       	call   8015a5 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	6a 2d                	push   $0x2d
  801bc3:	e8 dd f9 ff ff       	call   8015a5 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    
  801bce:	66 90                	xchg   %ax,%ax

00801bd0 <__udivdi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801be7:	89 ca                	mov    %ecx,%edx
  801be9:	89 f8                	mov    %edi,%eax
  801beb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bef:	85 f6                	test   %esi,%esi
  801bf1:	75 2d                	jne    801c20 <__udivdi3+0x50>
  801bf3:	39 cf                	cmp    %ecx,%edi
  801bf5:	77 65                	ja     801c5c <__udivdi3+0x8c>
  801bf7:	89 fd                	mov    %edi,%ebp
  801bf9:	85 ff                	test   %edi,%edi
  801bfb:	75 0b                	jne    801c08 <__udivdi3+0x38>
  801bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801c02:	31 d2                	xor    %edx,%edx
  801c04:	f7 f7                	div    %edi
  801c06:	89 c5                	mov    %eax,%ebp
  801c08:	31 d2                	xor    %edx,%edx
  801c0a:	89 c8                	mov    %ecx,%eax
  801c0c:	f7 f5                	div    %ebp
  801c0e:	89 c1                	mov    %eax,%ecx
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	f7 f5                	div    %ebp
  801c14:	89 cf                	mov    %ecx,%edi
  801c16:	89 fa                	mov    %edi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	39 ce                	cmp    %ecx,%esi
  801c22:	77 28                	ja     801c4c <__udivdi3+0x7c>
  801c24:	0f bd fe             	bsr    %esi,%edi
  801c27:	83 f7 1f             	xor    $0x1f,%edi
  801c2a:	75 40                	jne    801c6c <__udivdi3+0x9c>
  801c2c:	39 ce                	cmp    %ecx,%esi
  801c2e:	72 0a                	jb     801c3a <__udivdi3+0x6a>
  801c30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c34:	0f 87 9e 00 00 00    	ja     801cd8 <__udivdi3+0x108>
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	89 fa                	mov    %edi,%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d 76 00             	lea    0x0(%esi),%esi
  801c4c:	31 ff                	xor    %edi,%edi
  801c4e:	31 c0                	xor    %eax,%eax
  801c50:	89 fa                	mov    %edi,%edx
  801c52:	83 c4 1c             	add    $0x1c,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	89 d8                	mov    %ebx,%eax
  801c5e:	f7 f7                	div    %edi
  801c60:	31 ff                	xor    %edi,%edi
  801c62:	89 fa                	mov    %edi,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c71:	89 eb                	mov    %ebp,%ebx
  801c73:	29 fb                	sub    %edi,%ebx
  801c75:	89 f9                	mov    %edi,%ecx
  801c77:	d3 e6                	shl    %cl,%esi
  801c79:	89 c5                	mov    %eax,%ebp
  801c7b:	88 d9                	mov    %bl,%cl
  801c7d:	d3 ed                	shr    %cl,%ebp
  801c7f:	89 e9                	mov    %ebp,%ecx
  801c81:	09 f1                	or     %esi,%ecx
  801c83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c87:	89 f9                	mov    %edi,%ecx
  801c89:	d3 e0                	shl    %cl,%eax
  801c8b:	89 c5                	mov    %eax,%ebp
  801c8d:	89 d6                	mov    %edx,%esi
  801c8f:	88 d9                	mov    %bl,%cl
  801c91:	d3 ee                	shr    %cl,%esi
  801c93:	89 f9                	mov    %edi,%ecx
  801c95:	d3 e2                	shl    %cl,%edx
  801c97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9b:	88 d9                	mov    %bl,%cl
  801c9d:	d3 e8                	shr    %cl,%eax
  801c9f:	09 c2                	or     %eax,%edx
  801ca1:	89 d0                	mov    %edx,%eax
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	f7 74 24 0c          	divl   0xc(%esp)
  801ca9:	89 d6                	mov    %edx,%esi
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	f7 e5                	mul    %ebp
  801caf:	39 d6                	cmp    %edx,%esi
  801cb1:	72 19                	jb     801ccc <__udivdi3+0xfc>
  801cb3:	74 0b                	je     801cc0 <__udivdi3+0xf0>
  801cb5:	89 d8                	mov    %ebx,%eax
  801cb7:	31 ff                	xor    %edi,%edi
  801cb9:	e9 58 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cc4:	89 f9                	mov    %edi,%ecx
  801cc6:	d3 e2                	shl    %cl,%edx
  801cc8:	39 c2                	cmp    %eax,%edx
  801cca:	73 e9                	jae    801cb5 <__udivdi3+0xe5>
  801ccc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ccf:	31 ff                	xor    %edi,%edi
  801cd1:	e9 40 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cd6:	66 90                	xchg   %ax,%ax
  801cd8:	31 c0                	xor    %eax,%eax
  801cda:	e9 37 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cdf:	90                   	nop

00801ce0 <__umoddi3>:
  801ce0:	55                   	push   %ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ceb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cff:	89 f3                	mov    %esi,%ebx
  801d01:	89 fa                	mov    %edi,%edx
  801d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d07:	89 34 24             	mov    %esi,(%esp)
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	75 1a                	jne    801d28 <__umoddi3+0x48>
  801d0e:	39 f7                	cmp    %esi,%edi
  801d10:	0f 86 a2 00 00 00    	jbe    801db8 <__umoddi3+0xd8>
  801d16:	89 c8                	mov    %ecx,%eax
  801d18:	89 f2                	mov    %esi,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	31 d2                	xor    %edx,%edx
  801d20:	83 c4 1c             	add    $0x1c,%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    
  801d28:	39 f0                	cmp    %esi,%eax
  801d2a:	0f 87 ac 00 00 00    	ja     801ddc <__umoddi3+0xfc>
  801d30:	0f bd e8             	bsr    %eax,%ebp
  801d33:	83 f5 1f             	xor    $0x1f,%ebp
  801d36:	0f 84 ac 00 00 00    	je     801de8 <__umoddi3+0x108>
  801d3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d41:	29 ef                	sub    %ebp,%edi
  801d43:	89 fe                	mov    %edi,%esi
  801d45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 e0                	shl    %cl,%eax
  801d4d:	89 d7                	mov    %edx,%edi
  801d4f:	89 f1                	mov    %esi,%ecx
  801d51:	d3 ef                	shr    %cl,%edi
  801d53:	09 c7                	or     %eax,%edi
  801d55:	89 e9                	mov    %ebp,%ecx
  801d57:	d3 e2                	shl    %cl,%edx
  801d59:	89 14 24             	mov    %edx,(%esp)
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	d3 e0                	shl    %cl,%eax
  801d60:	89 c2                	mov    %eax,%edx
  801d62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d66:	d3 e0                	shl    %cl,%eax
  801d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d70:	89 f1                	mov    %esi,%ecx
  801d72:	d3 e8                	shr    %cl,%eax
  801d74:	09 d0                	or     %edx,%eax
  801d76:	d3 eb                	shr    %cl,%ebx
  801d78:	89 da                	mov    %ebx,%edx
  801d7a:	f7 f7                	div    %edi
  801d7c:	89 d3                	mov    %edx,%ebx
  801d7e:	f7 24 24             	mull   (%esp)
  801d81:	89 c6                	mov    %eax,%esi
  801d83:	89 d1                	mov    %edx,%ecx
  801d85:	39 d3                	cmp    %edx,%ebx
  801d87:	0f 82 87 00 00 00    	jb     801e14 <__umoddi3+0x134>
  801d8d:	0f 84 91 00 00 00    	je     801e24 <__umoddi3+0x144>
  801d93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d97:	29 f2                	sub    %esi,%edx
  801d99:	19 cb                	sbb    %ecx,%ebx
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801da1:	d3 e0                	shl    %cl,%eax
  801da3:	89 e9                	mov    %ebp,%ecx
  801da5:	d3 ea                	shr    %cl,%edx
  801da7:	09 d0                	or     %edx,%eax
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 eb                	shr    %cl,%ebx
  801dad:	89 da                	mov    %ebx,%edx
  801daf:	83 c4 1c             	add    $0x1c,%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5f                   	pop    %edi
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    
  801db7:	90                   	nop
  801db8:	89 fd                	mov    %edi,%ebp
  801dba:	85 ff                	test   %edi,%edi
  801dbc:	75 0b                	jne    801dc9 <__umoddi3+0xe9>
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	31 d2                	xor    %edx,%edx
  801dc5:	f7 f7                	div    %edi
  801dc7:	89 c5                	mov    %eax,%ebp
  801dc9:	89 f0                	mov    %esi,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	f7 f5                	div    %ebp
  801dcf:	89 c8                	mov    %ecx,%eax
  801dd1:	f7 f5                	div    %ebp
  801dd3:	89 d0                	mov    %edx,%eax
  801dd5:	e9 44 ff ff ff       	jmp    801d1e <__umoddi3+0x3e>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	89 c8                	mov    %ecx,%eax
  801dde:	89 f2                	mov    %esi,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	3b 04 24             	cmp    (%esp),%eax
  801deb:	72 06                	jb     801df3 <__umoddi3+0x113>
  801ded:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801df1:	77 0f                	ja     801e02 <__umoddi3+0x122>
  801df3:	89 f2                	mov    %esi,%edx
  801df5:	29 f9                	sub    %edi,%ecx
  801df7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dfb:	89 14 24             	mov    %edx,(%esp)
  801dfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e02:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e06:	8b 14 24             	mov    (%esp),%edx
  801e09:	83 c4 1c             	add    $0x1c,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
  801e11:	8d 76 00             	lea    0x0(%esi),%esi
  801e14:	2b 04 24             	sub    (%esp),%eax
  801e17:	19 fa                	sbb    %edi,%edx
  801e19:	89 d1                	mov    %edx,%ecx
  801e1b:	89 c6                	mov    %eax,%esi
  801e1d:	e9 71 ff ff ff       	jmp    801d93 <__umoddi3+0xb3>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e28:	72 ea                	jb     801e14 <__umoddi3+0x134>
  801e2a:	89 d9                	mov    %ebx,%ecx
  801e2c:	e9 62 ff ff ff       	jmp    801d93 <__umoddi3+0xb3>
