
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 ad 02 00 00       	call   8002e3 <libmain>
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
  800065:	6a 12                	push   $0x12
  800067:	68 5c 1e 80 00       	push   $0x801e5c
  80006c:	e8 a9 03 00 00       	call   80041a <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
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
  8000bc:	e8 fa 15 00 00       	call   8016bb <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 3d 16 00 00       	call   801706 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 aa 13 00 00       	call   801487 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 78 1e 80 00       	push   $0x801e78
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 5c 1e 80 00       	push   $0x801e5c
  800100:	e8 15 03 00 00       	call   80041a <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 fc 15 00 00       	call   801706 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 1e 80 00       	push   $0x801ea8
  800117:	6a 32                	push   $0x32
  800119:	68 5c 1e 80 00       	push   $0x801e5c
  80011e:	e8 f7 02 00 00       	call   80041a <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 93 15 00 00       	call   8016bb <sys_calculate_free_frames>
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
  80015f:	e8 57 15 00 00       	call   8016bb <sys_calculate_free_frames>
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
  800181:	6a 3c                	push   $0x3c
  800183:	68 5c 1e 80 00       	push   $0x801e5c
  800188:	e8 8d 02 00 00       	call   80041a <_panic>

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
  8001c7:	e8 4a 19 00 00       	call   801b16 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 1f 80 00       	push   $0x801f54
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 5c 1e 80 00       	push   $0x801e5c
  8001e7:	e8 2e 02 00 00       	call   80041a <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 ca 14 00 00       	call   8016bb <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 0d 15 00 00       	call   801706 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a5 12 00 00       	call   8014b0 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 f3 14 00 00       	call   801706 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 1f 80 00       	push   $0x801f74
  800220:	6a 4d                	push   $0x4d
  800222:	68 5c 1e 80 00       	push   $0x801e5c
  800227:	e8 ee 01 00 00       	call   80041a <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 8a 14 00 00       	call   8016bb <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 1f 80 00       	push   $0x801fb0
  800247:	6a 4e                	push   $0x4e
  800249:	68 5c 1e 80 00       	push   $0x801e5c
  80024e:	e8 c7 01 00 00       	call   80041a <_panic>
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
  80028d:	e8 84 18 00 00       	call   801b16 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 1f 80 00       	push   $0x801ffc
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 5c 1e 80 00       	push   $0x801e5c
  8002ad:	e8 68 01 00 00       	call   80041a <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 0b 17 00 00       	call   8019c2 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 1f 17 00 00       	call   8019dc <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 f3 16 00 00       	call   8019c2 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 20 20 80 00       	push   $0x802020
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 5c 1e 80 00       	push   $0x801e5c
  8002de:	e8 37 01 00 00       	call   80041a <_panic>

008002e3 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002e9:	e8 96 15 00 00       	call   801884 <sys_getenvindex>
  8002ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	c1 e0 02             	shl    $0x2,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	01 c0                	add    %eax,%eax
  8002fd:	01 d0                	add    %edx,%eax
  8002ff:	c1 e0 02             	shl    $0x2,%eax
  800302:	01 d0                	add    %edx,%eax
  800304:	01 c0                	add    %eax,%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c1 e0 04             	shl    $0x4,%eax
  80030b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800310:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800315:	a1 04 30 80 00       	mov    0x803004,%eax
  80031a:	8a 40 20             	mov    0x20(%eax),%al
  80031d:	84 c0                	test   %al,%al
  80031f:	74 0d                	je     80032e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800321:	a1 04 30 80 00       	mov    0x803004,%eax
  800326:	83 c0 20             	add    $0x20,%eax
  800329:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800332:	7e 0a                	jle    80033e <libmain+0x5b>
		binaryname = argv[0];
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 ec fc ff ff       	call   800038 <_main>
  80034c:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80034f:	e8 b4 12 00 00       	call   801608 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	68 84 20 80 00       	push   $0x802084
  80035c:	e8 76 03 00 00       	call   8006d7 <cprintf>
  800361:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800364:	a1 04 30 80 00       	mov    0x803004,%eax
  800369:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80036f:	a1 04 30 80 00       	mov    0x803004,%eax
  800374:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	52                   	push   %edx
  80037e:	50                   	push   %eax
  80037f:	68 ac 20 80 00       	push   $0x8020ac
  800384:	e8 4e 03 00 00       	call   8006d7 <cprintf>
  800389:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80038c:	a1 04 30 80 00       	mov    0x803004,%eax
  800391:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800397:	a1 04 30 80 00       	mov    0x803004,%eax
  80039c:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8003a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8003a7:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8003ad:	51                   	push   %ecx
  8003ae:	52                   	push   %edx
  8003af:	50                   	push   %eax
  8003b0:	68 d4 20 80 00       	push   $0x8020d4
  8003b5:	e8 1d 03 00 00       	call   8006d7 <cprintf>
  8003ba:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8003c2:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	50                   	push   %eax
  8003cc:	68 2c 21 80 00       	push   $0x80212c
  8003d1:	e8 01 03 00 00       	call   8006d7 <cprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	68 84 20 80 00       	push   $0x802084
  8003e1:	e8 f1 02 00 00       	call   8006d7 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003e9:	e8 34 12 00 00       	call   801622 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003ee:	e8 19 00 00 00       	call   80040c <exit>
}
  8003f3:	90                   	nop
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    

008003f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	6a 00                	push   $0x0
  800401:	e8 4a 14 00 00       	call   801850 <sys_destroy_env>
  800406:	83 c4 10             	add    $0x10,%esp
}
  800409:	90                   	nop
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <exit>:

void
exit(void)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800412:	e8 9f 14 00 00       	call   8018b6 <sys_exit_env>
}
  800417:	90                   	nop
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800420:	8d 45 10             	lea    0x10(%ebp),%eax
  800423:	83 c0 04             	add    $0x4,%eax
  800426:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800429:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80042e:	85 c0                	test   %eax,%eax
  800430:	74 16                	je     800448 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800432:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800437:	83 ec 08             	sub    $0x8,%esp
  80043a:	50                   	push   %eax
  80043b:	68 40 21 80 00       	push   $0x802140
  800440:	e8 92 02 00 00       	call   8006d7 <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800448:	a1 00 30 80 00       	mov    0x803000,%eax
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	ff 75 08             	pushl  0x8(%ebp)
  800453:	50                   	push   %eax
  800454:	68 45 21 80 00       	push   $0x802145
  800459:	e8 79 02 00 00       	call   8006d7 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	ff 75 f4             	pushl  -0xc(%ebp)
  80046a:	50                   	push   %eax
  80046b:	e8 fc 01 00 00       	call   80066c <vcprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	6a 00                	push   $0x0
  800478:	68 61 21 80 00       	push   $0x802161
  80047d:	e8 ea 01 00 00       	call   80066c <vcprintf>
  800482:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800485:	e8 82 ff ff ff       	call   80040c <exit>

	// should not return here
	while (1) ;
  80048a:	eb fe                	jmp    80048a <_panic+0x70>

0080048c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800492:	a1 04 30 80 00       	mov    0x803004,%eax
  800497:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80049d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a0:	39 c2                	cmp    %eax,%edx
  8004a2:	74 14                	je     8004b8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004a4:	83 ec 04             	sub    $0x4,%esp
  8004a7:	68 64 21 80 00       	push   $0x802164
  8004ac:	6a 26                	push   $0x26
  8004ae:	68 b0 21 80 00       	push   $0x8021b0
  8004b3:	e8 62 ff ff ff       	call   80041a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c6:	e9 c5 00 00 00       	jmp    800590 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	85 c0                	test   %eax,%eax
  8004de:	75 08                	jne    8004e8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004e0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004e3:	e9 a5 00 00 00       	jmp    80058d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004f6:	eb 69                	jmp    800561 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004fd:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800503:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800506:	89 d0                	mov    %edx,%eax
  800508:	01 c0                	add    %eax,%eax
  80050a:	01 d0                	add    %edx,%eax
  80050c:	c1 e0 03             	shl    $0x3,%eax
  80050f:	01 c8                	add    %ecx,%eax
  800511:	8a 40 04             	mov    0x4(%eax),%al
  800514:	84 c0                	test   %al,%al
  800516:	75 46                	jne    80055e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800518:	a1 04 30 80 00       	mov    0x803004,%eax
  80051d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800523:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	01 c0                	add    %eax,%eax
  80052a:	01 d0                	add    %edx,%eax
  80052c:	c1 e0 03             	shl    $0x3,%eax
  80052f:	01 c8                	add    %ecx,%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800536:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800539:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800543:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	01 c8                	add    %ecx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800551:	39 c2                	cmp    %eax,%edx
  800553:	75 09                	jne    80055e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800555:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80055c:	eb 15                	jmp    800573 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055e:	ff 45 e8             	incl   -0x18(%ebp)
  800561:	a1 04 30 80 00       	mov    0x803004,%eax
  800566:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80056c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80056f:	39 c2                	cmp    %eax,%edx
  800571:	77 85                	ja     8004f8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800577:	75 14                	jne    80058d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 bc 21 80 00       	push   $0x8021bc
  800581:	6a 3a                	push   $0x3a
  800583:	68 b0 21 80 00       	push   $0x8021b0
  800588:	e8 8d fe ff ff       	call   80041a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80058d:	ff 45 f0             	incl   -0x10(%ebp)
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800596:	0f 8c 2f ff ff ff    	jl     8004cb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80059c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005aa:	eb 26                	jmp    8005d2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8005b1:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8005b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ba:	89 d0                	mov    %edx,%eax
  8005bc:	01 c0                	add    %eax,%eax
  8005be:	01 d0                	add    %edx,%eax
  8005c0:	c1 e0 03             	shl    $0x3,%eax
  8005c3:	01 c8                	add    %ecx,%eax
  8005c5:	8a 40 04             	mov    0x4(%eax),%al
  8005c8:	3c 01                	cmp    $0x1,%al
  8005ca:	75 03                	jne    8005cf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005cc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cf:	ff 45 e0             	incl   -0x20(%ebp)
  8005d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8005d7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e0:	39 c2                	cmp    %eax,%edx
  8005e2:	77 c8                	ja     8005ac <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005ea:	74 14                	je     800600 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 10 22 80 00       	push   $0x802210
  8005f4:	6a 44                	push   $0x44
  8005f6:	68 b0 21 80 00       	push   $0x8021b0
  8005fb:	e8 1a fe ff ff       	call   80041a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800600:	90                   	nop
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	8d 48 01             	lea    0x1(%eax),%ecx
  800611:	8b 55 0c             	mov    0xc(%ebp),%edx
  800614:	89 0a                	mov    %ecx,(%edx)
  800616:	8b 55 08             	mov    0x8(%ebp),%edx
  800619:	88 d1                	mov    %dl,%cl
  80061b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	3d ff 00 00 00       	cmp    $0xff,%eax
  80062c:	75 2c                	jne    80065a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80062e:	a0 08 30 80 00       	mov    0x803008,%al
  800633:	0f b6 c0             	movzbl %al,%eax
  800636:	8b 55 0c             	mov    0xc(%ebp),%edx
  800639:	8b 12                	mov    (%edx),%edx
  80063b:	89 d1                	mov    %edx,%ecx
  80063d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800640:	83 c2 08             	add    $0x8,%edx
  800643:	83 ec 04             	sub    $0x4,%esp
  800646:	50                   	push   %eax
  800647:	51                   	push   %ecx
  800648:	52                   	push   %edx
  800649:	e8 78 0f 00 00       	call   8015c6 <sys_cputs>
  80064e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800651:	8b 45 0c             	mov    0xc(%ebp),%eax
  800654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80065a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065d:	8b 40 04             	mov    0x4(%eax),%eax
  800660:	8d 50 01             	lea    0x1(%eax),%edx
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
  800666:	89 50 04             	mov    %edx,0x4(%eax)
}
  800669:	90                   	nop
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800675:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80067c:	00 00 00 
	b.cnt = 0;
  80067f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800686:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800689:	ff 75 0c             	pushl  0xc(%ebp)
  80068c:	ff 75 08             	pushl  0x8(%ebp)
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	68 03 06 80 00       	push   $0x800603
  80069b:	e8 11 02 00 00       	call   8008b1 <vprintfmt>
  8006a0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006a3:	a0 08 30 80 00       	mov    0x803008,%al
  8006a8:	0f b6 c0             	movzbl %al,%eax
  8006ab:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006b1:	83 ec 04             	sub    $0x4,%esp
  8006b4:	50                   	push   %eax
  8006b5:	52                   	push   %edx
  8006b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006bc:	83 c0 08             	add    $0x8,%eax
  8006bf:	50                   	push   %eax
  8006c0:	e8 01 0f 00 00       	call   8015c6 <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006c8:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8006cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006dd:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	e8 73 ff ff ff       	call   80066c <vcprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80070a:	e8 f9 0e 00 00       	call   801608 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80070f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800712:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 f4             	pushl  -0xc(%ebp)
  80071e:	50                   	push   %eax
  80071f:	e8 48 ff ff ff       	call   80066c <vcprintf>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80072a:	e8 f3 0e 00 00       	call   801622 <sys_unlock_cons>
	return cnt;
  80072f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800732:	c9                   	leave  
  800733:	c3                   	ret    

00800734 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	53                   	push   %ebx
  800738:	83 ec 14             	sub    $0x14,%esp
  80073b:	8b 45 10             	mov    0x10(%ebp),%eax
  80073e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800747:	8b 45 18             	mov    0x18(%ebp),%eax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800752:	77 55                	ja     8007a9 <printnum+0x75>
  800754:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800757:	72 05                	jb     80075e <printnum+0x2a>
  800759:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80075c:	77 4b                	ja     8007a9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800761:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800764:	8b 45 18             	mov    0x18(%ebp),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
  80076c:	52                   	push   %edx
  80076d:	50                   	push   %eax
  80076e:	ff 75 f4             	pushl  -0xc(%ebp)
  800771:	ff 75 f0             	pushl  -0x10(%ebp)
  800774:	e8 4b 14 00 00       	call   801bc4 <__udivdi3>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	ff 75 20             	pushl  0x20(%ebp)
  800782:	53                   	push   %ebx
  800783:	ff 75 18             	pushl  0x18(%ebp)
  800786:	52                   	push   %edx
  800787:	50                   	push   %eax
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	ff 75 08             	pushl  0x8(%ebp)
  80078e:	e8 a1 ff ff ff       	call   800734 <printnum>
  800793:	83 c4 20             	add    $0x20,%esp
  800796:	eb 1a                	jmp    8007b2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	ff 75 20             	pushl  0x20(%ebp)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a9:	ff 4d 1c             	decl   0x1c(%ebp)
  8007ac:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007b0:	7f e6                	jg     800798 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c0:	53                   	push   %ebx
  8007c1:	51                   	push   %ecx
  8007c2:	52                   	push   %edx
  8007c3:	50                   	push   %eax
  8007c4:	e8 0b 15 00 00       	call   801cd4 <__umoddi3>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	05 74 24 80 00       	add    $0x802474,%eax
  8007d1:	8a 00                	mov    (%eax),%al
  8007d3:	0f be c0             	movsbl %al,%eax
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	ff d0                	call   *%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	90                   	nop
  8007e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    

008007eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007f2:	7e 1c                	jle    800810 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	8d 50 08             	lea    0x8(%eax),%edx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	89 10                	mov    %edx,(%eax)
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	83 e8 08             	sub    $0x8,%eax
  800809:	8b 50 04             	mov    0x4(%eax),%edx
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	eb 40                	jmp    800850 <getuint+0x65>
	else if (lflag)
  800810:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800814:	74 1e                	je     800834 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	8d 50 04             	lea    0x4(%eax),%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	89 10                	mov    %edx,(%eax)
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	eb 1c                	jmp    800850 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 04             	lea    0x4(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 04             	sub    $0x4,%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800855:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800859:	7e 1c                	jle    800877 <getint+0x25>
		return va_arg(*ap, long long);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	8d 50 08             	lea    0x8(%eax),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	89 10                	mov    %edx,(%eax)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	83 e8 08             	sub    $0x8,%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	eb 38                	jmp    8008af <getint+0x5d>
	else if (lflag)
  800877:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087b:	74 1a                	je     800897 <getint+0x45>
		return va_arg(*ap, long);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 04             	sub    $0x4,%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	99                   	cltd   
  800895:	eb 18                	jmp    8008af <getint+0x5d>
	else
		return va_arg(*ap, int);
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	8d 50 04             	lea    0x4(%eax),%edx
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	89 10                	mov    %edx,(%eax)
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	83 e8 04             	sub    $0x4,%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	99                   	cltd   
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	56                   	push   %esi
  8008b5:	53                   	push   %ebx
  8008b6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b9:	eb 17                	jmp    8008d2 <vprintfmt+0x21>
			if (ch == '\0')
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	0f 84 c1 03 00 00    	je     800c84 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	53                   	push   %ebx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d5:	8d 50 01             	lea    0x1(%eax),%edx
  8008d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008db:	8a 00                	mov    (%eax),%al
  8008dd:	0f b6 d8             	movzbl %al,%ebx
  8008e0:	83 fb 25             	cmp    $0x25,%ebx
  8008e3:	75 d6                	jne    8008bb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800905:	8b 45 10             	mov    0x10(%ebp),%eax
  800908:	8d 50 01             	lea    0x1(%eax),%edx
  80090b:	89 55 10             	mov    %edx,0x10(%ebp)
  80090e:	8a 00                	mov    (%eax),%al
  800910:	0f b6 d8             	movzbl %al,%ebx
  800913:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800916:	83 f8 5b             	cmp    $0x5b,%eax
  800919:	0f 87 3d 03 00 00    	ja     800c5c <vprintfmt+0x3ab>
  80091f:	8b 04 85 98 24 80 00 	mov    0x802498(,%eax,4),%eax
  800926:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800928:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80092c:	eb d7                	jmp    800905 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80092e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800932:	eb d1                	jmp    800905 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800934:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80093b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	c1 e0 02             	shl    $0x2,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	01 c0                	add    %eax,%eax
  800947:	01 d8                	add    %ebx,%eax
  800949:	83 e8 30             	sub    $0x30,%eax
  80094c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80094f:	8b 45 10             	mov    0x10(%ebp),%eax
  800952:	8a 00                	mov    (%eax),%al
  800954:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800957:	83 fb 2f             	cmp    $0x2f,%ebx
  80095a:	7e 3e                	jle    80099a <vprintfmt+0xe9>
  80095c:	83 fb 39             	cmp    $0x39,%ebx
  80095f:	7f 39                	jg     80099a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800961:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800964:	eb d5                	jmp    80093b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80097a:	eb 1f                	jmp    80099b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80097c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800980:	79 83                	jns    800905 <vprintfmt+0x54>
				width = 0;
  800982:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800989:	e9 77 ff ff ff       	jmp    800905 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80098e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800995:	e9 6b ff ff ff       	jmp    800905 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80099a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80099b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099f:	0f 89 60 ff ff ff    	jns    800905 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009b2:	e9 4e ff ff ff       	jmp    800905 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ba:	e9 46 ff ff ff       	jmp    800905 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 e8 04             	sub    $0x4,%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	50                   	push   %eax
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			break;
  8009df:	e9 9b 02 00 00       	jmp    800c7f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	83 c0 04             	add    $0x4,%eax
  8009ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	83 e8 04             	sub    $0x4,%eax
  8009f3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009f5:	85 db                	test   %ebx,%ebx
  8009f7:	79 02                	jns    8009fb <vprintfmt+0x14a>
				err = -err;
  8009f9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009fb:	83 fb 64             	cmp    $0x64,%ebx
  8009fe:	7f 0b                	jg     800a0b <vprintfmt+0x15a>
  800a00:	8b 34 9d e0 22 80 00 	mov    0x8022e0(,%ebx,4),%esi
  800a07:	85 f6                	test   %esi,%esi
  800a09:	75 19                	jne    800a24 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a0b:	53                   	push   %ebx
  800a0c:	68 85 24 80 00       	push   $0x802485
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	e8 70 02 00 00       	call   800c8c <printfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a1f:	e9 5b 02 00 00       	jmp    800c7f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a24:	56                   	push   %esi
  800a25:	68 8e 24 80 00       	push   $0x80248e
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 57 02 00 00       	call   800c8c <printfmt>
  800a35:	83 c4 10             	add    $0x10,%esp
			break;
  800a38:	e9 42 02 00 00       	jmp    800c7f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 c0 04             	add    $0x4,%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	83 e8 04             	sub    $0x4,%eax
  800a4c:	8b 30                	mov    (%eax),%esi
  800a4e:	85 f6                	test   %esi,%esi
  800a50:	75 05                	jne    800a57 <vprintfmt+0x1a6>
				p = "(null)";
  800a52:	be 91 24 80 00       	mov    $0x802491,%esi
			if (width > 0 && padc != '-')
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7e 6d                	jle    800aca <vprintfmt+0x219>
  800a5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a61:	74 67                	je     800aca <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	50                   	push   %eax
  800a6a:	56                   	push   %esi
  800a6b:	e8 1e 03 00 00       	call   800d8e <strnlen>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a76:	eb 16                	jmp    800a8e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a78:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	50                   	push   %eax
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	ff d0                	call   *%eax
  800a88:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a92:	7f e4                	jg     800a78 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a94:	eb 34                	jmp    800aca <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a9a:	74 1c                	je     800ab8 <vprintfmt+0x207>
  800a9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a9f:	7e 05                	jle    800aa6 <vprintfmt+0x1f5>
  800aa1:	83 fb 7e             	cmp    $0x7e,%ebx
  800aa4:	7e 12                	jle    800ab8 <vprintfmt+0x207>
					putch('?', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 3f                	push   $0x3f
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	eb 0f                	jmp    800ac7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	53                   	push   %ebx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aca:	89 f0                	mov    %esi,%eax
  800acc:	8d 70 01             	lea    0x1(%eax),%esi
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	0f be d8             	movsbl %al,%ebx
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	74 24                	je     800afc <vprintfmt+0x24b>
  800ad8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800adc:	78 b8                	js     800a96 <vprintfmt+0x1e5>
  800ade:	ff 4d e0             	decl   -0x20(%ebp)
  800ae1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae5:	79 af                	jns    800a96 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae7:	eb 13                	jmp    800afc <vprintfmt+0x24b>
				putch(' ', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 20                	push   $0x20
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af9:	ff 4d e4             	decl   -0x1c(%ebp)
  800afc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b00:	7f e7                	jg     800ae9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b02:	e9 78 01 00 00       	jmp    800c7f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 3c fd ff ff       	call   800852 <getint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b25:	85 d2                	test   %edx,%edx
  800b27:	79 23                	jns    800b4c <vprintfmt+0x29b>
				putch('-', putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	6a 2d                	push   $0x2d
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3f:	f7 d8                	neg    %eax
  800b41:	83 d2 00             	adc    $0x0,%edx
  800b44:	f7 da                	neg    %edx
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b53:	e9 bc 00 00 00       	jmp    800c14 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b61:	50                   	push   %eax
  800b62:	e8 84 fc ff ff       	call   8007eb <getuint>
  800b67:	83 c4 10             	add    $0x10,%esp
  800b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b77:	e9 98 00 00 00       	jmp    800c14 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	6a 58                	push   $0x58
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 58                	push   $0x58
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 58                	push   $0x58
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			break;
  800bac:	e9 ce 00 00 00       	jmp    800c7f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	6a 30                	push   $0x30
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 78                	push   $0x78
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd4:	83 c0 04             	add    $0x4,%eax
  800bd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800bda:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdd:	83 e8 04             	sub    $0x4,%eax
  800be0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bf3:	eb 1f                	jmp    800c14 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfe:	50                   	push   %eax
  800bff:	e8 e7 fb ff ff       	call   8007eb <getuint>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c14:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1b:	83 ec 04             	sub    $0x4,%esp
  800c1e:	52                   	push   %edx
  800c1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c22:	50                   	push   %eax
  800c23:	ff 75 f4             	pushl  -0xc(%ebp)
  800c26:	ff 75 f0             	pushl  -0x10(%ebp)
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 00 fb ff ff       	call   800734 <printnum>
  800c34:	83 c4 20             	add    $0x20,%esp
			break;
  800c37:	eb 46                	jmp    800c7f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	53                   	push   %ebx
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
			break;
  800c48:	eb 35                	jmp    800c7f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c4a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c51:	eb 2c                	jmp    800c7f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c53:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c5a:	eb 23                	jmp    800c7f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	6a 25                	push   $0x25
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	ff d0                	call   *%eax
  800c69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6c:	ff 4d 10             	decl   0x10(%ebp)
  800c6f:	eb 03                	jmp    800c74 <vprintfmt+0x3c3>
  800c71:	ff 4d 10             	decl   0x10(%ebp)
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	48                   	dec    %eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	3c 25                	cmp    $0x25,%al
  800c7c:	75 f3                	jne    800c71 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c7e:	90                   	nop
		}
	}
  800c7f:	e9 35 fc ff ff       	jmp    8008b9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c92:	8d 45 10             	lea    0x10(%ebp),%eax
  800c95:	83 c0 04             	add    $0x4,%eax
  800c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca1:	50                   	push   %eax
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	ff 75 08             	pushl  0x8(%ebp)
  800ca8:	e8 04 fc ff ff       	call   8008b1 <vprintfmt>
  800cad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cb0:	90                   	nop
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8b 40 08             	mov    0x8(%eax),%eax
  800cbc:	8d 50 01             	lea    0x1(%eax),%edx
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc8:	8b 10                	mov    (%eax),%edx
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8b 40 04             	mov    0x4(%eax),%eax
  800cd0:	39 c2                	cmp    %eax,%edx
  800cd2:	73 12                	jae    800ce6 <sprintputch+0x33>
		*b->buf++ = ch;
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8b 00                	mov    (%eax),%eax
  800cd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdf:	89 0a                	mov    %ecx,(%edx)
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	88 10                	mov    %dl,(%eax)
}
  800ce6:	90                   	nop
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0e:	74 06                	je     800d16 <vsnprintf+0x2d>
  800d10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d14:	7f 07                	jg     800d1d <vsnprintf+0x34>
		return -E_INVAL;
  800d16:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1b:	eb 20                	jmp    800d3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d1d:	ff 75 14             	pushl  0x14(%ebp)
  800d20:	ff 75 10             	pushl  0x10(%ebp)
  800d23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d26:	50                   	push   %eax
  800d27:	68 b3 0c 80 00       	push   $0x800cb3
  800d2c:	e8 80 fb ff ff       	call   8008b1 <vprintfmt>
  800d31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d45:	8d 45 10             	lea    0x10(%ebp),%eax
  800d48:	83 c0 04             	add    $0x4,%eax
  800d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	ff 75 f4             	pushl  -0xc(%ebp)
  800d54:	50                   	push   %eax
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	ff 75 08             	pushl  0x8(%ebp)
  800d5b:	e8 89 ff ff ff       	call   800ce9 <vsnprintf>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 06                	jmp    800d80 <strlen+0x15>
		n++;
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 f1                	jne    800d7a <strlen+0xf>
		n++;
	return n;
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d9b:	eb 09                	jmp    800da6 <strnlen+0x18>
		n++;
  800d9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 4d 0c             	decl   0xc(%ebp)
  800da6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800daa:	74 09                	je     800db5 <strnlen+0x27>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	84 c0                	test   %al,%al
  800db3:	75 e8                	jne    800d9d <strnlen+0xf>
		n++;
	return n;
  800db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dc6:	90                   	nop
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd9:	8a 12                	mov    (%edx),%dl
  800ddb:	88 10                	mov    %dl,(%eax)
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 e4                	jne    800dc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800df4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfb:	eb 1f                	jmp    800e1c <strncpy+0x34>
		*dst++ = *src;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 08             	mov    %edx,0x8(%ebp)
  800e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e09:	8a 12                	mov    (%edx),%dl
  800e0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	84 c0                	test   %al,%al
  800e14:	74 03                	je     800e19 <strncpy+0x31>
			src++;
  800e16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e19:	ff 45 fc             	incl   -0x4(%ebp)
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e22:	72 d9                	jb     800dfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	74 30                	je     800e6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e3b:	eb 16                	jmp    800e53 <strlcpy+0x2a>
			*dst++ = *src++;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8d 50 01             	lea    0x1(%eax),%edx
  800e43:	89 55 08             	mov    %edx,0x8(%ebp)
  800e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4f:	8a 12                	mov    (%edx),%dl
  800e51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e53:	ff 4d 10             	decl   0x10(%ebp)
  800e56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5a:	74 09                	je     800e65 <strlcpy+0x3c>
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	84 c0                	test   %al,%al
  800e63:	75 d8                	jne    800e3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e71:	29 c2                	sub    %eax,%edx
  800e73:	89 d0                	mov    %edx,%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e7a:	eb 06                	jmp    800e82 <strcmp+0xb>
		p++, q++;
  800e7c:	ff 45 08             	incl   0x8(%ebp)
  800e7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strcmp+0x22>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 e3                	je     800e7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f b6 d0             	movzbl %al,%edx
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 c0             	movzbl %al,%eax
  800ea9:	29 c2                	sub    %eax,%edx
  800eab:	89 d0                	mov    %edx,%eax
}
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eb2:	eb 09                	jmp    800ebd <strncmp+0xe>
		n--, p++, q++;
  800eb4:	ff 4d 10             	decl   0x10(%ebp)
  800eb7:	ff 45 08             	incl   0x8(%ebp)
  800eba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	74 17                	je     800eda <strncmp+0x2b>
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	74 0e                	je     800eda <strncmp+0x2b>
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 10                	mov    (%eax),%dl
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	38 c2                	cmp    %al,%dl
  800ed8:	74 da                	je     800eb4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ede:	75 07                	jne    800ee7 <strncmp+0x38>
		return 0;
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	eb 14                	jmp    800efb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	0f b6 d0             	movzbl %al,%edx
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 c0             	movzbl %al,%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 04             	sub    $0x4,%esp
  800f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f09:	eb 12                	jmp    800f1d <strchr+0x20>
		if (*s == c)
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f13:	75 05                	jne    800f1a <strchr+0x1d>
			return (char *) s;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	eb 11                	jmp    800f2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	84 c0                	test   %al,%al
  800f24:	75 e5                	jne    800f0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 04             	sub    $0x4,%esp
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f39:	eb 0d                	jmp    800f48 <strfind+0x1b>
		if (*s == c)
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f43:	74 0e                	je     800f53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	84 c0                	test   %al,%al
  800f4f:	75 ea                	jne    800f3b <strfind+0xe>
  800f51:	eb 01                	jmp    800f54 <strfind+0x27>
		if (*s == c)
			break;
  800f53:	90                   	nop
	return (char *) s;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f6b:	eb 0e                	jmp    800f7b <memset+0x22>
		*p++ = c;
  800f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f70:	8d 50 01             	lea    0x1(%eax),%edx
  800f73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f7b:	ff 4d f8             	decl   -0x8(%ebp)
  800f7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f82:	79 e9                	jns    800f6d <memset+0x14>
		*p++ = c;

	return v;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f9b:	eb 16                	jmp    800fb3 <memcpy+0x2a>
		*d++ = *s++;
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	8d 50 01             	lea    0x1(%eax),%edx
  800fa3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800faf:	8a 12                	mov    (%edx),%dl
  800fb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	75 dd                	jne    800f9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fdd:	73 50                	jae    80102f <memmove+0x6a>
  800fdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fea:	76 43                	jbe    80102f <memmove+0x6a>
		s += n;
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ff8:	eb 10                	jmp    80100a <memmove+0x45>
			*--d = *--s;
  800ffa:	ff 4d f8             	decl   -0x8(%ebp)
  800ffd:	ff 4d fc             	decl   -0x4(%ebp)
  801000:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801003:	8a 10                	mov    (%eax),%dl
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801010:	89 55 10             	mov    %edx,0x10(%ebp)
  801013:	85 c0                	test   %eax,%eax
  801015:	75 e3                	jne    800ffa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801017:	eb 23                	jmp    80103c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8d 50 01             	lea    0x1(%eax),%edx
  80101f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801022:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801025:	8d 4a 01             	lea    0x1(%edx),%ecx
  801028:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80102b:	8a 12                	mov    (%edx),%dl
  80102d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	8d 50 ff             	lea    -0x1(%eax),%edx
  801035:	89 55 10             	mov    %edx,0x10(%ebp)
  801038:	85 c0                	test   %eax,%eax
  80103a:	75 dd                	jne    801019 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801053:	eb 2a                	jmp    80107f <memcmp+0x3e>
		if (*s1 != *s2)
  801055:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801058:	8a 10                	mov    (%eax),%dl
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	38 c2                	cmp    %al,%dl
  801061:	74 16                	je     801079 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	0f b6 d0             	movzbl %al,%edx
  80106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	29 c2                	sub    %eax,%edx
  801075:	89 d0                	mov    %edx,%eax
  801077:	eb 18                	jmp    801091 <memcmp+0x50>
		s1++, s2++;
  801079:	ff 45 fc             	incl   -0x4(%ebp)
  80107c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	8d 50 ff             	lea    -0x1(%eax),%edx
  801085:	89 55 10             	mov    %edx,0x10(%ebp)
  801088:	85 c0                	test   %eax,%eax
  80108a:	75 c9                	jne    801055 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010a4:	eb 15                	jmp    8010bb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	0f b6 d0             	movzbl %al,%edx
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	0f b6 c0             	movzbl %al,%eax
  8010b4:	39 c2                	cmp    %eax,%edx
  8010b6:	74 0d                	je     8010c5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010b8:	ff 45 08             	incl   0x8(%ebp)
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010c1:	72 e3                	jb     8010a6 <memfind+0x13>
  8010c3:	eb 01                	jmp    8010c6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010c5:	90                   	nop
	return (void *) s;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010df:	eb 03                	jmp    8010e4 <strtol+0x19>
		s++;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 20                	cmp    $0x20,%al
  8010eb:	74 f4                	je     8010e1 <strtol+0x16>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 09                	cmp    $0x9,%al
  8010f4:	74 eb                	je     8010e1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 2b                	cmp    $0x2b,%al
  8010fd:	75 05                	jne    801104 <strtol+0x39>
		s++;
  8010ff:	ff 45 08             	incl   0x8(%ebp)
  801102:	eb 13                	jmp    801117 <strtol+0x4c>
	else if (*s == '-')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 2d                	cmp    $0x2d,%al
  80110b:	75 0a                	jne    801117 <strtol+0x4c>
		s++, neg = 1;
  80110d:	ff 45 08             	incl   0x8(%ebp)
  801110:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111b:	74 06                	je     801123 <strtol+0x58>
  80111d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801121:	75 20                	jne    801143 <strtol+0x78>
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	3c 30                	cmp    $0x30,%al
  80112a:	75 17                	jne    801143 <strtol+0x78>
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	40                   	inc    %eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 78                	cmp    $0x78,%al
  801134:	75 0d                	jne    801143 <strtol+0x78>
		s += 2, base = 16;
  801136:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80113a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801141:	eb 28                	jmp    80116b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801147:	75 15                	jne    80115e <strtol+0x93>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 30                	cmp    $0x30,%al
  801150:	75 0c                	jne    80115e <strtol+0x93>
		s++, base = 8;
  801152:	ff 45 08             	incl   0x8(%ebp)
  801155:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80115c:	eb 0d                	jmp    80116b <strtol+0xa0>
	else if (base == 0)
  80115e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801162:	75 07                	jne    80116b <strtol+0xa0>
		base = 10;
  801164:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 2f                	cmp    $0x2f,%al
  801172:	7e 19                	jle    80118d <strtol+0xc2>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 39                	cmp    $0x39,%al
  80117b:	7f 10                	jg     80118d <strtol+0xc2>
			dig = *s - '0';
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f be c0             	movsbl %al,%eax
  801185:	83 e8 30             	sub    $0x30,%eax
  801188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118b:	eb 42                	jmp    8011cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 60                	cmp    $0x60,%al
  801194:	7e 19                	jle    8011af <strtol+0xe4>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 7a                	cmp    $0x7a,%al
  80119d:	7f 10                	jg     8011af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	83 e8 57             	sub    $0x57,%eax
  8011aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ad:	eb 20                	jmp    8011cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	3c 40                	cmp    $0x40,%al
  8011b6:	7e 39                	jle    8011f1 <strtol+0x126>
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 5a                	cmp    $0x5a,%al
  8011bf:	7f 30                	jg     8011f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	0f be c0             	movsbl %al,%eax
  8011c9:	83 e8 37             	sub    $0x37,%eax
  8011cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d5:	7d 19                	jge    8011f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011d7:	ff 45 08             	incl   0x8(%ebp)
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011eb:	e9 7b ff ff ff       	jmp    80116b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f5:	74 08                	je     8011ff <strtol+0x134>
		*endptr = (char *) s;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801203:	74 07                	je     80120c <strtol+0x141>
  801205:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801208:	f7 d8                	neg    %eax
  80120a:	eb 03                	jmp    80120f <strtol+0x144>
  80120c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <ltostr>:

void
ltostr(long value, char *str)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80121e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801229:	79 13                	jns    80123e <ltostr+0x2d>
	{
		neg = 1;
  80122b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801238:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80123b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801246:	99                   	cltd   
  801247:	f7 f9                	idiv   %ecx
  801249:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801255:	89 c2                	mov    %eax,%edx
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	01 d0                	add    %edx,%eax
  80125c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125f:	83 c2 30             	add    $0x30,%edx
  801262:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801264:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801267:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80126c:	f7 e9                	imul   %ecx
  80126e:	c1 fa 02             	sar    $0x2,%edx
  801271:	89 c8                	mov    %ecx,%eax
  801273:	c1 f8 1f             	sar    $0x1f,%eax
  801276:	29 c2                	sub    %eax,%edx
  801278:	89 d0                	mov    %edx,%eax
  80127a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80127d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801281:	75 bb                	jne    80123e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80128a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128d:	48                   	dec    %eax
  80128e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801295:	74 3d                	je     8012d4 <ltostr+0xc3>
		start = 1 ;
  801297:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80129e:	eb 34                	jmp    8012d4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	01 c2                	add    %eax,%edx
  8012b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c8                	add    %ecx,%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012cc:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ce:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012d1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012da:	7c c4                	jl     8012a0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	01 d0                	add    %edx,%eax
  8012e4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e7:	90                   	nop
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	e8 73 fa ff ff       	call   800d6b <strlen>
  8012f8:	83 c4 04             	add    $0x4,%esp
  8012fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	e8 65 fa ff ff       	call   800d6b <strlen>
  801306:	83 c4 04             	add    $0x4,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80130c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131a:	eb 17                	jmp    801333 <strcconcat+0x49>
		final[s] = str1[s] ;
  80131c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	01 c8                	add    %ecx,%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801330:	ff 45 fc             	incl   -0x4(%ebp)
  801333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801336:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801339:	7c e1                	jl     80131c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80133b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801342:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801349:	eb 1f                	jmp    80136a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80134b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801354:	89 c2                	mov    %eax,%edx
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	01 c2                	add    %eax,%edx
  80135b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	01 c8                	add    %ecx,%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801367:	ff 45 f8             	incl   -0x8(%ebp)
  80136a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801370:	7c d9                	jl     80134b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801372:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	c6 00 00             	movb   $0x0,(%eax)
}
  80137d:	90                   	nop
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801383:	8b 45 14             	mov    0x14(%ebp),%eax
  801386:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80138c:	8b 45 14             	mov    0x14(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 d0                	add    %edx,%eax
  80139d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a3:	eb 0c                	jmp    8013b1 <strsplit+0x31>
			*string++ = 0;
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8d 50 01             	lea    0x1(%eax),%edx
  8013ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ae:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 18                	je     8013d2 <strsplit+0x52>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	0f be c0             	movsbl %al,%eax
  8013c2:	50                   	push   %eax
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	e8 32 fb ff ff       	call   800efd <strchr>
  8013cb:	83 c4 08             	add    $0x8,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	75 d3                	jne    8013a5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	84 c0                	test   %al,%al
  8013d9:	74 5a                	je     801435 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013db:	8b 45 14             	mov    0x14(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	83 f8 0f             	cmp    $0xf,%eax
  8013e3:	75 07                	jne    8013ec <strsplit+0x6c>
		{
			return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	eb 66                	jmp    801452 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ef:	8b 00                	mov    (%eax),%eax
  8013f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f7:	89 0a                	mov    %ecx,(%edx)
  8013f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	01 c2                	add    %eax,%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140a:	eb 03                	jmp    80140f <strsplit+0x8f>
			string++;
  80140c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	84 c0                	test   %al,%al
  801416:	74 8b                	je     8013a3 <strsplit+0x23>
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	0f be c0             	movsbl %al,%eax
  801420:	50                   	push   %eax
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	e8 d4 fa ff ff       	call   800efd <strchr>
  801429:	83 c4 08             	add    $0x8,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 dc                	je     80140c <strsplit+0x8c>
			string++;
	}
  801430:	e9 6e ff ff ff       	jmp    8013a3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801435:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801436:	8b 45 14             	mov    0x14(%ebp),%eax
  801439:	8b 00                	mov    (%eax),%eax
  80143b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801442:	8b 45 10             	mov    0x10(%ebp),%eax
  801445:	01 d0                	add    %edx,%eax
  801447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80144d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 08 26 80 00       	push   $0x802608
  801462:	68 3f 01 00 00       	push   $0x13f
  801467:	68 2a 26 80 00       	push   $0x80262a
  80146c:	e8 a9 ef ff ff       	call   80041a <_panic>

00801471 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801477:	83 ec 0c             	sub    $0xc,%esp
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 ef 06 00 00       	call   801b71 <sys_sbrk>
  801482:	83 c4 10             	add    $0x10,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80148d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801491:	75 07                	jne    80149a <malloc+0x13>
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
  801498:	eb 14                	jmp    8014ae <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	68 38 26 80 00       	push   $0x802638
  8014a2:	6a 1b                	push   $0x1b
  8014a4:	68 5d 26 80 00       	push   $0x80265d
  8014a9:	e8 6c ef ff ff       	call   80041a <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014b6:	83 ec 04             	sub    $0x4,%esp
  8014b9:	68 6c 26 80 00       	push   $0x80266c
  8014be:	6a 29                	push   $0x29
  8014c0:	68 5d 26 80 00       	push   $0x80265d
  8014c5:	e8 50 ef ff ff       	call   80041a <_panic>

008014ca <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 18             	sub    $0x18,%esp
  8014d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014da:	75 07                	jne    8014e3 <smalloc+0x19>
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e1:	eb 14                	jmp    8014f7 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 90 26 80 00       	push   $0x802690
  8014eb:	6a 38                	push   $0x38
  8014ed:	68 5d 26 80 00       	push   $0x80265d
  8014f2:	e8 23 ef ff ff       	call   80041a <_panic>
	return NULL;
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	68 b8 26 80 00       	push   $0x8026b8
  801507:	6a 43                	push   $0x43
  801509:	68 5d 26 80 00       	push   $0x80265d
  80150e:	e8 07 ef ff ff       	call   80041a <_panic>

00801513 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	68 dc 26 80 00       	push   $0x8026dc
  801521:	6a 5b                	push   $0x5b
  801523:	68 5d 26 80 00       	push   $0x80265d
  801528:	e8 ed ee ff ff       	call   80041a <_panic>

0080152d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	68 00 27 80 00       	push   $0x802700
  80153b:	6a 72                	push   $0x72
  80153d:	68 5d 26 80 00       	push   $0x80265d
  801542:	e8 d3 ee ff ff       	call   80041a <_panic>

00801547 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 26 27 80 00       	push   $0x802726
  801555:	6a 7e                	push   $0x7e
  801557:	68 5d 26 80 00       	push   $0x80265d
  80155c:	e8 b9 ee ff ff       	call   80041a <_panic>

00801561 <shrink>:

}
void shrink(uint32 newSize)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 26 27 80 00       	push   $0x802726
  80156f:	68 83 00 00 00       	push   $0x83
  801574:	68 5d 26 80 00       	push   $0x80265d
  801579:	e8 9c ee ff ff       	call   80041a <_panic>

0080157e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 26 27 80 00       	push   $0x802726
  80158c:	68 88 00 00 00       	push   $0x88
  801591:	68 5d 26 80 00       	push   $0x80265d
  801596:	e8 7f ee ff ff       	call   80041a <_panic>

0080159b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	57                   	push   %edi
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b6:	cd 30                	int    $0x30
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	52                   	push   %edx
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 b2 ff ff ff       	call   80159b <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	90                   	nop
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 02                	push   $0x2
  8015fe:	e8 98 ff ff ff       	call   80159b <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 03                	push   $0x3
  801617:	e8 7f ff ff ff       	call   80159b <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 04                	push   $0x4
  801631:	e8 65 ff ff ff       	call   80159b <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	90                   	nop
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 08                	push   $0x8
  80164f:	e8 47 ff ff ff       	call   80159b <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165e:	8b 75 18             	mov    0x18(%ebp),%esi
  801661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	56                   	push   %esi
  80166e:	53                   	push   %ebx
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	6a 09                	push   $0x9
  801674:	e8 22 ff ff ff       	call   80159b <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 0a                	push   $0xa
  801696:	e8 00 ff ff ff       	call   80159b <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	6a 0b                	push   $0xb
  8016b1:	e8 e5 fe ff ff       	call   80159b <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 0c                	push   $0xc
  8016ca:	e8 cc fe ff ff       	call   80159b <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 0d                	push   $0xd
  8016e3:	e8 b3 fe ff ff       	call   80159b <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 0e                	push   $0xe
  8016fc:	e8 9a fe ff ff       	call   80159b <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 0f                	push   $0xf
  801715:	e8 81 fe ff ff       	call   80159b <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 10                	push   $0x10
  80172f:	e8 67 fe ff ff       	call   80159b <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 11                	push   $0x11
  801748:	e8 4e fe ff ff       	call   80159b <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_cputc>:

void
sys_cputc(const char c)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	50                   	push   %eax
  80176c:	6a 01                	push   $0x1
  80176e:	e8 28 fe ff ff       	call   80159b <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	90                   	nop
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 14                	push   $0x14
  801788:	e8 0e fe ff ff       	call   80159b <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	8b 45 10             	mov    0x10(%ebp),%eax
  80179c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80179f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	51                   	push   %ecx
  8017ac:	52                   	push   %edx
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	50                   	push   %eax
  8017b1:	6a 15                	push   $0x15
  8017b3:	e8 e3 fd ff ff       	call   80159b <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	52                   	push   %edx
  8017cd:	50                   	push   %eax
  8017ce:	6a 16                	push   $0x16
  8017d0:	e8 c6 fd ff ff       	call   80159b <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	51                   	push   %ecx
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 17                	push   $0x17
  8017ef:	e8 a7 fd ff ff       	call   80159b <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	52                   	push   %edx
  801809:	50                   	push   %eax
  80180a:	6a 18                	push   $0x18
  80180c:	e8 8a fd ff ff       	call   80159b <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 14             	pushl  0x14(%ebp)
  801821:	ff 75 10             	pushl  0x10(%ebp)
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	50                   	push   %eax
  801828:	6a 19                	push   $0x19
  80182a:	e8 6c fd ff ff       	call   80159b <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	50                   	push   %eax
  801843:	6a 1a                	push   $0x1a
  801845:	e8 51 fd ff ff       	call   80159b <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	50                   	push   %eax
  80185f:	6a 1b                	push   $0x1b
  801861:	e8 35 fd ff ff       	call   80159b <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 05                	push   $0x5
  80187a:	e8 1c fd ff ff       	call   80159b <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 06                	push   $0x6
  801893:	e8 03 fd ff ff       	call   80159b <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 07                	push   $0x7
  8018ac:	e8 ea fc ff ff       	call   80159b <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 1c                	push   $0x1c
  8018c5:	e8 d1 fc ff ff       	call   80159b <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d9:	8d 50 04             	lea    0x4(%eax),%edx
  8018dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 1d                	push   $0x1d
  8018e9:	e8 ad fc ff ff       	call   80159b <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018fa:	89 01                	mov    %eax,(%ecx)
  8018fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	c9                   	leave  
  801903:	c2 04 00             	ret    $0x4

00801906 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 10             	pushl  0x10(%ebp)
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	6a 13                	push   $0x13
  801918:	e8 7e fc ff ff       	call   80159b <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_rcr2>:
uint32 sys_rcr2()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 1e                	push   $0x1e
  801932:	e8 64 fc ff ff       	call   80159b <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801948:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	50                   	push   %eax
  801955:	6a 1f                	push   $0x1f
  801957:	e8 3f fc ff ff       	call   80159b <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <rsttst>:
void rsttst()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 21                	push   $0x21
  801971:	e8 25 fc ff ff       	call   80159b <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
	return ;
  801979:	90                   	nop
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 45 14             	mov    0x14(%ebp),%eax
  801985:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801988:	8b 55 18             	mov    0x18(%ebp),%edx
  80198b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	6a 20                	push   $0x20
  80199c:	e8 fa fb ff ff       	call   80159b <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a4:	90                   	nop
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <chktst>:
void chktst(uint32 n)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	6a 22                	push   $0x22
  8019b7:	e8 df fb ff ff       	call   80159b <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bf:	90                   	nop
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <inctst>:

void inctst()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 23                	push   $0x23
  8019d1:	e8 c5 fb ff ff       	call   80159b <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d9:	90                   	nop
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <gettst>:
uint32 gettst()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 24                	push   $0x24
  8019eb:	e8 ab fb ff ff       	call   80159b <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 25                	push   $0x25
  801a07:	e8 8f fb ff ff       	call   80159b <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
  801a0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a16:	75 07                	jne    801a1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a18:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1d:	eb 05                	jmp    801a24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 25                	push   $0x25
  801a38:	e8 5e fb ff ff       	call   80159b <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
  801a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a47:	75 07                	jne    801a50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	eb 05                	jmp    801a55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 25                	push   $0x25
  801a69:	e8 2d fb ff ff       	call   80159b <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
  801a71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a78:	75 07                	jne    801a81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	eb 05                	jmp    801a86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 25                	push   $0x25
  801a9a:	e8 fc fa ff ff       	call   80159b <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
  801aa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa9:	75 07                	jne    801ab2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aab:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab0:	eb 05                	jmp    801ab7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	ff 75 08             	pushl  0x8(%ebp)
  801ac7:	6a 26                	push   $0x26
  801ac9:	e8 cd fa ff ff       	call   80159b <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad1:	90                   	nop
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	53                   	push   %ebx
  801ae7:	51                   	push   %ecx
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 27                	push   $0x27
  801aec:	e8 aa fa ff ff       	call   80159b <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 28                	push   $0x28
  801b0c:	e8 8a fa ff ff       	call   80159b <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	51                   	push   %ecx
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 29                	push   $0x29
  801b2c:	e8 6a fa ff ff       	call   80159b <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 12                	push   $0x12
  801b48:	e8 4e fa ff ff       	call   80159b <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 2a                	push   $0x2a
  801b66:	e8 30 fa ff ff       	call   80159b <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
	return;
  801b6e:	90                   	nop
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	50                   	push   %eax
  801b80:	6a 2b                	push   $0x2b
  801b82:	e8 14 fa ff ff       	call   80159b <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 2c                	push   $0x2c
  801b9d:	e8 f9 f9 ff ff       	call   80159b <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 2d                	push   $0x2d
  801bb9:	e8 dd f9 ff ff       	call   80159b <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <__udivdi3>:
  801bc4:	55                   	push   %ebp
  801bc5:	57                   	push   %edi
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 1c             	sub    $0x1c,%esp
  801bcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdb:	89 ca                	mov    %ecx,%edx
  801bdd:	89 f8                	mov    %edi,%eax
  801bdf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801be3:	85 f6                	test   %esi,%esi
  801be5:	75 2d                	jne    801c14 <__udivdi3+0x50>
  801be7:	39 cf                	cmp    %ecx,%edi
  801be9:	77 65                	ja     801c50 <__udivdi3+0x8c>
  801beb:	89 fd                	mov    %edi,%ebp
  801bed:	85 ff                	test   %edi,%edi
  801bef:	75 0b                	jne    801bfc <__udivdi3+0x38>
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	31 d2                	xor    %edx,%edx
  801bf8:	f7 f7                	div    %edi
  801bfa:	89 c5                	mov    %eax,%ebp
  801bfc:	31 d2                	xor    %edx,%edx
  801bfe:	89 c8                	mov    %ecx,%eax
  801c00:	f7 f5                	div    %ebp
  801c02:	89 c1                	mov    %eax,%ecx
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	f7 f5                	div    %ebp
  801c08:	89 cf                	mov    %ecx,%edi
  801c0a:	89 fa                	mov    %edi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	39 ce                	cmp    %ecx,%esi
  801c16:	77 28                	ja     801c40 <__udivdi3+0x7c>
  801c18:	0f bd fe             	bsr    %esi,%edi
  801c1b:	83 f7 1f             	xor    $0x1f,%edi
  801c1e:	75 40                	jne    801c60 <__udivdi3+0x9c>
  801c20:	39 ce                	cmp    %ecx,%esi
  801c22:	72 0a                	jb     801c2e <__udivdi3+0x6a>
  801c24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c28:	0f 87 9e 00 00 00    	ja     801ccc <__udivdi3+0x108>
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	89 fa                	mov    %edi,%edx
  801c35:	83 c4 1c             	add    $0x1c,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
  801c3d:	8d 76 00             	lea    0x0(%esi),%esi
  801c40:	31 ff                	xor    %edi,%edi
  801c42:	31 c0                	xor    %eax,%eax
  801c44:	89 fa                	mov    %edi,%edx
  801c46:	83 c4 1c             	add    $0x1c,%esp
  801c49:	5b                   	pop    %ebx
  801c4a:	5e                   	pop    %esi
  801c4b:	5f                   	pop    %edi
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	f7 f7                	div    %edi
  801c54:	31 ff                	xor    %edi,%edi
  801c56:	89 fa                	mov    %edi,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c65:	89 eb                	mov    %ebp,%ebx
  801c67:	29 fb                	sub    %edi,%ebx
  801c69:	89 f9                	mov    %edi,%ecx
  801c6b:	d3 e6                	shl    %cl,%esi
  801c6d:	89 c5                	mov    %eax,%ebp
  801c6f:	88 d9                	mov    %bl,%cl
  801c71:	d3 ed                	shr    %cl,%ebp
  801c73:	89 e9                	mov    %ebp,%ecx
  801c75:	09 f1                	or     %esi,%ecx
  801c77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c7b:	89 f9                	mov    %edi,%ecx
  801c7d:	d3 e0                	shl    %cl,%eax
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 d6                	mov    %edx,%esi
  801c83:	88 d9                	mov    %bl,%cl
  801c85:	d3 ee                	shr    %cl,%esi
  801c87:	89 f9                	mov    %edi,%ecx
  801c89:	d3 e2                	shl    %cl,%edx
  801c8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c8f:	88 d9                	mov    %bl,%cl
  801c91:	d3 e8                	shr    %cl,%eax
  801c93:	09 c2                	or     %eax,%edx
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	89 f2                	mov    %esi,%edx
  801c99:	f7 74 24 0c          	divl   0xc(%esp)
  801c9d:	89 d6                	mov    %edx,%esi
  801c9f:	89 c3                	mov    %eax,%ebx
  801ca1:	f7 e5                	mul    %ebp
  801ca3:	39 d6                	cmp    %edx,%esi
  801ca5:	72 19                	jb     801cc0 <__udivdi3+0xfc>
  801ca7:	74 0b                	je     801cb4 <__udivdi3+0xf0>
  801ca9:	89 d8                	mov    %ebx,%eax
  801cab:	31 ff                	xor    %edi,%edi
  801cad:	e9 58 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cb8:	89 f9                	mov    %edi,%ecx
  801cba:	d3 e2                	shl    %cl,%edx
  801cbc:	39 c2                	cmp    %eax,%edx
  801cbe:	73 e9                	jae    801ca9 <__udivdi3+0xe5>
  801cc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	e9 40 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	31 c0                	xor    %eax,%eax
  801cce:	e9 37 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cd3:	90                   	nop

00801cd4 <__umoddi3>:
  801cd4:	55                   	push   %ebp
  801cd5:	57                   	push   %edi
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 1c             	sub    $0x1c,%esp
  801cdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ce7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ceb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf3:	89 f3                	mov    %esi,%ebx
  801cf5:	89 fa                	mov    %edi,%edx
  801cf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cfb:	89 34 24             	mov    %esi,(%esp)
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	75 1a                	jne    801d1c <__umoddi3+0x48>
  801d02:	39 f7                	cmp    %esi,%edi
  801d04:	0f 86 a2 00 00 00    	jbe    801dac <__umoddi3+0xd8>
  801d0a:	89 c8                	mov    %ecx,%eax
  801d0c:	89 f2                	mov    %esi,%edx
  801d0e:	f7 f7                	div    %edi
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	31 d2                	xor    %edx,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	39 f0                	cmp    %esi,%eax
  801d1e:	0f 87 ac 00 00 00    	ja     801dd0 <__umoddi3+0xfc>
  801d24:	0f bd e8             	bsr    %eax,%ebp
  801d27:	83 f5 1f             	xor    $0x1f,%ebp
  801d2a:	0f 84 ac 00 00 00    	je     801ddc <__umoddi3+0x108>
  801d30:	bf 20 00 00 00       	mov    $0x20,%edi
  801d35:	29 ef                	sub    %ebp,%edi
  801d37:	89 fe                	mov    %edi,%esi
  801d39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 e0                	shl    %cl,%eax
  801d41:	89 d7                	mov    %edx,%edi
  801d43:	89 f1                	mov    %esi,%ecx
  801d45:	d3 ef                	shr    %cl,%edi
  801d47:	09 c7                	or     %eax,%edi
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 e2                	shl    %cl,%edx
  801d4d:	89 14 24             	mov    %edx,(%esp)
  801d50:	89 d8                	mov    %ebx,%eax
  801d52:	d3 e0                	shl    %cl,%eax
  801d54:	89 c2                	mov    %eax,%edx
  801d56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5a:	d3 e0                	shl    %cl,%eax
  801d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d64:	89 f1                	mov    %esi,%ecx
  801d66:	d3 e8                	shr    %cl,%eax
  801d68:	09 d0                	or     %edx,%eax
  801d6a:	d3 eb                	shr    %cl,%ebx
  801d6c:	89 da                	mov    %ebx,%edx
  801d6e:	f7 f7                	div    %edi
  801d70:	89 d3                	mov    %edx,%ebx
  801d72:	f7 24 24             	mull   (%esp)
  801d75:	89 c6                	mov    %eax,%esi
  801d77:	89 d1                	mov    %edx,%ecx
  801d79:	39 d3                	cmp    %edx,%ebx
  801d7b:	0f 82 87 00 00 00    	jb     801e08 <__umoddi3+0x134>
  801d81:	0f 84 91 00 00 00    	je     801e18 <__umoddi3+0x144>
  801d87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d8b:	29 f2                	sub    %esi,%edx
  801d8d:	19 cb                	sbb    %ecx,%ebx
  801d8f:	89 d8                	mov    %ebx,%eax
  801d91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d95:	d3 e0                	shl    %cl,%eax
  801d97:	89 e9                	mov    %ebp,%ecx
  801d99:	d3 ea                	shr    %cl,%edx
  801d9b:	09 d0                	or     %edx,%eax
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 eb                	shr    %cl,%ebx
  801da1:	89 da                	mov    %ebx,%edx
  801da3:	83 c4 1c             	add    $0x1c,%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5e                   	pop    %esi
  801da8:	5f                   	pop    %edi
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    
  801dab:	90                   	nop
  801dac:	89 fd                	mov    %edi,%ebp
  801dae:	85 ff                	test   %edi,%edi
  801db0:	75 0b                	jne    801dbd <__umoddi3+0xe9>
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	31 d2                	xor    %edx,%edx
  801db9:	f7 f7                	div    %edi
  801dbb:	89 c5                	mov    %eax,%ebp
  801dbd:	89 f0                	mov    %esi,%eax
  801dbf:	31 d2                	xor    %edx,%edx
  801dc1:	f7 f5                	div    %ebp
  801dc3:	89 c8                	mov    %ecx,%eax
  801dc5:	f7 f5                	div    %ebp
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	e9 44 ff ff ff       	jmp    801d12 <__umoddi3+0x3e>
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	89 c8                	mov    %ecx,%eax
  801dd2:	89 f2                	mov    %esi,%edx
  801dd4:	83 c4 1c             	add    $0x1c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
  801ddc:	3b 04 24             	cmp    (%esp),%eax
  801ddf:	72 06                	jb     801de7 <__umoddi3+0x113>
  801de1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801de5:	77 0f                	ja     801df6 <__umoddi3+0x122>
  801de7:	89 f2                	mov    %esi,%edx
  801de9:	29 f9                	sub    %edi,%ecx
  801deb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801def:	89 14 24             	mov    %edx,(%esp)
  801df2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801df6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dfa:	8b 14 24             	mov    (%esp),%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	2b 04 24             	sub    (%esp),%eax
  801e0b:	19 fa                	sbb    %edi,%edx
  801e0d:	89 d1                	mov    %edx,%ecx
  801e0f:	89 c6                	mov    %eax,%esi
  801e11:	e9 71 ff ff ff       	jmp    801d87 <__umoddi3+0xb3>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e1c:	72 ea                	jb     801e08 <__umoddi3+0x134>
  801e1e:	89 d9                	mov    %ebx,%ecx
  801e20:	e9 62 ff ff ff       	jmp    801d87 <__umoddi3+0xb3>
