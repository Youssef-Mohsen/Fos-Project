
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
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 3d 80 00       	push   $0x803dc0
  800065:	6a 12                	push   $0x12
  800067:	68 dc 3d 80 00       	push   $0x803ddc
  80006c:	e8 b1 03 00 00       	call   800422 <_panic>
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
  8000bc:	e8 f8 1a 00 00       	call   801bb9 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 3b 1b 00 00       	call   801c04 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 b2 13 00 00       	call   80148f <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 f8 3d 80 00       	push   $0x803df8
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 dc 3d 80 00       	push   $0x803ddc
  800100:	e8 1d 03 00 00       	call   800422 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 fa 1a 00 00       	call   801c04 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 3e 80 00       	push   $0x803e28
  800117:	6a 32                	push   $0x32
  800119:	68 dc 3d 80 00       	push   $0x803ddc
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 91 1a 00 00       	call   801bb9 <sys_calculate_free_frames>
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
  80015f:	e8 55 1a 00 00       	call   801bb9 <sys_calculate_free_frames>
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
  80017c:	68 58 3e 80 00       	push   $0x803e58
  800181:	6a 3c                	push   $0x3c
  800183:	68 dc 3d 80 00       	push   $0x803ddc
  800188:	e8 95 02 00 00       	call   800422 <_panic>

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
  8001c7:	e8 48 1e 00 00       	call   802014 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 3e 80 00       	push   $0x803ed4
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 dc 3d 80 00       	push   $0x803ddc
  8001e7:	e8 36 02 00 00       	call   800422 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 c8 19 00 00       	call   801bb9 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 0b 1a 00 00       	call   801c04 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 f1 19 00 00       	call   801c04 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 3e 80 00       	push   $0x803ef4
  800220:	6a 4d                	push   $0x4d
  800222:	68 dc 3d 80 00       	push   $0x803ddc
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 88 19 00 00       	call   801bb9 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 30 3f 80 00       	push   $0x803f30
  800247:	6a 4e                	push   $0x4e
  800249:	68 dc 3d 80 00       	push   $0x803ddc
  80024e:	e8 cf 01 00 00       	call   800422 <_panic>
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
  80028d:	e8 82 1d 00 00       	call   802014 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 3f 80 00       	push   $0x803f7c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 dc 3d 80 00       	push   $0x803ddc
  8002ad:	e8 70 01 00 00       	call   800422 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 09 1c 00 00       	call   801ec0 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 1d 1c 00 00       	call   801eda <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 f1 1b 00 00       	call   801ec0 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 a0 3f 80 00       	push   $0x803fa0
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 dc 3d 80 00       	push   $0x803ddc
  8002de:	e8 3f 01 00 00       	call   800422 <_panic>

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
  8002e9:	e8 94 1a 00 00       	call   801d82 <sys_getenvindex>
  8002ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	c1 e0 03             	shl    $0x3,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800302:	01 c8                	add    %ecx,%eax
  800304:	01 c0                	add    %eax,%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80030f:	01 c8                	add    %ecx,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800318:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80031d:	a1 20 50 80 00       	mov    0x805020,%eax
  800322:	8a 40 20             	mov    0x20(%eax),%al
  800325:	84 c0                	test   %al,%al
  800327:	74 0d                	je     800336 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800329:	a1 20 50 80 00       	mov    0x805020,%eax
  80032e:	83 c0 20             	add    $0x20,%eax
  800331:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033a:	7e 0a                	jle    800346 <libmain+0x63>
		binaryname = argv[0];
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 e4 fc ff ff       	call   800038 <_main>
  800354:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800357:	e8 aa 17 00 00       	call   801b06 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 04 40 80 00       	push   $0x804004
  800364:	e8 76 03 00 00       	call   8006df <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80036c:	a1 20 50 80 00       	mov    0x805020,%eax
  800371:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800377:	a1 20 50 80 00       	mov    0x805020,%eax
  80037c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	52                   	push   %edx
  800386:	50                   	push   %eax
  800387:	68 2c 40 80 00       	push   $0x80402c
  80038c:	e8 4e 03 00 00       	call   8006df <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8003aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8003af:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003b5:	51                   	push   %ecx
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 54 40 80 00       	push   $0x804054
  8003bd:	e8 1d 03 00 00       	call   8006df <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	50                   	push   %eax
  8003d4:	68 ac 40 80 00       	push   $0x8040ac
  8003d9:	e8 01 03 00 00       	call   8006df <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 04 40 80 00       	push   $0x804004
  8003e9:	e8 f1 02 00 00       	call   8006df <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f1:	e8 2a 17 00 00       	call   801b20 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003f6:	e8 19 00 00 00       	call   800414 <exit>
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	6a 00                	push   $0x0
  800409:	e8 40 19 00 00       	call   801d4e <sys_destroy_env>
  80040e:	83 c4 10             	add    $0x10,%esp
}
  800411:	90                   	nop
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <exit>:

void
exit(void)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80041a:	e8 95 19 00 00       	call   801db4 <sys_exit_env>
}
  80041f:	90                   	nop
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800428:	8d 45 10             	lea    0x10(%ebp),%eax
  80042b:	83 c0 04             	add    $0x4,%eax
  80042e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800431:	a1 50 50 80 00       	mov    0x805050,%eax
  800436:	85 c0                	test   %eax,%eax
  800438:	74 16                	je     800450 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80043a:	a1 50 50 80 00       	mov    0x805050,%eax
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	50                   	push   %eax
  800443:	68 c0 40 80 00       	push   $0x8040c0
  800448:	e8 92 02 00 00       	call   8006df <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800450:	a1 00 50 80 00       	mov    0x805000,%eax
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	50                   	push   %eax
  80045c:	68 c5 40 80 00       	push   $0x8040c5
  800461:	e8 79 02 00 00       	call   8006df <cprintf>
  800466:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800469:	8b 45 10             	mov    0x10(%ebp),%eax
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 f4             	pushl  -0xc(%ebp)
  800472:	50                   	push   %eax
  800473:	e8 fc 01 00 00       	call   800674 <vcprintf>
  800478:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	6a 00                	push   $0x0
  800480:	68 e1 40 80 00       	push   $0x8040e1
  800485:	e8 ea 01 00 00       	call   800674 <vcprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80048d:	e8 82 ff ff ff       	call   800414 <exit>

	// should not return here
	while (1) ;
  800492:	eb fe                	jmp    800492 <_panic+0x70>

00800494 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80049a:	a1 20 50 80 00       	mov    0x805020,%eax
  80049f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	39 c2                	cmp    %eax,%edx
  8004aa:	74 14                	je     8004c0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	68 e4 40 80 00       	push   $0x8040e4
  8004b4:	6a 26                	push   $0x26
  8004b6:	68 30 41 80 00       	push   $0x804130
  8004bb:	e8 62 ff ff ff       	call   800422 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	e9 c5 00 00 00       	jmp    800598 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	75 08                	jne    8004f0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004e8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004eb:	e9 a5 00 00 00       	jmp    800595 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004fe:	eb 69                	jmp    800569 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800500:	a1 20 50 80 00       	mov    0x805020,%eax
  800505:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80050b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80050e:	89 d0                	mov    %edx,%eax
  800510:	01 c0                	add    %eax,%eax
  800512:	01 d0                	add    %edx,%eax
  800514:	c1 e0 03             	shl    $0x3,%eax
  800517:	01 c8                	add    %ecx,%eax
  800519:	8a 40 04             	mov    0x4(%eax),%al
  80051c:	84 c0                	test   %al,%al
  80051e:	75 46                	jne    800566 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800520:	a1 20 50 80 00       	mov    0x805020,%eax
  800525:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80052b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052e:	89 d0                	mov    %edx,%eax
  800530:	01 c0                	add    %eax,%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	c1 e0 03             	shl    $0x3,%eax
  800537:	01 c8                	add    %ecx,%eax
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80053e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800541:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800546:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	01 c8                	add    %ecx,%eax
  800557:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	75 09                	jne    800566 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80055d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800564:	eb 15                	jmp    80057b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800566:	ff 45 e8             	incl   -0x18(%ebp)
  800569:	a1 20 50 80 00       	mov    0x805020,%eax
  80056e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800577:	39 c2                	cmp    %eax,%edx
  800579:	77 85                	ja     800500 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80057b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80057f:	75 14                	jne    800595 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	68 3c 41 80 00       	push   $0x80413c
  800589:	6a 3a                	push   $0x3a
  80058b:	68 30 41 80 00       	push   $0x804130
  800590:	e8 8d fe ff ff       	call   800422 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800595:	ff 45 f0             	incl   -0x10(%ebp)
  800598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80059e:	0f 8c 2f ff ff ff    	jl     8004d3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005b2:	eb 26                	jmp    8005da <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8005bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c2:	89 d0                	mov    %edx,%eax
  8005c4:	01 c0                	add    %eax,%eax
  8005c6:	01 d0                	add    %edx,%eax
  8005c8:	c1 e0 03             	shl    $0x3,%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8a 40 04             	mov    0x4(%eax),%al
  8005d0:	3c 01                	cmp    $0x1,%al
  8005d2:	75 03                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005d4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d7:	ff 45 e0             	incl   -0x20(%ebp)
  8005da:	a1 20 50 80 00       	mov    0x805020,%eax
  8005df:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 c8                	ja     8005b4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005f2:	74 14                	je     800608 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 90 41 80 00       	push   $0x804190
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 30 41 80 00       	push   $0x804130
  800603:	e8 1a fe ff ff       	call   800422 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800608:	90                   	nop
  800609:	c9                   	leave  
  80060a:	c3                   	ret    

0080060b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800611:	8b 45 0c             	mov    0xc(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 48 01             	lea    0x1(%eax),%ecx
  800619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061c:	89 0a                	mov    %ecx,(%edx)
  80061e:	8b 55 08             	mov    0x8(%ebp),%edx
  800621:	88 d1                	mov    %dl,%cl
  800623:	8b 55 0c             	mov    0xc(%ebp),%edx
  800626:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800634:	75 2c                	jne    800662 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800636:	a0 2c 50 80 00       	mov    0x80502c,%al
  80063b:	0f b6 c0             	movzbl %al,%eax
  80063e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800641:	8b 12                	mov    (%edx),%edx
  800643:	89 d1                	mov    %edx,%ecx
  800645:	8b 55 0c             	mov    0xc(%ebp),%edx
  800648:	83 c2 08             	add    $0x8,%edx
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	50                   	push   %eax
  80064f:	51                   	push   %ecx
  800650:	52                   	push   %edx
  800651:	e8 6e 14 00 00       	call   801ac4 <sys_cputs>
  800656:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800662:	8b 45 0c             	mov    0xc(%ebp),%eax
  800665:	8b 40 04             	mov    0x4(%eax),%eax
  800668:	8d 50 01             	lea    0x1(%eax),%edx
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800671:	90                   	nop
  800672:	c9                   	leave  
  800673:	c3                   	ret    

00800674 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
  800677:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80067d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800684:	00 00 00 
	b.cnt = 0;
  800687:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80068e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 08             	pushl  0x8(%ebp)
  800697:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	68 0b 06 80 00       	push   $0x80060b
  8006a3:	e8 11 02 00 00       	call   8008b9 <vprintfmt>
  8006a8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006ab:	a0 2c 50 80 00       	mov    0x80502c,%al
  8006b0:	0f b6 c0             	movzbl %al,%eax
  8006b3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	52                   	push   %edx
  8006be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c4:	83 c0 08             	add    $0x8,%eax
  8006c7:	50                   	push   %eax
  8006c8:	e8 f7 13 00 00       	call   801ac4 <sys_cputs>
  8006cd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006d0:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  8006d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006dd:	c9                   	leave  
  8006de:	c3                   	ret    

008006df <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
  8006e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006e5:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  8006ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 73 ff ff ff       	call   800674 <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800707:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070a:	c9                   	leave  
  80070b:	c3                   	ret    

0080070c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800712:	e8 ef 13 00 00       	call   801b06 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800717:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 f4             	pushl  -0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	e8 48 ff ff ff       	call   800674 <vcprintf>
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800732:	e8 e9 13 00 00       	call   801b20 <sys_unlock_cons>
	return cnt;
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	53                   	push   %ebx
  800740:	83 ec 14             	sub    $0x14,%esp
  800743:	8b 45 10             	mov    0x10(%ebp),%eax
  800746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80074f:	8b 45 18             	mov    0x18(%ebp),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80075a:	77 55                	ja     8007b1 <printnum+0x75>
  80075c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80075f:	72 05                	jb     800766 <printnum+0x2a>
  800761:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800764:	77 4b                	ja     8007b1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800766:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800769:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076c:	8b 45 18             	mov    0x18(%ebp),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
  800774:	52                   	push   %edx
  800775:	50                   	push   %eax
  800776:	ff 75 f4             	pushl  -0xc(%ebp)
  800779:	ff 75 f0             	pushl  -0x10(%ebp)
  80077c:	e8 db 33 00 00       	call   803b5c <__udivdi3>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	83 ec 04             	sub    $0x4,%esp
  800787:	ff 75 20             	pushl  0x20(%ebp)
  80078a:	53                   	push   %ebx
  80078b:	ff 75 18             	pushl  0x18(%ebp)
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	ff 75 08             	pushl  0x8(%ebp)
  800796:	e8 a1 ff ff ff       	call   80073c <printnum>
  80079b:	83 c4 20             	add    $0x20,%esp
  80079e:	eb 1a                	jmp    8007ba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	ff 75 20             	pushl  0x20(%ebp)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b1:	ff 4d 1c             	decl   0x1c(%ebp)
  8007b4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007b8:	7f e6                	jg     8007a0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	53                   	push   %ebx
  8007c9:	51                   	push   %ecx
  8007ca:	52                   	push   %edx
  8007cb:	50                   	push   %eax
  8007cc:	e8 9b 34 00 00       	call   803c6c <__umoddi3>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	05 f4 43 80 00       	add    $0x8043f4,%eax
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f be c0             	movsbl %al,%eax
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	50                   	push   %eax
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	ff d0                	call   *%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
}
  8007ed:	90                   	nop
  8007ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f1:	c9                   	leave  
  8007f2:	c3                   	ret    

008007f3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007fa:	7e 1c                	jle    800818 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	8d 50 08             	lea    0x8(%eax),%edx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	89 10                	mov    %edx,(%eax)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	83 e8 08             	sub    $0x8,%eax
  800811:	8b 50 04             	mov    0x4(%eax),%edx
  800814:	8b 00                	mov    (%eax),%eax
  800816:	eb 40                	jmp    800858 <getuint+0x65>
	else if (lflag)
  800818:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80081c:	74 1e                	je     80083c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	8d 50 04             	lea    0x4(%eax),%edx
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	89 10                	mov    %edx,(%eax)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	83 e8 04             	sub    $0x4,%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	eb 1c                	jmp    800858 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	8d 50 04             	lea    0x4(%eax),%edx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	89 10                	mov    %edx,(%eax)
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80085d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800861:	7e 1c                	jle    80087f <getint+0x25>
		return va_arg(*ap, long long);
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 10                	mov    %edx,(%eax)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 e8 08             	sub    $0x8,%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	eb 38                	jmp    8008b7 <getint+0x5d>
	else if (lflag)
  80087f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800883:	74 1a                	je     80089f <getint+0x45>
		return va_arg(*ap, long);
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	89 10                	mov    %edx,(%eax)
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	99                   	cltd   
  80089d:	eb 18                	jmp    8008b7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 50 04             	lea    0x4(%eax),%edx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 10                	mov    %edx,(%eax)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	99                   	cltd   
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
  8008be:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c1:	eb 17                	jmp    8008da <vprintfmt+0x21>
			if (ch == '\0')
  8008c3:	85 db                	test   %ebx,%ebx
  8008c5:	0f 84 c1 03 00 00    	je     800c8c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	53                   	push   %ebx
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	ff d0                	call   *%eax
  8008d7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008da:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dd:	8d 50 01             	lea    0x1(%eax),%edx
  8008e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e3:	8a 00                	mov    (%eax),%al
  8008e5:	0f b6 d8             	movzbl %al,%ebx
  8008e8:	83 fb 25             	cmp    $0x25,%ebx
  8008eb:	75 d6                	jne    8008c3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800906:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80090d:	8b 45 10             	mov    0x10(%ebp),%eax
  800910:	8d 50 01             	lea    0x1(%eax),%edx
  800913:	89 55 10             	mov    %edx,0x10(%ebp)
  800916:	8a 00                	mov    (%eax),%al
  800918:	0f b6 d8             	movzbl %al,%ebx
  80091b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80091e:	83 f8 5b             	cmp    $0x5b,%eax
  800921:	0f 87 3d 03 00 00    	ja     800c64 <vprintfmt+0x3ab>
  800927:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
  80092e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800930:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800934:	eb d7                	jmp    80090d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800936:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80093a:	eb d1                	jmp    80090d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800943:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800946:	89 d0                	mov    %edx,%eax
  800948:	c1 e0 02             	shl    $0x2,%eax
  80094b:	01 d0                	add    %edx,%eax
  80094d:	01 c0                	add    %eax,%eax
  80094f:	01 d8                	add    %ebx,%eax
  800951:	83 e8 30             	sub    $0x30,%eax
  800954:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800957:	8b 45 10             	mov    0x10(%ebp),%eax
  80095a:	8a 00                	mov    (%eax),%al
  80095c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80095f:	83 fb 2f             	cmp    $0x2f,%ebx
  800962:	7e 3e                	jle    8009a2 <vprintfmt+0xe9>
  800964:	83 fb 39             	cmp    $0x39,%ebx
  800967:	7f 39                	jg     8009a2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800969:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096c:	eb d5                	jmp    800943 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 c0 04             	add    $0x4,%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800982:	eb 1f                	jmp    8009a3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800988:	79 83                	jns    80090d <vprintfmt+0x54>
				width = 0;
  80098a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800991:	e9 77 ff ff ff       	jmp    80090d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800996:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80099d:	e9 6b ff ff ff       	jmp    80090d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a7:	0f 89 60 ff ff ff    	jns    80090d <vprintfmt+0x54>
				width = precision, precision = -1;
  8009ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ba:	e9 4e ff ff ff       	jmp    80090d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009bf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009c2:	e9 46 ff ff ff       	jmp    80090d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	83 c0 04             	add    $0x4,%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	83 e8 04             	sub    $0x4,%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	50                   	push   %eax
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
			break;
  8009e7:	e9 9b 02 00 00       	jmp    800c87 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 c0 04             	add    $0x4,%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 e8 04             	sub    $0x4,%eax
  8009fb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009fd:	85 db                	test   %ebx,%ebx
  8009ff:	79 02                	jns    800a03 <vprintfmt+0x14a>
				err = -err;
  800a01:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a03:	83 fb 64             	cmp    $0x64,%ebx
  800a06:	7f 0b                	jg     800a13 <vprintfmt+0x15a>
  800a08:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	75 19                	jne    800a2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a13:	53                   	push   %ebx
  800a14:	68 05 44 80 00       	push   $0x804405
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	ff 75 08             	pushl  0x8(%ebp)
  800a1f:	e8 70 02 00 00       	call   800c94 <printfmt>
  800a24:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a27:	e9 5b 02 00 00       	jmp    800c87 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a2c:	56                   	push   %esi
  800a2d:	68 0e 44 80 00       	push   $0x80440e
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	ff 75 08             	pushl  0x8(%ebp)
  800a38:	e8 57 02 00 00       	call   800c94 <printfmt>
  800a3d:	83 c4 10             	add    $0x10,%esp
			break;
  800a40:	e9 42 02 00 00       	jmp    800c87 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	83 e8 04             	sub    $0x4,%eax
  800a54:	8b 30                	mov    (%eax),%esi
  800a56:	85 f6                	test   %esi,%esi
  800a58:	75 05                	jne    800a5f <vprintfmt+0x1a6>
				p = "(null)";
  800a5a:	be 11 44 80 00       	mov    $0x804411,%esi
			if (width > 0 && padc != '-')
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7e 6d                	jle    800ad2 <vprintfmt+0x219>
  800a65:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a69:	74 67                	je     800ad2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	50                   	push   %eax
  800a72:	56                   	push   %esi
  800a73:	e8 1e 03 00 00       	call   800d96 <strnlen>
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a7e:	eb 16                	jmp    800a96 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a80:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a93:	ff 4d e4             	decl   -0x1c(%ebp)
  800a96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9a:	7f e4                	jg     800a80 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9c:	eb 34                	jmp    800ad2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aa2:	74 1c                	je     800ac0 <vprintfmt+0x207>
  800aa4:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa7:	7e 05                	jle    800aae <vprintfmt+0x1f5>
  800aa9:	83 fb 7e             	cmp    $0x7e,%ebx
  800aac:	7e 12                	jle    800ac0 <vprintfmt+0x207>
					putch('?', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 3f                	push   $0x3f
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	eb 0f                	jmp    800acf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	53                   	push   %ebx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800acf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad2:	89 f0                	mov    %esi,%eax
  800ad4:	8d 70 01             	lea    0x1(%eax),%esi
  800ad7:	8a 00                	mov    (%eax),%al
  800ad9:	0f be d8             	movsbl %al,%ebx
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	74 24                	je     800b04 <vprintfmt+0x24b>
  800ae0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae4:	78 b8                	js     800a9e <vprintfmt+0x1e5>
  800ae6:	ff 4d e0             	decl   -0x20(%ebp)
  800ae9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aed:	79 af                	jns    800a9e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aef:	eb 13                	jmp    800b04 <vprintfmt+0x24b>
				putch(' ', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 20                	push   $0x20
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e7                	jg     800af1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b0a:	e9 78 01 00 00       	jmp    800c87 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 e8             	pushl  -0x18(%ebp)
  800b15:	8d 45 14             	lea    0x14(%ebp),%eax
  800b18:	50                   	push   %eax
  800b19:	e8 3c fd ff ff       	call   80085a <getint>
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2d:	85 d2                	test   %edx,%edx
  800b2f:	79 23                	jns    800b54 <vprintfmt+0x29b>
				putch('-', putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	6a 2d                	push   $0x2d
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b47:	f7 d8                	neg    %eax
  800b49:	83 d2 00             	adc    $0x0,%edx
  800b4c:	f7 da                	neg    %edx
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5b:	e9 bc 00 00 00       	jmp    800c1c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 e8             	pushl  -0x18(%ebp)
  800b66:	8d 45 14             	lea    0x14(%ebp),%eax
  800b69:	50                   	push   %eax
  800b6a:	e8 84 fc ff ff       	call   8007f3 <getuint>
  800b6f:	83 c4 10             	add    $0x10,%esp
  800b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b7f:	e9 98 00 00 00       	jmp    800c1c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	6a 58                	push   $0x58
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	6a 58                	push   $0x58
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	6a 58                	push   $0x58
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	ff d0                	call   *%eax
  800bb1:	83 c4 10             	add    $0x10,%esp
			break;
  800bb4:	e9 ce 00 00 00       	jmp    800c87 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	6a 30                	push   $0x30
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	ff d0                	call   *%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	6a 78                	push   $0x78
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	ff d0                	call   *%eax
  800bd6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdc:	83 c0 04             	add    $0x4,%eax
  800bdf:	89 45 14             	mov    %eax,0x14(%ebp)
  800be2:	8b 45 14             	mov    0x14(%ebp),%eax
  800be5:	83 e8 04             	sub    $0x4,%eax
  800be8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bf4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bfb:	eb 1f                	jmp    800c1c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 e8             	pushl  -0x18(%ebp)
  800c03:	8d 45 14             	lea    0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	e8 e7 fb ff ff       	call   8007f3 <getuint>
  800c0c:	83 c4 10             	add    $0x10,%esp
  800c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c23:	83 ec 04             	sub    $0x4,%esp
  800c26:	52                   	push   %edx
  800c27:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c2a:	50                   	push   %eax
  800c2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	ff 75 08             	pushl  0x8(%ebp)
  800c37:	e8 00 fb ff ff       	call   80073c <printnum>
  800c3c:	83 c4 20             	add    $0x20,%esp
			break;
  800c3f:	eb 46                	jmp    800c87 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	53                   	push   %ebx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			break;
  800c50:	eb 35                	jmp    800c87 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c52:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800c59:	eb 2c                	jmp    800c87 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c5b:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800c62:	eb 23                	jmp    800c87 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 25                	push   $0x25
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c74:	ff 4d 10             	decl   0x10(%ebp)
  800c77:	eb 03                	jmp    800c7c <vprintfmt+0x3c3>
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	48                   	dec    %eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	3c 25                	cmp    $0x25,%al
  800c84:	75 f3                	jne    800c79 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c86:	90                   	nop
		}
	}
  800c87:	e9 35 fc ff ff       	jmp    8008c1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c8c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c9a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9d:	83 c0 04             	add    $0x4,%eax
  800ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca9:	50                   	push   %eax
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	ff 75 08             	pushl  0x8(%ebp)
  800cb0:	e8 04 fc ff ff       	call   8008b9 <vprintfmt>
  800cb5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cb8:	90                   	nop
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	8b 40 08             	mov    0x8(%eax),%eax
  800cc4:	8d 50 01             	lea    0x1(%eax),%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	8b 10                	mov    (%eax),%edx
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8b 40 04             	mov    0x4(%eax),%eax
  800cd8:	39 c2                	cmp    %eax,%edx
  800cda:	73 12                	jae    800cee <sprintputch+0x33>
		*b->buf++ = ch;
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce7:	89 0a                	mov    %ecx,(%edx)
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	88 10                	mov    %dl,(%eax)
}
  800cee:	90                   	nop
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d16:	74 06                	je     800d1e <vsnprintf+0x2d>
  800d18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1c:	7f 07                	jg     800d25 <vsnprintf+0x34>
		return -E_INVAL;
  800d1e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d23:	eb 20                	jmp    800d45 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d25:	ff 75 14             	pushl  0x14(%ebp)
  800d28:	ff 75 10             	pushl  0x10(%ebp)
  800d2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d2e:	50                   	push   %eax
  800d2f:	68 bb 0c 80 00       	push   $0x800cbb
  800d34:	e8 80 fb ff ff       	call   8008b9 <vprintfmt>
  800d39:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d3f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d4d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d50:	83 c0 04             	add    $0x4,%eax
  800d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5c:	50                   	push   %eax
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	ff 75 08             	pushl  0x8(%ebp)
  800d63:	e8 89 ff ff ff       	call   800cf1 <vsnprintf>
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d80:	eb 06                	jmp    800d88 <strlen+0x15>
		n++;
  800d82:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d85:	ff 45 08             	incl   0x8(%ebp)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	84 c0                	test   %al,%al
  800d8f:	75 f1                	jne    800d82 <strlen+0xf>
		n++;
	return n;
  800d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da3:	eb 09                	jmp    800dae <strnlen+0x18>
		n++;
  800da5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 4d 0c             	decl   0xc(%ebp)
  800dae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db2:	74 09                	je     800dbd <strnlen+0x27>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 e8                	jne    800da5 <strnlen+0xf>
		n++;
	return n;
  800dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dce:	90                   	nop
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8d 50 01             	lea    0x1(%eax),%edx
  800dd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de1:	8a 12                	mov    (%edx),%dl
  800de3:	88 10                	mov    %dl,(%eax)
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	75 e4                	jne    800dcf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e03:	eb 1f                	jmp    800e24 <strncpy+0x34>
		*dst++ = *src;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8d 50 01             	lea    0x1(%eax),%edx
  800e0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e11:	8a 12                	mov    (%edx),%dl
  800e13:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	84 c0                	test   %al,%al
  800e1c:	74 03                	je     800e21 <strncpy+0x31>
			src++;
  800e1e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e21:	ff 45 fc             	incl   -0x4(%ebp)
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2a:	72 d9                	jb     800e05 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e41:	74 30                	je     800e73 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e43:	eb 16                	jmp    800e5b <strlcpy+0x2a>
			*dst++ = *src++;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8d 50 01             	lea    0x1(%eax),%edx
  800e4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e57:	8a 12                	mov    (%edx),%dl
  800e59:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e5b:	ff 4d 10             	decl   0x10(%ebp)
  800e5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e62:	74 09                	je     800e6d <strlcpy+0x3c>
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	75 d8                	jne    800e45 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e79:	29 c2                	sub    %eax,%edx
  800e7b:	89 d0                	mov    %edx,%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e82:	eb 06                	jmp    800e8a <strcmp+0xb>
		p++, q++;
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strcmp+0x22>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 e3                	je     800e84 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 d0             	movzbl %al,%edx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f b6 c0             	movzbl %al,%eax
  800eb1:	29 c2                	sub    %eax,%edx
  800eb3:	89 d0                	mov    %edx,%eax
}
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eba:	eb 09                	jmp    800ec5 <strncmp+0xe>
		n--, p++, q++;
  800ebc:	ff 4d 10             	decl   0x10(%ebp)
  800ebf:	ff 45 08             	incl   0x8(%ebp)
  800ec2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec9:	74 17                	je     800ee2 <strncmp+0x2b>
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	84 c0                	test   %al,%al
  800ed2:	74 0e                	je     800ee2 <strncmp+0x2b>
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 10                	mov    (%eax),%dl
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	38 c2                	cmp    %al,%dl
  800ee0:	74 da                	je     800ebc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	75 07                	jne    800eef <strncmp+0x38>
		return 0;
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	eb 14                	jmp    800f03 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d0             	movzbl %al,%edx
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f b6 c0             	movzbl %al,%eax
  800eff:	29 c2                	sub    %eax,%edx
  800f01:	89 d0                	mov    %edx,%eax
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 04             	sub    $0x4,%esp
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f11:	eb 12                	jmp    800f25 <strchr+0x20>
		if (*s == c)
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f1b:	75 05                	jne    800f22 <strchr+0x1d>
			return (char *) s;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	eb 11                	jmp    800f33 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	84 c0                	test   %al,%al
  800f2c:	75 e5                	jne    800f13 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f41:	eb 0d                	jmp    800f50 <strfind+0x1b>
		if (*s == c)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f4b:	74 0e                	je     800f5b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f4d:	ff 45 08             	incl   0x8(%ebp)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	75 ea                	jne    800f43 <strfind+0xe>
  800f59:	eb 01                	jmp    800f5c <strfind+0x27>
		if (*s == c)
			break;
  800f5b:	90                   	nop
	return (char *) s;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f73:	eb 0e                	jmp    800f83 <memset+0x22>
		*p++ = c;
  800f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f78:	8d 50 01             	lea    0x1(%eax),%edx
  800f7b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f81:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f83:	ff 4d f8             	decl   -0x8(%ebp)
  800f86:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f8a:	79 e9                	jns    800f75 <memset+0x14>
		*p++ = c;

	return v;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fa3:	eb 16                	jmp    800fbb <memcpy+0x2a>
		*d++ = *s++;
  800fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa8:	8d 50 01             	lea    0x1(%eax),%edx
  800fab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb7:	8a 12                	mov    (%edx),%dl
  800fb9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	75 dd                	jne    800fa5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe5:	73 50                	jae    801037 <memmove+0x6a>
  800fe7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	01 d0                	add    %edx,%eax
  800fef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff2:	76 43                	jbe    801037 <memmove+0x6a>
		s += n;
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801000:	eb 10                	jmp    801012 <memmove+0x45>
			*--d = *--s;
  801002:	ff 4d f8             	decl   -0x8(%ebp)
  801005:	ff 4d fc             	decl   -0x4(%ebp)
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	8a 10                	mov    (%eax),%dl
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801012:	8b 45 10             	mov    0x10(%ebp),%eax
  801015:	8d 50 ff             	lea    -0x1(%eax),%edx
  801018:	89 55 10             	mov    %edx,0x10(%ebp)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	75 e3                	jne    801002 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80101f:	eb 23                	jmp    801044 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801030:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801033:	8a 12                	mov    (%edx),%dl
  801035:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103d:	89 55 10             	mov    %edx,0x10(%ebp)
  801040:	85 c0                	test   %eax,%eax
  801042:	75 dd                	jne    801021 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80105b:	eb 2a                	jmp    801087 <memcmp+0x3e>
		if (*s1 != *s2)
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	8a 10                	mov    (%eax),%dl
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	38 c2                	cmp    %al,%dl
  801069:	74 16                	je     801081 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f b6 d0             	movzbl %al,%edx
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	29 c2                	sub    %eax,%edx
  80107d:	89 d0                	mov    %edx,%eax
  80107f:	eb 18                	jmp    801099 <memcmp+0x50>
		s1++, s2++;
  801081:	ff 45 fc             	incl   -0x4(%ebp)
  801084:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 c9                	jne    80105d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010ac:	eb 15                	jmp    8010c3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f b6 d0             	movzbl %al,%edx
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	0f b6 c0             	movzbl %al,%eax
  8010bc:	39 c2                	cmp    %eax,%edx
  8010be:	74 0d                	je     8010cd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c0:	ff 45 08             	incl   0x8(%ebp)
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010c9:	72 e3                	jb     8010ae <memfind+0x13>
  8010cb:	eb 01                	jmp    8010ce <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010cd:	90                   	nop
	return (void *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e7:	eb 03                	jmp    8010ec <strtol+0x19>
		s++;
  8010e9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 20                	cmp    $0x20,%al
  8010f3:	74 f4                	je     8010e9 <strtol+0x16>
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 09                	cmp    $0x9,%al
  8010fc:	74 eb                	je     8010e9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 2b                	cmp    $0x2b,%al
  801105:	75 05                	jne    80110c <strtol+0x39>
		s++;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	eb 13                	jmp    80111f <strtol+0x4c>
	else if (*s == '-')
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 2d                	cmp    $0x2d,%al
  801113:	75 0a                	jne    80111f <strtol+0x4c>
		s++, neg = 1;
  801115:	ff 45 08             	incl   0x8(%ebp)
  801118:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80111f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801123:	74 06                	je     80112b <strtol+0x58>
  801125:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801129:	75 20                	jne    80114b <strtol+0x78>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 30                	cmp    $0x30,%al
  801132:	75 17                	jne    80114b <strtol+0x78>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	40                   	inc    %eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 78                	cmp    $0x78,%al
  80113c:	75 0d                	jne    80114b <strtol+0x78>
		s += 2, base = 16;
  80113e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801142:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801149:	eb 28                	jmp    801173 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80114b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114f:	75 15                	jne    801166 <strtol+0x93>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 30                	cmp    $0x30,%al
  801158:	75 0c                	jne    801166 <strtol+0x93>
		s++, base = 8;
  80115a:	ff 45 08             	incl   0x8(%ebp)
  80115d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801164:	eb 0d                	jmp    801173 <strtol+0xa0>
	else if (base == 0)
  801166:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116a:	75 07                	jne    801173 <strtol+0xa0>
		base = 10;
  80116c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 2f                	cmp    $0x2f,%al
  80117a:	7e 19                	jle    801195 <strtol+0xc2>
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 39                	cmp    $0x39,%al
  801183:	7f 10                	jg     801195 <strtol+0xc2>
			dig = *s - '0';
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f be c0             	movsbl %al,%eax
  80118d:	83 e8 30             	sub    $0x30,%eax
  801190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801193:	eb 42                	jmp    8011d7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 60                	cmp    $0x60,%al
  80119c:	7e 19                	jle    8011b7 <strtol+0xe4>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	3c 7a                	cmp    $0x7a,%al
  8011a5:	7f 10                	jg     8011b7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f be c0             	movsbl %al,%eax
  8011af:	83 e8 57             	sub    $0x57,%eax
  8011b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b5:	eb 20                	jmp    8011d7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 40                	cmp    $0x40,%al
  8011be:	7e 39                	jle    8011f9 <strtol+0x126>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 5a                	cmp    $0x5a,%al
  8011c7:	7f 30                	jg     8011f9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	0f be c0             	movsbl %al,%eax
  8011d1:	83 e8 37             	sub    $0x37,%eax
  8011d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011dd:	7d 19                	jge    8011f8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ee:	01 d0                	add    %edx,%eax
  8011f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f3:	e9 7b ff ff ff       	jmp    801173 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011f8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fd:	74 08                	je     801207 <strtol+0x134>
		*endptr = (char *) s;
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	8b 55 08             	mov    0x8(%ebp),%edx
  801205:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801207:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120b:	74 07                	je     801214 <strtol+0x141>
  80120d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801210:	f7 d8                	neg    %eax
  801212:	eb 03                	jmp    801217 <strtol+0x144>
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <ltostr>:

void
ltostr(long value, char *str)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80121f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801226:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80122d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801231:	79 13                	jns    801246 <ltostr+0x2d>
	{
		neg = 1;
  801233:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801240:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801243:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80124e:	99                   	cltd   
  80124f:	f7 f9                	idiv   %ecx
  801251:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801254:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	83 c2 30             	add    $0x30,%edx
  80126a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80126c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801274:	f7 e9                	imul   %ecx
  801276:	c1 fa 02             	sar    $0x2,%edx
  801279:	89 c8                	mov    %ecx,%eax
  80127b:	c1 f8 1f             	sar    $0x1f,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
  801282:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801289:	75 bb                	jne    801246 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80128b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801295:	48                   	dec    %eax
  801296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801299:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129d:	74 3d                	je     8012dc <ltostr+0xc3>
		start = 1 ;
  80129f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012a6:	eb 34                	jmp    8012dc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c3:	01 c8                	add    %ecx,%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8012d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e2:	7c c4                	jl     8012a8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012f8:	ff 75 08             	pushl  0x8(%ebp)
  8012fb:	e8 73 fa ff ff       	call   800d73 <strlen>
  801300:	83 c4 04             	add    $0x4,%esp
  801303:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	e8 65 fa ff ff       	call   800d73 <strlen>
  80130e:	83 c4 04             	add    $0x4,%esp
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801322:	eb 17                	jmp    80133b <strcconcat+0x49>
		final[s] = str1[s] ;
  801324:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 c2                	add    %eax,%edx
  80132c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	01 c8                	add    %ecx,%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801338:	ff 45 fc             	incl   -0x4(%ebp)
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801341:	7c e1                	jl     801324 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801343:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80134a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801351:	eb 1f                	jmp    801372 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801353:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801356:	8d 50 01             	lea    0x1(%eax),%edx
  801359:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80135c:	89 c2                	mov    %eax,%edx
  80135e:	8b 45 10             	mov    0x10(%ebp),%eax
  801361:	01 c2                	add    %eax,%edx
  801363:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	01 c8                	add    %ecx,%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80136f:	ff 45 f8             	incl   -0x8(%ebp)
  801372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801375:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801378:	7c d9                	jl     801353 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80137a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137d:	8b 45 10             	mov    0x10(%ebp),%eax
  801380:	01 d0                	add    %edx,%eax
  801382:	c6 00 00             	movb   $0x0,(%eax)
}
  801385:	90                   	nop
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80138b:	8b 45 14             	mov    0x14(%ebp),%eax
  80138e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ab:	eb 0c                	jmp    8013b9 <strsplit+0x31>
			*string++ = 0;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8d 50 01             	lea    0x1(%eax),%edx
  8013b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	84 c0                	test   %al,%al
  8013c0:	74 18                	je     8013da <strsplit+0x52>
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	0f be c0             	movsbl %al,%eax
  8013ca:	50                   	push   %eax
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	e8 32 fb ff ff       	call   800f05 <strchr>
  8013d3:	83 c4 08             	add    $0x8,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	75 d3                	jne    8013ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 5a                	je     80143d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	83 f8 0f             	cmp    $0xf,%eax
  8013eb:	75 07                	jne    8013f4 <strsplit+0x6c>
		{
			return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb 66                	jmp    80145a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ff:	89 0a                	mov    %ecx,(%edx)
  801401:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801408:	8b 45 10             	mov    0x10(%ebp),%eax
  80140b:	01 c2                	add    %eax,%edx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801412:	eb 03                	jmp    801417 <strsplit+0x8f>
			string++;
  801414:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	84 c0                	test   %al,%al
  80141e:	74 8b                	je     8013ab <strsplit+0x23>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f be c0             	movsbl %al,%eax
  801428:	50                   	push   %eax
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	e8 d4 fa ff ff       	call   800f05 <strchr>
  801431:	83 c4 08             	add    $0x8,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	74 dc                	je     801414 <strsplit+0x8c>
			string++;
	}
  801438:	e9 6e ff ff ff       	jmp    8013ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80143d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	8b 00                	mov    (%eax),%eax
  801443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801455:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 88 45 80 00       	push   $0x804588
  80146a:	68 3f 01 00 00       	push   $0x13f
  80146f:	68 aa 45 80 00       	push   $0x8045aa
  801474:	e8 a9 ef ff ff       	call   800422 <_panic>

00801479 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 e5 0b 00 00       	call   80206f <sys_sbrk>
  80148a:	83 c4 10             	add    $0x10,%esp
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801495:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801499:	75 0a                	jne    8014a5 <malloc+0x16>
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a0:	e9 07 02 00 00       	jmp    8016ac <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8014a5:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8014ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8014af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b2:	01 d0                	add    %edx,%eax
  8014b4:	48                   	dec    %eax
  8014b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c0:	f7 75 dc             	divl   -0x24(%ebp)
  8014c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c6:	29 d0                	sub    %edx,%eax
  8014c8:	c1 e8 0c             	shr    $0xc,%eax
  8014cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8014ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8014d3:	8b 40 78             	mov    0x78(%eax),%eax
  8014d6:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8014db:	29 c2                	sub    %eax,%edx
  8014dd:	89 d0                	mov    %edx,%eax
  8014df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ea:	c1 e8 0c             	shr    $0xc,%eax
  8014ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8014f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8014f7:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014fe:	77 42                	ja     801542 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801500:	e8 ee 09 00 00       	call   801ef3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 2e 0f 00 00       	call   802442 <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 00 0a 00 00       	call   801f24 <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 c7 13 00 00       	call   8028fe <alloc_block_BF>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153d:	e9 67 01 00 00       	jmp    8016a9 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801542:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801545:	48                   	dec    %eax
  801546:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801549:	0f 86 53 01 00 00    	jbe    8016a2 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80154f:	a1 20 50 80 00       	mov    0x805020,%eax
  801554:	8b 40 78             	mov    0x78(%eax),%eax
  801557:	05 00 10 00 00       	add    $0x1000,%eax
  80155c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80155f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801566:	e9 de 00 00 00       	jmp    801649 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80156b:	a1 20 50 80 00       	mov    0x805020,%eax
  801570:	8b 40 78             	mov    0x78(%eax),%eax
  801573:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801576:	29 c2                	sub    %eax,%edx
  801578:	89 d0                	mov    %edx,%eax
  80157a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80157f:	c1 e8 0c             	shr    $0xc,%eax
  801582:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801589:	85 c0                	test   %eax,%eax
  80158b:	0f 85 ab 00 00 00    	jne    80163c <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801594:	05 00 10 00 00       	add    $0x1000,%eax
  801599:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80159c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8015a3:	eb 47                	jmp    8015ec <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8015a5:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8015ac:	76 0a                	jbe    8015b8 <malloc+0x129>
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	e9 f4 00 00 00       	jmp    8016ac <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8015b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8015bd:	8b 40 78             	mov    0x78(%eax),%eax
  8015c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015c3:	29 c2                	sub    %eax,%edx
  8015c5:	89 d0                	mov    %edx,%eax
  8015c7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015cc:	c1 e8 0c             	shr    $0xc,%eax
  8015cf:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 08                	je     8015e2 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8015da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8015e0:	eb 5a                	jmp    80163c <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8015e2:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8015e9:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8015ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015ef:	48                   	dec    %eax
  8015f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f3:	77 b0                	ja     8015a5 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8015f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8015fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801603:	eb 2f                	jmp    801634 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801608:	c1 e0 0c             	shl    $0xc,%eax
  80160b:	89 c2                	mov    %eax,%edx
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	01 c2                	add    %eax,%edx
  801612:	a1 20 50 80 00       	mov    0x805020,%eax
  801617:	8b 40 78             	mov    0x78(%eax),%eax
  80161a:	29 c2                	sub    %eax,%edx
  80161c:	89 d0                	mov    %edx,%eax
  80161e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801623:	c1 e8 0c             	shr    $0xc,%eax
  801626:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
  80162d:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801631:	ff 45 e0             	incl   -0x20(%ebp)
  801634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801637:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80163a:	72 c9                	jb     801605 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80163c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801640:	75 16                	jne    801658 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801642:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801649:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801650:	0f 86 15 ff ff ff    	jbe    80156b <malloc+0xdc>
  801656:	eb 01                	jmp    801659 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801658:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801659:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80165d:	75 07                	jne    801666 <malloc+0x1d7>
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
  801664:	eb 46                	jmp    8016ac <malloc+0x21d>
		ptr = (void*)i;
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80166c:	a1 20 50 80 00       	mov    0x805020,%eax
  801671:	8b 40 78             	mov    0x78(%eax),%eax
  801674:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801677:	29 c2                	sub    %eax,%edx
  801679:	89 d0                	mov    %edx,%eax
  80167b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801680:	c1 e8 0c             	shr    $0xc,%eax
  801683:	89 c2                	mov    %eax,%edx
  801685:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801688:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	e8 09 0a 00 00       	call   8020a6 <sys_allocate_user_mem>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	eb 07                	jmp    8016a9 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a7:	eb 03                	jmp    8016ac <malloc+0x21d>
	}
	return ptr;
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8016b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8016b9:	8b 40 78             	mov    0x78(%eax),%eax
  8016bc:	05 00 10 00 00       	add    $0x1000,%eax
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8016c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8016cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8016d0:	8b 50 78             	mov    0x78(%eax),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	39 c2                	cmp    %eax,%edx
  8016d8:	76 24                	jbe    8016fe <free+0x50>
		size = get_block_size(va);
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 dd 09 00 00       	call   8020c2 <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 10 1c 00 00       	call   803306 <free_block>
  8016f6:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8016f9:	e9 ac 00 00 00       	jmp    8017aa <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801704:	0f 82 89 00 00 00    	jb     801793 <free+0xe5>
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801712:	77 7f                	ja     801793 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801714:	8b 55 08             	mov    0x8(%ebp),%edx
  801717:	a1 20 50 80 00       	mov    0x805020,%eax
  80171c:	8b 40 78             	mov    0x78(%eax),%eax
  80171f:	29 c2                	sub    %eax,%edx
  801721:	89 d0                	mov    %edx,%eax
  801723:	2d 00 10 00 00       	sub    $0x1000,%eax
  801728:	c1 e8 0c             	shr    $0xc,%eax
  80172b:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801732:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801738:	c1 e0 0c             	shl    $0xc,%eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80173e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801745:	eb 42                	jmp    801789 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174a:	c1 e0 0c             	shl    $0xc,%eax
  80174d:	89 c2                	mov    %eax,%edx
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	01 c2                	add    %eax,%edx
  801754:	a1 20 50 80 00       	mov    0x805020,%eax
  801759:	8b 40 78             	mov    0x78(%eax),%eax
  80175c:	29 c2                	sub    %eax,%edx
  80175e:	89 d0                	mov    %edx,%eax
  801760:	2d 00 10 00 00       	sub    $0x1000,%eax
  801765:	c1 e8 0c             	shr    $0xc,%eax
  801768:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  80176f:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	83 ec 08             	sub    $0x8,%esp
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	e8 07 09 00 00       	call   80208a <sys_free_user_mem>
  801783:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801786:	ff 45 f4             	incl   -0xc(%ebp)
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80178f:	72 b6                	jb     801747 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801791:	eb 17                	jmp    8017aa <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 b8 45 80 00       	push   $0x8045b8
  80179b:	68 88 00 00 00       	push   $0x88
  8017a0:	68 e2 45 80 00       	push   $0x8045e2
  8017a5:	e8 78 ec ff ff       	call   800422 <_panic>
	}
}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 28             	sub    $0x28,%esp
  8017b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8017b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017bd:	75 0a                	jne    8017c9 <smalloc+0x1c>
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	e9 ec 00 00 00       	jmp    8018b5 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dc:	39 d0                	cmp    %edx,%eax
  8017de:	73 02                	jae    8017e2 <smalloc+0x35>
  8017e0:	89 d0                	mov    %edx,%eax
  8017e2:	83 ec 0c             	sub    $0xc,%esp
  8017e5:	50                   	push   %eax
  8017e6:	e8 a4 fc ff ff       	call   80148f <malloc>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f5:	75 0a                	jne    801801 <smalloc+0x54>
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	e9 b4 00 00 00       	jmp    8018b5 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801801:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801805:	ff 75 ec             	pushl  -0x14(%ebp)
  801808:	50                   	push   %eax
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	e8 7d 04 00 00       	call   801c91 <sys_createSharedObject>
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80181a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80181e:	74 06                	je     801826 <smalloc+0x79>
  801820:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801824:	75 0a                	jne    801830 <smalloc+0x83>
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
  80182b:	e9 85 00 00 00       	jmp    8018b5 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	ff 75 ec             	pushl  -0x14(%ebp)
  801836:	68 ee 45 80 00       	push   $0x8045ee
  80183b:	e8 9f ee ff ff       	call   8006df <cprintf>
  801840:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801843:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801846:	a1 20 50 80 00       	mov    0x805020,%eax
  80184b:	8b 40 78             	mov    0x78(%eax),%eax
  80184e:	29 c2                	sub    %eax,%edx
  801850:	89 d0                	mov    %edx,%eax
  801852:	2d 00 10 00 00       	sub    $0x1000,%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801860:	42                   	inc    %edx
  801861:	89 15 24 50 80 00    	mov    %edx,0x805024
  801867:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80186d:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801874:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801877:	a1 20 50 80 00       	mov    0x805020,%eax
  80187c:	8b 40 78             	mov    0x78(%eax),%eax
  80187f:	29 c2                	sub    %eax,%edx
  801881:	89 d0                	mov    %edx,%eax
  801883:	2d 00 10 00 00       	sub    $0x1000,%eax
  801888:	c1 e8 0c             	shr    $0xc,%eax
  80188b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801892:	a1 20 50 80 00       	mov    0x805020,%eax
  801897:	8b 50 10             	mov    0x10(%eax),%edx
  80189a:	89 c8                	mov    %ecx,%eax
  80189c:	c1 e0 02             	shl    $0x2,%eax
  80189f:	89 c1                	mov    %eax,%ecx
  8018a1:	c1 e1 09             	shl    $0x9,%ecx
  8018a4:	01 c8                	add    %ecx,%eax
  8018a6:	01 c2                	add    %eax,%edx
  8018a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ab:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8018b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	e8 f0 03 00 00       	call   801cbb <sys_getSizeOfSharedObject>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018d1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018d5:	75 0a                	jne    8018e1 <sget+0x2a>
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	e9 e7 00 00 00       	jmp    8019c8 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018e7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f4:	39 d0                	cmp    %edx,%eax
  8018f6:	73 02                	jae    8018fa <sget+0x43>
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	83 ec 0c             	sub    $0xc,%esp
  8018fd:	50                   	push   %eax
  8018fe:	e8 8c fb ff ff       	call   80148f <malloc>
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801909:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80190d:	75 0a                	jne    801919 <sget+0x62>
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	e9 af 00 00 00       	jmp    8019c8 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	ff 75 e8             	pushl  -0x18(%ebp)
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 ae 03 00 00       	call   801cd8 <sys_getSharedObject>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801930:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801933:	a1 20 50 80 00       	mov    0x805020,%eax
  801938:	8b 40 78             	mov    0x78(%eax),%eax
  80193b:	29 c2                	sub    %eax,%edx
  80193d:	89 d0                	mov    %edx,%eax
  80193f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801944:	c1 e8 0c             	shr    $0xc,%eax
  801947:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80194d:	42                   	inc    %edx
  80194e:	89 15 24 50 80 00    	mov    %edx,0x805024
  801954:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80195a:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801961:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801964:	a1 20 50 80 00       	mov    0x805020,%eax
  801969:	8b 40 78             	mov    0x78(%eax),%eax
  80196c:	29 c2                	sub    %eax,%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	2d 00 10 00 00       	sub    $0x1000,%eax
  801975:	c1 e8 0c             	shr    $0xc,%eax
  801978:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80197f:	a1 20 50 80 00       	mov    0x805020,%eax
  801984:	8b 50 10             	mov    0x10(%eax),%edx
  801987:	89 c8                	mov    %ecx,%eax
  801989:	c1 e0 02             	shl    $0x2,%eax
  80198c:	89 c1                	mov    %eax,%ecx
  80198e:	c1 e1 09             	shl    $0x9,%ecx
  801991:	01 c8                	add    %ecx,%eax
  801993:	01 c2                	add    %eax,%edx
  801995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801998:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80199f:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a4:	8b 40 10             	mov    0x10(%eax),%eax
  8019a7:	83 ec 08             	sub    $0x8,%esp
  8019aa:	50                   	push   %eax
  8019ab:	68 fd 45 80 00       	push   $0x8045fd
  8019b0:	e8 2a ed ff ff       	call   8006df <cprintf>
  8019b5:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019b8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019bc:	75 07                	jne    8019c5 <sget+0x10e>
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	eb 03                	jmp    8019c8 <sget+0x111>
	return ptr;
  8019c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  8019d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8019d8:	8b 40 78             	mov    0x78(%eax),%eax
  8019db:	29 c2                	sub    %eax,%edx
  8019dd:	89 d0                	mov    %edx,%eax
  8019df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019e4:	c1 e8 0c             	shr    $0xc,%eax
  8019e7:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8019f3:	8b 50 10             	mov    0x10(%eax),%edx
  8019f6:	89 c8                	mov    %ecx,%eax
  8019f8:	c1 e0 02             	shl    $0x2,%eax
  8019fb:	89 c1                	mov    %eax,%ecx
  8019fd:	c1 e1 09             	shl    $0x9,%ecx
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	01 d0                	add    %edx,%eax
  801a04:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a0e:	83 ec 08             	sub    $0x8,%esp
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	e8 db 02 00 00       	call   801cf7 <sys_freeSharedObject>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	68 0c 46 80 00       	push   $0x80460c
  801a33:	68 e5 00 00 00       	push   $0xe5
  801a38:	68 e2 45 80 00       	push   $0x8045e2
  801a3d:	e8 e0 e9 ff ff       	call   800422 <_panic>

00801a42 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	68 32 46 80 00       	push   $0x804632
  801a50:	68 f1 00 00 00       	push   $0xf1
  801a55:	68 e2 45 80 00       	push   $0x8045e2
  801a5a:	e8 c3 e9 ff ff       	call   800422 <_panic>

00801a5f <shrink>:

}
void shrink(uint32 newSize)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	68 32 46 80 00       	push   $0x804632
  801a6d:	68 f6 00 00 00       	push   $0xf6
  801a72:	68 e2 45 80 00       	push   $0x8045e2
  801a77:	e8 a6 e9 ff ff       	call   800422 <_panic>

00801a7c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	68 32 46 80 00       	push   $0x804632
  801a8a:	68 fb 00 00 00       	push   $0xfb
  801a8f:	68 e2 45 80 00       	push   $0x8045e2
  801a94:	e8 89 e9 ff ff       	call   800422 <_panic>

00801a99 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	57                   	push   %edi
  801a9d:	56                   	push   %esi
  801a9e:	53                   	push   %ebx
  801a9f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aae:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ab1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ab4:	cd 30                	int    $0x30
  801ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    

00801ac4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ad0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	52                   	push   %edx
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	50                   	push   %eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	e8 b2 ff ff ff       	call   801a99 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_cgetc>:

int
sys_cgetc(void)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 02                	push   $0x2
  801afc:	e8 98 ff ff ff       	call   801a99 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 03                	push   $0x3
  801b15:	e8 7f ff ff ff       	call   801a99 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 04                	push   $0x4
  801b2f:	e8 65 ff ff ff       	call   801a99 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	52                   	push   %edx
  801b4a:	50                   	push   %eax
  801b4b:	6a 08                	push   $0x8
  801b4d:	e8 47 ff ff ff       	call   801a99 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b5c:	8b 75 18             	mov    0x18(%ebp),%esi
  801b5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	51                   	push   %ecx
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 09                	push   $0x9
  801b72:	e8 22 ff ff ff       	call   801a99 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    

00801b81 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 0a                	push   $0xa
  801b94:	e8 00 ff ff ff       	call   801a99 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	6a 0b                	push   $0xb
  801baf:	e8 e5 fe ff ff       	call   801a99 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 0c                	push   $0xc
  801bc8:	e8 cc fe ff ff       	call   801a99 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 0d                	push   $0xd
  801be1:	e8 b3 fe ff ff       	call   801a99 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 0e                	push   $0xe
  801bfa:	e8 9a fe ff ff       	call   801a99 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 0f                	push   $0xf
  801c13:	e8 81 fe ff ff       	call   801a99 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	6a 10                	push   $0x10
  801c2d:	e8 67 fe ff ff       	call   801a99 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 11                	push   $0x11
  801c46:	e8 4e fe ff ff       	call   801a99 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	90                   	nop
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c5d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	50                   	push   %eax
  801c6a:	6a 01                	push   $0x1
  801c6c:	e8 28 fe ff ff       	call   801a99 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	90                   	nop
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 14                	push   $0x14
  801c86:	e8 0e fe ff ff       	call   801a99 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c9d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	51                   	push   %ecx
  801caa:	52                   	push   %edx
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	50                   	push   %eax
  801caf:	6a 15                	push   $0x15
  801cb1:	e8 e3 fd ff ff       	call   801a99 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	6a 16                	push   $0x16
  801cce:	e8 c6 fd ff ff       	call   801a99 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	51                   	push   %ecx
  801ce9:	52                   	push   %edx
  801cea:	50                   	push   %eax
  801ceb:	6a 17                	push   $0x17
  801ced:	e8 a7 fd ff ff       	call   801a99 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	6a 18                	push   $0x18
  801d0a:	e8 8a fd ff ff       	call   801a99 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	ff 75 14             	pushl  0x14(%ebp)
  801d1f:	ff 75 10             	pushl  0x10(%ebp)
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	50                   	push   %eax
  801d26:	6a 19                	push   $0x19
  801d28:	e8 6c fd ff ff       	call   801a99 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	50                   	push   %eax
  801d41:	6a 1a                	push   $0x1a
  801d43:	e8 51 fd ff ff       	call   801a99 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	90                   	nop
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	50                   	push   %eax
  801d5d:	6a 1b                	push   $0x1b
  801d5f:	e8 35 fd ff ff       	call   801a99 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 05                	push   $0x5
  801d78:	e8 1c fd ff ff       	call   801a99 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 06                	push   $0x6
  801d91:	e8 03 fd ff ff       	call   801a99 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 07                	push   $0x7
  801daa:	e8 ea fc ff ff       	call   801a99 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_exit_env>:


void sys_exit_env(void)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 1c                	push   $0x1c
  801dc3:	e8 d1 fc ff ff       	call   801a99 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	90                   	nop
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dd4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd7:	8d 50 04             	lea    0x4(%eax),%edx
  801dda:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 1d                	push   $0x1d
  801de7:	e8 ad fc ff ff       	call   801a99 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
	return result;
  801def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801df8:	89 01                	mov    %eax,(%ecx)
  801dfa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	c9                   	leave  
  801e01:	c2 04 00             	ret    $0x4

00801e04 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 10             	pushl  0x10(%ebp)
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	6a 13                	push   $0x13
  801e16:	e8 7e fc ff ff       	call   801a99 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 1e                	push   $0x1e
  801e30:	e8 64 fc ff ff       	call   801a99 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e46:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	50                   	push   %eax
  801e53:	6a 1f                	push   $0x1f
  801e55:	e8 3f fc ff ff       	call   801a99 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5d:	90                   	nop
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <rsttst>:
void rsttst()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 21                	push   $0x21
  801e6f:	e8 25 fc ff ff       	call   801a99 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return ;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	8b 45 14             	mov    0x14(%ebp),%eax
  801e83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e86:	8b 55 18             	mov    0x18(%ebp),%edx
  801e89:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	ff 75 10             	pushl  0x10(%ebp)
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	ff 75 08             	pushl  0x8(%ebp)
  801e98:	6a 20                	push   $0x20
  801e9a:	e8 fa fb ff ff       	call   801a99 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea2:	90                   	nop
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <chktst>:
void chktst(uint32 n)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	ff 75 08             	pushl  0x8(%ebp)
  801eb3:	6a 22                	push   $0x22
  801eb5:	e8 df fb ff ff       	call   801a99 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebd:	90                   	nop
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <inctst>:

void inctst()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 23                	push   $0x23
  801ecf:	e8 c5 fb ff ff       	call   801a99 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed7:	90                   	nop
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <gettst>:
uint32 gettst()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 24                	push   $0x24
  801ee9:	e8 ab fb ff ff       	call   801a99 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 25                	push   $0x25
  801f05:	e8 8f fb ff ff       	call   801a99 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
  801f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f10:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f14:	75 07                	jne    801f1d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f16:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1b:	eb 05                	jmp    801f22 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 25                	push   $0x25
  801f36:	e8 5e fb ff ff       	call   801a99 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
  801f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f41:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f45:	75 07                	jne    801f4e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f47:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4c:	eb 05                	jmp    801f53 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 25                	push   $0x25
  801f67:	e8 2d fb ff ff       	call   801a99 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
  801f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f72:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f76:	75 07                	jne    801f7f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f78:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7d:	eb 05                	jmp    801f84 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 25                	push   $0x25
  801f98:	e8 fc fa ff ff       	call   801a99 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
  801fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fa3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fa7:	75 07                	jne    801fb0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	eb 05                	jmp    801fb5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	6a 26                	push   $0x26
  801fc7:	e8 cd fa ff ff       	call   801a99 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcf:	90                   	nop
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fd6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	53                   	push   %ebx
  801fe5:	51                   	push   %ecx
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 27                	push   $0x27
  801fea:	e8 aa fa ff ff       	call   801a99 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	52                   	push   %edx
  802007:	50                   	push   %eax
  802008:	6a 28                	push   $0x28
  80200a:	e8 8a fa ff ff       	call   801a99 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802017:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80201a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	51                   	push   %ecx
  802023:	ff 75 10             	pushl  0x10(%ebp)
  802026:	52                   	push   %edx
  802027:	50                   	push   %eax
  802028:	6a 29                	push   $0x29
  80202a:	e8 6a fa ff ff       	call   801a99 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 10             	pushl  0x10(%ebp)
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	6a 12                	push   $0x12
  802046:	e8 4e fa ff ff       	call   801a99 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
	return ;
  80204e:	90                   	nop
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802054:	8b 55 0c             	mov    0xc(%ebp),%edx
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	6a 2a                	push   $0x2a
  802064:	e8 30 fa ff ff       	call   801a99 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
	return;
  80206c:	90                   	nop
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	50                   	push   %eax
  80207e:	6a 2b                	push   $0x2b
  802080:	e8 14 fa ff ff       	call   801a99 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	ff 75 08             	pushl  0x8(%ebp)
  802099:	6a 2c                	push   $0x2c
  80209b:	e8 f9 f9 ff ff       	call   801a99 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
	return;
  8020a3:	90                   	nop
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	6a 2d                	push   $0x2d
  8020b7:	e8 dd f9 ff ff       	call   801a99 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
	return;
  8020bf:	90                   	nop
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	83 e8 04             	sub    $0x4,%eax
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	83 e8 04             	sub    $0x4,%eax
  8020e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	83 e0 01             	and    $0x1,%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	0f 94 c0             	sete   %al
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802106:	8b 45 0c             	mov    0xc(%ebp),%eax
  802109:	83 f8 02             	cmp    $0x2,%eax
  80210c:	74 2b                	je     802139 <alloc_block+0x40>
  80210e:	83 f8 02             	cmp    $0x2,%eax
  802111:	7f 07                	jg     80211a <alloc_block+0x21>
  802113:	83 f8 01             	cmp    $0x1,%eax
  802116:	74 0e                	je     802126 <alloc_block+0x2d>
  802118:	eb 58                	jmp    802172 <alloc_block+0x79>
  80211a:	83 f8 03             	cmp    $0x3,%eax
  80211d:	74 2d                	je     80214c <alloc_block+0x53>
  80211f:	83 f8 04             	cmp    $0x4,%eax
  802122:	74 3b                	je     80215f <alloc_block+0x66>
  802124:	eb 4c                	jmp    802172 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	e8 11 03 00 00       	call   802442 <alloc_block_FF>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802137:	eb 4a                	jmp    802183 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	e8 fa 19 00 00       	call   803b3e <alloc_block_NF>
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80214a:	eb 37                	jmp    802183 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	ff 75 08             	pushl  0x8(%ebp)
  802152:	e8 a7 07 00 00       	call   8028fe <alloc_block_BF>
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80215d:	eb 24                	jmp    802183 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	e8 b7 19 00 00       	call   803b21 <alloc_block_WF>
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802170:	eb 11                	jmp    802183 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802172:	83 ec 0c             	sub    $0xc,%esp
  802175:	68 44 46 80 00       	push   $0x804644
  80217a:	e8 60 e5 ff ff       	call   8006df <cprintf>
  80217f:	83 c4 10             	add    $0x10,%esp
		break;
  802182:	90                   	nop
	}
	return va;
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	53                   	push   %ebx
  80218c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	68 64 46 80 00       	push   $0x804664
  802197:	e8 43 e5 ff ff       	call   8006df <cprintf>
  80219c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80219f:	83 ec 0c             	sub    $0xc,%esp
  8021a2:	68 8f 46 80 00       	push   $0x80468f
  8021a7:	e8 33 e5 ff ff       	call   8006df <cprintf>
  8021ac:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b5:	eb 37                	jmp    8021ee <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bd:	e8 19 ff ff ff       	call   8020db <is_free_block>
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	0f be d8             	movsbl %al,%ebx
  8021c8:	83 ec 0c             	sub    $0xc,%esp
  8021cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ce:	e8 ef fe ff ff       	call   8020c2 <get_block_size>
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	53                   	push   %ebx
  8021da:	50                   	push   %eax
  8021db:	68 a7 46 80 00       	push   $0x8046a7
  8021e0:	e8 fa e4 ff ff       	call   8006df <cprintf>
  8021e5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f2:	74 07                	je     8021fb <print_blocks_list+0x73>
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	eb 05                	jmp    802200 <print_blocks_list+0x78>
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	89 45 10             	mov    %eax,0x10(%ebp)
  802203:	8b 45 10             	mov    0x10(%ebp),%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	75 ad                	jne    8021b7 <print_blocks_list+0x2f>
  80220a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220e:	75 a7                	jne    8021b7 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	68 64 46 80 00       	push   $0x804664
  802218:	e8 c2 e4 ff ff       	call   8006df <cprintf>
  80221d:	83 c4 10             	add    $0x10,%esp

}
  802220:	90                   	nop
  802221:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	83 e0 01             	and    $0x1,%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 03                	je     802239 <initialize_dynamic_allocator+0x13>
  802236:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802239:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80223d:	0f 84 c7 01 00 00    	je     80240a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802243:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80224a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80224d:	8b 55 08             	mov    0x8(%ebp),%edx
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	01 d0                	add    %edx,%eax
  802255:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80225a:	0f 87 ad 01 00 00    	ja     80240d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	0f 89 a5 01 00 00    	jns    802410 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	83 e8 04             	sub    $0x4,%eax
  802276:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80227b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802282:	a1 30 50 80 00       	mov    0x805030,%eax
  802287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228a:	e9 87 00 00 00       	jmp    802316 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80228f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802293:	75 14                	jne    8022a9 <initialize_dynamic_allocator+0x83>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 bf 46 80 00       	push   $0x8046bf
  80229d:	6a 79                	push   $0x79
  80229f:	68 dd 46 80 00       	push   $0x8046dd
  8022a4:	e8 79 e1 ff ff       	call   800422 <_panic>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 10                	je     8022c2 <initialize_dynamic_allocator+0x9c>
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ba:	8b 52 04             	mov    0x4(%edx),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	eb 0b                	jmp    8022cd <initialize_dynamic_allocator+0xa7>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 0f                	je     8022e6 <initialize_dynamic_allocator+0xc0>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 04             	mov    0x4(%eax),%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	8b 12                	mov    (%edx),%edx
  8022e2:	89 10                	mov    %edx,(%eax)
  8022e4:	eb 0a                	jmp    8022f0 <initialize_dynamic_allocator+0xca>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802303:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802308:	48                   	dec    %eax
  802309:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80230e:	a1 38 50 80 00       	mov    0x805038,%eax
  802313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	74 07                	je     802323 <initialize_dynamic_allocator+0xfd>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	eb 05                	jmp    802328 <initialize_dynamic_allocator+0x102>
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	a3 38 50 80 00       	mov    %eax,0x805038
  80232d:	a1 38 50 80 00       	mov    0x805038,%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	0f 85 55 ff ff ff    	jne    80228f <initialize_dynamic_allocator+0x69>
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	0f 85 4b ff ff ff    	jne    80228f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80234a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802353:	a1 48 50 80 00       	mov    0x805048,%eax
  802358:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80235d:	a1 44 50 80 00       	mov    0x805044,%eax
  802362:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	83 c0 08             	add    $0x8,%eax
  80236e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	83 c0 04             	add    $0x4,%eax
  802377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237a:	83 ea 08             	sub    $0x8,%edx
  80237d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80237f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	01 d0                	add    %edx,%eax
  802387:	83 e8 08             	sub    $0x8,%eax
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	83 ea 08             	sub    $0x8,%edx
  802390:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80239b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023a9:	75 17                	jne    8023c2 <initialize_dynamic_allocator+0x19c>
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	68 f8 46 80 00       	push   $0x8046f8
  8023b3:	68 90 00 00 00       	push   $0x90
  8023b8:	68 dd 46 80 00       	push   $0x8046dd
  8023bd:	e8 60 e0 ff ff       	call   800422 <_panic>
  8023c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cb:	89 10                	mov    %edx,(%eax)
  8023cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0d                	je     8023e3 <initialize_dynamic_allocator+0x1bd>
  8023d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8023db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023de:	89 50 04             	mov    %edx,0x4(%eax)
  8023e1:	eb 08                	jmp    8023eb <initialize_dynamic_allocator+0x1c5>
  8023e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8023eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802402:	40                   	inc    %eax
  802403:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802408:	eb 07                	jmp    802411 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80240a:	90                   	nop
  80240b:	eb 04                	jmp    802411 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80240d:	90                   	nop
  80240e:	eb 01                	jmp    802411 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802410:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802416:	8b 45 10             	mov    0x10(%ebp),%eax
  802419:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802422:	8b 45 0c             	mov    0xc(%ebp),%eax
  802425:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	83 e8 04             	sub    $0x4,%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	83 e0 fe             	and    $0xfffffffe,%eax
  802432:	8d 50 f8             	lea    -0x8(%eax),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	01 c2                	add    %eax,%edx
  80243a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243d:	89 02                	mov    %eax,(%edx)
}
  80243f:	90                   	nop
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	83 e0 01             	and    $0x1,%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 03                	je     802455 <alloc_block_FF+0x13>
  802452:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802455:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802459:	77 07                	ja     802462 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80245b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802462:	a1 28 50 80 00       	mov    0x805028,%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	75 73                	jne    8024de <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	83 c0 10             	add    $0x10,%eax
  802471:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802474:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80247b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80247e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802481:	01 d0                	add    %edx,%eax
  802483:	48                   	dec    %eax
  802484:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248a:	ba 00 00 00 00       	mov    $0x0,%edx
  80248f:	f7 75 ec             	divl   -0x14(%ebp)
  802492:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802495:	29 d0                	sub    %edx,%eax
  802497:	c1 e8 0c             	shr    $0xc,%eax
  80249a:	83 ec 0c             	sub    $0xc,%esp
  80249d:	50                   	push   %eax
  80249e:	e8 d6 ef ff ff       	call   801479 <sbrk>
  8024a3:	83 c4 10             	add    $0x10,%esp
  8024a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024a9:	83 ec 0c             	sub    $0xc,%esp
  8024ac:	6a 00                	push   $0x0
  8024ae:	e8 c6 ef ff ff       	call   801479 <sbrk>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024bc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024bf:	83 ec 08             	sub    $0x8,%esp
  8024c2:	50                   	push   %eax
  8024c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024c6:	e8 5b fd ff ff       	call   802226 <initialize_dynamic_allocator>
  8024cb:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	68 1b 47 80 00       	push   $0x80471b
  8024d6:	e8 04 e2 ff ff       	call   8006df <cprintf>
  8024db:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e2:	75 0a                	jne    8024ee <alloc_block_FF+0xac>
	        return NULL;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	e9 0e 04 00 00       	jmp    8028fc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024f5:	a1 30 50 80 00       	mov    0x805030,%eax
  8024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fd:	e9 f3 02 00 00       	jmp    8027f5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	ff 75 bc             	pushl  -0x44(%ebp)
  80250e:	e8 af fb ff ff       	call   8020c2 <get_block_size>
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	83 c0 08             	add    $0x8,%eax
  80251f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802522:	0f 87 c5 02 00 00    	ja     8027ed <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	83 c0 18             	add    $0x18,%eax
  80252e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802531:	0f 87 19 02 00 00    	ja     802750 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802537:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80253a:	2b 45 08             	sub    0x8(%ebp),%eax
  80253d:	83 e8 08             	sub    $0x8,%eax
  802540:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	8d 50 08             	lea    0x8(%eax),%edx
  802549:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254c:	01 d0                	add    %edx,%eax
  80254e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	83 c0 08             	add    $0x8,%eax
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	6a 01                	push   $0x1
  80255c:	50                   	push   %eax
  80255d:	ff 75 bc             	pushl  -0x44(%ebp)
  802560:	e8 ae fe ff ff       	call   802413 <set_block_data>
  802565:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	75 68                	jne    8025da <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802572:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802576:	75 17                	jne    80258f <alloc_block_FF+0x14d>
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	68 f8 46 80 00       	push   $0x8046f8
  802580:	68 d7 00 00 00       	push   $0xd7
  802585:	68 dd 46 80 00       	push   $0x8046dd
  80258a:	e8 93 de ff ff       	call   800422 <_panic>
  80258f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802595:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802598:	89 10                	mov    %edx,(%eax)
  80259a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 0d                	je     8025b0 <alloc_block_FF+0x16e>
  8025a3:	a1 30 50 80 00       	mov    0x805030,%eax
  8025a8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025ab:	89 50 04             	mov    %edx,0x4(%eax)
  8025ae:	eb 08                	jmp    8025b8 <alloc_block_FF+0x176>
  8025b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ca:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025cf:	40                   	inc    %eax
  8025d0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025d5:	e9 dc 00 00 00       	jmp    8026b6 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 65                	jne    802648 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025e3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025e7:	75 17                	jne    802600 <alloc_block_FF+0x1be>
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	68 2c 47 80 00       	push   $0x80472c
  8025f1:	68 db 00 00 00       	push   $0xdb
  8025f6:	68 dd 46 80 00       	push   $0x8046dd
  8025fb:	e8 22 de ff ff       	call   800422 <_panic>
  802600:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802606:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802609:	89 50 04             	mov    %edx,0x4(%eax)
  80260c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	74 0c                	je     802622 <alloc_block_FF+0x1e0>
  802616:	a1 34 50 80 00       	mov    0x805034,%eax
  80261b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	eb 08                	jmp    80262a <alloc_block_FF+0x1e8>
  802622:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802625:	a3 30 50 80 00       	mov    %eax,0x805030
  80262a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262d:	a3 34 50 80 00       	mov    %eax,0x805034
  802632:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802640:	40                   	inc    %eax
  802641:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802646:	eb 6e                	jmp    8026b6 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264c:	74 06                	je     802654 <alloc_block_FF+0x212>
  80264e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802652:	75 17                	jne    80266b <alloc_block_FF+0x229>
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 50 47 80 00       	push   $0x804750
  80265c:	68 df 00 00 00       	push   $0xdf
  802661:	68 dd 46 80 00       	push   $0x8046dd
  802666:	e8 b7 dd ff ff       	call   800422 <_panic>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 10                	mov    (%eax),%edx
  802670:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802673:	89 10                	mov    %edx,(%eax)
  802675:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0b                	je     802689 <alloc_block_FF+0x247>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802686:	89 50 04             	mov    %edx,0x4(%eax)
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80268f:	89 10                	mov    %edx,(%eax)
  802691:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802697:	89 50 04             	mov    %edx,0x4(%eax)
  80269a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 08                	jne    8026ab <alloc_block_FF+0x269>
  8026a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a6:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026b0:	40                   	inc    %eax
  8026b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ba:	75 17                	jne    8026d3 <alloc_block_FF+0x291>
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	68 bf 46 80 00       	push   $0x8046bf
  8026c4:	68 e1 00 00 00       	push   $0xe1
  8026c9:	68 dd 46 80 00       	push   $0x8046dd
  8026ce:	e8 4f dd ff ff       	call   800422 <_panic>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 10                	je     8026ec <alloc_block_FF+0x2aa>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e4:	8b 52 04             	mov    0x4(%edx),%edx
  8026e7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ea:	eb 0b                	jmp    8026f7 <alloc_block_FF+0x2b5>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 0f                	je     802710 <alloc_block_FF+0x2ce>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	8b 12                	mov    (%edx),%edx
  80270c:	89 10                	mov    %edx,(%eax)
  80270e:	eb 0a                	jmp    80271a <alloc_block_FF+0x2d8>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	a3 30 50 80 00       	mov    %eax,0x805030
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802732:	48                   	dec    %eax
  802733:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	6a 00                	push   $0x0
  80273d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802740:	ff 75 b0             	pushl  -0x50(%ebp)
  802743:	e8 cb fc ff ff       	call   802413 <set_block_data>
  802748:	83 c4 10             	add    $0x10,%esp
  80274b:	e9 95 00 00 00       	jmp    8027e5 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	6a 01                	push   $0x1
  802755:	ff 75 b8             	pushl  -0x48(%ebp)
  802758:	ff 75 bc             	pushl  -0x44(%ebp)
  80275b:	e8 b3 fc ff ff       	call   802413 <set_block_data>
  802760:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	75 17                	jne    802780 <alloc_block_FF+0x33e>
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	68 bf 46 80 00       	push   $0x8046bf
  802771:	68 e8 00 00 00       	push   $0xe8
  802776:	68 dd 46 80 00       	push   $0x8046dd
  80277b:	e8 a2 dc ff ff       	call   800422 <_panic>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 10                	je     802799 <alloc_block_FF+0x357>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802791:	8b 52 04             	mov    0x4(%edx),%edx
  802794:	89 50 04             	mov    %edx,0x4(%eax)
  802797:	eb 0b                	jmp    8027a4 <alloc_block_FF+0x362>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	a3 34 50 80 00       	mov    %eax,0x805034
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 0f                	je     8027bd <alloc_block_FF+0x37b>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 12                	mov    (%edx),%edx
  8027b9:	89 10                	mov    %edx,(%eax)
  8027bb:	eb 0a                	jmp    8027c7 <alloc_block_FF+0x385>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027da:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027df:	48                   	dec    %eax
  8027e0:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  8027e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027e8:	e9 0f 01 00 00       	jmp    8028fc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	74 07                	je     802802 <alloc_block_FF+0x3c0>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	eb 05                	jmp    802807 <alloc_block_FF+0x3c5>
  802802:	b8 00 00 00 00       	mov    $0x0,%eax
  802807:	a3 38 50 80 00       	mov    %eax,0x805038
  80280c:	a1 38 50 80 00       	mov    0x805038,%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	0f 85 e9 fc ff ff    	jne    802502 <alloc_block_FF+0xc0>
  802819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281d:	0f 85 df fc ff ff    	jne    802502 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	83 c0 08             	add    $0x8,%eax
  802829:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80282c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802833:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802836:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802839:	01 d0                	add    %edx,%eax
  80283b:	48                   	dec    %eax
  80283c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80283f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802842:	ba 00 00 00 00       	mov    $0x0,%edx
  802847:	f7 75 d8             	divl   -0x28(%ebp)
  80284a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284d:	29 d0                	sub    %edx,%eax
  80284f:	c1 e8 0c             	shr    $0xc,%eax
  802852:	83 ec 0c             	sub    $0xc,%esp
  802855:	50                   	push   %eax
  802856:	e8 1e ec ff ff       	call   801479 <sbrk>
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802861:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802865:	75 0a                	jne    802871 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	e9 8b 00 00 00       	jmp    8028fc <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802871:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802878:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80287b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	48                   	dec    %eax
  802881:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802884:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802887:	ba 00 00 00 00       	mov    $0x0,%edx
  80288c:	f7 75 cc             	divl   -0x34(%ebp)
  80288f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802892:	29 d0                	sub    %edx,%eax
  802894:	8d 50 fc             	lea    -0x4(%eax),%edx
  802897:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  8028a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028ac:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028b9:	01 d0                	add    %edx,%eax
  8028bb:	48                   	dec    %eax
  8028bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c7:	f7 75 c4             	divl   -0x3c(%ebp)
  8028ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028cd:	29 d0                	sub    %edx,%eax
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	6a 01                	push   $0x1
  8028d4:	50                   	push   %eax
  8028d5:	ff 75 d0             	pushl  -0x30(%ebp)
  8028d8:	e8 36 fb ff ff       	call   802413 <set_block_data>
  8028dd:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8028e6:	e8 1b 0a 00 00       	call   803306 <free_block>
  8028eb:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	ff 75 08             	pushl  0x8(%ebp)
  8028f4:	e8 49 fb ff ff       	call   802442 <alloc_block_FF>
  8028f9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028fc:	c9                   	leave  
  8028fd:	c3                   	ret    

008028fe <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	83 e0 01             	and    $0x1,%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 03                	je     802911 <alloc_block_BF+0x13>
  80290e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802911:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802915:	77 07                	ja     80291e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802917:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80291e:	a1 28 50 80 00       	mov    0x805028,%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	75 73                	jne    80299a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	83 c0 10             	add    $0x10,%eax
  80292d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802930:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802937:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80293a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293d:	01 d0                	add    %edx,%eax
  80293f:	48                   	dec    %eax
  802940:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802943:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802946:	ba 00 00 00 00       	mov    $0x0,%edx
  80294b:	f7 75 e0             	divl   -0x20(%ebp)
  80294e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802951:	29 d0                	sub    %edx,%eax
  802953:	c1 e8 0c             	shr    $0xc,%eax
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	50                   	push   %eax
  80295a:	e8 1a eb ff ff       	call   801479 <sbrk>
  80295f:	83 c4 10             	add    $0x10,%esp
  802962:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	6a 00                	push   $0x0
  80296a:	e8 0a eb ff ff       	call   801479 <sbrk>
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802975:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802978:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80297b:	83 ec 08             	sub    $0x8,%esp
  80297e:	50                   	push   %eax
  80297f:	ff 75 d8             	pushl  -0x28(%ebp)
  802982:	e8 9f f8 ff ff       	call   802226 <initialize_dynamic_allocator>
  802987:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80298a:	83 ec 0c             	sub    $0xc,%esp
  80298d:	68 1b 47 80 00       	push   $0x80471b
  802992:	e8 48 dd ff ff       	call   8006df <cprintf>
  802997:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80299a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029a8:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8029bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029be:	e9 1d 01 00 00       	jmp    802ae0 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029c9:	83 ec 0c             	sub    $0xc,%esp
  8029cc:	ff 75 a8             	pushl  -0x58(%ebp)
  8029cf:	e8 ee f6 ff ff       	call   8020c2 <get_block_size>
  8029d4:	83 c4 10             	add    $0x10,%esp
  8029d7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	83 c0 08             	add    $0x8,%eax
  8029e0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e3:	0f 87 ef 00 00 00    	ja     802ad8 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	83 c0 18             	add    $0x18,%eax
  8029ef:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029f2:	77 1d                	ja     802a11 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029fa:	0f 86 d8 00 00 00    	jbe    802ad8 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a00:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a06:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a0c:	e9 c7 00 00 00       	jmp    802ad8 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	83 c0 08             	add    $0x8,%eax
  802a17:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a1a:	0f 85 9d 00 00 00    	jne    802abd <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	6a 01                	push   $0x1
  802a25:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a28:	ff 75 a8             	pushl  -0x58(%ebp)
  802a2b:	e8 e3 f9 ff ff       	call   802413 <set_block_data>
  802a30:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a37:	75 17                	jne    802a50 <alloc_block_BF+0x152>
  802a39:	83 ec 04             	sub    $0x4,%esp
  802a3c:	68 bf 46 80 00       	push   $0x8046bf
  802a41:	68 2c 01 00 00       	push   $0x12c
  802a46:	68 dd 46 80 00       	push   $0x8046dd
  802a4b:	e8 d2 d9 ff ff       	call   800422 <_panic>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 10                	je     802a69 <alloc_block_BF+0x16b>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a61:	8b 52 04             	mov    0x4(%edx),%edx
  802a64:	89 50 04             	mov    %edx,0x4(%eax)
  802a67:	eb 0b                	jmp    802a74 <alloc_block_BF+0x176>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 04             	mov    0x4(%eax),%eax
  802a6f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 04             	mov    0x4(%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 0f                	je     802a8d <alloc_block_BF+0x18f>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a87:	8b 12                	mov    (%edx),%edx
  802a89:	89 10                	mov    %edx,(%eax)
  802a8b:	eb 0a                	jmp    802a97 <alloc_block_BF+0x199>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	a3 30 50 80 00       	mov    %eax,0x805030
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aaf:	48                   	dec    %eax
  802ab0:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802ab5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ab8:	e9 24 04 00 00       	jmp    802ee1 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ac3:	76 13                	jbe    802ad8 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ac5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802acc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ad2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ad8:	a1 38 50 80 00       	mov    0x805038,%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	74 07                	je     802aed <alloc_block_BF+0x1ef>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	eb 05                	jmp    802af2 <alloc_block_BF+0x1f4>
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	a3 38 50 80 00       	mov    %eax,0x805038
  802af7:	a1 38 50 80 00       	mov    0x805038,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	0f 85 bf fe ff ff    	jne    8029c3 <alloc_block_BF+0xc5>
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	0f 85 b5 fe ff ff    	jne    8029c3 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b12:	0f 84 26 02 00 00    	je     802d3e <alloc_block_BF+0x440>
  802b18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b1c:	0f 85 1c 02 00 00    	jne    802d3e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	2b 45 08             	sub    0x8(%ebp),%eax
  802b28:	83 e8 08             	sub    $0x8,%eax
  802b2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	8d 50 08             	lea    0x8(%eax),%edx
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	01 d0                	add    %edx,%eax
  802b39:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	83 c0 08             	add    $0x8,%eax
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	6a 01                	push   $0x1
  802b47:	50                   	push   %eax
  802b48:	ff 75 f0             	pushl  -0x10(%ebp)
  802b4b:	e8 c3 f8 ff ff       	call   802413 <set_block_data>
  802b50:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b56:	8b 40 04             	mov    0x4(%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	75 68                	jne    802bc5 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b5d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b61:	75 17                	jne    802b7a <alloc_block_BF+0x27c>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 f8 46 80 00       	push   $0x8046f8
  802b6b:	68 45 01 00 00       	push   $0x145
  802b70:	68 dd 46 80 00       	push   $0x8046dd
  802b75:	e8 a8 d8 ff ff       	call   800422 <_panic>
  802b7a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b83:	89 10                	mov    %edx,(%eax)
  802b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0d                	je     802b9b <alloc_block_BF+0x29d>
  802b8e:	a1 30 50 80 00       	mov    0x805030,%eax
  802b93:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 08                	jmp    802ba3 <alloc_block_BF+0x2a5>
  802b9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9e:	a3 34 50 80 00       	mov    %eax,0x805034
  802ba3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bba:	40                   	inc    %eax
  802bbb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bc0:	e9 dc 00 00 00       	jmp    802ca1 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	75 65                	jne    802c33 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bd2:	75 17                	jne    802beb <alloc_block_BF+0x2ed>
  802bd4:	83 ec 04             	sub    $0x4,%esp
  802bd7:	68 2c 47 80 00       	push   $0x80472c
  802bdc:	68 4a 01 00 00       	push   $0x14a
  802be1:	68 dd 46 80 00       	push   $0x8046dd
  802be6:	e8 37 d8 ff ff       	call   800422 <_panic>
  802beb:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
  802bf7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 0c                	je     802c0d <alloc_block_BF+0x30f>
  802c01:	a1 34 50 80 00       	mov    0x805034,%eax
  802c06:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c09:	89 10                	mov    %edx,(%eax)
  802c0b:	eb 08                	jmp    802c15 <alloc_block_BF+0x317>
  802c0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c10:	a3 30 50 80 00       	mov    %eax,0x805030
  802c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c18:	a3 34 50 80 00       	mov    %eax,0x805034
  802c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c26:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c2b:	40                   	inc    %eax
  802c2c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c31:	eb 6e                	jmp    802ca1 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c37:	74 06                	je     802c3f <alloc_block_BF+0x341>
  802c39:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c3d:	75 17                	jne    802c56 <alloc_block_BF+0x358>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 50 47 80 00       	push   $0x804750
  802c47:	68 4f 01 00 00       	push   $0x14f
  802c4c:	68 dd 46 80 00       	push   $0x8046dd
  802c51:	e8 cc d7 ff ff       	call   800422 <_panic>
  802c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c59:	8b 10                	mov    (%eax),%edx
  802c5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0b                	je     802c74 <alloc_block_BF+0x376>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c82:	89 50 04             	mov    %edx,0x4(%eax)
  802c85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	75 08                	jne    802c96 <alloc_block_BF+0x398>
  802c8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c91:	a3 34 50 80 00       	mov    %eax,0x805034
  802c96:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c9b:	40                   	inc    %eax
  802c9c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca5:	75 17                	jne    802cbe <alloc_block_BF+0x3c0>
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	68 bf 46 80 00       	push   $0x8046bf
  802caf:	68 51 01 00 00       	push   $0x151
  802cb4:	68 dd 46 80 00       	push   $0x8046dd
  802cb9:	e8 64 d7 ff ff       	call   800422 <_panic>
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 10                	je     802cd7 <alloc_block_BF+0x3d9>
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ccf:	8b 52 04             	mov    0x4(%edx),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	eb 0b                	jmp    802ce2 <alloc_block_BF+0x3e4>
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	a3 34 50 80 00       	mov    %eax,0x805034
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	74 0f                	je     802cfb <alloc_block_BF+0x3fd>
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf5:	8b 12                	mov    (%edx),%edx
  802cf7:	89 10                	mov    %edx,(%eax)
  802cf9:	eb 0a                	jmp    802d05 <alloc_block_BF+0x407>
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	a3 30 50 80 00       	mov    %eax,0x805030
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d18:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d1d:	48                   	dec    %eax
  802d1e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	6a 00                	push   $0x0
  802d28:	ff 75 d0             	pushl  -0x30(%ebp)
  802d2b:	ff 75 cc             	pushl  -0x34(%ebp)
  802d2e:	e8 e0 f6 ff ff       	call   802413 <set_block_data>
  802d33:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	e9 a3 01 00 00       	jmp    802ee1 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d3e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d42:	0f 85 9d 00 00 00    	jne    802de5 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d48:	83 ec 04             	sub    $0x4,%esp
  802d4b:	6a 01                	push   $0x1
  802d4d:	ff 75 ec             	pushl  -0x14(%ebp)
  802d50:	ff 75 f0             	pushl  -0x10(%ebp)
  802d53:	e8 bb f6 ff ff       	call   802413 <set_block_data>
  802d58:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5f:	75 17                	jne    802d78 <alloc_block_BF+0x47a>
  802d61:	83 ec 04             	sub    $0x4,%esp
  802d64:	68 bf 46 80 00       	push   $0x8046bf
  802d69:	68 58 01 00 00       	push   $0x158
  802d6e:	68 dd 46 80 00       	push   $0x8046dd
  802d73:	e8 aa d6 ff ff       	call   800422 <_panic>
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 10                	je     802d91 <alloc_block_BF+0x493>
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d89:	8b 52 04             	mov    0x4(%edx),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 0b                	jmp    802d9c <alloc_block_BF+0x49e>
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	a3 34 50 80 00       	mov    %eax,0x805034
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0f                	je     802db5 <alloc_block_BF+0x4b7>
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802daf:	8b 12                	mov    (%edx),%edx
  802db1:	89 10                	mov    %edx,(%eax)
  802db3:	eb 0a                	jmp    802dbf <alloc_block_BF+0x4c1>
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	a3 30 50 80 00       	mov    %eax,0x805030
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802dd7:	48                   	dec    %eax
  802dd8:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	e9 fc 00 00 00       	jmp    802ee1 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	83 c0 08             	add    $0x8,%eax
  802deb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dee:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802df5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802df8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dfb:	01 d0                	add    %edx,%eax
  802dfd:	48                   	dec    %eax
  802dfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e01:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e04:	ba 00 00 00 00       	mov    $0x0,%edx
  802e09:	f7 75 c4             	divl   -0x3c(%ebp)
  802e0c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e0f:	29 d0                	sub    %edx,%eax
  802e11:	c1 e8 0c             	shr    $0xc,%eax
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	50                   	push   %eax
  802e18:	e8 5c e6 ff ff       	call   801479 <sbrk>
  802e1d:	83 c4 10             	add    $0x10,%esp
  802e20:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e23:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e27:	75 0a                	jne    802e33 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	e9 ae 00 00 00       	jmp    802ee1 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e33:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e3a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e40:	01 d0                	add    %edx,%eax
  802e42:	48                   	dec    %eax
  802e43:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e49:	ba 00 00 00 00       	mov    $0x0,%edx
  802e4e:	f7 75 b8             	divl   -0x48(%ebp)
  802e51:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e54:	29 d0                	sub    %edx,%eax
  802e56:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e59:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e5c:	01 d0                	add    %edx,%eax
  802e5e:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802e63:	a1 44 50 80 00       	mov    0x805044,%eax
  802e68:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e6e:	83 ec 0c             	sub    $0xc,%esp
  802e71:	68 84 47 80 00       	push   $0x804784
  802e76:	e8 64 d8 ff ff       	call   8006df <cprintf>
  802e7b:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e7e:	83 ec 08             	sub    $0x8,%esp
  802e81:	ff 75 bc             	pushl  -0x44(%ebp)
  802e84:	68 89 47 80 00       	push   $0x804789
  802e89:	e8 51 d8 ff ff       	call   8006df <cprintf>
  802e8e:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e91:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e98:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e9e:	01 d0                	add    %edx,%eax
  802ea0:	48                   	dec    %eax
  802ea1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ea4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  802eac:	f7 75 b0             	divl   -0x50(%ebp)
  802eaf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eb2:	29 d0                	sub    %edx,%eax
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	6a 01                	push   $0x1
  802eb9:	50                   	push   %eax
  802eba:	ff 75 bc             	pushl  -0x44(%ebp)
  802ebd:	e8 51 f5 ff ff       	call   802413 <set_block_data>
  802ec2:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	ff 75 bc             	pushl  -0x44(%ebp)
  802ecb:	e8 36 04 00 00       	call   803306 <free_block>
  802ed0:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ed3:	83 ec 0c             	sub    $0xc,%esp
  802ed6:	ff 75 08             	pushl  0x8(%ebp)
  802ed9:	e8 20 fa ff ff       	call   8028fe <alloc_block_BF>
  802ede:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ee1:	c9                   	leave  
  802ee2:	c3                   	ret    

00802ee3 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ee3:	55                   	push   %ebp
  802ee4:	89 e5                	mov    %esp,%ebp
  802ee6:	53                   	push   %ebx
  802ee7:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ef1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efc:	74 1e                	je     802f1c <merging+0x39>
  802efe:	ff 75 08             	pushl  0x8(%ebp)
  802f01:	e8 bc f1 ff ff       	call   8020c2 <get_block_size>
  802f06:	83 c4 04             	add    $0x4,%esp
  802f09:	89 c2                	mov    %eax,%edx
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	01 d0                	add    %edx,%eax
  802f10:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f13:	75 07                	jne    802f1c <merging+0x39>
		prev_is_free = 1;
  802f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f20:	74 1e                	je     802f40 <merging+0x5d>
  802f22:	ff 75 10             	pushl  0x10(%ebp)
  802f25:	e8 98 f1 ff ff       	call   8020c2 <get_block_size>
  802f2a:	83 c4 04             	add    $0x4,%esp
  802f2d:	89 c2                	mov    %eax,%edx
  802f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f37:	75 07                	jne    802f40 <merging+0x5d>
		next_is_free = 1;
  802f39:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f44:	0f 84 cc 00 00 00    	je     803016 <merging+0x133>
  802f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4e:	0f 84 c2 00 00 00    	je     803016 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f54:	ff 75 08             	pushl  0x8(%ebp)
  802f57:	e8 66 f1 ff ff       	call   8020c2 <get_block_size>
  802f5c:	83 c4 04             	add    $0x4,%esp
  802f5f:	89 c3                	mov    %eax,%ebx
  802f61:	ff 75 10             	pushl  0x10(%ebp)
  802f64:	e8 59 f1 ff ff       	call   8020c2 <get_block_size>
  802f69:	83 c4 04             	add    $0x4,%esp
  802f6c:	01 c3                	add    %eax,%ebx
  802f6e:	ff 75 0c             	pushl  0xc(%ebp)
  802f71:	e8 4c f1 ff ff       	call   8020c2 <get_block_size>
  802f76:	83 c4 04             	add    $0x4,%esp
  802f79:	01 d8                	add    %ebx,%eax
  802f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f7e:	6a 00                	push   $0x0
  802f80:	ff 75 ec             	pushl  -0x14(%ebp)
  802f83:	ff 75 08             	pushl  0x8(%ebp)
  802f86:	e8 88 f4 ff ff       	call   802413 <set_block_data>
  802f8b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	75 17                	jne    802fab <merging+0xc8>
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	68 bf 46 80 00       	push   $0x8046bf
  802f9c:	68 7d 01 00 00       	push   $0x17d
  802fa1:	68 dd 46 80 00       	push   $0x8046dd
  802fa6:	e8 77 d4 ff ff       	call   800422 <_panic>
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 10                	je     802fc4 <merging+0xe1>
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbc:	8b 52 04             	mov    0x4(%edx),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	eb 0b                	jmp    802fcf <merging+0xec>
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	a3 34 50 80 00       	mov    %eax,0x805034
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0f                	je     802fe8 <merging+0x105>
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe2:	8b 12                	mov    (%edx),%edx
  802fe4:	89 10                	mov    %edx,(%eax)
  802fe6:	eb 0a                	jmp    802ff2 <merging+0x10f>
  802fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80300a:	48                   	dec    %eax
  80300b:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803010:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803011:	e9 ea 02 00 00       	jmp    803300 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803016:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301a:	74 3b                	je     803057 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80301c:	83 ec 0c             	sub    $0xc,%esp
  80301f:	ff 75 08             	pushl  0x8(%ebp)
  803022:	e8 9b f0 ff ff       	call   8020c2 <get_block_size>
  803027:	83 c4 10             	add    $0x10,%esp
  80302a:	89 c3                	mov    %eax,%ebx
  80302c:	83 ec 0c             	sub    $0xc,%esp
  80302f:	ff 75 10             	pushl  0x10(%ebp)
  803032:	e8 8b f0 ff ff       	call   8020c2 <get_block_size>
  803037:	83 c4 10             	add    $0x10,%esp
  80303a:	01 d8                	add    %ebx,%eax
  80303c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	6a 00                	push   $0x0
  803044:	ff 75 e8             	pushl  -0x18(%ebp)
  803047:	ff 75 08             	pushl  0x8(%ebp)
  80304a:	e8 c4 f3 ff ff       	call   802413 <set_block_data>
  80304f:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803052:	e9 a9 02 00 00       	jmp    803300 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803057:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305b:	0f 84 2d 01 00 00    	je     80318e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803061:	83 ec 0c             	sub    $0xc,%esp
  803064:	ff 75 10             	pushl  0x10(%ebp)
  803067:	e8 56 f0 ff ff       	call   8020c2 <get_block_size>
  80306c:	83 c4 10             	add    $0x10,%esp
  80306f:	89 c3                	mov    %eax,%ebx
  803071:	83 ec 0c             	sub    $0xc,%esp
  803074:	ff 75 0c             	pushl  0xc(%ebp)
  803077:	e8 46 f0 ff ff       	call   8020c2 <get_block_size>
  80307c:	83 c4 10             	add    $0x10,%esp
  80307f:	01 d8                	add    %ebx,%eax
  803081:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	6a 00                	push   $0x0
  803089:	ff 75 e4             	pushl  -0x1c(%ebp)
  80308c:	ff 75 10             	pushl  0x10(%ebp)
  80308f:	e8 7f f3 ff ff       	call   802413 <set_block_data>
  803094:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803097:	8b 45 10             	mov    0x10(%ebp),%eax
  80309a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80309d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a1:	74 06                	je     8030a9 <merging+0x1c6>
  8030a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030a7:	75 17                	jne    8030c0 <merging+0x1dd>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 98 47 80 00       	push   $0x804798
  8030b1:	68 8d 01 00 00       	push   $0x18d
  8030b6:	68 dd 46 80 00       	push   $0x8046dd
  8030bb:	e8 62 d3 ff ff       	call   800422 <_panic>
  8030c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c3:	8b 50 04             	mov    0x4(%eax),%edx
  8030c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 0d                	je     8030eb <merging+0x208>
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	eb 08                	jmp    8030f3 <merging+0x210>
  8030eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803101:	40                   	inc    %eax
  803102:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803107:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80310b:	75 17                	jne    803124 <merging+0x241>
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	68 bf 46 80 00       	push   $0x8046bf
  803115:	68 8e 01 00 00       	push   $0x18e
  80311a:	68 dd 46 80 00       	push   $0x8046dd
  80311f:	e8 fe d2 ff ff       	call   800422 <_panic>
  803124:	8b 45 0c             	mov    0xc(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 10                	je     80313d <merging+0x25a>
  80312d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	8b 55 0c             	mov    0xc(%ebp),%edx
  803135:	8b 52 04             	mov    0x4(%edx),%edx
  803138:	89 50 04             	mov    %edx,0x4(%eax)
  80313b:	eb 0b                	jmp    803148 <merging+0x265>
  80313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803140:	8b 40 04             	mov    0x4(%eax),%eax
  803143:	a3 34 50 80 00       	mov    %eax,0x805034
  803148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314b:	8b 40 04             	mov    0x4(%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	74 0f                	je     803161 <merging+0x27e>
  803152:	8b 45 0c             	mov    0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315b:	8b 12                	mov    (%edx),%edx
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	eb 0a                	jmp    80316b <merging+0x288>
  803161:	8b 45 0c             	mov    0xc(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	a3 30 50 80 00       	mov    %eax,0x805030
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803174:	8b 45 0c             	mov    0xc(%ebp),%eax
  803177:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803183:	48                   	dec    %eax
  803184:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803189:	e9 72 01 00 00       	jmp    803300 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80318e:	8b 45 10             	mov    0x10(%ebp),%eax
  803191:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803198:	74 79                	je     803213 <merging+0x330>
  80319a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80319e:	74 73                	je     803213 <merging+0x330>
  8031a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a4:	74 06                	je     8031ac <merging+0x2c9>
  8031a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031aa:	75 17                	jne    8031c3 <merging+0x2e0>
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	68 50 47 80 00       	push   $0x804750
  8031b4:	68 94 01 00 00       	push   $0x194
  8031b9:	68 dd 46 80 00       	push   $0x8046dd
  8031be:	e8 5f d2 ff ff       	call   800422 <_panic>
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	8b 10                	mov    (%eax),%edx
  8031c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 0b                	je     8031e1 <merging+0x2fe>
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e7:	89 10                	mov    %edx,(%eax)
  8031e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ef:	89 50 04             	mov    %edx,0x4(%eax)
  8031f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	75 08                	jne    803203 <merging+0x320>
  8031fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fe:	a3 34 50 80 00       	mov    %eax,0x805034
  803203:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803208:	40                   	inc    %eax
  803209:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80320e:	e9 ce 00 00 00       	jmp    8032e1 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803217:	74 65                	je     80327e <merging+0x39b>
  803219:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80321d:	75 17                	jne    803236 <merging+0x353>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 2c 47 80 00       	push   $0x80472c
  803227:	68 95 01 00 00       	push   $0x195
  80322c:	68 dd 46 80 00       	push   $0x8046dd
  803231:	e8 ec d1 ff ff       	call   800422 <_panic>
  803236:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323f:	89 50 04             	mov    %edx,0x4(%eax)
  803242:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0c                	je     803258 <merging+0x375>
  80324c:	a1 34 50 80 00       	mov    0x805034,%eax
  803251:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803254:	89 10                	mov    %edx,(%eax)
  803256:	eb 08                	jmp    803260 <merging+0x37d>
  803258:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325b:	a3 30 50 80 00       	mov    %eax,0x805030
  803260:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803263:	a3 34 50 80 00       	mov    %eax,0x805034
  803268:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803271:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803276:	40                   	inc    %eax
  803277:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80327c:	eb 63                	jmp    8032e1 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80327e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803282:	75 17                	jne    80329b <merging+0x3b8>
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	68 f8 46 80 00       	push   $0x8046f8
  80328c:	68 98 01 00 00       	push   $0x198
  803291:	68 dd 46 80 00       	push   $0x8046dd
  803296:	e8 87 d1 ff ff       	call   800422 <_panic>
  80329b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	74 0d                	je     8032bc <merging+0x3d9>
  8032af:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ba:	eb 08                	jmp    8032c4 <merging+0x3e1>
  8032bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032db:	40                   	inc    %eax
  8032dc:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8032e1:	83 ec 0c             	sub    $0xc,%esp
  8032e4:	ff 75 10             	pushl  0x10(%ebp)
  8032e7:	e8 d6 ed ff ff       	call   8020c2 <get_block_size>
  8032ec:	83 c4 10             	add    $0x10,%esp
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	6a 00                	push   $0x0
  8032f4:	50                   	push   %eax
  8032f5:	ff 75 10             	pushl  0x10(%ebp)
  8032f8:	e8 16 f1 ff ff       	call   802413 <set_block_data>
  8032fd:	83 c4 10             	add    $0x10,%esp
	}
}
  803300:	90                   	nop
  803301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803304:	c9                   	leave  
  803305:	c3                   	ret    

00803306 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803306:	55                   	push   %ebp
  803307:	89 e5                	mov    %esp,%ebp
  803309:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80330c:	a1 30 50 80 00       	mov    0x805030,%eax
  803311:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803314:	a1 34 50 80 00       	mov    0x805034,%eax
  803319:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331c:	73 1b                	jae    803339 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80331e:	a1 34 50 80 00       	mov    0x805034,%eax
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	ff 75 08             	pushl  0x8(%ebp)
  803329:	6a 00                	push   $0x0
  80332b:	50                   	push   %eax
  80332c:	e8 b2 fb ff ff       	call   802ee3 <merging>
  803331:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803334:	e9 8b 00 00 00       	jmp    8033c4 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803339:	a1 30 50 80 00       	mov    0x805030,%eax
  80333e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803341:	76 18                	jbe    80335b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803343:	a1 30 50 80 00       	mov    0x805030,%eax
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	ff 75 08             	pushl  0x8(%ebp)
  80334e:	50                   	push   %eax
  80334f:	6a 00                	push   $0x0
  803351:	e8 8d fb ff ff       	call   802ee3 <merging>
  803356:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803359:	eb 69                	jmp    8033c4 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80335b:	a1 30 50 80 00       	mov    0x805030,%eax
  803360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803363:	eb 39                	jmp    80339e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	3b 45 08             	cmp    0x8(%ebp),%eax
  80336b:	73 29                	jae    803396 <free_block+0x90>
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	3b 45 08             	cmp    0x8(%ebp),%eax
  803375:	76 1f                	jbe    803396 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80337f:	83 ec 04             	sub    $0x4,%esp
  803382:	ff 75 08             	pushl  0x8(%ebp)
  803385:	ff 75 f0             	pushl  -0x10(%ebp)
  803388:	ff 75 f4             	pushl  -0xc(%ebp)
  80338b:	e8 53 fb ff ff       	call   802ee3 <merging>
  803390:	83 c4 10             	add    $0x10,%esp
			break;
  803393:	90                   	nop
		}
	}
}
  803394:	eb 2e                	jmp    8033c4 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803396:	a1 38 50 80 00       	mov    0x805038,%eax
  80339b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80339e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a2:	74 07                	je     8033ab <free_block+0xa5>
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	eb 05                	jmp    8033b0 <free_block+0xaa>
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b0:	a3 38 50 80 00       	mov    %eax,0x805038
  8033b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	75 a7                	jne    803365 <free_block+0x5f>
  8033be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c2:	75 a1                	jne    803365 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033c4:	90                   	nop
  8033c5:	c9                   	leave  
  8033c6:	c3                   	ret    

008033c7 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033c7:	55                   	push   %ebp
  8033c8:	89 e5                	mov    %esp,%ebp
  8033ca:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033cd:	ff 75 08             	pushl  0x8(%ebp)
  8033d0:	e8 ed ec ff ff       	call   8020c2 <get_block_size>
  8033d5:	83 c4 04             	add    $0x4,%esp
  8033d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033e2:	eb 17                	jmp    8033fb <copy_data+0x34>
  8033e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ea:	01 c2                	add    %eax,%edx
  8033ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	01 c8                	add    %ecx,%eax
  8033f4:	8a 00                	mov    (%eax),%al
  8033f6:	88 02                	mov    %al,(%edx)
  8033f8:	ff 45 fc             	incl   -0x4(%ebp)
  8033fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803401:	72 e1                	jb     8033e4 <copy_data+0x1d>
}
  803403:	90                   	nop
  803404:	c9                   	leave  
  803405:	c3                   	ret    

00803406 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803406:	55                   	push   %ebp
  803407:	89 e5                	mov    %esp,%ebp
  803409:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80340c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803410:	75 23                	jne    803435 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803412:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803416:	74 13                	je     80342b <realloc_block_FF+0x25>
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	ff 75 0c             	pushl  0xc(%ebp)
  80341e:	e8 1f f0 ff ff       	call   802442 <alloc_block_FF>
  803423:	83 c4 10             	add    $0x10,%esp
  803426:	e9 f4 06 00 00       	jmp    803b1f <realloc_block_FF+0x719>
		return NULL;
  80342b:	b8 00 00 00 00       	mov    $0x0,%eax
  803430:	e9 ea 06 00 00       	jmp    803b1f <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803439:	75 18                	jne    803453 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80343b:	83 ec 0c             	sub    $0xc,%esp
  80343e:	ff 75 08             	pushl  0x8(%ebp)
  803441:	e8 c0 fe ff ff       	call   803306 <free_block>
  803446:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803449:	b8 00 00 00 00       	mov    $0x0,%eax
  80344e:	e9 cc 06 00 00       	jmp    803b1f <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803453:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803457:	77 07                	ja     803460 <realloc_block_FF+0x5a>
  803459:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803460:	8b 45 0c             	mov    0xc(%ebp),%eax
  803463:	83 e0 01             	and    $0x1,%eax
  803466:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346c:	83 c0 08             	add    $0x8,%eax
  80346f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803472:	83 ec 0c             	sub    $0xc,%esp
  803475:	ff 75 08             	pushl  0x8(%ebp)
  803478:	e8 45 ec ff ff       	call   8020c2 <get_block_size>
  80347d:	83 c4 10             	add    $0x10,%esp
  803480:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803486:	83 e8 08             	sub    $0x8,%eax
  803489:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	83 e8 04             	sub    $0x4,%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	83 e0 fe             	and    $0xfffffffe,%eax
  803497:	89 c2                	mov    %eax,%edx
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034a1:	83 ec 0c             	sub    $0xc,%esp
  8034a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a7:	e8 16 ec ff ff       	call   8020c2 <get_block_size>
  8034ac:	83 c4 10             	add    $0x10,%esp
  8034af:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b5:	83 e8 08             	sub    $0x8,%eax
  8034b8:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034c1:	75 08                	jne    8034cb <realloc_block_FF+0xc5>
	{
		 return va;
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	e9 54 06 00 00       	jmp    803b1f <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034d1:	0f 83 e5 03 00 00    	jae    8038bc <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034e0:	83 ec 0c             	sub    $0xc,%esp
  8034e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034e6:	e8 f0 eb ff ff       	call   8020db <is_free_block>
  8034eb:	83 c4 10             	add    $0x10,%esp
  8034ee:	84 c0                	test   %al,%al
  8034f0:	0f 84 3b 01 00 00    	je     803631 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034fc:	01 d0                	add    %edx,%eax
  8034fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	6a 01                	push   $0x1
  803506:	ff 75 f0             	pushl  -0x10(%ebp)
  803509:	ff 75 08             	pushl  0x8(%ebp)
  80350c:	e8 02 ef ff ff       	call   802413 <set_block_data>
  803511:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	83 e8 04             	sub    $0x4,%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	83 e0 fe             	and    $0xfffffffe,%eax
  80351f:	89 c2                	mov    %eax,%edx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	6a 00                	push   $0x0
  80352e:	ff 75 cc             	pushl  -0x34(%ebp)
  803531:	ff 75 c8             	pushl  -0x38(%ebp)
  803534:	e8 da ee ff ff       	call   802413 <set_block_data>
  803539:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80353c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803540:	74 06                	je     803548 <realloc_block_FF+0x142>
  803542:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803546:	75 17                	jne    80355f <realloc_block_FF+0x159>
  803548:	83 ec 04             	sub    $0x4,%esp
  80354b:	68 50 47 80 00       	push   $0x804750
  803550:	68 f6 01 00 00       	push   $0x1f6
  803555:	68 dd 46 80 00       	push   $0x8046dd
  80355a:	e8 c3 ce ff ff       	call   800422 <_panic>
  80355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803562:	8b 10                	mov    (%eax),%edx
  803564:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803567:	89 10                	mov    %edx,(%eax)
  803569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0b                	je     80357d <realloc_block_FF+0x177>
  803572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80357a:	89 50 04             	mov    %edx,0x4(%eax)
  80357d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803580:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803583:	89 10                	mov    %edx,(%eax)
  803585:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80358b:	89 50 04             	mov    %edx,0x4(%eax)
  80358e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	75 08                	jne    80359f <realloc_block_FF+0x199>
  803597:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359a:	a3 34 50 80 00       	mov    %eax,0x805034
  80359f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035a4:	40                   	inc    %eax
  8035a5:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ae:	75 17                	jne    8035c7 <realloc_block_FF+0x1c1>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 bf 46 80 00       	push   $0x8046bf
  8035b8:	68 f7 01 00 00       	push   $0x1f7
  8035bd:	68 dd 46 80 00       	push   $0x8046dd
  8035c2:	e8 5b ce ff ff       	call   800422 <_panic>
  8035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	74 10                	je     8035e0 <realloc_block_FF+0x1da>
  8035d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d8:	8b 52 04             	mov    0x4(%edx),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 0b                	jmp    8035eb <realloc_block_FF+0x1e5>
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8035eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 0f                	je     803604 <realloc_block_FF+0x1fe>
  8035f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035fe:	8b 12                	mov    (%edx),%edx
  803600:	89 10                	mov    %edx,(%eax)
  803602:	eb 0a                	jmp    80360e <realloc_block_FF+0x208>
  803604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	a3 30 50 80 00       	mov    %eax,0x805030
  80360e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803621:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803626:	48                   	dec    %eax
  803627:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80362c:	e9 83 02 00 00       	jmp    8038b4 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803631:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803635:	0f 86 69 02 00 00    	jbe    8038a4 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80363b:	83 ec 04             	sub    $0x4,%esp
  80363e:	6a 01                	push   $0x1
  803640:	ff 75 f0             	pushl  -0x10(%ebp)
  803643:	ff 75 08             	pushl  0x8(%ebp)
  803646:	e8 c8 ed ff ff       	call   802413 <set_block_data>
  80364b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	83 e8 04             	sub    $0x4,%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	83 e0 fe             	and    $0xfffffffe,%eax
  803659:	89 c2                	mov    %eax,%edx
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	01 d0                	add    %edx,%eax
  803660:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803663:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803668:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80366b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80366f:	75 68                	jne    8036d9 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803671:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803675:	75 17                	jne    80368e <realloc_block_FF+0x288>
  803677:	83 ec 04             	sub    $0x4,%esp
  80367a:	68 f8 46 80 00       	push   $0x8046f8
  80367f:	68 06 02 00 00       	push   $0x206
  803684:	68 dd 46 80 00       	push   $0x8046dd
  803689:	e8 94 cd ff ff       	call   800422 <_panic>
  80368e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803694:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803697:	89 10                	mov    %edx,(%eax)
  803699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0d                	je     8036af <realloc_block_FF+0x2a9>
  8036a2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	eb 08                	jmp    8036b7 <realloc_block_FF+0x2b1>
  8036af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036ce:	40                   	inc    %eax
  8036cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036d4:	e9 b0 01 00 00       	jmp    803889 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036d9:	a1 30 50 80 00       	mov    0x805030,%eax
  8036de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e1:	76 68                	jbe    80374b <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e7:	75 17                	jne    803700 <realloc_block_FF+0x2fa>
  8036e9:	83 ec 04             	sub    $0x4,%esp
  8036ec:	68 f8 46 80 00       	push   $0x8046f8
  8036f1:	68 0b 02 00 00       	push   $0x20b
  8036f6:	68 dd 46 80 00       	push   $0x8046dd
  8036fb:	e8 22 cd ff ff       	call   800422 <_panic>
  803700:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803706:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	74 0d                	je     803721 <realloc_block_FF+0x31b>
  803714:	a1 30 50 80 00       	mov    0x805030,%eax
  803719:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
  80371f:	eb 08                	jmp    803729 <realloc_block_FF+0x323>
  803721:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803724:	a3 34 50 80 00       	mov    %eax,0x805034
  803729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372c:	a3 30 50 80 00       	mov    %eax,0x805030
  803731:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803740:	40                   	inc    %eax
  803741:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803746:	e9 3e 01 00 00       	jmp    803889 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80374b:	a1 30 50 80 00       	mov    0x805030,%eax
  803750:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803753:	73 68                	jae    8037bd <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803755:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803759:	75 17                	jne    803772 <realloc_block_FF+0x36c>
  80375b:	83 ec 04             	sub    $0x4,%esp
  80375e:	68 2c 47 80 00       	push   $0x80472c
  803763:	68 10 02 00 00       	push   $0x210
  803768:	68 dd 46 80 00       	push   $0x8046dd
  80376d:	e8 b0 cc ff ff       	call   800422 <_panic>
  803772:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377b:	89 50 04             	mov    %edx,0x4(%eax)
  80377e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803781:	8b 40 04             	mov    0x4(%eax),%eax
  803784:	85 c0                	test   %eax,%eax
  803786:	74 0c                	je     803794 <realloc_block_FF+0x38e>
  803788:	a1 34 50 80 00       	mov    0x805034,%eax
  80378d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803790:	89 10                	mov    %edx,(%eax)
  803792:	eb 08                	jmp    80379c <realloc_block_FF+0x396>
  803794:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803797:	a3 30 50 80 00       	mov    %eax,0x805030
  80379c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379f:	a3 34 50 80 00       	mov    %eax,0x805034
  8037a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ad:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037b2:	40                   	inc    %eax
  8037b3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037b8:	e9 cc 00 00 00       	jmp    803889 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8037c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037cc:	e9 8a 00 00 00       	jmp    80385b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037d7:	73 7a                	jae    803853 <realloc_block_FF+0x44d>
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	8b 00                	mov    (%eax),%eax
  8037de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037e1:	73 70                	jae    803853 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e7:	74 06                	je     8037ef <realloc_block_FF+0x3e9>
  8037e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ed:	75 17                	jne    803806 <realloc_block_FF+0x400>
  8037ef:	83 ec 04             	sub    $0x4,%esp
  8037f2:	68 50 47 80 00       	push   $0x804750
  8037f7:	68 1a 02 00 00       	push   $0x21a
  8037fc:	68 dd 46 80 00       	push   $0x8046dd
  803801:	e8 1c cc ff ff       	call   800422 <_panic>
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	8b 10                	mov    (%eax),%edx
  80380b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	85 c0                	test   %eax,%eax
  803817:	74 0b                	je     803824 <realloc_block_FF+0x41e>
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803821:	89 50 04             	mov    %edx,0x4(%eax)
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803832:	89 50 04             	mov    %edx,0x4(%eax)
  803835:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	75 08                	jne    803846 <realloc_block_FF+0x440>
  80383e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803841:	a3 34 50 80 00       	mov    %eax,0x805034
  803846:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80384b:	40                   	inc    %eax
  80384c:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803851:	eb 36                	jmp    803889 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803853:	a1 38 50 80 00       	mov    0x805038,%eax
  803858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385f:	74 07                	je     803868 <realloc_block_FF+0x462>
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	eb 05                	jmp    80386d <realloc_block_FF+0x467>
  803868:	b8 00 00 00 00       	mov    $0x0,%eax
  80386d:	a3 38 50 80 00       	mov    %eax,0x805038
  803872:	a1 38 50 80 00       	mov    0x805038,%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	0f 85 52 ff ff ff    	jne    8037d1 <realloc_block_FF+0x3cb>
  80387f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803883:	0f 85 48 ff ff ff    	jne    8037d1 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	6a 00                	push   $0x0
  80388e:	ff 75 d8             	pushl  -0x28(%ebp)
  803891:	ff 75 d4             	pushl  -0x2c(%ebp)
  803894:	e8 7a eb ff ff       	call   802413 <set_block_data>
  803899:	83 c4 10             	add    $0x10,%esp
				return va;
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	e9 7b 02 00 00       	jmp    803b1f <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038a4:	83 ec 0c             	sub    $0xc,%esp
  8038a7:	68 cd 47 80 00       	push   $0x8047cd
  8038ac:	e8 2e ce ff ff       	call   8006df <cprintf>
  8038b1:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	e9 63 02 00 00       	jmp    803b1f <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038c2:	0f 86 4d 02 00 00    	jbe    803b15 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038c8:	83 ec 0c             	sub    $0xc,%esp
  8038cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038ce:	e8 08 e8 ff ff       	call   8020db <is_free_block>
  8038d3:	83 c4 10             	add    $0x10,%esp
  8038d6:	84 c0                	test   %al,%al
  8038d8:	0f 84 37 02 00 00    	je     803b15 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038ed:	76 38                	jbe    803927 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038ef:	83 ec 0c             	sub    $0xc,%esp
  8038f2:	ff 75 08             	pushl  0x8(%ebp)
  8038f5:	e8 0c fa ff ff       	call   803306 <free_block>
  8038fa:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038fd:	83 ec 0c             	sub    $0xc,%esp
  803900:	ff 75 0c             	pushl  0xc(%ebp)
  803903:	e8 3a eb ff ff       	call   802442 <alloc_block_FF>
  803908:	83 c4 10             	add    $0x10,%esp
  80390b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80390e:	83 ec 08             	sub    $0x8,%esp
  803911:	ff 75 c0             	pushl  -0x40(%ebp)
  803914:	ff 75 08             	pushl  0x8(%ebp)
  803917:	e8 ab fa ff ff       	call   8033c7 <copy_data>
  80391c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80391f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803922:	e9 f8 01 00 00       	jmp    803b1f <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803927:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80392d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803930:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803934:	0f 87 a0 00 00 00    	ja     8039da <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80393a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80393e:	75 17                	jne    803957 <realloc_block_FF+0x551>
  803940:	83 ec 04             	sub    $0x4,%esp
  803943:	68 bf 46 80 00       	push   $0x8046bf
  803948:	68 38 02 00 00       	push   $0x238
  80394d:	68 dd 46 80 00       	push   $0x8046dd
  803952:	e8 cb ca ff ff       	call   800422 <_panic>
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 10                	je     803970 <realloc_block_FF+0x56a>
  803960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803968:	8b 52 04             	mov    0x4(%edx),%edx
  80396b:	89 50 04             	mov    %edx,0x4(%eax)
  80396e:	eb 0b                	jmp    80397b <realloc_block_FF+0x575>
  803970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	a3 34 50 80 00       	mov    %eax,0x805034
  80397b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397e:	8b 40 04             	mov    0x4(%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 0f                	je     803994 <realloc_block_FF+0x58e>
  803985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80398e:	8b 12                	mov    (%edx),%edx
  803990:	89 10                	mov    %edx,(%eax)
  803992:	eb 0a                	jmp    80399e <realloc_block_FF+0x598>
  803994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803997:	8b 00                	mov    (%eax),%eax
  803999:	a3 30 50 80 00       	mov    %eax,0x805030
  80399e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039b6:	48                   	dec    %eax
  8039b7:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c2:	01 d0                	add    %edx,%eax
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	6a 01                	push   $0x1
  8039c9:	50                   	push   %eax
  8039ca:	ff 75 08             	pushl  0x8(%ebp)
  8039cd:	e8 41 ea ff ff       	call   802413 <set_block_data>
  8039d2:	83 c4 10             	add    $0x10,%esp
  8039d5:	e9 36 01 00 00       	jmp    803b10 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039e0:	01 d0                	add    %edx,%eax
  8039e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039e5:	83 ec 04             	sub    $0x4,%esp
  8039e8:	6a 01                	push   $0x1
  8039ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ed:	ff 75 08             	pushl  0x8(%ebp)
  8039f0:	e8 1e ea ff ff       	call   802413 <set_block_data>
  8039f5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	83 e8 04             	sub    $0x4,%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	83 e0 fe             	and    $0xfffffffe,%eax
  803a03:	89 c2                	mov    %eax,%edx
  803a05:	8b 45 08             	mov    0x8(%ebp),%eax
  803a08:	01 d0                	add    %edx,%eax
  803a0a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a11:	74 06                	je     803a19 <realloc_block_FF+0x613>
  803a13:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a17:	75 17                	jne    803a30 <realloc_block_FF+0x62a>
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	68 50 47 80 00       	push   $0x804750
  803a21:	68 44 02 00 00       	push   $0x244
  803a26:	68 dd 46 80 00       	push   $0x8046dd
  803a2b:	e8 f2 c9 ff ff       	call   800422 <_panic>
  803a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a33:	8b 10                	mov    (%eax),%edx
  803a35:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a38:	89 10                	mov    %edx,(%eax)
  803a3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	74 0b                	je     803a4e <realloc_block_FF+0x648>
  803a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a4b:	89 50 04             	mov    %edx,0x4(%eax)
  803a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a51:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a54:	89 10                	mov    %edx,(%eax)
  803a56:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a5c:	89 50 04             	mov    %edx,0x4(%eax)
  803a5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a62:	8b 00                	mov    (%eax),%eax
  803a64:	85 c0                	test   %eax,%eax
  803a66:	75 08                	jne    803a70 <realloc_block_FF+0x66a>
  803a68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a6b:	a3 34 50 80 00       	mov    %eax,0x805034
  803a70:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a75:	40                   	inc    %eax
  803a76:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a7f:	75 17                	jne    803a98 <realloc_block_FF+0x692>
  803a81:	83 ec 04             	sub    $0x4,%esp
  803a84:	68 bf 46 80 00       	push   $0x8046bf
  803a89:	68 45 02 00 00       	push   $0x245
  803a8e:	68 dd 46 80 00       	push   $0x8046dd
  803a93:	e8 8a c9 ff ff       	call   800422 <_panic>
  803a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9b:	8b 00                	mov    (%eax),%eax
  803a9d:	85 c0                	test   %eax,%eax
  803a9f:	74 10                	je     803ab1 <realloc_block_FF+0x6ab>
  803aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa9:	8b 52 04             	mov    0x4(%edx),%edx
  803aac:	89 50 04             	mov    %edx,0x4(%eax)
  803aaf:	eb 0b                	jmp    803abc <realloc_block_FF+0x6b6>
  803ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab4:	8b 40 04             	mov    0x4(%eax),%eax
  803ab7:	a3 34 50 80 00       	mov    %eax,0x805034
  803abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abf:	8b 40 04             	mov    0x4(%eax),%eax
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	74 0f                	je     803ad5 <realloc_block_FF+0x6cf>
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	8b 40 04             	mov    0x4(%eax),%eax
  803acc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803acf:	8b 12                	mov    (%edx),%edx
  803ad1:	89 10                	mov    %edx,(%eax)
  803ad3:	eb 0a                	jmp    803adf <realloc_block_FF+0x6d9>
  803ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	a3 30 50 80 00       	mov    %eax,0x805030
  803adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803af7:	48                   	dec    %eax
  803af8:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803afd:	83 ec 04             	sub    $0x4,%esp
  803b00:	6a 00                	push   $0x0
  803b02:	ff 75 bc             	pushl  -0x44(%ebp)
  803b05:	ff 75 b8             	pushl  -0x48(%ebp)
  803b08:	e8 06 e9 ff ff       	call   802413 <set_block_data>
  803b0d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b10:	8b 45 08             	mov    0x8(%ebp),%eax
  803b13:	eb 0a                	jmp    803b1f <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b15:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b1f:	c9                   	leave  
  803b20:	c3                   	ret    

00803b21 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b21:	55                   	push   %ebp
  803b22:	89 e5                	mov    %esp,%ebp
  803b24:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b27:	83 ec 04             	sub    $0x4,%esp
  803b2a:	68 d4 47 80 00       	push   $0x8047d4
  803b2f:	68 58 02 00 00       	push   $0x258
  803b34:	68 dd 46 80 00       	push   $0x8046dd
  803b39:	e8 e4 c8 ff ff       	call   800422 <_panic>

00803b3e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b3e:	55                   	push   %ebp
  803b3f:	89 e5                	mov    %esp,%ebp
  803b41:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b44:	83 ec 04             	sub    $0x4,%esp
  803b47:	68 fc 47 80 00       	push   $0x8047fc
  803b4c:	68 61 02 00 00       	push   $0x261
  803b51:	68 dd 46 80 00       	push   $0x8046dd
  803b56:	e8 c7 c8 ff ff       	call   800422 <_panic>
  803b5b:	90                   	nop

00803b5c <__udivdi3>:
  803b5c:	55                   	push   %ebp
  803b5d:	57                   	push   %edi
  803b5e:	56                   	push   %esi
  803b5f:	53                   	push   %ebx
  803b60:	83 ec 1c             	sub    $0x1c,%esp
  803b63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b73:	89 ca                	mov    %ecx,%edx
  803b75:	89 f8                	mov    %edi,%eax
  803b77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b7b:	85 f6                	test   %esi,%esi
  803b7d:	75 2d                	jne    803bac <__udivdi3+0x50>
  803b7f:	39 cf                	cmp    %ecx,%edi
  803b81:	77 65                	ja     803be8 <__udivdi3+0x8c>
  803b83:	89 fd                	mov    %edi,%ebp
  803b85:	85 ff                	test   %edi,%edi
  803b87:	75 0b                	jne    803b94 <__udivdi3+0x38>
  803b89:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8e:	31 d2                	xor    %edx,%edx
  803b90:	f7 f7                	div    %edi
  803b92:	89 c5                	mov    %eax,%ebp
  803b94:	31 d2                	xor    %edx,%edx
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	f7 f5                	div    %ebp
  803b9a:	89 c1                	mov    %eax,%ecx
  803b9c:	89 d8                	mov    %ebx,%eax
  803b9e:	f7 f5                	div    %ebp
  803ba0:	89 cf                	mov    %ecx,%edi
  803ba2:	89 fa                	mov    %edi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	39 ce                	cmp    %ecx,%esi
  803bae:	77 28                	ja     803bd8 <__udivdi3+0x7c>
  803bb0:	0f bd fe             	bsr    %esi,%edi
  803bb3:	83 f7 1f             	xor    $0x1f,%edi
  803bb6:	75 40                	jne    803bf8 <__udivdi3+0x9c>
  803bb8:	39 ce                	cmp    %ecx,%esi
  803bba:	72 0a                	jb     803bc6 <__udivdi3+0x6a>
  803bbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc0:	0f 87 9e 00 00 00    	ja     803c64 <__udivdi3+0x108>
  803bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcb:	89 fa                	mov    %edi,%edx
  803bcd:	83 c4 1c             	add    $0x1c,%esp
  803bd0:	5b                   	pop    %ebx
  803bd1:	5e                   	pop    %esi
  803bd2:	5f                   	pop    %edi
  803bd3:	5d                   	pop    %ebp
  803bd4:	c3                   	ret    
  803bd5:	8d 76 00             	lea    0x0(%esi),%esi
  803bd8:	31 ff                	xor    %edi,%edi
  803bda:	31 c0                	xor    %eax,%eax
  803bdc:	89 fa                	mov    %edi,%edx
  803bde:	83 c4 1c             	add    $0x1c,%esp
  803be1:	5b                   	pop    %ebx
  803be2:	5e                   	pop    %esi
  803be3:	5f                   	pop    %edi
  803be4:	5d                   	pop    %ebp
  803be5:	c3                   	ret    
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	89 d8                	mov    %ebx,%eax
  803bea:	f7 f7                	div    %edi
  803bec:	31 ff                	xor    %edi,%edi
  803bee:	89 fa                	mov    %edi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bfd:	89 eb                	mov    %ebp,%ebx
  803bff:	29 fb                	sub    %edi,%ebx
  803c01:	89 f9                	mov    %edi,%ecx
  803c03:	d3 e6                	shl    %cl,%esi
  803c05:	89 c5                	mov    %eax,%ebp
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 ed                	shr    %cl,%ebp
  803c0b:	89 e9                	mov    %ebp,%ecx
  803c0d:	09 f1                	or     %esi,%ecx
  803c0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c13:	89 f9                	mov    %edi,%ecx
  803c15:	d3 e0                	shl    %cl,%eax
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 d6                	mov    %edx,%esi
  803c1b:	88 d9                	mov    %bl,%cl
  803c1d:	d3 ee                	shr    %cl,%esi
  803c1f:	89 f9                	mov    %edi,%ecx
  803c21:	d3 e2                	shl    %cl,%edx
  803c23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c27:	88 d9                	mov    %bl,%cl
  803c29:	d3 e8                	shr    %cl,%eax
  803c2b:	09 c2                	or     %eax,%edx
  803c2d:	89 d0                	mov    %edx,%eax
  803c2f:	89 f2                	mov    %esi,%edx
  803c31:	f7 74 24 0c          	divl   0xc(%esp)
  803c35:	89 d6                	mov    %edx,%esi
  803c37:	89 c3                	mov    %eax,%ebx
  803c39:	f7 e5                	mul    %ebp
  803c3b:	39 d6                	cmp    %edx,%esi
  803c3d:	72 19                	jb     803c58 <__udivdi3+0xfc>
  803c3f:	74 0b                	je     803c4c <__udivdi3+0xf0>
  803c41:	89 d8                	mov    %ebx,%eax
  803c43:	31 ff                	xor    %edi,%edi
  803c45:	e9 58 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c50:	89 f9                	mov    %edi,%ecx
  803c52:	d3 e2                	shl    %cl,%edx
  803c54:	39 c2                	cmp    %eax,%edx
  803c56:	73 e9                	jae    803c41 <__udivdi3+0xe5>
  803c58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c5b:	31 ff                	xor    %edi,%edi
  803c5d:	e9 40 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	31 c0                	xor    %eax,%eax
  803c66:	e9 37 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c6b:	90                   	nop

00803c6c <__umoddi3>:
  803c6c:	55                   	push   %ebp
  803c6d:	57                   	push   %edi
  803c6e:	56                   	push   %esi
  803c6f:	53                   	push   %ebx
  803c70:	83 ec 1c             	sub    $0x1c,%esp
  803c73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c8b:	89 f3                	mov    %esi,%ebx
  803c8d:	89 fa                	mov    %edi,%edx
  803c8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c93:	89 34 24             	mov    %esi,(%esp)
  803c96:	85 c0                	test   %eax,%eax
  803c98:	75 1a                	jne    803cb4 <__umoddi3+0x48>
  803c9a:	39 f7                	cmp    %esi,%edi
  803c9c:	0f 86 a2 00 00 00    	jbe    803d44 <__umoddi3+0xd8>
  803ca2:	89 c8                	mov    %ecx,%eax
  803ca4:	89 f2                	mov    %esi,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d0                	mov    %edx,%eax
  803caa:	31 d2                	xor    %edx,%edx
  803cac:	83 c4 1c             	add    $0x1c,%esp
  803caf:	5b                   	pop    %ebx
  803cb0:	5e                   	pop    %esi
  803cb1:	5f                   	pop    %edi
  803cb2:	5d                   	pop    %ebp
  803cb3:	c3                   	ret    
  803cb4:	39 f0                	cmp    %esi,%eax
  803cb6:	0f 87 ac 00 00 00    	ja     803d68 <__umoddi3+0xfc>
  803cbc:	0f bd e8             	bsr    %eax,%ebp
  803cbf:	83 f5 1f             	xor    $0x1f,%ebp
  803cc2:	0f 84 ac 00 00 00    	je     803d74 <__umoddi3+0x108>
  803cc8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ccd:	29 ef                	sub    %ebp,%edi
  803ccf:	89 fe                	mov    %edi,%esi
  803cd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 e0                	shl    %cl,%eax
  803cd9:	89 d7                	mov    %edx,%edi
  803cdb:	89 f1                	mov    %esi,%ecx
  803cdd:	d3 ef                	shr    %cl,%edi
  803cdf:	09 c7                	or     %eax,%edi
  803ce1:	89 e9                	mov    %ebp,%ecx
  803ce3:	d3 e2                	shl    %cl,%edx
  803ce5:	89 14 24             	mov    %edx,(%esp)
  803ce8:	89 d8                	mov    %ebx,%eax
  803cea:	d3 e0                	shl    %cl,%eax
  803cec:	89 c2                	mov    %eax,%edx
  803cee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf2:	d3 e0                	shl    %cl,%eax
  803cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfc:	89 f1                	mov    %esi,%ecx
  803cfe:	d3 e8                	shr    %cl,%eax
  803d00:	09 d0                	or     %edx,%eax
  803d02:	d3 eb                	shr    %cl,%ebx
  803d04:	89 da                	mov    %ebx,%edx
  803d06:	f7 f7                	div    %edi
  803d08:	89 d3                	mov    %edx,%ebx
  803d0a:	f7 24 24             	mull   (%esp)
  803d0d:	89 c6                	mov    %eax,%esi
  803d0f:	89 d1                	mov    %edx,%ecx
  803d11:	39 d3                	cmp    %edx,%ebx
  803d13:	0f 82 87 00 00 00    	jb     803da0 <__umoddi3+0x134>
  803d19:	0f 84 91 00 00 00    	je     803db0 <__umoddi3+0x144>
  803d1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d23:	29 f2                	sub    %esi,%edx
  803d25:	19 cb                	sbb    %ecx,%ebx
  803d27:	89 d8                	mov    %ebx,%eax
  803d29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d2d:	d3 e0                	shl    %cl,%eax
  803d2f:	89 e9                	mov    %ebp,%ecx
  803d31:	d3 ea                	shr    %cl,%edx
  803d33:	09 d0                	or     %edx,%eax
  803d35:	89 e9                	mov    %ebp,%ecx
  803d37:	d3 eb                	shr    %cl,%ebx
  803d39:	89 da                	mov    %ebx,%edx
  803d3b:	83 c4 1c             	add    $0x1c,%esp
  803d3e:	5b                   	pop    %ebx
  803d3f:	5e                   	pop    %esi
  803d40:	5f                   	pop    %edi
  803d41:	5d                   	pop    %ebp
  803d42:	c3                   	ret    
  803d43:	90                   	nop
  803d44:	89 fd                	mov    %edi,%ebp
  803d46:	85 ff                	test   %edi,%edi
  803d48:	75 0b                	jne    803d55 <__umoddi3+0xe9>
  803d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4f:	31 d2                	xor    %edx,%edx
  803d51:	f7 f7                	div    %edi
  803d53:	89 c5                	mov    %eax,%ebp
  803d55:	89 f0                	mov    %esi,%eax
  803d57:	31 d2                	xor    %edx,%edx
  803d59:	f7 f5                	div    %ebp
  803d5b:	89 c8                	mov    %ecx,%eax
  803d5d:	f7 f5                	div    %ebp
  803d5f:	89 d0                	mov    %edx,%eax
  803d61:	e9 44 ff ff ff       	jmp    803caa <__umoddi3+0x3e>
  803d66:	66 90                	xchg   %ax,%ax
  803d68:	89 c8                	mov    %ecx,%eax
  803d6a:	89 f2                	mov    %esi,%edx
  803d6c:	83 c4 1c             	add    $0x1c,%esp
  803d6f:	5b                   	pop    %ebx
  803d70:	5e                   	pop    %esi
  803d71:	5f                   	pop    %edi
  803d72:	5d                   	pop    %ebp
  803d73:	c3                   	ret    
  803d74:	3b 04 24             	cmp    (%esp),%eax
  803d77:	72 06                	jb     803d7f <__umoddi3+0x113>
  803d79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d7d:	77 0f                	ja     803d8e <__umoddi3+0x122>
  803d7f:	89 f2                	mov    %esi,%edx
  803d81:	29 f9                	sub    %edi,%ecx
  803d83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d87:	89 14 24             	mov    %edx,(%esp)
  803d8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d92:	8b 14 24             	mov    (%esp),%edx
  803d95:	83 c4 1c             	add    $0x1c,%esp
  803d98:	5b                   	pop    %ebx
  803d99:	5e                   	pop    %esi
  803d9a:	5f                   	pop    %edi
  803d9b:	5d                   	pop    %ebp
  803d9c:	c3                   	ret    
  803d9d:	8d 76 00             	lea    0x0(%esi),%esi
  803da0:	2b 04 24             	sub    (%esp),%eax
  803da3:	19 fa                	sbb    %edi,%edx
  803da5:	89 d1                	mov    %edx,%ecx
  803da7:	89 c6                	mov    %eax,%esi
  803da9:	e9 71 ff ff ff       	jmp    803d1f <__umoddi3+0xb3>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db4:	72 ea                	jb     803da0 <__umoddi3+0x134>
  803db6:	89 d9                	mov    %ebx,%ecx
  803db8:	e9 62 ff ff ff       	jmp    803d1f <__umoddi3+0xb3>
