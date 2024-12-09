
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
  800060:	68 40 3d 80 00       	push   $0x803d40
  800065:	6a 12                	push   $0x12
  800067:	68 5c 3d 80 00       	push   $0x803d5c
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
  8000bc:	e8 0b 1a 00 00       	call   801acc <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 4e 1a 00 00       	call   801b17 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 78 3d 80 00       	push   $0x803d78
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 5c 3d 80 00       	push   $0x803d5c
  800100:	e8 1d 03 00 00       	call   800422 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 0d 1a 00 00       	call   801b17 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 3d 80 00       	push   $0x803da8
  800117:	6a 32                	push   $0x32
  800119:	68 5c 3d 80 00       	push   $0x803d5c
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 a4 19 00 00       	call   801acc <sys_calculate_free_frames>
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
  80015f:	e8 68 19 00 00       	call   801acc <sys_calculate_free_frames>
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
  80017c:	68 d8 3d 80 00       	push   $0x803dd8
  800181:	6a 3c                	push   $0x3c
  800183:	68 5c 3d 80 00       	push   $0x803d5c
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
  8001c7:	e8 5b 1d 00 00       	call   801f27 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 3e 80 00       	push   $0x803e54
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 5c 3d 80 00       	push   $0x803d5c
  8001e7:	e8 36 02 00 00       	call   800422 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 db 18 00 00       	call   801acc <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 1e 19 00 00       	call   801b17 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 04 19 00 00       	call   801b17 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 3e 80 00       	push   $0x803e74
  800220:	6a 4d                	push   $0x4d
  800222:	68 5c 3d 80 00       	push   $0x803d5c
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 9b 18 00 00       	call   801acc <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 3e 80 00       	push   $0x803eb0
  800247:	6a 4e                	push   $0x4e
  800249:	68 5c 3d 80 00       	push   $0x803d5c
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
  80028d:	e8 95 1c 00 00       	call   801f27 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 3e 80 00       	push   $0x803efc
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 5c 3d 80 00       	push   $0x803d5c
  8002ad:	e8 70 01 00 00       	call   800422 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 1c 1b 00 00       	call   801dd3 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 30 1b 00 00       	call   801ded <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 04 1b 00 00       	call   801dd3 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 20 3f 80 00       	push   $0x803f20
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 5c 3d 80 00       	push   $0x803d5c
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
  8002e9:	e8 a7 19 00 00       	call   801c95 <sys_getenvindex>
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
  800357:	e8 bd 16 00 00       	call   801a19 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 84 3f 80 00       	push   $0x803f84
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
  800387:	68 ac 3f 80 00       	push   $0x803fac
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
  8003b8:	68 d4 3f 80 00       	push   $0x803fd4
  8003bd:	e8 1d 03 00 00       	call   8006df <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	50                   	push   %eax
  8003d4:	68 2c 40 80 00       	push   $0x80402c
  8003d9:	e8 01 03 00 00       	call   8006df <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 84 3f 80 00       	push   $0x803f84
  8003e9:	e8 f1 02 00 00       	call   8006df <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f1:	e8 3d 16 00 00       	call   801a33 <sys_unlock_cons>
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
  800409:	e8 53 18 00 00       	call   801c61 <sys_destroy_env>
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
  80041a:	e8 a8 18 00 00       	call   801cc7 <sys_exit_env>
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
  800443:	68 40 40 80 00       	push   $0x804040
  800448:	e8 92 02 00 00       	call   8006df <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800450:	a1 00 50 80 00       	mov    0x805000,%eax
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	50                   	push   %eax
  80045c:	68 45 40 80 00       	push   $0x804045
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
  800480:	68 61 40 80 00       	push   $0x804061
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
  8004af:	68 64 40 80 00       	push   $0x804064
  8004b4:	6a 26                	push   $0x26
  8004b6:	68 b0 40 80 00       	push   $0x8040b0
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
  800584:	68 bc 40 80 00       	push   $0x8040bc
  800589:	6a 3a                	push   $0x3a
  80058b:	68 b0 40 80 00       	push   $0x8040b0
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
  8005f7:	68 10 41 80 00       	push   $0x804110
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 b0 40 80 00       	push   $0x8040b0
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
  800651:	e8 81 13 00 00       	call   8019d7 <sys_cputs>
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
  8006c8:	e8 0a 13 00 00       	call   8019d7 <sys_cputs>
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
  800712:	e8 02 13 00 00       	call   801a19 <sys_lock_cons>
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
  800732:	e8 fc 12 00 00       	call   801a33 <sys_unlock_cons>
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
  80077c:	e8 57 33 00 00       	call   803ad8 <__udivdi3>
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
  8007cc:	e8 17 34 00 00       	call   803be8 <__umoddi3>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	05 74 43 80 00       	add    $0x804374,%eax
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
  800927:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  800a08:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	75 19                	jne    800a2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a13:	53                   	push   %ebx
  800a14:	68 85 43 80 00       	push   $0x804385
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
  800a2d:	68 8e 43 80 00       	push   $0x80438e
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
  800a5a:	be 91 43 80 00       	mov    $0x804391,%esi
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
  801465:	68 08 45 80 00       	push   $0x804508
  80146a:	68 3f 01 00 00       	push   $0x13f
  80146f:	68 2a 45 80 00       	push   $0x80452a
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
  801485:	e8 f8 0a 00 00       	call   801f82 <sys_sbrk>
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
  801500:	e8 01 09 00 00       	call   801e06 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 dd 0e 00 00       	call   8023f1 <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 13 09 00 00       	call   801e37 <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 76 13 00 00       	call   8028ad <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80156b:	a1 20 50 80 00       	mov    0x805020,%eax
  801570:	8b 40 78             	mov    0x78(%eax),%eax
  801573:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801576:	29 c2                	sub    %eax,%edx
  801578:	89 d0                	mov    %edx,%eax
  80157a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80157f:	c1 e8 0c             	shr    $0xc,%eax
  801582:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801589:	85 c0                	test   %eax,%eax
  80158b:	0f 85 ab 00 00 00    	jne    80163c <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801594:	05 00 10 00 00       	add    $0x1000,%eax
  801599:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80159c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  8015cf:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 08                	je     8015e2 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  801626:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  80163c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801640:	75 16                	jne    801658 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801642:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801649:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801650:	0f 86 15 ff ff ff    	jbe    80156b <malloc+0xdc>
  801656:	eb 01                	jmp    801659 <malloc+0x1ca>
				}
				

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
  801688:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	e8 1c 09 00 00       	call   801fb9 <sys_allocate_user_mem>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	eb 07                	jmp    8016a9 <malloc+0x21a>
		
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
  8016e0:	e8 8c 09 00 00       	call   802071 <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 9c 1b 00 00       	call   803292 <free_block>
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
  80172b:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801768:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  80176f:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	83 ec 08             	sub    $0x8,%esp
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	e8 1a 08 00 00       	call   801f9d <sys_free_user_mem>
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
  801796:	68 38 45 80 00       	push   $0x804538
  80179b:	68 87 00 00 00       	push   $0x87
  8017a0:	68 62 45 80 00       	push   $0x804562
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
  8017c4:	e9 87 00 00 00       	jmp    801850 <smalloc+0xa3>
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
  8017f5:	75 07                	jne    8017fe <smalloc+0x51>
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	eb 52                	jmp    801850 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017fe:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801802:	ff 75 ec             	pushl  -0x14(%ebp)
  801805:	50                   	push   %eax
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	e8 93 03 00 00       	call   801ba4 <sys_createSharedObject>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801817:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80181b:	74 06                	je     801823 <smalloc+0x76>
  80181d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801821:	75 07                	jne    80182a <smalloc+0x7d>
  801823:	b8 00 00 00 00       	mov    $0x0,%eax
  801828:	eb 26                	jmp    801850 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80182a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80182d:	a1 20 50 80 00       	mov    0x805020,%eax
  801832:	8b 40 78             	mov    0x78(%eax),%eax
  801835:	29 c2                	sub    %eax,%edx
  801837:	89 d0                	mov    %edx,%eax
  801839:	2d 00 10 00 00       	sub    $0x1000,%eax
  80183e:	c1 e8 0c             	shr    $0xc,%eax
  801841:	89 c2                	mov    %eax,%edx
  801843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801846:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80184d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 68 03 00 00       	call   801bce <sys_getSizeOfSharedObject>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80186c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801870:	75 07                	jne    801879 <sget+0x27>
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
  801877:	eb 7f                	jmp    8018f8 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80187f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801886:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	39 d0                	cmp    %edx,%eax
  80188e:	73 02                	jae    801892 <sget+0x40>
  801890:	89 d0                	mov    %edx,%eax
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	50                   	push   %eax
  801896:	e8 f4 fb ff ff       	call   80148f <malloc>
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018a5:	75 07                	jne    8018ae <sget+0x5c>
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	eb 4a                	jmp    8018f8 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	e8 2c 03 00 00       	call   801beb <sys_getSharedObject>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8018c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8018cd:	8b 40 78             	mov    0x78(%eax),%eax
  8018d0:	29 c2                	sub    %eax,%edx
  8018d2:	89 d0                	mov    %edx,%eax
  8018d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d9:	c1 e8 0c             	shr    $0xc,%eax
  8018dc:	89 c2                	mov    %eax,%edx
  8018de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e1:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018e8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018ec:	75 07                	jne    8018f5 <sget+0xa3>
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f3:	eb 03                	jmp    8018f8 <sget+0xa6>
	return ptr;
  8018f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801900:	8b 55 08             	mov    0x8(%ebp),%edx
  801903:	a1 20 50 80 00       	mov    0x805020,%eax
  801908:	8b 40 78             	mov    0x78(%eax),%eax
  80190b:	29 c2                	sub    %eax,%edx
  80190d:	89 d0                	mov    %edx,%eax
  80190f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801914:	c1 e8 0c             	shr    $0xc,%eax
  801917:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80191e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	ff 75 f4             	pushl  -0xc(%ebp)
  80192a:	e8 db 02 00 00       	call   801c0a <sys_freeSharedObject>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801935:	90                   	nop
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	68 70 45 80 00       	push   $0x804570
  801946:	68 e4 00 00 00       	push   $0xe4
  80194b:	68 62 45 80 00       	push   $0x804562
  801950:	e8 cd ea ff ff       	call   800422 <_panic>

00801955 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	68 96 45 80 00       	push   $0x804596
  801963:	68 f0 00 00 00       	push   $0xf0
  801968:	68 62 45 80 00       	push   $0x804562
  80196d:	e8 b0 ea ff ff       	call   800422 <_panic>

00801972 <shrink>:

}
void shrink(uint32 newSize)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	68 96 45 80 00       	push   $0x804596
  801980:	68 f5 00 00 00       	push   $0xf5
  801985:	68 62 45 80 00       	push   $0x804562
  80198a:	e8 93 ea ff ff       	call   800422 <_panic>

0080198f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	68 96 45 80 00       	push   $0x804596
  80199d:	68 fa 00 00 00       	push   $0xfa
  8019a2:	68 62 45 80 00       	push   $0x804562
  8019a7:	e8 76 ea ff ff       	call   800422 <_panic>

008019ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c7:	cd 30                	int    $0x30
  8019c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	5b                   	pop    %ebx
  8019d3:	5e                   	pop    %esi
  8019d4:	5f                   	pop    %edi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	50                   	push   %eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	e8 b2 ff ff ff       	call   8019ac <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 02                	push   $0x2
  801a0f:	e8 98 ff ff ff       	call   8019ac <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 03                	push   $0x3
  801a28:	e8 7f ff ff ff       	call   8019ac <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	90                   	nop
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 04                	push   $0x4
  801a42:	e8 65 ff ff ff       	call   8019ac <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 08                	push   $0x8
  801a60:	e8 47 ff ff ff       	call   8019ac <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a6f:	8b 75 18             	mov    0x18(%ebp),%esi
  801a72:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	51                   	push   %ecx
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 09                	push   $0x9
  801a85:	e8 22 ff ff ff       	call   8019ac <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a90:	5b                   	pop    %ebx
  801a91:	5e                   	pop    %esi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    

00801a94 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 0a                	push   $0xa
  801aa7:	e8 00 ff ff ff       	call   8019ac <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	ff 75 08             	pushl  0x8(%ebp)
  801ac0:	6a 0b                	push   $0xb
  801ac2:	e8 e5 fe ff ff       	call   8019ac <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 0c                	push   $0xc
  801adb:	e8 cc fe ff ff       	call   8019ac <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 0d                	push   $0xd
  801af4:	e8 b3 fe ff ff       	call   8019ac <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 0e                	push   $0xe
  801b0d:	e8 9a fe ff ff       	call   8019ac <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 0f                	push   $0xf
  801b26:	e8 81 fe ff ff       	call   8019ac <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	6a 10                	push   $0x10
  801b40:	e8 67 fe ff ff       	call   8019ac <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 11                	push   $0x11
  801b59:	e8 4e fe ff ff       	call   8019ac <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b70:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	50                   	push   %eax
  801b7d:	6a 01                	push   $0x1
  801b7f:	e8 28 fe ff ff       	call   8019ac <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 14                	push   $0x14
  801b99:	e8 0e fe ff ff       	call   8019ac <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	90                   	nop
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	ff 75 0c             	pushl  0xc(%ebp)
  801bc1:	50                   	push   %eax
  801bc2:	6a 15                	push   $0x15
  801bc4:	e8 e3 fd ff ff       	call   8019ac <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 16                	push   $0x16
  801be1:	e8 c6 fd ff ff       	call   8019ac <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	51                   	push   %ecx
  801bfc:	52                   	push   %edx
  801bfd:	50                   	push   %eax
  801bfe:	6a 17                	push   $0x17
  801c00:	e8 a7 fd ff ff       	call   8019ac <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 18                	push   $0x18
  801c1d:	e8 8a fd ff ff       	call   8019ac <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	ff 75 14             	pushl  0x14(%ebp)
  801c32:	ff 75 10             	pushl  0x10(%ebp)
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	50                   	push   %eax
  801c39:	6a 19                	push   $0x19
  801c3b:	e8 6c fd ff ff       	call   8019ac <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	50                   	push   %eax
  801c54:	6a 1a                	push   $0x1a
  801c56:	e8 51 fd ff ff       	call   8019ac <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	50                   	push   %eax
  801c70:	6a 1b                	push   $0x1b
  801c72:	e8 35 fd ff ff       	call   8019ac <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 05                	push   $0x5
  801c8b:	e8 1c fd ff ff       	call   8019ac <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 06                	push   $0x6
  801ca4:	e8 03 fd ff ff       	call   8019ac <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 07                	push   $0x7
  801cbd:	e8 ea fc ff ff       	call   8019ac <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_exit_env>:


void sys_exit_env(void)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 1c                	push   $0x1c
  801cd6:	e8 d1 fc ff ff       	call   8019ac <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	90                   	nop
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ce7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cea:	8d 50 04             	lea    0x4(%eax),%edx
  801ced:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 1d                	push   $0x1d
  801cfa:	e8 ad fc ff ff       	call   8019ac <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
	return result;
  801d02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0b:	89 01                	mov    %eax,(%ecx)
  801d0d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	c9                   	leave  
  801d14:	c2 04 00             	ret    $0x4

00801d17 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	ff 75 10             	pushl  0x10(%ebp)
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 13                	push   $0x13
  801d29:	e8 7e fc ff ff       	call   8019ac <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 1e                	push   $0x1e
  801d43:	e8 64 fc ff ff       	call   8019ac <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d59:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	50                   	push   %eax
  801d66:	6a 1f                	push   $0x1f
  801d68:	e8 3f fc ff ff       	call   8019ac <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <rsttst>:
void rsttst()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 21                	push   $0x21
  801d82:	e8 25 fc ff ff       	call   8019ac <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	8b 45 14             	mov    0x14(%ebp),%eax
  801d96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d99:	8b 55 18             	mov    0x18(%ebp),%edx
  801d9c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	ff 75 10             	pushl  0x10(%ebp)
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 20                	push   $0x20
  801dad:	e8 fa fb ff ff       	call   8019ac <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return ;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <chktst>:
void chktst(uint32 n)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 22                	push   $0x22
  801dc8:	e8 df fb ff ff       	call   8019ac <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <inctst>:

void inctst()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 23                	push   $0x23
  801de2:	e8 c5 fb ff ff       	call   8019ac <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <gettst>:
uint32 gettst()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 24                	push   $0x24
  801dfc:	e8 ab fb ff ff       	call   8019ac <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 25                	push   $0x25
  801e18:	e8 8f fb ff ff       	call   8019ac <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
  801e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e23:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e27:	75 07                	jne    801e30 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e29:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2e:	eb 05                	jmp    801e35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 25                	push   $0x25
  801e49:	e8 5e fb ff ff       	call   8019ac <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
  801e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e54:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e58:	75 07                	jne    801e61 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5f:	eb 05                	jmp    801e66 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 25                	push   $0x25
  801e7a:	e8 2d fb ff ff       	call   8019ac <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
  801e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e85:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e89:	75 07                	jne    801e92 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e90:	eb 05                	jmp    801e97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 25                	push   $0x25
  801eab:	e8 fc fa ff ff       	call   8019ac <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
  801eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eb6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eba:	75 07                	jne    801ec3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec1:	eb 05                	jmp    801ec8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	6a 26                	push   $0x26
  801eda:	e8 cd fa ff ff       	call   8019ac <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ee9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	53                   	push   %ebx
  801ef8:	51                   	push   %ecx
  801ef9:	52                   	push   %edx
  801efa:	50                   	push   %eax
  801efb:	6a 27                	push   $0x27
  801efd:	e8 aa fa ff ff       	call   8019ac <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 28                	push   $0x28
  801f1d:	e8 8a fa ff ff       	call   8019ac <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f2a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	6a 00                	push   $0x0
  801f35:	51                   	push   %ecx
  801f36:	ff 75 10             	pushl  0x10(%ebp)
  801f39:	52                   	push   %edx
  801f3a:	50                   	push   %eax
  801f3b:	6a 29                	push   $0x29
  801f3d:	e8 6a fa ff ff       	call   8019ac <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	ff 75 10             	pushl  0x10(%ebp)
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	6a 12                	push   $0x12
  801f59:	e8 4e fa ff ff       	call   8019ac <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f61:	90                   	nop
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 2a                	push   $0x2a
  801f77:	e8 30 fa ff ff       	call   8019ac <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
	return;
  801f7f:	90                   	nop
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	50                   	push   %eax
  801f91:	6a 2b                	push   $0x2b
  801f93:	e8 14 fa ff ff       	call   8019ac <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	ff 75 0c             	pushl  0xc(%ebp)
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	6a 2c                	push   $0x2c
  801fae:	e8 f9 f9 ff ff       	call   8019ac <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
	return;
  801fb6:	90                   	nop
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	6a 2d                	push   $0x2d
  801fca:	e8 dd f9 ff ff       	call   8019ac <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
	return;
  801fd2:	90                   	nop
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 2e                	push   $0x2e
  801fe7:	e8 c0 f9 ff ff       	call   8019ac <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	50                   	push   %eax
  802006:	6a 2f                	push   $0x2f
  802008:	e8 9f f9 ff ff       	call   8019ac <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
	return;
  802010:	90                   	nop
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	6a 30                	push   $0x30
  802026:	e8 81 f9 ff ff       	call   8019ac <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
	return;
  80202e:	90                   	nop
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	50                   	push   %eax
  802043:	6a 31                	push   $0x31
  802045:	e8 62 f9 ff ff       	call   8019ac <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
  80204d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802050:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	50                   	push   %eax
  802064:	6a 32                	push   $0x32
  802066:	e8 41 f9 ff ff       	call   8019ac <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return;
  80206e:	90                   	nop
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	83 e8 04             	sub    $0x4,%eax
  80207d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802083:	8b 00                	mov    (%eax),%eax
  802085:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	83 e8 04             	sub    $0x4,%eax
  802096:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209c:	8b 00                	mov    (%eax),%eax
  80209e:	83 e0 01             	and    $0x1,%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	0f 94 c0             	sete   %al
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	83 f8 02             	cmp    $0x2,%eax
  8020bb:	74 2b                	je     8020e8 <alloc_block+0x40>
  8020bd:	83 f8 02             	cmp    $0x2,%eax
  8020c0:	7f 07                	jg     8020c9 <alloc_block+0x21>
  8020c2:	83 f8 01             	cmp    $0x1,%eax
  8020c5:	74 0e                	je     8020d5 <alloc_block+0x2d>
  8020c7:	eb 58                	jmp    802121 <alloc_block+0x79>
  8020c9:	83 f8 03             	cmp    $0x3,%eax
  8020cc:	74 2d                	je     8020fb <alloc_block+0x53>
  8020ce:	83 f8 04             	cmp    $0x4,%eax
  8020d1:	74 3b                	je     80210e <alloc_block+0x66>
  8020d3:	eb 4c                	jmp    802121 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 08             	pushl  0x8(%ebp)
  8020db:	e8 11 03 00 00       	call   8023f1 <alloc_block_FF>
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e6:	eb 4a                	jmp    802132 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020e8:	83 ec 0c             	sub    $0xc,%esp
  8020eb:	ff 75 08             	pushl  0x8(%ebp)
  8020ee:	e8 c7 19 00 00       	call   803aba <alloc_block_NF>
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f9:	eb 37                	jmp    802132 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	ff 75 08             	pushl  0x8(%ebp)
  802101:	e8 a7 07 00 00       	call   8028ad <alloc_block_BF>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80210c:	eb 24                	jmp    802132 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 84 19 00 00       	call   803a9d <alloc_block_WF>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80211f:	eb 11                	jmp    802132 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 a8 45 80 00       	push   $0x8045a8
  802129:	e8 b1 e5 ff ff       	call   8006df <cprintf>
  80212e:	83 c4 10             	add    $0x10,%esp
		break;
  802131:	90                   	nop
	}
	return va;
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	53                   	push   %ebx
  80213b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	68 c8 45 80 00       	push   $0x8045c8
  802146:	e8 94 e5 ff ff       	call   8006df <cprintf>
  80214b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	68 f3 45 80 00       	push   $0x8045f3
  802156:	e8 84 e5 ff ff       	call   8006df <cprintf>
  80215b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	eb 37                	jmp    80219d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802166:	83 ec 0c             	sub    $0xc,%esp
  802169:	ff 75 f4             	pushl  -0xc(%ebp)
  80216c:	e8 19 ff ff ff       	call   80208a <is_free_block>
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	0f be d8             	movsbl %al,%ebx
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	ff 75 f4             	pushl  -0xc(%ebp)
  80217d:	e8 ef fe ff ff       	call   802071 <get_block_size>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	53                   	push   %ebx
  802189:	50                   	push   %eax
  80218a:	68 0b 46 80 00       	push   $0x80460b
  80218f:	e8 4b e5 ff ff       	call   8006df <cprintf>
  802194:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802197:	8b 45 10             	mov    0x10(%ebp),%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a1:	74 07                	je     8021aa <print_blocks_list+0x73>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	eb 05                	jmp    8021af <print_blocks_list+0x78>
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	89 45 10             	mov    %eax,0x10(%ebp)
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	75 ad                	jne    802166 <print_blocks_list+0x2f>
  8021b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bd:	75 a7                	jne    802166 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	68 c8 45 80 00       	push   $0x8045c8
  8021c7:	e8 13 e5 ff ff       	call   8006df <cprintf>
  8021cc:	83 c4 10             	add    $0x10,%esp

}
  8021cf:	90                   	nop
  8021d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021de:	83 e0 01             	and    $0x1,%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	74 03                	je     8021e8 <initialize_dynamic_allocator+0x13>
  8021e5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021ec:	0f 84 c7 01 00 00    	je     8023b9 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021f2:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021f9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802202:	01 d0                	add    %edx,%eax
  802204:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802209:	0f 87 ad 01 00 00    	ja     8023bc <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	0f 89 a5 01 00 00    	jns    8023bf <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802220:	01 d0                	add    %edx,%eax
  802222:	83 e8 04             	sub    $0x4,%eax
  802225:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80222a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802231:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802239:	e9 87 00 00 00       	jmp    8022c5 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80223e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802242:	75 14                	jne    802258 <initialize_dynamic_allocator+0x83>
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	68 23 46 80 00       	push   $0x804623
  80224c:	6a 79                	push   $0x79
  80224e:	68 41 46 80 00       	push   $0x804641
  802253:	e8 ca e1 ff ff       	call   800422 <_panic>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 00                	mov    (%eax),%eax
  80225d:	85 c0                	test   %eax,%eax
  80225f:	74 10                	je     802271 <initialize_dynamic_allocator+0x9c>
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
  802266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802269:	8b 52 04             	mov    0x4(%edx),%edx
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	eb 0b                	jmp    80227c <initialize_dynamic_allocator+0xa7>
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	8b 40 04             	mov    0x4(%eax),%eax
  802277:	a3 30 50 80 00       	mov    %eax,0x805030
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 40 04             	mov    0x4(%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	74 0f                	je     802295 <initialize_dynamic_allocator+0xc0>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228f:	8b 12                	mov    (%edx),%edx
  802291:	89 10                	mov    %edx,(%eax)
  802293:	eb 0a                	jmp    80229f <initialize_dynamic_allocator+0xca>
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 00                	mov    (%eax),%eax
  80229a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8022b7:	48                   	dec    %eax
  8022b8:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c9:	74 07                	je     8022d2 <initialize_dynamic_allocator+0xfd>
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 00                	mov    (%eax),%eax
  8022d0:	eb 05                	jmp    8022d7 <initialize_dynamic_allocator+0x102>
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8022dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	0f 85 55 ff ff ff    	jne    80223e <initialize_dynamic_allocator+0x69>
  8022e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ed:	0f 85 4b ff ff ff    	jne    80223e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802302:	a1 44 50 80 00       	mov    0x805044,%eax
  802307:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80230c:	a1 40 50 80 00       	mov    0x805040,%eax
  802311:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	83 c0 08             	add    $0x8,%eax
  80231d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	83 c0 04             	add    $0x4,%eax
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	83 ea 08             	sub    $0x8,%edx
  80232c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80232e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	01 d0                	add    %edx,%eax
  802336:	83 e8 08             	sub    $0x8,%eax
  802339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233c:	83 ea 08             	sub    $0x8,%edx
  80233f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80234a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802354:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802358:	75 17                	jne    802371 <initialize_dynamic_allocator+0x19c>
  80235a:	83 ec 04             	sub    $0x4,%esp
  80235d:	68 5c 46 80 00       	push   $0x80465c
  802362:	68 90 00 00 00       	push   $0x90
  802367:	68 41 46 80 00       	push   $0x804641
  80236c:	e8 b1 e0 ff ff       	call   800422 <_panic>
  802371:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237a:	89 10                	mov    %edx,(%eax)
  80237c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0d                	je     802392 <initialize_dynamic_allocator+0x1bd>
  802385:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80238a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80238d:	89 50 04             	mov    %edx,0x4(%eax)
  802390:	eb 08                	jmp    80239a <initialize_dynamic_allocator+0x1c5>
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	a3 30 50 80 00       	mov    %eax,0x805030
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8023b7:	eb 07                	jmp    8023c0 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023b9:	90                   	nop
  8023ba:	eb 04                	jmp    8023c0 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023bc:	90                   	nop
  8023bd:	eb 01                	jmp    8023c0 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023bf:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c8:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	83 e8 04             	sub    $0x4,%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	83 e0 fe             	and    $0xfffffffe,%eax
  8023e1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	01 c2                	add    %eax,%edx
  8023e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ec:	89 02                	mov    %eax,(%edx)
}
  8023ee:	90                   	nop
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    

008023f1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	83 e0 01             	and    $0x1,%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	74 03                	je     802404 <alloc_block_FF+0x13>
  802401:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802404:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802408:	77 07                	ja     802411 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80240a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802411:	a1 24 50 80 00       	mov    0x805024,%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	75 73                	jne    80248d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	83 c0 10             	add    $0x10,%eax
  802420:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802423:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80242a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	01 d0                	add    %edx,%eax
  802432:	48                   	dec    %eax
  802433:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802439:	ba 00 00 00 00       	mov    $0x0,%edx
  80243e:	f7 75 ec             	divl   -0x14(%ebp)
  802441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802444:	29 d0                	sub    %edx,%eax
  802446:	c1 e8 0c             	shr    $0xc,%eax
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	50                   	push   %eax
  80244d:	e8 27 f0 ff ff       	call   801479 <sbrk>
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	6a 00                	push   $0x0
  80245d:	e8 17 f0 ff ff       	call   801479 <sbrk>
  802462:	83 c4 10             	add    $0x10,%esp
  802465:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80246e:	83 ec 08             	sub    $0x8,%esp
  802471:	50                   	push   %eax
  802472:	ff 75 e4             	pushl  -0x1c(%ebp)
  802475:	e8 5b fd ff ff       	call   8021d5 <initialize_dynamic_allocator>
  80247a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	68 7f 46 80 00       	push   $0x80467f
  802485:	e8 55 e2 ff ff       	call   8006df <cprintf>
  80248a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80248d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802491:	75 0a                	jne    80249d <alloc_block_FF+0xac>
	        return NULL;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
  802498:	e9 0e 04 00 00       	jmp    8028ab <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80249d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ac:	e9 f3 02 00 00       	jmp    8027a4 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8024bd:	e8 af fb ff ff       	call   802071 <get_block_size>
  8024c2:	83 c4 10             	add    $0x10,%esp
  8024c5:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	83 c0 08             	add    $0x8,%eax
  8024ce:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024d1:	0f 87 c5 02 00 00    	ja     80279c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	83 c0 18             	add    $0x18,%eax
  8024dd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024e0:	0f 87 19 02 00 00    	ja     8026ff <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ec:	83 e8 08             	sub    $0x8,%eax
  8024ef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8d 50 08             	lea    0x8(%eax),%edx
  8024f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	83 c0 08             	add    $0x8,%eax
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	6a 01                	push   $0x1
  80250b:	50                   	push   %eax
  80250c:	ff 75 bc             	pushl  -0x44(%ebp)
  80250f:	e8 ae fe ff ff       	call   8023c2 <set_block_data>
  802514:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	75 68                	jne    802589 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802521:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802525:	75 17                	jne    80253e <alloc_block_FF+0x14d>
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	68 5c 46 80 00       	push   $0x80465c
  80252f:	68 d7 00 00 00       	push   $0xd7
  802534:	68 41 46 80 00       	push   $0x804641
  802539:	e8 e4 de ff ff       	call   800422 <_panic>
  80253e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802544:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802547:	89 10                	mov    %edx,(%eax)
  802549:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0d                	je     80255f <alloc_block_FF+0x16e>
  802552:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802557:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80255a:	89 50 04             	mov    %edx,0x4(%eax)
  80255d:	eb 08                	jmp    802567 <alloc_block_FF+0x176>
  80255f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802562:	a3 30 50 80 00       	mov    %eax,0x805030
  802567:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80256f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802579:	a1 38 50 80 00       	mov    0x805038,%eax
  80257e:	40                   	inc    %eax
  80257f:	a3 38 50 80 00       	mov    %eax,0x805038
  802584:	e9 dc 00 00 00       	jmp    802665 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	75 65                	jne    8025f7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802592:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802596:	75 17                	jne    8025af <alloc_block_FF+0x1be>
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 90 46 80 00       	push   $0x804690
  8025a0:	68 db 00 00 00       	push   $0xdb
  8025a5:	68 41 46 80 00       	push   $0x804641
  8025aa:	e8 73 de ff ff       	call   800422 <_panic>
  8025af:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b8:	89 50 04             	mov    %edx,0x4(%eax)
  8025bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025be:	8b 40 04             	mov    0x4(%eax),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	74 0c                	je     8025d1 <alloc_block_FF+0x1e0>
  8025c5:	a1 30 50 80 00       	mov    0x805030,%eax
  8025ca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025cd:	89 10                	mov    %edx,(%eax)
  8025cf:	eb 08                	jmp    8025d9 <alloc_block_FF+0x1e8>
  8025d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8025ef:	40                   	inc    %eax
  8025f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8025f5:	eb 6e                	jmp    802665 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fb:	74 06                	je     802603 <alloc_block_FF+0x212>
  8025fd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802601:	75 17                	jne    80261a <alloc_block_FF+0x229>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 b4 46 80 00       	push   $0x8046b4
  80260b:	68 df 00 00 00       	push   $0xdf
  802610:	68 41 46 80 00       	push   $0x804641
  802615:	e8 08 de ff ff       	call   800422 <_panic>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 10                	mov    (%eax),%edx
  80261f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802622:	89 10                	mov    %edx,(%eax)
  802624:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 0b                	je     802638 <alloc_block_FF+0x247>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802635:	89 50 04             	mov    %edx,0x4(%eax)
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80263e:	89 10                	mov    %edx,(%eax)
  802640:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802646:	89 50 04             	mov    %edx,0x4(%eax)
  802649:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 08                	jne    80265a <alloc_block_FF+0x269>
  802652:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802655:	a3 30 50 80 00       	mov    %eax,0x805030
  80265a:	a1 38 50 80 00       	mov    0x805038,%eax
  80265f:	40                   	inc    %eax
  802660:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802669:	75 17                	jne    802682 <alloc_block_FF+0x291>
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 23 46 80 00       	push   $0x804623
  802673:	68 e1 00 00 00       	push   $0xe1
  802678:	68 41 46 80 00       	push   $0x804641
  80267d:	e8 a0 dd ff ff       	call   800422 <_panic>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	74 10                	je     80269b <alloc_block_FF+0x2aa>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802693:	8b 52 04             	mov    0x4(%edx),%edx
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	eb 0b                	jmp    8026a6 <alloc_block_FF+0x2b5>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 04             	mov    0x4(%eax),%eax
  8026a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0f                	je     8026bf <alloc_block_FF+0x2ce>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b9:	8b 12                	mov    (%edx),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	eb 0a                	jmp    8026c9 <alloc_block_FF+0x2d8>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e1:	48                   	dec    %eax
  8026e2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	6a 00                	push   $0x0
  8026ec:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026ef:	ff 75 b0             	pushl  -0x50(%ebp)
  8026f2:	e8 cb fc ff ff       	call   8023c2 <set_block_data>
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	e9 95 00 00 00       	jmp    802794 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	6a 01                	push   $0x1
  802704:	ff 75 b8             	pushl  -0x48(%ebp)
  802707:	ff 75 bc             	pushl  -0x44(%ebp)
  80270a:	e8 b3 fc ff ff       	call   8023c2 <set_block_data>
  80270f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	75 17                	jne    80272f <alloc_block_FF+0x33e>
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	68 23 46 80 00       	push   $0x804623
  802720:	68 e8 00 00 00       	push   $0xe8
  802725:	68 41 46 80 00       	push   $0x804641
  80272a:	e8 f3 dc ff ff       	call   800422 <_panic>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	74 10                	je     802748 <alloc_block_FF+0x357>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802740:	8b 52 04             	mov    0x4(%edx),%edx
  802743:	89 50 04             	mov    %edx,0x4(%eax)
  802746:	eb 0b                	jmp    802753 <alloc_block_FF+0x362>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	a3 30 50 80 00       	mov    %eax,0x805030
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 0f                	je     80276c <alloc_block_FF+0x37b>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802766:	8b 12                	mov    (%edx),%edx
  802768:	89 10                	mov    %edx,(%eax)
  80276a:	eb 0a                	jmp    802776 <alloc_block_FF+0x385>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802789:	a1 38 50 80 00       	mov    0x805038,%eax
  80278e:	48                   	dec    %eax
  80278f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802794:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802797:	e9 0f 01 00 00       	jmp    8028ab <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80279c:	a1 34 50 80 00       	mov    0x805034,%eax
  8027a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a8:	74 07                	je     8027b1 <alloc_block_FF+0x3c0>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	eb 05                	jmp    8027b6 <alloc_block_FF+0x3c5>
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8027bb:	a1 34 50 80 00       	mov    0x805034,%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	0f 85 e9 fc ff ff    	jne    8024b1 <alloc_block_FF+0xc0>
  8027c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cc:	0f 85 df fc ff ff    	jne    8024b1 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	83 c0 08             	add    $0x8,%eax
  8027d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027db:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f6:	f7 75 d8             	divl   -0x28(%ebp)
  8027f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fc:	29 d0                	sub    %edx,%eax
  8027fe:	c1 e8 0c             	shr    $0xc,%eax
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	50                   	push   %eax
  802805:	e8 6f ec ff ff       	call   801479 <sbrk>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802810:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802814:	75 0a                	jne    802820 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802816:	b8 00 00 00 00       	mov    $0x0,%eax
  80281b:	e9 8b 00 00 00       	jmp    8028ab <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802820:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802827:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80282a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80282d:	01 d0                	add    %edx,%eax
  80282f:	48                   	dec    %eax
  802830:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802833:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802836:	ba 00 00 00 00       	mov    $0x0,%edx
  80283b:	f7 75 cc             	divl   -0x34(%ebp)
  80283e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802841:	29 d0                	sub    %edx,%eax
  802843:	8d 50 fc             	lea    -0x4(%eax),%edx
  802846:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802849:	01 d0                	add    %edx,%eax
  80284b:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802850:	a1 40 50 80 00       	mov    0x805040,%eax
  802855:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80285b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802862:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802865:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802868:	01 d0                	add    %edx,%eax
  80286a:	48                   	dec    %eax
  80286b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80286e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802871:	ba 00 00 00 00       	mov    $0x0,%edx
  802876:	f7 75 c4             	divl   -0x3c(%ebp)
  802879:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80287c:	29 d0                	sub    %edx,%eax
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	6a 01                	push   $0x1
  802883:	50                   	push   %eax
  802884:	ff 75 d0             	pushl  -0x30(%ebp)
  802887:	e8 36 fb ff ff       	call   8023c2 <set_block_data>
  80288c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80288f:	83 ec 0c             	sub    $0xc,%esp
  802892:	ff 75 d0             	pushl  -0x30(%ebp)
  802895:	e8 f8 09 00 00       	call   803292 <free_block>
  80289a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80289d:	83 ec 0c             	sub    $0xc,%esp
  8028a0:	ff 75 08             	pushl  0x8(%ebp)
  8028a3:	e8 49 fb ff ff       	call   8023f1 <alloc_block_FF>
  8028a8:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    

008028ad <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
  8028b0:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	83 e0 01             	and    $0x1,%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 03                	je     8028c0 <alloc_block_BF+0x13>
  8028bd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028c0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028c4:	77 07                	ja     8028cd <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028c6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	75 73                	jne    802949 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	83 c0 10             	add    $0x10,%eax
  8028dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028df:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	48                   	dec    %eax
  8028ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fa:	f7 75 e0             	divl   -0x20(%ebp)
  8028fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802900:	29 d0                	sub    %edx,%eax
  802902:	c1 e8 0c             	shr    $0xc,%eax
  802905:	83 ec 0c             	sub    $0xc,%esp
  802908:	50                   	push   %eax
  802909:	e8 6b eb ff ff       	call   801479 <sbrk>
  80290e:	83 c4 10             	add    $0x10,%esp
  802911:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802914:	83 ec 0c             	sub    $0xc,%esp
  802917:	6a 00                	push   $0x0
  802919:	e8 5b eb ff ff       	call   801479 <sbrk>
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802927:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80292a:	83 ec 08             	sub    $0x8,%esp
  80292d:	50                   	push   %eax
  80292e:	ff 75 d8             	pushl  -0x28(%ebp)
  802931:	e8 9f f8 ff ff       	call   8021d5 <initialize_dynamic_allocator>
  802936:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802939:	83 ec 0c             	sub    $0xc,%esp
  80293c:	68 7f 46 80 00       	push   $0x80467f
  802941:	e8 99 dd ff ff       	call   8006df <cprintf>
  802946:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802950:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802957:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80295e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802965:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80296a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296d:	e9 1d 01 00 00       	jmp    802a8f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802978:	83 ec 0c             	sub    $0xc,%esp
  80297b:	ff 75 a8             	pushl  -0x58(%ebp)
  80297e:	e8 ee f6 ff ff       	call   802071 <get_block_size>
  802983:	83 c4 10             	add    $0x10,%esp
  802986:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	83 c0 08             	add    $0x8,%eax
  80298f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802992:	0f 87 ef 00 00 00    	ja     802a87 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	83 c0 18             	add    $0x18,%eax
  80299e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a1:	77 1d                	ja     8029c0 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a9:	0f 86 d8 00 00 00    	jbe    802a87 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029af:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029b5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029bb:	e9 c7 00 00 00       	jmp    802a87 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	83 c0 08             	add    $0x8,%eax
  8029c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c9:	0f 85 9d 00 00 00    	jne    802a6c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	6a 01                	push   $0x1
  8029d4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029d7:	ff 75 a8             	pushl  -0x58(%ebp)
  8029da:	e8 e3 f9 ff ff       	call   8023c2 <set_block_data>
  8029df:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e6:	75 17                	jne    8029ff <alloc_block_BF+0x152>
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	68 23 46 80 00       	push   $0x804623
  8029f0:	68 2c 01 00 00       	push   $0x12c
  8029f5:	68 41 46 80 00       	push   $0x804641
  8029fa:	e8 23 da ff ff       	call   800422 <_panic>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 10                	je     802a18 <alloc_block_BF+0x16b>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a10:	8b 52 04             	mov    0x4(%edx),%edx
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
  802a16:	eb 0b                	jmp    802a23 <alloc_block_BF+0x176>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 0f                	je     802a3c <alloc_block_BF+0x18f>
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a36:	8b 12                	mov    (%edx),%edx
  802a38:	89 10                	mov    %edx,(%eax)
  802a3a:	eb 0a                	jmp    802a46 <alloc_block_BF+0x199>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a59:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a64:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a67:	e9 01 04 00 00       	jmp    802e6d <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a72:	76 13                	jbe    802a87 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a74:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a7b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a81:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a84:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a87:	a1 34 50 80 00       	mov    0x805034,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	74 07                	je     802a9c <alloc_block_BF+0x1ef>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	eb 05                	jmp    802aa1 <alloc_block_BF+0x1f4>
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa1:	a3 34 50 80 00       	mov    %eax,0x805034
  802aa6:	a1 34 50 80 00       	mov    0x805034,%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	0f 85 bf fe ff ff    	jne    802972 <alloc_block_BF+0xc5>
  802ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab7:	0f 85 b5 fe ff ff    	jne    802972 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac1:	0f 84 26 02 00 00    	je     802ced <alloc_block_BF+0x440>
  802ac7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802acb:	0f 85 1c 02 00 00    	jne    802ced <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad7:	83 e8 08             	sub    $0x8,%eax
  802ada:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8d 50 08             	lea    0x8(%eax),%edx
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	01 d0                	add    %edx,%eax
  802ae8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	83 c0 08             	add    $0x8,%eax
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	6a 01                	push   $0x1
  802af6:	50                   	push   %eax
  802af7:	ff 75 f0             	pushl  -0x10(%ebp)
  802afa:	e8 c3 f8 ff ff       	call   8023c2 <set_block_data>
  802aff:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	75 68                	jne    802b74 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b10:	75 17                	jne    802b29 <alloc_block_BF+0x27c>
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	68 5c 46 80 00       	push   $0x80465c
  802b1a:	68 45 01 00 00       	push   $0x145
  802b1f:	68 41 46 80 00       	push   $0x804641
  802b24:	e8 f9 d8 ff ff       	call   800422 <_panic>
  802b29:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b32:	89 10                	mov    %edx,(%eax)
  802b34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 0d                	je     802b4a <alloc_block_BF+0x29d>
  802b3d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b42:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
  802b48:	eb 08                	jmp    802b52 <alloc_block_BF+0x2a5>
  802b4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 38 50 80 00       	mov    0x805038,%eax
  802b69:	40                   	inc    %eax
  802b6a:	a3 38 50 80 00       	mov    %eax,0x805038
  802b6f:	e9 dc 00 00 00       	jmp    802c50 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 65                	jne    802be2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b7d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b81:	75 17                	jne    802b9a <alloc_block_BF+0x2ed>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 90 46 80 00       	push   $0x804690
  802b8b:	68 4a 01 00 00       	push   $0x14a
  802b90:	68 41 46 80 00       	push   $0x804641
  802b95:	e8 88 d8 ff ff       	call   800422 <_panic>
  802b9a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ba0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0c                	je     802bbc <alloc_block_BF+0x30f>
  802bb0:	a1 30 50 80 00       	mov    0x805030,%eax
  802bb5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	eb 08                	jmp    802bc4 <alloc_block_BF+0x317>
  802bbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bda:	40                   	inc    %eax
  802bdb:	a3 38 50 80 00       	mov    %eax,0x805038
  802be0:	eb 6e                	jmp    802c50 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802be2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be6:	74 06                	je     802bee <alloc_block_BF+0x341>
  802be8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bec:	75 17                	jne    802c05 <alloc_block_BF+0x358>
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	68 b4 46 80 00       	push   $0x8046b4
  802bf6:	68 4f 01 00 00       	push   $0x14f
  802bfb:	68 41 46 80 00       	push   $0x804641
  802c00:	e8 1d d8 ff ff       	call   800422 <_panic>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 10                	mov    (%eax),%edx
  802c0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 0b                	je     802c23 <alloc_block_BF+0x376>
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c20:	89 50 04             	mov    %edx,0x4(%eax)
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	75 08                	jne    802c45 <alloc_block_BF+0x398>
  802c3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c40:	a3 30 50 80 00       	mov    %eax,0x805030
  802c45:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4a:	40                   	inc    %eax
  802c4b:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c54:	75 17                	jne    802c6d <alloc_block_BF+0x3c0>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 23 46 80 00       	push   $0x804623
  802c5e:	68 51 01 00 00       	push   $0x151
  802c63:	68 41 46 80 00       	push   $0x804641
  802c68:	e8 b5 d7 ff ff       	call   800422 <_panic>
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 10                	je     802c86 <alloc_block_BF+0x3d9>
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7e:	8b 52 04             	mov    0x4(%edx),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 0b                	jmp    802c91 <alloc_block_BF+0x3e4>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0f                	je     802caa <alloc_block_BF+0x3fd>
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca4:	8b 12                	mov    (%edx),%edx
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	eb 0a                	jmp    802cb4 <alloc_block_BF+0x407>
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccc:	48                   	dec    %eax
  802ccd:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	6a 00                	push   $0x0
  802cd7:	ff 75 d0             	pushl  -0x30(%ebp)
  802cda:	ff 75 cc             	pushl  -0x34(%ebp)
  802cdd:	e8 e0 f6 ff ff       	call   8023c2 <set_block_data>
  802ce2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	e9 80 01 00 00       	jmp    802e6d <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802ced:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cf1:	0f 85 9d 00 00 00    	jne    802d94 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cf7:	83 ec 04             	sub    $0x4,%esp
  802cfa:	6a 01                	push   $0x1
  802cfc:	ff 75 ec             	pushl  -0x14(%ebp)
  802cff:	ff 75 f0             	pushl  -0x10(%ebp)
  802d02:	e8 bb f6 ff ff       	call   8023c2 <set_block_data>
  802d07:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0e:	75 17                	jne    802d27 <alloc_block_BF+0x47a>
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	68 23 46 80 00       	push   $0x804623
  802d18:	68 58 01 00 00       	push   $0x158
  802d1d:	68 41 46 80 00       	push   $0x804641
  802d22:	e8 fb d6 ff ff       	call   800422 <_panic>
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	74 10                	je     802d40 <alloc_block_BF+0x493>
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d38:	8b 52 04             	mov    0x4(%edx),%edx
  802d3b:	89 50 04             	mov    %edx,0x4(%eax)
  802d3e:	eb 0b                	jmp    802d4b <alloc_block_BF+0x49e>
  802d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d43:	8b 40 04             	mov    0x4(%eax),%eax
  802d46:	a3 30 50 80 00       	mov    %eax,0x805030
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 0f                	je     802d64 <alloc_block_BF+0x4b7>
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5e:	8b 12                	mov    (%edx),%edx
  802d60:	89 10                	mov    %edx,(%eax)
  802d62:	eb 0a                	jmp    802d6e <alloc_block_BF+0x4c1>
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d81:	a1 38 50 80 00       	mov    0x805038,%eax
  802d86:	48                   	dec    %eax
  802d87:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	e9 d9 00 00 00       	jmp    802e6d <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	83 c0 08             	add    $0x8,%eax
  802d9a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d9d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802da4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802da7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802daa:	01 d0                	add    %edx,%eax
  802dac:	48                   	dec    %eax
  802dad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802db0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802db3:	ba 00 00 00 00       	mov    $0x0,%edx
  802db8:	f7 75 c4             	divl   -0x3c(%ebp)
  802dbb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dbe:	29 d0                	sub    %edx,%eax
  802dc0:	c1 e8 0c             	shr    $0xc,%eax
  802dc3:	83 ec 0c             	sub    $0xc,%esp
  802dc6:	50                   	push   %eax
  802dc7:	e8 ad e6 ff ff       	call   801479 <sbrk>
  802dcc:	83 c4 10             	add    $0x10,%esp
  802dcf:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802dd2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802dd6:	75 0a                	jne    802de2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddd:	e9 8b 00 00 00       	jmp    802e6d <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802de2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802de9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802def:	01 d0                	add    %edx,%eax
  802df1:	48                   	dec    %eax
  802df2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802df5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802df8:	ba 00 00 00 00       	mov    $0x0,%edx
  802dfd:	f7 75 b8             	divl   -0x48(%ebp)
  802e00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e03:	29 d0                	sub    %edx,%eax
  802e05:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e0b:	01 d0                	add    %edx,%eax
  802e0d:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e12:	a1 40 50 80 00       	mov    0x805040,%eax
  802e17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e1d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e24:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e2a:	01 d0                	add    %edx,%eax
  802e2c:	48                   	dec    %eax
  802e2d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e30:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e33:	ba 00 00 00 00       	mov    $0x0,%edx
  802e38:	f7 75 b0             	divl   -0x50(%ebp)
  802e3b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e3e:	29 d0                	sub    %edx,%eax
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	6a 01                	push   $0x1
  802e45:	50                   	push   %eax
  802e46:	ff 75 bc             	pushl  -0x44(%ebp)
  802e49:	e8 74 f5 ff ff       	call   8023c2 <set_block_data>
  802e4e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e51:	83 ec 0c             	sub    $0xc,%esp
  802e54:	ff 75 bc             	pushl  -0x44(%ebp)
  802e57:	e8 36 04 00 00       	call   803292 <free_block>
  802e5c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e5f:	83 ec 0c             	sub    $0xc,%esp
  802e62:	ff 75 08             	pushl  0x8(%ebp)
  802e65:	e8 43 fa ff ff       	call   8028ad <alloc_block_BF>
  802e6a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	53                   	push   %ebx
  802e73:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e88:	74 1e                	je     802ea8 <merging+0x39>
  802e8a:	ff 75 08             	pushl  0x8(%ebp)
  802e8d:	e8 df f1 ff ff       	call   802071 <get_block_size>
  802e92:	83 c4 04             	add    $0x4,%esp
  802e95:	89 c2                	mov    %eax,%edx
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	01 d0                	add    %edx,%eax
  802e9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e9f:	75 07                	jne    802ea8 <merging+0x39>
		prev_is_free = 1;
  802ea1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eac:	74 1e                	je     802ecc <merging+0x5d>
  802eae:	ff 75 10             	pushl  0x10(%ebp)
  802eb1:	e8 bb f1 ff ff       	call   802071 <get_block_size>
  802eb6:	83 c4 04             	add    $0x4,%esp
  802eb9:	89 c2                	mov    %eax,%edx
  802ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  802ebe:	01 d0                	add    %edx,%eax
  802ec0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ec3:	75 07                	jne    802ecc <merging+0x5d>
		next_is_free = 1;
  802ec5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed0:	0f 84 cc 00 00 00    	je     802fa2 <merging+0x133>
  802ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eda:	0f 84 c2 00 00 00    	je     802fa2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ee0:	ff 75 08             	pushl  0x8(%ebp)
  802ee3:	e8 89 f1 ff ff       	call   802071 <get_block_size>
  802ee8:	83 c4 04             	add    $0x4,%esp
  802eeb:	89 c3                	mov    %eax,%ebx
  802eed:	ff 75 10             	pushl  0x10(%ebp)
  802ef0:	e8 7c f1 ff ff       	call   802071 <get_block_size>
  802ef5:	83 c4 04             	add    $0x4,%esp
  802ef8:	01 c3                	add    %eax,%ebx
  802efa:	ff 75 0c             	pushl  0xc(%ebp)
  802efd:	e8 6f f1 ff ff       	call   802071 <get_block_size>
  802f02:	83 c4 04             	add    $0x4,%esp
  802f05:	01 d8                	add    %ebx,%eax
  802f07:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f0a:	6a 00                	push   $0x0
  802f0c:	ff 75 ec             	pushl  -0x14(%ebp)
  802f0f:	ff 75 08             	pushl  0x8(%ebp)
  802f12:	e8 ab f4 ff ff       	call   8023c2 <set_block_data>
  802f17:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f1e:	75 17                	jne    802f37 <merging+0xc8>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 23 46 80 00       	push   $0x804623
  802f28:	68 7d 01 00 00       	push   $0x17d
  802f2d:	68 41 46 80 00       	push   $0x804641
  802f32:	e8 eb d4 ff ff       	call   800422 <_panic>
  802f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 10                	je     802f50 <merging+0xe1>
  802f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f48:	8b 52 04             	mov    0x4(%edx),%edx
  802f4b:	89 50 04             	mov    %edx,0x4(%eax)
  802f4e:	eb 0b                	jmp    802f5b <merging+0xec>
  802f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	a3 30 50 80 00       	mov    %eax,0x805030
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0f                	je     802f74 <merging+0x105>
  802f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6e:	8b 12                	mov    (%edx),%edx
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	eb 0a                	jmp    802f7e <merging+0x10f>
  802f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 38 50 80 00       	mov    0x805038,%eax
  802f96:	48                   	dec    %eax
  802f97:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f9c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f9d:	e9 ea 02 00 00       	jmp    80328c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	74 3b                	je     802fe3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fa8:	83 ec 0c             	sub    $0xc,%esp
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	e8 be f0 ff ff       	call   802071 <get_block_size>
  802fb3:	83 c4 10             	add    $0x10,%esp
  802fb6:	89 c3                	mov    %eax,%ebx
  802fb8:	83 ec 0c             	sub    $0xc,%esp
  802fbb:	ff 75 10             	pushl  0x10(%ebp)
  802fbe:	e8 ae f0 ff ff       	call   802071 <get_block_size>
  802fc3:	83 c4 10             	add    $0x10,%esp
  802fc6:	01 d8                	add    %ebx,%eax
  802fc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	6a 00                	push   $0x0
  802fd0:	ff 75 e8             	pushl  -0x18(%ebp)
  802fd3:	ff 75 08             	pushl  0x8(%ebp)
  802fd6:	e8 e7 f3 ff ff       	call   8023c2 <set_block_data>
  802fdb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fde:	e9 a9 02 00 00       	jmp    80328c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fe3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe7:	0f 84 2d 01 00 00    	je     80311a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fed:	83 ec 0c             	sub    $0xc,%esp
  802ff0:	ff 75 10             	pushl  0x10(%ebp)
  802ff3:	e8 79 f0 ff ff       	call   802071 <get_block_size>
  802ff8:	83 c4 10             	add    $0x10,%esp
  802ffb:	89 c3                	mov    %eax,%ebx
  802ffd:	83 ec 0c             	sub    $0xc,%esp
  803000:	ff 75 0c             	pushl  0xc(%ebp)
  803003:	e8 69 f0 ff ff       	call   802071 <get_block_size>
  803008:	83 c4 10             	add    $0x10,%esp
  80300b:	01 d8                	add    %ebx,%eax
  80300d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	6a 00                	push   $0x0
  803015:	ff 75 e4             	pushl  -0x1c(%ebp)
  803018:	ff 75 10             	pushl  0x10(%ebp)
  80301b:	e8 a2 f3 ff ff       	call   8023c2 <set_block_data>
  803020:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803023:	8b 45 10             	mov    0x10(%ebp),%eax
  803026:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803029:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80302d:	74 06                	je     803035 <merging+0x1c6>
  80302f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803033:	75 17                	jne    80304c <merging+0x1dd>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 e8 46 80 00       	push   $0x8046e8
  80303d:	68 8d 01 00 00       	push   $0x18d
  803042:	68 41 46 80 00       	push   $0x804641
  803047:	e8 d6 d3 ff ff       	call   800422 <_panic>
  80304c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304f:	8b 50 04             	mov    0x4(%eax),%edx
  803052:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 0c             	mov    0xc(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0d                	je     803077 <merging+0x208>
  80306a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	eb 08                	jmp    80307f <merging+0x210>
  803077:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803082:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	a1 38 50 80 00       	mov    0x805038,%eax
  80308d:	40                   	inc    %eax
  80308e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803093:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803097:	75 17                	jne    8030b0 <merging+0x241>
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	68 23 46 80 00       	push   $0x804623
  8030a1:	68 8e 01 00 00       	push   $0x18e
  8030a6:	68 41 46 80 00       	push   $0x804641
  8030ab:	e8 72 d3 ff ff       	call   800422 <_panic>
  8030b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	74 10                	je     8030c9 <merging+0x25a>
  8030b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c1:	8b 52 04             	mov    0x4(%edx),%edx
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	eb 0b                	jmp    8030d4 <merging+0x265>
  8030c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 0f                	je     8030ed <merging+0x27e>
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e7:	8b 12                	mov    (%edx),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	eb 0a                	jmp    8030f7 <merging+0x288>
  8030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803100:	8b 45 0c             	mov    0xc(%ebp),%eax
  803103:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310a:	a1 38 50 80 00       	mov    0x805038,%eax
  80310f:	48                   	dec    %eax
  803110:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803115:	e9 72 01 00 00       	jmp    80328c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80311a:	8b 45 10             	mov    0x10(%ebp),%eax
  80311d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803124:	74 79                	je     80319f <merging+0x330>
  803126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80312a:	74 73                	je     80319f <merging+0x330>
  80312c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803130:	74 06                	je     803138 <merging+0x2c9>
  803132:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803136:	75 17                	jne    80314f <merging+0x2e0>
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	68 b4 46 80 00       	push   $0x8046b4
  803140:	68 94 01 00 00       	push   $0x194
  803145:	68 41 46 80 00       	push   $0x804641
  80314a:	e8 d3 d2 ff ff       	call   800422 <_panic>
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 10                	mov    (%eax),%edx
  803154:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803157:	89 10                	mov    %edx,(%eax)
  803159:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 0b                	je     80316d <merging+0x2fe>
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803173:	89 10                	mov    %edx,(%eax)
  803175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803178:	8b 55 08             	mov    0x8(%ebp),%edx
  80317b:	89 50 04             	mov    %edx,0x4(%eax)
  80317e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	75 08                	jne    80318f <merging+0x320>
  803187:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318a:	a3 30 50 80 00       	mov    %eax,0x805030
  80318f:	a1 38 50 80 00       	mov    0x805038,%eax
  803194:	40                   	inc    %eax
  803195:	a3 38 50 80 00       	mov    %eax,0x805038
  80319a:	e9 ce 00 00 00       	jmp    80326d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80319f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a3:	74 65                	je     80320a <merging+0x39b>
  8031a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031a9:	75 17                	jne    8031c2 <merging+0x353>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 90 46 80 00       	push   $0x804690
  8031b3:	68 95 01 00 00       	push   $0x195
  8031b8:	68 41 46 80 00       	push   $0x804641
  8031bd:	e8 60 d2 ff ff       	call   800422 <_panic>
  8031c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 0c                	je     8031e4 <merging+0x375>
  8031d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8031dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e0:	89 10                	mov    %edx,(%eax)
  8031e2:	eb 08                	jmp    8031ec <merging+0x37d>
  8031e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803202:	40                   	inc    %eax
  803203:	a3 38 50 80 00       	mov    %eax,0x805038
  803208:	eb 63                	jmp    80326d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80320a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80320e:	75 17                	jne    803227 <merging+0x3b8>
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	68 5c 46 80 00       	push   $0x80465c
  803218:	68 98 01 00 00       	push   $0x198
  80321d:	68 41 46 80 00       	push   $0x804641
  803222:	e8 fb d1 ff ff       	call   800422 <_panic>
  803227:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0d                	je     803248 <merging+0x3d9>
  80323b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803240:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	eb 08                	jmp    803250 <merging+0x3e1>
  803248:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324b:	a3 30 50 80 00       	mov    %eax,0x805030
  803250:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803253:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803258:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 38 50 80 00       	mov    0x805038,%eax
  803267:	40                   	inc    %eax
  803268:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80326d:	83 ec 0c             	sub    $0xc,%esp
  803270:	ff 75 10             	pushl  0x10(%ebp)
  803273:	e8 f9 ed ff ff       	call   802071 <get_block_size>
  803278:	83 c4 10             	add    $0x10,%esp
  80327b:	83 ec 04             	sub    $0x4,%esp
  80327e:	6a 00                	push   $0x0
  803280:	50                   	push   %eax
  803281:	ff 75 10             	pushl  0x10(%ebp)
  803284:	e8 39 f1 ff ff       	call   8023c2 <set_block_data>
  803289:	83 c4 10             	add    $0x10,%esp
	}
}
  80328c:	90                   	nop
  80328d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803290:	c9                   	leave  
  803291:	c3                   	ret    

00803292 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803292:	55                   	push   %ebp
  803293:	89 e5                	mov    %esp,%ebp
  803295:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803298:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80329d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8032a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a8:	73 1b                	jae    8032c5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	ff 75 08             	pushl  0x8(%ebp)
  8032b5:	6a 00                	push   $0x0
  8032b7:	50                   	push   %eax
  8032b8:	e8 b2 fb ff ff       	call   802e6f <merging>
  8032bd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032c0:	e9 8b 00 00 00       	jmp    803350 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032cd:	76 18                	jbe    8032e7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	ff 75 08             	pushl  0x8(%ebp)
  8032da:	50                   	push   %eax
  8032db:	6a 00                	push   $0x0
  8032dd:	e8 8d fb ff ff       	call   802e6f <merging>
  8032e2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032e5:	eb 69                	jmp    803350 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ef:	eb 39                	jmp    80332a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032f7:	73 29                	jae    803322 <free_block+0x90>
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803301:	76 1f                	jbe    803322 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	ff 75 08             	pushl  0x8(%ebp)
  803311:	ff 75 f0             	pushl  -0x10(%ebp)
  803314:	ff 75 f4             	pushl  -0xc(%ebp)
  803317:	e8 53 fb ff ff       	call   802e6f <merging>
  80331c:	83 c4 10             	add    $0x10,%esp
			break;
  80331f:	90                   	nop
		}
	}
}
  803320:	eb 2e                	jmp    803350 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803322:	a1 34 50 80 00       	mov    0x805034,%eax
  803327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332e:	74 07                	je     803337 <free_block+0xa5>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	eb 05                	jmp    80333c <free_block+0xaa>
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
  80333c:	a3 34 50 80 00       	mov    %eax,0x805034
  803341:	a1 34 50 80 00       	mov    0x805034,%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	75 a7                	jne    8032f1 <free_block+0x5f>
  80334a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334e:	75 a1                	jne    8032f1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803350:	90                   	nop
  803351:	c9                   	leave  
  803352:	c3                   	ret    

00803353 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803353:	55                   	push   %ebp
  803354:	89 e5                	mov    %esp,%ebp
  803356:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803359:	ff 75 08             	pushl  0x8(%ebp)
  80335c:	e8 10 ed ff ff       	call   802071 <get_block_size>
  803361:	83 c4 04             	add    $0x4,%esp
  803364:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80336e:	eb 17                	jmp    803387 <copy_data+0x34>
  803370:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803373:	8b 45 0c             	mov    0xc(%ebp),%eax
  803376:	01 c2                	add    %eax,%edx
  803378:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	01 c8                	add    %ecx,%eax
  803380:	8a 00                	mov    (%eax),%al
  803382:	88 02                	mov    %al,(%edx)
  803384:	ff 45 fc             	incl   -0x4(%ebp)
  803387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80338a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80338d:	72 e1                	jb     803370 <copy_data+0x1d>
}
  80338f:	90                   	nop
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
  803395:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	75 23                	jne    8033c1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80339e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a2:	74 13                	je     8033b7 <realloc_block_FF+0x25>
  8033a4:	83 ec 0c             	sub    $0xc,%esp
  8033a7:	ff 75 0c             	pushl  0xc(%ebp)
  8033aa:	e8 42 f0 ff ff       	call   8023f1 <alloc_block_FF>
  8033af:	83 c4 10             	add    $0x10,%esp
  8033b2:	e9 e4 06 00 00       	jmp    803a9b <realloc_block_FF+0x709>
		return NULL;
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bc:	e9 da 06 00 00       	jmp    803a9b <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8033c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c5:	75 18                	jne    8033df <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	ff 75 08             	pushl  0x8(%ebp)
  8033cd:	e8 c0 fe ff ff       	call   803292 <free_block>
  8033d2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	e9 bc 06 00 00       	jmp    803a9b <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033df:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033e3:	77 07                	ja     8033ec <realloc_block_FF+0x5a>
  8033e5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ef:	83 e0 01             	and    $0x1,%eax
  8033f2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f8:	83 c0 08             	add    $0x8,%eax
  8033fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033fe:	83 ec 0c             	sub    $0xc,%esp
  803401:	ff 75 08             	pushl  0x8(%ebp)
  803404:	e8 68 ec ff ff       	call   802071 <get_block_size>
  803409:	83 c4 10             	add    $0x10,%esp
  80340c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80340f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803412:	83 e8 08             	sub    $0x8,%eax
  803415:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	83 e8 04             	sub    $0x4,%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	83 e0 fe             	and    $0xfffffffe,%eax
  803423:	89 c2                	mov    %eax,%edx
  803425:	8b 45 08             	mov    0x8(%ebp),%eax
  803428:	01 d0                	add    %edx,%eax
  80342a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80342d:	83 ec 0c             	sub    $0xc,%esp
  803430:	ff 75 e4             	pushl  -0x1c(%ebp)
  803433:	e8 39 ec ff ff       	call   802071 <get_block_size>
  803438:	83 c4 10             	add    $0x10,%esp
  80343b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80343e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803441:	83 e8 08             	sub    $0x8,%eax
  803444:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80344d:	75 08                	jne    803457 <realloc_block_FF+0xc5>
	{
		 return va;
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	e9 44 06 00 00       	jmp    803a9b <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80345d:	0f 83 d5 03 00 00    	jae    803838 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	2b 45 0c             	sub    0xc(%ebp),%eax
  803469:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80346c:	83 ec 0c             	sub    $0xc,%esp
  80346f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803472:	e8 13 ec ff ff       	call   80208a <is_free_block>
  803477:	83 c4 10             	add    $0x10,%esp
  80347a:	84 c0                	test   %al,%al
  80347c:	0f 84 3b 01 00 00    	je     8035bd <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803488:	01 d0                	add    %edx,%eax
  80348a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	6a 01                	push   $0x1
  803492:	ff 75 f0             	pushl  -0x10(%ebp)
  803495:	ff 75 08             	pushl  0x8(%ebp)
  803498:	e8 25 ef ff ff       	call   8023c2 <set_block_data>
  80349d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	83 e8 04             	sub    $0x4,%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8034ab:	89 c2                	mov    %eax,%edx
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	01 d0                	add    %edx,%eax
  8034b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	6a 00                	push   $0x0
  8034ba:	ff 75 cc             	pushl  -0x34(%ebp)
  8034bd:	ff 75 c8             	pushl  -0x38(%ebp)
  8034c0:	e8 fd ee ff ff       	call   8023c2 <set_block_data>
  8034c5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034cc:	74 06                	je     8034d4 <realloc_block_FF+0x142>
  8034ce:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034d2:	75 17                	jne    8034eb <realloc_block_FF+0x159>
  8034d4:	83 ec 04             	sub    $0x4,%esp
  8034d7:	68 b4 46 80 00       	push   $0x8046b4
  8034dc:	68 f6 01 00 00       	push   $0x1f6
  8034e1:	68 41 46 80 00       	push   $0x804641
  8034e6:	e8 37 cf ff ff       	call   800422 <_panic>
  8034eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ee:	8b 10                	mov    (%eax),%edx
  8034f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	74 0b                	je     803509 <realloc_block_FF+0x177>
  8034fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80350f:	89 10                	mov    %edx,(%eax)
  803511:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803514:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803517:	89 50 04             	mov    %edx,0x4(%eax)
  80351a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80351d:	8b 00                	mov    (%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	75 08                	jne    80352b <realloc_block_FF+0x199>
  803523:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803526:	a3 30 50 80 00       	mov    %eax,0x805030
  80352b:	a1 38 50 80 00       	mov    0x805038,%eax
  803530:	40                   	inc    %eax
  803531:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80353a:	75 17                	jne    803553 <realloc_block_FF+0x1c1>
  80353c:	83 ec 04             	sub    $0x4,%esp
  80353f:	68 23 46 80 00       	push   $0x804623
  803544:	68 f7 01 00 00       	push   $0x1f7
  803549:	68 41 46 80 00       	push   $0x804641
  80354e:	e8 cf ce ff ff       	call   800422 <_panic>
  803553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 10                	je     80356c <realloc_block_FF+0x1da>
  80355c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355f:	8b 00                	mov    (%eax),%eax
  803561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803564:	8b 52 04             	mov    0x4(%edx),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 0b                	jmp    803577 <realloc_block_FF+0x1e5>
  80356c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	a3 30 50 80 00       	mov    %eax,0x805030
  803577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 0f                	je     803590 <realloc_block_FF+0x1fe>
  803581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803584:	8b 40 04             	mov    0x4(%eax),%eax
  803587:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80358a:	8b 12                	mov    (%edx),%edx
  80358c:	89 10                	mov    %edx,(%eax)
  80358e:	eb 0a                	jmp    80359a <realloc_block_FF+0x208>
  803590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b2:	48                   	dec    %eax
  8035b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8035b8:	e9 73 02 00 00       	jmp    803830 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8035bd:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035c1:	0f 86 69 02 00 00    	jbe    803830 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035c7:	83 ec 04             	sub    $0x4,%esp
  8035ca:	6a 01                	push   $0x1
  8035cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8035cf:	ff 75 08             	pushl  0x8(%ebp)
  8035d2:	e8 eb ed ff ff       	call   8023c2 <set_block_data>
  8035d7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	83 e8 04             	sub    $0x4,%eax
  8035e0:	8b 00                	mov    (%eax),%eax
  8035e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8035e5:	89 c2                	mov    %eax,%edx
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	01 d0                	add    %edx,%eax
  8035ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035fb:	75 68                	jne    803665 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803601:	75 17                	jne    80361a <realloc_block_FF+0x288>
  803603:	83 ec 04             	sub    $0x4,%esp
  803606:	68 5c 46 80 00       	push   $0x80465c
  80360b:	68 06 02 00 00       	push   $0x206
  803610:	68 41 46 80 00       	push   $0x804641
  803615:	e8 08 ce ff ff       	call   800422 <_panic>
  80361a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803623:	89 10                	mov    %edx,(%eax)
  803625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 0d                	je     80363b <realloc_block_FF+0x2a9>
  80362e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803633:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	eb 08                	jmp    803643 <realloc_block_FF+0x2b1>
  80363b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363e:	a3 30 50 80 00       	mov    %eax,0x805030
  803643:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803646:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803655:	a1 38 50 80 00       	mov    0x805038,%eax
  80365a:	40                   	inc    %eax
  80365b:	a3 38 50 80 00       	mov    %eax,0x805038
  803660:	e9 b0 01 00 00       	jmp    803815 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803665:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80366a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80366d:	76 68                	jbe    8036d7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80366f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803673:	75 17                	jne    80368c <realloc_block_FF+0x2fa>
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 5c 46 80 00       	push   $0x80465c
  80367d:	68 0b 02 00 00       	push   $0x20b
  803682:	68 41 46 80 00       	push   $0x804641
  803687:	e8 96 cd ff ff       	call   800422 <_panic>
  80368c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803695:	89 10                	mov    %edx,(%eax)
  803697:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 0d                	je     8036ad <realloc_block_FF+0x31b>
  8036a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	eb 08                	jmp    8036b5 <realloc_block_FF+0x323>
  8036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8036cc:	40                   	inc    %eax
  8036cd:	a3 38 50 80 00       	mov    %eax,0x805038
  8036d2:	e9 3e 01 00 00       	jmp    803815 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036df:	73 68                	jae    803749 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e5:	75 17                	jne    8036fe <realloc_block_FF+0x36c>
  8036e7:	83 ec 04             	sub    $0x4,%esp
  8036ea:	68 90 46 80 00       	push   $0x804690
  8036ef:	68 10 02 00 00       	push   $0x210
  8036f4:	68 41 46 80 00       	push   $0x804641
  8036f9:	e8 24 cd ff ff       	call   800422 <_panic>
  8036fe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803704:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803707:	89 50 04             	mov    %edx,0x4(%eax)
  80370a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370d:	8b 40 04             	mov    0x4(%eax),%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	74 0c                	je     803720 <realloc_block_FF+0x38e>
  803714:	a1 30 50 80 00       	mov    0x805030,%eax
  803719:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371c:	89 10                	mov    %edx,(%eax)
  80371e:	eb 08                	jmp    803728 <realloc_block_FF+0x396>
  803720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803723:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372b:	a3 30 50 80 00       	mov    %eax,0x805030
  803730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803739:	a1 38 50 80 00       	mov    0x805038,%eax
  80373e:	40                   	inc    %eax
  80373f:	a3 38 50 80 00       	mov    %eax,0x805038
  803744:	e9 cc 00 00 00       	jmp    803815 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803750:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803758:	e9 8a 00 00 00       	jmp    8037e7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803763:	73 7a                	jae    8037df <realloc_block_FF+0x44d>
  803765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80376d:	73 70                	jae    8037df <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80376f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803773:	74 06                	je     80377b <realloc_block_FF+0x3e9>
  803775:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803779:	75 17                	jne    803792 <realloc_block_FF+0x400>
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 b4 46 80 00       	push   $0x8046b4
  803783:	68 1a 02 00 00       	push   $0x21a
  803788:	68 41 46 80 00       	push   $0x804641
  80378d:	e8 90 cc ff ff       	call   800422 <_panic>
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 10                	mov    (%eax),%edx
  803797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 0b                	je     8037b0 <realloc_block_FF+0x41e>
  8037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b6:	89 10                	mov    %edx,(%eax)
  8037b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037be:	89 50 04             	mov    %edx,0x4(%eax)
  8037c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	75 08                	jne    8037d2 <realloc_block_FF+0x440>
  8037ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d7:	40                   	inc    %eax
  8037d8:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037dd:	eb 36                	jmp    803815 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037df:	a1 34 50 80 00       	mov    0x805034,%eax
  8037e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037eb:	74 07                	je     8037f4 <realloc_block_FF+0x462>
  8037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	eb 05                	jmp    8037f9 <realloc_block_FF+0x467>
  8037f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f9:	a3 34 50 80 00       	mov    %eax,0x805034
  8037fe:	a1 34 50 80 00       	mov    0x805034,%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	0f 85 52 ff ff ff    	jne    80375d <realloc_block_FF+0x3cb>
  80380b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380f:	0f 85 48 ff ff ff    	jne    80375d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803815:	83 ec 04             	sub    $0x4,%esp
  803818:	6a 00                	push   $0x0
  80381a:	ff 75 d8             	pushl  -0x28(%ebp)
  80381d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803820:	e8 9d eb ff ff       	call   8023c2 <set_block_data>
  803825:	83 c4 10             	add    $0x10,%esp
				return va;
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	e9 6b 02 00 00       	jmp    803a9b <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803830:	8b 45 08             	mov    0x8(%ebp),%eax
  803833:	e9 63 02 00 00       	jmp    803a9b <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80383e:	0f 86 4d 02 00 00    	jbe    803a91 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803844:	83 ec 0c             	sub    $0xc,%esp
  803847:	ff 75 e4             	pushl  -0x1c(%ebp)
  80384a:	e8 3b e8 ff ff       	call   80208a <is_free_block>
  80384f:	83 c4 10             	add    $0x10,%esp
  803852:	84 c0                	test   %al,%al
  803854:	0f 84 37 02 00 00    	je     803a91 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80385a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803860:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803863:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803866:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803869:	76 38                	jbe    8038a3 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80386b:	83 ec 0c             	sub    $0xc,%esp
  80386e:	ff 75 0c             	pushl  0xc(%ebp)
  803871:	e8 7b eb ff ff       	call   8023f1 <alloc_block_FF>
  803876:	83 c4 10             	add    $0x10,%esp
  803879:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80387c:	83 ec 08             	sub    $0x8,%esp
  80387f:	ff 75 c0             	pushl  -0x40(%ebp)
  803882:	ff 75 08             	pushl  0x8(%ebp)
  803885:	e8 c9 fa ff ff       	call   803353 <copy_data>
  80388a:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80388d:	83 ec 0c             	sub    $0xc,%esp
  803890:	ff 75 08             	pushl  0x8(%ebp)
  803893:	e8 fa f9 ff ff       	call   803292 <free_block>
  803898:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80389b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80389e:	e9 f8 01 00 00       	jmp    803a9b <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038a6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038ac:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038b0:	0f 87 a0 00 00 00    	ja     803956 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ba:	75 17                	jne    8038d3 <realloc_block_FF+0x541>
  8038bc:	83 ec 04             	sub    $0x4,%esp
  8038bf:	68 23 46 80 00       	push   $0x804623
  8038c4:	68 38 02 00 00       	push   $0x238
  8038c9:	68 41 46 80 00       	push   $0x804641
  8038ce:	e8 4f cb ff ff       	call   800422 <_panic>
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	8b 00                	mov    (%eax),%eax
  8038d8:	85 c0                	test   %eax,%eax
  8038da:	74 10                	je     8038ec <realloc_block_FF+0x55a>
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e4:	8b 52 04             	mov    0x4(%edx),%edx
  8038e7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ea:	eb 0b                	jmp    8038f7 <realloc_block_FF+0x565>
  8038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 40 04             	mov    0x4(%eax),%eax
  8038fd:	85 c0                	test   %eax,%eax
  8038ff:	74 0f                	je     803910 <realloc_block_FF+0x57e>
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390a:	8b 12                	mov    (%edx),%edx
  80390c:	89 10                	mov    %edx,(%eax)
  80390e:	eb 0a                	jmp    80391a <realloc_block_FF+0x588>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803926:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392d:	a1 38 50 80 00       	mov    0x805038,%eax
  803932:	48                   	dec    %eax
  803933:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803938:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80393b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393e:	01 d0                	add    %edx,%eax
  803940:	83 ec 04             	sub    $0x4,%esp
  803943:	6a 01                	push   $0x1
  803945:	50                   	push   %eax
  803946:	ff 75 08             	pushl  0x8(%ebp)
  803949:	e8 74 ea ff ff       	call   8023c2 <set_block_data>
  80394e:	83 c4 10             	add    $0x10,%esp
  803951:	e9 36 01 00 00       	jmp    803a8c <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803956:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803959:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80395c:	01 d0                	add    %edx,%eax
  80395e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803961:	83 ec 04             	sub    $0x4,%esp
  803964:	6a 01                	push   $0x1
  803966:	ff 75 f0             	pushl  -0x10(%ebp)
  803969:	ff 75 08             	pushl  0x8(%ebp)
  80396c:	e8 51 ea ff ff       	call   8023c2 <set_block_data>
  803971:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	83 e8 04             	sub    $0x4,%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	83 e0 fe             	and    $0xfffffffe,%eax
  80397f:	89 c2                	mov    %eax,%edx
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	01 d0                	add    %edx,%eax
  803986:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398d:	74 06                	je     803995 <realloc_block_FF+0x603>
  80398f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803993:	75 17                	jne    8039ac <realloc_block_FF+0x61a>
  803995:	83 ec 04             	sub    $0x4,%esp
  803998:	68 b4 46 80 00       	push   $0x8046b4
  80399d:	68 44 02 00 00       	push   $0x244
  8039a2:	68 41 46 80 00       	push   $0x804641
  8039a7:	e8 76 ca ff ff       	call   800422 <_panic>
  8039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039af:	8b 10                	mov    (%eax),%edx
  8039b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b4:	89 10                	mov    %edx,(%eax)
  8039b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b9:	8b 00                	mov    (%eax),%eax
  8039bb:	85 c0                	test   %eax,%eax
  8039bd:	74 0b                	je     8039ca <realloc_block_FF+0x638>
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039c7:	89 50 04             	mov    %edx,0x4(%eax)
  8039ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039d0:	89 10                	mov    %edx,(%eax)
  8039d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d8:	89 50 04             	mov    %edx,0x4(%eax)
  8039db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039de:	8b 00                	mov    (%eax),%eax
  8039e0:	85 c0                	test   %eax,%eax
  8039e2:	75 08                	jne    8039ec <realloc_block_FF+0x65a>
  8039e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8039f1:	40                   	inc    %eax
  8039f2:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fb:	75 17                	jne    803a14 <realloc_block_FF+0x682>
  8039fd:	83 ec 04             	sub    $0x4,%esp
  803a00:	68 23 46 80 00       	push   $0x804623
  803a05:	68 45 02 00 00       	push   $0x245
  803a0a:	68 41 46 80 00       	push   $0x804641
  803a0f:	e8 0e ca ff ff       	call   800422 <_panic>
  803a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	85 c0                	test   %eax,%eax
  803a1b:	74 10                	je     803a2d <realloc_block_FF+0x69b>
  803a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a20:	8b 00                	mov    (%eax),%eax
  803a22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a25:	8b 52 04             	mov    0x4(%edx),%edx
  803a28:	89 50 04             	mov    %edx,0x4(%eax)
  803a2b:	eb 0b                	jmp    803a38 <realloc_block_FF+0x6a6>
  803a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a30:	8b 40 04             	mov    0x4(%eax),%eax
  803a33:	a3 30 50 80 00       	mov    %eax,0x805030
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	8b 40 04             	mov    0x4(%eax),%eax
  803a3e:	85 c0                	test   %eax,%eax
  803a40:	74 0f                	je     803a51 <realloc_block_FF+0x6bf>
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a4b:	8b 12                	mov    (%edx),%edx
  803a4d:	89 10                	mov    %edx,(%eax)
  803a4f:	eb 0a                	jmp    803a5b <realloc_block_FF+0x6c9>
  803a51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a54:	8b 00                	mov    (%eax),%eax
  803a56:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6e:	a1 38 50 80 00       	mov    0x805038,%eax
  803a73:	48                   	dec    %eax
  803a74:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a79:	83 ec 04             	sub    $0x4,%esp
  803a7c:	6a 00                	push   $0x0
  803a7e:	ff 75 bc             	pushl  -0x44(%ebp)
  803a81:	ff 75 b8             	pushl  -0x48(%ebp)
  803a84:	e8 39 e9 ff ff       	call   8023c2 <set_block_data>
  803a89:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	eb 0a                	jmp    803a9b <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a91:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a9b:	c9                   	leave  
  803a9c:	c3                   	ret    

00803a9d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a9d:	55                   	push   %ebp
  803a9e:	89 e5                	mov    %esp,%ebp
  803aa0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803aa3:	83 ec 04             	sub    $0x4,%esp
  803aa6:	68 20 47 80 00       	push   $0x804720
  803aab:	68 58 02 00 00       	push   $0x258
  803ab0:	68 41 46 80 00       	push   $0x804641
  803ab5:	e8 68 c9 ff ff       	call   800422 <_panic>

00803aba <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803aba:	55                   	push   %ebp
  803abb:	89 e5                	mov    %esp,%ebp
  803abd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ac0:	83 ec 04             	sub    $0x4,%esp
  803ac3:	68 48 47 80 00       	push   $0x804748
  803ac8:	68 61 02 00 00       	push   $0x261
  803acd:	68 41 46 80 00       	push   $0x804641
  803ad2:	e8 4b c9 ff ff       	call   800422 <_panic>
  803ad7:	90                   	nop

00803ad8 <__udivdi3>:
  803ad8:	55                   	push   %ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aeb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aef:	89 ca                	mov    %ecx,%edx
  803af1:	89 f8                	mov    %edi,%eax
  803af3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af7:	85 f6                	test   %esi,%esi
  803af9:	75 2d                	jne    803b28 <__udivdi3+0x50>
  803afb:	39 cf                	cmp    %ecx,%edi
  803afd:	77 65                	ja     803b64 <__udivdi3+0x8c>
  803aff:	89 fd                	mov    %edi,%ebp
  803b01:	85 ff                	test   %edi,%edi
  803b03:	75 0b                	jne    803b10 <__udivdi3+0x38>
  803b05:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0a:	31 d2                	xor    %edx,%edx
  803b0c:	f7 f7                	div    %edi
  803b0e:	89 c5                	mov    %eax,%ebp
  803b10:	31 d2                	xor    %edx,%edx
  803b12:	89 c8                	mov    %ecx,%eax
  803b14:	f7 f5                	div    %ebp
  803b16:	89 c1                	mov    %eax,%ecx
  803b18:	89 d8                	mov    %ebx,%eax
  803b1a:	f7 f5                	div    %ebp
  803b1c:	89 cf                	mov    %ecx,%edi
  803b1e:	89 fa                	mov    %edi,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	39 ce                	cmp    %ecx,%esi
  803b2a:	77 28                	ja     803b54 <__udivdi3+0x7c>
  803b2c:	0f bd fe             	bsr    %esi,%edi
  803b2f:	83 f7 1f             	xor    $0x1f,%edi
  803b32:	75 40                	jne    803b74 <__udivdi3+0x9c>
  803b34:	39 ce                	cmp    %ecx,%esi
  803b36:	72 0a                	jb     803b42 <__udivdi3+0x6a>
  803b38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b3c:	0f 87 9e 00 00 00    	ja     803be0 <__udivdi3+0x108>
  803b42:	b8 01 00 00 00       	mov    $0x1,%eax
  803b47:	89 fa                	mov    %edi,%edx
  803b49:	83 c4 1c             	add    $0x1c,%esp
  803b4c:	5b                   	pop    %ebx
  803b4d:	5e                   	pop    %esi
  803b4e:	5f                   	pop    %edi
  803b4f:	5d                   	pop    %ebp
  803b50:	c3                   	ret    
  803b51:	8d 76 00             	lea    0x0(%esi),%esi
  803b54:	31 ff                	xor    %edi,%edi
  803b56:	31 c0                	xor    %eax,%eax
  803b58:	89 fa                	mov    %edi,%edx
  803b5a:	83 c4 1c             	add    $0x1c,%esp
  803b5d:	5b                   	pop    %ebx
  803b5e:	5e                   	pop    %esi
  803b5f:	5f                   	pop    %edi
  803b60:	5d                   	pop    %ebp
  803b61:	c3                   	ret    
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	f7 f7                	div    %edi
  803b68:	31 ff                	xor    %edi,%edi
  803b6a:	89 fa                	mov    %edi,%edx
  803b6c:	83 c4 1c             	add    $0x1c,%esp
  803b6f:	5b                   	pop    %ebx
  803b70:	5e                   	pop    %esi
  803b71:	5f                   	pop    %edi
  803b72:	5d                   	pop    %ebp
  803b73:	c3                   	ret    
  803b74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b79:	89 eb                	mov    %ebp,%ebx
  803b7b:	29 fb                	sub    %edi,%ebx
  803b7d:	89 f9                	mov    %edi,%ecx
  803b7f:	d3 e6                	shl    %cl,%esi
  803b81:	89 c5                	mov    %eax,%ebp
  803b83:	88 d9                	mov    %bl,%cl
  803b85:	d3 ed                	shr    %cl,%ebp
  803b87:	89 e9                	mov    %ebp,%ecx
  803b89:	09 f1                	or     %esi,%ecx
  803b8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8f:	89 f9                	mov    %edi,%ecx
  803b91:	d3 e0                	shl    %cl,%eax
  803b93:	89 c5                	mov    %eax,%ebp
  803b95:	89 d6                	mov    %edx,%esi
  803b97:	88 d9                	mov    %bl,%cl
  803b99:	d3 ee                	shr    %cl,%esi
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e2                	shl    %cl,%edx
  803b9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 e8                	shr    %cl,%eax
  803ba7:	09 c2                	or     %eax,%edx
  803ba9:	89 d0                	mov    %edx,%eax
  803bab:	89 f2                	mov    %esi,%edx
  803bad:	f7 74 24 0c          	divl   0xc(%esp)
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	89 c3                	mov    %eax,%ebx
  803bb5:	f7 e5                	mul    %ebp
  803bb7:	39 d6                	cmp    %edx,%esi
  803bb9:	72 19                	jb     803bd4 <__udivdi3+0xfc>
  803bbb:	74 0b                	je     803bc8 <__udivdi3+0xf0>
  803bbd:	89 d8                	mov    %ebx,%eax
  803bbf:	31 ff                	xor    %edi,%edi
  803bc1:	e9 58 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bcc:	89 f9                	mov    %edi,%ecx
  803bce:	d3 e2                	shl    %cl,%edx
  803bd0:	39 c2                	cmp    %eax,%edx
  803bd2:	73 e9                	jae    803bbd <__udivdi3+0xe5>
  803bd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd7:	31 ff                	xor    %edi,%edi
  803bd9:	e9 40 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	31 c0                	xor    %eax,%eax
  803be2:	e9 37 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803be7:	90                   	nop

00803be8 <__umoddi3>:
  803be8:	55                   	push   %ebp
  803be9:	57                   	push   %edi
  803bea:	56                   	push   %esi
  803beb:	53                   	push   %ebx
  803bec:	83 ec 1c             	sub    $0x1c,%esp
  803bef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c07:	89 f3                	mov    %esi,%ebx
  803c09:	89 fa                	mov    %edi,%edx
  803c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0f:	89 34 24             	mov    %esi,(%esp)
  803c12:	85 c0                	test   %eax,%eax
  803c14:	75 1a                	jne    803c30 <__umoddi3+0x48>
  803c16:	39 f7                	cmp    %esi,%edi
  803c18:	0f 86 a2 00 00 00    	jbe    803cc0 <__umoddi3+0xd8>
  803c1e:	89 c8                	mov    %ecx,%eax
  803c20:	89 f2                	mov    %esi,%edx
  803c22:	f7 f7                	div    %edi
  803c24:	89 d0                	mov    %edx,%eax
  803c26:	31 d2                	xor    %edx,%edx
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	39 f0                	cmp    %esi,%eax
  803c32:	0f 87 ac 00 00 00    	ja     803ce4 <__umoddi3+0xfc>
  803c38:	0f bd e8             	bsr    %eax,%ebp
  803c3b:	83 f5 1f             	xor    $0x1f,%ebp
  803c3e:	0f 84 ac 00 00 00    	je     803cf0 <__umoddi3+0x108>
  803c44:	bf 20 00 00 00       	mov    $0x20,%edi
  803c49:	29 ef                	sub    %ebp,%edi
  803c4b:	89 fe                	mov    %edi,%esi
  803c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c51:	89 e9                	mov    %ebp,%ecx
  803c53:	d3 e0                	shl    %cl,%eax
  803c55:	89 d7                	mov    %edx,%edi
  803c57:	89 f1                	mov    %esi,%ecx
  803c59:	d3 ef                	shr    %cl,%edi
  803c5b:	09 c7                	or     %eax,%edi
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 e2                	shl    %cl,%edx
  803c61:	89 14 24             	mov    %edx,(%esp)
  803c64:	89 d8                	mov    %ebx,%eax
  803c66:	d3 e0                	shl    %cl,%eax
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6e:	d3 e0                	shl    %cl,%eax
  803c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c78:	89 f1                	mov    %esi,%ecx
  803c7a:	d3 e8                	shr    %cl,%eax
  803c7c:	09 d0                	or     %edx,%eax
  803c7e:	d3 eb                	shr    %cl,%ebx
  803c80:	89 da                	mov    %ebx,%edx
  803c82:	f7 f7                	div    %edi
  803c84:	89 d3                	mov    %edx,%ebx
  803c86:	f7 24 24             	mull   (%esp)
  803c89:	89 c6                	mov    %eax,%esi
  803c8b:	89 d1                	mov    %edx,%ecx
  803c8d:	39 d3                	cmp    %edx,%ebx
  803c8f:	0f 82 87 00 00 00    	jb     803d1c <__umoddi3+0x134>
  803c95:	0f 84 91 00 00 00    	je     803d2c <__umoddi3+0x144>
  803c9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9f:	29 f2                	sub    %esi,%edx
  803ca1:	19 cb                	sbb    %ecx,%ebx
  803ca3:	89 d8                	mov    %ebx,%eax
  803ca5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 e9                	mov    %ebp,%ecx
  803cad:	d3 ea                	shr    %cl,%edx
  803caf:	09 d0                	or     %edx,%eax
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 eb                	shr    %cl,%ebx
  803cb5:	89 da                	mov    %ebx,%edx
  803cb7:	83 c4 1c             	add    $0x1c,%esp
  803cba:	5b                   	pop    %ebx
  803cbb:	5e                   	pop    %esi
  803cbc:	5f                   	pop    %edi
  803cbd:	5d                   	pop    %ebp
  803cbe:	c3                   	ret    
  803cbf:	90                   	nop
  803cc0:	89 fd                	mov    %edi,%ebp
  803cc2:	85 ff                	test   %edi,%edi
  803cc4:	75 0b                	jne    803cd1 <__umoddi3+0xe9>
  803cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccb:	31 d2                	xor    %edx,%edx
  803ccd:	f7 f7                	div    %edi
  803ccf:	89 c5                	mov    %eax,%ebp
  803cd1:	89 f0                	mov    %esi,%eax
  803cd3:	31 d2                	xor    %edx,%edx
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 c8                	mov    %ecx,%eax
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 d0                	mov    %edx,%eax
  803cdd:	e9 44 ff ff ff       	jmp    803c26 <__umoddi3+0x3e>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	89 c8                	mov    %ecx,%eax
  803ce6:	89 f2                	mov    %esi,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	3b 04 24             	cmp    (%esp),%eax
  803cf3:	72 06                	jb     803cfb <__umoddi3+0x113>
  803cf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf9:	77 0f                	ja     803d0a <__umoddi3+0x122>
  803cfb:	89 f2                	mov    %esi,%edx
  803cfd:	29 f9                	sub    %edi,%ecx
  803cff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d03:	89 14 24             	mov    %edx,(%esp)
  803d06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0e:	8b 14 24             	mov    (%esp),%edx
  803d11:	83 c4 1c             	add    $0x1c,%esp
  803d14:	5b                   	pop    %ebx
  803d15:	5e                   	pop    %esi
  803d16:	5f                   	pop    %edi
  803d17:	5d                   	pop    %ebp
  803d18:	c3                   	ret    
  803d19:	8d 76 00             	lea    0x0(%esi),%esi
  803d1c:	2b 04 24             	sub    (%esp),%eax
  803d1f:	19 fa                	sbb    %edi,%edx
  803d21:	89 d1                	mov    %edx,%ecx
  803d23:	89 c6                	mov    %eax,%esi
  803d25:	e9 71 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>
  803d2a:	66 90                	xchg   %ax,%ax
  803d2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d30:	72 ea                	jb     803d1c <__umoddi3+0x134>
  803d32:	89 d9                	mov    %ebx,%ecx
  803d34:	e9 62 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>
