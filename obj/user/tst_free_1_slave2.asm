
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
  800060:	68 20 3c 80 00       	push   $0x803c20
  800065:	6a 12                	push   $0x12
  800067:	68 3c 3c 80 00       	push   $0x803c3c
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
  8000bc:	e8 48 19 00 00       	call   801a09 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 8b 19 00 00       	call   801a54 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 58 3c 80 00       	push   $0x803c58
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 3c 3c 80 00       	push   $0x803c3c
  800100:	e8 1d 03 00 00       	call   800422 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 4a 19 00 00       	call   801a54 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 88 3c 80 00       	push   $0x803c88
  800117:	6a 32                	push   $0x32
  800119:	68 3c 3c 80 00       	push   $0x803c3c
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 e1 18 00 00       	call   801a09 <sys_calculate_free_frames>
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
  80015f:	e8 a5 18 00 00       	call   801a09 <sys_calculate_free_frames>
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
  80017c:	68 b8 3c 80 00       	push   $0x803cb8
  800181:	6a 3c                	push   $0x3c
  800183:	68 3c 3c 80 00       	push   $0x803c3c
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
  8001c7:	e8 98 1c 00 00       	call   801e64 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 34 3d 80 00       	push   $0x803d34
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 3c 3c 80 00       	push   $0x803c3c
  8001e7:	e8 36 02 00 00       	call   800422 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 18 18 00 00       	call   801a09 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 5b 18 00 00       	call   801a54 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 41 18 00 00       	call   801a54 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 54 3d 80 00       	push   $0x803d54
  800220:	6a 4d                	push   $0x4d
  800222:	68 3c 3c 80 00       	push   $0x803c3c
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 d8 17 00 00       	call   801a09 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 90 3d 80 00       	push   $0x803d90
  800247:	6a 4e                	push   $0x4e
  800249:	68 3c 3c 80 00       	push   $0x803c3c
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
  80028d:	e8 d2 1b 00 00       	call   801e64 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 dc 3d 80 00       	push   $0x803ddc
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 3c 3c 80 00       	push   $0x803c3c
  8002ad:	e8 70 01 00 00       	call   800422 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 59 1a 00 00       	call   801d10 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 6d 1a 00 00       	call   801d2a <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 41 1a 00 00       	call   801d10 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 00 3e 80 00       	push   $0x803e00
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 3c 3c 80 00       	push   $0x803c3c
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
  8002e9:	e8 e4 18 00 00       	call   801bd2 <sys_getenvindex>
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
  800357:	e8 fa 15 00 00       	call   801956 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 64 3e 80 00       	push   $0x803e64
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
  800387:	68 8c 3e 80 00       	push   $0x803e8c
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
  8003b8:	68 b4 3e 80 00       	push   $0x803eb4
  8003bd:	e8 1d 03 00 00       	call   8006df <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	50                   	push   %eax
  8003d4:	68 0c 3f 80 00       	push   $0x803f0c
  8003d9:	e8 01 03 00 00       	call   8006df <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 64 3e 80 00       	push   $0x803e64
  8003e9:	e8 f1 02 00 00       	call   8006df <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f1:	e8 7a 15 00 00       	call   801970 <sys_unlock_cons>
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
  800409:	e8 90 17 00 00       	call   801b9e <sys_destroy_env>
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
  80041a:	e8 e5 17 00 00       	call   801c04 <sys_exit_env>
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
  800443:	68 20 3f 80 00       	push   $0x803f20
  800448:	e8 92 02 00 00       	call   8006df <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800450:	a1 00 50 80 00       	mov    0x805000,%eax
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	50                   	push   %eax
  80045c:	68 25 3f 80 00       	push   $0x803f25
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
  800480:	68 41 3f 80 00       	push   $0x803f41
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
  8004af:	68 44 3f 80 00       	push   $0x803f44
  8004b4:	6a 26                	push   $0x26
  8004b6:	68 90 3f 80 00       	push   $0x803f90
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
  800584:	68 9c 3f 80 00       	push   $0x803f9c
  800589:	6a 3a                	push   $0x3a
  80058b:	68 90 3f 80 00       	push   $0x803f90
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
  8005f7:	68 f0 3f 80 00       	push   $0x803ff0
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 90 3f 80 00       	push   $0x803f90
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
  800651:	e8 be 12 00 00       	call   801914 <sys_cputs>
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
  8006c8:	e8 47 12 00 00       	call   801914 <sys_cputs>
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
  800712:	e8 3f 12 00 00       	call   801956 <sys_lock_cons>
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
  800732:	e8 39 12 00 00       	call   801970 <sys_unlock_cons>
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
  80077c:	e8 2b 32 00 00       	call   8039ac <__udivdi3>
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
  8007cc:	e8 eb 32 00 00       	call   803abc <__umoddi3>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	05 54 42 80 00       	add    $0x804254,%eax
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
  800927:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  800a08:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	75 19                	jne    800a2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a13:	53                   	push   %ebx
  800a14:	68 65 42 80 00       	push   $0x804265
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
  800a2d:	68 6e 42 80 00       	push   $0x80426e
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
  800a5a:	be 71 42 80 00       	mov    $0x804271,%esi
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
  801465:	68 e8 43 80 00       	push   $0x8043e8
  80146a:	68 3f 01 00 00       	push   $0x13f
  80146f:	68 0a 44 80 00       	push   $0x80440a
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
  801485:	e8 35 0a 00 00       	call   801ebf <sys_sbrk>
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
  801500:	e8 3e 08 00 00       	call   801d43 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 7e 0d 00 00       	call   802292 <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 50 08 00 00       	call   801d74 <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 17 12 00 00       	call   80274e <alloc_block_BF>
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
  801698:	e8 59 08 00 00       	call   801ef6 <sys_allocate_user_mem>
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
  8016e0:	e8 2d 08 00 00       	call   801f12 <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 60 1a 00 00       	call   803156 <free_block>
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
  801788:	e8 4d 07 00 00       	call   801eda <sys_free_user_mem>
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
  801796:	68 18 44 80 00       	push   $0x804418
  80179b:	68 84 00 00 00       	push   $0x84
  8017a0:	68 42 44 80 00       	push   $0x804442
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
  801808:	e8 d4 02 00 00       	call   801ae1 <sys_createSharedObject>
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
  801829:	68 4e 44 80 00       	push   $0x80444e
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
  80183e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 54 44 80 00       	push   $0x804454
  801849:	68 a4 00 00 00       	push   $0xa4
  80184e:	68 42 44 80 00       	push   $0x804442
  801853:	e8 ca eb ff ff       	call   800422 <_panic>

00801858 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 78 44 80 00       	push   $0x804478
  801866:	68 bc 00 00 00       	push   $0xbc
  80186b:	68 42 44 80 00       	push   $0x804442
  801870:	e8 ad eb ff ff       	call   800422 <_panic>

00801875 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	68 9c 44 80 00       	push   $0x80449c
  801883:	68 d3 00 00 00       	push   $0xd3
  801888:	68 42 44 80 00       	push   $0x804442
  80188d:	e8 90 eb ff ff       	call   800422 <_panic>

00801892 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 c2 44 80 00       	push   $0x8044c2
  8018a0:	68 df 00 00 00       	push   $0xdf
  8018a5:	68 42 44 80 00       	push   $0x804442
  8018aa:	e8 73 eb ff ff       	call   800422 <_panic>

008018af <shrink>:

}
void shrink(uint32 newSize)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 c2 44 80 00       	push   $0x8044c2
  8018bd:	68 e4 00 00 00       	push   $0xe4
  8018c2:	68 42 44 80 00       	push   $0x804442
  8018c7:	e8 56 eb ff ff       	call   800422 <_panic>

008018cc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 c2 44 80 00       	push   $0x8044c2
  8018da:	68 e9 00 00 00       	push   $0xe9
  8018df:	68 42 44 80 00       	push   $0x804442
  8018e4:	e8 39 eb ff ff       	call   800422 <_panic>

008018e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	57                   	push   %edi
  8018ed:	56                   	push   %esi
  8018ee:	53                   	push   %ebx
  8018ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801901:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801904:	cd 30                	int    $0x30
  801906:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801909:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	8b 45 10             	mov    0x10(%ebp),%eax
  80191d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801920:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	50                   	push   %eax
  801930:	6a 00                	push   $0x0
  801932:	e8 b2 ff ff ff       	call   8018e9 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_cgetc>:

int
sys_cgetc(void)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 02                	push   $0x2
  80194c:	e8 98 ff ff ff       	call   8018e9 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 03                	push   $0x3
  801965:	e8 7f ff ff ff       	call   8018e9 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	90                   	nop
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 04                	push   $0x4
  80197f:	e8 65 ff ff ff       	call   8018e9 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 08                	push   $0x8
  80199d:	e8 47 ff ff ff       	call   8018e9 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ac:	8b 75 18             	mov    0x18(%ebp),%esi
  8019af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	56                   	push   %esi
  8019bc:	53                   	push   %ebx
  8019bd:	51                   	push   %ecx
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	6a 09                	push   $0x9
  8019c2:	e8 22 ff ff ff       	call   8018e9 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5e                   	pop    %esi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 0a                	push   $0xa
  8019e4:	e8 00 ff ff ff       	call   8018e9 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 0b                	push   $0xb
  8019ff:	e8 e5 fe ff ff       	call   8018e9 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 0c                	push   $0xc
  801a18:	e8 cc fe ff ff       	call   8018e9 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 0d                	push   $0xd
  801a31:	e8 b3 fe ff ff       	call   8018e9 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 0e                	push   $0xe
  801a4a:	e8 9a fe ff ff       	call   8018e9 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 0f                	push   $0xf
  801a63:	e8 81 fe ff ff       	call   8018e9 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 10                	push   $0x10
  801a7d:	e8 67 fe ff ff       	call   8018e9 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 11                	push   $0x11
  801a96:	e8 4e fe ff ff       	call   8018e9 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_cputc>:

void
sys_cputc(const char c)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	50                   	push   %eax
  801aba:	6a 01                	push   $0x1
  801abc:	e8 28 fe ff ff       	call   8018e9 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 14                	push   $0x14
  801ad6:	e8 0e fe ff ff       	call   8018e9 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	51                   	push   %ecx
  801afa:	52                   	push   %edx
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	6a 15                	push   $0x15
  801b01:	e8 e3 fd ff ff       	call   8018e9 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 16                	push   $0x16
  801b1e:	e8 c6 fd ff ff       	call   8018e9 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	51                   	push   %ecx
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 17                	push   $0x17
  801b3d:	e8 a7 fd ff ff       	call   8018e9 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	6a 18                	push   $0x18
  801b5a:	e8 8a fd ff ff       	call   8018e9 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	ff 75 14             	pushl  0x14(%ebp)
  801b6f:	ff 75 10             	pushl  0x10(%ebp)
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	50                   	push   %eax
  801b76:	6a 19                	push   $0x19
  801b78:	e8 6c fd ff ff       	call   8018e9 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	50                   	push   %eax
  801b91:	6a 1a                	push   $0x1a
  801b93:	e8 51 fd ff ff       	call   8018e9 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	90                   	nop
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	50                   	push   %eax
  801bad:	6a 1b                	push   $0x1b
  801baf:	e8 35 fd ff ff       	call   8018e9 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 05                	push   $0x5
  801bc8:	e8 1c fd ff ff       	call   8018e9 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 06                	push   $0x6
  801be1:	e8 03 fd ff ff       	call   8018e9 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 07                	push   $0x7
  801bfa:	e8 ea fc ff ff       	call   8018e9 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_exit_env>:


void sys_exit_env(void)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 1c                	push   $0x1c
  801c13:	e8 d1 fc ff ff       	call   8018e9 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c27:	8d 50 04             	lea    0x4(%eax),%edx
  801c2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	52                   	push   %edx
  801c34:	50                   	push   %eax
  801c35:	6a 1d                	push   $0x1d
  801c37:	e8 ad fc ff ff       	call   8018e9 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c48:	89 01                	mov    %eax,(%ecx)
  801c4a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	c9                   	leave  
  801c51:	c2 04 00             	ret    $0x4

00801c54 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 10             	pushl  0x10(%ebp)
  801c5e:	ff 75 0c             	pushl  0xc(%ebp)
  801c61:	ff 75 08             	pushl  0x8(%ebp)
  801c64:	6a 13                	push   $0x13
  801c66:	e8 7e fc ff ff       	call   8018e9 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6e:	90                   	nop
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 1e                	push   $0x1e
  801c80:	e8 64 fc ff ff       	call   8018e9 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 04             	sub    $0x4,%esp
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c96:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	50                   	push   %eax
  801ca3:	6a 1f                	push   $0x1f
  801ca5:	e8 3f fc ff ff       	call   8018e9 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cad:	90                   	nop
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <rsttst>:
void rsttst()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 21                	push   $0x21
  801cbf:	e8 25 fc ff ff       	call   8018e9 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc7:	90                   	nop
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cd6:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	ff 75 10             	pushl  0x10(%ebp)
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	6a 20                	push   $0x20
  801cea:	e8 fa fb ff ff       	call   8018e9 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf2:	90                   	nop
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <chktst>:
void chktst(uint32 n)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 22                	push   $0x22
  801d05:	e8 df fb ff ff       	call   8018e9 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <inctst>:

void inctst()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 23                	push   $0x23
  801d1f:	e8 c5 fb ff ff       	call   8018e9 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <gettst>:
uint32 gettst()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 24                	push   $0x24
  801d39:	e8 ab fb ff ff       	call   8018e9 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 25                	push   $0x25
  801d55:	e8 8f fb ff ff       	call   8018e9 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
  801d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d60:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d64:	75 07                	jne    801d6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	eb 05                	jmp    801d72 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 25                	push   $0x25
  801d86:	e8 5e fb ff ff       	call   8018e9 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d91:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 25                	push   $0x25
  801db7:	e8 2d fb ff ff       	call   8018e9 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dc2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 25                	push   $0x25
  801de8:	e8 fc fa ff ff       	call   8018e9 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801df3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	6a 26                	push   $0x26
  801e17:	e8 cd fa ff ff       	call   8018e9 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1f:	90                   	nop
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	53                   	push   %ebx
  801e35:	51                   	push   %ecx
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 27                	push   $0x27
  801e3a:	e8 aa fa ff ff       	call   8018e9 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	52                   	push   %edx
  801e57:	50                   	push   %eax
  801e58:	6a 28                	push   $0x28
  801e5a:	e8 8a fa ff ff       	call   8018e9 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e67:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	51                   	push   %ecx
  801e73:	ff 75 10             	pushl  0x10(%ebp)
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 29                	push   $0x29
  801e7a:	e8 6a fa ff ff       	call   8018e9 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	ff 75 10             	pushl  0x10(%ebp)
  801e8e:	ff 75 0c             	pushl  0xc(%ebp)
  801e91:	ff 75 08             	pushl  0x8(%ebp)
  801e94:	6a 12                	push   $0x12
  801e96:	e8 4e fa ff ff       	call   8018e9 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 2a                	push   $0x2a
  801eb4:	e8 30 fa ff ff       	call   8018e9 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
	return;
  801ebc:	90                   	nop
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	50                   	push   %eax
  801ece:	6a 2b                	push   $0x2b
  801ed0:	e8 14 fa ff ff       	call   8018e9 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 0c             	pushl  0xc(%ebp)
  801ee6:	ff 75 08             	pushl  0x8(%ebp)
  801ee9:	6a 2c                	push   $0x2c
  801eeb:	e8 f9 f9 ff ff       	call   8018e9 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
	return;
  801ef3:	90                   	nop
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 2d                	push   $0x2d
  801f07:	e8 dd f9 ff ff       	call   8018e9 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	83 e8 04             	sub    $0x4,%eax
  801f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f24:	8b 00                	mov    (%eax),%eax
  801f26:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	83 e8 04             	sub    $0x4,%eax
  801f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	83 e0 01             	and    $0x1,%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	0f 94 c0             	sete   %al
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	83 f8 02             	cmp    $0x2,%eax
  801f5c:	74 2b                	je     801f89 <alloc_block+0x40>
  801f5e:	83 f8 02             	cmp    $0x2,%eax
  801f61:	7f 07                	jg     801f6a <alloc_block+0x21>
  801f63:	83 f8 01             	cmp    $0x1,%eax
  801f66:	74 0e                	je     801f76 <alloc_block+0x2d>
  801f68:	eb 58                	jmp    801fc2 <alloc_block+0x79>
  801f6a:	83 f8 03             	cmp    $0x3,%eax
  801f6d:	74 2d                	je     801f9c <alloc_block+0x53>
  801f6f:	83 f8 04             	cmp    $0x4,%eax
  801f72:	74 3b                	je     801faf <alloc_block+0x66>
  801f74:	eb 4c                	jmp    801fc2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	ff 75 08             	pushl  0x8(%ebp)
  801f7c:	e8 11 03 00 00       	call   802292 <alloc_block_FF>
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f87:	eb 4a                	jmp    801fd3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	ff 75 08             	pushl  0x8(%ebp)
  801f8f:	e8 fa 19 00 00       	call   80398e <alloc_block_NF>
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f9a:	eb 37                	jmp    801fd3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff 75 08             	pushl  0x8(%ebp)
  801fa2:	e8 a7 07 00 00       	call   80274e <alloc_block_BF>
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fad:	eb 24                	jmp    801fd3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	e8 b7 19 00 00       	call   803971 <alloc_block_WF>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc0:	eb 11                	jmp    801fd3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	68 d4 44 80 00       	push   $0x8044d4
  801fca:	e8 10 e7 ff ff       	call   8006df <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
		break;
  801fd2:	90                   	nop
	}
	return va;
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	53                   	push   %ebx
  801fdc:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	68 f4 44 80 00       	push   $0x8044f4
  801fe7:	e8 f3 e6 ff ff       	call   8006df <cprintf>
  801fec:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	68 1f 45 80 00       	push   $0x80451f
  801ff7:	e8 e3 e6 ff ff       	call   8006df <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802005:	eb 37                	jmp    80203e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 f4             	pushl  -0xc(%ebp)
  80200d:	e8 19 ff ff ff       	call   801f2b <is_free_block>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	0f be d8             	movsbl %al,%ebx
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 f4             	pushl  -0xc(%ebp)
  80201e:	e8 ef fe ff ff       	call   801f12 <get_block_size>
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	53                   	push   %ebx
  80202a:	50                   	push   %eax
  80202b:	68 37 45 80 00       	push   $0x804537
  802030:	e8 aa e6 ff ff       	call   8006df <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802038:	8b 45 10             	mov    0x10(%ebp),%eax
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802042:	74 07                	je     80204b <print_blocks_list+0x73>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	eb 05                	jmp    802050 <print_blocks_list+0x78>
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	89 45 10             	mov    %eax,0x10(%ebp)
  802053:	8b 45 10             	mov    0x10(%ebp),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	75 ad                	jne    802007 <print_blocks_list+0x2f>
  80205a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205e:	75 a7                	jne    802007 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	68 f4 44 80 00       	push   $0x8044f4
  802068:	e8 72 e6 ff ff       	call   8006df <cprintf>
  80206d:	83 c4 10             	add    $0x10,%esp

}
  802070:	90                   	nop
  802071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	83 e0 01             	and    $0x1,%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 03                	je     802089 <initialize_dynamic_allocator+0x13>
  802086:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802089:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208d:	0f 84 c7 01 00 00    	je     80225a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802093:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80209a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80209d:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	01 d0                	add    %edx,%eax
  8020a5:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020aa:	0f 87 ad 01 00 00    	ja     80225d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	0f 89 a5 01 00 00    	jns    802260 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	01 d0                	add    %edx,%eax
  8020c3:	83 e8 04             	sub    $0x4,%eax
  8020c6:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020da:	e9 87 00 00 00       	jmp    802166 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e3:	75 14                	jne    8020f9 <initialize_dynamic_allocator+0x83>
  8020e5:	83 ec 04             	sub    $0x4,%esp
  8020e8:	68 4f 45 80 00       	push   $0x80454f
  8020ed:	6a 79                	push   $0x79
  8020ef:	68 6d 45 80 00       	push   $0x80456d
  8020f4:	e8 29 e3 ff ff       	call   800422 <_panic>
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 10                	je     802112 <initialize_dynamic_allocator+0x9c>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210a:	8b 52 04             	mov    0x4(%edx),%edx
  80210d:	89 50 04             	mov    %edx,0x4(%eax)
  802110:	eb 0b                	jmp    80211d <initialize_dynamic_allocator+0xa7>
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 40 04             	mov    0x4(%eax),%eax
  802118:	a3 30 50 80 00       	mov    %eax,0x805030
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 40 04             	mov    0x4(%eax),%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	74 0f                	je     802136 <initialize_dynamic_allocator+0xc0>
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 40 04             	mov    0x4(%eax),%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	8b 12                	mov    (%edx),%edx
  802132:	89 10                	mov    %edx,(%eax)
  802134:	eb 0a                	jmp    802140 <initialize_dynamic_allocator+0xca>
  802136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802153:	a1 38 50 80 00       	mov    0x805038,%eax
  802158:	48                   	dec    %eax
  802159:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80215e:	a1 34 50 80 00       	mov    0x805034,%eax
  802163:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216a:	74 07                	je     802173 <initialize_dynamic_allocator+0xfd>
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	eb 05                	jmp    802178 <initialize_dynamic_allocator+0x102>
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	a3 34 50 80 00       	mov    %eax,0x805034
  80217d:	a1 34 50 80 00       	mov    0x805034,%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 85 55 ff ff ff    	jne    8020df <initialize_dynamic_allocator+0x69>
  80218a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218e:	0f 85 4b ff ff ff    	jne    8020df <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021a3:	a1 44 50 80 00       	mov    0x805044,%eax
  8021a8:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	83 c0 08             	add    $0x8,%eax
  8021be:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	83 c0 04             	add    $0x4,%eax
  8021c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ca:	83 ea 08             	sub    $0x8,%edx
  8021cd:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	01 d0                	add    %edx,%eax
  8021d7:	83 e8 08             	sub    $0x8,%eax
  8021da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dd:	83 ea 08             	sub    $0x8,%edx
  8021e0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021f9:	75 17                	jne    802212 <initialize_dynamic_allocator+0x19c>
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	68 88 45 80 00       	push   $0x804588
  802203:	68 90 00 00 00       	push   $0x90
  802208:	68 6d 45 80 00       	push   $0x80456d
  80220d:	e8 10 e2 ff ff       	call   800422 <_panic>
  802212:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	89 10                	mov    %edx,(%eax)
  80221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	85 c0                	test   %eax,%eax
  802224:	74 0d                	je     802233 <initialize_dynamic_allocator+0x1bd>
  802226:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80222b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222e:	89 50 04             	mov    %edx,0x4(%eax)
  802231:	eb 08                	jmp    80223b <initialize_dynamic_allocator+0x1c5>
  802233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802236:	a3 30 50 80 00       	mov    %eax,0x805030
  80223b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224d:	a1 38 50 80 00       	mov    0x805038,%eax
  802252:	40                   	inc    %eax
  802253:	a3 38 50 80 00       	mov    %eax,0x805038
  802258:	eb 07                	jmp    802261 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80225a:	90                   	nop
  80225b:	eb 04                	jmp    802261 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80225d:	90                   	nop
  80225e:	eb 01                	jmp    802261 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802260:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802266:	8b 45 10             	mov    0x10(%ebp),%eax
  802269:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802272:	8b 45 0c             	mov    0xc(%ebp),%eax
  802275:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	83 e8 04             	sub    $0x4,%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	83 e0 fe             	and    $0xfffffffe,%eax
  802282:	8d 50 f8             	lea    -0x8(%eax),%edx
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	01 c2                	add    %eax,%edx
  80228a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228d:	89 02                	mov    %eax,(%edx)
}
  80228f:	90                   	nop
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    

00802292 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	83 e0 01             	and    $0x1,%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 03                	je     8022a5 <alloc_block_FF+0x13>
  8022a2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022a5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022a9:	77 07                	ja     8022b2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022ab:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	75 73                	jne    80232e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	83 c0 10             	add    $0x10,%eax
  8022c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022c4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	48                   	dec    %eax
  8022d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022da:	ba 00 00 00 00       	mov    $0x0,%edx
  8022df:	f7 75 ec             	divl   -0x14(%ebp)
  8022e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e5:	29 d0                	sub    %edx,%eax
  8022e7:	c1 e8 0c             	shr    $0xc,%eax
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	50                   	push   %eax
  8022ee:	e8 86 f1 ff ff       	call   801479 <sbrk>
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	6a 00                	push   $0x0
  8022fe:	e8 76 f1 ff ff       	call   801479 <sbrk>
  802303:	83 c4 10             	add    $0x10,%esp
  802306:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80230f:	83 ec 08             	sub    $0x8,%esp
  802312:	50                   	push   %eax
  802313:	ff 75 e4             	pushl  -0x1c(%ebp)
  802316:	e8 5b fd ff ff       	call   802076 <initialize_dynamic_allocator>
  80231b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80231e:	83 ec 0c             	sub    $0xc,%esp
  802321:	68 ab 45 80 00       	push   $0x8045ab
  802326:	e8 b4 e3 ff ff       	call   8006df <cprintf>
  80232b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80232e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802332:	75 0a                	jne    80233e <alloc_block_FF+0xac>
	        return NULL;
  802334:	b8 00 00 00 00       	mov    $0x0,%eax
  802339:	e9 0e 04 00 00       	jmp    80274c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80233e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802345:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234d:	e9 f3 02 00 00       	jmp    802645 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802358:	83 ec 0c             	sub    $0xc,%esp
  80235b:	ff 75 bc             	pushl  -0x44(%ebp)
  80235e:	e8 af fb ff ff       	call   801f12 <get_block_size>
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	83 c0 08             	add    $0x8,%eax
  80236f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802372:	0f 87 c5 02 00 00    	ja     80263d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	83 c0 18             	add    $0x18,%eax
  80237e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802381:	0f 87 19 02 00 00    	ja     8025a0 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802387:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80238a:	2b 45 08             	sub    0x8(%ebp),%eax
  80238d:	83 e8 08             	sub    $0x8,%eax
  802390:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	8d 50 08             	lea    0x8(%eax),%edx
  802399:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80239c:	01 d0                	add    %edx,%eax
  80239e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	83 c0 08             	add    $0x8,%eax
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	6a 01                	push   $0x1
  8023ac:	50                   	push   %eax
  8023ad:	ff 75 bc             	pushl  -0x44(%ebp)
  8023b0:	e8 ae fe ff ff       	call   802263 <set_block_data>
  8023b5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	75 68                	jne    80242a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023c2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023c6:	75 17                	jne    8023df <alloc_block_FF+0x14d>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 88 45 80 00       	push   $0x804588
  8023d0:	68 d7 00 00 00       	push   $0xd7
  8023d5:	68 6d 45 80 00       	push   $0x80456d
  8023da:	e8 43 e0 ff ff       	call   800422 <_panic>
  8023df:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e8:	89 10                	mov    %edx,(%eax)
  8023ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	74 0d                	je     802400 <alloc_block_FF+0x16e>
  8023f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023f8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023fb:	89 50 04             	mov    %edx,0x4(%eax)
  8023fe:	eb 08                	jmp    802408 <alloc_block_FF+0x176>
  802400:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802403:	a3 30 50 80 00       	mov    %eax,0x805030
  802408:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802410:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 38 50 80 00       	mov    0x805038,%eax
  80241f:	40                   	inc    %eax
  802420:	a3 38 50 80 00       	mov    %eax,0x805038
  802425:	e9 dc 00 00 00       	jmp    802506 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	75 65                	jne    802498 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802433:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802437:	75 17                	jne    802450 <alloc_block_FF+0x1be>
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 bc 45 80 00       	push   $0x8045bc
  802441:	68 db 00 00 00       	push   $0xdb
  802446:	68 6d 45 80 00       	push   $0x80456d
  80244b:	e8 d2 df ff ff       	call   800422 <_panic>
  802450:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802456:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802459:	89 50 04             	mov    %edx,0x4(%eax)
  80245c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 0c                	je     802472 <alloc_block_FF+0x1e0>
  802466:	a1 30 50 80 00       	mov    0x805030,%eax
  80246b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80246e:	89 10                	mov    %edx,(%eax)
  802470:	eb 08                	jmp    80247a <alloc_block_FF+0x1e8>
  802472:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802475:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80247a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247d:	a3 30 50 80 00       	mov    %eax,0x805030
  802482:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248b:	a1 38 50 80 00       	mov    0x805038,%eax
  802490:	40                   	inc    %eax
  802491:	a3 38 50 80 00       	mov    %eax,0x805038
  802496:	eb 6e                	jmp    802506 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249c:	74 06                	je     8024a4 <alloc_block_FF+0x212>
  80249e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024a2:	75 17                	jne    8024bb <alloc_block_FF+0x229>
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 e0 45 80 00       	push   $0x8045e0
  8024ac:	68 df 00 00 00       	push   $0xdf
  8024b1:	68 6d 45 80 00       	push   $0x80456d
  8024b6:	e8 67 df ff ff       	call   800422 <_panic>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 10                	mov    (%eax),%edx
  8024c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c3:	89 10                	mov    %edx,(%eax)
  8024c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 0b                	je     8024d9 <alloc_block_FF+0x247>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d6:	89 50 04             	mov    %edx,0x4(%eax)
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 08                	jne    8024fb <alloc_block_FF+0x269>
  8024f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024fb:	a1 38 50 80 00       	mov    0x805038,%eax
  802500:	40                   	inc    %eax
  802501:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	75 17                	jne    802523 <alloc_block_FF+0x291>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 4f 45 80 00       	push   $0x80454f
  802514:	68 e1 00 00 00       	push   $0xe1
  802519:	68 6d 45 80 00       	push   $0x80456d
  80251e:	e8 ff de ff ff       	call   800422 <_panic>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	74 10                	je     80253c <alloc_block_FF+0x2aa>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 00                	mov    (%eax),%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	8b 52 04             	mov    0x4(%edx),%edx
  802537:	89 50 04             	mov    %edx,0x4(%eax)
  80253a:	eb 0b                	jmp    802547 <alloc_block_FF+0x2b5>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	a3 30 50 80 00       	mov    %eax,0x805030
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 0f                	je     802560 <alloc_block_FF+0x2ce>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255a:	8b 12                	mov    (%edx),%edx
  80255c:	89 10                	mov    %edx,(%eax)
  80255e:	eb 0a                	jmp    80256a <alloc_block_FF+0x2d8>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257d:	a1 38 50 80 00       	mov    0x805038,%eax
  802582:	48                   	dec    %eax
  802583:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	6a 00                	push   $0x0
  80258d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802590:	ff 75 b0             	pushl  -0x50(%ebp)
  802593:	e8 cb fc ff ff       	call   802263 <set_block_data>
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	e9 95 00 00 00       	jmp    802635 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	6a 01                	push   $0x1
  8025a5:	ff 75 b8             	pushl  -0x48(%ebp)
  8025a8:	ff 75 bc             	pushl  -0x44(%ebp)
  8025ab:	e8 b3 fc ff ff       	call   802263 <set_block_data>
  8025b0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	75 17                	jne    8025d0 <alloc_block_FF+0x33e>
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	68 4f 45 80 00       	push   $0x80454f
  8025c1:	68 e8 00 00 00       	push   $0xe8
  8025c6:	68 6d 45 80 00       	push   $0x80456d
  8025cb:	e8 52 de ff ff       	call   800422 <_panic>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 10                	je     8025e9 <alloc_block_FF+0x357>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e1:	8b 52 04             	mov    0x4(%edx),%edx
  8025e4:	89 50 04             	mov    %edx,0x4(%eax)
  8025e7:	eb 0b                	jmp    8025f4 <alloc_block_FF+0x362>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 04             	mov    0x4(%eax),%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	74 0f                	je     80260d <alloc_block_FF+0x37b>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802607:	8b 12                	mov    (%edx),%edx
  802609:	89 10                	mov    %edx,(%eax)
  80260b:	eb 0a                	jmp    802617 <alloc_block_FF+0x385>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262a:	a1 38 50 80 00       	mov    0x805038,%eax
  80262f:	48                   	dec    %eax
  802630:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802635:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802638:	e9 0f 01 00 00       	jmp    80274c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80263d:	a1 34 50 80 00       	mov    0x805034,%eax
  802642:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802649:	74 07                	je     802652 <alloc_block_FF+0x3c0>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	eb 05                	jmp    802657 <alloc_block_FF+0x3c5>
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
  802657:	a3 34 50 80 00       	mov    %eax,0x805034
  80265c:	a1 34 50 80 00       	mov    0x805034,%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 85 e9 fc ff ff    	jne    802352 <alloc_block_FF+0xc0>
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	0f 85 df fc ff ff    	jne    802352 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	83 c0 08             	add    $0x8,%eax
  802679:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80267c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802683:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802686:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802689:	01 d0                	add    %edx,%eax
  80268b:	48                   	dec    %eax
  80268c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80268f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802692:	ba 00 00 00 00       	mov    $0x0,%edx
  802697:	f7 75 d8             	divl   -0x28(%ebp)
  80269a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80269d:	29 d0                	sub    %edx,%eax
  80269f:	c1 e8 0c             	shr    $0xc,%eax
  8026a2:	83 ec 0c             	sub    $0xc,%esp
  8026a5:	50                   	push   %eax
  8026a6:	e8 ce ed ff ff       	call   801479 <sbrk>
  8026ab:	83 c4 10             	add    $0x10,%esp
  8026ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026b1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026b5:	75 0a                	jne    8026c1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	e9 8b 00 00 00       	jmp    80274c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026c1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	48                   	dec    %eax
  8026d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dc:	f7 75 cc             	divl   -0x34(%ebp)
  8026df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e2:	29 d0                	sub    %edx,%eax
  8026e4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026fc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802703:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802706:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	48                   	dec    %eax
  80270c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80270f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802712:	ba 00 00 00 00       	mov    $0x0,%edx
  802717:	f7 75 c4             	divl   -0x3c(%ebp)
  80271a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80271d:	29 d0                	sub    %edx,%eax
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	6a 01                	push   $0x1
  802724:	50                   	push   %eax
  802725:	ff 75 d0             	pushl  -0x30(%ebp)
  802728:	e8 36 fb ff ff       	call   802263 <set_block_data>
  80272d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802730:	83 ec 0c             	sub    $0xc,%esp
  802733:	ff 75 d0             	pushl  -0x30(%ebp)
  802736:	e8 1b 0a 00 00       	call   803156 <free_block>
  80273b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	ff 75 08             	pushl  0x8(%ebp)
  802744:	e8 49 fb ff ff       	call   802292 <alloc_block_FF>
  802749:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	83 e0 01             	and    $0x1,%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	74 03                	je     802761 <alloc_block_BF+0x13>
  80275e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802761:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802765:	77 07                	ja     80276e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802767:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80276e:	a1 24 50 80 00       	mov    0x805024,%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	75 73                	jne    8027ea <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	83 c0 10             	add    $0x10,%eax
  80277d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802780:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802787:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80278a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	48                   	dec    %eax
  802790:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802793:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802796:	ba 00 00 00 00       	mov    $0x0,%edx
  80279b:	f7 75 e0             	divl   -0x20(%ebp)
  80279e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a1:	29 d0                	sub    %edx,%eax
  8027a3:	c1 e8 0c             	shr    $0xc,%eax
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	50                   	push   %eax
  8027aa:	e8 ca ec ff ff       	call   801479 <sbrk>
  8027af:	83 c4 10             	add    $0x10,%esp
  8027b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	6a 00                	push   $0x0
  8027ba:	e8 ba ec ff ff       	call   801479 <sbrk>
  8027bf:	83 c4 10             	add    $0x10,%esp
  8027c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027cb:	83 ec 08             	sub    $0x8,%esp
  8027ce:	50                   	push   %eax
  8027cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8027d2:	e8 9f f8 ff ff       	call   802076 <initialize_dynamic_allocator>
  8027d7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027da:	83 ec 0c             	sub    $0xc,%esp
  8027dd:	68 ab 45 80 00       	push   $0x8045ab
  8027e2:	e8 f8 de ff ff       	call   8006df <cprintf>
  8027e7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027f8:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802806:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	e9 1d 01 00 00       	jmp    802930 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802819:	83 ec 0c             	sub    $0xc,%esp
  80281c:	ff 75 a8             	pushl  -0x58(%ebp)
  80281f:	e8 ee f6 ff ff       	call   801f12 <get_block_size>
  802824:	83 c4 10             	add    $0x10,%esp
  802827:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	83 c0 08             	add    $0x8,%eax
  802830:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802833:	0f 87 ef 00 00 00    	ja     802928 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	83 c0 18             	add    $0x18,%eax
  80283f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802842:	77 1d                	ja     802861 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80284a:	0f 86 d8 00 00 00    	jbe    802928 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802850:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802853:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802856:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802859:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80285c:	e9 c7 00 00 00       	jmp    802928 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	83 c0 08             	add    $0x8,%eax
  802867:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286a:	0f 85 9d 00 00 00    	jne    80290d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	6a 01                	push   $0x1
  802875:	ff 75 a4             	pushl  -0x5c(%ebp)
  802878:	ff 75 a8             	pushl  -0x58(%ebp)
  80287b:	e8 e3 f9 ff ff       	call   802263 <set_block_data>
  802880:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802887:	75 17                	jne    8028a0 <alloc_block_BF+0x152>
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 4f 45 80 00       	push   $0x80454f
  802891:	68 2c 01 00 00       	push   $0x12c
  802896:	68 6d 45 80 00       	push   $0x80456d
  80289b:	e8 82 db ff ff       	call   800422 <_panic>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 10                	je     8028b9 <alloc_block_BF+0x16b>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	8b 52 04             	mov    0x4(%edx),%edx
  8028b4:	89 50 04             	mov    %edx,0x4(%eax)
  8028b7:	eb 0b                	jmp    8028c4 <alloc_block_BF+0x176>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 0f                	je     8028dd <alloc_block_BF+0x18f>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d7:	8b 12                	mov    (%edx),%edx
  8028d9:	89 10                	mov    %edx,(%eax)
  8028db:	eb 0a                	jmp    8028e7 <alloc_block_BF+0x199>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ff:	48                   	dec    %eax
  802900:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802905:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802908:	e9 24 04 00 00       	jmp    802d31 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80290d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802910:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802913:	76 13                	jbe    802928 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802915:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80291c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80291f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802922:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802925:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802928:	a1 34 50 80 00       	mov    0x805034,%eax
  80292d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	74 07                	je     80293d <alloc_block_BF+0x1ef>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	eb 05                	jmp    802942 <alloc_block_BF+0x1f4>
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	a3 34 50 80 00       	mov    %eax,0x805034
  802947:	a1 34 50 80 00       	mov    0x805034,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 bf fe ff ff    	jne    802813 <alloc_block_BF+0xc5>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	0f 85 b5 fe ff ff    	jne    802813 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80295e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802962:	0f 84 26 02 00 00    	je     802b8e <alloc_block_BF+0x440>
  802968:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296c:	0f 85 1c 02 00 00    	jne    802b8e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	2b 45 08             	sub    0x8(%ebp),%eax
  802978:	83 e8 08             	sub    $0x8,%eax
  80297b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	8d 50 08             	lea    0x8(%eax),%edx
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	83 c0 08             	add    $0x8,%eax
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	6a 01                	push   $0x1
  802997:	50                   	push   %eax
  802998:	ff 75 f0             	pushl  -0x10(%ebp)
  80299b:	e8 c3 f8 ff ff       	call   802263 <set_block_data>
  8029a0:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	8b 40 04             	mov    0x4(%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	75 68                	jne    802a15 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029b1:	75 17                	jne    8029ca <alloc_block_BF+0x27c>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 88 45 80 00       	push   $0x804588
  8029bb:	68 45 01 00 00       	push   $0x145
  8029c0:	68 6d 45 80 00       	push   $0x80456d
  8029c5:	e8 58 da ff ff       	call   800422 <_panic>
  8029ca:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d3:	89 10                	mov    %edx,(%eax)
  8029d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 0d                	je     8029eb <alloc_block_BF+0x29d>
  8029de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029e3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e6:	89 50 04             	mov    %edx,0x4(%eax)
  8029e9:	eb 08                	jmp    8029f3 <alloc_block_BF+0x2a5>
  8029eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a05:	a1 38 50 80 00       	mov    0x805038,%eax
  802a0a:	40                   	inc    %eax
  802a0b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a10:	e9 dc 00 00 00       	jmp    802af1 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	75 65                	jne    802a83 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a1e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a22:	75 17                	jne    802a3b <alloc_block_BF+0x2ed>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 bc 45 80 00       	push   $0x8045bc
  802a2c:	68 4a 01 00 00       	push   $0x14a
  802a31:	68 6d 45 80 00       	push   $0x80456d
  802a36:	e8 e7 d9 ff ff       	call   800422 <_panic>
  802a3b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	74 0c                	je     802a5d <alloc_block_BF+0x30f>
  802a51:	a1 30 50 80 00       	mov    0x805030,%eax
  802a56:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	eb 08                	jmp    802a65 <alloc_block_BF+0x317>
  802a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a60:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a68:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a76:	a1 38 50 80 00       	mov    0x805038,%eax
  802a7b:	40                   	inc    %eax
  802a7c:	a3 38 50 80 00       	mov    %eax,0x805038
  802a81:	eb 6e                	jmp    802af1 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a87:	74 06                	je     802a8f <alloc_block_BF+0x341>
  802a89:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a8d:	75 17                	jne    802aa6 <alloc_block_BF+0x358>
  802a8f:	83 ec 04             	sub    $0x4,%esp
  802a92:	68 e0 45 80 00       	push   $0x8045e0
  802a97:	68 4f 01 00 00       	push   $0x14f
  802a9c:	68 6d 45 80 00       	push   $0x80456d
  802aa1:	e8 7c d9 ff ff       	call   800422 <_panic>
  802aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa9:	8b 10                	mov    (%eax),%edx
  802aab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 0b                	je     802ac4 <alloc_block_BF+0x376>
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	75 08                	jne    802ae6 <alloc_block_BF+0x398>
  802ade:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae6:	a1 38 50 80 00       	mov    0x805038,%eax
  802aeb:	40                   	inc    %eax
  802aec:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802af1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af5:	75 17                	jne    802b0e <alloc_block_BF+0x3c0>
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	68 4f 45 80 00       	push   $0x80454f
  802aff:	68 51 01 00 00       	push   $0x151
  802b04:	68 6d 45 80 00       	push   $0x80456d
  802b09:	e8 14 d9 ff ff       	call   800422 <_panic>
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 10                	je     802b27 <alloc_block_BF+0x3d9>
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1f:	8b 52 04             	mov    0x4(%edx),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	eb 0b                	jmp    802b32 <alloc_block_BF+0x3e4>
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 0f                	je     802b4b <alloc_block_BF+0x3fd>
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b45:	8b 12                	mov    (%edx),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	eb 0a                	jmp    802b55 <alloc_block_BF+0x407>
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b68:	a1 38 50 80 00       	mov    0x805038,%eax
  802b6d:	48                   	dec    %eax
  802b6e:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	6a 00                	push   $0x0
  802b78:	ff 75 d0             	pushl  -0x30(%ebp)
  802b7b:	ff 75 cc             	pushl  -0x34(%ebp)
  802b7e:	e8 e0 f6 ff ff       	call   802263 <set_block_data>
  802b83:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	e9 a3 01 00 00       	jmp    802d31 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b8e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b92:	0f 85 9d 00 00 00    	jne    802c35 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	6a 01                	push   $0x1
  802b9d:	ff 75 ec             	pushl  -0x14(%ebp)
  802ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ba3:	e8 bb f6 ff ff       	call   802263 <set_block_data>
  802ba8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802baf:	75 17                	jne    802bc8 <alloc_block_BF+0x47a>
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	68 4f 45 80 00       	push   $0x80454f
  802bb9:	68 58 01 00 00       	push   $0x158
  802bbe:	68 6d 45 80 00       	push   $0x80456d
  802bc3:	e8 5a d8 ff ff       	call   800422 <_panic>
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 10                	je     802be1 <alloc_block_BF+0x493>
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd9:	8b 52 04             	mov    0x4(%edx),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	eb 0b                	jmp    802bec <alloc_block_BF+0x49e>
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	74 0f                	je     802c05 <alloc_block_BF+0x4b7>
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bff:	8b 12                	mov    (%edx),%edx
  802c01:	89 10                	mov    %edx,(%eax)
  802c03:	eb 0a                	jmp    802c0f <alloc_block_BF+0x4c1>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 38 50 80 00       	mov    0x805038,%eax
  802c27:	48                   	dec    %eax
  802c28:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	e9 fc 00 00 00       	jmp    802d31 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	83 c0 08             	add    $0x8,%eax
  802c3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c3e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c45:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c4b:	01 d0                	add    %edx,%eax
  802c4d:	48                   	dec    %eax
  802c4e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c51:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c54:	ba 00 00 00 00       	mov    $0x0,%edx
  802c59:	f7 75 c4             	divl   -0x3c(%ebp)
  802c5c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c5f:	29 d0                	sub    %edx,%eax
  802c61:	c1 e8 0c             	shr    $0xc,%eax
  802c64:	83 ec 0c             	sub    $0xc,%esp
  802c67:	50                   	push   %eax
  802c68:	e8 0c e8 ff ff       	call   801479 <sbrk>
  802c6d:	83 c4 10             	add    $0x10,%esp
  802c70:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c73:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c77:	75 0a                	jne    802c83 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c79:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7e:	e9 ae 00 00 00       	jmp    802d31 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c83:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c8a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c90:	01 d0                	add    %edx,%eax
  802c92:	48                   	dec    %eax
  802c93:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c96:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c99:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9e:	f7 75 b8             	divl   -0x48(%ebp)
  802ca1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca4:	29 d0                	sub    %edx,%eax
  802ca6:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ca9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cb3:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cbe:	83 ec 0c             	sub    $0xc,%esp
  802cc1:	68 14 46 80 00       	push   $0x804614
  802cc6:	e8 14 da ff ff       	call   8006df <cprintf>
  802ccb:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cce:	83 ec 08             	sub    $0x8,%esp
  802cd1:	ff 75 bc             	pushl  -0x44(%ebp)
  802cd4:	68 19 46 80 00       	push   $0x804619
  802cd9:	e8 01 da ff ff       	call   8006df <cprintf>
  802cde:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ce1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ce8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ceb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cee:	01 d0                	add    %edx,%eax
  802cf0:	48                   	dec    %eax
  802cf1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cf4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfc:	f7 75 b0             	divl   -0x50(%ebp)
  802cff:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d02:	29 d0                	sub    %edx,%eax
  802d04:	83 ec 04             	sub    $0x4,%esp
  802d07:	6a 01                	push   $0x1
  802d09:	50                   	push   %eax
  802d0a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0d:	e8 51 f5 ff ff       	call   802263 <set_block_data>
  802d12:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d15:	83 ec 0c             	sub    $0xc,%esp
  802d18:	ff 75 bc             	pushl  -0x44(%ebp)
  802d1b:	e8 36 04 00 00       	call   803156 <free_block>
  802d20:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	ff 75 08             	pushl  0x8(%ebp)
  802d29:	e8 20 fa ff ff       	call   80274e <alloc_block_BF>
  802d2e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
  802d36:	53                   	push   %ebx
  802d37:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4c:	74 1e                	je     802d6c <merging+0x39>
  802d4e:	ff 75 08             	pushl  0x8(%ebp)
  802d51:	e8 bc f1 ff ff       	call   801f12 <get_block_size>
  802d56:	83 c4 04             	add    $0x4,%esp
  802d59:	89 c2                	mov    %eax,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d63:	75 07                	jne    802d6c <merging+0x39>
		prev_is_free = 1;
  802d65:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d70:	74 1e                	je     802d90 <merging+0x5d>
  802d72:	ff 75 10             	pushl  0x10(%ebp)
  802d75:	e8 98 f1 ff ff       	call   801f12 <get_block_size>
  802d7a:	83 c4 04             	add    $0x4,%esp
  802d7d:	89 c2                	mov    %eax,%edx
  802d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d82:	01 d0                	add    %edx,%eax
  802d84:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d87:	75 07                	jne    802d90 <merging+0x5d>
		next_is_free = 1;
  802d89:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d94:	0f 84 cc 00 00 00    	je     802e66 <merging+0x133>
  802d9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9e:	0f 84 c2 00 00 00    	je     802e66 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802da4:	ff 75 08             	pushl  0x8(%ebp)
  802da7:	e8 66 f1 ff ff       	call   801f12 <get_block_size>
  802dac:	83 c4 04             	add    $0x4,%esp
  802daf:	89 c3                	mov    %eax,%ebx
  802db1:	ff 75 10             	pushl  0x10(%ebp)
  802db4:	e8 59 f1 ff ff       	call   801f12 <get_block_size>
  802db9:	83 c4 04             	add    $0x4,%esp
  802dbc:	01 c3                	add    %eax,%ebx
  802dbe:	ff 75 0c             	pushl  0xc(%ebp)
  802dc1:	e8 4c f1 ff ff       	call   801f12 <get_block_size>
  802dc6:	83 c4 04             	add    $0x4,%esp
  802dc9:	01 d8                	add    %ebx,%eax
  802dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dce:	6a 00                	push   $0x0
  802dd0:	ff 75 ec             	pushl  -0x14(%ebp)
  802dd3:	ff 75 08             	pushl  0x8(%ebp)
  802dd6:	e8 88 f4 ff ff       	call   802263 <set_block_data>
  802ddb:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de2:	75 17                	jne    802dfb <merging+0xc8>
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 4f 45 80 00       	push   $0x80454f
  802dec:	68 7d 01 00 00       	push   $0x17d
  802df1:	68 6d 45 80 00       	push   $0x80456d
  802df6:	e8 27 d6 ff ff       	call   800422 <_panic>
  802dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 10                	je     802e14 <merging+0xe1>
  802e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0c:	8b 52 04             	mov    0x4(%edx),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 0b                	jmp    802e1f <merging+0xec>
  802e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0f                	je     802e38 <merging+0x105>
  802e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e32:	8b 12                	mov    (%edx),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 0a                	jmp    802e42 <merging+0x10f>
  802e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 38 50 80 00       	mov    0x805038,%eax
  802e5a:	48                   	dec    %eax
  802e5b:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e60:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e61:	e9 ea 02 00 00       	jmp    803150 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	74 3b                	je     802ea7 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e6c:	83 ec 0c             	sub    $0xc,%esp
  802e6f:	ff 75 08             	pushl  0x8(%ebp)
  802e72:	e8 9b f0 ff ff       	call   801f12 <get_block_size>
  802e77:	83 c4 10             	add    $0x10,%esp
  802e7a:	89 c3                	mov    %eax,%ebx
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	ff 75 10             	pushl  0x10(%ebp)
  802e82:	e8 8b f0 ff ff       	call   801f12 <get_block_size>
  802e87:	83 c4 10             	add    $0x10,%esp
  802e8a:	01 d8                	add    %ebx,%eax
  802e8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e8f:	83 ec 04             	sub    $0x4,%esp
  802e92:	6a 00                	push   $0x0
  802e94:	ff 75 e8             	pushl  -0x18(%ebp)
  802e97:	ff 75 08             	pushl  0x8(%ebp)
  802e9a:	e8 c4 f3 ff ff       	call   802263 <set_block_data>
  802e9f:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ea2:	e9 a9 02 00 00       	jmp    803150 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ea7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eab:	0f 84 2d 01 00 00    	je     802fde <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802eb1:	83 ec 0c             	sub    $0xc,%esp
  802eb4:	ff 75 10             	pushl  0x10(%ebp)
  802eb7:	e8 56 f0 ff ff       	call   801f12 <get_block_size>
  802ebc:	83 c4 10             	add    $0x10,%esp
  802ebf:	89 c3                	mov    %eax,%ebx
  802ec1:	83 ec 0c             	sub    $0xc,%esp
  802ec4:	ff 75 0c             	pushl  0xc(%ebp)
  802ec7:	e8 46 f0 ff ff       	call   801f12 <get_block_size>
  802ecc:	83 c4 10             	add    $0x10,%esp
  802ecf:	01 d8                	add    %ebx,%eax
  802ed1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	6a 00                	push   $0x0
  802ed9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802edc:	ff 75 10             	pushl  0x10(%ebp)
  802edf:	e8 7f f3 ff ff       	call   802263 <set_block_data>
  802ee4:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  802eea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802eed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef1:	74 06                	je     802ef9 <merging+0x1c6>
  802ef3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef7:	75 17                	jne    802f10 <merging+0x1dd>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 28 46 80 00       	push   $0x804628
  802f01:	68 8d 01 00 00       	push   $0x18d
  802f06:	68 6d 45 80 00       	push   $0x80456d
  802f0b:	e8 12 d5 ff ff       	call   800422 <_panic>
  802f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f13:	8b 50 04             	mov    0x4(%eax),%edx
  802f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0d                	je     802f3b <merging+0x208>
  802f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 08                	jmp    802f43 <merging+0x210>
  802f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	a1 38 50 80 00       	mov    0x805038,%eax
  802f51:	40                   	inc    %eax
  802f52:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5b:	75 17                	jne    802f74 <merging+0x241>
  802f5d:	83 ec 04             	sub    $0x4,%esp
  802f60:	68 4f 45 80 00       	push   $0x80454f
  802f65:	68 8e 01 00 00       	push   $0x18e
  802f6a:	68 6d 45 80 00       	push   $0x80456d
  802f6f:	e8 ae d4 ff ff       	call   800422 <_panic>
  802f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 10                	je     802f8d <merging+0x25a>
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f85:	8b 52 04             	mov    0x4(%edx),%edx
  802f88:	89 50 04             	mov    %edx,0x4(%eax)
  802f8b:	eb 0b                	jmp    802f98 <merging+0x265>
  802f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f90:	8b 40 04             	mov    0x4(%eax),%eax
  802f93:	a3 30 50 80 00       	mov    %eax,0x805030
  802f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9b:	8b 40 04             	mov    0x4(%eax),%eax
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	74 0f                	je     802fb1 <merging+0x27e>
  802fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fab:	8b 12                	mov    (%edx),%edx
  802fad:	89 10                	mov    %edx,(%eax)
  802faf:	eb 0a                	jmp    802fbb <merging+0x288>
  802fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fce:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd3:	48                   	dec    %eax
  802fd4:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fd9:	e9 72 01 00 00       	jmp    803150 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fde:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fe4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe8:	74 79                	je     803063 <merging+0x330>
  802fea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fee:	74 73                	je     803063 <merging+0x330>
  802ff0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff4:	74 06                	je     802ffc <merging+0x2c9>
  802ff6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ffa:	75 17                	jne    803013 <merging+0x2e0>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 e0 45 80 00       	push   $0x8045e0
  803004:	68 94 01 00 00       	push   $0x194
  803009:	68 6d 45 80 00       	push   $0x80456d
  80300e:	e8 0f d4 ff ff       	call   800422 <_panic>
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 10                	mov    (%eax),%edx
  803018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301b:	89 10                	mov    %edx,(%eax)
  80301d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0b                	je     803031 <merging+0x2fe>
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80302e:	89 50 04             	mov    %edx,0x4(%eax)
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803037:	89 10                	mov    %edx,(%eax)
  803039:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303c:	8b 55 08             	mov    0x8(%ebp),%edx
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	75 08                	jne    803053 <merging+0x320>
  80304b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304e:	a3 30 50 80 00       	mov    %eax,0x805030
  803053:	a1 38 50 80 00       	mov    0x805038,%eax
  803058:	40                   	inc    %eax
  803059:	a3 38 50 80 00       	mov    %eax,0x805038
  80305e:	e9 ce 00 00 00       	jmp    803131 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803067:	74 65                	je     8030ce <merging+0x39b>
  803069:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306d:	75 17                	jne    803086 <merging+0x353>
  80306f:	83 ec 04             	sub    $0x4,%esp
  803072:	68 bc 45 80 00       	push   $0x8045bc
  803077:	68 95 01 00 00       	push   $0x195
  80307c:	68 6d 45 80 00       	push   $0x80456d
  803081:	e8 9c d3 ff ff       	call   800422 <_panic>
  803086:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80308c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0c                	je     8030a8 <merging+0x375>
  80309c:	a1 30 50 80 00       	mov    0x805030,%eax
  8030a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a4:	89 10                	mov    %edx,(%eax)
  8030a6:	eb 08                	jmp    8030b0 <merging+0x37d>
  8030a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c6:	40                   	inc    %eax
  8030c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8030cc:	eb 63                	jmp    803131 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d2:	75 17                	jne    8030eb <merging+0x3b8>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 88 45 80 00       	push   $0x804588
  8030dc:	68 98 01 00 00       	push   $0x198
  8030e1:	68 6d 45 80 00       	push   $0x80456d
  8030e6:	e8 37 d3 ff ff       	call   800422 <_panic>
  8030eb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0d                	je     80310c <merging+0x3d9>
  8030ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803104:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	eb 08                	jmp    803114 <merging+0x3e1>
  80310c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310f:	a3 30 50 80 00       	mov    %eax,0x805030
  803114:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803117:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 38 50 80 00       	mov    0x805038,%eax
  80312b:	40                   	inc    %eax
  80312c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803131:	83 ec 0c             	sub    $0xc,%esp
  803134:	ff 75 10             	pushl  0x10(%ebp)
  803137:	e8 d6 ed ff ff       	call   801f12 <get_block_size>
  80313c:	83 c4 10             	add    $0x10,%esp
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	6a 00                	push   $0x0
  803144:	50                   	push   %eax
  803145:	ff 75 10             	pushl  0x10(%ebp)
  803148:	e8 16 f1 ff ff       	call   802263 <set_block_data>
  80314d:	83 c4 10             	add    $0x10,%esp
	}
}
  803150:	90                   	nop
  803151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80315c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803161:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803164:	a1 30 50 80 00       	mov    0x805030,%eax
  803169:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316c:	73 1b                	jae    803189 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80316e:	a1 30 50 80 00       	mov    0x805030,%eax
  803173:	83 ec 04             	sub    $0x4,%esp
  803176:	ff 75 08             	pushl  0x8(%ebp)
  803179:	6a 00                	push   $0x0
  80317b:	50                   	push   %eax
  80317c:	e8 b2 fb ff ff       	call   802d33 <merging>
  803181:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803184:	e9 8b 00 00 00       	jmp    803214 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803189:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80318e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803191:	76 18                	jbe    8031ab <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803193:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	ff 75 08             	pushl  0x8(%ebp)
  80319e:	50                   	push   %eax
  80319f:	6a 00                	push   $0x0
  8031a1:	e8 8d fb ff ff       	call   802d33 <merging>
  8031a6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031a9:	eb 69                	jmp    803214 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b3:	eb 39                	jmp    8031ee <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031bb:	73 29                	jae    8031e6 <free_block+0x90>
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c5:	76 1f                	jbe    8031e6 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031cf:	83 ec 04             	sub    $0x4,%esp
  8031d2:	ff 75 08             	pushl  0x8(%ebp)
  8031d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8031d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8031db:	e8 53 fb ff ff       	call   802d33 <merging>
  8031e0:	83 c4 10             	add    $0x10,%esp
			break;
  8031e3:	90                   	nop
		}
	}
}
  8031e4:	eb 2e                	jmp    803214 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8031eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f2:	74 07                	je     8031fb <free_block+0xa5>
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	eb 05                	jmp    803200 <free_block+0xaa>
  8031fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803200:	a3 34 50 80 00       	mov    %eax,0x805034
  803205:	a1 34 50 80 00       	mov    0x805034,%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	75 a7                	jne    8031b5 <free_block+0x5f>
  80320e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803212:	75 a1                	jne    8031b5 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803214:	90                   	nop
  803215:	c9                   	leave  
  803216:	c3                   	ret    

00803217 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803217:	55                   	push   %ebp
  803218:	89 e5                	mov    %esp,%ebp
  80321a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80321d:	ff 75 08             	pushl  0x8(%ebp)
  803220:	e8 ed ec ff ff       	call   801f12 <get_block_size>
  803225:	83 c4 04             	add    $0x4,%esp
  803228:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80322b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803232:	eb 17                	jmp    80324b <copy_data+0x34>
  803234:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323a:	01 c2                	add    %eax,%edx
  80323c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	01 c8                	add    %ecx,%eax
  803244:	8a 00                	mov    (%eax),%al
  803246:	88 02                	mov    %al,(%edx)
  803248:	ff 45 fc             	incl   -0x4(%ebp)
  80324b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80324e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803251:	72 e1                	jb     803234 <copy_data+0x1d>
}
  803253:	90                   	nop
  803254:	c9                   	leave  
  803255:	c3                   	ret    

00803256 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
  803259:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80325c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803260:	75 23                	jne    803285 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803262:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803266:	74 13                	je     80327b <realloc_block_FF+0x25>
  803268:	83 ec 0c             	sub    $0xc,%esp
  80326b:	ff 75 0c             	pushl  0xc(%ebp)
  80326e:	e8 1f f0 ff ff       	call   802292 <alloc_block_FF>
  803273:	83 c4 10             	add    $0x10,%esp
  803276:	e9 f4 06 00 00       	jmp    80396f <realloc_block_FF+0x719>
		return NULL;
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	e9 ea 06 00 00       	jmp    80396f <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803285:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803289:	75 18                	jne    8032a3 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80328b:	83 ec 0c             	sub    $0xc,%esp
  80328e:	ff 75 08             	pushl  0x8(%ebp)
  803291:	e8 c0 fe ff ff       	call   803156 <free_block>
  803296:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803299:	b8 00 00 00 00       	mov    $0x0,%eax
  80329e:	e9 cc 06 00 00       	jmp    80396f <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032a3:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032a7:	77 07                	ja     8032b0 <realloc_block_FF+0x5a>
  8032a9:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b3:	83 e0 01             	and    $0x1,%eax
  8032b6:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bc:	83 c0 08             	add    $0x8,%eax
  8032bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032c2:	83 ec 0c             	sub    $0xc,%esp
  8032c5:	ff 75 08             	pushl  0x8(%ebp)
  8032c8:	e8 45 ec ff ff       	call   801f12 <get_block_size>
  8032cd:	83 c4 10             	add    $0x10,%esp
  8032d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d6:	83 e8 08             	sub    $0x8,%eax
  8032d9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	83 e8 04             	sub    $0x4,%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	83 e0 fe             	and    $0xfffffffe,%eax
  8032e7:	89 c2                	mov    %eax,%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032f1:	83 ec 0c             	sub    $0xc,%esp
  8032f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f7:	e8 16 ec ff ff       	call   801f12 <get_block_size>
  8032fc:	83 c4 10             	add    $0x10,%esp
  8032ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803305:	83 e8 08             	sub    $0x8,%eax
  803308:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803311:	75 08                	jne    80331b <realloc_block_FF+0xc5>
	{
		 return va;
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	e9 54 06 00 00       	jmp    80396f <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80331b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803321:	0f 83 e5 03 00 00    	jae    80370c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80332d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803330:	83 ec 0c             	sub    $0xc,%esp
  803333:	ff 75 e4             	pushl  -0x1c(%ebp)
  803336:	e8 f0 eb ff ff       	call   801f2b <is_free_block>
  80333b:	83 c4 10             	add    $0x10,%esp
  80333e:	84 c0                	test   %al,%al
  803340:	0f 84 3b 01 00 00    	je     803481 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803346:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803349:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80334c:	01 d0                	add    %edx,%eax
  80334e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	6a 01                	push   $0x1
  803356:	ff 75 f0             	pushl  -0x10(%ebp)
  803359:	ff 75 08             	pushl  0x8(%ebp)
  80335c:	e8 02 ef ff ff       	call   802263 <set_block_data>
  803361:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	83 e8 04             	sub    $0x4,%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	83 e0 fe             	and    $0xfffffffe,%eax
  80336f:	89 c2                	mov    %eax,%edx
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	01 d0                	add    %edx,%eax
  803376:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	6a 00                	push   $0x0
  80337e:	ff 75 cc             	pushl  -0x34(%ebp)
  803381:	ff 75 c8             	pushl  -0x38(%ebp)
  803384:	e8 da ee ff ff       	call   802263 <set_block_data>
  803389:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80338c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803390:	74 06                	je     803398 <realloc_block_FF+0x142>
  803392:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803396:	75 17                	jne    8033af <realloc_block_FF+0x159>
  803398:	83 ec 04             	sub    $0x4,%esp
  80339b:	68 e0 45 80 00       	push   $0x8045e0
  8033a0:	68 f6 01 00 00       	push   $0x1f6
  8033a5:	68 6d 45 80 00       	push   $0x80456d
  8033aa:	e8 73 d0 ff ff       	call   800422 <_panic>
  8033af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b2:	8b 10                	mov    (%eax),%edx
  8033b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b7:	89 10                	mov    %edx,(%eax)
  8033b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0b                	je     8033cd <realloc_block_FF+0x177>
  8033c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c5:	8b 00                	mov    (%eax),%eax
  8033c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033ca:	89 50 04             	mov    %edx,0x4(%eax)
  8033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d3:	89 10                	mov    %edx,(%eax)
  8033d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033db:	89 50 04             	mov    %edx,0x4(%eax)
  8033de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	85 c0                	test   %eax,%eax
  8033e5:	75 08                	jne    8033ef <realloc_block_FF+0x199>
  8033e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f4:	40                   	inc    %eax
  8033f5:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fe:	75 17                	jne    803417 <realloc_block_FF+0x1c1>
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	68 4f 45 80 00       	push   $0x80454f
  803408:	68 f7 01 00 00       	push   $0x1f7
  80340d:	68 6d 45 80 00       	push   $0x80456d
  803412:	e8 0b d0 ff ff       	call   800422 <_panic>
  803417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 10                	je     803430 <realloc_block_FF+0x1da>
  803420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803428:	8b 52 04             	mov    0x4(%edx),%edx
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	eb 0b                	jmp    80343b <realloc_block_FF+0x1e5>
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	a3 30 50 80 00       	mov    %eax,0x805030
  80343b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343e:	8b 40 04             	mov    0x4(%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	74 0f                	je     803454 <realloc_block_FF+0x1fe>
  803445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344e:	8b 12                	mov    (%edx),%edx
  803450:	89 10                	mov    %edx,(%eax)
  803452:	eb 0a                	jmp    80345e <realloc_block_FF+0x208>
  803454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803471:	a1 38 50 80 00       	mov    0x805038,%eax
  803476:	48                   	dec    %eax
  803477:	a3 38 50 80 00       	mov    %eax,0x805038
  80347c:	e9 83 02 00 00       	jmp    803704 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803481:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803485:	0f 86 69 02 00 00    	jbe    8036f4 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80348b:	83 ec 04             	sub    $0x4,%esp
  80348e:	6a 01                	push   $0x1
  803490:	ff 75 f0             	pushl  -0x10(%ebp)
  803493:	ff 75 08             	pushl  0x8(%ebp)
  803496:	e8 c8 ed ff ff       	call   802263 <set_block_data>
  80349b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	83 e8 04             	sub    $0x4,%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8034a9:	89 c2                	mov    %eax,%edx
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	01 d0                	add    %edx,%eax
  8034b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034bf:	75 68                	jne    803529 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c5:	75 17                	jne    8034de <realloc_block_FF+0x288>
  8034c7:	83 ec 04             	sub    $0x4,%esp
  8034ca:	68 88 45 80 00       	push   $0x804588
  8034cf:	68 06 02 00 00       	push   $0x206
  8034d4:	68 6d 45 80 00       	push   $0x80456d
  8034d9:	e8 44 cf ff ff       	call   800422 <_panic>
  8034de:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e7:	89 10                	mov    %edx,(%eax)
  8034e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 0d                	je     8034ff <realloc_block_FF+0x2a9>
  8034f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fa:	89 50 04             	mov    %edx,0x4(%eax)
  8034fd:	eb 08                	jmp    803507 <realloc_block_FF+0x2b1>
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	a3 30 50 80 00       	mov    %eax,0x805030
  803507:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80350f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803519:	a1 38 50 80 00       	mov    0x805038,%eax
  80351e:	40                   	inc    %eax
  80351f:	a3 38 50 80 00       	mov    %eax,0x805038
  803524:	e9 b0 01 00 00       	jmp    8036d9 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803529:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803531:	76 68                	jbe    80359b <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803533:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803537:	75 17                	jne    803550 <realloc_block_FF+0x2fa>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 88 45 80 00       	push   $0x804588
  803541:	68 0b 02 00 00       	push   $0x20b
  803546:	68 6d 45 80 00       	push   $0x80456d
  80354b:	e8 d2 ce ff ff       	call   800422 <_panic>
  803550:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <realloc_block_FF+0x31b>
  803564:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803569:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	eb 08                	jmp    803579 <realloc_block_FF+0x323>
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	a3 30 50 80 00       	mov    %eax,0x805030
  803579:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803584:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358b:	a1 38 50 80 00       	mov    0x805038,%eax
  803590:	40                   	inc    %eax
  803591:	a3 38 50 80 00       	mov    %eax,0x805038
  803596:	e9 3e 01 00 00       	jmp    8036d9 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80359b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035a3:	73 68                	jae    80360d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a9:	75 17                	jne    8035c2 <realloc_block_FF+0x36c>
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	68 bc 45 80 00       	push   $0x8045bc
  8035b3:	68 10 02 00 00       	push   $0x210
  8035b8:	68 6d 45 80 00       	push   $0x80456d
  8035bd:	e8 60 ce ff ff       	call   800422 <_panic>
  8035c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cb:	89 50 04             	mov    %edx,0x4(%eax)
  8035ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d1:	8b 40 04             	mov    0x4(%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 0c                	je     8035e4 <realloc_block_FF+0x38e>
  8035d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8035dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035e0:	89 10                	mov    %edx,(%eax)
  8035e2:	eb 08                	jmp    8035ec <realloc_block_FF+0x396>
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803602:	40                   	inc    %eax
  803603:	a3 38 50 80 00       	mov    %eax,0x805038
  803608:	e9 cc 00 00 00       	jmp    8036d9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80360d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803614:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80361c:	e9 8a 00 00 00       	jmp    8036ab <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803627:	73 7a                	jae    8036a3 <realloc_block_FF+0x44d>
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803631:	73 70                	jae    8036a3 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803637:	74 06                	je     80363f <realloc_block_FF+0x3e9>
  803639:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80363d:	75 17                	jne    803656 <realloc_block_FF+0x400>
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	68 e0 45 80 00       	push   $0x8045e0
  803647:	68 1a 02 00 00       	push   $0x21a
  80364c:	68 6d 45 80 00       	push   $0x80456d
  803651:	e8 cc cd ff ff       	call   800422 <_panic>
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 10                	mov    (%eax),%edx
  80365b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365e:	89 10                	mov    %edx,(%eax)
  803660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	85 c0                	test   %eax,%eax
  803667:	74 0b                	je     803674 <realloc_block_FF+0x41e>
  803669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803671:	89 50 04             	mov    %edx,0x4(%eax)
  803674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803677:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	75 08                	jne    803696 <realloc_block_FF+0x440>
  80368e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803691:	a3 30 50 80 00       	mov    %eax,0x805030
  803696:	a1 38 50 80 00       	mov    0x805038,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036a1:	eb 36                	jmp    8036d9 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036a3:	a1 34 50 80 00       	mov    0x805034,%eax
  8036a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036af:	74 07                	je     8036b8 <realloc_block_FF+0x462>
  8036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	eb 05                	jmp    8036bd <realloc_block_FF+0x467>
  8036b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	0f 85 52 ff ff ff    	jne    803621 <realloc_block_FF+0x3cb>
  8036cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d3:	0f 85 48 ff ff ff    	jne    803621 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	6a 00                	push   $0x0
  8036de:	ff 75 d8             	pushl  -0x28(%ebp)
  8036e1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036e4:	e8 7a eb ff ff       	call   802263 <set_block_data>
  8036e9:	83 c4 10             	add    $0x10,%esp
				return va;
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	e9 7b 02 00 00       	jmp    80396f <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036f4:	83 ec 0c             	sub    $0xc,%esp
  8036f7:	68 5d 46 80 00       	push   $0x80465d
  8036fc:	e8 de cf ff ff       	call   8006df <cprintf>
  803701:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	e9 63 02 00 00       	jmp    80396f <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803712:	0f 86 4d 02 00 00    	jbe    803965 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803718:	83 ec 0c             	sub    $0xc,%esp
  80371b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80371e:	e8 08 e8 ff ff       	call   801f2b <is_free_block>
  803723:	83 c4 10             	add    $0x10,%esp
  803726:	84 c0                	test   %al,%al
  803728:	0f 84 37 02 00 00    	je     803965 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80372e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803731:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803734:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803737:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80373a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80373d:	76 38                	jbe    803777 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80373f:	83 ec 0c             	sub    $0xc,%esp
  803742:	ff 75 08             	pushl  0x8(%ebp)
  803745:	e8 0c fa ff ff       	call   803156 <free_block>
  80374a:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80374d:	83 ec 0c             	sub    $0xc,%esp
  803750:	ff 75 0c             	pushl  0xc(%ebp)
  803753:	e8 3a eb ff ff       	call   802292 <alloc_block_FF>
  803758:	83 c4 10             	add    $0x10,%esp
  80375b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80375e:	83 ec 08             	sub    $0x8,%esp
  803761:	ff 75 c0             	pushl  -0x40(%ebp)
  803764:	ff 75 08             	pushl  0x8(%ebp)
  803767:	e8 ab fa ff ff       	call   803217 <copy_data>
  80376c:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80376f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803772:	e9 f8 01 00 00       	jmp    80396f <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80377a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80377d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803780:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803784:	0f 87 a0 00 00 00    	ja     80382a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80378a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80378e:	75 17                	jne    8037a7 <realloc_block_FF+0x551>
  803790:	83 ec 04             	sub    $0x4,%esp
  803793:	68 4f 45 80 00       	push   $0x80454f
  803798:	68 38 02 00 00       	push   $0x238
  80379d:	68 6d 45 80 00       	push   $0x80456d
  8037a2:	e8 7b cc ff ff       	call   800422 <_panic>
  8037a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	74 10                	je     8037c0 <realloc_block_FF+0x56a>
  8037b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b8:	8b 52 04             	mov    0x4(%edx),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	eb 0b                	jmp    8037cb <realloc_block_FF+0x575>
  8037c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c3:	8b 40 04             	mov    0x4(%eax),%eax
  8037c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ce:	8b 40 04             	mov    0x4(%eax),%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	74 0f                	je     8037e4 <realloc_block_FF+0x58e>
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	8b 40 04             	mov    0x4(%eax),%eax
  8037db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037de:	8b 12                	mov    (%edx),%edx
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	eb 0a                	jmp    8037ee <realloc_block_FF+0x598>
  8037e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803801:	a1 38 50 80 00       	mov    0x805038,%eax
  803806:	48                   	dec    %eax
  803807:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80380c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80380f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803812:	01 d0                	add    %edx,%eax
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	6a 01                	push   $0x1
  803819:	50                   	push   %eax
  80381a:	ff 75 08             	pushl  0x8(%ebp)
  80381d:	e8 41 ea ff ff       	call   802263 <set_block_data>
  803822:	83 c4 10             	add    $0x10,%esp
  803825:	e9 36 01 00 00       	jmp    803960 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80382a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803830:	01 d0                	add    %edx,%eax
  803832:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803835:	83 ec 04             	sub    $0x4,%esp
  803838:	6a 01                	push   $0x1
  80383a:	ff 75 f0             	pushl  -0x10(%ebp)
  80383d:	ff 75 08             	pushl  0x8(%ebp)
  803840:	e8 1e ea ff ff       	call   802263 <set_block_data>
  803845:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	83 e8 04             	sub    $0x4,%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	83 e0 fe             	and    $0xfffffffe,%eax
  803853:	89 c2                	mov    %eax,%edx
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	01 d0                	add    %edx,%eax
  80385a:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80385d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803861:	74 06                	je     803869 <realloc_block_FF+0x613>
  803863:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803867:	75 17                	jne    803880 <realloc_block_FF+0x62a>
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 e0 45 80 00       	push   $0x8045e0
  803871:	68 44 02 00 00       	push   $0x244
  803876:	68 6d 45 80 00       	push   $0x80456d
  80387b:	e8 a2 cb ff ff       	call   800422 <_panic>
  803880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803883:	8b 10                	mov    (%eax),%edx
  803885:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803888:	89 10                	mov    %edx,(%eax)
  80388a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 0b                	je     80389e <realloc_block_FF+0x648>
  803893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803896:	8b 00                	mov    (%eax),%eax
  803898:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80389b:	89 50 04             	mov    %edx,0x4(%eax)
  80389e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038a4:	89 10                	mov    %edx,(%eax)
  8038a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ac:	89 50 04             	mov    %edx,0x4(%eax)
  8038af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	75 08                	jne    8038c0 <realloc_block_FF+0x66a>
  8038b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c5:	40                   	inc    %eax
  8038c6:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038cf:	75 17                	jne    8038e8 <realloc_block_FF+0x692>
  8038d1:	83 ec 04             	sub    $0x4,%esp
  8038d4:	68 4f 45 80 00       	push   $0x80454f
  8038d9:	68 45 02 00 00       	push   $0x245
  8038de:	68 6d 45 80 00       	push   $0x80456d
  8038e3:	e8 3a cb ff ff       	call   800422 <_panic>
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	74 10                	je     803901 <realloc_block_FF+0x6ab>
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 00                	mov    (%eax),%eax
  8038f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f9:	8b 52 04             	mov    0x4(%edx),%edx
  8038fc:	89 50 04             	mov    %edx,0x4(%eax)
  8038ff:	eb 0b                	jmp    80390c <realloc_block_FF+0x6b6>
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	a3 30 50 80 00       	mov    %eax,0x805030
  80390c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390f:	8b 40 04             	mov    0x4(%eax),%eax
  803912:	85 c0                	test   %eax,%eax
  803914:	74 0f                	je     803925 <realloc_block_FF+0x6cf>
  803916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803919:	8b 40 04             	mov    0x4(%eax),%eax
  80391c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391f:	8b 12                	mov    (%edx),%edx
  803921:	89 10                	mov    %edx,(%eax)
  803923:	eb 0a                	jmp    80392f <realloc_block_FF+0x6d9>
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	8b 00                	mov    (%eax),%eax
  80392a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803942:	a1 38 50 80 00       	mov    0x805038,%eax
  803947:	48                   	dec    %eax
  803948:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80394d:	83 ec 04             	sub    $0x4,%esp
  803950:	6a 00                	push   $0x0
  803952:	ff 75 bc             	pushl  -0x44(%ebp)
  803955:	ff 75 b8             	pushl  -0x48(%ebp)
  803958:	e8 06 e9 ff ff       	call   802263 <set_block_data>
  80395d:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	eb 0a                	jmp    80396f <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803965:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80396f:	c9                   	leave  
  803970:	c3                   	ret    

00803971 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803971:	55                   	push   %ebp
  803972:	89 e5                	mov    %esp,%ebp
  803974:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803977:	83 ec 04             	sub    $0x4,%esp
  80397a:	68 64 46 80 00       	push   $0x804664
  80397f:	68 58 02 00 00       	push   $0x258
  803984:	68 6d 45 80 00       	push   $0x80456d
  803989:	e8 94 ca ff ff       	call   800422 <_panic>

0080398e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80398e:	55                   	push   %ebp
  80398f:	89 e5                	mov    %esp,%ebp
  803991:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 8c 46 80 00       	push   $0x80468c
  80399c:	68 61 02 00 00       	push   $0x261
  8039a1:	68 6d 45 80 00       	push   $0x80456d
  8039a6:	e8 77 ca ff ff       	call   800422 <_panic>
  8039ab:	90                   	nop

008039ac <__udivdi3>:
  8039ac:	55                   	push   %ebp
  8039ad:	57                   	push   %edi
  8039ae:	56                   	push   %esi
  8039af:	53                   	push   %ebx
  8039b0:	83 ec 1c             	sub    $0x1c,%esp
  8039b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039c3:	89 ca                	mov    %ecx,%edx
  8039c5:	89 f8                	mov    %edi,%eax
  8039c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039cb:	85 f6                	test   %esi,%esi
  8039cd:	75 2d                	jne    8039fc <__udivdi3+0x50>
  8039cf:	39 cf                	cmp    %ecx,%edi
  8039d1:	77 65                	ja     803a38 <__udivdi3+0x8c>
  8039d3:	89 fd                	mov    %edi,%ebp
  8039d5:	85 ff                	test   %edi,%edi
  8039d7:	75 0b                	jne    8039e4 <__udivdi3+0x38>
  8039d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039de:	31 d2                	xor    %edx,%edx
  8039e0:	f7 f7                	div    %edi
  8039e2:	89 c5                	mov    %eax,%ebp
  8039e4:	31 d2                	xor    %edx,%edx
  8039e6:	89 c8                	mov    %ecx,%eax
  8039e8:	f7 f5                	div    %ebp
  8039ea:	89 c1                	mov    %eax,%ecx
  8039ec:	89 d8                	mov    %ebx,%eax
  8039ee:	f7 f5                	div    %ebp
  8039f0:	89 cf                	mov    %ecx,%edi
  8039f2:	89 fa                	mov    %edi,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	39 ce                	cmp    %ecx,%esi
  8039fe:	77 28                	ja     803a28 <__udivdi3+0x7c>
  803a00:	0f bd fe             	bsr    %esi,%edi
  803a03:	83 f7 1f             	xor    $0x1f,%edi
  803a06:	75 40                	jne    803a48 <__udivdi3+0x9c>
  803a08:	39 ce                	cmp    %ecx,%esi
  803a0a:	72 0a                	jb     803a16 <__udivdi3+0x6a>
  803a0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a10:	0f 87 9e 00 00 00    	ja     803ab4 <__udivdi3+0x108>
  803a16:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1b:	89 fa                	mov    %edi,%edx
  803a1d:	83 c4 1c             	add    $0x1c,%esp
  803a20:	5b                   	pop    %ebx
  803a21:	5e                   	pop    %esi
  803a22:	5f                   	pop    %edi
  803a23:	5d                   	pop    %ebp
  803a24:	c3                   	ret    
  803a25:	8d 76 00             	lea    0x0(%esi),%esi
  803a28:	31 ff                	xor    %edi,%edi
  803a2a:	31 c0                	xor    %eax,%eax
  803a2c:	89 fa                	mov    %edi,%edx
  803a2e:	83 c4 1c             	add    $0x1c,%esp
  803a31:	5b                   	pop    %ebx
  803a32:	5e                   	pop    %esi
  803a33:	5f                   	pop    %edi
  803a34:	5d                   	pop    %ebp
  803a35:	c3                   	ret    
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	89 d8                	mov    %ebx,%eax
  803a3a:	f7 f7                	div    %edi
  803a3c:	31 ff                	xor    %edi,%edi
  803a3e:	89 fa                	mov    %edi,%edx
  803a40:	83 c4 1c             	add    $0x1c,%esp
  803a43:	5b                   	pop    %ebx
  803a44:	5e                   	pop    %esi
  803a45:	5f                   	pop    %edi
  803a46:	5d                   	pop    %ebp
  803a47:	c3                   	ret    
  803a48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a4d:	89 eb                	mov    %ebp,%ebx
  803a4f:	29 fb                	sub    %edi,%ebx
  803a51:	89 f9                	mov    %edi,%ecx
  803a53:	d3 e6                	shl    %cl,%esi
  803a55:	89 c5                	mov    %eax,%ebp
  803a57:	88 d9                	mov    %bl,%cl
  803a59:	d3 ed                	shr    %cl,%ebp
  803a5b:	89 e9                	mov    %ebp,%ecx
  803a5d:	09 f1                	or     %esi,%ecx
  803a5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a63:	89 f9                	mov    %edi,%ecx
  803a65:	d3 e0                	shl    %cl,%eax
  803a67:	89 c5                	mov    %eax,%ebp
  803a69:	89 d6                	mov    %edx,%esi
  803a6b:	88 d9                	mov    %bl,%cl
  803a6d:	d3 ee                	shr    %cl,%esi
  803a6f:	89 f9                	mov    %edi,%ecx
  803a71:	d3 e2                	shl    %cl,%edx
  803a73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a77:	88 d9                	mov    %bl,%cl
  803a79:	d3 e8                	shr    %cl,%eax
  803a7b:	09 c2                	or     %eax,%edx
  803a7d:	89 d0                	mov    %edx,%eax
  803a7f:	89 f2                	mov    %esi,%edx
  803a81:	f7 74 24 0c          	divl   0xc(%esp)
  803a85:	89 d6                	mov    %edx,%esi
  803a87:	89 c3                	mov    %eax,%ebx
  803a89:	f7 e5                	mul    %ebp
  803a8b:	39 d6                	cmp    %edx,%esi
  803a8d:	72 19                	jb     803aa8 <__udivdi3+0xfc>
  803a8f:	74 0b                	je     803a9c <__udivdi3+0xf0>
  803a91:	89 d8                	mov    %ebx,%eax
  803a93:	31 ff                	xor    %edi,%edi
  803a95:	e9 58 ff ff ff       	jmp    8039f2 <__udivdi3+0x46>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa0:	89 f9                	mov    %edi,%ecx
  803aa2:	d3 e2                	shl    %cl,%edx
  803aa4:	39 c2                	cmp    %eax,%edx
  803aa6:	73 e9                	jae    803a91 <__udivdi3+0xe5>
  803aa8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aab:	31 ff                	xor    %edi,%edi
  803aad:	e9 40 ff ff ff       	jmp    8039f2 <__udivdi3+0x46>
  803ab2:	66 90                	xchg   %ax,%ax
  803ab4:	31 c0                	xor    %eax,%eax
  803ab6:	e9 37 ff ff ff       	jmp    8039f2 <__udivdi3+0x46>
  803abb:	90                   	nop

00803abc <__umoddi3>:
  803abc:	55                   	push   %ebp
  803abd:	57                   	push   %edi
  803abe:	56                   	push   %esi
  803abf:	53                   	push   %ebx
  803ac0:	83 ec 1c             	sub    $0x1c,%esp
  803ac3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ac7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803acf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ad3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ad7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803adb:	89 f3                	mov    %esi,%ebx
  803add:	89 fa                	mov    %edi,%edx
  803adf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae3:	89 34 24             	mov    %esi,(%esp)
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	75 1a                	jne    803b04 <__umoddi3+0x48>
  803aea:	39 f7                	cmp    %esi,%edi
  803aec:	0f 86 a2 00 00 00    	jbe    803b94 <__umoddi3+0xd8>
  803af2:	89 c8                	mov    %ecx,%eax
  803af4:	89 f2                	mov    %esi,%edx
  803af6:	f7 f7                	div    %edi
  803af8:	89 d0                	mov    %edx,%eax
  803afa:	31 d2                	xor    %edx,%edx
  803afc:	83 c4 1c             	add    $0x1c,%esp
  803aff:	5b                   	pop    %ebx
  803b00:	5e                   	pop    %esi
  803b01:	5f                   	pop    %edi
  803b02:	5d                   	pop    %ebp
  803b03:	c3                   	ret    
  803b04:	39 f0                	cmp    %esi,%eax
  803b06:	0f 87 ac 00 00 00    	ja     803bb8 <__umoddi3+0xfc>
  803b0c:	0f bd e8             	bsr    %eax,%ebp
  803b0f:	83 f5 1f             	xor    $0x1f,%ebp
  803b12:	0f 84 ac 00 00 00    	je     803bc4 <__umoddi3+0x108>
  803b18:	bf 20 00 00 00       	mov    $0x20,%edi
  803b1d:	29 ef                	sub    %ebp,%edi
  803b1f:	89 fe                	mov    %edi,%esi
  803b21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b25:	89 e9                	mov    %ebp,%ecx
  803b27:	d3 e0                	shl    %cl,%eax
  803b29:	89 d7                	mov    %edx,%edi
  803b2b:	89 f1                	mov    %esi,%ecx
  803b2d:	d3 ef                	shr    %cl,%edi
  803b2f:	09 c7                	or     %eax,%edi
  803b31:	89 e9                	mov    %ebp,%ecx
  803b33:	d3 e2                	shl    %cl,%edx
  803b35:	89 14 24             	mov    %edx,(%esp)
  803b38:	89 d8                	mov    %ebx,%eax
  803b3a:	d3 e0                	shl    %cl,%eax
  803b3c:	89 c2                	mov    %eax,%edx
  803b3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b42:	d3 e0                	shl    %cl,%eax
  803b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4c:	89 f1                	mov    %esi,%ecx
  803b4e:	d3 e8                	shr    %cl,%eax
  803b50:	09 d0                	or     %edx,%eax
  803b52:	d3 eb                	shr    %cl,%ebx
  803b54:	89 da                	mov    %ebx,%edx
  803b56:	f7 f7                	div    %edi
  803b58:	89 d3                	mov    %edx,%ebx
  803b5a:	f7 24 24             	mull   (%esp)
  803b5d:	89 c6                	mov    %eax,%esi
  803b5f:	89 d1                	mov    %edx,%ecx
  803b61:	39 d3                	cmp    %edx,%ebx
  803b63:	0f 82 87 00 00 00    	jb     803bf0 <__umoddi3+0x134>
  803b69:	0f 84 91 00 00 00    	je     803c00 <__umoddi3+0x144>
  803b6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b73:	29 f2                	sub    %esi,%edx
  803b75:	19 cb                	sbb    %ecx,%ebx
  803b77:	89 d8                	mov    %ebx,%eax
  803b79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b7d:	d3 e0                	shl    %cl,%eax
  803b7f:	89 e9                	mov    %ebp,%ecx
  803b81:	d3 ea                	shr    %cl,%edx
  803b83:	09 d0                	or     %edx,%eax
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 eb                	shr    %cl,%ebx
  803b89:	89 da                	mov    %ebx,%edx
  803b8b:	83 c4 1c             	add    $0x1c,%esp
  803b8e:	5b                   	pop    %ebx
  803b8f:	5e                   	pop    %esi
  803b90:	5f                   	pop    %edi
  803b91:	5d                   	pop    %ebp
  803b92:	c3                   	ret    
  803b93:	90                   	nop
  803b94:	89 fd                	mov    %edi,%ebp
  803b96:	85 ff                	test   %edi,%edi
  803b98:	75 0b                	jne    803ba5 <__umoddi3+0xe9>
  803b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9f:	31 d2                	xor    %edx,%edx
  803ba1:	f7 f7                	div    %edi
  803ba3:	89 c5                	mov    %eax,%ebp
  803ba5:	89 f0                	mov    %esi,%eax
  803ba7:	31 d2                	xor    %edx,%edx
  803ba9:	f7 f5                	div    %ebp
  803bab:	89 c8                	mov    %ecx,%eax
  803bad:	f7 f5                	div    %ebp
  803baf:	89 d0                	mov    %edx,%eax
  803bb1:	e9 44 ff ff ff       	jmp    803afa <__umoddi3+0x3e>
  803bb6:	66 90                	xchg   %ax,%ax
  803bb8:	89 c8                	mov    %ecx,%eax
  803bba:	89 f2                	mov    %esi,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	3b 04 24             	cmp    (%esp),%eax
  803bc7:	72 06                	jb     803bcf <__umoddi3+0x113>
  803bc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bcd:	77 0f                	ja     803bde <__umoddi3+0x122>
  803bcf:	89 f2                	mov    %esi,%edx
  803bd1:	29 f9                	sub    %edi,%ecx
  803bd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bd7:	89 14 24             	mov    %edx,(%esp)
  803bda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bde:	8b 44 24 04          	mov    0x4(%esp),%eax
  803be2:	8b 14 24             	mov    (%esp),%edx
  803be5:	83 c4 1c             	add    $0x1c,%esp
  803be8:	5b                   	pop    %ebx
  803be9:	5e                   	pop    %esi
  803bea:	5f                   	pop    %edi
  803beb:	5d                   	pop    %ebp
  803bec:	c3                   	ret    
  803bed:	8d 76 00             	lea    0x0(%esi),%esi
  803bf0:	2b 04 24             	sub    (%esp),%eax
  803bf3:	19 fa                	sbb    %edi,%edx
  803bf5:	89 d1                	mov    %edx,%ecx
  803bf7:	89 c6                	mov    %eax,%esi
  803bf9:	e9 71 ff ff ff       	jmp    803b6f <__umoddi3+0xb3>
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c04:	72 ea                	jb     803bf0 <__umoddi3+0x134>
  803c06:	89 d9                	mov    %ebx,%ecx
  803c08:	e9 62 ff ff ff       	jmp    803b6f <__umoddi3+0xb3>
