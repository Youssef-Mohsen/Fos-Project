
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
  8000bc:	e8 a0 19 00 00       	call   801a61 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 e3 19 00 00       	call   801aac <sys_pf_calculate_allocated_pages>
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
  800105:	e8 a2 19 00 00       	call   801aac <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 e8 3c 80 00       	push   $0x803ce8
  800117:	6a 32                	push   $0x32
  800119:	68 9c 3c 80 00       	push   $0x803c9c
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 39 19 00 00       	call   801a61 <sys_calculate_free_frames>
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
  80015f:	e8 fd 18 00 00       	call   801a61 <sys_calculate_free_frames>
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
  8001c7:	e8 f0 1c 00 00       	call   801ebc <sys_check_WS_list>
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
  8001ec:	e8 70 18 00 00       	call   801a61 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 b3 18 00 00       	call   801aac <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 99 18 00 00       	call   801aac <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 b4 3d 80 00       	push   $0x803db4
  800220:	6a 4d                	push   $0x4d
  800222:	68 9c 3c 80 00       	push   $0x803c9c
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 30 18 00 00       	call   801a61 <sys_calculate_free_frames>
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
  80028d:	e8 2a 1c 00 00       	call   801ebc <sys_check_WS_list>
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
  8002b2:	e8 b1 1a 00 00       	call   801d68 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 c5 1a 00 00       	call   801d82 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 99 1a 00 00       	call   801d68 <inctst>
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
  8002e9:	e8 3c 19 00 00       	call   801c2a <sys_getenvindex>
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
  800357:	e8 52 16 00 00       	call   8019ae <sys_lock_cons>
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
  8003f1:	e8 d2 15 00 00       	call   8019c8 <sys_unlock_cons>
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
  800409:	e8 e8 17 00 00       	call   801bf6 <sys_destroy_env>
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
  80041a:	e8 3d 18 00 00       	call   801c5c <sys_exit_env>
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
  800651:	e8 16 13 00 00       	call   80196c <sys_cputs>
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
  8006c8:	e8 9f 12 00 00       	call   80196c <sys_cputs>
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
  800712:	e8 97 12 00 00       	call   8019ae <sys_lock_cons>
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
  800732:	e8 91 12 00 00       	call   8019c8 <sys_unlock_cons>
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
  80077c:	e8 83 32 00 00       	call   803a04 <__udivdi3>
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
  8007cc:	e8 43 33 00 00       	call   803b14 <__umoddi3>
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
  801485:	e8 8d 0a 00 00       	call   801f17 <sys_sbrk>
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
  801500:	e8 96 08 00 00       	call   801d9b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 d6 0d 00 00       	call   8022ea <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 a8 08 00 00       	call   801dcc <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 6f 12 00 00       	call   8027a6 <alloc_block_BF>
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
  801698:	e8 b1 08 00 00       	call   801f4e <sys_allocate_user_mem>
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
  8016e0:	e8 85 08 00 00       	call   801f6a <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 b8 1a 00 00       	call   8031ae <free_block>
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
  801788:	e8 a5 07 00 00       	call   801f32 <sys_free_user_mem>
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
  8017c3:	eb 64                	jmp    801829 <smalloc+0x7d>
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
  8017f8:	eb 2f                	jmp    801829 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017fa:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801801:	50                   	push   %eax
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	e8 2c 03 00 00       	call   801b39 <sys_createSharedObject>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801813:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801817:	74 06                	je     80181f <smalloc+0x73>
  801819:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80181d:	75 07                	jne    801826 <smalloc+0x7a>
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb 03                	jmp    801829 <smalloc+0x7d>
	 return ptr;
  801826:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 24 03 00 00       	call   801b63 <sys_getSizeOfSharedObject>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801845:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801849:	75 07                	jne    801852 <sget+0x27>
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	eb 5c                	jmp    8018ae <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801858:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80185f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	39 d0                	cmp    %edx,%eax
  801867:	7d 02                	jge    80186b <sget+0x40>
  801869:	89 d0                	mov    %edx,%eax
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	50                   	push   %eax
  80186f:	e8 1b fc ff ff       	call   80148f <malloc>
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80187a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80187e:	75 07                	jne    801887 <sget+0x5c>
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
  801885:	eb 27                	jmp    8018ae <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	ff 75 e8             	pushl  -0x18(%ebp)
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 e8 02 00 00       	call   801b80 <sys_getSharedObject>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80189e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018a2:	75 07                	jne    8018ab <sget+0x80>
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	eb 03                	jmp    8018ae <sget+0x83>
	return ptr;
  8018ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 b0 44 80 00       	push   $0x8044b0
  8018be:	68 c1 00 00 00       	push   $0xc1
  8018c3:	68 a2 44 80 00       	push   $0x8044a2
  8018c8:	e8 55 eb ff ff       	call   800422 <_panic>

008018cd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 d4 44 80 00       	push   $0x8044d4
  8018db:	68 d8 00 00 00       	push   $0xd8
  8018e0:	68 a2 44 80 00       	push   $0x8044a2
  8018e5:	e8 38 eb ff ff       	call   800422 <_panic>

008018ea <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 fa 44 80 00       	push   $0x8044fa
  8018f8:	68 e4 00 00 00       	push   $0xe4
  8018fd:	68 a2 44 80 00       	push   $0x8044a2
  801902:	e8 1b eb ff ff       	call   800422 <_panic>

00801907 <shrink>:

}
void shrink(uint32 newSize)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	68 fa 44 80 00       	push   $0x8044fa
  801915:	68 e9 00 00 00       	push   $0xe9
  80191a:	68 a2 44 80 00       	push   $0x8044a2
  80191f:	e8 fe ea ff ff       	call   800422 <_panic>

00801924 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	68 fa 44 80 00       	push   $0x8044fa
  801932:	68 ee 00 00 00       	push   $0xee
  801937:	68 a2 44 80 00       	push   $0x8044a2
  80193c:	e8 e1 ea ff ff       	call   800422 <_panic>

00801941 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	57                   	push   %edi
  801945:	56                   	push   %esi
  801946:	53                   	push   %ebx
  801947:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801953:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801956:	8b 7d 18             	mov    0x18(%ebp),%edi
  801959:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80195c:	cd 30                	int    $0x30
  80195e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801978:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	52                   	push   %edx
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	50                   	push   %eax
  801988:	6a 00                	push   $0x0
  80198a:	e8 b2 ff ff ff       	call   801941 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	90                   	nop
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_cgetc>:

int
sys_cgetc(void)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 02                	push   $0x2
  8019a4:	e8 98 ff ff ff       	call   801941 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 03                	push   $0x3
  8019bd:	e8 7f ff ff ff       	call   801941 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 04                	push   $0x4
  8019d7:	e8 65 ff ff ff       	call   801941 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 08                	push   $0x8
  8019f5:	e8 47 ff ff ff       	call   801941 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a04:	8b 75 18             	mov    0x18(%ebp),%esi
  801a07:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	51                   	push   %ecx
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 09                	push   $0x9
  801a1a:	e8 22 ff ff ff       	call   801941 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    

00801a29 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 0a                	push   $0xa
  801a3c:	e8 00 ff ff ff       	call   801941 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 0b                	push   $0xb
  801a57:	e8 e5 fe ff ff       	call   801941 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 0c                	push   $0xc
  801a70:	e8 cc fe ff ff       	call   801941 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0d                	push   $0xd
  801a89:	e8 b3 fe ff ff       	call   801941 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 0e                	push   $0xe
  801aa2:	e8 9a fe ff ff       	call   801941 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 0f                	push   $0xf
  801abb:	e8 81 fe ff ff       	call   801941 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	6a 10                	push   $0x10
  801ad5:	e8 67 fe ff ff       	call   801941 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 11                	push   $0x11
  801aee:	e8 4e fe ff ff       	call   801941 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	90                   	nop
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_cputc>:

void
sys_cputc(const char c)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	50                   	push   %eax
  801b12:	6a 01                	push   $0x1
  801b14:	e8 28 fe ff ff       	call   801941 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 14                	push   $0x14
  801b2e:	e8 0e fe ff ff       	call   801941 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b42:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b45:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b48:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	51                   	push   %ecx
  801b52:	52                   	push   %edx
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	50                   	push   %eax
  801b57:	6a 15                	push   $0x15
  801b59:	e8 e3 fd ff ff       	call   801941 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 16                	push   $0x16
  801b76:	e8 c6 fd ff ff       	call   801941 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	51                   	push   %ecx
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	6a 17                	push   $0x17
  801b95:	e8 a7 fd ff ff       	call   801941 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 18                	push   $0x18
  801bb2:	e8 8a fd ff ff       	call   801941 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 14             	pushl  0x14(%ebp)
  801bc7:	ff 75 10             	pushl  0x10(%ebp)
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	6a 19                	push   $0x19
  801bd0:	e8 6c fd ff ff       	call   801941 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	50                   	push   %eax
  801be9:	6a 1a                	push   $0x1a
  801beb:	e8 51 fd ff ff       	call   801941 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	90                   	nop
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	50                   	push   %eax
  801c05:	6a 1b                	push   $0x1b
  801c07:	e8 35 fd ff ff       	call   801941 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 05                	push   $0x5
  801c20:	e8 1c fd ff ff       	call   801941 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 06                	push   $0x6
  801c39:	e8 03 fd ff ff       	call   801941 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 07                	push   $0x7
  801c52:	e8 ea fc ff ff       	call   801941 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_exit_env>:


void sys_exit_env(void)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 1c                	push   $0x1c
  801c6b:	e8 d1 fc ff ff       	call   801941 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	90                   	nop
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7f:	8d 50 04             	lea    0x4(%eax),%edx
  801c82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	52                   	push   %edx
  801c8c:	50                   	push   %eax
  801c8d:	6a 1d                	push   $0x1d
  801c8f:	e8 ad fc ff ff       	call   801941 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return result;
  801c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca0:	89 01                	mov    %eax,(%ecx)
  801ca2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	c9                   	leave  
  801ca9:	c2 04 00             	ret    $0x4

00801cac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	ff 75 10             	pushl  0x10(%ebp)
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	ff 75 08             	pushl  0x8(%ebp)
  801cbc:	6a 13                	push   $0x13
  801cbe:	e8 7e fc ff ff       	call   801941 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc6:	90                   	nop
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 1e                	push   $0x1e
  801cd8:	e8 64 fc ff ff       	call   801941 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 04             	sub    $0x4,%esp
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	50                   	push   %eax
  801cfb:	6a 1f                	push   $0x1f
  801cfd:	e8 3f fc ff ff       	call   801941 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <rsttst>:
void rsttst()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 21                	push   $0x21
  801d17:	e8 25 fc ff ff       	call   801941 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d2e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d35:	52                   	push   %edx
  801d36:	50                   	push   %eax
  801d37:	ff 75 10             	pushl  0x10(%ebp)
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	ff 75 08             	pushl  0x8(%ebp)
  801d40:	6a 20                	push   $0x20
  801d42:	e8 fa fb ff ff       	call   801941 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4a:	90                   	nop
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <chktst>:
void chktst(uint32 n)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 22                	push   $0x22
  801d5d:	e8 df fb ff ff       	call   801941 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <inctst>:

void inctst()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 23                	push   $0x23
  801d77:	e8 c5 fb ff ff       	call   801941 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <gettst>:
uint32 gettst()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 24                	push   $0x24
  801d91:	e8 ab fb ff ff       	call   801941 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 25                	push   $0x25
  801dad:	e8 8f fb ff ff       	call   801941 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
  801db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbc:	75 07                	jne    801dc5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	eb 05                	jmp    801dca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 25                	push   $0x25
  801dde:	e8 5e fb ff ff       	call   801941 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
  801de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801de9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ded:	75 07                	jne    801df6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801def:	b8 01 00 00 00       	mov    $0x1,%eax
  801df4:	eb 05                	jmp    801dfb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 25                	push   $0x25
  801e0f:	e8 2d fb ff ff       	call   801941 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
  801e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e1e:	75 07                	jne    801e27 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e20:	b8 01 00 00 00       	mov    $0x1,%eax
  801e25:	eb 05                	jmp    801e2c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 25                	push   $0x25
  801e40:	e8 fc fa ff ff       	call   801941 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
  801e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e4f:	75 07                	jne    801e58 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e51:	b8 01 00 00 00       	mov    $0x1,%eax
  801e56:	eb 05                	jmp    801e5d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	6a 26                	push   $0x26
  801e6f:	e8 cd fa ff ff       	call   801941 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return ;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	53                   	push   %ebx
  801e8d:	51                   	push   %ecx
  801e8e:	52                   	push   %edx
  801e8f:	50                   	push   %eax
  801e90:	6a 27                	push   $0x27
  801e92:	e8 aa fa ff ff       	call   801941 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	52                   	push   %edx
  801eaf:	50                   	push   %eax
  801eb0:	6a 28                	push   $0x28
  801eb2:	e8 8a fa ff ff       	call   801941 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ebf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	6a 00                	push   $0x0
  801eca:	51                   	push   %ecx
  801ecb:	ff 75 10             	pushl  0x10(%ebp)
  801ece:	52                   	push   %edx
  801ecf:	50                   	push   %eax
  801ed0:	6a 29                	push   $0x29
  801ed2:	e8 6a fa ff ff       	call   801941 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 10             	pushl  0x10(%ebp)
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	6a 12                	push   $0x12
  801eee:	e8 4e fa ff ff       	call   801941 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 2a                	push   $0x2a
  801f0c:	e8 30 fa ff ff       	call   801941 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	50                   	push   %eax
  801f26:	6a 2b                	push   $0x2b
  801f28:	e8 14 fa ff ff       	call   801941 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	ff 75 08             	pushl  0x8(%ebp)
  801f41:	6a 2c                	push   $0x2c
  801f43:	e8 f9 f9 ff ff       	call   801941 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
	return;
  801f4b:	90                   	nop
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	6a 2d                	push   $0x2d
  801f5f:	e8 dd f9 ff ff       	call   801941 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
	return;
  801f67:	90                   	nop
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	83 e8 04             	sub    $0x4,%eax
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	83 e8 04             	sub    $0x4,%eax
  801f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	83 e0 01             	and    $0x1,%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	0f 94 c0             	sete   %al
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	83 f8 02             	cmp    $0x2,%eax
  801fb4:	74 2b                	je     801fe1 <alloc_block+0x40>
  801fb6:	83 f8 02             	cmp    $0x2,%eax
  801fb9:	7f 07                	jg     801fc2 <alloc_block+0x21>
  801fbb:	83 f8 01             	cmp    $0x1,%eax
  801fbe:	74 0e                	je     801fce <alloc_block+0x2d>
  801fc0:	eb 58                	jmp    80201a <alloc_block+0x79>
  801fc2:	83 f8 03             	cmp    $0x3,%eax
  801fc5:	74 2d                	je     801ff4 <alloc_block+0x53>
  801fc7:	83 f8 04             	cmp    $0x4,%eax
  801fca:	74 3b                	je     802007 <alloc_block+0x66>
  801fcc:	eb 4c                	jmp    80201a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	e8 11 03 00 00       	call   8022ea <alloc_block_FF>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fdf:	eb 4a                	jmp    80202b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff 75 08             	pushl  0x8(%ebp)
  801fe7:	e8 fa 19 00 00       	call   8039e6 <alloc_block_NF>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff2:	eb 37                	jmp    80202b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	e8 a7 07 00 00       	call   8027a6 <alloc_block_BF>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802005:	eb 24                	jmp    80202b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	e8 b7 19 00 00       	call   8039c9 <alloc_block_WF>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802018:	eb 11                	jmp    80202b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	68 0c 45 80 00       	push   $0x80450c
  802022:	e8 b8 e6 ff ff       	call   8006df <cprintf>
  802027:	83 c4 10             	add    $0x10,%esp
		break;
  80202a:	90                   	nop
	}
	return va;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	53                   	push   %ebx
  802034:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802037:	83 ec 0c             	sub    $0xc,%esp
  80203a:	68 2c 45 80 00       	push   $0x80452c
  80203f:	e8 9b e6 ff ff       	call   8006df <cprintf>
  802044:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	68 57 45 80 00       	push   $0x804557
  80204f:	e8 8b e6 ff ff       	call   8006df <cprintf>
  802054:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205d:	eb 37                	jmp    802096 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	ff 75 f4             	pushl  -0xc(%ebp)
  802065:	e8 19 ff ff ff       	call   801f83 <is_free_block>
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	0f be d8             	movsbl %al,%ebx
  802070:	83 ec 0c             	sub    $0xc,%esp
  802073:	ff 75 f4             	pushl  -0xc(%ebp)
  802076:	e8 ef fe ff ff       	call   801f6a <get_block_size>
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	53                   	push   %ebx
  802082:	50                   	push   %eax
  802083:	68 6f 45 80 00       	push   $0x80456f
  802088:	e8 52 e6 ff ff       	call   8006df <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209a:	74 07                	je     8020a3 <print_blocks_list+0x73>
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 00                	mov    (%eax),%eax
  8020a1:	eb 05                	jmp    8020a8 <print_blocks_list+0x78>
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a8:	89 45 10             	mov    %eax,0x10(%ebp)
  8020ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	75 ad                	jne    80205f <print_blocks_list+0x2f>
  8020b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b6:	75 a7                	jne    80205f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	68 2c 45 80 00       	push   $0x80452c
  8020c0:	e8 1a e6 ff ff       	call   8006df <cprintf>
  8020c5:	83 c4 10             	add    $0x10,%esp

}
  8020c8:	90                   	nop
  8020c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	83 e0 01             	and    $0x1,%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	74 03                	je     8020e1 <initialize_dynamic_allocator+0x13>
  8020de:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e5:	0f 84 c7 01 00 00    	je     8022b2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020eb:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020f2:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802102:	0f 87 ad 01 00 00    	ja     8022b5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	0f 89 a5 01 00 00    	jns    8022b8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802113:	8b 55 08             	mov    0x8(%ebp),%edx
  802116:	8b 45 0c             	mov    0xc(%ebp),%eax
  802119:	01 d0                	add    %edx,%eax
  80211b:	83 e8 04             	sub    $0x4,%eax
  80211e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80212a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80212f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802132:	e9 87 00 00 00       	jmp    8021be <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213b:	75 14                	jne    802151 <initialize_dynamic_allocator+0x83>
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	68 87 45 80 00       	push   $0x804587
  802145:	6a 79                	push   $0x79
  802147:	68 a5 45 80 00       	push   $0x8045a5
  80214c:	e8 d1 e2 ff ff       	call   800422 <_panic>
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	74 10                	je     80216a <initialize_dynamic_allocator+0x9c>
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802162:	8b 52 04             	mov    0x4(%edx),%edx
  802165:	89 50 04             	mov    %edx,0x4(%eax)
  802168:	eb 0b                	jmp    802175 <initialize_dynamic_allocator+0xa7>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 40 04             	mov    0x4(%eax),%eax
  802170:	a3 30 50 80 00       	mov    %eax,0x805030
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 40 04             	mov    0x4(%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0f                	je     80218e <initialize_dynamic_allocator+0xc0>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802188:	8b 12                	mov    (%edx),%edx
  80218a:	89 10                	mov    %edx,(%eax)
  80218c:	eb 0a                	jmp    802198 <initialize_dynamic_allocator+0xca>
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 00                	mov    (%eax),%eax
  802193:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b0:	48                   	dec    %eax
  8021b1:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021b6:	a1 34 50 80 00       	mov    0x805034,%eax
  8021bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c2:	74 07                	je     8021cb <initialize_dynamic_allocator+0xfd>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	eb 05                	jmp    8021d0 <initialize_dynamic_allocator+0x102>
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d0:	a3 34 50 80 00       	mov    %eax,0x805034
  8021d5:	a1 34 50 80 00       	mov    0x805034,%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	0f 85 55 ff ff ff    	jne    802137 <initialize_dynamic_allocator+0x69>
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	0f 85 4b ff ff ff    	jne    802137 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802200:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802205:	a1 40 50 80 00       	mov    0x805040,%eax
  80220a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	83 c0 08             	add    $0x8,%eax
  802216:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	83 c0 04             	add    $0x4,%eax
  80221f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802222:	83 ea 08             	sub    $0x8,%edx
  802225:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	01 d0                	add    %edx,%eax
  80222f:	83 e8 08             	sub    $0x8,%eax
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	83 ea 08             	sub    $0x8,%edx
  802238:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80223a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80224d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802251:	75 17                	jne    80226a <initialize_dynamic_allocator+0x19c>
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 c0 45 80 00       	push   $0x8045c0
  80225b:	68 90 00 00 00       	push   $0x90
  802260:	68 a5 45 80 00       	push   $0x8045a5
  802265:	e8 b8 e1 ff ff       	call   800422 <_panic>
  80226a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	89 10                	mov    %edx,(%eax)
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	74 0d                	je     80228b <initialize_dynamic_allocator+0x1bd>
  80227e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802283:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802286:	89 50 04             	mov    %edx,0x4(%eax)
  802289:	eb 08                	jmp    802293 <initialize_dynamic_allocator+0x1c5>
  80228b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228e:	a3 30 50 80 00       	mov    %eax,0x805030
  802293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802296:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80229b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022aa:	40                   	inc    %eax
  8022ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8022b0:	eb 07                	jmp    8022b9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022b2:	90                   	nop
  8022b3:	eb 04                	jmp    8022b9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022b5:	90                   	nop
  8022b6:	eb 01                	jmp    8022b9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022b8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022be:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c1:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cd:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	83 e8 04             	sub    $0x4,%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8022da:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	01 c2                	add    %eax,%edx
  8022e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e5:	89 02                	mov    %eax,(%edx)
}
  8022e7:	90                   	nop
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    

008022ea <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	83 e0 01             	and    $0x1,%eax
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 03                	je     8022fd <alloc_block_FF+0x13>
  8022fa:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022fd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802301:	77 07                	ja     80230a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802303:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80230a:	a1 24 50 80 00       	mov    0x805024,%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	75 73                	jne    802386 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	83 c0 10             	add    $0x10,%eax
  802319:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80231c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802329:	01 d0                	add    %edx,%eax
  80232b:	48                   	dec    %eax
  80232c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80232f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802332:	ba 00 00 00 00       	mov    $0x0,%edx
  802337:	f7 75 ec             	divl   -0x14(%ebp)
  80233a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233d:	29 d0                	sub    %edx,%eax
  80233f:	c1 e8 0c             	shr    $0xc,%eax
  802342:	83 ec 0c             	sub    $0xc,%esp
  802345:	50                   	push   %eax
  802346:	e8 2e f1 ff ff       	call   801479 <sbrk>
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802351:	83 ec 0c             	sub    $0xc,%esp
  802354:	6a 00                	push   $0x0
  802356:	e8 1e f1 ff ff       	call   801479 <sbrk>
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802364:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802367:	83 ec 08             	sub    $0x8,%esp
  80236a:	50                   	push   %eax
  80236b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80236e:	e8 5b fd ff ff       	call   8020ce <initialize_dynamic_allocator>
  802373:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802376:	83 ec 0c             	sub    $0xc,%esp
  802379:	68 e3 45 80 00       	push   $0x8045e3
  80237e:	e8 5c e3 ff ff       	call   8006df <cprintf>
  802383:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238a:	75 0a                	jne    802396 <alloc_block_FF+0xac>
	        return NULL;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
  802391:	e9 0e 04 00 00       	jmp    8027a4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80239d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a5:	e9 f3 02 00 00       	jmp    80269d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023b0:	83 ec 0c             	sub    $0xc,%esp
  8023b3:	ff 75 bc             	pushl  -0x44(%ebp)
  8023b6:	e8 af fb ff ff       	call   801f6a <get_block_size>
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	83 c0 08             	add    $0x8,%eax
  8023c7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ca:	0f 87 c5 02 00 00    	ja     802695 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	83 c0 18             	add    $0x18,%eax
  8023d6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023d9:	0f 87 19 02 00 00    	ja     8025f8 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e5:	83 e8 08             	sub    $0x8,%eax
  8023e8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8d 50 08             	lea    0x8(%eax),%edx
  8023f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023f4:	01 d0                	add    %edx,%eax
  8023f6:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	83 c0 08             	add    $0x8,%eax
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	6a 01                	push   $0x1
  802404:	50                   	push   %eax
  802405:	ff 75 bc             	pushl  -0x44(%ebp)
  802408:	e8 ae fe ff ff       	call   8022bb <set_block_data>
  80240d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	75 68                	jne    802482 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80241a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80241e:	75 17                	jne    802437 <alloc_block_FF+0x14d>
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 c0 45 80 00       	push   $0x8045c0
  802428:	68 d7 00 00 00       	push   $0xd7
  80242d:	68 a5 45 80 00       	push   $0x8045a5
  802432:	e8 eb df ff ff       	call   800422 <_panic>
  802437:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80243d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802440:	89 10                	mov    %edx,(%eax)
  802442:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0d                	je     802458 <alloc_block_FF+0x16e>
  80244b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802450:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	eb 08                	jmp    802460 <alloc_block_FF+0x176>
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	a3 30 50 80 00       	mov    %eax,0x805030
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802468:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802472:	a1 38 50 80 00       	mov    0x805038,%eax
  802477:	40                   	inc    %eax
  802478:	a3 38 50 80 00       	mov    %eax,0x805038
  80247d:	e9 dc 00 00 00       	jmp    80255e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	75 65                	jne    8024f0 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80248b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80248f:	75 17                	jne    8024a8 <alloc_block_FF+0x1be>
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	68 f4 45 80 00       	push   $0x8045f4
  802499:	68 db 00 00 00       	push   $0xdb
  80249e:	68 a5 45 80 00       	push   $0x8045a5
  8024a3:	e8 7a df ff ff       	call   800422 <_panic>
  8024a8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b1:	89 50 04             	mov    %edx,0x4(%eax)
  8024b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0c                	je     8024ca <alloc_block_FF+0x1e0>
  8024be:	a1 30 50 80 00       	mov    0x805030,%eax
  8024c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024c6:	89 10                	mov    %edx,(%eax)
  8024c8:	eb 08                	jmp    8024d2 <alloc_block_FF+0x1e8>
  8024ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e8:	40                   	inc    %eax
  8024e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8024ee:	eb 6e                	jmp    80255e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f4:	74 06                	je     8024fc <alloc_block_FF+0x212>
  8024f6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024fa:	75 17                	jne    802513 <alloc_block_FF+0x229>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 18 46 80 00       	push   $0x804618
  802504:	68 df 00 00 00       	push   $0xdf
  802509:	68 a5 45 80 00       	push   $0x8045a5
  80250e:	e8 0f df ff ff       	call   800422 <_panic>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 10                	mov    (%eax),%edx
  802518:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 0b                	je     802531 <alloc_block_FF+0x247>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802537:	89 10                	mov    %edx,(%eax)
  802539:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253f:	89 50 04             	mov    %edx,0x4(%eax)
  802542:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	75 08                	jne    802553 <alloc_block_FF+0x269>
  80254b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254e:	a3 30 50 80 00       	mov    %eax,0x805030
  802553:	a1 38 50 80 00       	mov    0x805038,%eax
  802558:	40                   	inc    %eax
  802559:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80255e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802562:	75 17                	jne    80257b <alloc_block_FF+0x291>
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 87 45 80 00       	push   $0x804587
  80256c:	68 e1 00 00 00       	push   $0xe1
  802571:	68 a5 45 80 00       	push   $0x8045a5
  802576:	e8 a7 de ff ff       	call   800422 <_panic>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 10                	je     802594 <alloc_block_FF+0x2aa>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 52 04             	mov    0x4(%edx),%edx
  80258f:	89 50 04             	mov    %edx,0x4(%eax)
  802592:	eb 0b                	jmp    80259f <alloc_block_FF+0x2b5>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	a3 30 50 80 00       	mov    %eax,0x805030
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 0f                	je     8025b8 <alloc_block_FF+0x2ce>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b2:	8b 12                	mov    (%edx),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	eb 0a                	jmp    8025c2 <alloc_block_FF+0x2d8>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8025da:	48                   	dec    %eax
  8025db:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	6a 00                	push   $0x0
  8025e5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025e8:	ff 75 b0             	pushl  -0x50(%ebp)
  8025eb:	e8 cb fc ff ff       	call   8022bb <set_block_data>
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	e9 95 00 00 00       	jmp    80268d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	6a 01                	push   $0x1
  8025fd:	ff 75 b8             	pushl  -0x48(%ebp)
  802600:	ff 75 bc             	pushl  -0x44(%ebp)
  802603:	e8 b3 fc ff ff       	call   8022bb <set_block_data>
  802608:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	75 17                	jne    802628 <alloc_block_FF+0x33e>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 87 45 80 00       	push   $0x804587
  802619:	68 e8 00 00 00       	push   $0xe8
  80261e:	68 a5 45 80 00       	push   $0x8045a5
  802623:	e8 fa dd ff ff       	call   800422 <_panic>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	74 10                	je     802641 <alloc_block_FF+0x357>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802639:	8b 52 04             	mov    0x4(%edx),%edx
  80263c:	89 50 04             	mov    %edx,0x4(%eax)
  80263f:	eb 0b                	jmp    80264c <alloc_block_FF+0x362>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	a3 30 50 80 00       	mov    %eax,0x805030
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 0f                	je     802665 <alloc_block_FF+0x37b>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265f:	8b 12                	mov    (%edx),%edx
  802661:	89 10                	mov    %edx,(%eax)
  802663:	eb 0a                	jmp    80266f <alloc_block_FF+0x385>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802682:	a1 38 50 80 00       	mov    0x805038,%eax
  802687:	48                   	dec    %eax
  802688:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80268d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802690:	e9 0f 01 00 00       	jmp    8027a4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802695:	a1 34 50 80 00       	mov    0x805034,%eax
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a1:	74 07                	je     8026aa <alloc_block_FF+0x3c0>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	eb 05                	jmp    8026af <alloc_block_FF+0x3c5>
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026af:	a3 34 50 80 00       	mov    %eax,0x805034
  8026b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	0f 85 e9 fc ff ff    	jne    8023aa <alloc_block_FF+0xc0>
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	0f 85 df fc ff ff    	jne    8023aa <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	83 c0 08             	add    $0x8,%eax
  8026d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026d4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e1:	01 d0                	add    %edx,%eax
  8026e3:	48                   	dec    %eax
  8026e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ef:	f7 75 d8             	divl   -0x28(%ebp)
  8026f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f5:	29 d0                	sub    %edx,%eax
  8026f7:	c1 e8 0c             	shr    $0xc,%eax
  8026fa:	83 ec 0c             	sub    $0xc,%esp
  8026fd:	50                   	push   %eax
  8026fe:	e8 76 ed ff ff       	call   801479 <sbrk>
  802703:	83 c4 10             	add    $0x10,%esp
  802706:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802709:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80270d:	75 0a                	jne    802719 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	e9 8b 00 00 00       	jmp    8027a4 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802719:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802720:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802723:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802726:	01 d0                	add    %edx,%eax
  802728:	48                   	dec    %eax
  802729:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80272c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80272f:	ba 00 00 00 00       	mov    $0x0,%edx
  802734:	f7 75 cc             	divl   -0x34(%ebp)
  802737:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80273a:	29 d0                	sub    %edx,%eax
  80273c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80273f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802749:	a1 40 50 80 00       	mov    0x805040,%eax
  80274e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802754:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80275b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80275e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802761:	01 d0                	add    %edx,%eax
  802763:	48                   	dec    %eax
  802764:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802767:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276a:	ba 00 00 00 00       	mov    $0x0,%edx
  80276f:	f7 75 c4             	divl   -0x3c(%ebp)
  802772:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802775:	29 d0                	sub    %edx,%eax
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	6a 01                	push   $0x1
  80277c:	50                   	push   %eax
  80277d:	ff 75 d0             	pushl  -0x30(%ebp)
  802780:	e8 36 fb ff ff       	call   8022bb <set_block_data>
  802785:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	ff 75 d0             	pushl  -0x30(%ebp)
  80278e:	e8 1b 0a 00 00       	call   8031ae <free_block>
  802793:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	ff 75 08             	pushl  0x8(%ebp)
  80279c:	e8 49 fb ff ff       	call   8022ea <alloc_block_FF>
  8027a1:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	83 e0 01             	and    $0x1,%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 03                	je     8027b9 <alloc_block_BF+0x13>
  8027b6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027b9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027bd:	77 07                	ja     8027c6 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027bf:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027c6:	a1 24 50 80 00       	mov    0x805024,%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 73                	jne    802842 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	83 c0 10             	add    $0x10,%eax
  8027d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027d8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e5:	01 d0                	add    %edx,%eax
  8027e7:	48                   	dec    %eax
  8027e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f3:	f7 75 e0             	divl   -0x20(%ebp)
  8027f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f9:	29 d0                	sub    %edx,%eax
  8027fb:	c1 e8 0c             	shr    $0xc,%eax
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	50                   	push   %eax
  802802:	e8 72 ec ff ff       	call   801479 <sbrk>
  802807:	83 c4 10             	add    $0x10,%esp
  80280a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	6a 00                	push   $0x0
  802812:	e8 62 ec ff ff       	call   801479 <sbrk>
  802817:	83 c4 10             	add    $0x10,%esp
  80281a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80281d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802820:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802823:	83 ec 08             	sub    $0x8,%esp
  802826:	50                   	push   %eax
  802827:	ff 75 d8             	pushl  -0x28(%ebp)
  80282a:	e8 9f f8 ff ff       	call   8020ce <initialize_dynamic_allocator>
  80282f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802832:	83 ec 0c             	sub    $0xc,%esp
  802835:	68 e3 45 80 00       	push   $0x8045e3
  80283a:	e8 a0 de ff ff       	call   8006df <cprintf>
  80283f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802842:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802849:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802850:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802857:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80285e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802866:	e9 1d 01 00 00       	jmp    802988 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802871:	83 ec 0c             	sub    $0xc,%esp
  802874:	ff 75 a8             	pushl  -0x58(%ebp)
  802877:	e8 ee f6 ff ff       	call   801f6a <get_block_size>
  80287c:	83 c4 10             	add    $0x10,%esp
  80287f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	83 c0 08             	add    $0x8,%eax
  802888:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80288b:	0f 87 ef 00 00 00    	ja     802980 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	83 c0 18             	add    $0x18,%eax
  802897:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289a:	77 1d                	ja     8028b9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a2:	0f 86 d8 00 00 00    	jbe    802980 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028a8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028b4:	e9 c7 00 00 00       	jmp    802980 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	83 c0 08             	add    $0x8,%eax
  8028bf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c2:	0f 85 9d 00 00 00    	jne    802965 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	6a 01                	push   $0x1
  8028cd:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028d0:	ff 75 a8             	pushl  -0x58(%ebp)
  8028d3:	e8 e3 f9 ff ff       	call   8022bb <set_block_data>
  8028d8:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	75 17                	jne    8028f8 <alloc_block_BF+0x152>
  8028e1:	83 ec 04             	sub    $0x4,%esp
  8028e4:	68 87 45 80 00       	push   $0x804587
  8028e9:	68 2c 01 00 00       	push   $0x12c
  8028ee:	68 a5 45 80 00       	push   $0x8045a5
  8028f3:	e8 2a db ff ff       	call   800422 <_panic>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	74 10                	je     802911 <alloc_block_BF+0x16b>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802909:	8b 52 04             	mov    0x4(%edx),%edx
  80290c:	89 50 04             	mov    %edx,0x4(%eax)
  80290f:	eb 0b                	jmp    80291c <alloc_block_BF+0x176>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	a3 30 50 80 00       	mov    %eax,0x805030
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 04             	mov    0x4(%eax),%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 0f                	je     802935 <alloc_block_BF+0x18f>
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292f:	8b 12                	mov    (%edx),%edx
  802931:	89 10                	mov    %edx,(%eax)
  802933:	eb 0a                	jmp    80293f <alloc_block_BF+0x199>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802952:	a1 38 50 80 00       	mov    0x805038,%eax
  802957:	48                   	dec    %eax
  802958:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80295d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802960:	e9 24 04 00 00       	jmp    802d89 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802968:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80296b:	76 13                	jbe    802980 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80296d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802974:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802977:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80297a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80297d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802980:	a1 34 50 80 00       	mov    0x805034,%eax
  802985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	74 07                	je     802995 <alloc_block_BF+0x1ef>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	eb 05                	jmp    80299a <alloc_block_BF+0x1f4>
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	a3 34 50 80 00       	mov    %eax,0x805034
  80299f:	a1 34 50 80 00       	mov    0x805034,%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	0f 85 bf fe ff ff    	jne    80286b <alloc_block_BF+0xc5>
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	0f 85 b5 fe ff ff    	jne    80286b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ba:	0f 84 26 02 00 00    	je     802be6 <alloc_block_BF+0x440>
  8029c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c4:	0f 85 1c 02 00 00    	jne    802be6 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d0:	83 e8 08             	sub    $0x8,%eax
  8029d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8d 50 08             	lea    0x8(%eax),%edx
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	01 d0                	add    %edx,%eax
  8029e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	83 c0 08             	add    $0x8,%eax
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	6a 01                	push   $0x1
  8029ef:	50                   	push   %eax
  8029f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8029f3:	e8 c3 f8 ff ff       	call   8022bb <set_block_data>
  8029f8:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	75 68                	jne    802a6d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a05:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a09:	75 17                	jne    802a22 <alloc_block_BF+0x27c>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 c0 45 80 00       	push   $0x8045c0
  802a13:	68 45 01 00 00       	push   $0x145
  802a18:	68 a5 45 80 00       	push   $0x8045a5
  802a1d:	e8 00 da ff ff       	call   800422 <_panic>
  802a22:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0d                	je     802a43 <alloc_block_BF+0x29d>
  802a36:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a3b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 08                	jmp    802a4b <alloc_block_BF+0x2a5>
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 38 50 80 00       	mov    %eax,0x805038
  802a68:	e9 dc 00 00 00       	jmp    802b49 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	75 65                	jne    802adb <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a76:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a7a:	75 17                	jne    802a93 <alloc_block_BF+0x2ed>
  802a7c:	83 ec 04             	sub    $0x4,%esp
  802a7f:	68 f4 45 80 00       	push   $0x8045f4
  802a84:	68 4a 01 00 00       	push   $0x14a
  802a89:	68 a5 45 80 00       	push   $0x8045a5
  802a8e:	e8 8f d9 ff ff       	call   800422 <_panic>
  802a93:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9c:	89 50 04             	mov    %edx,0x4(%eax)
  802a9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0c                	je     802ab5 <alloc_block_BF+0x30f>
  802aa9:	a1 30 50 80 00       	mov    0x805030,%eax
  802aae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	eb 08                	jmp    802abd <alloc_block_BF+0x317>
  802ab5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ace:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad3:	40                   	inc    %eax
  802ad4:	a3 38 50 80 00       	mov    %eax,0x805038
  802ad9:	eb 6e                	jmp    802b49 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adf:	74 06                	je     802ae7 <alloc_block_BF+0x341>
  802ae1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ae5:	75 17                	jne    802afe <alloc_block_BF+0x358>
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	68 18 46 80 00       	push   $0x804618
  802aef:	68 4f 01 00 00       	push   $0x14f
  802af4:	68 a5 45 80 00       	push   $0x8045a5
  802af9:	e8 24 d9 ff ff       	call   800422 <_panic>
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 10                	mov    (%eax),%edx
  802b03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0b                	je     802b1c <alloc_block_BF+0x376>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b22:	89 10                	mov    %edx,(%eax)
  802b24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2a:	89 50 04             	mov    %edx,0x4(%eax)
  802b2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 08                	jne    802b3e <alloc_block_BF+0x398>
  802b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b39:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b43:	40                   	inc    %eax
  802b44:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4d:	75 17                	jne    802b66 <alloc_block_BF+0x3c0>
  802b4f:	83 ec 04             	sub    $0x4,%esp
  802b52:	68 87 45 80 00       	push   $0x804587
  802b57:	68 51 01 00 00       	push   $0x151
  802b5c:	68 a5 45 80 00       	push   $0x8045a5
  802b61:	e8 bc d8 ff ff       	call   800422 <_panic>
  802b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 10                	je     802b7f <alloc_block_BF+0x3d9>
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b77:	8b 52 04             	mov    0x4(%edx),%edx
  802b7a:	89 50 04             	mov    %edx,0x4(%eax)
  802b7d:	eb 0b                	jmp    802b8a <alloc_block_BF+0x3e4>
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 0f                	je     802ba3 <alloc_block_BF+0x3fd>
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9d:	8b 12                	mov    (%edx),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	eb 0a                	jmp    802bad <alloc_block_BF+0x407>
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc0:	a1 38 50 80 00       	mov    0x805038,%eax
  802bc5:	48                   	dec    %eax
  802bc6:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	6a 00                	push   $0x0
  802bd0:	ff 75 d0             	pushl  -0x30(%ebp)
  802bd3:	ff 75 cc             	pushl  -0x34(%ebp)
  802bd6:	e8 e0 f6 ff ff       	call   8022bb <set_block_data>
  802bdb:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	e9 a3 01 00 00       	jmp    802d89 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802be6:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bea:	0f 85 9d 00 00 00    	jne    802c8d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bf0:	83 ec 04             	sub    $0x4,%esp
  802bf3:	6a 01                	push   $0x1
  802bf5:	ff 75 ec             	pushl  -0x14(%ebp)
  802bf8:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfb:	e8 bb f6 ff ff       	call   8022bb <set_block_data>
  802c00:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c07:	75 17                	jne    802c20 <alloc_block_BF+0x47a>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 87 45 80 00       	push   $0x804587
  802c11:	68 58 01 00 00       	push   $0x158
  802c16:	68 a5 45 80 00       	push   $0x8045a5
  802c1b:	e8 02 d8 ff ff       	call   800422 <_panic>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 10                	je     802c39 <alloc_block_BF+0x493>
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c31:	8b 52 04             	mov    0x4(%edx),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	eb 0b                	jmp    802c44 <alloc_block_BF+0x49e>
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	74 0f                	je     802c5d <alloc_block_BF+0x4b7>
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c57:	8b 12                	mov    (%edx),%edx
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	eb 0a                	jmp    802c67 <alloc_block_BF+0x4c1>
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c7f:	48                   	dec    %eax
  802c80:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	e9 fc 00 00 00       	jmp    802d89 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	83 c0 08             	add    $0x8,%eax
  802c93:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c96:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c9d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	48                   	dec    %eax
  802ca6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ca9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cac:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb1:	f7 75 c4             	divl   -0x3c(%ebp)
  802cb4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb7:	29 d0                	sub    %edx,%eax
  802cb9:	c1 e8 0c             	shr    $0xc,%eax
  802cbc:	83 ec 0c             	sub    $0xc,%esp
  802cbf:	50                   	push   %eax
  802cc0:	e8 b4 e7 ff ff       	call   801479 <sbrk>
  802cc5:	83 c4 10             	add    $0x10,%esp
  802cc8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ccb:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ccf:	75 0a                	jne    802cdb <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd6:	e9 ae 00 00 00       	jmp    802d89 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cdb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ce2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ce5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	48                   	dec    %eax
  802ceb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf6:	f7 75 b8             	divl   -0x48(%ebp)
  802cf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cfc:	29 d0                	sub    %edx,%eax
  802cfe:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d04:	01 d0                	add    %edx,%eax
  802d06:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d0b:	a1 40 50 80 00       	mov    0x805040,%eax
  802d10:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d16:	83 ec 0c             	sub    $0xc,%esp
  802d19:	68 4c 46 80 00       	push   $0x80464c
  802d1e:	e8 bc d9 ff ff       	call   8006df <cprintf>
  802d23:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d26:	83 ec 08             	sub    $0x8,%esp
  802d29:	ff 75 bc             	pushl  -0x44(%ebp)
  802d2c:	68 51 46 80 00       	push   $0x804651
  802d31:	e8 a9 d9 ff ff       	call   8006df <cprintf>
  802d36:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d39:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d40:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d46:	01 d0                	add    %edx,%eax
  802d48:	48                   	dec    %eax
  802d49:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d4c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d54:	f7 75 b0             	divl   -0x50(%ebp)
  802d57:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d5a:	29 d0                	sub    %edx,%eax
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	6a 01                	push   $0x1
  802d61:	50                   	push   %eax
  802d62:	ff 75 bc             	pushl  -0x44(%ebp)
  802d65:	e8 51 f5 ff ff       	call   8022bb <set_block_data>
  802d6a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d6d:	83 ec 0c             	sub    $0xc,%esp
  802d70:	ff 75 bc             	pushl  -0x44(%ebp)
  802d73:	e8 36 04 00 00       	call   8031ae <free_block>
  802d78:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	ff 75 08             	pushl  0x8(%ebp)
  802d81:	e8 20 fa ff ff       	call   8027a6 <alloc_block_BF>
  802d86:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d89:	c9                   	leave  
  802d8a:	c3                   	ret    

00802d8b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d8b:	55                   	push   %ebp
  802d8c:	89 e5                	mov    %esp,%ebp
  802d8e:	53                   	push   %ebx
  802d8f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802da0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da4:	74 1e                	je     802dc4 <merging+0x39>
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	e8 bc f1 ff ff       	call   801f6a <get_block_size>
  802dae:	83 c4 04             	add    $0x4,%esp
  802db1:	89 c2                	mov    %eax,%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dbb:	75 07                	jne    802dc4 <merging+0x39>
		prev_is_free = 1;
  802dbd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc8:	74 1e                	je     802de8 <merging+0x5d>
  802dca:	ff 75 10             	pushl  0x10(%ebp)
  802dcd:	e8 98 f1 ff ff       	call   801f6a <get_block_size>
  802dd2:	83 c4 04             	add    $0x4,%esp
  802dd5:	89 c2                	mov    %eax,%edx
  802dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ddf:	75 07                	jne    802de8 <merging+0x5d>
		next_is_free = 1;
  802de1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802de8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dec:	0f 84 cc 00 00 00    	je     802ebe <merging+0x133>
  802df2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df6:	0f 84 c2 00 00 00    	je     802ebe <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dfc:	ff 75 08             	pushl  0x8(%ebp)
  802dff:	e8 66 f1 ff ff       	call   801f6a <get_block_size>
  802e04:	83 c4 04             	add    $0x4,%esp
  802e07:	89 c3                	mov    %eax,%ebx
  802e09:	ff 75 10             	pushl  0x10(%ebp)
  802e0c:	e8 59 f1 ff ff       	call   801f6a <get_block_size>
  802e11:	83 c4 04             	add    $0x4,%esp
  802e14:	01 c3                	add    %eax,%ebx
  802e16:	ff 75 0c             	pushl  0xc(%ebp)
  802e19:	e8 4c f1 ff ff       	call   801f6a <get_block_size>
  802e1e:	83 c4 04             	add    $0x4,%esp
  802e21:	01 d8                	add    %ebx,%eax
  802e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e26:	6a 00                	push   $0x0
  802e28:	ff 75 ec             	pushl  -0x14(%ebp)
  802e2b:	ff 75 08             	pushl  0x8(%ebp)
  802e2e:	e8 88 f4 ff ff       	call   8022bb <set_block_data>
  802e33:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e3a:	75 17                	jne    802e53 <merging+0xc8>
  802e3c:	83 ec 04             	sub    $0x4,%esp
  802e3f:	68 87 45 80 00       	push   $0x804587
  802e44:	68 7d 01 00 00       	push   $0x17d
  802e49:	68 a5 45 80 00       	push   $0x8045a5
  802e4e:	e8 cf d5 ff ff       	call   800422 <_panic>
  802e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 10                	je     802e6c <merging+0xe1>
  802e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e64:	8b 52 04             	mov    0x4(%edx),%edx
  802e67:	89 50 04             	mov    %edx,0x4(%eax)
  802e6a:	eb 0b                	jmp    802e77 <merging+0xec>
  802e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	a3 30 50 80 00       	mov    %eax,0x805030
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 40 04             	mov    0x4(%eax),%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 0f                	je     802e90 <merging+0x105>
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8a:	8b 12                	mov    (%edx),%edx
  802e8c:	89 10                	mov    %edx,(%eax)
  802e8e:	eb 0a                	jmp    802e9a <merging+0x10f>
  802e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ead:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb2:	48                   	dec    %eax
  802eb3:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802eb8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eb9:	e9 ea 02 00 00       	jmp    8031a8 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ebe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec2:	74 3b                	je     802eff <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ec4:	83 ec 0c             	sub    $0xc,%esp
  802ec7:	ff 75 08             	pushl  0x8(%ebp)
  802eca:	e8 9b f0 ff ff       	call   801f6a <get_block_size>
  802ecf:	83 c4 10             	add    $0x10,%esp
  802ed2:	89 c3                	mov    %eax,%ebx
  802ed4:	83 ec 0c             	sub    $0xc,%esp
  802ed7:	ff 75 10             	pushl  0x10(%ebp)
  802eda:	e8 8b f0 ff ff       	call   801f6a <get_block_size>
  802edf:	83 c4 10             	add    $0x10,%esp
  802ee2:	01 d8                	add    %ebx,%eax
  802ee4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	6a 00                	push   $0x0
  802eec:	ff 75 e8             	pushl  -0x18(%ebp)
  802eef:	ff 75 08             	pushl  0x8(%ebp)
  802ef2:	e8 c4 f3 ff ff       	call   8022bb <set_block_data>
  802ef7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802efa:	e9 a9 02 00 00       	jmp    8031a8 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802eff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f03:	0f 84 2d 01 00 00    	je     803036 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f09:	83 ec 0c             	sub    $0xc,%esp
  802f0c:	ff 75 10             	pushl  0x10(%ebp)
  802f0f:	e8 56 f0 ff ff       	call   801f6a <get_block_size>
  802f14:	83 c4 10             	add    $0x10,%esp
  802f17:	89 c3                	mov    %eax,%ebx
  802f19:	83 ec 0c             	sub    $0xc,%esp
  802f1c:	ff 75 0c             	pushl  0xc(%ebp)
  802f1f:	e8 46 f0 ff ff       	call   801f6a <get_block_size>
  802f24:	83 c4 10             	add    $0x10,%esp
  802f27:	01 d8                	add    %ebx,%eax
  802f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	6a 00                	push   $0x0
  802f31:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f34:	ff 75 10             	pushl  0x10(%ebp)
  802f37:	e8 7f f3 ff ff       	call   8022bb <set_block_data>
  802f3c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f42:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f49:	74 06                	je     802f51 <merging+0x1c6>
  802f4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f4f:	75 17                	jne    802f68 <merging+0x1dd>
  802f51:	83 ec 04             	sub    $0x4,%esp
  802f54:	68 60 46 80 00       	push   $0x804660
  802f59:	68 8d 01 00 00       	push   $0x18d
  802f5e:	68 a5 45 80 00       	push   $0x8045a5
  802f63:	e8 ba d4 ff ff       	call   800422 <_panic>
  802f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6b:	8b 50 04             	mov    0x4(%eax),%edx
  802f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f71:	89 50 04             	mov    %edx,0x4(%eax)
  802f74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 0d                	je     802f93 <merging+0x208>
  802f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	eb 08                	jmp    802f9b <merging+0x210>
  802f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f96:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa1:	89 50 04             	mov    %edx,0x4(%eax)
  802fa4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa9:	40                   	inc    %eax
  802faa:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802faf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb3:	75 17                	jne    802fcc <merging+0x241>
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	68 87 45 80 00       	push   $0x804587
  802fbd:	68 8e 01 00 00       	push   $0x18e
  802fc2:	68 a5 45 80 00       	push   $0x8045a5
  802fc7:	e8 56 d4 ff ff       	call   800422 <_panic>
  802fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	74 10                	je     802fe5 <merging+0x25a>
  802fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdd:	8b 52 04             	mov    0x4(%edx),%edx
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
  802fe3:	eb 0b                	jmp    802ff0 <merging+0x265>
  802fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 0f                	je     803009 <merging+0x27e>
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	8b 55 0c             	mov    0xc(%ebp),%edx
  803003:	8b 12                	mov    (%edx),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	eb 0a                	jmp    803013 <merging+0x288>
  803009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 38 50 80 00       	mov    0x805038,%eax
  80302b:	48                   	dec    %eax
  80302c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803031:	e9 72 01 00 00       	jmp    8031a8 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803036:	8b 45 10             	mov    0x10(%ebp),%eax
  803039:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80303c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803040:	74 79                	je     8030bb <merging+0x330>
  803042:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803046:	74 73                	je     8030bb <merging+0x330>
  803048:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304c:	74 06                	je     803054 <merging+0x2c9>
  80304e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803052:	75 17                	jne    80306b <merging+0x2e0>
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	68 18 46 80 00       	push   $0x804618
  80305c:	68 94 01 00 00       	push   $0x194
  803061:	68 a5 45 80 00       	push   $0x8045a5
  803066:	e8 b7 d3 ff ff       	call   800422 <_panic>
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 10                	mov    (%eax),%edx
  803070:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803073:	89 10                	mov    %edx,(%eax)
  803075:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0b                	je     803089 <merging+0x2fe>
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80308f:	89 10                	mov    %edx,(%eax)
  803091:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803094:	8b 55 08             	mov    0x8(%ebp),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	75 08                	jne    8030ab <merging+0x320>
  8030a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b0:	40                   	inc    %eax
  8030b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8030b6:	e9 ce 00 00 00       	jmp    803189 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bf:	74 65                	je     803126 <merging+0x39b>
  8030c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030c5:	75 17                	jne    8030de <merging+0x353>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 f4 45 80 00       	push   $0x8045f4
  8030cf:	68 95 01 00 00       	push   $0x195
  8030d4:	68 a5 45 80 00       	push   $0x8045a5
  8030d9:	e8 44 d3 ff ff       	call   800422 <_panic>
  8030de:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0c                	je     803100 <merging+0x375>
  8030f4:	a1 30 50 80 00       	mov    0x805030,%eax
  8030f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	eb 08                	jmp    803108 <merging+0x37d>
  803100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803103:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803108:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310b:	a3 30 50 80 00       	mov    %eax,0x805030
  803110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803113:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803119:	a1 38 50 80 00       	mov    0x805038,%eax
  80311e:	40                   	inc    %eax
  80311f:	a3 38 50 80 00       	mov    %eax,0x805038
  803124:	eb 63                	jmp    803189 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803126:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80312a:	75 17                	jne    803143 <merging+0x3b8>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 c0 45 80 00       	push   $0x8045c0
  803134:	68 98 01 00 00       	push   $0x198
  803139:	68 a5 45 80 00       	push   $0x8045a5
  80313e:	e8 df d2 ff ff       	call   800422 <_panic>
  803143:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	74 0d                	je     803164 <merging+0x3d9>
  803157:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%eax)
  803162:	eb 08                	jmp    80316c <merging+0x3e1>
  803164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803167:	a3 30 50 80 00       	mov    %eax,0x805030
  80316c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803177:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317e:	a1 38 50 80 00       	mov    0x805038,%eax
  803183:	40                   	inc    %eax
  803184:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803189:	83 ec 0c             	sub    $0xc,%esp
  80318c:	ff 75 10             	pushl  0x10(%ebp)
  80318f:	e8 d6 ed ff ff       	call   801f6a <get_block_size>
  803194:	83 c4 10             	add    $0x10,%esp
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	6a 00                	push   $0x0
  80319c:	50                   	push   %eax
  80319d:	ff 75 10             	pushl  0x10(%ebp)
  8031a0:	e8 16 f1 ff ff       	call   8022bb <set_block_data>
  8031a5:	83 c4 10             	add    $0x10,%esp
	}
}
  8031a8:	90                   	nop
  8031a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031ac:	c9                   	leave  
  8031ad:	c3                   	ret    

008031ae <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031ae:	55                   	push   %ebp
  8031af:	89 e5                	mov    %esp,%ebp
  8031b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031bc:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c4:	73 1b                	jae    8031e1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031cb:	83 ec 04             	sub    $0x4,%esp
  8031ce:	ff 75 08             	pushl  0x8(%ebp)
  8031d1:	6a 00                	push   $0x0
  8031d3:	50                   	push   %eax
  8031d4:	e8 b2 fb ff ff       	call   802d8b <merging>
  8031d9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031dc:	e9 8b 00 00 00       	jmp    80326c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e9:	76 18                	jbe    803203 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	ff 75 08             	pushl  0x8(%ebp)
  8031f6:	50                   	push   %eax
  8031f7:	6a 00                	push   $0x0
  8031f9:	e8 8d fb ff ff       	call   802d8b <merging>
  8031fe:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803201:	eb 69                	jmp    80326c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803203:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320b:	eb 39                	jmp    803246 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	3b 45 08             	cmp    0x8(%ebp),%eax
  803213:	73 29                	jae    80323e <free_block+0x90>
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321d:	76 1f                	jbe    80323e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	ff 75 08             	pushl  0x8(%ebp)
  80322d:	ff 75 f0             	pushl  -0x10(%ebp)
  803230:	ff 75 f4             	pushl  -0xc(%ebp)
  803233:	e8 53 fb ff ff       	call   802d8b <merging>
  803238:	83 c4 10             	add    $0x10,%esp
			break;
  80323b:	90                   	nop
		}
	}
}
  80323c:	eb 2e                	jmp    80326c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80323e:	a1 34 50 80 00       	mov    0x805034,%eax
  803243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324a:	74 07                	je     803253 <free_block+0xa5>
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	eb 05                	jmp    803258 <free_block+0xaa>
  803253:	b8 00 00 00 00       	mov    $0x0,%eax
  803258:	a3 34 50 80 00       	mov    %eax,0x805034
  80325d:	a1 34 50 80 00       	mov    0x805034,%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	75 a7                	jne    80320d <free_block+0x5f>
  803266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326a:	75 a1                	jne    80320d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80326c:	90                   	nop
  80326d:	c9                   	leave  
  80326e:	c3                   	ret    

0080326f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80326f:	55                   	push   %ebp
  803270:	89 e5                	mov    %esp,%ebp
  803272:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803275:	ff 75 08             	pushl  0x8(%ebp)
  803278:	e8 ed ec ff ff       	call   801f6a <get_block_size>
  80327d:	83 c4 04             	add    $0x4,%esp
  803280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80328a:	eb 17                	jmp    8032a3 <copy_data+0x34>
  80328c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80328f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803292:	01 c2                	add    %eax,%edx
  803294:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	01 c8                	add    %ecx,%eax
  80329c:	8a 00                	mov    (%eax),%al
  80329e:	88 02                	mov    %al,(%edx)
  8032a0:	ff 45 fc             	incl   -0x4(%ebp)
  8032a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032a9:	72 e1                	jb     80328c <copy_data+0x1d>
}
  8032ab:	90                   	nop
  8032ac:	c9                   	leave  
  8032ad:	c3                   	ret    

008032ae <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032ae:	55                   	push   %ebp
  8032af:	89 e5                	mov    %esp,%ebp
  8032b1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b8:	75 23                	jne    8032dd <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032be:	74 13                	je     8032d3 <realloc_block_FF+0x25>
  8032c0:	83 ec 0c             	sub    $0xc,%esp
  8032c3:	ff 75 0c             	pushl  0xc(%ebp)
  8032c6:	e8 1f f0 ff ff       	call   8022ea <alloc_block_FF>
  8032cb:	83 c4 10             	add    $0x10,%esp
  8032ce:	e9 f4 06 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
		return NULL;
  8032d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d8:	e9 ea 06 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032e1:	75 18                	jne    8032fb <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032e3:	83 ec 0c             	sub    $0xc,%esp
  8032e6:	ff 75 08             	pushl  0x8(%ebp)
  8032e9:	e8 c0 fe ff ff       	call   8031ae <free_block>
  8032ee:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f6:	e9 cc 06 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032fb:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032ff:	77 07                	ja     803308 <realloc_block_FF+0x5a>
  803301:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330b:	83 e0 01             	and    $0x1,%eax
  80330e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803311:	8b 45 0c             	mov    0xc(%ebp),%eax
  803314:	83 c0 08             	add    $0x8,%eax
  803317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80331a:	83 ec 0c             	sub    $0xc,%esp
  80331d:	ff 75 08             	pushl  0x8(%ebp)
  803320:	e8 45 ec ff ff       	call   801f6a <get_block_size>
  803325:	83 c4 10             	add    $0x10,%esp
  803328:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	83 e8 08             	sub    $0x8,%eax
  803331:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	83 e8 04             	sub    $0x4,%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	83 e0 fe             	and    $0xfffffffe,%eax
  80333f:	89 c2                	mov    %eax,%edx
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	01 d0                	add    %edx,%eax
  803346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803349:	83 ec 0c             	sub    $0xc,%esp
  80334c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80334f:	e8 16 ec ff ff       	call   801f6a <get_block_size>
  803354:	83 c4 10             	add    $0x10,%esp
  803357:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80335a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335d:	83 e8 08             	sub    $0x8,%eax
  803360:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803363:	8b 45 0c             	mov    0xc(%ebp),%eax
  803366:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803369:	75 08                	jne    803373 <realloc_block_FF+0xc5>
	{
		 return va;
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	e9 54 06 00 00       	jmp    8039c7 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803373:	8b 45 0c             	mov    0xc(%ebp),%eax
  803376:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803379:	0f 83 e5 03 00 00    	jae    803764 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	2b 45 0c             	sub    0xc(%ebp),%eax
  803385:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803388:	83 ec 0c             	sub    $0xc,%esp
  80338b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80338e:	e8 f0 eb ff ff       	call   801f83 <is_free_block>
  803393:	83 c4 10             	add    $0x10,%esp
  803396:	84 c0                	test   %al,%al
  803398:	0f 84 3b 01 00 00    	je     8034d9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80339e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a4:	01 d0                	add    %edx,%eax
  8033a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	6a 01                	push   $0x1
  8033ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b1:	ff 75 08             	pushl  0x8(%ebp)
  8033b4:	e8 02 ef ff ff       	call   8022bb <set_block_data>
  8033b9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	83 e8 04             	sub    $0x4,%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c7:	89 c2                	mov    %eax,%edx
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	01 d0                	add    %edx,%eax
  8033ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	6a 00                	push   $0x0
  8033d6:	ff 75 cc             	pushl  -0x34(%ebp)
  8033d9:	ff 75 c8             	pushl  -0x38(%ebp)
  8033dc:	e8 da ee ff ff       	call   8022bb <set_block_data>
  8033e1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033e8:	74 06                	je     8033f0 <realloc_block_FF+0x142>
  8033ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033ee:	75 17                	jne    803407 <realloc_block_FF+0x159>
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 18 46 80 00       	push   $0x804618
  8033f8:	68 f6 01 00 00       	push   $0x1f6
  8033fd:	68 a5 45 80 00       	push   $0x8045a5
  803402:	e8 1b d0 ff ff       	call   800422 <_panic>
  803407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340a:	8b 10                	mov    (%eax),%edx
  80340c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80340f:	89 10                	mov    %edx,(%eax)
  803411:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	74 0b                	je     803425 <realloc_block_FF+0x177>
  80341a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803422:	89 50 04             	mov    %edx,0x4(%eax)
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342b:	89 10                	mov    %edx,(%eax)
  80342d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	75 08                	jne    803447 <realloc_block_FF+0x199>
  80343f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803442:	a3 30 50 80 00       	mov    %eax,0x805030
  803447:	a1 38 50 80 00       	mov    0x805038,%eax
  80344c:	40                   	inc    %eax
  80344d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803452:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803456:	75 17                	jne    80346f <realloc_block_FF+0x1c1>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 87 45 80 00       	push   $0x804587
  803460:	68 f7 01 00 00       	push   $0x1f7
  803465:	68 a5 45 80 00       	push   $0x8045a5
  80346a:	e8 b3 cf ff ff       	call   800422 <_panic>
  80346f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	74 10                	je     803488 <realloc_block_FF+0x1da>
  803478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803480:	8b 52 04             	mov    0x4(%edx),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	eb 0b                	jmp    803493 <realloc_block_FF+0x1e5>
  803488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348b:	8b 40 04             	mov    0x4(%eax),%eax
  80348e:	a3 30 50 80 00       	mov    %eax,0x805030
  803493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803496:	8b 40 04             	mov    0x4(%eax),%eax
  803499:	85 c0                	test   %eax,%eax
  80349b:	74 0f                	je     8034ac <realloc_block_FF+0x1fe>
  80349d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a6:	8b 12                	mov    (%edx),%edx
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	eb 0a                	jmp    8034b6 <realloc_block_FF+0x208>
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ce:	48                   	dec    %eax
  8034cf:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d4:	e9 83 02 00 00       	jmp    80375c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034d9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034dd:	0f 86 69 02 00 00    	jbe    80374c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034e3:	83 ec 04             	sub    $0x4,%esp
  8034e6:	6a 01                	push   $0x1
  8034e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034eb:	ff 75 08             	pushl  0x8(%ebp)
  8034ee:	e8 c8 ed ff ff       	call   8022bb <set_block_data>
  8034f3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	83 e8 04             	sub    $0x4,%eax
  8034fc:	8b 00                	mov    (%eax),%eax
  8034fe:	83 e0 fe             	and    $0xfffffffe,%eax
  803501:	89 c2                	mov    %eax,%edx
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	01 d0                	add    %edx,%eax
  803508:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80350b:	a1 38 50 80 00       	mov    0x805038,%eax
  803510:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803513:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803517:	75 68                	jne    803581 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803519:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80351d:	75 17                	jne    803536 <realloc_block_FF+0x288>
  80351f:	83 ec 04             	sub    $0x4,%esp
  803522:	68 c0 45 80 00       	push   $0x8045c0
  803527:	68 06 02 00 00       	push   $0x206
  80352c:	68 a5 45 80 00       	push   $0x8045a5
  803531:	e8 ec ce ff ff       	call   800422 <_panic>
  803536:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80353c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353f:	89 10                	mov    %edx,(%eax)
  803541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	85 c0                	test   %eax,%eax
  803548:	74 0d                	je     803557 <realloc_block_FF+0x2a9>
  80354a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80354f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803552:	89 50 04             	mov    %edx,0x4(%eax)
  803555:	eb 08                	jmp    80355f <realloc_block_FF+0x2b1>
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	a3 30 50 80 00       	mov    %eax,0x805030
  80355f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803562:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 38 50 80 00       	mov    0x805038,%eax
  803576:	40                   	inc    %eax
  803577:	a3 38 50 80 00       	mov    %eax,0x805038
  80357c:	e9 b0 01 00 00       	jmp    803731 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803581:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803586:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803589:	76 68                	jbe    8035f3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80358b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80358f:	75 17                	jne    8035a8 <realloc_block_FF+0x2fa>
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	68 c0 45 80 00       	push   $0x8045c0
  803599:	68 0b 02 00 00       	push   $0x20b
  80359e:	68 a5 45 80 00       	push   $0x8045a5
  8035a3:	e8 7a ce ff ff       	call   800422 <_panic>
  8035a8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 0d                	je     8035c9 <realloc_block_FF+0x31b>
  8035bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c4:	89 50 04             	mov    %edx,0x4(%eax)
  8035c7:	eb 08                	jmp    8035d1 <realloc_block_FF+0x323>
  8035c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e8:	40                   	inc    %eax
  8035e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ee:	e9 3e 01 00 00       	jmp    803731 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035fb:	73 68                	jae    803665 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803601:	75 17                	jne    80361a <realloc_block_FF+0x36c>
  803603:	83 ec 04             	sub    $0x4,%esp
  803606:	68 f4 45 80 00       	push   $0x8045f4
  80360b:	68 10 02 00 00       	push   $0x210
  803610:	68 a5 45 80 00       	push   $0x8045a5
  803615:	e8 08 ce ff ff       	call   800422 <_panic>
  80361a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803623:	89 50 04             	mov    %edx,0x4(%eax)
  803626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803629:	8b 40 04             	mov    0x4(%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0c                	je     80363c <realloc_block_FF+0x38e>
  803630:	a1 30 50 80 00       	mov    0x805030,%eax
  803635:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	eb 08                	jmp    803644 <realloc_block_FF+0x396>
  80363c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803647:	a3 30 50 80 00       	mov    %eax,0x805030
  80364c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803655:	a1 38 50 80 00       	mov    0x805038,%eax
  80365a:	40                   	inc    %eax
  80365b:	a3 38 50 80 00       	mov    %eax,0x805038
  803660:	e9 cc 00 00 00       	jmp    803731 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80366c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803674:	e9 8a 00 00 00       	jmp    803703 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80367f:	73 7a                	jae    8036fb <realloc_block_FF+0x44d>
  803681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803689:	73 70                	jae    8036fb <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80368b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368f:	74 06                	je     803697 <realloc_block_FF+0x3e9>
  803691:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803695:	75 17                	jne    8036ae <realloc_block_FF+0x400>
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 18 46 80 00       	push   $0x804618
  80369f:	68 1a 02 00 00       	push   $0x21a
  8036a4:	68 a5 45 80 00       	push   $0x8045a5
  8036a9:	e8 74 cd ff ff       	call   800422 <_panic>
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	8b 10                	mov    (%eax),%edx
  8036b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b6:	89 10                	mov    %edx,(%eax)
  8036b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	85 c0                	test   %eax,%eax
  8036bf:	74 0b                	je     8036cc <realloc_block_FF+0x41e>
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036c9:	89 50 04             	mov    %edx,0x4(%eax)
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d2:	89 10                	mov    %edx,(%eax)
  8036d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036da:	89 50 04             	mov    %edx,0x4(%eax)
  8036dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	75 08                	jne    8036ee <realloc_block_FF+0x440>
  8036e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f3:	40                   	inc    %eax
  8036f4:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036f9:	eb 36                	jmp    803731 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036fb:	a1 34 50 80 00       	mov    0x805034,%eax
  803700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803707:	74 07                	je     803710 <realloc_block_FF+0x462>
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	eb 05                	jmp    803715 <realloc_block_FF+0x467>
  803710:	b8 00 00 00 00       	mov    $0x0,%eax
  803715:	a3 34 50 80 00       	mov    %eax,0x805034
  80371a:	a1 34 50 80 00       	mov    0x805034,%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	0f 85 52 ff ff ff    	jne    803679 <realloc_block_FF+0x3cb>
  803727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372b:	0f 85 48 ff ff ff    	jne    803679 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	6a 00                	push   $0x0
  803736:	ff 75 d8             	pushl  -0x28(%ebp)
  803739:	ff 75 d4             	pushl  -0x2c(%ebp)
  80373c:	e8 7a eb ff ff       	call   8022bb <set_block_data>
  803741:	83 c4 10             	add    $0x10,%esp
				return va;
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	e9 7b 02 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80374c:	83 ec 0c             	sub    $0xc,%esp
  80374f:	68 95 46 80 00       	push   $0x804695
  803754:	e8 86 cf ff ff       	call   8006df <cprintf>
  803759:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	e9 63 02 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803764:	8b 45 0c             	mov    0xc(%ebp),%eax
  803767:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80376a:	0f 86 4d 02 00 00    	jbe    8039bd <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803770:	83 ec 0c             	sub    $0xc,%esp
  803773:	ff 75 e4             	pushl  -0x1c(%ebp)
  803776:	e8 08 e8 ff ff       	call   801f83 <is_free_block>
  80377b:	83 c4 10             	add    $0x10,%esp
  80377e:	84 c0                	test   %al,%al
  803780:	0f 84 37 02 00 00    	je     8039bd <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803786:	8b 45 0c             	mov    0xc(%ebp),%eax
  803789:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80378c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80378f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803792:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803795:	76 38                	jbe    8037cf <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803797:	83 ec 0c             	sub    $0xc,%esp
  80379a:	ff 75 08             	pushl  0x8(%ebp)
  80379d:	e8 0c fa ff ff       	call   8031ae <free_block>
  8037a2:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037a5:	83 ec 0c             	sub    $0xc,%esp
  8037a8:	ff 75 0c             	pushl  0xc(%ebp)
  8037ab:	e8 3a eb ff ff       	call   8022ea <alloc_block_FF>
  8037b0:	83 c4 10             	add    $0x10,%esp
  8037b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037b6:	83 ec 08             	sub    $0x8,%esp
  8037b9:	ff 75 c0             	pushl  -0x40(%ebp)
  8037bc:	ff 75 08             	pushl  0x8(%ebp)
  8037bf:	e8 ab fa ff ff       	call   80326f <copy_data>
  8037c4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037ca:	e9 f8 01 00 00       	jmp    8039c7 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037d8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037dc:	0f 87 a0 00 00 00    	ja     803882 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e6:	75 17                	jne    8037ff <realloc_block_FF+0x551>
  8037e8:	83 ec 04             	sub    $0x4,%esp
  8037eb:	68 87 45 80 00       	push   $0x804587
  8037f0:	68 38 02 00 00       	push   $0x238
  8037f5:	68 a5 45 80 00       	push   $0x8045a5
  8037fa:	e8 23 cc ff ff       	call   800422 <_panic>
  8037ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803802:	8b 00                	mov    (%eax),%eax
  803804:	85 c0                	test   %eax,%eax
  803806:	74 10                	je     803818 <realloc_block_FF+0x56a>
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803810:	8b 52 04             	mov    0x4(%edx),%edx
  803813:	89 50 04             	mov    %edx,0x4(%eax)
  803816:	eb 0b                	jmp    803823 <realloc_block_FF+0x575>
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	8b 40 04             	mov    0x4(%eax),%eax
  80381e:	a3 30 50 80 00       	mov    %eax,0x805030
  803823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803826:	8b 40 04             	mov    0x4(%eax),%eax
  803829:	85 c0                	test   %eax,%eax
  80382b:	74 0f                	je     80383c <realloc_block_FF+0x58e>
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 40 04             	mov    0x4(%eax),%eax
  803833:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803836:	8b 12                	mov    (%edx),%edx
  803838:	89 10                	mov    %edx,(%eax)
  80383a:	eb 0a                	jmp    803846 <realloc_block_FF+0x598>
  80383c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803852:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803859:	a1 38 50 80 00       	mov    0x805038,%eax
  80385e:	48                   	dec    %eax
  80385f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803864:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386a:	01 d0                	add    %edx,%eax
  80386c:	83 ec 04             	sub    $0x4,%esp
  80386f:	6a 01                	push   $0x1
  803871:	50                   	push   %eax
  803872:	ff 75 08             	pushl  0x8(%ebp)
  803875:	e8 41 ea ff ff       	call   8022bb <set_block_data>
  80387a:	83 c4 10             	add    $0x10,%esp
  80387d:	e9 36 01 00 00       	jmp    8039b8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803882:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803885:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803888:	01 d0                	add    %edx,%eax
  80388a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80388d:	83 ec 04             	sub    $0x4,%esp
  803890:	6a 01                	push   $0x1
  803892:	ff 75 f0             	pushl  -0x10(%ebp)
  803895:	ff 75 08             	pushl  0x8(%ebp)
  803898:	e8 1e ea ff ff       	call   8022bb <set_block_data>
  80389d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	83 e8 04             	sub    $0x4,%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8038ab:	89 c2                	mov    %eax,%edx
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038b9:	74 06                	je     8038c1 <realloc_block_FF+0x613>
  8038bb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038bf:	75 17                	jne    8038d8 <realloc_block_FF+0x62a>
  8038c1:	83 ec 04             	sub    $0x4,%esp
  8038c4:	68 18 46 80 00       	push   $0x804618
  8038c9:	68 44 02 00 00       	push   $0x244
  8038ce:	68 a5 45 80 00       	push   $0x8045a5
  8038d3:	e8 4a cb ff ff       	call   800422 <_panic>
  8038d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038db:	8b 10                	mov    (%eax),%edx
  8038dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e0:	89 10                	mov    %edx,(%eax)
  8038e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	74 0b                	je     8038f6 <realloc_block_FF+0x648>
  8038eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038f3:	89 50 04             	mov    %edx,0x4(%eax)
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fc:	89 10                	mov    %edx,(%eax)
  8038fe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803901:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803904:	89 50 04             	mov    %edx,0x4(%eax)
  803907:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	75 08                	jne    803918 <realloc_block_FF+0x66a>
  803910:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803913:	a3 30 50 80 00       	mov    %eax,0x805030
  803918:	a1 38 50 80 00       	mov    0x805038,%eax
  80391d:	40                   	inc    %eax
  80391e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803923:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803927:	75 17                	jne    803940 <realloc_block_FF+0x692>
  803929:	83 ec 04             	sub    $0x4,%esp
  80392c:	68 87 45 80 00       	push   $0x804587
  803931:	68 45 02 00 00       	push   $0x245
  803936:	68 a5 45 80 00       	push   $0x8045a5
  80393b:	e8 e2 ca ff ff       	call   800422 <_panic>
  803940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	74 10                	je     803959 <realloc_block_FF+0x6ab>
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803951:	8b 52 04             	mov    0x4(%edx),%edx
  803954:	89 50 04             	mov    %edx,0x4(%eax)
  803957:	eb 0b                	jmp    803964 <realloc_block_FF+0x6b6>
  803959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395c:	8b 40 04             	mov    0x4(%eax),%eax
  80395f:	a3 30 50 80 00       	mov    %eax,0x805030
  803964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803967:	8b 40 04             	mov    0x4(%eax),%eax
  80396a:	85 c0                	test   %eax,%eax
  80396c:	74 0f                	je     80397d <realloc_block_FF+0x6cf>
  80396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803971:	8b 40 04             	mov    0x4(%eax),%eax
  803974:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803977:	8b 12                	mov    (%edx),%edx
  803979:	89 10                	mov    %edx,(%eax)
  80397b:	eb 0a                	jmp    803987 <realloc_block_FF+0x6d9>
  80397d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803993:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399a:	a1 38 50 80 00       	mov    0x805038,%eax
  80399f:	48                   	dec    %eax
  8039a0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039a5:	83 ec 04             	sub    $0x4,%esp
  8039a8:	6a 00                	push   $0x0
  8039aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8039ad:	ff 75 b8             	pushl  -0x48(%ebp)
  8039b0:	e8 06 e9 ff ff       	call   8022bb <set_block_data>
  8039b5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	eb 0a                	jmp    8039c7 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039bd:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039c7:	c9                   	leave  
  8039c8:	c3                   	ret    

008039c9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039c9:	55                   	push   %ebp
  8039ca:	89 e5                	mov    %esp,%ebp
  8039cc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039cf:	83 ec 04             	sub    $0x4,%esp
  8039d2:	68 9c 46 80 00       	push   $0x80469c
  8039d7:	68 58 02 00 00       	push   $0x258
  8039dc:	68 a5 45 80 00       	push   $0x8045a5
  8039e1:	e8 3c ca ff ff       	call   800422 <_panic>

008039e6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039e6:	55                   	push   %ebp
  8039e7:	89 e5                	mov    %esp,%ebp
  8039e9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 c4 46 80 00       	push   $0x8046c4
  8039f4:	68 61 02 00 00       	push   $0x261
  8039f9:	68 a5 45 80 00       	push   $0x8045a5
  8039fe:	e8 1f ca ff ff       	call   800422 <_panic>
  803a03:	90                   	nop

00803a04 <__udivdi3>:
  803a04:	55                   	push   %ebp
  803a05:	57                   	push   %edi
  803a06:	56                   	push   %esi
  803a07:	53                   	push   %ebx
  803a08:	83 ec 1c             	sub    $0x1c,%esp
  803a0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a1b:	89 ca                	mov    %ecx,%edx
  803a1d:	89 f8                	mov    %edi,%eax
  803a1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a23:	85 f6                	test   %esi,%esi
  803a25:	75 2d                	jne    803a54 <__udivdi3+0x50>
  803a27:	39 cf                	cmp    %ecx,%edi
  803a29:	77 65                	ja     803a90 <__udivdi3+0x8c>
  803a2b:	89 fd                	mov    %edi,%ebp
  803a2d:	85 ff                	test   %edi,%edi
  803a2f:	75 0b                	jne    803a3c <__udivdi3+0x38>
  803a31:	b8 01 00 00 00       	mov    $0x1,%eax
  803a36:	31 d2                	xor    %edx,%edx
  803a38:	f7 f7                	div    %edi
  803a3a:	89 c5                	mov    %eax,%ebp
  803a3c:	31 d2                	xor    %edx,%edx
  803a3e:	89 c8                	mov    %ecx,%eax
  803a40:	f7 f5                	div    %ebp
  803a42:	89 c1                	mov    %eax,%ecx
  803a44:	89 d8                	mov    %ebx,%eax
  803a46:	f7 f5                	div    %ebp
  803a48:	89 cf                	mov    %ecx,%edi
  803a4a:	89 fa                	mov    %edi,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	39 ce                	cmp    %ecx,%esi
  803a56:	77 28                	ja     803a80 <__udivdi3+0x7c>
  803a58:	0f bd fe             	bsr    %esi,%edi
  803a5b:	83 f7 1f             	xor    $0x1f,%edi
  803a5e:	75 40                	jne    803aa0 <__udivdi3+0x9c>
  803a60:	39 ce                	cmp    %ecx,%esi
  803a62:	72 0a                	jb     803a6e <__udivdi3+0x6a>
  803a64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a68:	0f 87 9e 00 00 00    	ja     803b0c <__udivdi3+0x108>
  803a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a73:	89 fa                	mov    %edi,%edx
  803a75:	83 c4 1c             	add    $0x1c,%esp
  803a78:	5b                   	pop    %ebx
  803a79:	5e                   	pop    %esi
  803a7a:	5f                   	pop    %edi
  803a7b:	5d                   	pop    %ebp
  803a7c:	c3                   	ret    
  803a7d:	8d 76 00             	lea    0x0(%esi),%esi
  803a80:	31 ff                	xor    %edi,%edi
  803a82:	31 c0                	xor    %eax,%eax
  803a84:	89 fa                	mov    %edi,%edx
  803a86:	83 c4 1c             	add    $0x1c,%esp
  803a89:	5b                   	pop    %ebx
  803a8a:	5e                   	pop    %esi
  803a8b:	5f                   	pop    %edi
  803a8c:	5d                   	pop    %ebp
  803a8d:	c3                   	ret    
  803a8e:	66 90                	xchg   %ax,%ax
  803a90:	89 d8                	mov    %ebx,%eax
  803a92:	f7 f7                	div    %edi
  803a94:	31 ff                	xor    %edi,%edi
  803a96:	89 fa                	mov    %edi,%edx
  803a98:	83 c4 1c             	add    $0x1c,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5e                   	pop    %esi
  803a9d:	5f                   	pop    %edi
  803a9e:	5d                   	pop    %ebp
  803a9f:	c3                   	ret    
  803aa0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aa5:	89 eb                	mov    %ebp,%ebx
  803aa7:	29 fb                	sub    %edi,%ebx
  803aa9:	89 f9                	mov    %edi,%ecx
  803aab:	d3 e6                	shl    %cl,%esi
  803aad:	89 c5                	mov    %eax,%ebp
  803aaf:	88 d9                	mov    %bl,%cl
  803ab1:	d3 ed                	shr    %cl,%ebp
  803ab3:	89 e9                	mov    %ebp,%ecx
  803ab5:	09 f1                	or     %esi,%ecx
  803ab7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803abb:	89 f9                	mov    %edi,%ecx
  803abd:	d3 e0                	shl    %cl,%eax
  803abf:	89 c5                	mov    %eax,%ebp
  803ac1:	89 d6                	mov    %edx,%esi
  803ac3:	88 d9                	mov    %bl,%cl
  803ac5:	d3 ee                	shr    %cl,%esi
  803ac7:	89 f9                	mov    %edi,%ecx
  803ac9:	d3 e2                	shl    %cl,%edx
  803acb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acf:	88 d9                	mov    %bl,%cl
  803ad1:	d3 e8                	shr    %cl,%eax
  803ad3:	09 c2                	or     %eax,%edx
  803ad5:	89 d0                	mov    %edx,%eax
  803ad7:	89 f2                	mov    %esi,%edx
  803ad9:	f7 74 24 0c          	divl   0xc(%esp)
  803add:	89 d6                	mov    %edx,%esi
  803adf:	89 c3                	mov    %eax,%ebx
  803ae1:	f7 e5                	mul    %ebp
  803ae3:	39 d6                	cmp    %edx,%esi
  803ae5:	72 19                	jb     803b00 <__udivdi3+0xfc>
  803ae7:	74 0b                	je     803af4 <__udivdi3+0xf0>
  803ae9:	89 d8                	mov    %ebx,%eax
  803aeb:	31 ff                	xor    %edi,%edi
  803aed:	e9 58 ff ff ff       	jmp    803a4a <__udivdi3+0x46>
  803af2:	66 90                	xchg   %ax,%ax
  803af4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803af8:	89 f9                	mov    %edi,%ecx
  803afa:	d3 e2                	shl    %cl,%edx
  803afc:	39 c2                	cmp    %eax,%edx
  803afe:	73 e9                	jae    803ae9 <__udivdi3+0xe5>
  803b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b03:	31 ff                	xor    %edi,%edi
  803b05:	e9 40 ff ff ff       	jmp    803a4a <__udivdi3+0x46>
  803b0a:	66 90                	xchg   %ax,%ax
  803b0c:	31 c0                	xor    %eax,%eax
  803b0e:	e9 37 ff ff ff       	jmp    803a4a <__udivdi3+0x46>
  803b13:	90                   	nop

00803b14 <__umoddi3>:
  803b14:	55                   	push   %ebp
  803b15:	57                   	push   %edi
  803b16:	56                   	push   %esi
  803b17:	53                   	push   %ebx
  803b18:	83 ec 1c             	sub    $0x1c,%esp
  803b1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b33:	89 f3                	mov    %esi,%ebx
  803b35:	89 fa                	mov    %edi,%edx
  803b37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b3b:	89 34 24             	mov    %esi,(%esp)
  803b3e:	85 c0                	test   %eax,%eax
  803b40:	75 1a                	jne    803b5c <__umoddi3+0x48>
  803b42:	39 f7                	cmp    %esi,%edi
  803b44:	0f 86 a2 00 00 00    	jbe    803bec <__umoddi3+0xd8>
  803b4a:	89 c8                	mov    %ecx,%eax
  803b4c:	89 f2                	mov    %esi,%edx
  803b4e:	f7 f7                	div    %edi
  803b50:	89 d0                	mov    %edx,%eax
  803b52:	31 d2                	xor    %edx,%edx
  803b54:	83 c4 1c             	add    $0x1c,%esp
  803b57:	5b                   	pop    %ebx
  803b58:	5e                   	pop    %esi
  803b59:	5f                   	pop    %edi
  803b5a:	5d                   	pop    %ebp
  803b5b:	c3                   	ret    
  803b5c:	39 f0                	cmp    %esi,%eax
  803b5e:	0f 87 ac 00 00 00    	ja     803c10 <__umoddi3+0xfc>
  803b64:	0f bd e8             	bsr    %eax,%ebp
  803b67:	83 f5 1f             	xor    $0x1f,%ebp
  803b6a:	0f 84 ac 00 00 00    	je     803c1c <__umoddi3+0x108>
  803b70:	bf 20 00 00 00       	mov    $0x20,%edi
  803b75:	29 ef                	sub    %ebp,%edi
  803b77:	89 fe                	mov    %edi,%esi
  803b79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b7d:	89 e9                	mov    %ebp,%ecx
  803b7f:	d3 e0                	shl    %cl,%eax
  803b81:	89 d7                	mov    %edx,%edi
  803b83:	89 f1                	mov    %esi,%ecx
  803b85:	d3 ef                	shr    %cl,%edi
  803b87:	09 c7                	or     %eax,%edi
  803b89:	89 e9                	mov    %ebp,%ecx
  803b8b:	d3 e2                	shl    %cl,%edx
  803b8d:	89 14 24             	mov    %edx,(%esp)
  803b90:	89 d8                	mov    %ebx,%eax
  803b92:	d3 e0                	shl    %cl,%eax
  803b94:	89 c2                	mov    %eax,%edx
  803b96:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9a:	d3 e0                	shl    %cl,%eax
  803b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba4:	89 f1                	mov    %esi,%ecx
  803ba6:	d3 e8                	shr    %cl,%eax
  803ba8:	09 d0                	or     %edx,%eax
  803baa:	d3 eb                	shr    %cl,%ebx
  803bac:	89 da                	mov    %ebx,%edx
  803bae:	f7 f7                	div    %edi
  803bb0:	89 d3                	mov    %edx,%ebx
  803bb2:	f7 24 24             	mull   (%esp)
  803bb5:	89 c6                	mov    %eax,%esi
  803bb7:	89 d1                	mov    %edx,%ecx
  803bb9:	39 d3                	cmp    %edx,%ebx
  803bbb:	0f 82 87 00 00 00    	jb     803c48 <__umoddi3+0x134>
  803bc1:	0f 84 91 00 00 00    	je     803c58 <__umoddi3+0x144>
  803bc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bcb:	29 f2                	sub    %esi,%edx
  803bcd:	19 cb                	sbb    %ecx,%ebx
  803bcf:	89 d8                	mov    %ebx,%eax
  803bd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bd5:	d3 e0                	shl    %cl,%eax
  803bd7:	89 e9                	mov    %ebp,%ecx
  803bd9:	d3 ea                	shr    %cl,%edx
  803bdb:	09 d0                	or     %edx,%eax
  803bdd:	89 e9                	mov    %ebp,%ecx
  803bdf:	d3 eb                	shr    %cl,%ebx
  803be1:	89 da                	mov    %ebx,%edx
  803be3:	83 c4 1c             	add    $0x1c,%esp
  803be6:	5b                   	pop    %ebx
  803be7:	5e                   	pop    %esi
  803be8:	5f                   	pop    %edi
  803be9:	5d                   	pop    %ebp
  803bea:	c3                   	ret    
  803beb:	90                   	nop
  803bec:	89 fd                	mov    %edi,%ebp
  803bee:	85 ff                	test   %edi,%edi
  803bf0:	75 0b                	jne    803bfd <__umoddi3+0xe9>
  803bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf7:	31 d2                	xor    %edx,%edx
  803bf9:	f7 f7                	div    %edi
  803bfb:	89 c5                	mov    %eax,%ebp
  803bfd:	89 f0                	mov    %esi,%eax
  803bff:	31 d2                	xor    %edx,%edx
  803c01:	f7 f5                	div    %ebp
  803c03:	89 c8                	mov    %ecx,%eax
  803c05:	f7 f5                	div    %ebp
  803c07:	89 d0                	mov    %edx,%eax
  803c09:	e9 44 ff ff ff       	jmp    803b52 <__umoddi3+0x3e>
  803c0e:	66 90                	xchg   %ax,%ax
  803c10:	89 c8                	mov    %ecx,%eax
  803c12:	89 f2                	mov    %esi,%edx
  803c14:	83 c4 1c             	add    $0x1c,%esp
  803c17:	5b                   	pop    %ebx
  803c18:	5e                   	pop    %esi
  803c19:	5f                   	pop    %edi
  803c1a:	5d                   	pop    %ebp
  803c1b:	c3                   	ret    
  803c1c:	3b 04 24             	cmp    (%esp),%eax
  803c1f:	72 06                	jb     803c27 <__umoddi3+0x113>
  803c21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c25:	77 0f                	ja     803c36 <__umoddi3+0x122>
  803c27:	89 f2                	mov    %esi,%edx
  803c29:	29 f9                	sub    %edi,%ecx
  803c2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c2f:	89 14 24             	mov    %edx,(%esp)
  803c32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c36:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c3a:	8b 14 24             	mov    (%esp),%edx
  803c3d:	83 c4 1c             	add    $0x1c,%esp
  803c40:	5b                   	pop    %ebx
  803c41:	5e                   	pop    %esi
  803c42:	5f                   	pop    %edi
  803c43:	5d                   	pop    %ebp
  803c44:	c3                   	ret    
  803c45:	8d 76 00             	lea    0x0(%esi),%esi
  803c48:	2b 04 24             	sub    (%esp),%eax
  803c4b:	19 fa                	sbb    %edi,%edx
  803c4d:	89 d1                	mov    %edx,%ecx
  803c4f:	89 c6                	mov    %eax,%esi
  803c51:	e9 71 ff ff ff       	jmp    803bc7 <__umoddi3+0xb3>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c5c:	72 ea                	jb     803c48 <__umoddi3+0x134>
  803c5e:	89 d9                	mov    %ebx,%ecx
  803c60:	e9 62 ff ff ff       	jmp    803bc7 <__umoddi3+0xb3>
