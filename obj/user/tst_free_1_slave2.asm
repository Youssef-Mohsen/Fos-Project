
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
  800060:	68 e0 3c 80 00       	push   $0x803ce0
  800065:	6a 12                	push   $0x12
  800067:	68 fc 3c 80 00       	push   $0x803cfc
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
  8000bc:	e8 fa 19 00 00       	call   801abb <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 3d 1a 00 00       	call   801b06 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 18 3d 80 00       	push   $0x803d18
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 fc 3c 80 00       	push   $0x803cfc
  800100:	e8 1d 03 00 00       	call   800422 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 fc 19 00 00       	call   801b06 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 48 3d 80 00       	push   $0x803d48
  800117:	6a 32                	push   $0x32
  800119:	68 fc 3c 80 00       	push   $0x803cfc
  80011e:	e8 ff 02 00 00       	call   800422 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 93 19 00 00       	call   801abb <sys_calculate_free_frames>
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
  80015f:	e8 57 19 00 00       	call   801abb <sys_calculate_free_frames>
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
  80017c:	68 78 3d 80 00       	push   $0x803d78
  800181:	6a 3c                	push   $0x3c
  800183:	68 fc 3c 80 00       	push   $0x803cfc
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
  8001c7:	e8 4a 1d 00 00       	call   801f16 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 f4 3d 80 00       	push   $0x803df4
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 fc 3c 80 00       	push   $0x803cfc
  8001e7:	e8 36 02 00 00       	call   800422 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 ca 18 00 00       	call   801abb <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 0d 19 00 00       	call   801b06 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 a3 14 00 00       	call   8016ae <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 f3 18 00 00       	call   801b06 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 14 3e 80 00       	push   $0x803e14
  800220:	6a 4d                	push   $0x4d
  800222:	68 fc 3c 80 00       	push   $0x803cfc
  800227:	e8 f6 01 00 00       	call   800422 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 8a 18 00 00       	call   801abb <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 50 3e 80 00       	push   $0x803e50
  800247:	6a 4e                	push   $0x4e
  800249:	68 fc 3c 80 00       	push   $0x803cfc
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
  80028d:	e8 84 1c 00 00       	call   801f16 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 9c 3e 80 00       	push   $0x803e9c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 fc 3c 80 00       	push   $0x803cfc
  8002ad:	e8 70 01 00 00       	call   800422 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 0b 1b 00 00       	call   801dc2 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 1f 1b 00 00       	call   801ddc <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 f3 1a 00 00       	call   801dc2 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 c0 3e 80 00       	push   $0x803ec0
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 fc 3c 80 00       	push   $0x803cfc
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
  8002e9:	e8 96 19 00 00       	call   801c84 <sys_getenvindex>
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
  800357:	e8 ac 16 00 00       	call   801a08 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 24 3f 80 00       	push   $0x803f24
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
  800387:	68 4c 3f 80 00       	push   $0x803f4c
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
  8003b8:	68 74 3f 80 00       	push   $0x803f74
  8003bd:	e8 1d 03 00 00       	call   8006df <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	50                   	push   %eax
  8003d4:	68 cc 3f 80 00       	push   $0x803fcc
  8003d9:	e8 01 03 00 00       	call   8006df <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 24 3f 80 00       	push   $0x803f24
  8003e9:	e8 f1 02 00 00       	call   8006df <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003f1:	e8 2c 16 00 00       	call   801a22 <sys_unlock_cons>
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
  800409:	e8 42 18 00 00       	call   801c50 <sys_destroy_env>
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
  80041a:	e8 97 18 00 00       	call   801cb6 <sys_exit_env>
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
  800443:	68 e0 3f 80 00       	push   $0x803fe0
  800448:	e8 92 02 00 00       	call   8006df <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800450:	a1 00 50 80 00       	mov    0x805000,%eax
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	50                   	push   %eax
  80045c:	68 e5 3f 80 00       	push   $0x803fe5
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
  800480:	68 01 40 80 00       	push   $0x804001
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
  8004af:	68 04 40 80 00       	push   $0x804004
  8004b4:	6a 26                	push   $0x26
  8004b6:	68 50 40 80 00       	push   $0x804050
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
  800584:	68 5c 40 80 00       	push   $0x80405c
  800589:	6a 3a                	push   $0x3a
  80058b:	68 50 40 80 00       	push   $0x804050
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
  8005f7:	68 b0 40 80 00       	push   $0x8040b0
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 50 40 80 00       	push   $0x804050
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
  800651:	e8 70 13 00 00       	call   8019c6 <sys_cputs>
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
  8006c8:	e8 f9 12 00 00       	call   8019c6 <sys_cputs>
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
  800712:	e8 f1 12 00 00       	call   801a08 <sys_lock_cons>
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
  800732:	e8 eb 12 00 00       	call   801a22 <sys_unlock_cons>
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
  80077c:	e8 df 32 00 00       	call   803a60 <__udivdi3>
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
  8007cc:	e8 9f 33 00 00       	call   803b70 <__umoddi3>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	05 14 43 80 00       	add    $0x804314,%eax
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
  800927:	8b 04 85 38 43 80 00 	mov    0x804338(,%eax,4),%eax
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
  800a08:	8b 34 9d 80 41 80 00 	mov    0x804180(,%ebx,4),%esi
  800a0f:	85 f6                	test   %esi,%esi
  800a11:	75 19                	jne    800a2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a13:	53                   	push   %ebx
  800a14:	68 25 43 80 00       	push   $0x804325
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
  800a2d:	68 2e 43 80 00       	push   $0x80432e
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
  800a5a:	be 31 43 80 00       	mov    $0x804331,%esi
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
  801465:	68 a8 44 80 00       	push   $0x8044a8
  80146a:	68 3f 01 00 00       	push   $0x13f
  80146f:	68 ca 44 80 00       	push   $0x8044ca
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
  801485:	e8 e7 0a 00 00       	call   801f71 <sys_sbrk>
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
  801500:	e8 f0 08 00 00       	call   801df5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	74 16                	je     80151f <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 30 0e 00 00       	call   802344 <alloc_block_FF>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	e9 8a 01 00 00       	jmp    8016a9 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80151f:	e8 02 09 00 00       	call   801e26 <sys_isUHeapPlacementStrategyBESTFIT>
  801524:	85 c0                	test   %eax,%eax
  801526:	0f 84 7d 01 00 00    	je     8016a9 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 c9 12 00 00       	call   802800 <alloc_block_BF>
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
  801582:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8015cf:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801688:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	e8 0b 09 00 00       	call   801fa8 <sys_allocate_user_mem>
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
  8016e0:	e8 df 08 00 00       	call   801fc4 <get_block_size>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 12 1b 00 00       	call   803208 <free_block>
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
  80172b:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801768:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801788:	e8 ff 07 00 00       	call   801f8c <sys_free_user_mem>
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
  801796:	68 d8 44 80 00       	push   $0x8044d8
  80179b:	68 85 00 00 00       	push   $0x85
  8017a0:	68 02 45 80 00       	push   $0x804502
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
  8017bc:	75 0a                	jne    8017c8 <smalloc+0x1c>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 9a 00 00 00       	jmp    801862 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	39 d0                	cmp    %edx,%eax
  8017dd:	73 02                	jae    8017e1 <smalloc+0x35>
  8017df:	89 d0                	mov    %edx,%eax
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	50                   	push   %eax
  8017e5:	e8 a5 fc ff ff       	call   80148f <malloc>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f4:	75 07                	jne    8017fd <smalloc+0x51>
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb 65                	jmp    801862 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017fd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801801:	ff 75 ec             	pushl  -0x14(%ebp)
  801804:	50                   	push   %eax
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 83 03 00 00       	call   801b93 <sys_createSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801816:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80181a:	74 06                	je     801822 <smalloc+0x76>
  80181c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801820:	75 07                	jne    801829 <smalloc+0x7d>
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 39                	jmp    801862 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	ff 75 ec             	pushl  -0x14(%ebp)
  80182f:	68 0e 45 80 00       	push   $0x80450e
  801834:	e8 a6 ee ff ff       	call   8006df <cprintf>
  801839:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80183c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80183f:	a1 20 50 80 00       	mov    0x805020,%eax
  801844:	8b 40 78             	mov    0x78(%eax),%eax
  801847:	29 c2                	sub    %eax,%edx
  801849:	89 d0                	mov    %edx,%eax
  80184b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801850:	c1 e8 0c             	shr    $0xc,%eax
  801853:	89 c2                	mov    %eax,%edx
  801855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801858:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80185f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 45 03 00 00       	call   801bbd <sys_getSizeOfSharedObject>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80187e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801882:	75 07                	jne    80188b <sget+0x27>
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	eb 5c                	jmp    8018e7 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801891:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801898:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	39 d0                	cmp    %edx,%eax
  8018a0:	7d 02                	jge    8018a4 <sget+0x40>
  8018a2:	89 d0                	mov    %edx,%eax
  8018a4:	83 ec 0c             	sub    $0xc,%esp
  8018a7:	50                   	push   %eax
  8018a8:	e8 e2 fb ff ff       	call   80148f <malloc>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018b7:	75 07                	jne    8018c0 <sget+0x5c>
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	eb 27                	jmp    8018e7 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	e8 09 03 00 00       	call   801bda <sys_getSharedObject>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018d7:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018db:	75 07                	jne    8018e4 <sget+0x80>
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	eb 03                	jmp    8018e7 <sget+0x83>
	return ptr;
  8018e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8018f7:	8b 40 78             	mov    0x78(%eax),%eax
  8018fa:	29 c2                	sub    %eax,%edx
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	2d 00 10 00 00       	sub    $0x1000,%eax
  801903:	c1 e8 0c             	shr    $0xc,%eax
  801906:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80190d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	ff 75 f4             	pushl  -0xc(%ebp)
  801919:	e8 db 02 00 00       	call   801bf9 <sys_freeSharedObject>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 20 45 80 00       	push   $0x804520
  801935:	68 dd 00 00 00       	push   $0xdd
  80193a:	68 02 45 80 00       	push   $0x804502
  80193f:	e8 de ea ff ff       	call   800422 <_panic>

00801944 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 46 45 80 00       	push   $0x804546
  801952:	68 e9 00 00 00       	push   $0xe9
  801957:	68 02 45 80 00       	push   $0x804502
  80195c:	e8 c1 ea ff ff       	call   800422 <_panic>

00801961 <shrink>:

}
void shrink(uint32 newSize)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	68 46 45 80 00       	push   $0x804546
  80196f:	68 ee 00 00 00       	push   $0xee
  801974:	68 02 45 80 00       	push   $0x804502
  801979:	e8 a4 ea ff ff       	call   800422 <_panic>

0080197e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	68 46 45 80 00       	push   $0x804546
  80198c:	68 f3 00 00 00       	push   $0xf3
  801991:	68 02 45 80 00       	push   $0x804502
  801996:	e8 87 ea ff ff       	call   800422 <_panic>

0080199b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	57                   	push   %edi
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019b6:	cd 30                	int    $0x30
  8019b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	5b                   	pop    %ebx
  8019c2:	5e                   	pop    %esi
  8019c3:	5f                   	pop    %edi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	50                   	push   %eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	e8 b2 ff ff ff       	call   80199b <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 02                	push   $0x2
  8019fe:	e8 98 ff ff ff       	call   80199b <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 03                	push   $0x3
  801a17:	e8 7f ff ff ff       	call   80199b <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 04                	push   $0x4
  801a31:	e8 65 ff ff ff       	call   80199b <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	52                   	push   %edx
  801a4c:	50                   	push   %eax
  801a4d:	6a 08                	push   $0x8
  801a4f:	e8 47 ff ff ff       	call   80199b <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a5e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	51                   	push   %ecx
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 09                	push   $0x9
  801a74:	e8 22 ff ff ff       	call   80199b <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 0a                	push   $0xa
  801a96:	e8 00 ff ff ff       	call   80199b <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 0b                	push   $0xb
  801ab1:	e8 e5 fe ff ff       	call   80199b <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 0c                	push   $0xc
  801aca:	e8 cc fe ff ff       	call   80199b <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 0d                	push   $0xd
  801ae3:	e8 b3 fe ff ff       	call   80199b <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 0e                	push   $0xe
  801afc:	e8 9a fe ff ff       	call   80199b <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 0f                	push   $0xf
  801b15:	e8 81 fe ff ff       	call   80199b <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 10                	push   $0x10
  801b2f:	e8 67 fe ff ff       	call   80199b <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 11                	push   $0x11
  801b48:	e8 4e fe ff ff       	call   80199b <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	50                   	push   %eax
  801b6c:	6a 01                	push   $0x1
  801b6e:	e8 28 fe ff ff       	call   80199b <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	90                   	nop
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 14                	push   $0x14
  801b88:	e8 0e fe ff ff       	call   80199b <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	51                   	push   %ecx
  801bac:	52                   	push   %edx
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	50                   	push   %eax
  801bb1:	6a 15                	push   $0x15
  801bb3:	e8 e3 fd ff ff       	call   80199b <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 16                	push   $0x16
  801bd0:	e8 c6 fd ff ff       	call   80199b <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	51                   	push   %ecx
  801beb:	52                   	push   %edx
  801bec:	50                   	push   %eax
  801bed:	6a 17                	push   $0x17
  801bef:	e8 a7 fd ff ff       	call   80199b <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 18                	push   $0x18
  801c0c:	e8 8a fd ff ff       	call   80199b <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 14             	pushl  0x14(%ebp)
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	6a 19                	push   $0x19
  801c2a:	e8 6c fd ff ff       	call   80199b <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	50                   	push   %eax
  801c43:	6a 1a                	push   $0x1a
  801c45:	e8 51 fd ff ff       	call   80199b <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	50                   	push   %eax
  801c5f:	6a 1b                	push   $0x1b
  801c61:	e8 35 fd ff ff       	call   80199b <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 05                	push   $0x5
  801c7a:	e8 1c fd ff ff       	call   80199b <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 06                	push   $0x6
  801c93:	e8 03 fd ff ff       	call   80199b <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 07                	push   $0x7
  801cac:	e8 ea fc ff ff       	call   80199b <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 1c                	push   $0x1c
  801cc5:	e8 d1 fc ff ff       	call   80199b <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd9:	8d 50 04             	lea    0x4(%eax),%edx
  801cdc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 1d                	push   $0x1d
  801ce9:	e8 ad fc ff ff       	call   80199b <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfa:	89 01                	mov    %eax,(%ecx)
  801cfc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	c9                   	leave  
  801d03:	c2 04 00             	ret    $0x4

00801d06 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 13                	push   $0x13
  801d18:	e8 7e fc ff ff       	call   80199b <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 1e                	push   $0x1e
  801d32:	e8 64 fc ff ff       	call   80199b <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	50                   	push   %eax
  801d55:	6a 1f                	push   $0x1f
  801d57:	e8 3f fc ff ff       	call   80199b <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <rsttst>:
void rsttst()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 21                	push   $0x21
  801d71:	e8 25 fc ff ff       	call   80199b <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return ;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 14             	mov    0x14(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d88:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 20                	push   $0x20
  801d9c:	e8 fa fb ff ff       	call   80199b <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <chktst>:
void chktst(uint32 n)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 22                	push   $0x22
  801db7:	e8 df fb ff ff       	call   80199b <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <inctst>:

void inctst()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 23                	push   $0x23
  801dd1:	e8 c5 fb ff ff       	call   80199b <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd9:	90                   	nop
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <gettst>:
uint32 gettst()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 24                	push   $0x24
  801deb:	e8 ab fb ff ff       	call   80199b <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 25                	push   $0x25
  801e07:	e8 8f fb ff ff       	call   80199b <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 25                	push   $0x25
  801e38:	e8 5e fb ff ff       	call   80199b <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
  801e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e47:	75 07                	jne    801e50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e49:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4e:	eb 05                	jmp    801e55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 25                	push   $0x25
  801e69:	e8 2d fb ff ff       	call   80199b <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 25                	push   $0x25
  801e9a:	e8 fc fa ff ff       	call   80199b <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea9:	75 07                	jne    801eb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	eb 05                	jmp    801eb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	6a 26                	push   $0x26
  801ec9:	e8 cd fa ff ff       	call   80199b <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed1:	90                   	nop
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	53                   	push   %ebx
  801ee7:	51                   	push   %ecx
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	6a 27                	push   $0x27
  801eec:	e8 aa fa ff ff       	call   80199b <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 28                	push   $0x28
  801f0c:	e8 8a fa ff ff       	call   80199b <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	51                   	push   %ecx
  801f25:	ff 75 10             	pushl  0x10(%ebp)
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	6a 29                	push   $0x29
  801f2c:	e8 6a fa ff ff       	call   80199b <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	ff 75 10             	pushl  0x10(%ebp)
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	ff 75 08             	pushl  0x8(%ebp)
  801f46:	6a 12                	push   $0x12
  801f48:	e8 4e fa ff ff       	call   80199b <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f50:	90                   	nop
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	52                   	push   %edx
  801f63:	50                   	push   %eax
  801f64:	6a 2a                	push   $0x2a
  801f66:	e8 30 fa ff ff       	call   80199b <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
	return;
  801f6e:	90                   	nop
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	50                   	push   %eax
  801f80:	6a 2b                	push   $0x2b
  801f82:	e8 14 fa ff ff       	call   80199b <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	ff 75 08             	pushl  0x8(%ebp)
  801f9b:	6a 2c                	push   $0x2c
  801f9d:	e8 f9 f9 ff ff       	call   80199b <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
	return;
  801fa5:	90                   	nop
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	ff 75 0c             	pushl  0xc(%ebp)
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	6a 2d                	push   $0x2d
  801fb9:	e8 dd f9 ff ff       	call   80199b <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
	return;
  801fc1:	90                   	nop
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	83 e8 04             	sub    $0x4,%eax
  801fd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd6:	8b 00                	mov    (%eax),%eax
  801fd8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	83 e8 04             	sub    $0x4,%eax
  801fe9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fef:	8b 00                	mov    (%eax),%eax
  801ff1:	83 e0 01             	and    $0x1,%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	0f 94 c0             	sete   %al
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802001:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200b:	83 f8 02             	cmp    $0x2,%eax
  80200e:	74 2b                	je     80203b <alloc_block+0x40>
  802010:	83 f8 02             	cmp    $0x2,%eax
  802013:	7f 07                	jg     80201c <alloc_block+0x21>
  802015:	83 f8 01             	cmp    $0x1,%eax
  802018:	74 0e                	je     802028 <alloc_block+0x2d>
  80201a:	eb 58                	jmp    802074 <alloc_block+0x79>
  80201c:	83 f8 03             	cmp    $0x3,%eax
  80201f:	74 2d                	je     80204e <alloc_block+0x53>
  802021:	83 f8 04             	cmp    $0x4,%eax
  802024:	74 3b                	je     802061 <alloc_block+0x66>
  802026:	eb 4c                	jmp    802074 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	e8 11 03 00 00       	call   802344 <alloc_block_FF>
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802039:	eb 4a                	jmp    802085 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	ff 75 08             	pushl  0x8(%ebp)
  802041:	e8 fa 19 00 00       	call   803a40 <alloc_block_NF>
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80204c:	eb 37                	jmp    802085 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	ff 75 08             	pushl  0x8(%ebp)
  802054:	e8 a7 07 00 00       	call   802800 <alloc_block_BF>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80205f:	eb 24                	jmp    802085 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 b7 19 00 00       	call   803a23 <alloc_block_WF>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802072:	eb 11                	jmp    802085 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	68 58 45 80 00       	push   $0x804558
  80207c:	e8 5e e6 ff ff       	call   8006df <cprintf>
  802081:	83 c4 10             	add    $0x10,%esp
		break;
  802084:	90                   	nop
	}
	return va;
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
  80208e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	68 78 45 80 00       	push   $0x804578
  802099:	e8 41 e6 ff ff       	call   8006df <cprintf>
  80209e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 a3 45 80 00       	push   $0x8045a3
  8020a9:	e8 31 e6 ff ff       	call   8006df <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b7:	eb 37                	jmp    8020f0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8020bf:	e8 19 ff ff ff       	call   801fdd <is_free_block>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	0f be d8             	movsbl %al,%ebx
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d0:	e8 ef fe ff ff       	call   801fc4 <get_block_size>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	53                   	push   %ebx
  8020dc:	50                   	push   %eax
  8020dd:	68 bb 45 80 00       	push   $0x8045bb
  8020e2:	e8 f8 e5 ff ff       	call   8006df <cprintf>
  8020e7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f4:	74 07                	je     8020fd <print_blocks_list+0x73>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	eb 05                	jmp    802102 <print_blocks_list+0x78>
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	89 45 10             	mov    %eax,0x10(%ebp)
  802105:	8b 45 10             	mov    0x10(%ebp),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	75 ad                	jne    8020b9 <print_blocks_list+0x2f>
  80210c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802110:	75 a7                	jne    8020b9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802112:	83 ec 0c             	sub    $0xc,%esp
  802115:	68 78 45 80 00       	push   $0x804578
  80211a:	e8 c0 e5 ff ff       	call   8006df <cprintf>
  80211f:	83 c4 10             	add    $0x10,%esp

}
  802122:	90                   	nop
  802123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	83 e0 01             	and    $0x1,%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 03                	je     80213b <initialize_dynamic_allocator+0x13>
  802138:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80213b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80213f:	0f 84 c7 01 00 00    	je     80230c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802145:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80214c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	8b 45 0c             	mov    0xc(%ebp),%eax
  802155:	01 d0                	add    %edx,%eax
  802157:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80215c:	0f 87 ad 01 00 00    	ja     80230f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	0f 89 a5 01 00 00    	jns    802312 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80216d:	8b 55 08             	mov    0x8(%ebp),%edx
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	01 d0                	add    %edx,%eax
  802175:	83 e8 04             	sub    $0x4,%eax
  802178:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80217d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802184:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802189:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218c:	e9 87 00 00 00       	jmp    802218 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802195:	75 14                	jne    8021ab <initialize_dynamic_allocator+0x83>
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	68 d3 45 80 00       	push   $0x8045d3
  80219f:	6a 79                	push   $0x79
  8021a1:	68 f1 45 80 00       	push   $0x8045f1
  8021a6:	e8 77 e2 ff ff       	call   800422 <_panic>
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 10                	je     8021c4 <initialize_dynamic_allocator+0x9c>
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bc:	8b 52 04             	mov    0x4(%edx),%edx
  8021bf:	89 50 04             	mov    %edx,0x4(%eax)
  8021c2:	eb 0b                	jmp    8021cf <initialize_dynamic_allocator+0xa7>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 40 04             	mov    0x4(%eax),%eax
  8021ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 40 04             	mov    0x4(%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 0f                	je     8021e8 <initialize_dynamic_allocator+0xc0>
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 40 04             	mov    0x4(%eax),%eax
  8021df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e2:	8b 12                	mov    (%edx),%edx
  8021e4:	89 10                	mov    %edx,(%eax)
  8021e6:	eb 0a                	jmp    8021f2 <initialize_dynamic_allocator+0xca>
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802205:	a1 38 50 80 00       	mov    0x805038,%eax
  80220a:	48                   	dec    %eax
  80220b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802210:	a1 34 50 80 00       	mov    0x805034,%eax
  802215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221c:	74 07                	je     802225 <initialize_dynamic_allocator+0xfd>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	eb 05                	jmp    80222a <initialize_dynamic_allocator+0x102>
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	a3 34 50 80 00       	mov    %eax,0x805034
  80222f:	a1 34 50 80 00       	mov    0x805034,%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	0f 85 55 ff ff ff    	jne    802191 <initialize_dynamic_allocator+0x69>
  80223c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802240:	0f 85 4b ff ff ff    	jne    802191 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80224c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802255:	a1 44 50 80 00       	mov    0x805044,%eax
  80225a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80225f:	a1 40 50 80 00       	mov    0x805040,%eax
  802264:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	83 c0 08             	add    $0x8,%eax
  802270:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	83 c0 04             	add    $0x4,%eax
  802279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227c:	83 ea 08             	sub    $0x8,%edx
  80227f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802281:	8b 55 0c             	mov    0xc(%ebp),%edx
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	01 d0                	add    %edx,%eax
  802289:	83 e8 08             	sub    $0x8,%eax
  80228c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228f:	83 ea 08             	sub    $0x8,%edx
  802292:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80229d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022ab:	75 17                	jne    8022c4 <initialize_dynamic_allocator+0x19c>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 0c 46 80 00       	push   $0x80460c
  8022b5:	68 90 00 00 00       	push   $0x90
  8022ba:	68 f1 45 80 00       	push   $0x8045f1
  8022bf:	e8 5e e1 ff ff       	call   800422 <_panic>
  8022c4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cd:	89 10                	mov    %edx,(%eax)
  8022cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0d                	je     8022e5 <initialize_dynamic_allocator+0x1bd>
  8022d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022e0:	89 50 04             	mov    %edx,0x4(%eax)
  8022e3:	eb 08                	jmp    8022ed <initialize_dynamic_allocator+0x1c5>
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802304:	40                   	inc    %eax
  802305:	a3 38 50 80 00       	mov    %eax,0x805038
  80230a:	eb 07                	jmp    802313 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80230c:	90                   	nop
  80230d:	eb 04                	jmp    802313 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80230f:	90                   	nop
  802310:	eb 01                	jmp    802313 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802312:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802318:	8b 45 10             	mov    0x10(%ebp),%eax
  80231b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8d 50 fc             	lea    -0x4(%eax),%edx
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	83 e8 04             	sub    $0x4,%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	83 e0 fe             	and    $0xfffffffe,%eax
  802334:	8d 50 f8             	lea    -0x8(%eax),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	01 c2                	add    %eax,%edx
  80233c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233f:	89 02                	mov    %eax,(%edx)
}
  802341:	90                   	nop
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	83 e0 01             	and    $0x1,%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 03                	je     802357 <alloc_block_FF+0x13>
  802354:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802357:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80235b:	77 07                	ja     802364 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80235d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802364:	a1 24 50 80 00       	mov    0x805024,%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	75 73                	jne    8023e0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	83 c0 10             	add    $0x10,%eax
  802373:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802376:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80237d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802383:	01 d0                	add    %edx,%eax
  802385:	48                   	dec    %eax
  802386:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80238c:	ba 00 00 00 00       	mov    $0x0,%edx
  802391:	f7 75 ec             	divl   -0x14(%ebp)
  802394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802397:	29 d0                	sub    %edx,%eax
  802399:	c1 e8 0c             	shr    $0xc,%eax
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	50                   	push   %eax
  8023a0:	e8 d4 f0 ff ff       	call   801479 <sbrk>
  8023a5:	83 c4 10             	add    $0x10,%esp
  8023a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023ab:	83 ec 0c             	sub    $0xc,%esp
  8023ae:	6a 00                	push   $0x0
  8023b0:	e8 c4 f0 ff ff       	call   801479 <sbrk>
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023be:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023c1:	83 ec 08             	sub    $0x8,%esp
  8023c4:	50                   	push   %eax
  8023c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023c8:	e8 5b fd ff ff       	call   802128 <initialize_dynamic_allocator>
  8023cd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023d0:	83 ec 0c             	sub    $0xc,%esp
  8023d3:	68 2f 46 80 00       	push   $0x80462f
  8023d8:	e8 02 e3 ff ff       	call   8006df <cprintf>
  8023dd:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e4:	75 0a                	jne    8023f0 <alloc_block_FF+0xac>
	        return NULL;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	e9 0e 04 00 00       	jmp    8027fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ff:	e9 f3 02 00 00       	jmp    8026f7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80240a:	83 ec 0c             	sub    $0xc,%esp
  80240d:	ff 75 bc             	pushl  -0x44(%ebp)
  802410:	e8 af fb ff ff       	call   801fc4 <get_block_size>
  802415:	83 c4 10             	add    $0x10,%esp
  802418:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	83 c0 08             	add    $0x8,%eax
  802421:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802424:	0f 87 c5 02 00 00    	ja     8026ef <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	83 c0 18             	add    $0x18,%eax
  802430:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802433:	0f 87 19 02 00 00    	ja     802652 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802439:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80243c:	2b 45 08             	sub    0x8(%ebp),%eax
  80243f:	83 e8 08             	sub    $0x8,%eax
  802442:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	8d 50 08             	lea    0x8(%eax),%edx
  80244b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80244e:	01 d0                	add    %edx,%eax
  802450:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	83 c0 08             	add    $0x8,%eax
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	6a 01                	push   $0x1
  80245e:	50                   	push   %eax
  80245f:	ff 75 bc             	pushl  -0x44(%ebp)
  802462:	e8 ae fe ff ff       	call   802315 <set_block_data>
  802467:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 40 04             	mov    0x4(%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	75 68                	jne    8024dc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802474:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802478:	75 17                	jne    802491 <alloc_block_FF+0x14d>
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	68 0c 46 80 00       	push   $0x80460c
  802482:	68 d7 00 00 00       	push   $0xd7
  802487:	68 f1 45 80 00       	push   $0x8045f1
  80248c:	e8 91 df ff ff       	call   800422 <_panic>
  802491:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802497:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249a:	89 10                	mov    %edx,(%eax)
  80249c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	74 0d                	je     8024b2 <alloc_block_FF+0x16e>
  8024a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	eb 08                	jmp    8024ba <alloc_block_FF+0x176>
  8024b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8024d1:	40                   	inc    %eax
  8024d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8024d7:	e9 dc 00 00 00       	jmp    8025b8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	75 65                	jne    80254a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024e5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024e9:	75 17                	jne    802502 <alloc_block_FF+0x1be>
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	68 40 46 80 00       	push   $0x804640
  8024f3:	68 db 00 00 00       	push   $0xdb
  8024f8:	68 f1 45 80 00       	push   $0x8045f1
  8024fd:	e8 20 df ff ff       	call   800422 <_panic>
  802502:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802508:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250b:	89 50 04             	mov    %edx,0x4(%eax)
  80250e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 0c                	je     802524 <alloc_block_FF+0x1e0>
  802518:	a1 30 50 80 00       	mov    0x805030,%eax
  80251d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802520:	89 10                	mov    %edx,(%eax)
  802522:	eb 08                	jmp    80252c <alloc_block_FF+0x1e8>
  802524:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802527:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80252c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252f:	a3 30 50 80 00       	mov    %eax,0x805030
  802534:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253d:	a1 38 50 80 00       	mov    0x805038,%eax
  802542:	40                   	inc    %eax
  802543:	a3 38 50 80 00       	mov    %eax,0x805038
  802548:	eb 6e                	jmp    8025b8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80254a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254e:	74 06                	je     802556 <alloc_block_FF+0x212>
  802550:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802554:	75 17                	jne    80256d <alloc_block_FF+0x229>
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	68 64 46 80 00       	push   $0x804664
  80255e:	68 df 00 00 00       	push   $0xdf
  802563:	68 f1 45 80 00       	push   $0x8045f1
  802568:	e8 b5 de ff ff       	call   800422 <_panic>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 10                	mov    (%eax),%edx
  802572:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802575:	89 10                	mov    %edx,(%eax)
  802577:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 0b                	je     80258b <alloc_block_FF+0x247>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802591:	89 10                	mov    %edx,(%eax)
  802593:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	75 08                	jne    8025ad <alloc_block_FF+0x269>
  8025a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b2:	40                   	inc    %eax
  8025b3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bc:	75 17                	jne    8025d5 <alloc_block_FF+0x291>
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	68 d3 45 80 00       	push   $0x8045d3
  8025c6:	68 e1 00 00 00       	push   $0xe1
  8025cb:	68 f1 45 80 00       	push   $0x8045f1
  8025d0:	e8 4d de ff ff       	call   800422 <_panic>
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	74 10                	je     8025ee <alloc_block_FF+0x2aa>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	8b 52 04             	mov    0x4(%edx),%edx
  8025e9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ec:	eb 0b                	jmp    8025f9 <alloc_block_FF+0x2b5>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 04             	mov    0x4(%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 0f                	je     802612 <alloc_block_FF+0x2ce>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260c:	8b 12                	mov    (%edx),%edx
  80260e:	89 10                	mov    %edx,(%eax)
  802610:	eb 0a                	jmp    80261c <alloc_block_FF+0x2d8>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262f:	a1 38 50 80 00       	mov    0x805038,%eax
  802634:	48                   	dec    %eax
  802635:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	6a 00                	push   $0x0
  80263f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802642:	ff 75 b0             	pushl  -0x50(%ebp)
  802645:	e8 cb fc ff ff       	call   802315 <set_block_data>
  80264a:	83 c4 10             	add    $0x10,%esp
  80264d:	e9 95 00 00 00       	jmp    8026e7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802652:	83 ec 04             	sub    $0x4,%esp
  802655:	6a 01                	push   $0x1
  802657:	ff 75 b8             	pushl  -0x48(%ebp)
  80265a:	ff 75 bc             	pushl  -0x44(%ebp)
  80265d:	e8 b3 fc ff ff       	call   802315 <set_block_data>
  802662:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802669:	75 17                	jne    802682 <alloc_block_FF+0x33e>
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 d3 45 80 00       	push   $0x8045d3
  802673:	68 e8 00 00 00       	push   $0xe8
  802678:	68 f1 45 80 00       	push   $0x8045f1
  80267d:	e8 a0 dd ff ff       	call   800422 <_panic>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	74 10                	je     80269b <alloc_block_FF+0x357>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802693:	8b 52 04             	mov    0x4(%edx),%edx
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	eb 0b                	jmp    8026a6 <alloc_block_FF+0x362>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 04             	mov    0x4(%eax),%eax
  8026a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0f                	je     8026bf <alloc_block_FF+0x37b>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b9:	8b 12                	mov    (%edx),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	eb 0a                	jmp    8026c9 <alloc_block_FF+0x385>
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
	            }
	            return va;
  8026e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ea:	e9 0f 01 00 00       	jmp    8027fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	74 07                	je     802704 <alloc_block_FF+0x3c0>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	eb 05                	jmp    802709 <alloc_block_FF+0x3c5>
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	a3 34 50 80 00       	mov    %eax,0x805034
  80270e:	a1 34 50 80 00       	mov    0x805034,%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	0f 85 e9 fc ff ff    	jne    802404 <alloc_block_FF+0xc0>
  80271b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271f:	0f 85 df fc ff ff    	jne    802404 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	83 c0 08             	add    $0x8,%eax
  80272b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80272e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802735:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802738:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80273b:	01 d0                	add    %edx,%eax
  80273d:	48                   	dec    %eax
  80273e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802744:	ba 00 00 00 00       	mov    $0x0,%edx
  802749:	f7 75 d8             	divl   -0x28(%ebp)
  80274c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274f:	29 d0                	sub    %edx,%eax
  802751:	c1 e8 0c             	shr    $0xc,%eax
  802754:	83 ec 0c             	sub    $0xc,%esp
  802757:	50                   	push   %eax
  802758:	e8 1c ed ff ff       	call   801479 <sbrk>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802763:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802767:	75 0a                	jne    802773 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802769:	b8 00 00 00 00       	mov    $0x0,%eax
  80276e:	e9 8b 00 00 00       	jmp    8027fe <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802773:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80277a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80277d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	48                   	dec    %eax
  802783:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802786:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802789:	ba 00 00 00 00       	mov    $0x0,%edx
  80278e:	f7 75 cc             	divl   -0x34(%ebp)
  802791:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802794:	29 d0                	sub    %edx,%eax
  802796:	8d 50 fc             	lea    -0x4(%eax),%edx
  802799:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027ae:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027bb:	01 d0                	add    %edx,%eax
  8027bd:	48                   	dec    %eax
  8027be:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c9:	f7 75 c4             	divl   -0x3c(%ebp)
  8027cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027cf:	29 d0                	sub    %edx,%eax
  8027d1:	83 ec 04             	sub    $0x4,%esp
  8027d4:	6a 01                	push   $0x1
  8027d6:	50                   	push   %eax
  8027d7:	ff 75 d0             	pushl  -0x30(%ebp)
  8027da:	e8 36 fb ff ff       	call   802315 <set_block_data>
  8027df:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8027e8:	e8 1b 0a 00 00       	call   803208 <free_block>
  8027ed:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027f0:	83 ec 0c             	sub    $0xc,%esp
  8027f3:	ff 75 08             	pushl  0x8(%ebp)
  8027f6:	e8 49 fb ff ff       	call   802344 <alloc_block_FF>
  8027fb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	83 e0 01             	and    $0x1,%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 03                	je     802813 <alloc_block_BF+0x13>
  802810:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802813:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802817:	77 07                	ja     802820 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802819:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802820:	a1 24 50 80 00       	mov    0x805024,%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	75 73                	jne    80289c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 c0 10             	add    $0x10,%eax
  80282f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802832:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	48                   	dec    %eax
  802842:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802845:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802848:	ba 00 00 00 00       	mov    $0x0,%edx
  80284d:	f7 75 e0             	divl   -0x20(%ebp)
  802850:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802853:	29 d0                	sub    %edx,%eax
  802855:	c1 e8 0c             	shr    $0xc,%eax
  802858:	83 ec 0c             	sub    $0xc,%esp
  80285b:	50                   	push   %eax
  80285c:	e8 18 ec ff ff       	call   801479 <sbrk>
  802861:	83 c4 10             	add    $0x10,%esp
  802864:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802867:	83 ec 0c             	sub    $0xc,%esp
  80286a:	6a 00                	push   $0x0
  80286c:	e8 08 ec ff ff       	call   801479 <sbrk>
  802871:	83 c4 10             	add    $0x10,%esp
  802874:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80287a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80287d:	83 ec 08             	sub    $0x8,%esp
  802880:	50                   	push   %eax
  802881:	ff 75 d8             	pushl  -0x28(%ebp)
  802884:	e8 9f f8 ff ff       	call   802128 <initialize_dynamic_allocator>
  802889:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80288c:	83 ec 0c             	sub    $0xc,%esp
  80288f:	68 2f 46 80 00       	push   $0x80462f
  802894:	e8 46 de ff ff       	call   8006df <cprintf>
  802899:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80289c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028aa:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c0:	e9 1d 01 00 00       	jmp    8029e2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	ff 75 a8             	pushl  -0x58(%ebp)
  8028d1:	e8 ee f6 ff ff       	call   801fc4 <get_block_size>
  8028d6:	83 c4 10             	add    $0x10,%esp
  8028d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	83 c0 08             	add    $0x8,%eax
  8028e2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e5:	0f 87 ef 00 00 00    	ja     8029da <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	83 c0 18             	add    $0x18,%eax
  8028f1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028f4:	77 1d                	ja     802913 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028fc:	0f 86 d8 00 00 00    	jbe    8029da <alloc_block_BF+0x1da>
				{
					best_va = va;
  802902:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802905:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802908:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80290b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80290e:	e9 c7 00 00 00       	jmp    8029da <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	83 c0 08             	add    $0x8,%eax
  802919:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80291c:	0f 85 9d 00 00 00    	jne    8029bf <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802922:	83 ec 04             	sub    $0x4,%esp
  802925:	6a 01                	push   $0x1
  802927:	ff 75 a4             	pushl  -0x5c(%ebp)
  80292a:	ff 75 a8             	pushl  -0x58(%ebp)
  80292d:	e8 e3 f9 ff ff       	call   802315 <set_block_data>
  802932:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802939:	75 17                	jne    802952 <alloc_block_BF+0x152>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 d3 45 80 00       	push   $0x8045d3
  802943:	68 2c 01 00 00       	push   $0x12c
  802948:	68 f1 45 80 00       	push   $0x8045f1
  80294d:	e8 d0 da ff ff       	call   800422 <_panic>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 10                	je     80296b <alloc_block_BF+0x16b>
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802963:	8b 52 04             	mov    0x4(%edx),%edx
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	eb 0b                	jmp    802976 <alloc_block_BF+0x176>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	a3 30 50 80 00       	mov    %eax,0x805030
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0f                	je     80298f <alloc_block_BF+0x18f>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802989:	8b 12                	mov    (%edx),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 0a                	jmp    802999 <alloc_block_BF+0x199>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029ba:	e9 24 04 00 00       	jmp    802de3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c5:	76 13                	jbe    8029da <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029c7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029da:	a1 34 50 80 00       	mov    0x805034,%eax
  8029df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e6:	74 07                	je     8029ef <alloc_block_BF+0x1ef>
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	eb 05                	jmp    8029f4 <alloc_block_BF+0x1f4>
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8029f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	0f 85 bf fe ff ff    	jne    8028c5 <alloc_block_BF+0xc5>
  802a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0a:	0f 85 b5 fe ff ff    	jne    8028c5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a14:	0f 84 26 02 00 00    	je     802c40 <alloc_block_BF+0x440>
  802a1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a1e:	0f 85 1c 02 00 00    	jne    802c40 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2a:	83 e8 08             	sub    $0x8,%eax
  802a2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8d 50 08             	lea    0x8(%eax),%edx
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	01 d0                	add    %edx,%eax
  802a3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	83 c0 08             	add    $0x8,%eax
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	6a 01                	push   $0x1
  802a49:	50                   	push   %eax
  802a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a4d:	e8 c3 f8 ff ff       	call   802315 <set_block_data>
  802a52:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	75 68                	jne    802ac7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a5f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a63:	75 17                	jne    802a7c <alloc_block_BF+0x27c>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 0c 46 80 00       	push   $0x80460c
  802a6d:	68 45 01 00 00       	push   $0x145
  802a72:	68 f1 45 80 00       	push   $0x8045f1
  802a77:	e8 a6 d9 ff ff       	call   800422 <_panic>
  802a7c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0d                	je     802a9d <alloc_block_BF+0x29d>
  802a90:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 08                	jmp    802aa5 <alloc_block_BF+0x2a5>
  802a9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa0:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab7:	a1 38 50 80 00       	mov    0x805038,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 38 50 80 00       	mov    %eax,0x805038
  802ac2:	e9 dc 00 00 00       	jmp    802ba3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	75 65                	jne    802b35 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ad0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad4:	75 17                	jne    802aed <alloc_block_BF+0x2ed>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 40 46 80 00       	push   $0x804640
  802ade:	68 4a 01 00 00       	push   $0x14a
  802ae3:	68 f1 45 80 00       	push   $0x8045f1
  802ae8:	e8 35 d9 ff ff       	call   800422 <_panic>
  802aed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802af3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af6:	89 50 04             	mov    %edx,0x4(%eax)
  802af9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0c                	je     802b0f <alloc_block_BF+0x30f>
  802b03:	a1 30 50 80 00       	mov    0x805030,%eax
  802b08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0b:	89 10                	mov    %edx,(%eax)
  802b0d:	eb 08                	jmp    802b17 <alloc_block_BF+0x317>
  802b0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b28:	a1 38 50 80 00       	mov    0x805038,%eax
  802b2d:	40                   	inc    %eax
  802b2e:	a3 38 50 80 00       	mov    %eax,0x805038
  802b33:	eb 6e                	jmp    802ba3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b39:	74 06                	je     802b41 <alloc_block_BF+0x341>
  802b3b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b3f:	75 17                	jne    802b58 <alloc_block_BF+0x358>
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	68 64 46 80 00       	push   $0x804664
  802b49:	68 4f 01 00 00       	push   $0x14f
  802b4e:	68 f1 45 80 00       	push   $0x8045f1
  802b53:	e8 ca d8 ff ff       	call   800422 <_panic>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 10                	mov    (%eax),%edx
  802b5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0b                	je     802b76 <alloc_block_BF+0x376>
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b7c:	89 10                	mov    %edx,(%eax)
  802b7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	75 08                	jne    802b98 <alloc_block_BF+0x398>
  802b90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b93:	a3 30 50 80 00       	mov    %eax,0x805030
  802b98:	a1 38 50 80 00       	mov    0x805038,%eax
  802b9d:	40                   	inc    %eax
  802b9e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ba3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ba7:	75 17                	jne    802bc0 <alloc_block_BF+0x3c0>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 d3 45 80 00       	push   $0x8045d3
  802bb1:	68 51 01 00 00       	push   $0x151
  802bb6:	68 f1 45 80 00       	push   $0x8045f1
  802bbb:	e8 62 d8 ff ff       	call   800422 <_panic>
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 10                	je     802bd9 <alloc_block_BF+0x3d9>
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd1:	8b 52 04             	mov    0x4(%edx),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	eb 0b                	jmp    802be4 <alloc_block_BF+0x3e4>
  802bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0f                	je     802bfd <alloc_block_BF+0x3fd>
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf7:	8b 12                	mov    (%edx),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 0a                	jmp    802c07 <alloc_block_BF+0x407>
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c25:	83 ec 04             	sub    $0x4,%esp
  802c28:	6a 00                	push   $0x0
  802c2a:	ff 75 d0             	pushl  -0x30(%ebp)
  802c2d:	ff 75 cc             	pushl  -0x34(%ebp)
  802c30:	e8 e0 f6 ff ff       	call   802315 <set_block_data>
  802c35:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	e9 a3 01 00 00       	jmp    802de3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c40:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c44:	0f 85 9d 00 00 00    	jne    802ce7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	6a 01                	push   $0x1
  802c4f:	ff 75 ec             	pushl  -0x14(%ebp)
  802c52:	ff 75 f0             	pushl  -0x10(%ebp)
  802c55:	e8 bb f6 ff ff       	call   802315 <set_block_data>
  802c5a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c61:	75 17                	jne    802c7a <alloc_block_BF+0x47a>
  802c63:	83 ec 04             	sub    $0x4,%esp
  802c66:	68 d3 45 80 00       	push   $0x8045d3
  802c6b:	68 58 01 00 00       	push   $0x158
  802c70:	68 f1 45 80 00       	push   $0x8045f1
  802c75:	e8 a8 d7 ff ff       	call   800422 <_panic>
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	74 10                	je     802c93 <alloc_block_BF+0x493>
  802c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8b:	8b 52 04             	mov    0x4(%edx),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	eb 0b                	jmp    802c9e <alloc_block_BF+0x49e>
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 0f                	je     802cb7 <alloc_block_BF+0x4b7>
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb1:	8b 12                	mov    (%edx),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	eb 0a                	jmp    802cc1 <alloc_block_BF+0x4c1>
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd4:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd9:	48                   	dec    %eax
  802cda:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	e9 fc 00 00 00       	jmp    802de3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	83 c0 08             	add    $0x8,%eax
  802ced:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cf0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cf7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cfa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	48                   	dec    %eax
  802d00:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d06:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0b:	f7 75 c4             	divl   -0x3c(%ebp)
  802d0e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d11:	29 d0                	sub    %edx,%eax
  802d13:	c1 e8 0c             	shr    $0xc,%eax
  802d16:	83 ec 0c             	sub    $0xc,%esp
  802d19:	50                   	push   %eax
  802d1a:	e8 5a e7 ff ff       	call   801479 <sbrk>
  802d1f:	83 c4 10             	add    $0x10,%esp
  802d22:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d25:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d29:	75 0a                	jne    802d35 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d30:	e9 ae 00 00 00       	jmp    802de3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d35:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d3c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d42:	01 d0                	add    %edx,%eax
  802d44:	48                   	dec    %eax
  802d45:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d50:	f7 75 b8             	divl   -0x48(%ebp)
  802d53:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d56:	29 d0                	sub    %edx,%eax
  802d58:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d65:	a1 40 50 80 00       	mov    0x805040,%eax
  802d6a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d70:	83 ec 0c             	sub    $0xc,%esp
  802d73:	68 98 46 80 00       	push   $0x804698
  802d78:	e8 62 d9 ff ff       	call   8006df <cprintf>
  802d7d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d80:	83 ec 08             	sub    $0x8,%esp
  802d83:	ff 75 bc             	pushl  -0x44(%ebp)
  802d86:	68 9d 46 80 00       	push   $0x80469d
  802d8b:	e8 4f d9 ff ff       	call   8006df <cprintf>
  802d90:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d93:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d9a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	48                   	dec    %eax
  802da3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802da6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da9:	ba 00 00 00 00       	mov    $0x0,%edx
  802dae:	f7 75 b0             	divl   -0x50(%ebp)
  802db1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802db4:	29 d0                	sub    %edx,%eax
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	6a 01                	push   $0x1
  802dbb:	50                   	push   %eax
  802dbc:	ff 75 bc             	pushl  -0x44(%ebp)
  802dbf:	e8 51 f5 ff ff       	call   802315 <set_block_data>
  802dc4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802dc7:	83 ec 0c             	sub    $0xc,%esp
  802dca:	ff 75 bc             	pushl  -0x44(%ebp)
  802dcd:	e8 36 04 00 00       	call   803208 <free_block>
  802dd2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dd5:	83 ec 0c             	sub    $0xc,%esp
  802dd8:	ff 75 08             	pushl  0x8(%ebp)
  802ddb:	e8 20 fa ff ff       	call   802800 <alloc_block_BF>
  802de0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
  802de8:	53                   	push   %ebx
  802de9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802df3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfe:	74 1e                	je     802e1e <merging+0x39>
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	e8 bc f1 ff ff       	call   801fc4 <get_block_size>
  802e08:	83 c4 04             	add    $0x4,%esp
  802e0b:	89 c2                	mov    %eax,%edx
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e15:	75 07                	jne    802e1e <merging+0x39>
		prev_is_free = 1;
  802e17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e22:	74 1e                	je     802e42 <merging+0x5d>
  802e24:	ff 75 10             	pushl  0x10(%ebp)
  802e27:	e8 98 f1 ff ff       	call   801fc4 <get_block_size>
  802e2c:	83 c4 04             	add    $0x4,%esp
  802e2f:	89 c2                	mov    %eax,%edx
  802e31:	8b 45 10             	mov    0x10(%ebp),%eax
  802e34:	01 d0                	add    %edx,%eax
  802e36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e39:	75 07                	jne    802e42 <merging+0x5d>
		next_is_free = 1;
  802e3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	0f 84 cc 00 00 00    	je     802f18 <merging+0x133>
  802e4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e50:	0f 84 c2 00 00 00    	je     802f18 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e56:	ff 75 08             	pushl  0x8(%ebp)
  802e59:	e8 66 f1 ff ff       	call   801fc4 <get_block_size>
  802e5e:	83 c4 04             	add    $0x4,%esp
  802e61:	89 c3                	mov    %eax,%ebx
  802e63:	ff 75 10             	pushl  0x10(%ebp)
  802e66:	e8 59 f1 ff ff       	call   801fc4 <get_block_size>
  802e6b:	83 c4 04             	add    $0x4,%esp
  802e6e:	01 c3                	add    %eax,%ebx
  802e70:	ff 75 0c             	pushl  0xc(%ebp)
  802e73:	e8 4c f1 ff ff       	call   801fc4 <get_block_size>
  802e78:	83 c4 04             	add    $0x4,%esp
  802e7b:	01 d8                	add    %ebx,%eax
  802e7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e80:	6a 00                	push   $0x0
  802e82:	ff 75 ec             	pushl  -0x14(%ebp)
  802e85:	ff 75 08             	pushl  0x8(%ebp)
  802e88:	e8 88 f4 ff ff       	call   802315 <set_block_data>
  802e8d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e94:	75 17                	jne    802ead <merging+0xc8>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 d3 45 80 00       	push   $0x8045d3
  802e9e:	68 7d 01 00 00       	push   $0x17d
  802ea3:	68 f1 45 80 00       	push   $0x8045f1
  802ea8:	e8 75 d5 ff ff       	call   800422 <_panic>
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 10                	je     802ec6 <merging+0xe1>
  802eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebe:	8b 52 04             	mov    0x4(%edx),%edx
  802ec1:	89 50 04             	mov    %edx,0x4(%eax)
  802ec4:	eb 0b                	jmp    802ed1 <merging+0xec>
  802ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	74 0f                	je     802eea <merging+0x105>
  802edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee4:	8b 12                	mov    (%edx),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	eb 0a                	jmp    802ef4 <merging+0x10f>
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f07:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0c:	48                   	dec    %eax
  802f0d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f12:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f13:	e9 ea 02 00 00       	jmp    803202 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1c:	74 3b                	je     802f59 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	e8 9b f0 ff ff       	call   801fc4 <get_block_size>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	89 c3                	mov    %eax,%ebx
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	ff 75 10             	pushl  0x10(%ebp)
  802f34:	e8 8b f0 ff ff       	call   801fc4 <get_block_size>
  802f39:	83 c4 10             	add    $0x10,%esp
  802f3c:	01 d8                	add    %ebx,%eax
  802f3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	6a 00                	push   $0x0
  802f46:	ff 75 e8             	pushl  -0x18(%ebp)
  802f49:	ff 75 08             	pushl  0x8(%ebp)
  802f4c:	e8 c4 f3 ff ff       	call   802315 <set_block_data>
  802f51:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f54:	e9 a9 02 00 00       	jmp    803202 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5d:	0f 84 2d 01 00 00    	je     803090 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f63:	83 ec 0c             	sub    $0xc,%esp
  802f66:	ff 75 10             	pushl  0x10(%ebp)
  802f69:	e8 56 f0 ff ff       	call   801fc4 <get_block_size>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	89 c3                	mov    %eax,%ebx
  802f73:	83 ec 0c             	sub    $0xc,%esp
  802f76:	ff 75 0c             	pushl  0xc(%ebp)
  802f79:	e8 46 f0 ff ff       	call   801fc4 <get_block_size>
  802f7e:	83 c4 10             	add    $0x10,%esp
  802f81:	01 d8                	add    %ebx,%eax
  802f83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	6a 00                	push   $0x0
  802f8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f8e:	ff 75 10             	pushl  0x10(%ebp)
  802f91:	e8 7f f3 ff ff       	call   802315 <set_block_data>
  802f96:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f99:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa3:	74 06                	je     802fab <merging+0x1c6>
  802fa5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fa9:	75 17                	jne    802fc2 <merging+0x1dd>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 ac 46 80 00       	push   $0x8046ac
  802fb3:	68 8d 01 00 00       	push   $0x18d
  802fb8:	68 f1 45 80 00       	push   $0x8045f1
  802fbd:	e8 60 d4 ff ff       	call   800422 <_panic>
  802fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc5:	8b 50 04             	mov    0x4(%eax),%edx
  802fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0d                	je     802fed <merging+0x208>
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	eb 08                	jmp    802ff5 <merging+0x210>
  802fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ffb:	89 50 04             	mov    %edx,0x4(%eax)
  802ffe:	a1 38 50 80 00       	mov    0x805038,%eax
  803003:	40                   	inc    %eax
  803004:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803009:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300d:	75 17                	jne    803026 <merging+0x241>
  80300f:	83 ec 04             	sub    $0x4,%esp
  803012:	68 d3 45 80 00       	push   $0x8045d3
  803017:	68 8e 01 00 00       	push   $0x18e
  80301c:	68 f1 45 80 00       	push   $0x8045f1
  803021:	e8 fc d3 ff ff       	call   800422 <_panic>
  803026:	8b 45 0c             	mov    0xc(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 10                	je     80303f <merging+0x25a>
  80302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	8b 55 0c             	mov    0xc(%ebp),%edx
  803037:	8b 52 04             	mov    0x4(%edx),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 0b                	jmp    80304a <merging+0x265>
  80303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	a3 30 50 80 00       	mov    %eax,0x805030
  80304a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0f                	je     803063 <merging+0x27e>
  803054:	8b 45 0c             	mov    0xc(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305d:	8b 12                	mov    (%edx),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 0a                	jmp    80306d <merging+0x288>
  803063:	8b 45 0c             	mov    0xc(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803076:	8b 45 0c             	mov    0xc(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 38 50 80 00       	mov    0x805038,%eax
  803085:	48                   	dec    %eax
  803086:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80308b:	e9 72 01 00 00       	jmp    803202 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803090:	8b 45 10             	mov    0x10(%ebp),%eax
  803093:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803096:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309a:	74 79                	je     803115 <merging+0x330>
  80309c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a0:	74 73                	je     803115 <merging+0x330>
  8030a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a6:	74 06                	je     8030ae <merging+0x2c9>
  8030a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ac:	75 17                	jne    8030c5 <merging+0x2e0>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 64 46 80 00       	push   $0x804664
  8030b6:	68 94 01 00 00       	push   $0x194
  8030bb:	68 f1 45 80 00       	push   $0x8045f1
  8030c0:	e8 5d d3 ff ff       	call   800422 <_panic>
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 10                	mov    (%eax),%edx
  8030ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0b                	je     8030e3 <merging+0x2fe>
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	75 08                	jne    803105 <merging+0x320>
  8030fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803100:	a3 30 50 80 00       	mov    %eax,0x805030
  803105:	a1 38 50 80 00       	mov    0x805038,%eax
  80310a:	40                   	inc    %eax
  80310b:	a3 38 50 80 00       	mov    %eax,0x805038
  803110:	e9 ce 00 00 00       	jmp    8031e3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	74 65                	je     803180 <merging+0x39b>
  80311b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311f:	75 17                	jne    803138 <merging+0x353>
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	68 40 46 80 00       	push   $0x804640
  803129:	68 95 01 00 00       	push   $0x195
  80312e:	68 f1 45 80 00       	push   $0x8045f1
  803133:	e8 ea d2 ff ff       	call   800422 <_panic>
  803138:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80313e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0c                	je     80315a <merging+0x375>
  80314e:	a1 30 50 80 00       	mov    0x805030,%eax
  803153:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 08                	jmp    803162 <merging+0x37d>
  80315a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803162:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803165:	a3 30 50 80 00       	mov    %eax,0x805030
  80316a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803173:	a1 38 50 80 00       	mov    0x805038,%eax
  803178:	40                   	inc    %eax
  803179:	a3 38 50 80 00       	mov    %eax,0x805038
  80317e:	eb 63                	jmp    8031e3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803180:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803184:	75 17                	jne    80319d <merging+0x3b8>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 0c 46 80 00       	push   $0x80460c
  80318e:	68 98 01 00 00       	push   $0x198
  803193:	68 f1 45 80 00       	push   $0x8045f1
  803198:	e8 85 d2 ff ff       	call   800422 <_panic>
  80319d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 0d                	je     8031be <merging+0x3d9>
  8031b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 08                	jmp    8031c6 <merging+0x3e1>
  8031be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	ff 75 10             	pushl  0x10(%ebp)
  8031e9:	e8 d6 ed ff ff       	call   801fc4 <get_block_size>
  8031ee:	83 c4 10             	add    $0x10,%esp
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	6a 00                	push   $0x0
  8031f6:	50                   	push   %eax
  8031f7:	ff 75 10             	pushl  0x10(%ebp)
  8031fa:	e8 16 f1 ff ff       	call   802315 <set_block_data>
  8031ff:	83 c4 10             	add    $0x10,%esp
	}
}
  803202:	90                   	nop
  803203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803206:	c9                   	leave  
  803207:	c3                   	ret    

00803208 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
  80320b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80320e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803213:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803216:	a1 30 50 80 00       	mov    0x805030,%eax
  80321b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321e:	73 1b                	jae    80323b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803220:	a1 30 50 80 00       	mov    0x805030,%eax
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	ff 75 08             	pushl  0x8(%ebp)
  80322b:	6a 00                	push   $0x0
  80322d:	50                   	push   %eax
  80322e:	e8 b2 fb ff ff       	call   802de5 <merging>
  803233:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803236:	e9 8b 00 00 00       	jmp    8032c6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80323b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803240:	3b 45 08             	cmp    0x8(%ebp),%eax
  803243:	76 18                	jbe    80325d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803245:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	ff 75 08             	pushl  0x8(%ebp)
  803250:	50                   	push   %eax
  803251:	6a 00                	push   $0x0
  803253:	e8 8d fb ff ff       	call   802de5 <merging>
  803258:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80325b:	eb 69                	jmp    8032c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80325d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803265:	eb 39                	jmp    8032a0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80326d:	73 29                	jae    803298 <free_block+0x90>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	3b 45 08             	cmp    0x8(%ebp),%eax
  803277:	76 1f                	jbe    803298 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803281:	83 ec 04             	sub    $0x4,%esp
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	ff 75 f0             	pushl  -0x10(%ebp)
  80328a:	ff 75 f4             	pushl  -0xc(%ebp)
  80328d:	e8 53 fb ff ff       	call   802de5 <merging>
  803292:	83 c4 10             	add    $0x10,%esp
			break;
  803295:	90                   	nop
		}
	}
}
  803296:	eb 2e                	jmp    8032c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803298:	a1 34 50 80 00       	mov    0x805034,%eax
  80329d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a4:	74 07                	je     8032ad <free_block+0xa5>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	eb 05                	jmp    8032b2 <free_block+0xaa>
  8032ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8032b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	75 a7                	jne    803267 <free_block+0x5f>
  8032c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c4:	75 a1                	jne    803267 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032c6:	90                   	nop
  8032c7:	c9                   	leave  
  8032c8:	c3                   	ret    

008032c9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
  8032cc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032cf:	ff 75 08             	pushl  0x8(%ebp)
  8032d2:	e8 ed ec ff ff       	call   801fc4 <get_block_size>
  8032d7:	83 c4 04             	add    $0x4,%esp
  8032da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032e4:	eb 17                	jmp    8032fd <copy_data+0x34>
  8032e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	01 c2                	add    %eax,%edx
  8032ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	01 c8                	add    %ecx,%eax
  8032f6:	8a 00                	mov    (%eax),%al
  8032f8:	88 02                	mov    %al,(%edx)
  8032fa:	ff 45 fc             	incl   -0x4(%ebp)
  8032fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803300:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803303:	72 e1                	jb     8032e6 <copy_data+0x1d>
}
  803305:	90                   	nop
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 23                	jne    803337 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803314:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803318:	74 13                	je     80332d <realloc_block_FF+0x25>
  80331a:	83 ec 0c             	sub    $0xc,%esp
  80331d:	ff 75 0c             	pushl  0xc(%ebp)
  803320:	e8 1f f0 ff ff       	call   802344 <alloc_block_FF>
  803325:	83 c4 10             	add    $0x10,%esp
  803328:	e9 f4 06 00 00       	jmp    803a21 <realloc_block_FF+0x719>
		return NULL;
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	e9 ea 06 00 00       	jmp    803a21 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803337:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80333b:	75 18                	jne    803355 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80333d:	83 ec 0c             	sub    $0xc,%esp
  803340:	ff 75 08             	pushl  0x8(%ebp)
  803343:	e8 c0 fe ff ff       	call   803208 <free_block>
  803348:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
  803350:	e9 cc 06 00 00       	jmp    803a21 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803355:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803359:	77 07                	ja     803362 <realloc_block_FF+0x5a>
  80335b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803362:	8b 45 0c             	mov    0xc(%ebp),%eax
  803365:	83 e0 01             	and    $0x1,%eax
  803368:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80336b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336e:	83 c0 08             	add    $0x8,%eax
  803371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803374:	83 ec 0c             	sub    $0xc,%esp
  803377:	ff 75 08             	pushl  0x8(%ebp)
  80337a:	e8 45 ec ff ff       	call   801fc4 <get_block_size>
  80337f:	83 c4 10             	add    $0x10,%esp
  803382:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803388:	83 e8 08             	sub    $0x8,%eax
  80338b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	83 e8 04             	sub    $0x4,%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	83 e0 fe             	and    $0xfffffffe,%eax
  803399:	89 c2                	mov    %eax,%edx
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	01 d0                	add    %edx,%eax
  8033a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033a3:	83 ec 0c             	sub    $0xc,%esp
  8033a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a9:	e8 16 ec ff ff       	call   801fc4 <get_block_size>
  8033ae:	83 c4 10             	add    $0x10,%esp
  8033b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b7:	83 e8 08             	sub    $0x8,%eax
  8033ba:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c3:	75 08                	jne    8033cd <realloc_block_FF+0xc5>
	{
		 return va;
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	e9 54 06 00 00       	jmp    803a21 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033d3:	0f 83 e5 03 00 00    	jae    8037be <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033e2:	83 ec 0c             	sub    $0xc,%esp
  8033e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033e8:	e8 f0 eb ff ff       	call   801fdd <is_free_block>
  8033ed:	83 c4 10             	add    $0x10,%esp
  8033f0:	84 c0                	test   %al,%al
  8033f2:	0f 84 3b 01 00 00    	je     803533 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033fe:	01 d0                	add    %edx,%eax
  803400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	6a 01                	push   $0x1
  803408:	ff 75 f0             	pushl  -0x10(%ebp)
  80340b:	ff 75 08             	pushl  0x8(%ebp)
  80340e:	e8 02 ef ff ff       	call   802315 <set_block_data>
  803413:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	83 e8 04             	sub    $0x4,%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	83 e0 fe             	and    $0xfffffffe,%eax
  803421:	89 c2                	mov    %eax,%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	01 d0                	add    %edx,%eax
  803428:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 cc             	pushl  -0x34(%ebp)
  803433:	ff 75 c8             	pushl  -0x38(%ebp)
  803436:	e8 da ee ff ff       	call   802315 <set_block_data>
  80343b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80343e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803442:	74 06                	je     80344a <realloc_block_FF+0x142>
  803444:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803448:	75 17                	jne    803461 <realloc_block_FF+0x159>
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	68 64 46 80 00       	push   $0x804664
  803452:	68 f6 01 00 00       	push   $0x1f6
  803457:	68 f1 45 80 00       	push   $0x8045f1
  80345c:	e8 c1 cf ff ff       	call   800422 <_panic>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8b 10                	mov    (%eax),%edx
  803466:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	74 0b                	je     80347f <realloc_block_FF+0x177>
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803485:	89 10                	mov    %edx,(%eax)
  803487:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	75 08                	jne    8034a1 <realloc_block_FF+0x199>
  803499:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80349c:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a6:	40                   	inc    %eax
  8034a7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b0:	75 17                	jne    8034c9 <realloc_block_FF+0x1c1>
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 d3 45 80 00       	push   $0x8045d3
  8034ba:	68 f7 01 00 00       	push   $0x1f7
  8034bf:	68 f1 45 80 00       	push   $0x8045f1
  8034c4:	e8 59 cf ff ff       	call   800422 <_panic>
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	74 10                	je     8034e2 <realloc_block_FF+0x1da>
  8034d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034da:	8b 52 04             	mov    0x4(%edx),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	eb 0b                	jmp    8034ed <realloc_block_FF+0x1e5>
  8034e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e5:	8b 40 04             	mov    0x4(%eax),%eax
  8034e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 0f                	je     803506 <realloc_block_FF+0x1fe>
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	8b 40 04             	mov    0x4(%eax),%eax
  8034fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803500:	8b 12                	mov    (%edx),%edx
  803502:	89 10                	mov    %edx,(%eax)
  803504:	eb 0a                	jmp    803510 <realloc_block_FF+0x208>
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 38 50 80 00       	mov    0x805038,%eax
  803528:	48                   	dec    %eax
  803529:	a3 38 50 80 00       	mov    %eax,0x805038
  80352e:	e9 83 02 00 00       	jmp    8037b6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803533:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803537:	0f 86 69 02 00 00    	jbe    8037a6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	6a 01                	push   $0x1
  803542:	ff 75 f0             	pushl  -0x10(%ebp)
  803545:	ff 75 08             	pushl  0x8(%ebp)
  803548:	e8 c8 ed ff ff       	call   802315 <set_block_data>
  80354d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	83 e8 04             	sub    $0x4,%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	83 e0 fe             	and    $0xfffffffe,%eax
  80355b:	89 c2                	mov    %eax,%edx
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	01 d0                	add    %edx,%eax
  803562:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803565:	a1 38 50 80 00       	mov    0x805038,%eax
  80356a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80356d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803571:	75 68                	jne    8035db <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803577:	75 17                	jne    803590 <realloc_block_FF+0x288>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 0c 46 80 00       	push   $0x80460c
  803581:	68 06 02 00 00       	push   $0x206
  803586:	68 f1 45 80 00       	push   $0x8045f1
  80358b:	e8 92 ce ff ff       	call   800422 <_panic>
  803590:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 0d                	je     8035b1 <realloc_block_FF+0x2a9>
  8035a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 08                	jmp    8035b9 <realloc_block_FF+0x2b1>
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035d6:	e9 b0 01 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035e3:	76 68                	jbe    80364d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e9:	75 17                	jne    803602 <realloc_block_FF+0x2fa>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 0c 46 80 00       	push   $0x80460c
  8035f3:	68 0b 02 00 00       	push   $0x20b
  8035f8:	68 f1 45 80 00       	push   $0x8045f1
  8035fd:	e8 20 ce ff ff       	call   800422 <_panic>
  803602:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	85 c0                	test   %eax,%eax
  803614:	74 0d                	je     803623 <realloc_block_FF+0x31b>
  803616:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80361b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361e:	89 50 04             	mov    %edx,0x4(%eax)
  803621:	eb 08                	jmp    80362b <realloc_block_FF+0x323>
  803623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803626:	a3 30 50 80 00       	mov    %eax,0x805030
  80362b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803633:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363d:	a1 38 50 80 00       	mov    0x805038,%eax
  803642:	40                   	inc    %eax
  803643:	a3 38 50 80 00       	mov    %eax,0x805038
  803648:	e9 3e 01 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80364d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803652:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803655:	73 68                	jae    8036bf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803657:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80365b:	75 17                	jne    803674 <realloc_block_FF+0x36c>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 40 46 80 00       	push   $0x804640
  803665:	68 10 02 00 00       	push   $0x210
  80366a:	68 f1 45 80 00       	push   $0x8045f1
  80366f:	e8 ae cd ff ff       	call   800422 <_panic>
  803674:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80367a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0c                	je     803696 <realloc_block_FF+0x38e>
  80368a:	a1 30 50 80 00       	mov    0x805030,%eax
  80368f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803692:	89 10                	mov    %edx,(%eax)
  803694:	eb 08                	jmp    80369e <realloc_block_FF+0x396>
  803696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803699:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036af:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b4:	40                   	inc    %eax
  8036b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ba:	e9 cc 00 00 00       	jmp    80378b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ce:	e9 8a 00 00 00       	jmp    80375d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d9:	73 7a                	jae    803755 <realloc_block_FF+0x44d>
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e3:	73 70                	jae    803755 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e9:	74 06                	je     8036f1 <realloc_block_FF+0x3e9>
  8036eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ef:	75 17                	jne    803708 <realloc_block_FF+0x400>
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	68 64 46 80 00       	push   $0x804664
  8036f9:	68 1a 02 00 00       	push   $0x21a
  8036fe:	68 f1 45 80 00       	push   $0x8045f1
  803703:	e8 1a cd ff ff       	call   800422 <_panic>
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 10                	mov    (%eax),%edx
  80370d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803710:	89 10                	mov    %edx,(%eax)
  803712:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 0b                	je     803726 <realloc_block_FF+0x41e>
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 00                	mov    (%eax),%eax
  803720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803723:	89 50 04             	mov    %edx,0x4(%eax)
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80372c:	89 10                	mov    %edx,(%eax)
  80372e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803734:	89 50 04             	mov    %edx,0x4(%eax)
  803737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	75 08                	jne    803748 <realloc_block_FF+0x440>
  803740:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803743:	a3 30 50 80 00       	mov    %eax,0x805030
  803748:	a1 38 50 80 00       	mov    0x805038,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803753:	eb 36                	jmp    80378b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803755:	a1 34 50 80 00       	mov    0x805034,%eax
  80375a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80375d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803761:	74 07                	je     80376a <realloc_block_FF+0x462>
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	eb 05                	jmp    80376f <realloc_block_FF+0x467>
  80376a:	b8 00 00 00 00       	mov    $0x0,%eax
  80376f:	a3 34 50 80 00       	mov    %eax,0x805034
  803774:	a1 34 50 80 00       	mov    0x805034,%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	0f 85 52 ff ff ff    	jne    8036d3 <realloc_block_FF+0x3cb>
  803781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803785:	0f 85 48 ff ff ff    	jne    8036d3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80378b:	83 ec 04             	sub    $0x4,%esp
  80378e:	6a 00                	push   $0x0
  803790:	ff 75 d8             	pushl  -0x28(%ebp)
  803793:	ff 75 d4             	pushl  -0x2c(%ebp)
  803796:	e8 7a eb ff ff       	call   802315 <set_block_data>
  80379b:	83 c4 10             	add    $0x10,%esp
				return va;
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	e9 7b 02 00 00       	jmp    803a21 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8037a6:	83 ec 0c             	sub    $0xc,%esp
  8037a9:	68 e1 46 80 00       	push   $0x8046e1
  8037ae:	e8 2c cf ff ff       	call   8006df <cprintf>
  8037b3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	e9 63 02 00 00       	jmp    803a21 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037c4:	0f 86 4d 02 00 00    	jbe    803a17 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037ca:	83 ec 0c             	sub    $0xc,%esp
  8037cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037d0:	e8 08 e8 ff ff       	call   801fdd <is_free_block>
  8037d5:	83 c4 10             	add    $0x10,%esp
  8037d8:	84 c0                	test   %al,%al
  8037da:	0f 84 37 02 00 00    	je     803a17 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037ef:	76 38                	jbe    803829 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037f1:	83 ec 0c             	sub    $0xc,%esp
  8037f4:	ff 75 08             	pushl  0x8(%ebp)
  8037f7:	e8 0c fa ff ff       	call   803208 <free_block>
  8037fc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037ff:	83 ec 0c             	sub    $0xc,%esp
  803802:	ff 75 0c             	pushl  0xc(%ebp)
  803805:	e8 3a eb ff ff       	call   802344 <alloc_block_FF>
  80380a:	83 c4 10             	add    $0x10,%esp
  80380d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803810:	83 ec 08             	sub    $0x8,%esp
  803813:	ff 75 c0             	pushl  -0x40(%ebp)
  803816:	ff 75 08             	pushl  0x8(%ebp)
  803819:	e8 ab fa ff ff       	call   8032c9 <copy_data>
  80381e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803821:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803824:	e9 f8 01 00 00       	jmp    803a21 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803829:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80382f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803832:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803836:	0f 87 a0 00 00 00    	ja     8038dc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80383c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803840:	75 17                	jne    803859 <realloc_block_FF+0x551>
  803842:	83 ec 04             	sub    $0x4,%esp
  803845:	68 d3 45 80 00       	push   $0x8045d3
  80384a:	68 38 02 00 00       	push   $0x238
  80384f:	68 f1 45 80 00       	push   $0x8045f1
  803854:	e8 c9 cb ff ff       	call   800422 <_panic>
  803859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385c:	8b 00                	mov    (%eax),%eax
  80385e:	85 c0                	test   %eax,%eax
  803860:	74 10                	je     803872 <realloc_block_FF+0x56a>
  803862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803865:	8b 00                	mov    (%eax),%eax
  803867:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386a:	8b 52 04             	mov    0x4(%edx),%edx
  80386d:	89 50 04             	mov    %edx,0x4(%eax)
  803870:	eb 0b                	jmp    80387d <realloc_block_FF+0x575>
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 40 04             	mov    0x4(%eax),%eax
  803878:	a3 30 50 80 00       	mov    %eax,0x805030
  80387d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803880:	8b 40 04             	mov    0x4(%eax),%eax
  803883:	85 c0                	test   %eax,%eax
  803885:	74 0f                	je     803896 <realloc_block_FF+0x58e>
  803887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803890:	8b 12                	mov    (%edx),%edx
  803892:	89 10                	mov    %edx,(%eax)
  803894:	eb 0a                	jmp    8038a0 <realloc_block_FF+0x598>
  803896:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803899:	8b 00                	mov    (%eax),%eax
  80389b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b8:	48                   	dec    %eax
  8038b9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038c4:	01 d0                	add    %edx,%eax
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	6a 01                	push   $0x1
  8038cb:	50                   	push   %eax
  8038cc:	ff 75 08             	pushl  0x8(%ebp)
  8038cf:	e8 41 ea ff ff       	call   802315 <set_block_data>
  8038d4:	83 c4 10             	add    $0x10,%esp
  8038d7:	e9 36 01 00 00       	jmp    803a12 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038e2:	01 d0                	add    %edx,%eax
  8038e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038e7:	83 ec 04             	sub    $0x4,%esp
  8038ea:	6a 01                	push   $0x1
  8038ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8038ef:	ff 75 08             	pushl  0x8(%ebp)
  8038f2:	e8 1e ea ff ff       	call   802315 <set_block_data>
  8038f7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	83 e8 04             	sub    $0x4,%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	83 e0 fe             	and    $0xfffffffe,%eax
  803905:	89 c2                	mov    %eax,%edx
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	01 d0                	add    %edx,%eax
  80390c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80390f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803913:	74 06                	je     80391b <realloc_block_FF+0x613>
  803915:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803919:	75 17                	jne    803932 <realloc_block_FF+0x62a>
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	68 64 46 80 00       	push   $0x804664
  803923:	68 44 02 00 00       	push   $0x244
  803928:	68 f1 45 80 00       	push   $0x8045f1
  80392d:	e8 f0 ca ff ff       	call   800422 <_panic>
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	8b 10                	mov    (%eax),%edx
  803937:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80393a:	89 10                	mov    %edx,(%eax)
  80393c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 0b                	je     803950 <realloc_block_FF+0x648>
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	8b 00                	mov    (%eax),%eax
  80394a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80394d:	89 50 04             	mov    %edx,0x4(%eax)
  803950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803953:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803956:	89 10                	mov    %edx,(%eax)
  803958:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80395b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395e:	89 50 04             	mov    %edx,0x4(%eax)
  803961:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	75 08                	jne    803972 <realloc_block_FF+0x66a>
  80396a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80396d:	a3 30 50 80 00       	mov    %eax,0x805030
  803972:	a1 38 50 80 00       	mov    0x805038,%eax
  803977:	40                   	inc    %eax
  803978:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80397d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803981:	75 17                	jne    80399a <realloc_block_FF+0x692>
  803983:	83 ec 04             	sub    $0x4,%esp
  803986:	68 d3 45 80 00       	push   $0x8045d3
  80398b:	68 45 02 00 00       	push   $0x245
  803990:	68 f1 45 80 00       	push   $0x8045f1
  803995:	e8 88 ca ff ff       	call   800422 <_panic>
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	74 10                	je     8039b3 <realloc_block_FF+0x6ab>
  8039a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a6:	8b 00                	mov    (%eax),%eax
  8039a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ab:	8b 52 04             	mov    0x4(%edx),%edx
  8039ae:	89 50 04             	mov    %edx,0x4(%eax)
  8039b1:	eb 0b                	jmp    8039be <realloc_block_FF+0x6b6>
  8039b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b6:	8b 40 04             	mov    0x4(%eax),%eax
  8039b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8039be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c1:	8b 40 04             	mov    0x4(%eax),%eax
  8039c4:	85 c0                	test   %eax,%eax
  8039c6:	74 0f                	je     8039d7 <realloc_block_FF+0x6cf>
  8039c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d1:	8b 12                	mov    (%edx),%edx
  8039d3:	89 10                	mov    %edx,(%eax)
  8039d5:	eb 0a                	jmp    8039e1 <realloc_block_FF+0x6d9>
  8039d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039da:	8b 00                	mov    (%eax),%eax
  8039dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8039f9:	48                   	dec    %eax
  8039fa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ff:	83 ec 04             	sub    $0x4,%esp
  803a02:	6a 00                	push   $0x0
  803a04:	ff 75 bc             	pushl  -0x44(%ebp)
  803a07:	ff 75 b8             	pushl  -0x48(%ebp)
  803a0a:	e8 06 e9 ff ff       	call   802315 <set_block_data>
  803a0f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	eb 0a                	jmp    803a21 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a17:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a21:	c9                   	leave  
  803a22:	c3                   	ret    

00803a23 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a23:	55                   	push   %ebp
  803a24:	89 e5                	mov    %esp,%ebp
  803a26:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a29:	83 ec 04             	sub    $0x4,%esp
  803a2c:	68 e8 46 80 00       	push   $0x8046e8
  803a31:	68 58 02 00 00       	push   $0x258
  803a36:	68 f1 45 80 00       	push   $0x8045f1
  803a3b:	e8 e2 c9 ff ff       	call   800422 <_panic>

00803a40 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a40:	55                   	push   %ebp
  803a41:	89 e5                	mov    %esp,%ebp
  803a43:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	68 10 47 80 00       	push   $0x804710
  803a4e:	68 61 02 00 00       	push   $0x261
  803a53:	68 f1 45 80 00       	push   $0x8045f1
  803a58:	e8 c5 c9 ff ff       	call   800422 <_panic>
  803a5d:	66 90                	xchg   %ax,%ax
  803a5f:	90                   	nop

00803a60 <__udivdi3>:
  803a60:	55                   	push   %ebp
  803a61:	57                   	push   %edi
  803a62:	56                   	push   %esi
  803a63:	53                   	push   %ebx
  803a64:	83 ec 1c             	sub    $0x1c,%esp
  803a67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a77:	89 ca                	mov    %ecx,%edx
  803a79:	89 f8                	mov    %edi,%eax
  803a7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a7f:	85 f6                	test   %esi,%esi
  803a81:	75 2d                	jne    803ab0 <__udivdi3+0x50>
  803a83:	39 cf                	cmp    %ecx,%edi
  803a85:	77 65                	ja     803aec <__udivdi3+0x8c>
  803a87:	89 fd                	mov    %edi,%ebp
  803a89:	85 ff                	test   %edi,%edi
  803a8b:	75 0b                	jne    803a98 <__udivdi3+0x38>
  803a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a92:	31 d2                	xor    %edx,%edx
  803a94:	f7 f7                	div    %edi
  803a96:	89 c5                	mov    %eax,%ebp
  803a98:	31 d2                	xor    %edx,%edx
  803a9a:	89 c8                	mov    %ecx,%eax
  803a9c:	f7 f5                	div    %ebp
  803a9e:	89 c1                	mov    %eax,%ecx
  803aa0:	89 d8                	mov    %ebx,%eax
  803aa2:	f7 f5                	div    %ebp
  803aa4:	89 cf                	mov    %ecx,%edi
  803aa6:	89 fa                	mov    %edi,%edx
  803aa8:	83 c4 1c             	add    $0x1c,%esp
  803aab:	5b                   	pop    %ebx
  803aac:	5e                   	pop    %esi
  803aad:	5f                   	pop    %edi
  803aae:	5d                   	pop    %ebp
  803aaf:	c3                   	ret    
  803ab0:	39 ce                	cmp    %ecx,%esi
  803ab2:	77 28                	ja     803adc <__udivdi3+0x7c>
  803ab4:	0f bd fe             	bsr    %esi,%edi
  803ab7:	83 f7 1f             	xor    $0x1f,%edi
  803aba:	75 40                	jne    803afc <__udivdi3+0x9c>
  803abc:	39 ce                	cmp    %ecx,%esi
  803abe:	72 0a                	jb     803aca <__udivdi3+0x6a>
  803ac0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ac4:	0f 87 9e 00 00 00    	ja     803b68 <__udivdi3+0x108>
  803aca:	b8 01 00 00 00       	mov    $0x1,%eax
  803acf:	89 fa                	mov    %edi,%edx
  803ad1:	83 c4 1c             	add    $0x1c,%esp
  803ad4:	5b                   	pop    %ebx
  803ad5:	5e                   	pop    %esi
  803ad6:	5f                   	pop    %edi
  803ad7:	5d                   	pop    %ebp
  803ad8:	c3                   	ret    
  803ad9:	8d 76 00             	lea    0x0(%esi),%esi
  803adc:	31 ff                	xor    %edi,%edi
  803ade:	31 c0                	xor    %eax,%eax
  803ae0:	89 fa                	mov    %edi,%edx
  803ae2:	83 c4 1c             	add    $0x1c,%esp
  803ae5:	5b                   	pop    %ebx
  803ae6:	5e                   	pop    %esi
  803ae7:	5f                   	pop    %edi
  803ae8:	5d                   	pop    %ebp
  803ae9:	c3                   	ret    
  803aea:	66 90                	xchg   %ax,%ax
  803aec:	89 d8                	mov    %ebx,%eax
  803aee:	f7 f7                	div    %edi
  803af0:	31 ff                	xor    %edi,%edi
  803af2:	89 fa                	mov    %edi,%edx
  803af4:	83 c4 1c             	add    $0x1c,%esp
  803af7:	5b                   	pop    %ebx
  803af8:	5e                   	pop    %esi
  803af9:	5f                   	pop    %edi
  803afa:	5d                   	pop    %ebp
  803afb:	c3                   	ret    
  803afc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b01:	89 eb                	mov    %ebp,%ebx
  803b03:	29 fb                	sub    %edi,%ebx
  803b05:	89 f9                	mov    %edi,%ecx
  803b07:	d3 e6                	shl    %cl,%esi
  803b09:	89 c5                	mov    %eax,%ebp
  803b0b:	88 d9                	mov    %bl,%cl
  803b0d:	d3 ed                	shr    %cl,%ebp
  803b0f:	89 e9                	mov    %ebp,%ecx
  803b11:	09 f1                	or     %esi,%ecx
  803b13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b17:	89 f9                	mov    %edi,%ecx
  803b19:	d3 e0                	shl    %cl,%eax
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 d6                	mov    %edx,%esi
  803b1f:	88 d9                	mov    %bl,%cl
  803b21:	d3 ee                	shr    %cl,%esi
  803b23:	89 f9                	mov    %edi,%ecx
  803b25:	d3 e2                	shl    %cl,%edx
  803b27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2b:	88 d9                	mov    %bl,%cl
  803b2d:	d3 e8                	shr    %cl,%eax
  803b2f:	09 c2                	or     %eax,%edx
  803b31:	89 d0                	mov    %edx,%eax
  803b33:	89 f2                	mov    %esi,%edx
  803b35:	f7 74 24 0c          	divl   0xc(%esp)
  803b39:	89 d6                	mov    %edx,%esi
  803b3b:	89 c3                	mov    %eax,%ebx
  803b3d:	f7 e5                	mul    %ebp
  803b3f:	39 d6                	cmp    %edx,%esi
  803b41:	72 19                	jb     803b5c <__udivdi3+0xfc>
  803b43:	74 0b                	je     803b50 <__udivdi3+0xf0>
  803b45:	89 d8                	mov    %ebx,%eax
  803b47:	31 ff                	xor    %edi,%edi
  803b49:	e9 58 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b54:	89 f9                	mov    %edi,%ecx
  803b56:	d3 e2                	shl    %cl,%edx
  803b58:	39 c2                	cmp    %eax,%edx
  803b5a:	73 e9                	jae    803b45 <__udivdi3+0xe5>
  803b5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b5f:	31 ff                	xor    %edi,%edi
  803b61:	e9 40 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	31 c0                	xor    %eax,%eax
  803b6a:	e9 37 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b6f:	90                   	nop

00803b70 <__umoddi3>:
  803b70:	55                   	push   %ebp
  803b71:	57                   	push   %edi
  803b72:	56                   	push   %esi
  803b73:	53                   	push   %ebx
  803b74:	83 ec 1c             	sub    $0x1c,%esp
  803b77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b8f:	89 f3                	mov    %esi,%ebx
  803b91:	89 fa                	mov    %edi,%edx
  803b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b97:	89 34 24             	mov    %esi,(%esp)
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	75 1a                	jne    803bb8 <__umoddi3+0x48>
  803b9e:	39 f7                	cmp    %esi,%edi
  803ba0:	0f 86 a2 00 00 00    	jbe    803c48 <__umoddi3+0xd8>
  803ba6:	89 c8                	mov    %ecx,%eax
  803ba8:	89 f2                	mov    %esi,%edx
  803baa:	f7 f7                	div    %edi
  803bac:	89 d0                	mov    %edx,%eax
  803bae:	31 d2                	xor    %edx,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	39 f0                	cmp    %esi,%eax
  803bba:	0f 87 ac 00 00 00    	ja     803c6c <__umoddi3+0xfc>
  803bc0:	0f bd e8             	bsr    %eax,%ebp
  803bc3:	83 f5 1f             	xor    $0x1f,%ebp
  803bc6:	0f 84 ac 00 00 00    	je     803c78 <__umoddi3+0x108>
  803bcc:	bf 20 00 00 00       	mov    $0x20,%edi
  803bd1:	29 ef                	sub    %ebp,%edi
  803bd3:	89 fe                	mov    %edi,%esi
  803bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bd9:	89 e9                	mov    %ebp,%ecx
  803bdb:	d3 e0                	shl    %cl,%eax
  803bdd:	89 d7                	mov    %edx,%edi
  803bdf:	89 f1                	mov    %esi,%ecx
  803be1:	d3 ef                	shr    %cl,%edi
  803be3:	09 c7                	or     %eax,%edi
  803be5:	89 e9                	mov    %ebp,%ecx
  803be7:	d3 e2                	shl    %cl,%edx
  803be9:	89 14 24             	mov    %edx,(%esp)
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	d3 e0                	shl    %cl,%eax
  803bf0:	89 c2                	mov    %eax,%edx
  803bf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf6:	d3 e0                	shl    %cl,%eax
  803bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c00:	89 f1                	mov    %esi,%ecx
  803c02:	d3 e8                	shr    %cl,%eax
  803c04:	09 d0                	or     %edx,%eax
  803c06:	d3 eb                	shr    %cl,%ebx
  803c08:	89 da                	mov    %ebx,%edx
  803c0a:	f7 f7                	div    %edi
  803c0c:	89 d3                	mov    %edx,%ebx
  803c0e:	f7 24 24             	mull   (%esp)
  803c11:	89 c6                	mov    %eax,%esi
  803c13:	89 d1                	mov    %edx,%ecx
  803c15:	39 d3                	cmp    %edx,%ebx
  803c17:	0f 82 87 00 00 00    	jb     803ca4 <__umoddi3+0x134>
  803c1d:	0f 84 91 00 00 00    	je     803cb4 <__umoddi3+0x144>
  803c23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c27:	29 f2                	sub    %esi,%edx
  803c29:	19 cb                	sbb    %ecx,%ebx
  803c2b:	89 d8                	mov    %ebx,%eax
  803c2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c31:	d3 e0                	shl    %cl,%eax
  803c33:	89 e9                	mov    %ebp,%ecx
  803c35:	d3 ea                	shr    %cl,%edx
  803c37:	09 d0                	or     %edx,%eax
  803c39:	89 e9                	mov    %ebp,%ecx
  803c3b:	d3 eb                	shr    %cl,%ebx
  803c3d:	89 da                	mov    %ebx,%edx
  803c3f:	83 c4 1c             	add    $0x1c,%esp
  803c42:	5b                   	pop    %ebx
  803c43:	5e                   	pop    %esi
  803c44:	5f                   	pop    %edi
  803c45:	5d                   	pop    %ebp
  803c46:	c3                   	ret    
  803c47:	90                   	nop
  803c48:	89 fd                	mov    %edi,%ebp
  803c4a:	85 ff                	test   %edi,%edi
  803c4c:	75 0b                	jne    803c59 <__umoddi3+0xe9>
  803c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c53:	31 d2                	xor    %edx,%edx
  803c55:	f7 f7                	div    %edi
  803c57:	89 c5                	mov    %eax,%ebp
  803c59:	89 f0                	mov    %esi,%eax
  803c5b:	31 d2                	xor    %edx,%edx
  803c5d:	f7 f5                	div    %ebp
  803c5f:	89 c8                	mov    %ecx,%eax
  803c61:	f7 f5                	div    %ebp
  803c63:	89 d0                	mov    %edx,%eax
  803c65:	e9 44 ff ff ff       	jmp    803bae <__umoddi3+0x3e>
  803c6a:	66 90                	xchg   %ax,%ax
  803c6c:	89 c8                	mov    %ecx,%eax
  803c6e:	89 f2                	mov    %esi,%edx
  803c70:	83 c4 1c             	add    $0x1c,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
  803c78:	3b 04 24             	cmp    (%esp),%eax
  803c7b:	72 06                	jb     803c83 <__umoddi3+0x113>
  803c7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c81:	77 0f                	ja     803c92 <__umoddi3+0x122>
  803c83:	89 f2                	mov    %esi,%edx
  803c85:	29 f9                	sub    %edi,%ecx
  803c87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c8b:	89 14 24             	mov    %edx,(%esp)
  803c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c96:	8b 14 24             	mov    (%esp),%edx
  803c99:	83 c4 1c             	add    $0x1c,%esp
  803c9c:	5b                   	pop    %ebx
  803c9d:	5e                   	pop    %esi
  803c9e:	5f                   	pop    %edi
  803c9f:	5d                   	pop    %ebp
  803ca0:	c3                   	ret    
  803ca1:	8d 76 00             	lea    0x0(%esi),%esi
  803ca4:	2b 04 24             	sub    (%esp),%eax
  803ca7:	19 fa                	sbb    %edi,%edx
  803ca9:	89 d1                	mov    %edx,%ecx
  803cab:	89 c6                	mov    %eax,%esi
  803cad:	e9 71 ff ff ff       	jmp    803c23 <__umoddi3+0xb3>
  803cb2:	66 90                	xchg   %ax,%ax
  803cb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cb8:	72 ea                	jb     803ca4 <__umoddi3+0x134>
  803cba:	89 d9                	mov    %ebx,%ecx
  803cbc:	e9 62 ff ff ff       	jmp    803c23 <__umoddi3+0xb3>
