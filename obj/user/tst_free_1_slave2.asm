
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
  800060:	68 80 3c 80 00       	push   $0x803c80
  800065:	6a 12                	push   $0x12
  800067:	68 9c 3c 80 00       	push   $0x803c9c
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
  8000bc:	e8 b0 19 00 00       	call   801a71 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 f3 19 00 00       	call   801abc <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 b8 3c 80 00       	push   $0x803cb8
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 9c 3c 80 00       	push   $0x803c9c
  800100:	e8 1d 03 00 00       	call   800422 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 b2 19 00 00       	call   801abc <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 e8 3c 80 00       	push   $0x803ce8
  800117:	6a 32                	push   $0x32
  800119:	68 9c 3c 80 00       	push   $0x803c9c
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 49 19 00 00       	call   801a71 <sys_calculate_free_frames>
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
  80015f:	e8 0d 19 00 00       	call   801a71 <sys_calculate_free_frames>
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
  80017c:	68 18 3d 80 00       	push   $0x803d18
  800181:	6a 3c                	push   $0x3c
  800183:	68 9c 3c 80 00       	push   $0x803c9c
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
  8001c7:	e8 00 1d 00 00       	call   801ecc <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 94 3d 80 00       	push   $0x803d94
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 9c 3c 80 00       	push   $0x803c9c
  8001e7:	e8 36 02 00 00       	call   800422 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 80 18 00 00       	call   801a71 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 c3 18 00 00       	call   801abc <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 a9 18 00 00       	call   801abc <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 b4 3d 80 00       	push   $0x803db4
  800220:	6a 4d                	push   $0x4d
  800222:	68 9c 3c 80 00       	push   $0x803c9c
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 40 18 00 00       	call   801a71 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 f0 3d 80 00       	push   $0x803df0
  800247:	6a 4e                	push   $0x4e
  800249:	68 9c 3c 80 00       	push   $0x803c9c
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
  80028d:	e8 3a 1c 00 00       	call   801ecc <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 3c 3e 80 00       	push   $0x803e3c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 9c 3c 80 00       	push   $0x803c9c
  8002ad:	e8 70 01 00 00       	call   800422 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 c1 1a 00 00       	call   801d78 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 d5 1a 00 00       	call   801d92 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 a9 1a 00 00       	call   801d78 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 60 3e 80 00       	push   $0x803e60
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 9c 3c 80 00       	push   $0x803c9c
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
  8002e9:	e8 4c 19 00 00       	call   801c3a <sys_getenvindex>
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
  800357:	e8 62 16 00 00       	call   8019be <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 c4 3e 80 00       	push   $0x803ec4
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
  800387:	68 ec 3e 80 00       	push   $0x803eec
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
  8003b8:	68 14 3f 80 00       	push   $0x803f14
  8003bd:	e8 1d 03 00 00       	call   8006df <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	50                   	push   %eax
  8003d4:	68 6c 3f 80 00       	push   $0x803f6c
  8003d9:	e8 01 03 00 00       	call   8006df <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 c4 3e 80 00       	push   $0x803ec4
  8003e9:	e8 f1 02 00 00       	call   8006df <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f1:	e8 e2 15 00 00       	call   8019d8 <sys_unlock_cons>
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
  800409:	e8 f8 17 00 00       	call   801c06 <sys_destroy_env>
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
  80041a:	e8 4d 18 00 00       	call   801c6c <sys_exit_env>
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
  800431:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800436:	85 c0                	test   %eax,%eax
  800438:	74 16                	je     800450 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80043a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	50                   	push   %eax
  800443:	68 80 3f 80 00       	push   $0x803f80
  800448:	e8 92 02 00 00       	call   8006df <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800450:	a1 00 50 80 00       	mov    0x805000,%eax
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	50                   	push   %eax
  80045c:	68 85 3f 80 00       	push   $0x803f85
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
  800480:	68 a1 3f 80 00       	push   $0x803fa1
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
  8004af:	68 a4 3f 80 00       	push   $0x803fa4
  8004b4:	6a 26                	push   $0x26
  8004b6:	68 f0 3f 80 00       	push   $0x803ff0
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
  800584:	68 fc 3f 80 00       	push   $0x803ffc
  800589:	6a 3a                	push   $0x3a
  80058b:	68 f0 3f 80 00       	push   $0x803ff0
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
  8005f7:	68 50 40 80 00       	push   $0x804050
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 f0 3f 80 00       	push   $0x803ff0
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
  800636:	a0 28 50 80 00       	mov    0x805028,%al
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
  800651:	e8 26 13 00 00       	call   80197c <sys_cputs>
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
  8006ab:	a0 28 50 80 00       	mov    0x805028,%al
  8006b0:	0f b6 c0             	movzbl %al,%eax
  8006b3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	52                   	push   %edx
  8006be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c4:	83 c0 08             	add    $0x8,%eax
  8006c7:	50                   	push   %eax
  8006c8:	e8 af 12 00 00       	call   80197c <sys_cputs>
  8006cd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006d0:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  8006e5:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800712:	e8 a7 12 00 00       	call   8019be <sys_lock_cons>
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
  800732:	e8 a1 12 00 00       	call   8019d8 <sys_unlock_cons>
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
  80077c:	e8 93 32 00 00       	call   803a14 <__udivdi3>
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
  8007cc:	e8 53 33 00 00       	call   803b24 <__umoddi3>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  800927:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  800a08:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	75 19                	jne    800a2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a13:	53                   	push   %ebx
  800a14:	68 c5 42 80 00       	push   $0x8042c5
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
  800a2d:	68 ce 42 80 00       	push   $0x8042ce
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
  800a5a:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  800c52:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c59:	eb 2c                	jmp    800c87 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c5b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  801465:	68 48 44 80 00       	push   $0x804448
  80146a:	68 3f 01 00 00       	push   $0x13f
  80146f:	68 6a 44 80 00       	push   $0x80446a
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
  801485:	e8 9d 0a 00 00       	call   801f27 <sys_sbrk>
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
  801500:	e8 a6 08 00 00       	call   801dab <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 e6 0d 00 00       	call   8022fa <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 b8 08 00 00       	call   801ddc <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 7f 12 00 00       	call   8027b6 <alloc_block_BF>
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
  801582:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8015cf:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801626:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801688:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	e8 c1 08 00 00       	call   801f5e <sys_allocate_user_mem>
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
  8016e0:	e8 95 08 00 00       	call   801f7a <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 c8 1a 00 00       	call   8031be <free_block>
  8016f6:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  80172b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801732:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801738:	c1 e0 0c             	shl    $0xc,%eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80173e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801745:	eb 2f                	jmp    801776 <free+0xc8>
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
  801768:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  80176f:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801773:	ff 45 f4             	incl   -0xc(%ebp)
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80177c:	72 c9                	jb     801747 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	ff 75 ec             	pushl  -0x14(%ebp)
  801787:	50                   	push   %eax
  801788:	e8 b5 07 00 00       	call   801f42 <sys_free_user_mem>
  80178d:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801790:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801791:	eb 17                	jmp    8017aa <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 78 44 80 00       	push   $0x804478
  80179b:	68 84 00 00 00       	push   $0x84
  8017a0:	68 a2 44 80 00       	push   $0x8044a2
  8017a5:	e8 78 ec ff ff       	call   800422 <_panic>
	}
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 28             	sub    $0x28,%esp
  8017b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b5:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8017b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017bc:	75 07                	jne    8017c5 <smalloc+0x19>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	eb 74                	jmp    801839 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	39 d0                	cmp    %edx,%eax
  8017da:	73 02                	jae    8017de <smalloc+0x32>
  8017dc:	89 d0                	mov    %edx,%eax
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	50                   	push   %eax
  8017e2:	e8 a8 fc ff ff       	call   80148f <malloc>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f1:	75 07                	jne    8017fa <smalloc+0x4e>
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	eb 3f                	jmp    801839 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017fa:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801801:	50                   	push   %eax
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	e8 3c 03 00 00       	call   801b49 <sys_createSharedObject>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801813:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801817:	74 06                	je     80181f <smalloc+0x73>
  801819:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80181d:	75 07                	jne    801826 <smalloc+0x7a>
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb 13                	jmp    801839 <smalloc+0x8d>
	 cprintf("153\n");
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	68 ae 44 80 00       	push   $0x8044ae
  80182e:	e8 ac ee ff ff       	call   8006df <cprintf>
  801833:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801836:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	e8 24 03 00 00       	call   801b73 <sys_getSizeOfSharedObject>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801855:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801859:	75 07                	jne    801862 <sget+0x27>
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
  801860:	eb 5c                	jmp    8018be <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801868:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80186f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801875:	39 d0                	cmp    %edx,%eax
  801877:	7d 02                	jge    80187b <sget+0x40>
  801879:	89 d0                	mov    %edx,%eax
  80187b:	83 ec 0c             	sub    $0xc,%esp
  80187e:	50                   	push   %eax
  80187f:	e8 0b fc ff ff       	call   80148f <malloc>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80188a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80188e:	75 07                	jne    801897 <sget+0x5c>
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	eb 27                	jmp    8018be <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	ff 75 e8             	pushl  -0x18(%ebp)
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 e8 02 00 00       	call   801b90 <sys_getSharedObject>
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018ae:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018b2:	75 07                	jne    8018bb <sget+0x80>
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	eb 03                	jmp    8018be <sget+0x83>
	return ptr;
  8018bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 b4 44 80 00       	push   $0x8044b4
  8018ce:	68 c2 00 00 00       	push   $0xc2
  8018d3:	68 a2 44 80 00       	push   $0x8044a2
  8018d8:	e8 45 eb ff ff       	call   800422 <_panic>

008018dd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 d8 44 80 00       	push   $0x8044d8
  8018eb:	68 d9 00 00 00       	push   $0xd9
  8018f0:	68 a2 44 80 00       	push   $0x8044a2
  8018f5:	e8 28 eb ff ff       	call   800422 <_panic>

008018fa <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	68 fe 44 80 00       	push   $0x8044fe
  801908:	68 e5 00 00 00       	push   $0xe5
  80190d:	68 a2 44 80 00       	push   $0x8044a2
  801912:	e8 0b eb ff ff       	call   800422 <_panic>

00801917 <shrink>:

}
void shrink(uint32 newSize)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	68 fe 44 80 00       	push   $0x8044fe
  801925:	68 ea 00 00 00       	push   $0xea
  80192a:	68 a2 44 80 00       	push   $0x8044a2
  80192f:	e8 ee ea ff ff       	call   800422 <_panic>

00801934 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 fe 44 80 00       	push   $0x8044fe
  801942:	68 ef 00 00 00       	push   $0xef
  801947:	68 a2 44 80 00       	push   $0x8044a2
  80194c:	e8 d1 ea ff ff       	call   800422 <_panic>

00801951 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	57                   	push   %edi
  801955:	56                   	push   %esi
  801956:	53                   	push   %ebx
  801957:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801963:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801966:	8b 7d 18             	mov    0x18(%ebp),%edi
  801969:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80196c:	cd 30                	int    $0x30
  80196e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801971:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801988:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	52                   	push   %edx
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	6a 00                	push   $0x0
  80199a:	e8 b2 ff ff ff       	call   801951 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 02                	push   $0x2
  8019b4:	e8 98 ff ff ff       	call   801951 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 03                	push   $0x3
  8019cd:	e8 7f ff ff ff       	call   801951 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	90                   	nop
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 04                	push   $0x4
  8019e7:	e8 65 ff ff ff       	call   801951 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	6a 08                	push   $0x8
  801a05:	e8 47 ff ff ff       	call   801951 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a14:	8b 75 18             	mov    0x18(%ebp),%esi
  801a17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	56                   	push   %esi
  801a24:	53                   	push   %ebx
  801a25:	51                   	push   %ecx
  801a26:	52                   	push   %edx
  801a27:	50                   	push   %eax
  801a28:	6a 09                	push   $0x9
  801a2a:	e8 22 ff ff ff       	call   801951 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 0a                	push   $0xa
  801a4c:	e8 00 ff ff ff       	call   801951 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 0b                	push   $0xb
  801a67:	e8 e5 fe ff ff       	call   801951 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 0c                	push   $0xc
  801a80:	e8 cc fe ff ff       	call   801951 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 0d                	push   $0xd
  801a99:	e8 b3 fe ff ff       	call   801951 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 0e                	push   $0xe
  801ab2:	e8 9a fe ff ff       	call   801951 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 0f                	push   $0xf
  801acb:	e8 81 fe ff ff       	call   801951 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	6a 10                	push   $0x10
  801ae5:	e8 67 fe ff ff       	call   801951 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 11                	push   $0x11
  801afe:	e8 4e fe ff ff       	call   801951 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	50                   	push   %eax
  801b22:	6a 01                	push   $0x1
  801b24:	e8 28 fe ff ff       	call   801951 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 14                	push   $0x14
  801b3e:	e8 0e fe ff ff       	call   801951 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b52:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b55:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b58:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	51                   	push   %ecx
  801b62:	52                   	push   %edx
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	6a 15                	push   $0x15
  801b69:	e8 e3 fd ff ff       	call   801951 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 16                	push   $0x16
  801b86:	e8 c6 fd ff ff       	call   801951 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	51                   	push   %ecx
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 17                	push   $0x17
  801ba5:	e8 a7 fd ff ff       	call   801951 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 18                	push   $0x18
  801bc2:	e8 8a fd ff ff       	call   801951 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	ff 75 14             	pushl  0x14(%ebp)
  801bd7:	ff 75 10             	pushl  0x10(%ebp)
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	50                   	push   %eax
  801bde:	6a 19                	push   $0x19
  801be0:	e8 6c fd ff ff       	call   801951 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	50                   	push   %eax
  801bf9:	6a 1a                	push   $0x1a
  801bfb:	e8 51 fd ff ff       	call   801951 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	90                   	nop
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	50                   	push   %eax
  801c15:	6a 1b                	push   $0x1b
  801c17:	e8 35 fd ff ff       	call   801951 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 05                	push   $0x5
  801c30:	e8 1c fd ff ff       	call   801951 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 06                	push   $0x6
  801c49:	e8 03 fd ff ff       	call   801951 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 07                	push   $0x7
  801c62:	e8 ea fc ff ff       	call   801951 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_exit_env>:


void sys_exit_env(void)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 1c                	push   $0x1c
  801c7b:	e8 d1 fc ff ff       	call   801951 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8f:	8d 50 04             	lea    0x4(%eax),%edx
  801c92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 1d                	push   $0x1d
  801c9f:	e8 ad fc ff ff       	call   801951 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801caa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cb0:	89 01                	mov    %eax,(%ecx)
  801cb2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	c9                   	leave  
  801cb9:	c2 04 00             	ret    $0x4

00801cbc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	ff 75 10             	pushl  0x10(%ebp)
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	6a 13                	push   $0x13
  801cce:	e8 7e fc ff ff       	call   801951 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 1e                	push   $0x1e
  801ce8:	e8 64 fc ff ff       	call   801951 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cfe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	50                   	push   %eax
  801d0b:	6a 1f                	push   $0x1f
  801d0d:	e8 3f fc ff ff       	call   801951 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return ;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <rsttst>:
void rsttst()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 21                	push   $0x21
  801d27:	e8 25 fc ff ff       	call   801951 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2f:	90                   	nop
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	ff 75 10             	pushl  0x10(%ebp)
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	6a 20                	push   $0x20
  801d52:	e8 fa fb ff ff       	call   801951 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <chktst>:
void chktst(uint32 n)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	ff 75 08             	pushl  0x8(%ebp)
  801d6b:	6a 22                	push   $0x22
  801d6d:	e8 df fb ff ff       	call   801951 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return ;
  801d75:	90                   	nop
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <inctst>:

void inctst()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 23                	push   $0x23
  801d87:	e8 c5 fb ff ff       	call   801951 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8f:	90                   	nop
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <gettst>:
uint32 gettst()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 24                	push   $0x24
  801da1:	e8 ab fb ff ff       	call   801951 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 25                	push   $0x25
  801dbd:	e8 8f fb ff ff       	call   801951 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 25                	push   $0x25
  801dee:	e8 5e fb ff ff       	call   801951 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
  801df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dfd:	75 07                	jne    801e06 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
  801e04:	eb 05                	jmp    801e0b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 25                	push   $0x25
  801e1f:	e8 2d fb ff ff       	call   801951 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
  801e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e2a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e2e:	75 07                	jne    801e37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e30:	b8 01 00 00 00       	mov    $0x1,%eax
  801e35:	eb 05                	jmp    801e3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 25                	push   $0x25
  801e50:	e8 fc fa ff ff       	call   801951 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
  801e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e5b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e5f:	75 07                	jne    801e68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e61:	b8 01 00 00 00       	mov    $0x1,%eax
  801e66:	eb 05                	jmp    801e6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	6a 26                	push   $0x26
  801e7f:	e8 cd fa ff ff       	call   801951 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
	return ;
  801e87:	90                   	nop
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e8e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	53                   	push   %ebx
  801e9d:	51                   	push   %ecx
  801e9e:	52                   	push   %edx
  801e9f:	50                   	push   %eax
  801ea0:	6a 27                	push   $0x27
  801ea2:	e8 aa fa ff ff       	call   801951 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	52                   	push   %edx
  801ebf:	50                   	push   %eax
  801ec0:	6a 28                	push   $0x28
  801ec2:	e8 8a fa ff ff       	call   801951 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ecf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	6a 00                	push   $0x0
  801eda:	51                   	push   %ecx
  801edb:	ff 75 10             	pushl  0x10(%ebp)
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	6a 29                	push   $0x29
  801ee2:	e8 6a fa ff ff       	call   801951 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 10             	pushl  0x10(%ebp)
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	6a 12                	push   $0x12
  801efe:	e8 4e fa ff ff       	call   801951 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return ;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	52                   	push   %edx
  801f19:	50                   	push   %eax
  801f1a:	6a 2a                	push   $0x2a
  801f1c:	e8 30 fa ff ff       	call   801951 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
	return;
  801f24:	90                   	nop
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	50                   	push   %eax
  801f36:	6a 2b                	push   $0x2b
  801f38:	e8 14 fa ff ff       	call   801951 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	ff 75 0c             	pushl  0xc(%ebp)
  801f4e:	ff 75 08             	pushl  0x8(%ebp)
  801f51:	6a 2c                	push   $0x2c
  801f53:	e8 f9 f9 ff ff       	call   801951 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return;
  801f5b:	90                   	nop
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	6a 2d                	push   $0x2d
  801f6f:	e8 dd f9 ff ff       	call   801951 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
	return;
  801f77:	90                   	nop
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	83 e8 04             	sub    $0x4,%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	83 e8 04             	sub    $0x4,%eax
  801f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	83 e0 01             	and    $0x1,%eax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	0f 94 c0             	sete   %al
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	83 f8 02             	cmp    $0x2,%eax
  801fc4:	74 2b                	je     801ff1 <alloc_block+0x40>
  801fc6:	83 f8 02             	cmp    $0x2,%eax
  801fc9:	7f 07                	jg     801fd2 <alloc_block+0x21>
  801fcb:	83 f8 01             	cmp    $0x1,%eax
  801fce:	74 0e                	je     801fde <alloc_block+0x2d>
  801fd0:	eb 58                	jmp    80202a <alloc_block+0x79>
  801fd2:	83 f8 03             	cmp    $0x3,%eax
  801fd5:	74 2d                	je     802004 <alloc_block+0x53>
  801fd7:	83 f8 04             	cmp    $0x4,%eax
  801fda:	74 3b                	je     802017 <alloc_block+0x66>
  801fdc:	eb 4c                	jmp    80202a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	e8 11 03 00 00       	call   8022fa <alloc_block_FF>
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fef:	eb 4a                	jmp    80203b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	ff 75 08             	pushl  0x8(%ebp)
  801ff7:	e8 fa 19 00 00       	call   8039f6 <alloc_block_NF>
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802002:	eb 37                	jmp    80203b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	e8 a7 07 00 00       	call   8027b6 <alloc_block_BF>
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802015:	eb 24                	jmp    80203b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	e8 b7 19 00 00       	call   8039d9 <alloc_block_WF>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802028:	eb 11                	jmp    80203b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	68 10 45 80 00       	push   $0x804510
  802032:	e8 a8 e6 ff ff       	call   8006df <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp
		break;
  80203a:	90                   	nop
	}
	return va;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	53                   	push   %ebx
  802044:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	68 30 45 80 00       	push   $0x804530
  80204f:	e8 8b e6 ff ff       	call   8006df <cprintf>
  802054:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	68 5b 45 80 00       	push   $0x80455b
  80205f:	e8 7b e6 ff ff       	call   8006df <cprintf>
  802064:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206d:	eb 37                	jmp    8020a6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	ff 75 f4             	pushl  -0xc(%ebp)
  802075:	e8 19 ff ff ff       	call   801f93 <is_free_block>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	0f be d8             	movsbl %al,%ebx
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	ff 75 f4             	pushl  -0xc(%ebp)
  802086:	e8 ef fe ff ff       	call   801f7a <get_block_size>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	53                   	push   %ebx
  802092:	50                   	push   %eax
  802093:	68 73 45 80 00       	push   $0x804573
  802098:	e8 42 e6 ff ff       	call   8006df <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020aa:	74 07                	je     8020b3 <print_blocks_list+0x73>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	eb 05                	jmp    8020b8 <print_blocks_list+0x78>
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	89 45 10             	mov    %eax,0x10(%ebp)
  8020bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	75 ad                	jne    80206f <print_blocks_list+0x2f>
  8020c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c6:	75 a7                	jne    80206f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	68 30 45 80 00       	push   $0x804530
  8020d0:	e8 0a e6 ff ff       	call   8006df <cprintf>
  8020d5:	83 c4 10             	add    $0x10,%esp

}
  8020d8:	90                   	nop
  8020d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	83 e0 01             	and    $0x1,%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	74 03                	je     8020f1 <initialize_dynamic_allocator+0x13>
  8020ee:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020f5:	0f 84 c7 01 00 00    	je     8022c2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020fb:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802102:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802105:	8b 55 08             	mov    0x8(%ebp),%edx
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802112:	0f 87 ad 01 00 00    	ja     8022c5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 89 a5 01 00 00    	jns    8022c8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802123:	8b 55 08             	mov    0x8(%ebp),%edx
  802126:	8b 45 0c             	mov    0xc(%ebp),%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	83 e8 04             	sub    $0x4,%eax
  80212e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80213a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80213f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802142:	e9 87 00 00 00       	jmp    8021ce <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214b:	75 14                	jne    802161 <initialize_dynamic_allocator+0x83>
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	68 8b 45 80 00       	push   $0x80458b
  802155:	6a 79                	push   $0x79
  802157:	68 a9 45 80 00       	push   $0x8045a9
  80215c:	e8 c1 e2 ff ff       	call   800422 <_panic>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 00                	mov    (%eax),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 10                	je     80217a <initialize_dynamic_allocator+0x9c>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802172:	8b 52 04             	mov    0x4(%edx),%edx
  802175:	89 50 04             	mov    %edx,0x4(%eax)
  802178:	eb 0b                	jmp    802185 <initialize_dynamic_allocator+0xa7>
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 40 04             	mov    0x4(%eax),%eax
  802180:	a3 30 50 80 00       	mov    %eax,0x805030
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 40 04             	mov    0x4(%eax),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 0f                	je     80219e <initialize_dynamic_allocator+0xc0>
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 40 04             	mov    0x4(%eax),%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	8b 12                	mov    (%edx),%edx
  80219a:	89 10                	mov    %edx,(%eax)
  80219c:	eb 0a                	jmp    8021a8 <initialize_dynamic_allocator+0xca>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c0:	48                   	dec    %eax
  8021c1:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021c6:	a1 34 50 80 00       	mov    0x805034,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d2:	74 07                	je     8021db <initialize_dynamic_allocator+0xfd>
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	eb 05                	jmp    8021e0 <initialize_dynamic_allocator+0x102>
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	a3 34 50 80 00       	mov    %eax,0x805034
  8021e5:	a1 34 50 80 00       	mov    0x805034,%eax
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	0f 85 55 ff ff ff    	jne    802147 <initialize_dynamic_allocator+0x69>
  8021f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f6:	0f 85 4b ff ff ff    	jne    802147 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80220b:	a1 44 50 80 00       	mov    0x805044,%eax
  802210:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802215:	a1 40 50 80 00       	mov    0x805040,%eax
  80221a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	83 c0 08             	add    $0x8,%eax
  802226:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	83 c0 04             	add    $0x4,%eax
  80222f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802232:	83 ea 08             	sub    $0x8,%edx
  802235:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802237:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	01 d0                	add    %edx,%eax
  80223f:	83 e8 08             	sub    $0x8,%eax
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	83 ea 08             	sub    $0x8,%edx
  802248:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80224a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802256:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80225d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802261:	75 17                	jne    80227a <initialize_dynamic_allocator+0x19c>
  802263:	83 ec 04             	sub    $0x4,%esp
  802266:	68 c4 45 80 00       	push   $0x8045c4
  80226b:	68 90 00 00 00       	push   $0x90
  802270:	68 a9 45 80 00       	push   $0x8045a9
  802275:	e8 a8 e1 ff ff       	call   800422 <_panic>
  80227a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802283:	89 10                	mov    %edx,(%eax)
  802285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	85 c0                	test   %eax,%eax
  80228c:	74 0d                	je     80229b <initialize_dynamic_allocator+0x1bd>
  80228e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802293:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	eb 08                	jmp    8022a3 <initialize_dynamic_allocator+0x1c5>
  80229b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229e:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ba:	40                   	inc    %eax
  8022bb:	a3 38 50 80 00       	mov    %eax,0x805038
  8022c0:	eb 07                	jmp    8022c9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022c2:	90                   	nop
  8022c3:	eb 04                	jmp    8022c9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022c5:	90                   	nop
  8022c6:	eb 01                	jmp    8022c9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022c8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d1:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022dd:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	83 e8 04             	sub    $0x4,%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8022ea:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	01 c2                	add    %eax,%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	89 02                	mov    %eax,(%edx)
}
  8022f7:	90                   	nop
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    

008022fa <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	83 e0 01             	and    $0x1,%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	74 03                	je     80230d <alloc_block_FF+0x13>
  80230a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80230d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802311:	77 07                	ja     80231a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802313:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80231a:	a1 24 50 80 00       	mov    0x805024,%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	75 73                	jne    802396 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	83 c0 10             	add    $0x10,%eax
  802329:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80232c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802333:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802339:	01 d0                	add    %edx,%eax
  80233b:	48                   	dec    %eax
  80233c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80233f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802342:	ba 00 00 00 00       	mov    $0x0,%edx
  802347:	f7 75 ec             	divl   -0x14(%ebp)
  80234a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80234d:	29 d0                	sub    %edx,%eax
  80234f:	c1 e8 0c             	shr    $0xc,%eax
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	50                   	push   %eax
  802356:	e8 1e f1 ff ff       	call   801479 <sbrk>
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	6a 00                	push   $0x0
  802366:	e8 0e f1 ff ff       	call   801479 <sbrk>
  80236b:	83 c4 10             	add    $0x10,%esp
  80236e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802374:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802377:	83 ec 08             	sub    $0x8,%esp
  80237a:	50                   	push   %eax
  80237b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80237e:	e8 5b fd ff ff       	call   8020de <initialize_dynamic_allocator>
  802383:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	68 e7 45 80 00       	push   $0x8045e7
  80238e:	e8 4c e3 ff ff       	call   8006df <cprintf>
  802393:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239a:	75 0a                	jne    8023a6 <alloc_block_FF+0xac>
	        return NULL;
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a1:	e9 0e 04 00 00       	jmp    8027b4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b5:	e9 f3 02 00 00       	jmp    8026ad <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c6:	e8 af fb ff ff       	call   801f7a <get_block_size>
  8023cb:	83 c4 10             	add    $0x10,%esp
  8023ce:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	83 c0 08             	add    $0x8,%eax
  8023d7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023da:	0f 87 c5 02 00 00    	ja     8026a5 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 c0 18             	add    $0x18,%eax
  8023e6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023e9:	0f 87 19 02 00 00    	ja     802608 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8023f5:	83 e8 08             	sub    $0x8,%eax
  8023f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	8d 50 08             	lea    0x8(%eax),%edx
  802401:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802404:	01 d0                	add    %edx,%eax
  802406:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	83 c0 08             	add    $0x8,%eax
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	6a 01                	push   $0x1
  802414:	50                   	push   %eax
  802415:	ff 75 bc             	pushl  -0x44(%ebp)
  802418:	e8 ae fe ff ff       	call   8022cb <set_block_data>
  80241d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 04             	mov    0x4(%eax),%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	75 68                	jne    802492 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80242a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80242e:	75 17                	jne    802447 <alloc_block_FF+0x14d>
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 c4 45 80 00       	push   $0x8045c4
  802438:	68 d7 00 00 00       	push   $0xd7
  80243d:	68 a9 45 80 00       	push   $0x8045a9
  802442:	e8 db df ff ff       	call   800422 <_panic>
  802447:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80244d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802450:	89 10                	mov    %edx,(%eax)
  802452:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	85 c0                	test   %eax,%eax
  802459:	74 0d                	je     802468 <alloc_block_FF+0x16e>
  80245b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802460:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	eb 08                	jmp    802470 <alloc_block_FF+0x176>
  802468:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246b:	a3 30 50 80 00       	mov    %eax,0x805030
  802470:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802473:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802478:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802482:	a1 38 50 80 00       	mov    0x805038,%eax
  802487:	40                   	inc    %eax
  802488:	a3 38 50 80 00       	mov    %eax,0x805038
  80248d:	e9 dc 00 00 00       	jmp    80256e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 65                	jne    802500 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80249b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80249f:	75 17                	jne    8024b8 <alloc_block_FF+0x1be>
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 f8 45 80 00       	push   $0x8045f8
  8024a9:	68 db 00 00 00       	push   $0xdb
  8024ae:	68 a9 45 80 00       	push   $0x8045a9
  8024b3:	e8 6a df ff ff       	call   800422 <_panic>
  8024b8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c1:	89 50 04             	mov    %edx,0x4(%eax)
  8024c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 0c                	je     8024da <alloc_block_FF+0x1e0>
  8024ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8024d3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d6:	89 10                	mov    %edx,(%eax)
  8024d8:	eb 08                	jmp    8024e2 <alloc_block_FF+0x1e8>
  8024da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f8:	40                   	inc    %eax
  8024f9:	a3 38 50 80 00       	mov    %eax,0x805038
  8024fe:	eb 6e                	jmp    80256e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802504:	74 06                	je     80250c <alloc_block_FF+0x212>
  802506:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80250a:	75 17                	jne    802523 <alloc_block_FF+0x229>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 1c 46 80 00       	push   $0x80461c
  802514:	68 df 00 00 00       	push   $0xdf
  802519:	68 a9 45 80 00       	push   $0x8045a9
  80251e:	e8 ff de ff ff       	call   800422 <_panic>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 10                	mov    (%eax),%edx
  802528:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252b:	89 10                	mov    %edx,(%eax)
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 0b                	je     802541 <alloc_block_FF+0x247>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80253e:	89 50 04             	mov    %edx,0x4(%eax)
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802547:	89 10                	mov    %edx,(%eax)
  802549:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	89 50 04             	mov    %edx,0x4(%eax)
  802552:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	75 08                	jne    802563 <alloc_block_FF+0x269>
  80255b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255e:	a3 30 50 80 00       	mov    %eax,0x805030
  802563:	a1 38 50 80 00       	mov    0x805038,%eax
  802568:	40                   	inc    %eax
  802569:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80256e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802572:	75 17                	jne    80258b <alloc_block_FF+0x291>
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 8b 45 80 00       	push   $0x80458b
  80257c:	68 e1 00 00 00       	push   $0xe1
  802581:	68 a9 45 80 00       	push   $0x8045a9
  802586:	e8 97 de ff ff       	call   800422 <_panic>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 10                	je     8025a4 <alloc_block_FF+0x2aa>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259c:	8b 52 04             	mov    0x4(%edx),%edx
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	eb 0b                	jmp    8025af <alloc_block_FF+0x2b5>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 0f                	je     8025c8 <alloc_block_FF+0x2ce>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c2:	8b 12                	mov    (%edx),%edx
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	eb 0a                	jmp    8025d2 <alloc_block_FF+0x2d8>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	6a 00                	push   $0x0
  8025f5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025f8:	ff 75 b0             	pushl  -0x50(%ebp)
  8025fb:	e8 cb fc ff ff       	call   8022cb <set_block_data>
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	e9 95 00 00 00       	jmp    80269d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	6a 01                	push   $0x1
  80260d:	ff 75 b8             	pushl  -0x48(%ebp)
  802610:	ff 75 bc             	pushl  -0x44(%ebp)
  802613:	e8 b3 fc ff ff       	call   8022cb <set_block_data>
  802618:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80261b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261f:	75 17                	jne    802638 <alloc_block_FF+0x33e>
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 8b 45 80 00       	push   $0x80458b
  802629:	68 e8 00 00 00       	push   $0xe8
  80262e:	68 a9 45 80 00       	push   $0x8045a9
  802633:	e8 ea dd ff ff       	call   800422 <_panic>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 10                	je     802651 <alloc_block_FF+0x357>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802649:	8b 52 04             	mov    0x4(%edx),%edx
  80264c:	89 50 04             	mov    %edx,0x4(%eax)
  80264f:	eb 0b                	jmp    80265c <alloc_block_FF+0x362>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	a3 30 50 80 00       	mov    %eax,0x805030
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 04             	mov    0x4(%eax),%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	74 0f                	je     802675 <alloc_block_FF+0x37b>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266f:	8b 12                	mov    (%edx),%edx
  802671:	89 10                	mov    %edx,(%eax)
  802673:	eb 0a                	jmp    80267f <alloc_block_FF+0x385>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802692:	a1 38 50 80 00       	mov    0x805038,%eax
  802697:	48                   	dec    %eax
  802698:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80269d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026a0:	e9 0f 01 00 00       	jmp    8027b4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026a5:	a1 34 50 80 00       	mov    0x805034,%eax
  8026aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	74 07                	je     8026ba <alloc_block_FF+0x3c0>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	eb 05                	jmp    8026bf <alloc_block_FF+0x3c5>
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	0f 85 e9 fc ff ff    	jne    8023ba <alloc_block_FF+0xc0>
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	0f 85 df fc ff ff    	jne    8023ba <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	83 c0 08             	add    $0x8,%eax
  8026e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026e4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	48                   	dec    %eax
  8026f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ff:	f7 75 d8             	divl   -0x28(%ebp)
  802702:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802705:	29 d0                	sub    %edx,%eax
  802707:	c1 e8 0c             	shr    $0xc,%eax
  80270a:	83 ec 0c             	sub    $0xc,%esp
  80270d:	50                   	push   %eax
  80270e:	e8 66 ed ff ff       	call   801479 <sbrk>
  802713:	83 c4 10             	add    $0x10,%esp
  802716:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802719:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80271d:	75 0a                	jne    802729 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	e9 8b 00 00 00       	jmp    8027b4 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802729:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802730:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802733:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802736:	01 d0                	add    %edx,%eax
  802738:	48                   	dec    %eax
  802739:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80273c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80273f:	ba 00 00 00 00       	mov    $0x0,%edx
  802744:	f7 75 cc             	divl   -0x34(%ebp)
  802747:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80274a:	29 d0                	sub    %edx,%eax
  80274c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80274f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802752:	01 d0                	add    %edx,%eax
  802754:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802759:	a1 40 50 80 00       	mov    0x805040,%eax
  80275e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802764:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80276b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80276e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	48                   	dec    %eax
  802774:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802777:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80277a:	ba 00 00 00 00       	mov    $0x0,%edx
  80277f:	f7 75 c4             	divl   -0x3c(%ebp)
  802782:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802785:	29 d0                	sub    %edx,%eax
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	6a 01                	push   $0x1
  80278c:	50                   	push   %eax
  80278d:	ff 75 d0             	pushl  -0x30(%ebp)
  802790:	e8 36 fb ff ff       	call   8022cb <set_block_data>
  802795:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802798:	83 ec 0c             	sub    $0xc,%esp
  80279b:	ff 75 d0             	pushl  -0x30(%ebp)
  80279e:	e8 1b 0a 00 00       	call   8031be <free_block>
  8027a3:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 08             	pushl  0x8(%ebp)
  8027ac:	e8 49 fb ff ff       	call   8022fa <alloc_block_FF>
  8027b1:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	83 e0 01             	and    $0x1,%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 03                	je     8027c9 <alloc_block_BF+0x13>
  8027c6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027c9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027cd:	77 07                	ja     8027d6 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027cf:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027d6:	a1 24 50 80 00       	mov    0x805024,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	75 73                	jne    802852 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	83 c0 10             	add    $0x10,%eax
  8027e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027e8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	48                   	dec    %eax
  8027f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802803:	f7 75 e0             	divl   -0x20(%ebp)
  802806:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802809:	29 d0                	sub    %edx,%eax
  80280b:	c1 e8 0c             	shr    $0xc,%eax
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	50                   	push   %eax
  802812:	e8 62 ec ff ff       	call   801479 <sbrk>
  802817:	83 c4 10             	add    $0x10,%esp
  80281a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	6a 00                	push   $0x0
  802822:	e8 52 ec ff ff       	call   801479 <sbrk>
  802827:	83 c4 10             	add    $0x10,%esp
  80282a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80282d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802830:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802833:	83 ec 08             	sub    $0x8,%esp
  802836:	50                   	push   %eax
  802837:	ff 75 d8             	pushl  -0x28(%ebp)
  80283a:	e8 9f f8 ff ff       	call   8020de <initialize_dynamic_allocator>
  80283f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802842:	83 ec 0c             	sub    $0xc,%esp
  802845:	68 e7 45 80 00       	push   $0x8045e7
  80284a:	e8 90 de ff ff       	call   8006df <cprintf>
  80284f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802859:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802860:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802867:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80286e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802876:	e9 1d 01 00 00       	jmp    802998 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802881:	83 ec 0c             	sub    $0xc,%esp
  802884:	ff 75 a8             	pushl  -0x58(%ebp)
  802887:	e8 ee f6 ff ff       	call   801f7a <get_block_size>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	83 c0 08             	add    $0x8,%eax
  802898:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289b:	0f 87 ef 00 00 00    	ja     802990 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	83 c0 18             	add    $0x18,%eax
  8028a7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028aa:	77 1d                	ja     8028c9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b2:	0f 86 d8 00 00 00    	jbe    802990 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028c4:	e9 c7 00 00 00       	jmp    802990 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	83 c0 08             	add    $0x8,%eax
  8028cf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d2:	0f 85 9d 00 00 00    	jne    802975 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	6a 01                	push   $0x1
  8028dd:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8028e3:	e8 e3 f9 ff ff       	call   8022cb <set_block_data>
  8028e8:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	75 17                	jne    802908 <alloc_block_BF+0x152>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 8b 45 80 00       	push   $0x80458b
  8028f9:	68 2c 01 00 00       	push   $0x12c
  8028fe:	68 a9 45 80 00       	push   $0x8045a9
  802903:	e8 1a db ff ff       	call   800422 <_panic>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 10                	je     802921 <alloc_block_BF+0x16b>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802919:	8b 52 04             	mov    0x4(%edx),%edx
  80291c:	89 50 04             	mov    %edx,0x4(%eax)
  80291f:	eb 0b                	jmp    80292c <alloc_block_BF+0x176>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	a3 30 50 80 00       	mov    %eax,0x805030
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 04             	mov    0x4(%eax),%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	74 0f                	je     802945 <alloc_block_BF+0x18f>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	8b 12                	mov    (%edx),%edx
  802941:	89 10                	mov    %edx,(%eax)
  802943:	eb 0a                	jmp    80294f <alloc_block_BF+0x199>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802962:	a1 38 50 80 00       	mov    0x805038,%eax
  802967:	48                   	dec    %eax
  802968:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80296d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802970:	e9 24 04 00 00       	jmp    802d99 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80297b:	76 13                	jbe    802990 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80297d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802984:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802987:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80298a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80298d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802990:	a1 34 50 80 00       	mov    0x805034,%eax
  802995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299c:	74 07                	je     8029a5 <alloc_block_BF+0x1ef>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	eb 05                	jmp    8029aa <alloc_block_BF+0x1f4>
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029aa:	a3 34 50 80 00       	mov    %eax,0x805034
  8029af:	a1 34 50 80 00       	mov    0x805034,%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	0f 85 bf fe ff ff    	jne    80287b <alloc_block_BF+0xc5>
  8029bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c0:	0f 85 b5 fe ff ff    	jne    80287b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ca:	0f 84 26 02 00 00    	je     802bf6 <alloc_block_BF+0x440>
  8029d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029d4:	0f 85 1c 02 00 00    	jne    802bf6 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e0:	83 e8 08             	sub    $0x8,%eax
  8029e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8d 50 08             	lea    0x8(%eax),%edx
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	01 d0                	add    %edx,%eax
  8029f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	83 c0 08             	add    $0x8,%eax
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	6a 01                	push   $0x1
  8029ff:	50                   	push   %eax
  802a00:	ff 75 f0             	pushl  -0x10(%ebp)
  802a03:	e8 c3 f8 ff ff       	call   8022cb <set_block_data>
  802a08:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	8b 40 04             	mov    0x4(%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	75 68                	jne    802a7d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a15:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a19:	75 17                	jne    802a32 <alloc_block_BF+0x27c>
  802a1b:	83 ec 04             	sub    $0x4,%esp
  802a1e:	68 c4 45 80 00       	push   $0x8045c4
  802a23:	68 45 01 00 00       	push   $0x145
  802a28:	68 a9 45 80 00       	push   $0x8045a9
  802a2d:	e8 f0 d9 ff ff       	call   800422 <_panic>
  802a32:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0d                	je     802a53 <alloc_block_BF+0x29d>
  802a46:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a4e:	89 50 04             	mov    %edx,0x4(%eax)
  802a51:	eb 08                	jmp    802a5b <alloc_block_BF+0x2a5>
  802a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a56:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a72:	40                   	inc    %eax
  802a73:	a3 38 50 80 00       	mov    %eax,0x805038
  802a78:	e9 dc 00 00 00       	jmp    802b59 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 65                	jne    802aeb <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a86:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a8a:	75 17                	jne    802aa3 <alloc_block_BF+0x2ed>
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	68 f8 45 80 00       	push   $0x8045f8
  802a94:	68 4a 01 00 00       	push   $0x14a
  802a99:	68 a9 45 80 00       	push   $0x8045a9
  802a9e:	e8 7f d9 ff ff       	call   800422 <_panic>
  802aa3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802aa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 0c                	je     802ac5 <alloc_block_BF+0x30f>
  802ab9:	a1 30 50 80 00       	mov    0x805030,%eax
  802abe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	eb 08                	jmp    802acd <alloc_block_BF+0x317>
  802ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802acd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 38 50 80 00       	mov    %eax,0x805038
  802ae9:	eb 6e                	jmp    802b59 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aef:	74 06                	je     802af7 <alloc_block_BF+0x341>
  802af1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802af5:	75 17                	jne    802b0e <alloc_block_BF+0x358>
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	68 1c 46 80 00       	push   $0x80461c
  802aff:	68 4f 01 00 00       	push   $0x14f
  802b04:	68 a9 45 80 00       	push   $0x8045a9
  802b09:	e8 14 d9 ff ff       	call   800422 <_panic>
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 10                	mov    (%eax),%edx
  802b13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 0b                	je     802b2c <alloc_block_BF+0x376>
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b32:	89 10                	mov    %edx,(%eax)
  802b34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
  802b3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	75 08                	jne    802b4e <alloc_block_BF+0x398>
  802b46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b49:	a3 30 50 80 00       	mov    %eax,0x805030
  802b4e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b53:	40                   	inc    %eax
  802b54:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5d:	75 17                	jne    802b76 <alloc_block_BF+0x3c0>
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	68 8b 45 80 00       	push   $0x80458b
  802b67:	68 51 01 00 00       	push   $0x151
  802b6c:	68 a9 45 80 00       	push   $0x8045a9
  802b71:	e8 ac d8 ff ff       	call   800422 <_panic>
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 10                	je     802b8f <alloc_block_BF+0x3d9>
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b87:	8b 52 04             	mov    0x4(%edx),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	eb 0b                	jmp    802b9a <alloc_block_BF+0x3e4>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	a3 30 50 80 00       	mov    %eax,0x805030
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0f                	je     802bb3 <alloc_block_BF+0x3fd>
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bad:	8b 12                	mov    (%edx),%edx
  802baf:	89 10                	mov    %edx,(%eax)
  802bb1:	eb 0a                	jmp    802bbd <alloc_block_BF+0x407>
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd0:	a1 38 50 80 00       	mov    0x805038,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	6a 00                	push   $0x0
  802be0:	ff 75 d0             	pushl  -0x30(%ebp)
  802be3:	ff 75 cc             	pushl  -0x34(%ebp)
  802be6:	e8 e0 f6 ff ff       	call   8022cb <set_block_data>
  802beb:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	e9 a3 01 00 00       	jmp    802d99 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bf6:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bfa:	0f 85 9d 00 00 00    	jne    802c9d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	6a 01                	push   $0x1
  802c05:	ff 75 ec             	pushl  -0x14(%ebp)
  802c08:	ff 75 f0             	pushl  -0x10(%ebp)
  802c0b:	e8 bb f6 ff ff       	call   8022cb <set_block_data>
  802c10:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c17:	75 17                	jne    802c30 <alloc_block_BF+0x47a>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 8b 45 80 00       	push   $0x80458b
  802c21:	68 58 01 00 00       	push   $0x158
  802c26:	68 a9 45 80 00       	push   $0x8045a9
  802c2b:	e8 f2 d7 ff ff       	call   800422 <_panic>
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 10                	je     802c49 <alloc_block_BF+0x493>
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c41:	8b 52 04             	mov    0x4(%edx),%edx
  802c44:	89 50 04             	mov    %edx,0x4(%eax)
  802c47:	eb 0b                	jmp    802c54 <alloc_block_BF+0x49e>
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	74 0f                	je     802c6d <alloc_block_BF+0x4b7>
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c67:	8b 12                	mov    (%edx),%edx
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	eb 0a                	jmp    802c77 <alloc_block_BF+0x4c1>
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c8f:	48                   	dec    %eax
  802c90:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	e9 fc 00 00 00       	jmp    802d99 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	83 c0 08             	add    $0x8,%eax
  802ca3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ca6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cad:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cb3:	01 d0                	add    %edx,%eax
  802cb5:	48                   	dec    %eax
  802cb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc1:	f7 75 c4             	divl   -0x3c(%ebp)
  802cc4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc7:	29 d0                	sub    %edx,%eax
  802cc9:	c1 e8 0c             	shr    $0xc,%eax
  802ccc:	83 ec 0c             	sub    $0xc,%esp
  802ccf:	50                   	push   %eax
  802cd0:	e8 a4 e7 ff ff       	call   801479 <sbrk>
  802cd5:	83 c4 10             	add    $0x10,%esp
  802cd8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cdb:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cdf:	75 0a                	jne    802ceb <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce6:	e9 ae 00 00 00       	jmp    802d99 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ceb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cf2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cf5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	48                   	dec    %eax
  802cfb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cfe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d01:	ba 00 00 00 00       	mov    $0x0,%edx
  802d06:	f7 75 b8             	divl   -0x48(%ebp)
  802d09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d0c:	29 d0                	sub    %edx,%eax
  802d0e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d11:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d14:	01 d0                	add    %edx,%eax
  802d16:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d1b:	a1 40 50 80 00       	mov    0x805040,%eax
  802d20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d26:	83 ec 0c             	sub    $0xc,%esp
  802d29:	68 50 46 80 00       	push   $0x804650
  802d2e:	e8 ac d9 ff ff       	call   8006df <cprintf>
  802d33:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d36:	83 ec 08             	sub    $0x8,%esp
  802d39:	ff 75 bc             	pushl  -0x44(%ebp)
  802d3c:	68 55 46 80 00       	push   $0x804655
  802d41:	e8 99 d9 ff ff       	call   8006df <cprintf>
  802d46:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d49:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d50:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d53:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d56:	01 d0                	add    %edx,%eax
  802d58:	48                   	dec    %eax
  802d59:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d64:	f7 75 b0             	divl   -0x50(%ebp)
  802d67:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d6a:	29 d0                	sub    %edx,%eax
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	6a 01                	push   $0x1
  802d71:	50                   	push   %eax
  802d72:	ff 75 bc             	pushl  -0x44(%ebp)
  802d75:	e8 51 f5 ff ff       	call   8022cb <set_block_data>
  802d7a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d7d:	83 ec 0c             	sub    $0xc,%esp
  802d80:	ff 75 bc             	pushl  -0x44(%ebp)
  802d83:	e8 36 04 00 00       	call   8031be <free_block>
  802d88:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d8b:	83 ec 0c             	sub    $0xc,%esp
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	e8 20 fa ff ff       	call   8027b6 <alloc_block_BF>
  802d96:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	53                   	push   %ebx
  802d9f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802da9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db4:	74 1e                	je     802dd4 <merging+0x39>
  802db6:	ff 75 08             	pushl  0x8(%ebp)
  802db9:	e8 bc f1 ff ff       	call   801f7a <get_block_size>
  802dbe:	83 c4 04             	add    $0x4,%esp
  802dc1:	89 c2                	mov    %eax,%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	01 d0                	add    %edx,%eax
  802dc8:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dcb:	75 07                	jne    802dd4 <merging+0x39>
		prev_is_free = 1;
  802dcd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd8:	74 1e                	je     802df8 <merging+0x5d>
  802dda:	ff 75 10             	pushl  0x10(%ebp)
  802ddd:	e8 98 f1 ff ff       	call   801f7a <get_block_size>
  802de2:	83 c4 04             	add    $0x4,%esp
  802de5:	89 c2                	mov    %eax,%edx
  802de7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dea:	01 d0                	add    %edx,%eax
  802dec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802def:	75 07                	jne    802df8 <merging+0x5d>
		next_is_free = 1;
  802df1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	0f 84 cc 00 00 00    	je     802ece <merging+0x133>
  802e02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e06:	0f 84 c2 00 00 00    	je     802ece <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e0c:	ff 75 08             	pushl  0x8(%ebp)
  802e0f:	e8 66 f1 ff ff       	call   801f7a <get_block_size>
  802e14:	83 c4 04             	add    $0x4,%esp
  802e17:	89 c3                	mov    %eax,%ebx
  802e19:	ff 75 10             	pushl  0x10(%ebp)
  802e1c:	e8 59 f1 ff ff       	call   801f7a <get_block_size>
  802e21:	83 c4 04             	add    $0x4,%esp
  802e24:	01 c3                	add    %eax,%ebx
  802e26:	ff 75 0c             	pushl  0xc(%ebp)
  802e29:	e8 4c f1 ff ff       	call   801f7a <get_block_size>
  802e2e:	83 c4 04             	add    $0x4,%esp
  802e31:	01 d8                	add    %ebx,%eax
  802e33:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e36:	6a 00                	push   $0x0
  802e38:	ff 75 ec             	pushl  -0x14(%ebp)
  802e3b:	ff 75 08             	pushl  0x8(%ebp)
  802e3e:	e8 88 f4 ff ff       	call   8022cb <set_block_data>
  802e43:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4a:	75 17                	jne    802e63 <merging+0xc8>
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	68 8b 45 80 00       	push   $0x80458b
  802e54:	68 7d 01 00 00       	push   $0x17d
  802e59:	68 a9 45 80 00       	push   $0x8045a9
  802e5e:	e8 bf d5 ff ff       	call   800422 <_panic>
  802e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 10                	je     802e7c <merging+0xe1>
  802e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e74:	8b 52 04             	mov    0x4(%edx),%edx
  802e77:	89 50 04             	mov    %edx,0x4(%eax)
  802e7a:	eb 0b                	jmp    802e87 <merging+0xec>
  802e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	a3 30 50 80 00       	mov    %eax,0x805030
  802e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	74 0f                	je     802ea0 <merging+0x105>
  802e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e94:	8b 40 04             	mov    0x4(%eax),%eax
  802e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9a:	8b 12                	mov    (%edx),%edx
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	eb 0a                	jmp    802eaa <merging+0x10f>
  802ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ead:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebd:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec2:	48                   	dec    %eax
  802ec3:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ec8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec9:	e9 ea 02 00 00       	jmp    8031b8 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed2:	74 3b                	je     802f0f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ed4:	83 ec 0c             	sub    $0xc,%esp
  802ed7:	ff 75 08             	pushl  0x8(%ebp)
  802eda:	e8 9b f0 ff ff       	call   801f7a <get_block_size>
  802edf:	83 c4 10             	add    $0x10,%esp
  802ee2:	89 c3                	mov    %eax,%ebx
  802ee4:	83 ec 0c             	sub    $0xc,%esp
  802ee7:	ff 75 10             	pushl  0x10(%ebp)
  802eea:	e8 8b f0 ff ff       	call   801f7a <get_block_size>
  802eef:	83 c4 10             	add    $0x10,%esp
  802ef2:	01 d8                	add    %ebx,%eax
  802ef4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	6a 00                	push   $0x0
  802efc:	ff 75 e8             	pushl  -0x18(%ebp)
  802eff:	ff 75 08             	pushl  0x8(%ebp)
  802f02:	e8 c4 f3 ff ff       	call   8022cb <set_block_data>
  802f07:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f0a:	e9 a9 02 00 00       	jmp    8031b8 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f13:	0f 84 2d 01 00 00    	je     803046 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f19:	83 ec 0c             	sub    $0xc,%esp
  802f1c:	ff 75 10             	pushl  0x10(%ebp)
  802f1f:	e8 56 f0 ff ff       	call   801f7a <get_block_size>
  802f24:	83 c4 10             	add    $0x10,%esp
  802f27:	89 c3                	mov    %eax,%ebx
  802f29:	83 ec 0c             	sub    $0xc,%esp
  802f2c:	ff 75 0c             	pushl  0xc(%ebp)
  802f2f:	e8 46 f0 ff ff       	call   801f7a <get_block_size>
  802f34:	83 c4 10             	add    $0x10,%esp
  802f37:	01 d8                	add    %ebx,%eax
  802f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	6a 00                	push   $0x0
  802f41:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f44:	ff 75 10             	pushl  0x10(%ebp)
  802f47:	e8 7f f3 ff ff       	call   8022cb <set_block_data>
  802f4c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f59:	74 06                	je     802f61 <merging+0x1c6>
  802f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f5f:	75 17                	jne    802f78 <merging+0x1dd>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 64 46 80 00       	push   $0x804664
  802f69:	68 8d 01 00 00       	push   $0x18d
  802f6e:	68 a9 45 80 00       	push   $0x8045a9
  802f73:	e8 aa d4 ff ff       	call   800422 <_panic>
  802f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7b:	8b 50 04             	mov    0x4(%eax),%edx
  802f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8a:	89 10                	mov    %edx,(%eax)
  802f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 0d                	je     802fa3 <merging+0x208>
  802f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 08                	jmp    802fab <merging+0x210>
  802fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb9:	40                   	inc    %eax
  802fba:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc3:	75 17                	jne    802fdc <merging+0x241>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 8b 45 80 00       	push   $0x80458b
  802fcd:	68 8e 01 00 00       	push   $0x18e
  802fd2:	68 a9 45 80 00       	push   $0x8045a9
  802fd7:	e8 46 d4 ff ff       	call   800422 <_panic>
  802fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 10                	je     802ff5 <merging+0x25a>
  802fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fed:	8b 52 04             	mov    0x4(%edx),%edx
  802ff0:	89 50 04             	mov    %edx,0x4(%eax)
  802ff3:	eb 0b                	jmp    803000 <merging+0x265>
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	a3 30 50 80 00       	mov    %eax,0x805030
  803000:	8b 45 0c             	mov    0xc(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 0f                	je     803019 <merging+0x27e>
  80300a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	8b 55 0c             	mov    0xc(%ebp),%edx
  803013:	8b 12                	mov    (%edx),%edx
  803015:	89 10                	mov    %edx,(%eax)
  803017:	eb 0a                	jmp    803023 <merging+0x288>
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803036:	a1 38 50 80 00       	mov    0x805038,%eax
  80303b:	48                   	dec    %eax
  80303c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803041:	e9 72 01 00 00       	jmp    8031b8 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803046:	8b 45 10             	mov    0x10(%ebp),%eax
  803049:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80304c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803050:	74 79                	je     8030cb <merging+0x330>
  803052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803056:	74 73                	je     8030cb <merging+0x330>
  803058:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305c:	74 06                	je     803064 <merging+0x2c9>
  80305e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803062:	75 17                	jne    80307b <merging+0x2e0>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 1c 46 80 00       	push   $0x80461c
  80306c:	68 94 01 00 00       	push   $0x194
  803071:	68 a9 45 80 00       	push   $0x8045a9
  803076:	e8 a7 d3 ff ff       	call   800422 <_panic>
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	8b 10                	mov    (%eax),%edx
  803080:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803083:	89 10                	mov    %edx,(%eax)
  803085:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0b                	je     803099 <merging+0x2fe>
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309f:	89 10                	mov    %edx,(%eax)
  8030a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	75 08                	jne    8030bb <merging+0x320>
  8030b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8030c6:	e9 ce 00 00 00       	jmp    803199 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cf:	74 65                	je     803136 <merging+0x39b>
  8030d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d5:	75 17                	jne    8030ee <merging+0x353>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 f8 45 80 00       	push   $0x8045f8
  8030df:	68 95 01 00 00       	push   $0x195
  8030e4:	68 a9 45 80 00       	push   $0x8045a9
  8030e9:	e8 34 d3 ff ff       	call   800422 <_panic>
  8030ee:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 0c                	je     803110 <merging+0x375>
  803104:	a1 30 50 80 00       	mov    0x805030,%eax
  803109:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	eb 08                	jmp    803118 <merging+0x37d>
  803110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803113:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803118:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311b:	a3 30 50 80 00       	mov    %eax,0x805030
  803120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803123:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803129:	a1 38 50 80 00       	mov    0x805038,%eax
  80312e:	40                   	inc    %eax
  80312f:	a3 38 50 80 00       	mov    %eax,0x805038
  803134:	eb 63                	jmp    803199 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803136:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80313a:	75 17                	jne    803153 <merging+0x3b8>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 c4 45 80 00       	push   $0x8045c4
  803144:	68 98 01 00 00       	push   $0x198
  803149:	68 a9 45 80 00       	push   $0x8045a9
  80314e:	e8 cf d2 ff ff       	call   800422 <_panic>
  803153:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803159:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0d                	je     803174 <merging+0x3d9>
  803167:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80316c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316f:	89 50 04             	mov    %edx,0x4(%eax)
  803172:	eb 08                	jmp    80317c <merging+0x3e1>
  803174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803177:	a3 30 50 80 00       	mov    %eax,0x805030
  80317c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803184:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803187:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318e:	a1 38 50 80 00       	mov    0x805038,%eax
  803193:	40                   	inc    %eax
  803194:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803199:	83 ec 0c             	sub    $0xc,%esp
  80319c:	ff 75 10             	pushl  0x10(%ebp)
  80319f:	e8 d6 ed ff ff       	call   801f7a <get_block_size>
  8031a4:	83 c4 10             	add    $0x10,%esp
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	6a 00                	push   $0x0
  8031ac:	50                   	push   %eax
  8031ad:	ff 75 10             	pushl  0x10(%ebp)
  8031b0:	e8 16 f1 ff ff       	call   8022cb <set_block_data>
  8031b5:	83 c4 10             	add    $0x10,%esp
	}
}
  8031b8:	90                   	nop
  8031b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031cc:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d4:	73 1b                	jae    8031f1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	ff 75 08             	pushl  0x8(%ebp)
  8031e1:	6a 00                	push   $0x0
  8031e3:	50                   	push   %eax
  8031e4:	e8 b2 fb ff ff       	call   802d9b <merging>
  8031e9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ec:	e9 8b 00 00 00       	jmp    80327c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f9:	76 18                	jbe    803213 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	ff 75 08             	pushl  0x8(%ebp)
  803206:	50                   	push   %eax
  803207:	6a 00                	push   $0x0
  803209:	e8 8d fb ff ff       	call   802d9b <merging>
  80320e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803211:	eb 69                	jmp    80327c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803213:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321b:	eb 39                	jmp    803256 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	3b 45 08             	cmp    0x8(%ebp),%eax
  803223:	73 29                	jae    80324e <free_block+0x90>
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80322d:	76 1f                	jbe    80324e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	ff 75 08             	pushl  0x8(%ebp)
  80323d:	ff 75 f0             	pushl  -0x10(%ebp)
  803240:	ff 75 f4             	pushl  -0xc(%ebp)
  803243:	e8 53 fb ff ff       	call   802d9b <merging>
  803248:	83 c4 10             	add    $0x10,%esp
			break;
  80324b:	90                   	nop
		}
	}
}
  80324c:	eb 2e                	jmp    80327c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80324e:	a1 34 50 80 00       	mov    0x805034,%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325a:	74 07                	je     803263 <free_block+0xa5>
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	eb 05                	jmp    803268 <free_block+0xaa>
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	a3 34 50 80 00       	mov    %eax,0x805034
  80326d:	a1 34 50 80 00       	mov    0x805034,%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	75 a7                	jne    80321d <free_block+0x5f>
  803276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327a:	75 a1                	jne    80321d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80327c:	90                   	nop
  80327d:	c9                   	leave  
  80327e:	c3                   	ret    

0080327f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80327f:	55                   	push   %ebp
  803280:	89 e5                	mov    %esp,%ebp
  803282:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803285:	ff 75 08             	pushl  0x8(%ebp)
  803288:	e8 ed ec ff ff       	call   801f7a <get_block_size>
  80328d:	83 c4 04             	add    $0x4,%esp
  803290:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80329a:	eb 17                	jmp    8032b3 <copy_data+0x34>
  80329c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80329f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a2:	01 c2                	add    %eax,%edx
  8032a4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	01 c8                	add    %ecx,%eax
  8032ac:	8a 00                	mov    (%eax),%al
  8032ae:	88 02                	mov    %al,(%edx)
  8032b0:	ff 45 fc             	incl   -0x4(%ebp)
  8032b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032b9:	72 e1                	jb     80329c <copy_data+0x1d>
}
  8032bb:	90                   	nop
  8032bc:	c9                   	leave  
  8032bd:	c3                   	ret    

008032be <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032be:	55                   	push   %ebp
  8032bf:	89 e5                	mov    %esp,%ebp
  8032c1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c8:	75 23                	jne    8032ed <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032ce:	74 13                	je     8032e3 <realloc_block_FF+0x25>
  8032d0:	83 ec 0c             	sub    $0xc,%esp
  8032d3:	ff 75 0c             	pushl  0xc(%ebp)
  8032d6:	e8 1f f0 ff ff       	call   8022fa <alloc_block_FF>
  8032db:	83 c4 10             	add    $0x10,%esp
  8032de:	e9 f4 06 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
		return NULL;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	e9 ea 06 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f1:	75 18                	jne    80330b <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032f3:	83 ec 0c             	sub    $0xc,%esp
  8032f6:	ff 75 08             	pushl  0x8(%ebp)
  8032f9:	e8 c0 fe ff ff       	call   8031be <free_block>
  8032fe:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
  803306:	e9 cc 06 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80330b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80330f:	77 07                	ja     803318 <realloc_block_FF+0x5a>
  803311:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331b:	83 e0 01             	and    $0x1,%eax
  80331e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803321:	8b 45 0c             	mov    0xc(%ebp),%eax
  803324:	83 c0 08             	add    $0x8,%eax
  803327:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80332a:	83 ec 0c             	sub    $0xc,%esp
  80332d:	ff 75 08             	pushl  0x8(%ebp)
  803330:	e8 45 ec ff ff       	call   801f7a <get_block_size>
  803335:	83 c4 10             	add    $0x10,%esp
  803338:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80333b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333e:	83 e8 08             	sub    $0x8,%eax
  803341:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	83 e8 04             	sub    $0x4,%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	83 e0 fe             	and    $0xfffffffe,%eax
  80334f:	89 c2                	mov    %eax,%edx
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	01 d0                	add    %edx,%eax
  803356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803359:	83 ec 0c             	sub    $0xc,%esp
  80335c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335f:	e8 16 ec ff ff       	call   801f7a <get_block_size>
  803364:	83 c4 10             	add    $0x10,%esp
  803367:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80336a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336d:	83 e8 08             	sub    $0x8,%eax
  803370:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803373:	8b 45 0c             	mov    0xc(%ebp),%eax
  803376:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803379:	75 08                	jne    803383 <realloc_block_FF+0xc5>
	{
		 return va;
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	e9 54 06 00 00       	jmp    8039d7 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803383:	8b 45 0c             	mov    0xc(%ebp),%eax
  803386:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803389:	0f 83 e5 03 00 00    	jae    803774 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803392:	2b 45 0c             	sub    0xc(%ebp),%eax
  803395:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803398:	83 ec 0c             	sub    $0xc,%esp
  80339b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80339e:	e8 f0 eb ff ff       	call   801f93 <is_free_block>
  8033a3:	83 c4 10             	add    $0x10,%esp
  8033a6:	84 c0                	test   %al,%al
  8033a8:	0f 84 3b 01 00 00    	je     8034e9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b4:	01 d0                	add    %edx,%eax
  8033b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	6a 01                	push   $0x1
  8033be:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c1:	ff 75 08             	pushl  0x8(%ebp)
  8033c4:	e8 02 ef ff ff       	call   8022cb <set_block_data>
  8033c9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	83 e8 04             	sub    $0x4,%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	83 e0 fe             	and    $0xfffffffe,%eax
  8033d7:	89 c2                	mov    %eax,%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	01 d0                	add    %edx,%eax
  8033de:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	6a 00                	push   $0x0
  8033e6:	ff 75 cc             	pushl  -0x34(%ebp)
  8033e9:	ff 75 c8             	pushl  -0x38(%ebp)
  8033ec:	e8 da ee ff ff       	call   8022cb <set_block_data>
  8033f1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f8:	74 06                	je     803400 <realloc_block_FF+0x142>
  8033fa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033fe:	75 17                	jne    803417 <realloc_block_FF+0x159>
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	68 1c 46 80 00       	push   $0x80461c
  803408:	68 f6 01 00 00       	push   $0x1f6
  80340d:	68 a9 45 80 00       	push   $0x8045a9
  803412:	e8 0b d0 ff ff       	call   800422 <_panic>
  803417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341a:	8b 10                	mov    (%eax),%edx
  80341c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341f:	89 10                	mov    %edx,(%eax)
  803421:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 0b                	je     803435 <realloc_block_FF+0x177>
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343b:	89 10                	mov    %edx,(%eax)
  80343d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	75 08                	jne    803457 <realloc_block_FF+0x199>
  80344f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803452:	a3 30 50 80 00       	mov    %eax,0x805030
  803457:	a1 38 50 80 00       	mov    0x805038,%eax
  80345c:	40                   	inc    %eax
  80345d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803466:	75 17                	jne    80347f <realloc_block_FF+0x1c1>
  803468:	83 ec 04             	sub    $0x4,%esp
  80346b:	68 8b 45 80 00       	push   $0x80458b
  803470:	68 f7 01 00 00       	push   $0x1f7
  803475:	68 a9 45 80 00       	push   $0x8045a9
  80347a:	e8 a3 cf ff ff       	call   800422 <_panic>
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 10                	je     803498 <realloc_block_FF+0x1da>
  803488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803490:	8b 52 04             	mov    0x4(%edx),%edx
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	eb 0b                	jmp    8034a3 <realloc_block_FF+0x1e5>
  803498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a6:	8b 40 04             	mov    0x4(%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0f                	je     8034bc <realloc_block_FF+0x1fe>
  8034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b6:	8b 12                	mov    (%edx),%edx
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	eb 0a                	jmp    8034c6 <realloc_block_FF+0x208>
  8034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034de:	48                   	dec    %eax
  8034df:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e4:	e9 83 02 00 00       	jmp    80376c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034e9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034ed:	0f 86 69 02 00 00    	jbe    80375c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034f3:	83 ec 04             	sub    $0x4,%esp
  8034f6:	6a 01                	push   $0x1
  8034f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034fb:	ff 75 08             	pushl  0x8(%ebp)
  8034fe:	e8 c8 ed ff ff       	call   8022cb <set_block_data>
  803503:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	83 e8 04             	sub    $0x4,%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	83 e0 fe             	and    $0xfffffffe,%eax
  803511:	89 c2                	mov    %eax,%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80351b:	a1 38 50 80 00       	mov    0x805038,%eax
  803520:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803523:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803527:	75 68                	jne    803591 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803529:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80352d:	75 17                	jne    803546 <realloc_block_FF+0x288>
  80352f:	83 ec 04             	sub    $0x4,%esp
  803532:	68 c4 45 80 00       	push   $0x8045c4
  803537:	68 06 02 00 00       	push   $0x206
  80353c:	68 a9 45 80 00       	push   $0x8045a9
  803541:	e8 dc ce ff ff       	call   800422 <_panic>
  803546:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80354c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354f:	89 10                	mov    %edx,(%eax)
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 0d                	je     803567 <realloc_block_FF+0x2a9>
  80355a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80355f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	eb 08                	jmp    80356f <realloc_block_FF+0x2b1>
  803567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356a:	a3 30 50 80 00       	mov    %eax,0x805030
  80356f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803572:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803577:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803581:	a1 38 50 80 00       	mov    0x805038,%eax
  803586:	40                   	inc    %eax
  803587:	a3 38 50 80 00       	mov    %eax,0x805038
  80358c:	e9 b0 01 00 00       	jmp    803741 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803591:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803596:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803599:	76 68                	jbe    803603 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80359b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80359f:	75 17                	jne    8035b8 <realloc_block_FF+0x2fa>
  8035a1:	83 ec 04             	sub    $0x4,%esp
  8035a4:	68 c4 45 80 00       	push   $0x8045c4
  8035a9:	68 0b 02 00 00       	push   $0x20b
  8035ae:	68 a9 45 80 00       	push   $0x8045a9
  8035b3:	e8 6a ce ff ff       	call   800422 <_panic>
  8035b8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c1:	89 10                	mov    %edx,(%eax)
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	74 0d                	je     8035d9 <realloc_block_FF+0x31b>
  8035cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d4:	89 50 04             	mov    %edx,0x4(%eax)
  8035d7:	eb 08                	jmp    8035e1 <realloc_block_FF+0x323>
  8035d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f8:	40                   	inc    %eax
  8035f9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035fe:	e9 3e 01 00 00       	jmp    803741 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803603:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803608:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80360b:	73 68                	jae    803675 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80360d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803611:	75 17                	jne    80362a <realloc_block_FF+0x36c>
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	68 f8 45 80 00       	push   $0x8045f8
  80361b:	68 10 02 00 00       	push   $0x210
  803620:	68 a9 45 80 00       	push   $0x8045a9
  803625:	e8 f8 cd ff ff       	call   800422 <_panic>
  80362a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803633:	89 50 04             	mov    %edx,0x4(%eax)
  803636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803639:	8b 40 04             	mov    0x4(%eax),%eax
  80363c:	85 c0                	test   %eax,%eax
  80363e:	74 0c                	je     80364c <realloc_block_FF+0x38e>
  803640:	a1 30 50 80 00       	mov    0x805030,%eax
  803645:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	eb 08                	jmp    803654 <realloc_block_FF+0x396>
  80364c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803657:	a3 30 50 80 00       	mov    %eax,0x805030
  80365c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803665:	a1 38 50 80 00       	mov    0x805038,%eax
  80366a:	40                   	inc    %eax
  80366b:	a3 38 50 80 00       	mov    %eax,0x805038
  803670:	e9 cc 00 00 00       	jmp    803741 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803675:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80367c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803684:	e9 8a 00 00 00       	jmp    803713 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80368f:	73 7a                	jae    80370b <realloc_block_FF+0x44d>
  803691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803699:	73 70                	jae    80370b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80369b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369f:	74 06                	je     8036a7 <realloc_block_FF+0x3e9>
  8036a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a5:	75 17                	jne    8036be <realloc_block_FF+0x400>
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	68 1c 46 80 00       	push   $0x80461c
  8036af:	68 1a 02 00 00       	push   $0x21a
  8036b4:	68 a9 45 80 00       	push   $0x8045a9
  8036b9:	e8 64 cd ff ff       	call   800422 <_panic>
  8036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c1:	8b 10                	mov    (%eax),%edx
  8036c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c6:	89 10                	mov    %edx,(%eax)
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	74 0b                	je     8036dc <realloc_block_FF+0x41e>
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ea:	89 50 04             	mov    %edx,0x4(%eax)
  8036ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f0:	8b 00                	mov    (%eax),%eax
  8036f2:	85 c0                	test   %eax,%eax
  8036f4:	75 08                	jne    8036fe <realloc_block_FF+0x440>
  8036f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803703:	40                   	inc    %eax
  803704:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803709:	eb 36                	jmp    803741 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80370b:	a1 34 50 80 00       	mov    0x805034,%eax
  803710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803717:	74 07                	je     803720 <realloc_block_FF+0x462>
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	eb 05                	jmp    803725 <realloc_block_FF+0x467>
  803720:	b8 00 00 00 00       	mov    $0x0,%eax
  803725:	a3 34 50 80 00       	mov    %eax,0x805034
  80372a:	a1 34 50 80 00       	mov    0x805034,%eax
  80372f:	85 c0                	test   %eax,%eax
  803731:	0f 85 52 ff ff ff    	jne    803689 <realloc_block_FF+0x3cb>
  803737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373b:	0f 85 48 ff ff ff    	jne    803689 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803741:	83 ec 04             	sub    $0x4,%esp
  803744:	6a 00                	push   $0x0
  803746:	ff 75 d8             	pushl  -0x28(%ebp)
  803749:	ff 75 d4             	pushl  -0x2c(%ebp)
  80374c:	e8 7a eb ff ff       	call   8022cb <set_block_data>
  803751:	83 c4 10             	add    $0x10,%esp
				return va;
  803754:	8b 45 08             	mov    0x8(%ebp),%eax
  803757:	e9 7b 02 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80375c:	83 ec 0c             	sub    $0xc,%esp
  80375f:	68 99 46 80 00       	push   $0x804699
  803764:	e8 76 cf ff ff       	call   8006df <cprintf>
  803769:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	e9 63 02 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803774:	8b 45 0c             	mov    0xc(%ebp),%eax
  803777:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80377a:	0f 86 4d 02 00 00    	jbe    8039cd <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803780:	83 ec 0c             	sub    $0xc,%esp
  803783:	ff 75 e4             	pushl  -0x1c(%ebp)
  803786:	e8 08 e8 ff ff       	call   801f93 <is_free_block>
  80378b:	83 c4 10             	add    $0x10,%esp
  80378e:	84 c0                	test   %al,%al
  803790:	0f 84 37 02 00 00    	je     8039cd <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803796:	8b 45 0c             	mov    0xc(%ebp),%eax
  803799:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80379c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80379f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037a5:	76 38                	jbe    8037df <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037a7:	83 ec 0c             	sub    $0xc,%esp
  8037aa:	ff 75 08             	pushl  0x8(%ebp)
  8037ad:	e8 0c fa ff ff       	call   8031be <free_block>
  8037b2:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037b5:	83 ec 0c             	sub    $0xc,%esp
  8037b8:	ff 75 0c             	pushl  0xc(%ebp)
  8037bb:	e8 3a eb ff ff       	call   8022fa <alloc_block_FF>
  8037c0:	83 c4 10             	add    $0x10,%esp
  8037c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037c6:	83 ec 08             	sub    $0x8,%esp
  8037c9:	ff 75 c0             	pushl  -0x40(%ebp)
  8037cc:	ff 75 08             	pushl  0x8(%ebp)
  8037cf:	e8 ab fa ff ff       	call   80327f <copy_data>
  8037d4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037da:	e9 f8 01 00 00       	jmp    8039d7 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037e8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ec:	0f 87 a0 00 00 00    	ja     803892 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f6:	75 17                	jne    80380f <realloc_block_FF+0x551>
  8037f8:	83 ec 04             	sub    $0x4,%esp
  8037fb:	68 8b 45 80 00       	push   $0x80458b
  803800:	68 38 02 00 00       	push   $0x238
  803805:	68 a9 45 80 00       	push   $0x8045a9
  80380a:	e8 13 cc ff ff       	call   800422 <_panic>
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 10                	je     803828 <realloc_block_FF+0x56a>
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	8b 00                	mov    (%eax),%eax
  80381d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803820:	8b 52 04             	mov    0x4(%edx),%edx
  803823:	89 50 04             	mov    %edx,0x4(%eax)
  803826:	eb 0b                	jmp    803833 <realloc_block_FF+0x575>
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	8b 40 04             	mov    0x4(%eax),%eax
  80382e:	a3 30 50 80 00       	mov    %eax,0x805030
  803833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	74 0f                	je     80384c <realloc_block_FF+0x58e>
  80383d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803840:	8b 40 04             	mov    0x4(%eax),%eax
  803843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803846:	8b 12                	mov    (%edx),%edx
  803848:	89 10                	mov    %edx,(%eax)
  80384a:	eb 0a                	jmp    803856 <realloc_block_FF+0x598>
  80384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803869:	a1 38 50 80 00       	mov    0x805038,%eax
  80386e:	48                   	dec    %eax
  80386f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803874:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387a:	01 d0                	add    %edx,%eax
  80387c:	83 ec 04             	sub    $0x4,%esp
  80387f:	6a 01                	push   $0x1
  803881:	50                   	push   %eax
  803882:	ff 75 08             	pushl  0x8(%ebp)
  803885:	e8 41 ea ff ff       	call   8022cb <set_block_data>
  80388a:	83 c4 10             	add    $0x10,%esp
  80388d:	e9 36 01 00 00       	jmp    8039c8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803892:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803895:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803898:	01 d0                	add    %edx,%eax
  80389a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80389d:	83 ec 04             	sub    $0x4,%esp
  8038a0:	6a 01                	push   $0x1
  8038a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8038a5:	ff 75 08             	pushl  0x8(%ebp)
  8038a8:	e8 1e ea ff ff       	call   8022cb <set_block_data>
  8038ad:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b3:	83 e8 04             	sub    $0x4,%eax
  8038b6:	8b 00                	mov    (%eax),%eax
  8038b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8038bb:	89 c2                	mov    %eax,%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	01 d0                	add    %edx,%eax
  8038c2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c9:	74 06                	je     8038d1 <realloc_block_FF+0x613>
  8038cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038cf:	75 17                	jne    8038e8 <realloc_block_FF+0x62a>
  8038d1:	83 ec 04             	sub    $0x4,%esp
  8038d4:	68 1c 46 80 00       	push   $0x80461c
  8038d9:	68 44 02 00 00       	push   $0x244
  8038de:	68 a9 45 80 00       	push   $0x8045a9
  8038e3:	e8 3a cb ff ff       	call   800422 <_panic>
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 10                	mov    (%eax),%edx
  8038ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f0:	89 10                	mov    %edx,(%eax)
  8038f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 0b                	je     803906 <realloc_block_FF+0x648>
  8038fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fe:	8b 00                	mov    (%eax),%eax
  803900:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80390c:	89 10                	mov    %edx,(%eax)
  80390e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803914:	89 50 04             	mov    %edx,0x4(%eax)
  803917:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	75 08                	jne    803928 <realloc_block_FF+0x66a>
  803920:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803923:	a3 30 50 80 00       	mov    %eax,0x805030
  803928:	a1 38 50 80 00       	mov    0x805038,%eax
  80392d:	40                   	inc    %eax
  80392e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803933:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803937:	75 17                	jne    803950 <realloc_block_FF+0x692>
  803939:	83 ec 04             	sub    $0x4,%esp
  80393c:	68 8b 45 80 00       	push   $0x80458b
  803941:	68 45 02 00 00       	push   $0x245
  803946:	68 a9 45 80 00       	push   $0x8045a9
  80394b:	e8 d2 ca ff ff       	call   800422 <_panic>
  803950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	85 c0                	test   %eax,%eax
  803957:	74 10                	je     803969 <realloc_block_FF+0x6ab>
  803959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803961:	8b 52 04             	mov    0x4(%edx),%edx
  803964:	89 50 04             	mov    %edx,0x4(%eax)
  803967:	eb 0b                	jmp    803974 <realloc_block_FF+0x6b6>
  803969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396c:	8b 40 04             	mov    0x4(%eax),%eax
  80396f:	a3 30 50 80 00       	mov    %eax,0x805030
  803974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803977:	8b 40 04             	mov    0x4(%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	74 0f                	je     80398d <realloc_block_FF+0x6cf>
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 40 04             	mov    0x4(%eax),%eax
  803984:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803987:	8b 12                	mov    (%edx),%edx
  803989:	89 10                	mov    %edx,(%eax)
  80398b:	eb 0a                	jmp    803997 <realloc_block_FF+0x6d9>
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	8b 00                	mov    (%eax),%eax
  803992:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8039af:	48                   	dec    %eax
  8039b0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039b5:	83 ec 04             	sub    $0x4,%esp
  8039b8:	6a 00                	push   $0x0
  8039ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8039bd:	ff 75 b8             	pushl  -0x48(%ebp)
  8039c0:	e8 06 e9 ff ff       	call   8022cb <set_block_data>
  8039c5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cb:	eb 0a                	jmp    8039d7 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039cd:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039d7:	c9                   	leave  
  8039d8:	c3                   	ret    

008039d9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039d9:	55                   	push   %ebp
  8039da:	89 e5                	mov    %esp,%ebp
  8039dc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039df:	83 ec 04             	sub    $0x4,%esp
  8039e2:	68 a0 46 80 00       	push   $0x8046a0
  8039e7:	68 58 02 00 00       	push   $0x258
  8039ec:	68 a9 45 80 00       	push   $0x8045a9
  8039f1:	e8 2c ca ff ff       	call   800422 <_panic>

008039f6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039f6:	55                   	push   %ebp
  8039f7:	89 e5                	mov    %esp,%ebp
  8039f9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	68 c8 46 80 00       	push   $0x8046c8
  803a04:	68 61 02 00 00       	push   $0x261
  803a09:	68 a9 45 80 00       	push   $0x8045a9
  803a0e:	e8 0f ca ff ff       	call   800422 <_panic>
  803a13:	90                   	nop

00803a14 <__udivdi3>:
  803a14:	55                   	push   %ebp
  803a15:	57                   	push   %edi
  803a16:	56                   	push   %esi
  803a17:	53                   	push   %ebx
  803a18:	83 ec 1c             	sub    $0x1c,%esp
  803a1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a2b:	89 ca                	mov    %ecx,%edx
  803a2d:	89 f8                	mov    %edi,%eax
  803a2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a33:	85 f6                	test   %esi,%esi
  803a35:	75 2d                	jne    803a64 <__udivdi3+0x50>
  803a37:	39 cf                	cmp    %ecx,%edi
  803a39:	77 65                	ja     803aa0 <__udivdi3+0x8c>
  803a3b:	89 fd                	mov    %edi,%ebp
  803a3d:	85 ff                	test   %edi,%edi
  803a3f:	75 0b                	jne    803a4c <__udivdi3+0x38>
  803a41:	b8 01 00 00 00       	mov    $0x1,%eax
  803a46:	31 d2                	xor    %edx,%edx
  803a48:	f7 f7                	div    %edi
  803a4a:	89 c5                	mov    %eax,%ebp
  803a4c:	31 d2                	xor    %edx,%edx
  803a4e:	89 c8                	mov    %ecx,%eax
  803a50:	f7 f5                	div    %ebp
  803a52:	89 c1                	mov    %eax,%ecx
  803a54:	89 d8                	mov    %ebx,%eax
  803a56:	f7 f5                	div    %ebp
  803a58:	89 cf                	mov    %ecx,%edi
  803a5a:	89 fa                	mov    %edi,%edx
  803a5c:	83 c4 1c             	add    $0x1c,%esp
  803a5f:	5b                   	pop    %ebx
  803a60:	5e                   	pop    %esi
  803a61:	5f                   	pop    %edi
  803a62:	5d                   	pop    %ebp
  803a63:	c3                   	ret    
  803a64:	39 ce                	cmp    %ecx,%esi
  803a66:	77 28                	ja     803a90 <__udivdi3+0x7c>
  803a68:	0f bd fe             	bsr    %esi,%edi
  803a6b:	83 f7 1f             	xor    $0x1f,%edi
  803a6e:	75 40                	jne    803ab0 <__udivdi3+0x9c>
  803a70:	39 ce                	cmp    %ecx,%esi
  803a72:	72 0a                	jb     803a7e <__udivdi3+0x6a>
  803a74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a78:	0f 87 9e 00 00 00    	ja     803b1c <__udivdi3+0x108>
  803a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a83:	89 fa                	mov    %edi,%edx
  803a85:	83 c4 1c             	add    $0x1c,%esp
  803a88:	5b                   	pop    %ebx
  803a89:	5e                   	pop    %esi
  803a8a:	5f                   	pop    %edi
  803a8b:	5d                   	pop    %ebp
  803a8c:	c3                   	ret    
  803a8d:	8d 76 00             	lea    0x0(%esi),%esi
  803a90:	31 ff                	xor    %edi,%edi
  803a92:	31 c0                	xor    %eax,%eax
  803a94:	89 fa                	mov    %edi,%edx
  803a96:	83 c4 1c             	add    $0x1c,%esp
  803a99:	5b                   	pop    %ebx
  803a9a:	5e                   	pop    %esi
  803a9b:	5f                   	pop    %edi
  803a9c:	5d                   	pop    %ebp
  803a9d:	c3                   	ret    
  803a9e:	66 90                	xchg   %ax,%ax
  803aa0:	89 d8                	mov    %ebx,%eax
  803aa2:	f7 f7                	div    %edi
  803aa4:	31 ff                	xor    %edi,%edi
  803aa6:	89 fa                	mov    %edi,%edx
  803aa8:	83 c4 1c             	add    $0x1c,%esp
  803aab:	5b                   	pop    %ebx
  803aac:	5e                   	pop    %esi
  803aad:	5f                   	pop    %edi
  803aae:	5d                   	pop    %ebp
  803aaf:	c3                   	ret    
  803ab0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ab5:	89 eb                	mov    %ebp,%ebx
  803ab7:	29 fb                	sub    %edi,%ebx
  803ab9:	89 f9                	mov    %edi,%ecx
  803abb:	d3 e6                	shl    %cl,%esi
  803abd:	89 c5                	mov    %eax,%ebp
  803abf:	88 d9                	mov    %bl,%cl
  803ac1:	d3 ed                	shr    %cl,%ebp
  803ac3:	89 e9                	mov    %ebp,%ecx
  803ac5:	09 f1                	or     %esi,%ecx
  803ac7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803acb:	89 f9                	mov    %edi,%ecx
  803acd:	d3 e0                	shl    %cl,%eax
  803acf:	89 c5                	mov    %eax,%ebp
  803ad1:	89 d6                	mov    %edx,%esi
  803ad3:	88 d9                	mov    %bl,%cl
  803ad5:	d3 ee                	shr    %cl,%esi
  803ad7:	89 f9                	mov    %edi,%ecx
  803ad9:	d3 e2                	shl    %cl,%edx
  803adb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803adf:	88 d9                	mov    %bl,%cl
  803ae1:	d3 e8                	shr    %cl,%eax
  803ae3:	09 c2                	or     %eax,%edx
  803ae5:	89 d0                	mov    %edx,%eax
  803ae7:	89 f2                	mov    %esi,%edx
  803ae9:	f7 74 24 0c          	divl   0xc(%esp)
  803aed:	89 d6                	mov    %edx,%esi
  803aef:	89 c3                	mov    %eax,%ebx
  803af1:	f7 e5                	mul    %ebp
  803af3:	39 d6                	cmp    %edx,%esi
  803af5:	72 19                	jb     803b10 <__udivdi3+0xfc>
  803af7:	74 0b                	je     803b04 <__udivdi3+0xf0>
  803af9:	89 d8                	mov    %ebx,%eax
  803afb:	31 ff                	xor    %edi,%edi
  803afd:	e9 58 ff ff ff       	jmp    803a5a <__udivdi3+0x46>
  803b02:	66 90                	xchg   %ax,%ax
  803b04:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b08:	89 f9                	mov    %edi,%ecx
  803b0a:	d3 e2                	shl    %cl,%edx
  803b0c:	39 c2                	cmp    %eax,%edx
  803b0e:	73 e9                	jae    803af9 <__udivdi3+0xe5>
  803b10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b13:	31 ff                	xor    %edi,%edi
  803b15:	e9 40 ff ff ff       	jmp    803a5a <__udivdi3+0x46>
  803b1a:	66 90                	xchg   %ax,%ax
  803b1c:	31 c0                	xor    %eax,%eax
  803b1e:	e9 37 ff ff ff       	jmp    803a5a <__udivdi3+0x46>
  803b23:	90                   	nop

00803b24 <__umoddi3>:
  803b24:	55                   	push   %ebp
  803b25:	57                   	push   %edi
  803b26:	56                   	push   %esi
  803b27:	53                   	push   %ebx
  803b28:	83 ec 1c             	sub    $0x1c,%esp
  803b2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b43:	89 f3                	mov    %esi,%ebx
  803b45:	89 fa                	mov    %edi,%edx
  803b47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b4b:	89 34 24             	mov    %esi,(%esp)
  803b4e:	85 c0                	test   %eax,%eax
  803b50:	75 1a                	jne    803b6c <__umoddi3+0x48>
  803b52:	39 f7                	cmp    %esi,%edi
  803b54:	0f 86 a2 00 00 00    	jbe    803bfc <__umoddi3+0xd8>
  803b5a:	89 c8                	mov    %ecx,%eax
  803b5c:	89 f2                	mov    %esi,%edx
  803b5e:	f7 f7                	div    %edi
  803b60:	89 d0                	mov    %edx,%eax
  803b62:	31 d2                	xor    %edx,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	39 f0                	cmp    %esi,%eax
  803b6e:	0f 87 ac 00 00 00    	ja     803c20 <__umoddi3+0xfc>
  803b74:	0f bd e8             	bsr    %eax,%ebp
  803b77:	83 f5 1f             	xor    $0x1f,%ebp
  803b7a:	0f 84 ac 00 00 00    	je     803c2c <__umoddi3+0x108>
  803b80:	bf 20 00 00 00       	mov    $0x20,%edi
  803b85:	29 ef                	sub    %ebp,%edi
  803b87:	89 fe                	mov    %edi,%esi
  803b89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b8d:	89 e9                	mov    %ebp,%ecx
  803b8f:	d3 e0                	shl    %cl,%eax
  803b91:	89 d7                	mov    %edx,%edi
  803b93:	89 f1                	mov    %esi,%ecx
  803b95:	d3 ef                	shr    %cl,%edi
  803b97:	09 c7                	or     %eax,%edi
  803b99:	89 e9                	mov    %ebp,%ecx
  803b9b:	d3 e2                	shl    %cl,%edx
  803b9d:	89 14 24             	mov    %edx,(%esp)
  803ba0:	89 d8                	mov    %ebx,%eax
  803ba2:	d3 e0                	shl    %cl,%eax
  803ba4:	89 c2                	mov    %eax,%edx
  803ba6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803baa:	d3 e0                	shl    %cl,%eax
  803bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb4:	89 f1                	mov    %esi,%ecx
  803bb6:	d3 e8                	shr    %cl,%eax
  803bb8:	09 d0                	or     %edx,%eax
  803bba:	d3 eb                	shr    %cl,%ebx
  803bbc:	89 da                	mov    %ebx,%edx
  803bbe:	f7 f7                	div    %edi
  803bc0:	89 d3                	mov    %edx,%ebx
  803bc2:	f7 24 24             	mull   (%esp)
  803bc5:	89 c6                	mov    %eax,%esi
  803bc7:	89 d1                	mov    %edx,%ecx
  803bc9:	39 d3                	cmp    %edx,%ebx
  803bcb:	0f 82 87 00 00 00    	jb     803c58 <__umoddi3+0x134>
  803bd1:	0f 84 91 00 00 00    	je     803c68 <__umoddi3+0x144>
  803bd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bdb:	29 f2                	sub    %esi,%edx
  803bdd:	19 cb                	sbb    %ecx,%ebx
  803bdf:	89 d8                	mov    %ebx,%eax
  803be1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803be5:	d3 e0                	shl    %cl,%eax
  803be7:	89 e9                	mov    %ebp,%ecx
  803be9:	d3 ea                	shr    %cl,%edx
  803beb:	09 d0                	or     %edx,%eax
  803bed:	89 e9                	mov    %ebp,%ecx
  803bef:	d3 eb                	shr    %cl,%ebx
  803bf1:	89 da                	mov    %ebx,%edx
  803bf3:	83 c4 1c             	add    $0x1c,%esp
  803bf6:	5b                   	pop    %ebx
  803bf7:	5e                   	pop    %esi
  803bf8:	5f                   	pop    %edi
  803bf9:	5d                   	pop    %ebp
  803bfa:	c3                   	ret    
  803bfb:	90                   	nop
  803bfc:	89 fd                	mov    %edi,%ebp
  803bfe:	85 ff                	test   %edi,%edi
  803c00:	75 0b                	jne    803c0d <__umoddi3+0xe9>
  803c02:	b8 01 00 00 00       	mov    $0x1,%eax
  803c07:	31 d2                	xor    %edx,%edx
  803c09:	f7 f7                	div    %edi
  803c0b:	89 c5                	mov    %eax,%ebp
  803c0d:	89 f0                	mov    %esi,%eax
  803c0f:	31 d2                	xor    %edx,%edx
  803c11:	f7 f5                	div    %ebp
  803c13:	89 c8                	mov    %ecx,%eax
  803c15:	f7 f5                	div    %ebp
  803c17:	89 d0                	mov    %edx,%eax
  803c19:	e9 44 ff ff ff       	jmp    803b62 <__umoddi3+0x3e>
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	89 c8                	mov    %ecx,%eax
  803c22:	89 f2                	mov    %esi,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	3b 04 24             	cmp    (%esp),%eax
  803c2f:	72 06                	jb     803c37 <__umoddi3+0x113>
  803c31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c35:	77 0f                	ja     803c46 <__umoddi3+0x122>
  803c37:	89 f2                	mov    %esi,%edx
  803c39:	29 f9                	sub    %edi,%ecx
  803c3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c3f:	89 14 24             	mov    %edx,(%esp)
  803c42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c46:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c4a:	8b 14 24             	mov    (%esp),%edx
  803c4d:	83 c4 1c             	add    $0x1c,%esp
  803c50:	5b                   	pop    %ebx
  803c51:	5e                   	pop    %esi
  803c52:	5f                   	pop    %edi
  803c53:	5d                   	pop    %ebp
  803c54:	c3                   	ret    
  803c55:	8d 76 00             	lea    0x0(%esi),%esi
  803c58:	2b 04 24             	sub    (%esp),%eax
  803c5b:	19 fa                	sbb    %edi,%edx
  803c5d:	89 d1                	mov    %edx,%ecx
  803c5f:	89 c6                	mov    %eax,%esi
  803c61:	e9 71 ff ff ff       	jmp    803bd7 <__umoddi3+0xb3>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c6c:	72 ea                	jb     803c58 <__umoddi3+0x134>
  803c6e:	89 d9                	mov    %ebx,%ecx
  803c70:	e9 62 ff ff ff       	jmp    803bd7 <__umoddi3+0xb3>
