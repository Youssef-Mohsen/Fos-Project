
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
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 3d 80 00       	push   $0x803d60
  800065:	6a 11                	push   $0x11
  800067:	68 7c 3d 80 00       	push   $0x803d7c
  80006c:	e8 bb 03 00 00       	call   80042c <_panic>
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
  8000bc:	e8 15 1a 00 00       	call   801ad6 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 58 1a 00 00       	call   801b21 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 bc 13 00 00       	call   801499 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 98 3d 80 00       	push   $0x803d98
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 7c 3d 80 00       	push   $0x803d7c
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 17 1a 00 00       	call   801b21 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 c8 3d 80 00       	push   $0x803dc8
  800117:	6a 33                	push   $0x33
  800119:	68 7c 3d 80 00       	push   $0x803d7c
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 ae 19 00 00       	call   801ad6 <sys_calculate_free_frames>
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
  80015f:	e8 72 19 00 00       	call   801ad6 <sys_calculate_free_frames>
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
  80017c:	68 f8 3d 80 00       	push   $0x803df8
  800181:	6a 3d                	push   $0x3d
  800183:	68 7c 3d 80 00       	push   $0x803d7c
  800188:	e8 9f 02 00 00       	call   80042c <_panic>

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
  8001c7:	e8 65 1d 00 00       	call   801f31 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 74 3e 80 00       	push   $0x803e74
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 7c 3d 80 00       	push   $0x803d7c
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 e5 18 00 00       	call   801ad6 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 28 19 00 00       	call   801b21 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 0e 19 00 00       	call   801b21 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 94 3e 80 00       	push   $0x803e94
  800220:	6a 4e                	push   $0x4e
  800222:	68 7c 3d 80 00       	push   $0x803d7c
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 a5 18 00 00       	call   801ad6 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 d0 3e 80 00       	push   $0x803ed0
  800247:	6a 4f                	push   $0x4f
  800249:	68 7c 3d 80 00       	push   $0x803d7c
  80024e:	e8 d9 01 00 00       	call   80042c <_panic>
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
  80028d:	e8 9f 1c 00 00       	call   801f31 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 1c 3f 80 00       	push   $0x803f1c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 7c 3d 80 00       	push   $0x803d7c
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 26 1b 00 00       	call   801ddd <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 3a 1b 00 00       	call   801df7 <gettst>
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
  8002d4:	e8 04 1b 00 00       	call   801ddd <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 40 3f 80 00       	push   $0x803f40
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 7c 3d 80 00       	push   $0x803d7c
  8002e8:	e8 3f 01 00 00       	call   80042c <_panic>

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
  8002f3:	e8 a7 19 00 00       	call   801c9f <sys_getenvindex>
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002fe:	89 d0                	mov    %edx,%eax
  800300:	c1 e0 03             	shl    $0x3,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80030c:	01 c8                	add    %ecx,%eax
  80030e:	01 c0                	add    %eax,%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800319:	01 c8                	add    %ecx,%eax
  80031b:	01 d0                	add    %edx,%eax
  80031d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800322:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800327:	a1 20 50 80 00       	mov    0x805020,%eax
  80032c:	8a 40 20             	mov    0x20(%eax),%al
  80032f:	84 c0                	test   %al,%al
  800331:	74 0d                	je     800340 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	83 c0 20             	add    $0x20,%eax
  80033b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800344:	7e 0a                	jle    800350 <libmain+0x63>
		binaryname = argv[0];
  800346:	8b 45 0c             	mov    0xc(%ebp),%eax
  800349:	8b 00                	mov    (%eax),%eax
  80034b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	ff 75 0c             	pushl  0xc(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 da fc ff ff       	call   800038 <_main>
  80035e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800361:	e8 bd 16 00 00       	call   801a23 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 a4 3f 80 00       	push   $0x803fa4
  80036e:	e8 76 03 00 00       	call   8006e9 <cprintf>
  800373:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800376:	a1 20 50 80 00       	mov    0x805020,%eax
  80037b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800381:	a1 20 50 80 00       	mov    0x805020,%eax
  800386:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	52                   	push   %edx
  800390:	50                   	push   %eax
  800391:	68 cc 3f 80 00       	push   $0x803fcc
  800396:	e8 4e 03 00 00       	call   8006e9 <cprintf>
  80039b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80039e:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a3:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8003a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ae:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8003b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b9:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003bf:	51                   	push   %ecx
  8003c0:	52                   	push   %edx
  8003c1:	50                   	push   %eax
  8003c2:	68 f4 3f 80 00       	push   $0x803ff4
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 4c 40 80 00       	push   $0x80404c
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 a4 3f 80 00       	push   $0x803fa4
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 3d 16 00 00       	call   801a3d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800400:	e8 19 00 00 00       	call   80041e <exit>
}
  800405:	90                   	nop
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040e:	83 ec 0c             	sub    $0xc,%esp
  800411:	6a 00                	push   $0x0
  800413:	e8 53 18 00 00       	call   801c6b <sys_destroy_env>
  800418:	83 c4 10             	add    $0x10,%esp
}
  80041b:	90                   	nop
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <exit>:

void
exit(void)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800424:	e8 a8 18 00 00       	call   801cd1 <sys_exit_env>
}
  800429:	90                   	nop
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800432:	8d 45 10             	lea    0x10(%ebp),%eax
  800435:	83 c0 04             	add    $0x4,%eax
  800438:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80043b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 16                	je     80045a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800444:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 60 40 80 00       	push   $0x804060
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 65 40 80 00       	push   $0x804065
  80046b:	e8 79 02 00 00       	call   8006e9 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800473:	8b 45 10             	mov    0x10(%ebp),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 f4             	pushl  -0xc(%ebp)
  80047c:	50                   	push   %eax
  80047d:	e8 fc 01 00 00       	call   80067e <vcprintf>
  800482:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	6a 00                	push   $0x0
  80048a:	68 81 40 80 00       	push   $0x804081
  80048f:	e8 ea 01 00 00       	call   80067e <vcprintf>
  800494:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800497:	e8 82 ff ff ff       	call   80041e <exit>

	// should not return here
	while (1) ;
  80049c:	eb fe                	jmp    80049c <_panic+0x70>

0080049e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	74 14                	je     8004ca <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 84 40 80 00       	push   $0x804084
  8004be:	6a 26                	push   $0x26
  8004c0:	68 d0 40 80 00       	push   $0x8040d0
  8004c5:	e8 62 ff ff ff       	call   80042c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d8:	e9 c5 00 00 00       	jmp    8005a2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	01 d0                	add    %edx,%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	75 08                	jne    8004fa <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004f5:	e9 a5 00 00 00       	jmp    80059f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800508:	eb 69                	jmp    800573 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80050a:	a1 20 50 80 00       	mov    0x805020,%eax
  80050f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800515:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	84 c0                	test   %al,%al
  800528:	75 46                	jne    800570 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052a:	a1 20 50 80 00       	mov    0x805020,%eax
  80052f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800535:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800538:	89 d0                	mov    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	c1 e0 03             	shl    $0x3,%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800548:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800550:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800555:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 c8                	add    %ecx,%eax
  800561:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800563:	39 c2                	cmp    %eax,%edx
  800565:	75 09                	jne    800570 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800567:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80056e:	eb 15                	jmp    800585 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800570:	ff 45 e8             	incl   -0x18(%ebp)
  800573:	a1 20 50 80 00       	mov    0x805020,%eax
  800578:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80057e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800581:	39 c2                	cmp    %eax,%edx
  800583:	77 85                	ja     80050a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800585:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800589:	75 14                	jne    80059f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80058b:	83 ec 04             	sub    $0x4,%esp
  80058e:	68 dc 40 80 00       	push   $0x8040dc
  800593:	6a 3a                	push   $0x3a
  800595:	68 d0 40 80 00       	push   $0x8040d0
  80059a:	e8 8d fe ff ff       	call   80042c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80059f:	ff 45 f0             	incl   -0x10(%ebp)
  8005a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	0f 8c 2f ff ff ff    	jl     8004dd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005bc:	eb 26                	jmp    8005e4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005be:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8005c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005cc:	89 d0                	mov    %edx,%eax
  8005ce:	01 c0                	add    %eax,%eax
  8005d0:	01 d0                	add    %edx,%eax
  8005d2:	c1 e0 03             	shl    $0x3,%eax
  8005d5:	01 c8                	add    %ecx,%eax
  8005d7:	8a 40 04             	mov    0x4(%eax),%al
  8005da:	3c 01                	cmp    $0x1,%al
  8005dc:	75 03                	jne    8005e1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005de:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e1:	ff 45 e0             	incl   -0x20(%ebp)
  8005e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f2:	39 c2                	cmp    %eax,%edx
  8005f4:	77 c8                	ja     8005be <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005fc:	74 14                	je     800612 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005fe:	83 ec 04             	sub    $0x4,%esp
  800601:	68 30 41 80 00       	push   $0x804130
  800606:	6a 44                	push   $0x44
  800608:	68 d0 40 80 00       	push   $0x8040d0
  80060d:	e8 1a fe ff ff       	call   80042c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800612:	90                   	nop
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	8d 48 01             	lea    0x1(%eax),%ecx
  800623:	8b 55 0c             	mov    0xc(%ebp),%edx
  800626:	89 0a                	mov    %ecx,(%edx)
  800628:	8b 55 08             	mov    0x8(%ebp),%edx
  80062b:	88 d1                	mov    %dl,%cl
  80062d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800630:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	3d ff 00 00 00       	cmp    $0xff,%eax
  80063e:	75 2c                	jne    80066c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800640:	a0 28 50 80 00       	mov    0x805028,%al
  800645:	0f b6 c0             	movzbl %al,%eax
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	8b 12                	mov    (%edx),%edx
  80064d:	89 d1                	mov    %edx,%ecx
  80064f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800652:	83 c2 08             	add    $0x8,%edx
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	50                   	push   %eax
  800659:	51                   	push   %ecx
  80065a:	52                   	push   %edx
  80065b:	e8 81 13 00 00       	call   8019e1 <sys_cputs>
  800660:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
  800666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066f:	8b 40 04             	mov    0x4(%eax),%eax
  800672:	8d 50 01             	lea    0x1(%eax),%edx
  800675:	8b 45 0c             	mov    0xc(%ebp),%eax
  800678:	89 50 04             	mov    %edx,0x4(%eax)
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800687:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80068e:	00 00 00 
	b.cnt = 0;
  800691:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800698:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a7:	50                   	push   %eax
  8006a8:	68 15 06 80 00       	push   $0x800615
  8006ad:	e8 11 02 00 00       	call   8008c3 <vprintfmt>
  8006b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006b5:	a0 28 50 80 00       	mov    0x805028,%al
  8006ba:	0f b6 c0             	movzbl %al,%eax
  8006bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	50                   	push   %eax
  8006c7:	52                   	push   %edx
  8006c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ce:	83 c0 08             	add    $0x8,%eax
  8006d1:	50                   	push   %eax
  8006d2:	e8 0a 13 00 00       	call   8019e1 <sys_cputs>
  8006d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006da:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8006e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ef:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8006f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 f4             	pushl  -0xc(%ebp)
  800705:	50                   	push   %eax
  800706:	e8 73 ff ff ff       	call   80067e <vcprintf>
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800711:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800714:	c9                   	leave  
  800715:	c3                   	ret    

00800716 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80071c:	e8 02 13 00 00       	call   801a23 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800721:	8d 45 0c             	lea    0xc(%ebp),%eax
  800724:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 f4             	pushl  -0xc(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 48 ff ff ff       	call   80067e <vcprintf>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80073c:	e8 fc 12 00 00       	call   801a3d <sys_unlock_cons>
	return cnt;
  800741:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	53                   	push   %ebx
  80074a:	83 ec 14             	sub    $0x14,%esp
  80074d:	8b 45 10             	mov    0x10(%ebp),%eax
  800750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800759:	8b 45 18             	mov    0x18(%ebp),%eax
  80075c:	ba 00 00 00 00       	mov    $0x0,%edx
  800761:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800764:	77 55                	ja     8007bb <printnum+0x75>
  800766:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800769:	72 05                	jb     800770 <printnum+0x2a>
  80076b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80076e:	77 4b                	ja     8007bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800770:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800773:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800776:	8b 45 18             	mov    0x18(%ebp),%eax
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
  80077e:	52                   	push   %edx
  80077f:	50                   	push   %eax
  800780:	ff 75 f4             	pushl  -0xc(%ebp)
  800783:	ff 75 f0             	pushl  -0x10(%ebp)
  800786:	e8 59 33 00 00       	call   803ae4 <__udivdi3>
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	83 ec 04             	sub    $0x4,%esp
  800791:	ff 75 20             	pushl  0x20(%ebp)
  800794:	53                   	push   %ebx
  800795:	ff 75 18             	pushl  0x18(%ebp)
  800798:	52                   	push   %edx
  800799:	50                   	push   %eax
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	ff 75 08             	pushl  0x8(%ebp)
  8007a0:	e8 a1 ff ff ff       	call   800746 <printnum>
  8007a5:	83 c4 20             	add    $0x20,%esp
  8007a8:	eb 1a                	jmp    8007c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 20             	pushl  0x20(%ebp)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8007be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007c2:	7f e6                	jg     8007aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d2:	53                   	push   %ebx
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	50                   	push   %eax
  8007d6:	e8 19 34 00 00       	call   803bf4 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 94 43 80 00       	add    $0x804394,%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be c0             	movsbl %al,%eax
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	50                   	push   %eax
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
}
  8007f7:	90                   	nop
  8007f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800800:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800804:	7e 1c                	jle    800822 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	8d 50 08             	lea    0x8(%eax),%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	89 10                	mov    %edx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 e8 08             	sub    $0x8,%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	eb 40                	jmp    800862 <getuint+0x65>
	else if (lflag)
  800822:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800826:	74 1e                	je     800846 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	8d 50 04             	lea    0x4(%eax),%edx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 10                	mov    %edx,(%eax)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	83 e8 04             	sub    $0x4,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	eb 1c                	jmp    800862 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	8d 50 04             	lea    0x4(%eax),%edx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	89 10                	mov    %edx,(%eax)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800867:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086b:	7e 1c                	jle    800889 <getint+0x25>
		return va_arg(*ap, long long);
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	8d 50 08             	lea    0x8(%eax),%edx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 10                	mov    %edx,(%eax)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	83 e8 08             	sub    $0x8,%eax
  800882:	8b 50 04             	mov    0x4(%eax),%edx
  800885:	8b 00                	mov    (%eax),%eax
  800887:	eb 38                	jmp    8008c1 <getint+0x5d>
	else if (lflag)
  800889:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088d:	74 1a                	je     8008a9 <getint+0x45>
		return va_arg(*ap, long);
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	8d 50 04             	lea    0x4(%eax),%edx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	89 10                	mov    %edx,(%eax)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	83 e8 04             	sub    $0x4,%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	99                   	cltd   
  8008a7:	eb 18                	jmp    8008c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	8d 50 04             	lea    0x4(%eax),%edx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	89 10                	mov    %edx,(%eax)
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	83 e8 04             	sub    $0x4,%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	99                   	cltd   
}
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cb:	eb 17                	jmp    8008e4 <vprintfmt+0x21>
			if (ch == '\0')
  8008cd:	85 db                	test   %ebx,%ebx
  8008cf:	0f 84 c1 03 00 00    	je     800c96 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	53                   	push   %ebx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	8d 50 01             	lea    0x1(%eax),%edx
  8008ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ed:	8a 00                	mov    (%eax),%al
  8008ef:	0f b6 d8             	movzbl %al,%ebx
  8008f2:	83 fb 25             	cmp    $0x25,%ebx
  8008f5:	75 d6                	jne    8008cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800902:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800909:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800910:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	8d 50 01             	lea    0x1(%eax),%edx
  80091d:	89 55 10             	mov    %edx,0x10(%ebp)
  800920:	8a 00                	mov    (%eax),%al
  800922:	0f b6 d8             	movzbl %al,%ebx
  800925:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800928:	83 f8 5b             	cmp    $0x5b,%eax
  80092b:	0f 87 3d 03 00 00    	ja     800c6e <vprintfmt+0x3ab>
  800931:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
  800938:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80093a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80093e:	eb d7                	jmp    800917 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800940:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800944:	eb d1                	jmp    800917 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80094d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800950:	89 d0                	mov    %edx,%eax
  800952:	c1 e0 02             	shl    $0x2,%eax
  800955:	01 d0                	add    %edx,%eax
  800957:	01 c0                	add    %eax,%eax
  800959:	01 d8                	add    %ebx,%eax
  80095b:	83 e8 30             	sub    $0x30,%eax
  80095e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	8a 00                	mov    (%eax),%al
  800966:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800969:	83 fb 2f             	cmp    $0x2f,%ebx
  80096c:	7e 3e                	jle    8009ac <vprintfmt+0xe9>
  80096e:	83 fb 39             	cmp    $0x39,%ebx
  800971:	7f 39                	jg     8009ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800973:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800976:	eb d5                	jmp    80094d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	83 c0 04             	add    $0x4,%eax
  80097e:	89 45 14             	mov    %eax,0x14(%ebp)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	83 e8 04             	sub    $0x4,%eax
  800987:	8b 00                	mov    (%eax),%eax
  800989:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80098c:	eb 1f                	jmp    8009ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	79 83                	jns    800917 <vprintfmt+0x54>
				width = 0;
  800994:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80099b:	e9 77 ff ff ff       	jmp    800917 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009a7:	e9 6b ff ff ff       	jmp    800917 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b1:	0f 89 60 ff ff ff    	jns    800917 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009c4:	e9 4e ff ff ff       	jmp    800917 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009cc:	e9 46 ff ff ff       	jmp    800917 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	83 c0 04             	add    $0x4,%eax
  8009d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	83 e8 04             	sub    $0x4,%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	50                   	push   %eax
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			break;
  8009f1:	e9 9b 02 00 00       	jmp    800c91 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	83 c0 04             	add    $0x4,%eax
  8009fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	83 e8 04             	sub    $0x4,%eax
  800a05:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a07:	85 db                	test   %ebx,%ebx
  800a09:	79 02                	jns    800a0d <vprintfmt+0x14a>
				err = -err;
  800a0b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a0d:	83 fb 64             	cmp    $0x64,%ebx
  800a10:	7f 0b                	jg     800a1d <vprintfmt+0x15a>
  800a12:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 a5 43 80 00       	push   $0x8043a5
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	ff 75 08             	pushl  0x8(%ebp)
  800a29:	e8 70 02 00 00       	call   800c9e <printfmt>
  800a2e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a31:	e9 5b 02 00 00       	jmp    800c91 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a36:	56                   	push   %esi
  800a37:	68 ae 43 80 00       	push   $0x8043ae
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	ff 75 08             	pushl  0x8(%ebp)
  800a42:	e8 57 02 00 00       	call   800c9e <printfmt>
  800a47:	83 c4 10             	add    $0x10,%esp
			break;
  800a4a:	e9 42 02 00 00       	jmp    800c91 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 30                	mov    (%eax),%esi
  800a60:	85 f6                	test   %esi,%esi
  800a62:	75 05                	jne    800a69 <vprintfmt+0x1a6>
				p = "(null)";
  800a64:	be b1 43 80 00       	mov    $0x8043b1,%esi
			if (width > 0 && padc != '-')
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7e 6d                	jle    800adc <vprintfmt+0x219>
  800a6f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a73:	74 67                	je     800adc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	50                   	push   %eax
  800a7c:	56                   	push   %esi
  800a7d:	e8 1e 03 00 00       	call   800da0 <strnlen>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a88:	eb 16                	jmp    800aa0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a8a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	50                   	push   %eax
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa4:	7f e4                	jg     800a8a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa6:	eb 34                	jmp    800adc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aa8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aac:	74 1c                	je     800aca <vprintfmt+0x207>
  800aae:	83 fb 1f             	cmp    $0x1f,%ebx
  800ab1:	7e 05                	jle    800ab8 <vprintfmt+0x1f5>
  800ab3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ab6:	7e 12                	jle    800aca <vprintfmt+0x207>
					putch('?', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 3f                	push   $0x3f
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	eb 0f                	jmp    800ad9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad9:	ff 4d e4             	decl   -0x1c(%ebp)
  800adc:	89 f0                	mov    %esi,%eax
  800ade:	8d 70 01             	lea    0x1(%eax),%esi
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	0f be d8             	movsbl %al,%ebx
  800ae6:	85 db                	test   %ebx,%ebx
  800ae8:	74 24                	je     800b0e <vprintfmt+0x24b>
  800aea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aee:	78 b8                	js     800aa8 <vprintfmt+0x1e5>
  800af0:	ff 4d e0             	decl   -0x20(%ebp)
  800af3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800af7:	79 af                	jns    800aa8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af9:	eb 13                	jmp    800b0e <vprintfmt+0x24b>
				putch(' ', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	6a 20                	push   $0x20
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b12:	7f e7                	jg     800afb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b14:	e9 78 01 00 00       	jmp    800c91 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 3c fd ff ff       	call   800864 <getint>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b37:	85 d2                	test   %edx,%edx
  800b39:	79 23                	jns    800b5e <vprintfmt+0x29b>
				putch('-', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 2d                	push   $0x2d
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b51:	f7 d8                	neg    %eax
  800b53:	83 d2 00             	adc    $0x0,%edx
  800b56:	f7 da                	neg    %edx
  800b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b65:	e9 bc 00 00 00       	jmp    800c26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b70:	8d 45 14             	lea    0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	e8 84 fc ff ff       	call   8007fd <getuint>
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b89:	e9 98 00 00 00       	jmp    800c26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	6a 58                	push   $0x58
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 58                	push   $0x58
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 58                	push   $0x58
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			break;
  800bbe:	e9 ce 00 00 00       	jmp    800c91 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	6a 30                	push   $0x30
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 78                	push   $0x78
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800be3:	8b 45 14             	mov    0x14(%ebp),%eax
  800be6:	83 c0 04             	add    $0x4,%eax
  800be9:	89 45 14             	mov    %eax,0x14(%ebp)
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	83 e8 04             	sub    $0x4,%eax
  800bf2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bfe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c05:	eb 1f                	jmp    800c26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c10:	50                   	push   %eax
  800c11:	e8 e7 fb ff ff       	call   8007fd <getuint>
  800c16:	83 c4 10             	add    $0x10,%esp
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2d:	83 ec 04             	sub    $0x4,%esp
  800c30:	52                   	push   %edx
  800c31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	ff 75 f0             	pushl  -0x10(%ebp)
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	ff 75 08             	pushl  0x8(%ebp)
  800c41:	e8 00 fb ff ff       	call   800746 <printnum>
  800c46:	83 c4 20             	add    $0x20,%esp
			break;
  800c49:	eb 46                	jmp    800c91 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	53                   	push   %ebx
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			break;
  800c5a:	eb 35                	jmp    800c91 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c5c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c63:	eb 2c                	jmp    800c91 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c65:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800c6c:	eb 23                	jmp    800c91 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 25                	push   $0x25
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c7e:	ff 4d 10             	decl   0x10(%ebp)
  800c81:	eb 03                	jmp    800c86 <vprintfmt+0x3c3>
  800c83:	ff 4d 10             	decl   0x10(%ebp)
  800c86:	8b 45 10             	mov    0x10(%ebp),%eax
  800c89:	48                   	dec    %eax
  800c8a:	8a 00                	mov    (%eax),%al
  800c8c:	3c 25                	cmp    $0x25,%al
  800c8e:	75 f3                	jne    800c83 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c90:	90                   	nop
		}
	}
  800c91:	e9 35 fc ff ff       	jmp    8008cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c96:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ca4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca7:	83 c0 04             	add    $0x4,%eax
  800caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cad:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb3:	50                   	push   %eax
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	ff 75 08             	pushl  0x8(%ebp)
  800cba:	e8 04 fc ff ff       	call   8008c3 <vprintfmt>
  800cbf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cc2:	90                   	nop
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8b 40 08             	mov    0x8(%eax),%eax
  800cce:	8d 50 01             	lea    0x1(%eax),%edx
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8b 10                	mov    (%eax),%edx
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8b 40 04             	mov    0x4(%eax),%eax
  800ce2:	39 c2                	cmp    %eax,%edx
  800ce4:	73 12                	jae    800cf8 <sprintputch+0x33>
		*b->buf++ = ch;
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 48 01             	lea    0x1(%eax),%ecx
  800cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf1:	89 0a                	mov    %ecx,(%edx)
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	88 10                	mov    %dl,(%eax)
}
  800cf8:	90                   	nop
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	01 d0                	add    %edx,%eax
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d20:	74 06                	je     800d28 <vsnprintf+0x2d>
  800d22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d26:	7f 07                	jg     800d2f <vsnprintf+0x34>
		return -E_INVAL;
  800d28:	b8 03 00 00 00       	mov    $0x3,%eax
  800d2d:	eb 20                	jmp    800d4f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d2f:	ff 75 14             	pushl  0x14(%ebp)
  800d32:	ff 75 10             	pushl  0x10(%ebp)
  800d35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d38:	50                   	push   %eax
  800d39:	68 c5 0c 80 00       	push   $0x800cc5
  800d3e:	e8 80 fb ff ff       	call   8008c3 <vprintfmt>
  800d43:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d49:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d57:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5a:	83 c0 04             	add    $0x4,%eax
  800d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	50                   	push   %eax
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	ff 75 08             	pushl  0x8(%ebp)
  800d6d:	e8 89 ff ff ff       	call   800cfb <vsnprintf>
  800d72:	83 c4 10             	add    $0x10,%esp
  800d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d8a:	eb 06                	jmp    800d92 <strlen+0x15>
		n++;
  800d8c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 f1                	jne    800d8c <strlen+0xf>
		n++;
	return n;
  800d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dad:	eb 09                	jmp    800db8 <strnlen+0x18>
		n++;
  800daf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db2:	ff 45 08             	incl   0x8(%ebp)
  800db5:	ff 4d 0c             	decl   0xc(%ebp)
  800db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbc:	74 09                	je     800dc7 <strnlen+0x27>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	75 e8                	jne    800daf <strnlen+0xf>
		n++;
	return n;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dd8:	90                   	nop
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 08             	mov    %edx,0x8(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	75 e4                	jne    800dd9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 1f                	jmp    800e2e <strncpy+0x34>
		*dst++ = *src;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8d 50 01             	lea    0x1(%eax),%edx
  800e15:	89 55 08             	mov    %edx,0x8(%ebp)
  800e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	74 03                	je     800e2b <strncpy+0x31>
			src++;
  800e28:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e2b:	ff 45 fc             	incl   -0x4(%ebp)
  800e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	72 d9                	jb     800e0f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4b:	74 30                	je     800e7d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e4d:	eb 16                	jmp    800e65 <strlcpy+0x2a>
			*dst++ = *src++;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 08             	mov    %edx,0x8(%ebp)
  800e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e65:	ff 4d 10             	decl   0x10(%ebp)
  800e68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6c:	74 09                	je     800e77 <strlcpy+0x3c>
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	84 c0                	test   %al,%al
  800e75:	75 d8                	jne    800e4f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	29 c2                	sub    %eax,%edx
  800e85:	89 d0                	mov    %edx,%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e8c:	eb 06                	jmp    800e94 <strcmp+0xb>
		p++, q++;
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	84 c0                	test   %al,%al
  800e9b:	74 0e                	je     800eab <strcmp+0x22>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 10                	mov    (%eax),%dl
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	38 c2                	cmp    %al,%dl
  800ea9:	74 e3                	je     800e8e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	0f b6 d0             	movzbl %al,%edx
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	0f b6 c0             	movzbl %al,%eax
  800ebb:	29 c2                	sub    %eax,%edx
  800ebd:	89 d0                	mov    %edx,%eax
}
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ec4:	eb 09                	jmp    800ecf <strncmp+0xe>
		n--, p++, q++;
  800ec6:	ff 4d 10             	decl   0x10(%ebp)
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	74 17                	je     800eec <strncmp+0x2b>
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	84 c0                	test   %al,%al
  800edc:	74 0e                	je     800eec <strncmp+0x2b>
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 10                	mov    (%eax),%dl
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	38 c2                	cmp    %al,%dl
  800eea:	74 da                	je     800ec6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef0:	75 07                	jne    800ef9 <strncmp+0x38>
		return 0;
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef7:	eb 14                	jmp    800f0d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	0f b6 d0             	movzbl %al,%edx
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 c0             	movzbl %al,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
}
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1b:	eb 12                	jmp    800f2f <strchr+0x20>
		if (*s == c)
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f25:	75 05                	jne    800f2c <strchr+0x1d>
			return (char *) s;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	eb 11                	jmp    800f3d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f2c:	ff 45 08             	incl   0x8(%ebp)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	75 e5                	jne    800f1d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    

00800f3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 04             	sub    $0x4,%esp
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f4b:	eb 0d                	jmp    800f5a <strfind+0x1b>
		if (*s == c)
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f55:	74 0e                	je     800f65 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	75 ea                	jne    800f4d <strfind+0xe>
  800f63:	eb 01                	jmp    800f66 <strfind+0x27>
		if (*s == c)
			break;
  800f65:	90                   	nop
	return (char *) s;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f77:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f7d:	eb 0e                	jmp    800f8d <memset+0x22>
		*p++ = c;
  800f7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f82:	8d 50 01             	lea    0x1(%eax),%edx
  800f85:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f8d:	ff 4d f8             	decl   -0x8(%ebp)
  800f90:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f94:	79 e9                	jns    800f7f <memset+0x14>
		*p++ = c;

	return v;
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fad:	eb 16                	jmp    800fc5 <memcpy+0x2a>
		*d++ = *s++;
  800faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb2:	8d 50 01             	lea    0x1(%eax),%edx
  800fb5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fbe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc1:	8a 12                	mov    (%edx),%dl
  800fc3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	75 dd                	jne    800faf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fe9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fef:	73 50                	jae    801041 <memmove+0x6a>
  800ff1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	01 d0                	add    %edx,%eax
  800ff9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ffc:	76 43                	jbe    801041 <memmove+0x6a>
		s += n;
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80100a:	eb 10                	jmp    80101c <memmove+0x45>
			*--d = *--s;
  80100c:	ff 4d f8             	decl   -0x8(%ebp)
  80100f:	ff 4d fc             	decl   -0x4(%ebp)
  801012:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801015:	8a 10                	mov    (%eax),%dl
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801022:	89 55 10             	mov    %edx,0x10(%ebp)
  801025:	85 c0                	test   %eax,%eax
  801027:	75 e3                	jne    80100c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801029:	eb 23                	jmp    80104e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	8d 50 01             	lea    0x1(%eax),%edx
  801031:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801034:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801037:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80103d:	8a 12                	mov    (%edx),%dl
  80103f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801041:	8b 45 10             	mov    0x10(%ebp),%eax
  801044:	8d 50 ff             	lea    -0x1(%eax),%edx
  801047:	89 55 10             	mov    %edx,0x10(%ebp)
  80104a:	85 c0                	test   %eax,%eax
  80104c:	75 dd                	jne    80102b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801065:	eb 2a                	jmp    801091 <memcmp+0x3e>
		if (*s1 != *s2)
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106a:	8a 10                	mov    (%eax),%dl
  80106c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	38 c2                	cmp    %al,%dl
  801073:	74 16                	je     80108b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f b6 d0             	movzbl %al,%edx
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f b6 c0             	movzbl %al,%eax
  801085:	29 c2                	sub    %eax,%edx
  801087:	89 d0                	mov    %edx,%eax
  801089:	eb 18                	jmp    8010a3 <memcmp+0x50>
		s1++, s2++;
  80108b:	ff 45 fc             	incl   -0x4(%ebp)
  80108e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801091:	8b 45 10             	mov    0x10(%ebp),%eax
  801094:	8d 50 ff             	lea    -0x1(%eax),%edx
  801097:	89 55 10             	mov    %edx,0x10(%ebp)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	75 c9                	jne    801067 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	01 d0                	add    %edx,%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010b6:	eb 15                	jmp    8010cd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	0f b6 d0             	movzbl %al,%edx
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	0f b6 c0             	movzbl %al,%eax
  8010c6:	39 c2                	cmp    %eax,%edx
  8010c8:	74 0d                	je     8010d7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010d3:	72 e3                	jb     8010b8 <memfind+0x13>
  8010d5:	eb 01                	jmp    8010d8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010d7:	90                   	nop
	return (void *) s;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    

008010dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f1:	eb 03                	jmp    8010f6 <strtol+0x19>
		s++;
  8010f3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 20                	cmp    $0x20,%al
  8010fd:	74 f4                	je     8010f3 <strtol+0x16>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 09                	cmp    $0x9,%al
  801106:	74 eb                	je     8010f3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 2b                	cmp    $0x2b,%al
  80110f:	75 05                	jne    801116 <strtol+0x39>
		s++;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	eb 13                	jmp    801129 <strtol+0x4c>
	else if (*s == '-')
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	3c 2d                	cmp    $0x2d,%al
  80111d:	75 0a                	jne    801129 <strtol+0x4c>
		s++, neg = 1;
  80111f:	ff 45 08             	incl   0x8(%ebp)
  801122:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112d:	74 06                	je     801135 <strtol+0x58>
  80112f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801133:	75 20                	jne    801155 <strtol+0x78>
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 30                	cmp    $0x30,%al
  80113c:	75 17                	jne    801155 <strtol+0x78>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	40                   	inc    %eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 78                	cmp    $0x78,%al
  801146:	75 0d                	jne    801155 <strtol+0x78>
		s += 2, base = 16;
  801148:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80114c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801153:	eb 28                	jmp    80117d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801155:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801159:	75 15                	jne    801170 <strtol+0x93>
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 30                	cmp    $0x30,%al
  801162:	75 0c                	jne    801170 <strtol+0x93>
		s++, base = 8;
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80116e:	eb 0d                	jmp    80117d <strtol+0xa0>
	else if (base == 0)
  801170:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801174:	75 07                	jne    80117d <strtol+0xa0>
		base = 10;
  801176:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 2f                	cmp    $0x2f,%al
  801184:	7e 19                	jle    80119f <strtol+0xc2>
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 39                	cmp    $0x39,%al
  80118d:	7f 10                	jg     80119f <strtol+0xc2>
			dig = *s - '0';
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f be c0             	movsbl %al,%eax
  801197:	83 e8 30             	sub    $0x30,%eax
  80119a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80119d:	eb 42                	jmp    8011e1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 60                	cmp    $0x60,%al
  8011a6:	7e 19                	jle    8011c1 <strtol+0xe4>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	3c 7a                	cmp    $0x7a,%al
  8011af:	7f 10                	jg     8011c1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f be c0             	movsbl %al,%eax
  8011b9:	83 e8 57             	sub    $0x57,%eax
  8011bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bf:	eb 20                	jmp    8011e1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 40                	cmp    $0x40,%al
  8011c8:	7e 39                	jle    801203 <strtol+0x126>
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 5a                	cmp    $0x5a,%al
  8011d1:	7f 30                	jg     801203 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f be c0             	movsbl %al,%eax
  8011db:	83 e8 37             	sub    $0x37,%eax
  8011de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e7:	7d 19                	jge    801202 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011e9:	ff 45 08             	incl   0x8(%ebp)
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ef:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011f3:	89 c2                	mov    %eax,%edx
  8011f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f8:	01 d0                	add    %edx,%eax
  8011fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011fd:	e9 7b ff ff ff       	jmp    80117d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801202:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801203:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801207:	74 08                	je     801211 <strtol+0x134>
		*endptr = (char *) s;
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	8b 55 08             	mov    0x8(%ebp),%edx
  80120f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801211:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801215:	74 07                	je     80121e <strtol+0x141>
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	f7 d8                	neg    %eax
  80121c:	eb 03                	jmp    801221 <strtol+0x144>
  80121e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <ltostr>:

void
ltostr(long value, char *str)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801229:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801230:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123b:	79 13                	jns    801250 <ltostr+0x2d>
	{
		neg = 1;
  80123d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80124a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80124d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801258:	99                   	cltd   
  801259:	f7 f9                	idiv   %ecx
  80125b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	8d 50 01             	lea    0x1(%eax),%edx
  801264:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801271:	83 c2 30             	add    $0x30,%edx
  801274:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801276:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801279:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80127e:	f7 e9                	imul   %ecx
  801280:	c1 fa 02             	sar    $0x2,%edx
  801283:	89 c8                	mov    %ecx,%eax
  801285:	c1 f8 1f             	sar    $0x1f,%eax
  801288:	29 c2                	sub    %eax,%edx
  80128a:	89 d0                	mov    %edx,%eax
  80128c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80128f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801293:	75 bb                	jne    801250 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801295:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80129c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129f:	48                   	dec    %eax
  8012a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a7:	74 3d                	je     8012e6 <ltostr+0xc3>
		start = 1 ;
  8012a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012b0:	eb 34                	jmp    8012e6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 c2                	add    %eax,%edx
  8012c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	01 c8                	add    %ecx,%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	01 c2                	add    %eax,%edx
  8012db:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012de:	88 02                	mov    %al,(%edx)
		start++ ;
  8012e0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012e3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ec:	7c c4                	jl     8012b2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	01 d0                	add    %edx,%eax
  8012f6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012f9:	90                   	nop
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801302:	ff 75 08             	pushl  0x8(%ebp)
  801305:	e8 73 fa ff ff       	call   800d7d <strlen>
  80130a:	83 c4 04             	add    $0x4,%esp
  80130d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801310:	ff 75 0c             	pushl  0xc(%ebp)
  801313:	e8 65 fa ff ff       	call   800d7d <strlen>
  801318:	83 c4 04             	add    $0x4,%esp
  80131b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80131e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80132c:	eb 17                	jmp    801345 <strcconcat+0x49>
		final[s] = str1[s] ;
  80132e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801331:	8b 45 10             	mov    0x10(%ebp),%eax
  801334:	01 c2                	add    %eax,%edx
  801336:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801342:	ff 45 fc             	incl   -0x4(%ebp)
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80134b:	7c e1                	jl     80132e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80134d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801354:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80135b:	eb 1f                	jmp    80137c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80135d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801360:	8d 50 01             	lea    0x1(%eax),%edx
  801363:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801366:	89 c2                	mov    %eax,%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c8                	add    %ecx,%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801379:	ff 45 f8             	incl   -0x8(%ebp)
  80137c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801382:	7c d9                	jl     80135d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801384:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 d0                	add    %edx,%eax
  80138c:	c6 00 00             	movb   $0x0,(%eax)
}
  80138f:	90                   	nop
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801395:	8b 45 14             	mov    0x14(%ebp),%eax
  801398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b5:	eb 0c                	jmp    8013c3 <strsplit+0x31>
			*string++ = 0;
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8d 50 01             	lea    0x1(%eax),%edx
  8013bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	84 c0                	test   %al,%al
  8013ca:	74 18                	je     8013e4 <strsplit+0x52>
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	0f be c0             	movsbl %al,%eax
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	e8 32 fb ff ff       	call   800f0f <strchr>
  8013dd:	83 c4 08             	add    $0x8,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	75 d3                	jne    8013b7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 5a                	je     801447 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	83 f8 0f             	cmp    $0xf,%eax
  8013f5:	75 07                	jne    8013fe <strsplit+0x6c>
		{
			return 0;
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fc:	eb 66                	jmp    801464 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	8d 48 01             	lea    0x1(%eax),%ecx
  801406:	8b 55 14             	mov    0x14(%ebp),%edx
  801409:	89 0a                	mov    %ecx,(%edx)
  80140b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 c2                	add    %eax,%edx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80141c:	eb 03                	jmp    801421 <strsplit+0x8f>
			string++;
  80141e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	84 c0                	test   %al,%al
  801428:	74 8b                	je     8013b5 <strsplit+0x23>
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f be c0             	movsbl %al,%eax
  801432:	50                   	push   %eax
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	e8 d4 fa ff ff       	call   800f0f <strchr>
  80143b:	83 c4 08             	add    $0x8,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	74 dc                	je     80141e <strsplit+0x8c>
			string++;
	}
  801442:	e9 6e ff ff ff       	jmp    8013b5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801447:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801454:	8b 45 10             	mov    0x10(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80145f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	68 28 45 80 00       	push   $0x804528
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 4a 45 80 00       	push   $0x80454a
  80147e:	e8 a9 ef ff ff       	call   80042c <_panic>

00801483 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	ff 75 08             	pushl  0x8(%ebp)
  80148f:	e8 f8 0a 00 00       	call   801f8c <sys_sbrk>
  801494:	83 c4 10             	add    $0x10,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80149f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a3:	75 0a                	jne    8014af <malloc+0x16>
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	e9 07 02 00 00       	jmp    8016b6 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8014af:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8014b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	48                   	dec    %eax
  8014bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ca:	f7 75 dc             	divl   -0x24(%ebp)
  8014cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d0:	29 d0                	sub    %edx,%eax
  8014d2:	c1 e8 0c             	shr    $0xc,%eax
  8014d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8014d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8014dd:	8b 40 78             	mov    0x78(%eax),%eax
  8014e0:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8014e5:	29 c2                	sub    %eax,%edx
  8014e7:	89 d0                	mov    %edx,%eax
  8014e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014f4:	c1 e8 0c             	shr    $0xc,%eax
  8014f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8014fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801501:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801508:	77 42                	ja     80154c <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80150a:	e8 01 09 00 00       	call   801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 dd 0e 00 00       	call   8023fb <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 13 09 00 00       	call   801e41 <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 76 13 00 00       	call   8028b7 <alloc_block_BF>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801547:	e9 67 01 00 00       	jmp    8016b3 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  80154c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80154f:	48                   	dec    %eax
  801550:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801553:	0f 86 53 01 00 00    	jbe    8016ac <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801559:	a1 20 50 80 00       	mov    0x805020,%eax
  80155e:	8b 40 78             	mov    0x78(%eax),%eax
  801561:	05 00 10 00 00       	add    $0x1000,%eax
  801566:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801569:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801570:	e9 de 00 00 00       	jmp    801653 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801575:	a1 20 50 80 00       	mov    0x805020,%eax
  80157a:	8b 40 78             	mov    0x78(%eax),%eax
  80157d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801580:	29 c2                	sub    %eax,%edx
  801582:	89 d0                	mov    %edx,%eax
  801584:	2d 00 10 00 00       	sub    $0x1000,%eax
  801589:	c1 e8 0c             	shr    $0xc,%eax
  80158c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	0f 85 ab 00 00 00    	jne    801646 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	05 00 10 00 00       	add    $0x1000,%eax
  8015a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8015a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  8015ad:	eb 47                	jmp    8015f6 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8015af:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8015b6:	76 0a                	jbe    8015c2 <malloc+0x129>
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	e9 f4 00 00 00       	jmp    8016b6 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8015c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8015c7:	8b 40 78             	mov    0x78(%eax),%eax
  8015ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015cd:	29 c2                	sub    %eax,%edx
  8015cf:	89 d0                	mov    %edx,%eax
  8015d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d6:	c1 e8 0c             	shr    $0xc,%eax
  8015d9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	74 08                	je     8015ec <malloc+0x153>
					{
						
						i = j;
  8015e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8015ea:	eb 5a                	jmp    801646 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8015ec:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8015f3:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  8015f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015f9:	48                   	dec    %eax
  8015fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015fd:	77 b0                	ja     8015af <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8015ff:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801606:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80160d:	eb 2f                	jmp    80163e <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80160f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801612:	c1 e0 0c             	shl    $0xc,%eax
  801615:	89 c2                	mov    %eax,%edx
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	01 c2                	add    %eax,%edx
  80161c:	a1 20 50 80 00       	mov    0x805020,%eax
  801621:	8b 40 78             	mov    0x78(%eax),%eax
  801624:	29 c2                	sub    %eax,%edx
  801626:	89 d0                	mov    %edx,%eax
  801628:	2d 00 10 00 00       	sub    $0x1000,%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801637:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80163b:	ff 45 e0             	incl   -0x20(%ebp)
  80163e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801641:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801644:	72 c9                	jb     80160f <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164a:	75 16                	jne    801662 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80164c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801653:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80165a:	0f 86 15 ff ff ff    	jbe    801575 <malloc+0xdc>
  801660:	eb 01                	jmp    801663 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801662:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801663:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801667:	75 07                	jne    801670 <malloc+0x1d7>
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	eb 46                	jmp    8016b6 <malloc+0x21d>
		ptr = (void*)i;
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801676:	a1 20 50 80 00       	mov    0x805020,%eax
  80167b:	8b 40 78             	mov    0x78(%eax),%eax
  80167e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801681:	29 c2                	sub    %eax,%edx
  801683:	89 d0                	mov    %edx,%eax
  801685:	2d 00 10 00 00       	sub    $0x1000,%eax
  80168a:	c1 e8 0c             	shr    $0xc,%eax
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801692:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a2:	e8 1c 09 00 00       	call   801fc3 <sys_allocate_user_mem>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	eb 07                	jmp    8016b3 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b1:	eb 03                	jmp    8016b6 <malloc+0x21d>
	}
	return ptr;
  8016b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8016be:	a1 20 50 80 00       	mov    0x805020,%eax
  8016c3:	8b 40 78             	mov    0x78(%eax),%eax
  8016c6:	05 00 10 00 00       	add    $0x1000,%eax
  8016cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8016ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8016d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016da:	8b 50 78             	mov    0x78(%eax),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	39 c2                	cmp    %eax,%edx
  8016e2:	76 24                	jbe    801708 <free+0x50>
		size = get_block_size(va);
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	e8 8c 09 00 00       	call   80207b <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 9c 1b 00 00       	call   80329c <free_block>
  801700:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801703:	e9 ac 00 00 00       	jmp    8017b4 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80170e:	0f 82 89 00 00 00    	jb     80179d <free+0xe5>
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80171c:	77 7f                	ja     80179d <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80171e:	8b 55 08             	mov    0x8(%ebp),%edx
  801721:	a1 20 50 80 00       	mov    0x805020,%eax
  801726:	8b 40 78             	mov    0x78(%eax),%eax
  801729:	29 c2                	sub    %eax,%edx
  80172b:	89 d0                	mov    %edx,%eax
  80172d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801732:	c1 e8 0c             	shr    $0xc,%eax
  801735:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  80173c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80173f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801742:	c1 e0 0c             	shl    $0xc,%eax
  801745:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80174f:	eb 42                	jmp    801793 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801754:	c1 e0 0c             	shl    $0xc,%eax
  801757:	89 c2                	mov    %eax,%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	01 c2                	add    %eax,%edx
  80175e:	a1 20 50 80 00       	mov    0x805020,%eax
  801763:	8b 40 78             	mov    0x78(%eax),%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80176f:	c1 e8 0c             	shr    $0xc,%eax
  801772:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801779:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	e8 1a 08 00 00       	call   801fa7 <sys_free_user_mem>
  80178d:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801790:	ff 45 f4             	incl   -0xc(%ebp)
  801793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801796:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801799:	72 b6                	jb     801751 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80179b:	eb 17                	jmp    8017b4 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 58 45 80 00       	push   $0x804558
  8017a5:	68 87 00 00 00       	push   $0x87
  8017aa:	68 82 45 80 00       	push   $0x804582
  8017af:	e8 78 ec ff ff       	call   80042c <_panic>
	}
}
  8017b4:	90                   	nop
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 28             	sub    $0x28,%esp
  8017bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8017c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c7:	75 0a                	jne    8017d3 <smalloc+0x1c>
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	e9 87 00 00 00       	jmp    80185a <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	39 d0                	cmp    %edx,%eax
  8017e8:	73 02                	jae    8017ec <smalloc+0x35>
  8017ea:	89 d0                	mov    %edx,%eax
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	50                   	push   %eax
  8017f0:	e8 a4 fc ff ff       	call   801499 <malloc>
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ff:	75 07                	jne    801808 <smalloc+0x51>
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	eb 52                	jmp    80185a <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801808:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80180c:	ff 75 ec             	pushl  -0x14(%ebp)
  80180f:	50                   	push   %eax
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 93 03 00 00       	call   801bae <sys_createSharedObject>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801821:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801825:	74 06                	je     80182d <smalloc+0x76>
  801827:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80182b:	75 07                	jne    801834 <smalloc+0x7d>
  80182d:	b8 00 00 00 00       	mov    $0x0,%eax
  801832:	eb 26                	jmp    80185a <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801837:	a1 20 50 80 00       	mov    0x805020,%eax
  80183c:	8b 40 78             	mov    0x78(%eax),%eax
  80183f:	29 c2                	sub    %eax,%edx
  801841:	89 d0                	mov    %edx,%eax
  801843:	2d 00 10 00 00       	sub    $0x1000,%eax
  801848:	c1 e8 0c             	shr    $0xc,%eax
  80184b:	89 c2                	mov    %eax,%edx
  80184d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801850:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801857:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 68 03 00 00       	call   801bd8 <sys_getSizeOfSharedObject>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801876:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80187a:	75 07                	jne    801883 <sget+0x27>
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax
  801881:	eb 7f                	jmp    801902 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801889:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	39 d0                	cmp    %edx,%eax
  801898:	73 02                	jae    80189c <sget+0x40>
  80189a:	89 d0                	mov    %edx,%eax
  80189c:	83 ec 0c             	sub    $0xc,%esp
  80189f:	50                   	push   %eax
  8018a0:	e8 f4 fb ff ff       	call   801499 <malloc>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018af:	75 07                	jne    8018b8 <sget+0x5c>
  8018b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b6:	eb 4a                	jmp    801902 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	e8 2c 03 00 00       	call   801bf5 <sys_getSharedObject>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8018cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d7:	8b 40 78             	mov    0x78(%eax),%eax
  8018da:	29 c2                	sub    %eax,%edx
  8018dc:	89 d0                	mov    %edx,%eax
  8018de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018e3:	c1 e8 0c             	shr    $0xc,%eax
  8018e6:	89 c2                	mov    %eax,%edx
  8018e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018eb:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018f2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018f6:	75 07                	jne    8018ff <sget+0xa3>
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fd:	eb 03                	jmp    801902 <sget+0xa6>
	return ptr;
  8018ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80190a:	8b 55 08             	mov    0x8(%ebp),%edx
  80190d:	a1 20 50 80 00       	mov    0x805020,%eax
  801912:	8b 40 78             	mov    0x78(%eax),%eax
  801915:	29 c2                	sub    %eax,%edx
  801917:	89 d0                	mov    %edx,%eax
  801919:	2d 00 10 00 00       	sub    $0x1000,%eax
  80191e:	c1 e8 0c             	shr    $0xc,%eax
  801921:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801928:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	ff 75 f4             	pushl  -0xc(%ebp)
  801934:	e8 db 02 00 00       	call   801c14 <sys_freeSharedObject>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 90 45 80 00       	push   $0x804590
  801950:	68 e4 00 00 00       	push   $0xe4
  801955:	68 82 45 80 00       	push   $0x804582
  80195a:	e8 cd ea ff ff       	call   80042c <_panic>

0080195f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 b6 45 80 00       	push   $0x8045b6
  80196d:	68 f0 00 00 00       	push   $0xf0
  801972:	68 82 45 80 00       	push   $0x804582
  801977:	e8 b0 ea ff ff       	call   80042c <_panic>

0080197c <shrink>:

}
void shrink(uint32 newSize)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 b6 45 80 00       	push   $0x8045b6
  80198a:	68 f5 00 00 00       	push   $0xf5
  80198f:	68 82 45 80 00       	push   $0x804582
  801994:	e8 93 ea ff ff       	call   80042c <_panic>

00801999 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 b6 45 80 00       	push   $0x8045b6
  8019a7:	68 fa 00 00 00       	push   $0xfa
  8019ac:	68 82 45 80 00       	push   $0x804582
  8019b1:	e8 76 ea ff ff       	call   80042c <_panic>

008019b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d1:	cd 30                	int    $0x30
  8019d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5f                   	pop    %edi
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    

008019e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	52                   	push   %edx
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	e8 b2 ff ff ff       	call   8019b6 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 02                	push   $0x2
  801a19:	e8 98 ff ff ff       	call   8019b6 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 03                	push   $0x3
  801a32:	e8 7f ff ff ff       	call   8019b6 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 04                	push   $0x4
  801a4c:	e8 65 ff ff ff       	call   8019b6 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	90                   	nop
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	52                   	push   %edx
  801a67:	50                   	push   %eax
  801a68:	6a 08                	push   $0x8
  801a6a:	e8 47 ff ff ff       	call   8019b6 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	56                   	push   %esi
  801a78:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a79:	8b 75 18             	mov    0x18(%ebp),%esi
  801a7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	56                   	push   %esi
  801a89:	53                   	push   %ebx
  801a8a:	51                   	push   %ecx
  801a8b:	52                   	push   %edx
  801a8c:	50                   	push   %eax
  801a8d:	6a 09                	push   $0x9
  801a8f:	e8 22 ff ff ff       	call   8019b6 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 0a                	push   $0xa
  801ab1:	e8 00 ff ff ff       	call   8019b6 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	ff 75 08             	pushl  0x8(%ebp)
  801aca:	6a 0b                	push   $0xb
  801acc:	e8 e5 fe ff ff       	call   8019b6 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 0c                	push   $0xc
  801ae5:	e8 cc fe ff ff       	call   8019b6 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 0d                	push   $0xd
  801afe:	e8 b3 fe ff ff       	call   8019b6 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 0e                	push   $0xe
  801b17:	e8 9a fe ff ff       	call   8019b6 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 0f                	push   $0xf
  801b30:	e8 81 fe ff ff       	call   8019b6 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 10                	push   $0x10
  801b4a:	e8 67 fe ff ff       	call   8019b6 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 11                	push   $0x11
  801b63:	e8 4e fe ff ff       	call   8019b6 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_cputc>:

void
sys_cputc(const char c)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	50                   	push   %eax
  801b87:	6a 01                	push   $0x1
  801b89:	e8 28 fe ff ff       	call   8019b6 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 14                	push   $0x14
  801ba3:	e8 0e fe ff ff       	call   8019b6 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bbd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	51                   	push   %ecx
  801bc7:	52                   	push   %edx
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	50                   	push   %eax
  801bcc:	6a 15                	push   $0x15
  801bce:	e8 e3 fd ff ff       	call   8019b6 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	6a 16                	push   $0x16
  801beb:	e8 c6 fd ff ff       	call   8019b6 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	51                   	push   %ecx
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 17                	push   $0x17
  801c0a:	e8 a7 fd ff ff       	call   8019b6 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 18                	push   $0x18
  801c27:	e8 8a fd ff ff       	call   8019b6 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 14             	pushl  0x14(%ebp)
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	6a 19                	push   $0x19
  801c45:	e8 6c fd ff ff       	call   8019b6 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 1a                	push   $0x1a
  801c60:	e8 51 fd ff ff       	call   8019b6 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 1b                	push   $0x1b
  801c7c:	e8 35 fd ff ff       	call   8019b6 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 05                	push   $0x5
  801c95:	e8 1c fd ff ff       	call   8019b6 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 06                	push   $0x6
  801cae:	e8 03 fd ff ff       	call   8019b6 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 07                	push   $0x7
  801cc7:	e8 ea fc ff ff       	call   8019b6 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 1c                	push   $0x1c
  801ce0:	e8 d1 fc ff ff       	call   8019b6 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf4:	8d 50 04             	lea    0x4(%eax),%edx
  801cf7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 1d                	push   $0x1d
  801d04:	e8 ad fc ff ff       	call   8019b6 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d15:	89 01                	mov    %eax,(%ecx)
  801d17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	c9                   	leave  
  801d1e:	c2 04 00             	ret    $0x4

00801d21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 13                	push   $0x13
  801d33:	e8 7e fc ff ff       	call   8019b6 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 1e                	push   $0x1e
  801d4d:	e8 64 fc ff ff       	call   8019b6 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	50                   	push   %eax
  801d70:	6a 1f                	push   $0x1f
  801d72:	e8 3f fc ff ff       	call   8019b6 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <rsttst>:
void rsttst()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 21                	push   $0x21
  801d8c:	e8 25 fc ff ff       	call   8019b6 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801da0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da3:	8b 55 18             	mov    0x18(%ebp),%edx
  801da6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 20                	push   $0x20
  801db7:	e8 fa fb ff ff       	call   8019b6 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <chktst>:
void chktst(uint32 n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 22                	push   $0x22
  801dd2:	e8 df fb ff ff       	call   8019b6 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <inctst>:

void inctst()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 23                	push   $0x23
  801dec:	e8 c5 fb ff ff       	call   8019b6 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <gettst>:
uint32 gettst()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 24                	push   $0x24
  801e06:	e8 ab fb ff ff       	call   8019b6 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 25                	push   $0x25
  801e22:	e8 8f fb ff ff       	call   8019b6 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 25                	push   $0x25
  801e53:	e8 5e fb ff ff       	call   8019b6 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 25                	push   $0x25
  801e84:	e8 2d fb ff ff       	call   8019b6 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 25                	push   $0x25
  801eb5:	e8 fc fa ff ff       	call   8019b6 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
  801ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec4:	75 07                	jne    801ecd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	eb 05                	jmp    801ed2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	6a 26                	push   $0x26
  801ee4:	e8 cd fa ff ff       	call   8019b6 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eec:	90                   	nop
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	53                   	push   %ebx
  801f02:	51                   	push   %ecx
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 27                	push   $0x27
  801f07:	e8 aa fa ff ff       	call   8019b6 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	6a 28                	push   $0x28
  801f27:	e8 8a fa ff ff       	call   8019b6 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f34:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	51                   	push   %ecx
  801f40:	ff 75 10             	pushl  0x10(%ebp)
  801f43:	52                   	push   %edx
  801f44:	50                   	push   %eax
  801f45:	6a 29                	push   $0x29
  801f47:	e8 6a fa ff ff       	call   8019b6 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	ff 75 10             	pushl  0x10(%ebp)
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	6a 12                	push   $0x12
  801f63:	e8 4e fa ff ff       	call   8019b6 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6b:	90                   	nop
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 2a                	push   $0x2a
  801f81:	e8 30 fa ff ff       	call   8019b6 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
	return;
  801f89:	90                   	nop
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	50                   	push   %eax
  801f9b:	6a 2b                	push   $0x2b
  801f9d:	e8 14 fa ff ff       	call   8019b6 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	6a 2c                	push   $0x2c
  801fb8:	e8 f9 f9 ff ff       	call   8019b6 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
	return;
  801fc0:	90                   	nop
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	6a 2d                	push   $0x2d
  801fd4:	e8 dd f9 ff ff       	call   8019b6 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
	return;
  801fdc:	90                   	nop
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 2e                	push   $0x2e
  801ff1:	e8 c0 f9 ff ff       	call   8019b6 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
  801ff9:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	50                   	push   %eax
  802010:	6a 2f                	push   $0x2f
  802012:	e8 9f f9 ff ff       	call   8019b6 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802020:	8b 55 0c             	mov    0xc(%ebp),%edx
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 30                	push   $0x30
  802030:	e8 81 f9 ff ff       	call   8019b6 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
	return;
  802038:	90                   	nop
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	50                   	push   %eax
  80204d:	6a 31                	push   $0x31
  80204f:	e8 62 f9 ff ff       	call   8019b6 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
  802057:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80205a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	50                   	push   %eax
  80206e:	6a 32                	push   $0x32
  802070:	e8 41 f9 ff ff       	call   8019b6 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
	return;
  802078:	90                   	nop
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	83 e8 04             	sub    $0x4,%eax
  802087:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	83 e8 04             	sub    $0x4,%eax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a6:	8b 00                	mov    (%eax),%eax
  8020a8:	83 e0 01             	and    $0x1,%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	0f 94 c0             	sete   %al
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c2:	83 f8 02             	cmp    $0x2,%eax
  8020c5:	74 2b                	je     8020f2 <alloc_block+0x40>
  8020c7:	83 f8 02             	cmp    $0x2,%eax
  8020ca:	7f 07                	jg     8020d3 <alloc_block+0x21>
  8020cc:	83 f8 01             	cmp    $0x1,%eax
  8020cf:	74 0e                	je     8020df <alloc_block+0x2d>
  8020d1:	eb 58                	jmp    80212b <alloc_block+0x79>
  8020d3:	83 f8 03             	cmp    $0x3,%eax
  8020d6:	74 2d                	je     802105 <alloc_block+0x53>
  8020d8:	83 f8 04             	cmp    $0x4,%eax
  8020db:	74 3b                	je     802118 <alloc_block+0x66>
  8020dd:	eb 4c                	jmp    80212b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 11 03 00 00       	call   8023fb <alloc_block_FF>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f0:	eb 4a                	jmp    80213c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	e8 c7 19 00 00       	call   803ac4 <alloc_block_NF>
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802103:	eb 37                	jmp    80213c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	e8 a7 07 00 00       	call   8028b7 <alloc_block_BF>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802116:	eb 24                	jmp    80213c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	e8 84 19 00 00       	call   803aa7 <alloc_block_WF>
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802129:	eb 11                	jmp    80213c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 c8 45 80 00       	push   $0x8045c8
  802133:	e8 b1 e5 ff ff       	call   8006e9 <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
		break;
  80213b:	90                   	nop
	}
	return va;
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	53                   	push   %ebx
  802145:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802148:	83 ec 0c             	sub    $0xc,%esp
  80214b:	68 e8 45 80 00       	push   $0x8045e8
  802150:	e8 94 e5 ff ff       	call   8006e9 <cprintf>
  802155:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802158:	83 ec 0c             	sub    $0xc,%esp
  80215b:	68 13 46 80 00       	push   $0x804613
  802160:	e8 84 e5 ff ff       	call   8006e9 <cprintf>
  802165:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216e:	eb 37                	jmp    8021a7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 f4             	pushl  -0xc(%ebp)
  802176:	e8 19 ff ff ff       	call   802094 <is_free_block>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	0f be d8             	movsbl %al,%ebx
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	ff 75 f4             	pushl  -0xc(%ebp)
  802187:	e8 ef fe ff ff       	call   80207b <get_block_size>
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	53                   	push   %ebx
  802193:	50                   	push   %eax
  802194:	68 2b 46 80 00       	push   $0x80462b
  802199:	e8 4b e5 ff ff       	call   8006e9 <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ab:	74 07                	je     8021b4 <print_blocks_list+0x73>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	eb 05                	jmp    8021b9 <print_blocks_list+0x78>
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	89 45 10             	mov    %eax,0x10(%ebp)
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 ad                	jne    802170 <print_blocks_list+0x2f>
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	75 a7                	jne    802170 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	68 e8 45 80 00       	push   $0x8045e8
  8021d1:	e8 13 e5 ff ff       	call   8006e9 <cprintf>
  8021d6:	83 c4 10             	add    $0x10,%esp

}
  8021d9:	90                   	nop
  8021da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	83 e0 01             	and    $0x1,%eax
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	74 03                	je     8021f2 <initialize_dynamic_allocator+0x13>
  8021ef:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021f6:	0f 84 c7 01 00 00    	je     8023c3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021fc:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802203:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802206:	8b 55 08             	mov    0x8(%ebp),%edx
  802209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802213:	0f 87 ad 01 00 00    	ja     8023c6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	0f 89 a5 01 00 00    	jns    8023c9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222a:	01 d0                	add    %edx,%eax
  80222c:	83 e8 04             	sub    $0x4,%eax
  80222f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80223b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802243:	e9 87 00 00 00       	jmp    8022cf <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224c:	75 14                	jne    802262 <initialize_dynamic_allocator+0x83>
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 43 46 80 00       	push   $0x804643
  802256:	6a 79                	push   $0x79
  802258:	68 61 46 80 00       	push   $0x804661
  80225d:	e8 ca e1 ff ff       	call   80042c <_panic>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 10                	je     80227b <initialize_dynamic_allocator+0x9c>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	8b 52 04             	mov    0x4(%edx),%edx
  802276:	89 50 04             	mov    %edx,0x4(%eax)
  802279:	eb 0b                	jmp    802286 <initialize_dynamic_allocator+0xa7>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	a3 30 50 80 00       	mov    %eax,0x805030
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0f                	je     80229f <initialize_dynamic_allocator+0xc0>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 40 04             	mov    0x4(%eax),%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	8b 12                	mov    (%edx),%edx
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	eb 0a                	jmp    8022a9 <initialize_dynamic_allocator+0xca>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8022c1:	48                   	dec    %eax
  8022c2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8022cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	74 07                	je     8022dc <initialize_dynamic_allocator+0xfd>
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	eb 05                	jmp    8022e1 <initialize_dynamic_allocator+0x102>
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8022e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	0f 85 55 ff ff ff    	jne    802248 <initialize_dynamic_allocator+0x69>
  8022f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f7:	0f 85 4b ff ff ff    	jne    802248 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80230c:	a1 44 50 80 00       	mov    0x805044,%eax
  802311:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802316:	a1 40 50 80 00       	mov    0x805040,%eax
  80231b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	83 c0 08             	add    $0x8,%eax
  802327:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	83 c0 04             	add    $0x4,%eax
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	83 ea 08             	sub    $0x8,%edx
  802336:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	01 d0                	add    %edx,%eax
  802340:	83 e8 08             	sub    $0x8,%eax
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	83 ea 08             	sub    $0x8,%edx
  802349:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80234b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80235e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802362:	75 17                	jne    80237b <initialize_dynamic_allocator+0x19c>
  802364:	83 ec 04             	sub    $0x4,%esp
  802367:	68 7c 46 80 00       	push   $0x80467c
  80236c:	68 90 00 00 00       	push   $0x90
  802371:	68 61 46 80 00       	push   $0x804661
  802376:	e8 b1 e0 ff ff       	call   80042c <_panic>
  80237b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802384:	89 10                	mov    %edx,(%eax)
  802386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 0d                	je     80239c <initialize_dynamic_allocator+0x1bd>
  80238f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802394:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	eb 08                	jmp    8023a4 <initialize_dynamic_allocator+0x1c5>
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8023bb:	40                   	inc    %eax
  8023bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8023c1:	eb 07                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023c3:	90                   	nop
  8023c4:	eb 04                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023c6:	90                   	nop
  8023c7:	eb 01                	jmp    8023ca <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023c9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023de:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 e8 04             	sub    $0x4,%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8023eb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	01 c2                	add    %eax,%edx
  8023f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f6:	89 02                	mov    %eax,(%edx)
}
  8023f8:	90                   	nop
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    

008023fb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	83 e0 01             	and    $0x1,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 03                	je     80240e <alloc_block_FF+0x13>
  80240b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80240e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802412:	77 07                	ja     80241b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802414:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80241b:	a1 24 50 80 00       	mov    0x805024,%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	75 73                	jne    802497 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	83 c0 10             	add    $0x10,%eax
  80242a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80242d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243a:	01 d0                	add    %edx,%eax
  80243c:	48                   	dec    %eax
  80243d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802443:	ba 00 00 00 00       	mov    $0x0,%edx
  802448:	f7 75 ec             	divl   -0x14(%ebp)
  80244b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244e:	29 d0                	sub    %edx,%eax
  802450:	c1 e8 0c             	shr    $0xc,%eax
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	50                   	push   %eax
  802457:	e8 27 f0 ff ff       	call   801483 <sbrk>
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	6a 00                	push   $0x0
  802467:	e8 17 f0 ff ff       	call   801483 <sbrk>
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802475:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802478:	83 ec 08             	sub    $0x8,%esp
  80247b:	50                   	push   %eax
  80247c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80247f:	e8 5b fd ff ff       	call   8021df <initialize_dynamic_allocator>
  802484:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	68 9f 46 80 00       	push   $0x80469f
  80248f:	e8 55 e2 ff ff       	call   8006e9 <cprintf>
  802494:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249b:	75 0a                	jne    8024a7 <alloc_block_FF+0xac>
	        return NULL;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	e9 0e 04 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b6:	e9 f3 02 00 00       	jmp    8027ae <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 75 bc             	pushl  -0x44(%ebp)
  8024c7:	e8 af fb ff ff       	call   80207b <get_block_size>
  8024cc:	83 c4 10             	add    $0x10,%esp
  8024cf:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	83 c0 08             	add    $0x8,%eax
  8024d8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024db:	0f 87 c5 02 00 00    	ja     8027a6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	83 c0 18             	add    $0x18,%eax
  8024e7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ea:	0f 87 19 02 00 00    	ja     802709 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f6:	83 e8 08             	sub    $0x8,%eax
  8024f9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	8d 50 08             	lea    0x8(%eax),%edx
  802502:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	83 c0 08             	add    $0x8,%eax
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	6a 01                	push   $0x1
  802515:	50                   	push   %eax
  802516:	ff 75 bc             	pushl  -0x44(%ebp)
  802519:	e8 ae fe ff ff       	call   8023cc <set_block_data>
  80251e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	75 68                	jne    802593 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80252b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80252f:	75 17                	jne    802548 <alloc_block_FF+0x14d>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 7c 46 80 00       	push   $0x80467c
  802539:	68 d7 00 00 00       	push   $0xd7
  80253e:	68 61 46 80 00       	push   $0x804661
  802543:	e8 e4 de ff ff       	call   80042c <_panic>
  802548:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80254e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802551:	89 10                	mov    %edx,(%eax)
  802553:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	74 0d                	je     802569 <alloc_block_FF+0x16e>
  80255c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802561:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802564:	89 50 04             	mov    %edx,0x4(%eax)
  802567:	eb 08                	jmp    802571 <alloc_block_FF+0x176>
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	a3 30 50 80 00       	mov    %eax,0x805030
  802571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802574:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802579:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802583:	a1 38 50 80 00       	mov    0x805038,%eax
  802588:	40                   	inc    %eax
  802589:	a3 38 50 80 00       	mov    %eax,0x805038
  80258e:	e9 dc 00 00 00       	jmp    80266f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	75 65                	jne    802601 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80259c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025a0:	75 17                	jne    8025b9 <alloc_block_FF+0x1be>
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 b0 46 80 00       	push   $0x8046b0
  8025aa:	68 db 00 00 00       	push   $0xdb
  8025af:	68 61 46 80 00       	push   $0x804661
  8025b4:	e8 73 de ff ff       	call   80042c <_panic>
  8025b9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0c                	je     8025db <alloc_block_FF+0x1e0>
  8025cf:	a1 30 50 80 00       	mov    0x805030,%eax
  8025d4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 08                	jmp    8025e3 <alloc_block_FF+0x1e8>
  8025db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8025eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f9:	40                   	inc    %eax
  8025fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8025ff:	eb 6e                	jmp    80266f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802605:	74 06                	je     80260d <alloc_block_FF+0x212>
  802607:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_FF+0x229>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 d4 46 80 00       	push   $0x8046d4
  802615:	68 df 00 00 00       	push   $0xdf
  80261a:	68 61 46 80 00       	push   $0x804661
  80261f:	e8 08 de ff ff       	call   80042c <_panic>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 10                	mov    (%eax),%edx
  802629:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262c:	89 10                	mov    %edx,(%eax)
  80262e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 0b                	je     802642 <alloc_block_FF+0x247>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80263f:	89 50 04             	mov    %edx,0x4(%eax)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802648:	89 10                	mov    %edx,(%eax)
  80264a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	89 50 04             	mov    %edx,0x4(%eax)
  802653:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 08                	jne    802664 <alloc_block_FF+0x269>
  80265c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265f:	a3 30 50 80 00       	mov    %eax,0x805030
  802664:	a1 38 50 80 00       	mov    0x805038,%eax
  802669:	40                   	inc    %eax
  80266a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_FF+0x291>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 43 46 80 00       	push   $0x804643
  80267d:	68 e1 00 00 00       	push   $0xe1
  802682:	68 61 46 80 00       	push   $0x804661
  802687:	e8 a0 dd ff ff       	call   80042c <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_FF+0x2aa>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_FF+0x2b5>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_FF+0x2ce>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_FF+0x2d8>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	6a 00                	push   $0x0
  8026f6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026f9:	ff 75 b0             	pushl  -0x50(%ebp)
  8026fc:	e8 cb fc ff ff       	call   8023cc <set_block_data>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	e9 95 00 00 00       	jmp    80279e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	6a 01                	push   $0x1
  80270e:	ff 75 b8             	pushl  -0x48(%ebp)
  802711:	ff 75 bc             	pushl  -0x44(%ebp)
  802714:	e8 b3 fc ff ff       	call   8023cc <set_block_data>
  802719:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80271c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_FF+0x33e>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 43 46 80 00       	push   $0x804643
  80272a:	68 e8 00 00 00       	push   $0xe8
  80272f:	68 61 46 80 00       	push   $0x804661
  802734:	e8 f3 dc ff ff       	call   80042c <_panic>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_FF+0x357>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_FF+0x362>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 30 50 80 00       	mov    %eax,0x805030
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_FF+0x37b>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_FF+0x385>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 38 50 80 00       	mov    0x805038,%eax
  802798:	48                   	dec    %eax
  802799:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80279e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027a1:	e9 0f 01 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b2:	74 07                	je     8027bb <alloc_block_FF+0x3c0>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	eb 05                	jmp    8027c0 <alloc_block_FF+0x3c5>
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8027c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 85 e9 fc ff ff    	jne    8024bb <alloc_block_FF+0xc0>
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	0f 85 df fc ff ff    	jne    8024bb <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	83 c0 08             	add    $0x8,%eax
  8027e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027e5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	48                   	dec    %eax
  8027f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802800:	f7 75 d8             	divl   -0x28(%ebp)
  802803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802806:	29 d0                	sub    %edx,%eax
  802808:	c1 e8 0c             	shr    $0xc,%eax
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	50                   	push   %eax
  80280f:	e8 6f ec ff ff       	call   801483 <sbrk>
  802814:	83 c4 10             	add    $0x10,%esp
  802817:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80281a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80281e:	75 0a                	jne    80282a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
  802825:	e9 8b 00 00 00       	jmp    8028b5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80282a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802831:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802834:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802837:	01 d0                	add    %edx,%eax
  802839:	48                   	dec    %eax
  80283a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80283d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802840:	ba 00 00 00 00       	mov    $0x0,%edx
  802845:	f7 75 cc             	divl   -0x34(%ebp)
  802848:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80284b:	29 d0                	sub    %edx,%eax
  80284d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802850:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802853:	01 d0                	add    %edx,%eax
  802855:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80285a:	a1 40 50 80 00       	mov    0x805040,%eax
  80285f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802865:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80286c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80286f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802872:	01 d0                	add    %edx,%eax
  802874:	48                   	dec    %eax
  802875:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802878:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80287b:	ba 00 00 00 00       	mov    $0x0,%edx
  802880:	f7 75 c4             	divl   -0x3c(%ebp)
  802883:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802886:	29 d0                	sub    %edx,%eax
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	6a 01                	push   $0x1
  80288d:	50                   	push   %eax
  80288e:	ff 75 d0             	pushl  -0x30(%ebp)
  802891:	e8 36 fb ff ff       	call   8023cc <set_block_data>
  802896:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	ff 75 d0             	pushl  -0x30(%ebp)
  80289f:	e8 f8 09 00 00       	call   80329c <free_block>
  8028a4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028a7:	83 ec 0c             	sub    $0xc,%esp
  8028aa:	ff 75 08             	pushl  0x8(%ebp)
  8028ad:	e8 49 fb ff ff       	call   8023fb <alloc_block_FF>
  8028b2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	83 e0 01             	and    $0x1,%eax
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	74 03                	je     8028ca <alloc_block_BF+0x13>
  8028c7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028ca:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028ce:	77 07                	ja     8028d7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028d0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	75 73                	jne    802953 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	83 c0 10             	add    $0x10,%eax
  8028e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028e9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	48                   	dec    %eax
  8028f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802904:	f7 75 e0             	divl   -0x20(%ebp)
  802907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80290a:	29 d0                	sub    %edx,%eax
  80290c:	c1 e8 0c             	shr    $0xc,%eax
  80290f:	83 ec 0c             	sub    $0xc,%esp
  802912:	50                   	push   %eax
  802913:	e8 6b eb ff ff       	call   801483 <sbrk>
  802918:	83 c4 10             	add    $0x10,%esp
  80291b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	6a 00                	push   $0x0
  802923:	e8 5b eb ff ff       	call   801483 <sbrk>
  802928:	83 c4 10             	add    $0x10,%esp
  80292b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80292e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802931:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802934:	83 ec 08             	sub    $0x8,%esp
  802937:	50                   	push   %eax
  802938:	ff 75 d8             	pushl  -0x28(%ebp)
  80293b:	e8 9f f8 ff ff       	call   8021df <initialize_dynamic_allocator>
  802940:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	68 9f 46 80 00       	push   $0x80469f
  80294b:	e8 99 dd ff ff       	call   8006e9 <cprintf>
  802950:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80295a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802961:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802968:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80296f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802977:	e9 1d 01 00 00       	jmp    802a99 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	ff 75 a8             	pushl  -0x58(%ebp)
  802988:	e8 ee f6 ff ff       	call   80207b <get_block_size>
  80298d:	83 c4 10             	add    $0x10,%esp
  802990:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 08             	add    $0x8,%eax
  802999:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80299c:	0f 87 ef 00 00 00    	ja     802a91 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	83 c0 18             	add    $0x18,%eax
  8029a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ab:	77 1d                	ja     8029ca <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b3:	0f 86 d8 00 00 00    	jbe    802a91 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029bf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029c5:	e9 c7 00 00 00       	jmp    802a91 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	83 c0 08             	add    $0x8,%eax
  8029d0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029d3:	0f 85 9d 00 00 00    	jne    802a76 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	6a 01                	push   $0x1
  8029de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029e1:	ff 75 a8             	pushl  -0x58(%ebp)
  8029e4:	e8 e3 f9 ff ff       	call   8023cc <set_block_data>
  8029e9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_BF+0x152>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 43 46 80 00       	push   $0x804643
  8029fa:	68 2c 01 00 00       	push   $0x12c
  8029ff:	68 61 46 80 00       	push   $0x804661
  802a04:	e8 23 da ff ff       	call   80042c <_panic>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 10                	je     802a22 <alloc_block_BF+0x16b>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	8b 52 04             	mov    0x4(%edx),%edx
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	eb 0b                	jmp    802a2d <alloc_block_BF+0x176>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0f                	je     802a46 <alloc_block_BF+0x18f>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a40:	8b 12                	mov    (%edx),%edx
  802a42:	89 10                	mov    %edx,(%eax)
  802a44:	eb 0a                	jmp    802a50 <alloc_block_BF+0x199>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a63:	a1 38 50 80 00       	mov    0x805038,%eax
  802a68:	48                   	dec    %eax
  802a69:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a71:	e9 01 04 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a79:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a7c:	76 13                	jbe    802a91 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a7e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a85:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a8b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a91:	a1 34 50 80 00       	mov    0x805034,%eax
  802a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9d:	74 07                	je     802aa6 <alloc_block_BF+0x1ef>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	eb 05                	jmp    802aab <alloc_block_BF+0x1f4>
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aab:	a3 34 50 80 00       	mov    %eax,0x805034
  802ab0:	a1 34 50 80 00       	mov    0x805034,%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	0f 85 bf fe ff ff    	jne    80297c <alloc_block_BF+0xc5>
  802abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac1:	0f 85 b5 fe ff ff    	jne    80297c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ac7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802acb:	0f 84 26 02 00 00    	je     802cf7 <alloc_block_BF+0x440>
  802ad1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad5:	0f 85 1c 02 00 00    	jne    802cf7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae1:	83 e8 08             	sub    $0x8,%eax
  802ae4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8d 50 08             	lea    0x8(%eax),%edx
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	83 c0 08             	add    $0x8,%eax
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	6a 01                	push   $0x1
  802b00:	50                   	push   %eax
  802b01:	ff 75 f0             	pushl  -0x10(%ebp)
  802b04:	e8 c3 f8 ff ff       	call   8023cc <set_block_data>
  802b09:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	75 68                	jne    802b7e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b16:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b1a:	75 17                	jne    802b33 <alloc_block_BF+0x27c>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 7c 46 80 00       	push   $0x80467c
  802b24:	68 45 01 00 00       	push   $0x145
  802b29:	68 61 46 80 00       	push   $0x804661
  802b2e:	e8 f9 d8 ff ff       	call   80042c <_panic>
  802b33:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0d                	je     802b54 <alloc_block_BF+0x29d>
  802b47:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 08                	jmp    802b5c <alloc_block_BF+0x2a5>
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	a3 30 50 80 00       	mov    %eax,0x805030
  802b5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b73:	40                   	inc    %eax
  802b74:	a3 38 50 80 00       	mov    %eax,0x805038
  802b79:	e9 dc 00 00 00       	jmp    802c5a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	75 65                	jne    802bec <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b87:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b8b:	75 17                	jne    802ba4 <alloc_block_BF+0x2ed>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 b0 46 80 00       	push   $0x8046b0
  802b95:	68 4a 01 00 00       	push   $0x14a
  802b9a:	68 61 46 80 00       	push   $0x804661
  802b9f:	e8 88 d8 ff ff       	call   80042c <_panic>
  802ba4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802baa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0c                	je     802bc6 <alloc_block_BF+0x30f>
  802bba:	a1 30 50 80 00       	mov    0x805030,%eax
  802bbf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	eb 08                	jmp    802bce <alloc_block_BF+0x317>
  802bc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd1:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	a1 38 50 80 00       	mov    0x805038,%eax
  802be4:	40                   	inc    %eax
  802be5:	a3 38 50 80 00       	mov    %eax,0x805038
  802bea:	eb 6e                	jmp    802c5a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf0:	74 06                	je     802bf8 <alloc_block_BF+0x341>
  802bf2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bf6:	75 17                	jne    802c0f <alloc_block_BF+0x358>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 d4 46 80 00       	push   $0x8046d4
  802c00:	68 4f 01 00 00       	push   $0x14f
  802c05:	68 61 46 80 00       	push   $0x804661
  802c0a:	e8 1d d8 ff ff       	call   80042c <_panic>
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	8b 10                	mov    (%eax),%edx
  802c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c17:	89 10                	mov    %edx,(%eax)
  802c19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0b                	je     802c2d <alloc_block_BF+0x376>
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	75 08                	jne    802c4f <alloc_block_BF+0x398>
  802c47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c54:	40                   	inc    %eax
  802c55:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5e:	75 17                	jne    802c77 <alloc_block_BF+0x3c0>
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	68 43 46 80 00       	push   $0x804643
  802c68:	68 51 01 00 00       	push   $0x151
  802c6d:	68 61 46 80 00       	push   $0x804661
  802c72:	e8 b5 d7 ff ff       	call   80042c <_panic>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 10                	je     802c90 <alloc_block_BF+0x3d9>
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c88:	8b 52 04             	mov    0x4(%edx),%edx
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	eb 0b                	jmp    802c9b <alloc_block_BF+0x3e4>
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 0f                	je     802cb4 <alloc_block_BF+0x3fd>
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 40 04             	mov    0x4(%eax),%eax
  802cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cae:	8b 12                	mov    (%edx),%edx
  802cb0:	89 10                	mov    %edx,(%eax)
  802cb2:	eb 0a                	jmp    802cbe <alloc_block_BF+0x407>
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd1:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	6a 00                	push   $0x0
  802ce1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ce4:	ff 75 cc             	pushl  -0x34(%ebp)
  802ce7:	e8 e0 f6 ff ff       	call   8023cc <set_block_data>
  802cec:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	e9 80 01 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802cf7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cfb:	0f 85 9d 00 00 00    	jne    802d9e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d01:	83 ec 04             	sub    $0x4,%esp
  802d04:	6a 01                	push   $0x1
  802d06:	ff 75 ec             	pushl  -0x14(%ebp)
  802d09:	ff 75 f0             	pushl  -0x10(%ebp)
  802d0c:	e8 bb f6 ff ff       	call   8023cc <set_block_data>
  802d11:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d18:	75 17                	jne    802d31 <alloc_block_BF+0x47a>
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	68 43 46 80 00       	push   $0x804643
  802d22:	68 58 01 00 00       	push   $0x158
  802d27:	68 61 46 80 00       	push   $0x804661
  802d2c:	e8 fb d6 ff ff       	call   80042c <_panic>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 10                	je     802d4a <alloc_block_BF+0x493>
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	8b 52 04             	mov    0x4(%edx),%edx
  802d45:	89 50 04             	mov    %edx,0x4(%eax)
  802d48:	eb 0b                	jmp    802d55 <alloc_block_BF+0x49e>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	a3 30 50 80 00       	mov    %eax,0x805030
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 0f                	je     802d6e <alloc_block_BF+0x4b7>
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d68:	8b 12                	mov    (%edx),%edx
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	eb 0a                	jmp    802d78 <alloc_block_BF+0x4c1>
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8b:	a1 38 50 80 00       	mov    0x805038,%eax
  802d90:	48                   	dec    %eax
  802d91:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	e9 d9 00 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	83 c0 08             	add    $0x8,%eax
  802da4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802da7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802db4:	01 d0                	add    %edx,%eax
  802db6:	48                   	dec    %eax
  802db7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc2:	f7 75 c4             	divl   -0x3c(%ebp)
  802dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dc8:	29 d0                	sub    %edx,%eax
  802dca:	c1 e8 0c             	shr    $0xc,%eax
  802dcd:	83 ec 0c             	sub    $0xc,%esp
  802dd0:	50                   	push   %eax
  802dd1:	e8 ad e6 ff ff       	call   801483 <sbrk>
  802dd6:	83 c4 10             	add    $0x10,%esp
  802dd9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ddc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802de0:	75 0a                	jne    802dec <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	e9 8b 00 00 00       	jmp    802e77 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dec:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802df3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802df6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	48                   	dec    %eax
  802dfc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e02:	ba 00 00 00 00       	mov    $0x0,%edx
  802e07:	f7 75 b8             	divl   -0x48(%ebp)
  802e0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e0d:	29 d0                	sub    %edx,%eax
  802e0f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e12:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e15:	01 d0                	add    %edx,%eax
  802e17:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e1c:	a1 40 50 80 00       	mov    0x805040,%eax
  802e21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e27:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e34:	01 d0                	add    %edx,%eax
  802e36:	48                   	dec    %eax
  802e37:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e42:	f7 75 b0             	divl   -0x50(%ebp)
  802e45:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e48:	29 d0                	sub    %edx,%eax
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	6a 01                	push   $0x1
  802e4f:	50                   	push   %eax
  802e50:	ff 75 bc             	pushl  -0x44(%ebp)
  802e53:	e8 74 f5 ff ff       	call   8023cc <set_block_data>
  802e58:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e5b:	83 ec 0c             	sub    $0xc,%esp
  802e5e:	ff 75 bc             	pushl  -0x44(%ebp)
  802e61:	e8 36 04 00 00       	call   80329c <free_block>
  802e66:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e69:	83 ec 0c             	sub    $0xc,%esp
  802e6c:	ff 75 08             	pushl  0x8(%ebp)
  802e6f:	e8 43 fa ff ff       	call   8028b7 <alloc_block_BF>
  802e74:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
  802e7c:	53                   	push   %ebx
  802e7d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e87:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e92:	74 1e                	je     802eb2 <merging+0x39>
  802e94:	ff 75 08             	pushl  0x8(%ebp)
  802e97:	e8 df f1 ff ff       	call   80207b <get_block_size>
  802e9c:	83 c4 04             	add    $0x4,%esp
  802e9f:	89 c2                	mov    %eax,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	01 d0                	add    %edx,%eax
  802ea6:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ea9:	75 07                	jne    802eb2 <merging+0x39>
		prev_is_free = 1;
  802eab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb6:	74 1e                	je     802ed6 <merging+0x5d>
  802eb8:	ff 75 10             	pushl  0x10(%ebp)
  802ebb:	e8 bb f1 ff ff       	call   80207b <get_block_size>
  802ec0:	83 c4 04             	add    $0x4,%esp
  802ec3:	89 c2                	mov    %eax,%edx
  802ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec8:	01 d0                	add    %edx,%eax
  802eca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecd:	75 07                	jne    802ed6 <merging+0x5d>
		next_is_free = 1;
  802ecf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eda:	0f 84 cc 00 00 00    	je     802fac <merging+0x133>
  802ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee4:	0f 84 c2 00 00 00    	je     802fac <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eea:	ff 75 08             	pushl  0x8(%ebp)
  802eed:	e8 89 f1 ff ff       	call   80207b <get_block_size>
  802ef2:	83 c4 04             	add    $0x4,%esp
  802ef5:	89 c3                	mov    %eax,%ebx
  802ef7:	ff 75 10             	pushl  0x10(%ebp)
  802efa:	e8 7c f1 ff ff       	call   80207b <get_block_size>
  802eff:	83 c4 04             	add    $0x4,%esp
  802f02:	01 c3                	add    %eax,%ebx
  802f04:	ff 75 0c             	pushl  0xc(%ebp)
  802f07:	e8 6f f1 ff ff       	call   80207b <get_block_size>
  802f0c:	83 c4 04             	add    $0x4,%esp
  802f0f:	01 d8                	add    %ebx,%eax
  802f11:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f14:	6a 00                	push   $0x0
  802f16:	ff 75 ec             	pushl  -0x14(%ebp)
  802f19:	ff 75 08             	pushl  0x8(%ebp)
  802f1c:	e8 ab f4 ff ff       	call   8023cc <set_block_data>
  802f21:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f28:	75 17                	jne    802f41 <merging+0xc8>
  802f2a:	83 ec 04             	sub    $0x4,%esp
  802f2d:	68 43 46 80 00       	push   $0x804643
  802f32:	68 7d 01 00 00       	push   $0x17d
  802f37:	68 61 46 80 00       	push   $0x804661
  802f3c:	e8 eb d4 ff ff       	call   80042c <_panic>
  802f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 10                	je     802f5a <merging+0xe1>
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f52:	8b 52 04             	mov    0x4(%edx),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	eb 0b                	jmp    802f65 <merging+0xec>
  802f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	a3 30 50 80 00       	mov    %eax,0x805030
  802f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0f                	je     802f7e <merging+0x105>
  802f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f78:	8b 12                	mov    (%edx),%edx
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	eb 0a                	jmp    802f88 <merging+0x10f>
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa0:	48                   	dec    %eax
  802fa1:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fa6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa7:	e9 ea 02 00 00       	jmp    803296 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb0:	74 3b                	je     802fed <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	e8 be f0 ff ff       	call   80207b <get_block_size>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	89 c3                	mov    %eax,%ebx
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	ff 75 10             	pushl  0x10(%ebp)
  802fc8:	e8 ae f0 ff ff       	call   80207b <get_block_size>
  802fcd:	83 c4 10             	add    $0x10,%esp
  802fd0:	01 d8                	add    %ebx,%eax
  802fd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	6a 00                	push   $0x0
  802fda:	ff 75 e8             	pushl  -0x18(%ebp)
  802fdd:	ff 75 08             	pushl  0x8(%ebp)
  802fe0:	e8 e7 f3 ff ff       	call   8023cc <set_block_data>
  802fe5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe8:	e9 a9 02 00 00       	jmp    803296 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff1:	0f 84 2d 01 00 00    	je     803124 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 10             	pushl  0x10(%ebp)
  802ffd:	e8 79 f0 ff ff       	call   80207b <get_block_size>
  803002:	83 c4 10             	add    $0x10,%esp
  803005:	89 c3                	mov    %eax,%ebx
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	ff 75 0c             	pushl  0xc(%ebp)
  80300d:	e8 69 f0 ff ff       	call   80207b <get_block_size>
  803012:	83 c4 10             	add    $0x10,%esp
  803015:	01 d8                	add    %ebx,%eax
  803017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	6a 00                	push   $0x0
  80301f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803022:	ff 75 10             	pushl  0x10(%ebp)
  803025:	e8 a2 f3 ff ff       	call   8023cc <set_block_data>
  80302a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80302d:	8b 45 10             	mov    0x10(%ebp),%eax
  803030:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803037:	74 06                	je     80303f <merging+0x1c6>
  803039:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80303d:	75 17                	jne    803056 <merging+0x1dd>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 08 47 80 00       	push   $0x804708
  803047:	68 8d 01 00 00       	push   $0x18d
  80304c:	68 61 46 80 00       	push   $0x804661
  803051:	e8 d6 d3 ff ff       	call   80042c <_panic>
  803056:	8b 45 0c             	mov    0xc(%ebp),%eax
  803059:	8b 50 04             	mov    0x4(%eax),%edx
  80305c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803065:	8b 55 0c             	mov    0xc(%ebp),%edx
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0d                	je     803081 <merging+0x208>
  803074:	8b 45 0c             	mov    0xc(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307d:	89 10                	mov    %edx,(%eax)
  80307f:	eb 08                	jmp    803089 <merging+0x210>
  803081:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803084:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	a1 38 50 80 00       	mov    0x805038,%eax
  803097:	40                   	inc    %eax
  803098:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80309d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a1:	75 17                	jne    8030ba <merging+0x241>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 43 46 80 00       	push   $0x804643
  8030ab:	68 8e 01 00 00       	push   $0x18e
  8030b0:	68 61 46 80 00       	push   $0x804661
  8030b5:	e8 72 d3 ff ff       	call   80042c <_panic>
  8030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 10                	je     8030d3 <merging+0x25a>
  8030c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cb:	8b 52 04             	mov    0x4(%edx),%edx
  8030ce:	89 50 04             	mov    %edx,0x4(%eax)
  8030d1:	eb 0b                	jmp    8030de <merging+0x265>
  8030d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d6:	8b 40 04             	mov    0x4(%eax),%eax
  8030d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0f                	je     8030f7 <merging+0x27e>
  8030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f1:	8b 12                	mov    (%edx),%edx
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	eb 0a                	jmp    803101 <merging+0x288>
  8030f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803101:	8b 45 0c             	mov    0xc(%ebp),%eax
  803104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803114:	a1 38 50 80 00       	mov    0x805038,%eax
  803119:	48                   	dec    %eax
  80311a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80311f:	e9 72 01 00 00       	jmp    803296 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803124:	8b 45 10             	mov    0x10(%ebp),%eax
  803127:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80312a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312e:	74 79                	je     8031a9 <merging+0x330>
  803130:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803134:	74 73                	je     8031a9 <merging+0x330>
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	74 06                	je     803142 <merging+0x2c9>
  80313c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803140:	75 17                	jne    803159 <merging+0x2e0>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 d4 46 80 00       	push   $0x8046d4
  80314a:	68 94 01 00 00       	push   $0x194
  80314f:	68 61 46 80 00       	push   $0x804661
  803154:	e8 d3 d2 ff ff       	call   80042c <_panic>
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 10                	mov    (%eax),%edx
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	89 10                	mov    %edx,(%eax)
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0b                	je     803177 <merging+0x2fe>
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80317d:	89 10                	mov    %edx,(%eax)
  80317f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803182:	8b 55 08             	mov    0x8(%ebp),%edx
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	75 08                	jne    803199 <merging+0x320>
  803191:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803194:	a3 30 50 80 00       	mov    %eax,0x805030
  803199:	a1 38 50 80 00       	mov    0x805038,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 38 50 80 00       	mov    %eax,0x805038
  8031a4:	e9 ce 00 00 00       	jmp    803277 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ad:	74 65                	je     803214 <merging+0x39b>
  8031af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b3:	75 17                	jne    8031cc <merging+0x353>
  8031b5:	83 ec 04             	sub    $0x4,%esp
  8031b8:	68 b0 46 80 00       	push   $0x8046b0
  8031bd:	68 95 01 00 00       	push   $0x195
  8031c2:	68 61 46 80 00       	push   $0x804661
  8031c7:	e8 60 d2 ff ff       	call   80042c <_panic>
  8031cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031db:	8b 40 04             	mov    0x4(%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 0c                	je     8031ee <merging+0x375>
  8031e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	eb 08                	jmp    8031f6 <merging+0x37d>
  8031ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8031fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	a1 38 50 80 00       	mov    0x805038,%eax
  80320c:	40                   	inc    %eax
  80320d:	a3 38 50 80 00       	mov    %eax,0x805038
  803212:	eb 63                	jmp    803277 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803214:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803218:	75 17                	jne    803231 <merging+0x3b8>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 7c 46 80 00       	push   $0x80467c
  803222:	68 98 01 00 00       	push   $0x198
  803227:	68 61 46 80 00       	push   $0x804661
  80322c:	e8 fb d1 ff ff       	call   80042c <_panic>
  803231:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803237:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323a:	89 10                	mov    %edx,(%eax)
  80323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	74 0d                	je     803252 <merging+0x3d9>
  803245:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80324a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%eax)
  803250:	eb 08                	jmp    80325a <merging+0x3e1>
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	a3 30 50 80 00       	mov    %eax,0x805030
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326c:	a1 38 50 80 00       	mov    0x805038,%eax
  803271:	40                   	inc    %eax
  803272:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 10             	pushl  0x10(%ebp)
  80327d:	e8 f9 ed ff ff       	call   80207b <get_block_size>
  803282:	83 c4 10             	add    $0x10,%esp
  803285:	83 ec 04             	sub    $0x4,%esp
  803288:	6a 00                	push   $0x0
  80328a:	50                   	push   %eax
  80328b:	ff 75 10             	pushl  0x10(%ebp)
  80328e:	e8 39 f1 ff ff       	call   8023cc <set_block_data>
  803293:	83 c4 10             	add    $0x10,%esp
	}
}
  803296:	90                   	nop
  803297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80329a:	c9                   	leave  
  80329b:	c3                   	ret    

0080329c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80329c:	55                   	push   %ebp
  80329d:	89 e5                	mov    %esp,%ebp
  80329f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8032af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b2:	73 1b                	jae    8032cf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032b4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	ff 75 08             	pushl  0x8(%ebp)
  8032bf:	6a 00                	push   $0x0
  8032c1:	50                   	push   %eax
  8032c2:	e8 b2 fb ff ff       	call   802e79 <merging>
  8032c7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ca:	e9 8b 00 00 00       	jmp    80335a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d7:	76 18                	jbe    8032f1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032d9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	ff 75 08             	pushl  0x8(%ebp)
  8032e4:	50                   	push   %eax
  8032e5:	6a 00                	push   $0x0
  8032e7:	e8 8d fb ff ff       	call   802e79 <merging>
  8032ec:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ef:	eb 69                	jmp    80335a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f9:	eb 39                	jmp    803334 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803301:	73 29                	jae    80332c <free_block+0x90>
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330b:	76 1f                	jbe    80332c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	ff 75 08             	pushl  0x8(%ebp)
  80331b:	ff 75 f0             	pushl  -0x10(%ebp)
  80331e:	ff 75 f4             	pushl  -0xc(%ebp)
  803321:	e8 53 fb ff ff       	call   802e79 <merging>
  803326:	83 c4 10             	add    $0x10,%esp
			break;
  803329:	90                   	nop
		}
	}
}
  80332a:	eb 2e                	jmp    80335a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80332c:	a1 34 50 80 00       	mov    0x805034,%eax
  803331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	74 07                	je     803341 <free_block+0xa5>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	eb 05                	jmp    803346 <free_block+0xaa>
  803341:	b8 00 00 00 00       	mov    $0x0,%eax
  803346:	a3 34 50 80 00       	mov    %eax,0x805034
  80334b:	a1 34 50 80 00       	mov    0x805034,%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	75 a7                	jne    8032fb <free_block+0x5f>
  803354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803358:	75 a1                	jne    8032fb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335a:	90                   	nop
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
  803360:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803363:	ff 75 08             	pushl  0x8(%ebp)
  803366:	e8 10 ed ff ff       	call   80207b <get_block_size>
  80336b:	83 c4 04             	add    $0x4,%esp
  80336e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803378:	eb 17                	jmp    803391 <copy_data+0x34>
  80337a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	01 c2                	add    %eax,%edx
  803382:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	01 c8                	add    %ecx,%eax
  80338a:	8a 00                	mov    (%eax),%al
  80338c:	88 02                	mov    %al,(%edx)
  80338e:	ff 45 fc             	incl   -0x4(%ebp)
  803391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803394:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803397:	72 e1                	jb     80337a <copy_data+0x1d>
}
  803399:	90                   	nop
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
  80339f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a6:	75 23                	jne    8033cb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ac:	74 13                	je     8033c1 <realloc_block_FF+0x25>
  8033ae:	83 ec 0c             	sub    $0xc,%esp
  8033b1:	ff 75 0c             	pushl  0xc(%ebp)
  8033b4:	e8 42 f0 ff ff       	call   8023fb <alloc_block_FF>
  8033b9:	83 c4 10             	add    $0x10,%esp
  8033bc:	e9 e4 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
		return NULL;
  8033c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c6:	e9 da 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8033cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033cf:	75 18                	jne    8033e9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033d1:	83 ec 0c             	sub    $0xc,%esp
  8033d4:	ff 75 08             	pushl  0x8(%ebp)
  8033d7:	e8 c0 fe ff ff       	call   80329c <free_block>
  8033dc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033df:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e4:	e9 bc 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033e9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033ed:	77 07                	ja     8033f6 <realloc_block_FF+0x5a>
  8033ef:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f9:	83 e0 01             	and    $0x1,%eax
  8033fc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	83 c0 08             	add    $0x8,%eax
  803405:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	ff 75 08             	pushl  0x8(%ebp)
  80340e:	e8 68 ec ff ff       	call   80207b <get_block_size>
  803413:	83 c4 10             	add    $0x10,%esp
  803416:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341c:	83 e8 08             	sub    $0x8,%eax
  80341f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	83 e8 04             	sub    $0x4,%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	83 e0 fe             	and    $0xfffffffe,%eax
  80342d:	89 c2                	mov    %eax,%edx
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	01 d0                	add    %edx,%eax
  803434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803437:	83 ec 0c             	sub    $0xc,%esp
  80343a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80343d:	e8 39 ec ff ff       	call   80207b <get_block_size>
  803442:	83 c4 10             	add    $0x10,%esp
  803445:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344b:	83 e8 08             	sub    $0x8,%eax
  80344e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803457:	75 08                	jne    803461 <realloc_block_FF+0xc5>
	{
		 return va;
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	e9 44 06 00 00       	jmp    803aa5 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803461:	8b 45 0c             	mov    0xc(%ebp),%eax
  803464:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803467:	0f 83 d5 03 00 00    	jae    803842 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	2b 45 0c             	sub    0xc(%ebp),%eax
  803473:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803476:	83 ec 0c             	sub    $0xc,%esp
  803479:	ff 75 e4             	pushl  -0x1c(%ebp)
  80347c:	e8 13 ec ff ff       	call   802094 <is_free_block>
  803481:	83 c4 10             	add    $0x10,%esp
  803484:	84 c0                	test   %al,%al
  803486:	0f 84 3b 01 00 00    	je     8035c7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80348c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803497:	83 ec 04             	sub    $0x4,%esp
  80349a:	6a 01                	push   $0x1
  80349c:	ff 75 f0             	pushl  -0x10(%ebp)
  80349f:	ff 75 08             	pushl  0x8(%ebp)
  8034a2:	e8 25 ef ff ff       	call   8023cc <set_block_data>
  8034a7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	83 e8 04             	sub    $0x4,%eax
  8034b0:	8b 00                	mov    (%eax),%eax
  8034b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8034b5:	89 c2                	mov    %eax,%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	01 d0                	add    %edx,%eax
  8034bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	6a 00                	push   $0x0
  8034c4:	ff 75 cc             	pushl  -0x34(%ebp)
  8034c7:	ff 75 c8             	pushl  -0x38(%ebp)
  8034ca:	e8 fd ee ff ff       	call   8023cc <set_block_data>
  8034cf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d6:	74 06                	je     8034de <realloc_block_FF+0x142>
  8034d8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034dc:	75 17                	jne    8034f5 <realloc_block_FF+0x159>
  8034de:	83 ec 04             	sub    $0x4,%esp
  8034e1:	68 d4 46 80 00       	push   $0x8046d4
  8034e6:	68 f6 01 00 00       	push   $0x1f6
  8034eb:	68 61 46 80 00       	push   $0x804661
  8034f0:	e8 37 cf ff ff       	call   80042c <_panic>
  8034f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f8:	8b 10                	mov    (%eax),%edx
  8034fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fd:	89 10                	mov    %edx,(%eax)
  8034ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 0b                	je     803513 <realloc_block_FF+0x177>
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803510:	89 50 04             	mov    %edx,0x4(%eax)
  803513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803516:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803519:	89 10                	mov    %edx,(%eax)
  80351b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80351e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	75 08                	jne    803535 <realloc_block_FF+0x199>
  80352d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803530:	a3 30 50 80 00       	mov    %eax,0x805030
  803535:	a1 38 50 80 00       	mov    0x805038,%eax
  80353a:	40                   	inc    %eax
  80353b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803544:	75 17                	jne    80355d <realloc_block_FF+0x1c1>
  803546:	83 ec 04             	sub    $0x4,%esp
  803549:	68 43 46 80 00       	push   $0x804643
  80354e:	68 f7 01 00 00       	push   $0x1f7
  803553:	68 61 46 80 00       	push   $0x804661
  803558:	e8 cf ce ff ff       	call   80042c <_panic>
  80355d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	85 c0                	test   %eax,%eax
  803564:	74 10                	je     803576 <realloc_block_FF+0x1da>
  803566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356e:	8b 52 04             	mov    0x4(%edx),%edx
  803571:	89 50 04             	mov    %edx,0x4(%eax)
  803574:	eb 0b                	jmp    803581 <realloc_block_FF+0x1e5>
  803576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	a3 30 50 80 00       	mov    %eax,0x805030
  803581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803584:	8b 40 04             	mov    0x4(%eax),%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 0f                	je     80359a <realloc_block_FF+0x1fe>
  80358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803594:	8b 12                	mov    (%edx),%edx
  803596:	89 10                	mov    %edx,(%eax)
  803598:	eb 0a                	jmp    8035a4 <realloc_block_FF+0x208>
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bc:	48                   	dec    %eax
  8035bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c2:	e9 73 02 00 00       	jmp    80383a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8035c7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035cb:	0f 86 69 02 00 00    	jbe    80383a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	6a 01                	push   $0x1
  8035d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035d9:	ff 75 08             	pushl  0x8(%ebp)
  8035dc:	e8 eb ed ff ff       	call   8023cc <set_block_data>
  8035e1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	83 e8 04             	sub    $0x4,%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	83 e0 fe             	and    $0xfffffffe,%eax
  8035ef:	89 c2                	mov    %eax,%edx
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	01 d0                	add    %edx,%eax
  8035f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803601:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803605:	75 68                	jne    80366f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x288>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 7c 46 80 00       	push   $0x80467c
  803615:	68 06 02 00 00       	push   $0x206
  80361a:	68 61 46 80 00       	push   $0x804661
  80361f:	e8 08 ce ff ff       	call   80042c <_panic>
  803624:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 0d                	je     803645 <realloc_block_FF+0x2a9>
  803638:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80363d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	eb 08                	jmp    80364d <realloc_block_FF+0x2b1>
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803650:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365f:	a1 38 50 80 00       	mov    0x805038,%eax
  803664:	40                   	inc    %eax
  803665:	a3 38 50 80 00       	mov    %eax,0x805038
  80366a:	e9 b0 01 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80366f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803674:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803677:	76 68                	jbe    8036e1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803679:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80367d:	75 17                	jne    803696 <realloc_block_FF+0x2fa>
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	68 7c 46 80 00       	push   $0x80467c
  803687:	68 0b 02 00 00       	push   $0x20b
  80368c:	68 61 46 80 00       	push   $0x804661
  803691:	e8 96 cd ff ff       	call   80042c <_panic>
  803696:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80369c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369f:	89 10                	mov    %edx,(%eax)
  8036a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	74 0d                	je     8036b7 <realloc_block_FF+0x31b>
  8036aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b2:	89 50 04             	mov    %edx,0x4(%eax)
  8036b5:	eb 08                	jmp    8036bf <realloc_block_FF+0x323>
  8036b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d6:	40                   	inc    %eax
  8036d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036dc:	e9 3e 01 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036e6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e9:	73 68                	jae    803753 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ef:	75 17                	jne    803708 <realloc_block_FF+0x36c>
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	68 b0 46 80 00       	push   $0x8046b0
  8036f9:	68 10 02 00 00       	push   $0x210
  8036fe:	68 61 46 80 00       	push   $0x804661
  803703:	e8 24 cd ff ff       	call   80042c <_panic>
  803708:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80370e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803711:	89 50 04             	mov    %edx,0x4(%eax)
  803714:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803717:	8b 40 04             	mov    0x4(%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0c                	je     80372a <realloc_block_FF+0x38e>
  80371e:	a1 30 50 80 00       	mov    0x805030,%eax
  803723:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803726:	89 10                	mov    %edx,(%eax)
  803728:	eb 08                	jmp    803732 <realloc_block_FF+0x396>
  80372a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803735:	a3 30 50 80 00       	mov    %eax,0x805030
  80373a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803743:	a1 38 50 80 00       	mov    0x805038,%eax
  803748:	40                   	inc    %eax
  803749:	a3 38 50 80 00       	mov    %eax,0x805038
  80374e:	e9 cc 00 00 00       	jmp    80381f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80375a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80375f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803762:	e9 8a 00 00 00       	jmp    8037f1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80376d:	73 7a                	jae    8037e9 <realloc_block_FF+0x44d>
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803777:	73 70                	jae    8037e9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377d:	74 06                	je     803785 <realloc_block_FF+0x3e9>
  80377f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803783:	75 17                	jne    80379c <realloc_block_FF+0x400>
  803785:	83 ec 04             	sub    $0x4,%esp
  803788:	68 d4 46 80 00       	push   $0x8046d4
  80378d:	68 1a 02 00 00       	push   $0x21a
  803792:	68 61 46 80 00       	push   $0x804661
  803797:	e8 90 cc ff ff       	call   80042c <_panic>
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 10                	mov    (%eax),%edx
  8037a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 0b                	je     8037ba <realloc_block_FF+0x41e>
  8037af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037c0:	89 10                	mov    %edx,(%eax)
  8037c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c8:	89 50 04             	mov    %edx,0x4(%eax)
  8037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ce:	8b 00                	mov    (%eax),%eax
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	75 08                	jne    8037dc <realloc_block_FF+0x440>
  8037d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e1:	40                   	inc    %eax
  8037e2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037e7:	eb 36                	jmp    80381f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f5:	74 07                	je     8037fe <realloc_block_FF+0x462>
  8037f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	eb 05                	jmp    803803 <realloc_block_FF+0x467>
  8037fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803803:	a3 34 50 80 00       	mov    %eax,0x805034
  803808:	a1 34 50 80 00       	mov    0x805034,%eax
  80380d:	85 c0                	test   %eax,%eax
  80380f:	0f 85 52 ff ff ff    	jne    803767 <realloc_block_FF+0x3cb>
  803815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803819:	0f 85 48 ff ff ff    	jne    803767 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80381f:	83 ec 04             	sub    $0x4,%esp
  803822:	6a 00                	push   $0x0
  803824:	ff 75 d8             	pushl  -0x28(%ebp)
  803827:	ff 75 d4             	pushl  -0x2c(%ebp)
  80382a:	e8 9d eb ff ff       	call   8023cc <set_block_data>
  80382f:	83 c4 10             	add    $0x10,%esp
				return va;
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	e9 6b 02 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	e9 63 02 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803842:	8b 45 0c             	mov    0xc(%ebp),%eax
  803845:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803848:	0f 86 4d 02 00 00    	jbe    803a9b <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80384e:	83 ec 0c             	sub    $0xc,%esp
  803851:	ff 75 e4             	pushl  -0x1c(%ebp)
  803854:	e8 3b e8 ff ff       	call   802094 <is_free_block>
  803859:	83 c4 10             	add    $0x10,%esp
  80385c:	84 c0                	test   %al,%al
  80385e:	0f 84 37 02 00 00    	je     803a9b <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803864:	8b 45 0c             	mov    0xc(%ebp),%eax
  803867:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80386a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80386d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803870:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803873:	76 38                	jbe    8038ad <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803875:	83 ec 0c             	sub    $0xc,%esp
  803878:	ff 75 0c             	pushl  0xc(%ebp)
  80387b:	e8 7b eb ff ff       	call   8023fb <alloc_block_FF>
  803880:	83 c4 10             	add    $0x10,%esp
  803883:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803886:	83 ec 08             	sub    $0x8,%esp
  803889:	ff 75 c0             	pushl  -0x40(%ebp)
  80388c:	ff 75 08             	pushl  0x8(%ebp)
  80388f:	e8 c9 fa ff ff       	call   80335d <copy_data>
  803894:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803897:	83 ec 0c             	sub    $0xc,%esp
  80389a:	ff 75 08             	pushl  0x8(%ebp)
  80389d:	e8 fa f9 ff ff       	call   80329c <free_block>
  8038a2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038a8:	e9 f8 01 00 00       	jmp    803aa5 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038b6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038ba:	0f 87 a0 00 00 00    	ja     803960 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c4:	75 17                	jne    8038dd <realloc_block_FF+0x541>
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	68 43 46 80 00       	push   $0x804643
  8038ce:	68 38 02 00 00       	push   $0x238
  8038d3:	68 61 46 80 00       	push   $0x804661
  8038d8:	e8 4f cb ff ff       	call   80042c <_panic>
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 10                	je     8038f6 <realloc_block_FF+0x55a>
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ee:	8b 52 04             	mov    0x4(%edx),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 0b                	jmp    803901 <realloc_block_FF+0x565>
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0f                	je     80391a <realloc_block_FF+0x57e>
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803914:	8b 12                	mov    (%edx),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 0a                	jmp    803924 <realloc_block_FF+0x588>
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803937:	a1 38 50 80 00       	mov    0x805038,%eax
  80393c:	48                   	dec    %eax
  80393d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803942:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803948:	01 d0                	add    %edx,%eax
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	6a 01                	push   $0x1
  80394f:	50                   	push   %eax
  803950:	ff 75 08             	pushl  0x8(%ebp)
  803953:	e8 74 ea ff ff       	call   8023cc <set_block_data>
  803958:	83 c4 10             	add    $0x10,%esp
  80395b:	e9 36 01 00 00       	jmp    803a96 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803960:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803963:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803966:	01 d0                	add    %edx,%eax
  803968:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	6a 01                	push   $0x1
  803970:	ff 75 f0             	pushl  -0x10(%ebp)
  803973:	ff 75 08             	pushl  0x8(%ebp)
  803976:	e8 51 ea ff ff       	call   8023cc <set_block_data>
  80397b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	83 e8 04             	sub    $0x4,%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	83 e0 fe             	and    $0xfffffffe,%eax
  803989:	89 c2                	mov    %eax,%edx
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	01 d0                	add    %edx,%eax
  803990:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803997:	74 06                	je     80399f <realloc_block_FF+0x603>
  803999:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80399d:	75 17                	jne    8039b6 <realloc_block_FF+0x61a>
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 d4 46 80 00       	push   $0x8046d4
  8039a7:	68 44 02 00 00       	push   $0x244
  8039ac:	68 61 46 80 00       	push   $0x804661
  8039b1:	e8 76 ca ff ff       	call   80042c <_panic>
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	8b 10                	mov    (%eax),%edx
  8039bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039be:	89 10                	mov    %edx,(%eax)
  8039c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	85 c0                	test   %eax,%eax
  8039c7:	74 0b                	je     8039d4 <realloc_block_FF+0x638>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039da:	89 10                	mov    %edx,(%eax)
  8039dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e2:	89 50 04             	mov    %edx,0x4(%eax)
  8039e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e8:	8b 00                	mov    (%eax),%eax
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	75 08                	jne    8039f6 <realloc_block_FF+0x65a>
  8039ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039fb:	40                   	inc    %eax
  8039fc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a05:	75 17                	jne    803a1e <realloc_block_FF+0x682>
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 43 46 80 00       	push   $0x804643
  803a0f:	68 45 02 00 00       	push   $0x245
  803a14:	68 61 46 80 00       	push   $0x804661
  803a19:	e8 0e ca ff ff       	call   80042c <_panic>
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 10                	je     803a37 <realloc_block_FF+0x69b>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2f:	8b 52 04             	mov    0x4(%edx),%edx
  803a32:	89 50 04             	mov    %edx,0x4(%eax)
  803a35:	eb 0b                	jmp    803a42 <realloc_block_FF+0x6a6>
  803a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	85 c0                	test   %eax,%eax
  803a4a:	74 0f                	je     803a5b <realloc_block_FF+0x6bf>
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	8b 40 04             	mov    0x4(%eax),%eax
  803a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a55:	8b 12                	mov    (%edx),%edx
  803a57:	89 10                	mov    %edx,(%eax)
  803a59:	eb 0a                	jmp    803a65 <realloc_block_FF+0x6c9>
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a78:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7d:	48                   	dec    %eax
  803a7e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	6a 00                	push   $0x0
  803a88:	ff 75 bc             	pushl  -0x44(%ebp)
  803a8b:	ff 75 b8             	pushl  -0x48(%ebp)
  803a8e:	e8 39 e9 ff ff       	call   8023cc <set_block_data>
  803a93:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	eb 0a                	jmp    803aa5 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a9b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aa5:	c9                   	leave  
  803aa6:	c3                   	ret    

00803aa7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803aa7:	55                   	push   %ebp
  803aa8:	89 e5                	mov    %esp,%ebp
  803aaa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803aad:	83 ec 04             	sub    $0x4,%esp
  803ab0:	68 40 47 80 00       	push   $0x804740
  803ab5:	68 58 02 00 00       	push   $0x258
  803aba:	68 61 46 80 00       	push   $0x804661
  803abf:	e8 68 c9 ff ff       	call   80042c <_panic>

00803ac4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ac4:	55                   	push   %ebp
  803ac5:	89 e5                	mov    %esp,%ebp
  803ac7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	68 68 47 80 00       	push   $0x804768
  803ad2:	68 61 02 00 00       	push   $0x261
  803ad7:	68 61 46 80 00       	push   $0x804661
  803adc:	e8 4b c9 ff ff       	call   80042c <_panic>
  803ae1:	66 90                	xchg   %ax,%ax
  803ae3:	90                   	nop

00803ae4 <__udivdi3>:
  803ae4:	55                   	push   %ebp
  803ae5:	57                   	push   %edi
  803ae6:	56                   	push   %esi
  803ae7:	53                   	push   %ebx
  803ae8:	83 ec 1c             	sub    $0x1c,%esp
  803aeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803afb:	89 ca                	mov    %ecx,%edx
  803afd:	89 f8                	mov    %edi,%eax
  803aff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b03:	85 f6                	test   %esi,%esi
  803b05:	75 2d                	jne    803b34 <__udivdi3+0x50>
  803b07:	39 cf                	cmp    %ecx,%edi
  803b09:	77 65                	ja     803b70 <__udivdi3+0x8c>
  803b0b:	89 fd                	mov    %edi,%ebp
  803b0d:	85 ff                	test   %edi,%edi
  803b0f:	75 0b                	jne    803b1c <__udivdi3+0x38>
  803b11:	b8 01 00 00 00       	mov    $0x1,%eax
  803b16:	31 d2                	xor    %edx,%edx
  803b18:	f7 f7                	div    %edi
  803b1a:	89 c5                	mov    %eax,%ebp
  803b1c:	31 d2                	xor    %edx,%edx
  803b1e:	89 c8                	mov    %ecx,%eax
  803b20:	f7 f5                	div    %ebp
  803b22:	89 c1                	mov    %eax,%ecx
  803b24:	89 d8                	mov    %ebx,%eax
  803b26:	f7 f5                	div    %ebp
  803b28:	89 cf                	mov    %ecx,%edi
  803b2a:	89 fa                	mov    %edi,%edx
  803b2c:	83 c4 1c             	add    $0x1c,%esp
  803b2f:	5b                   	pop    %ebx
  803b30:	5e                   	pop    %esi
  803b31:	5f                   	pop    %edi
  803b32:	5d                   	pop    %ebp
  803b33:	c3                   	ret    
  803b34:	39 ce                	cmp    %ecx,%esi
  803b36:	77 28                	ja     803b60 <__udivdi3+0x7c>
  803b38:	0f bd fe             	bsr    %esi,%edi
  803b3b:	83 f7 1f             	xor    $0x1f,%edi
  803b3e:	75 40                	jne    803b80 <__udivdi3+0x9c>
  803b40:	39 ce                	cmp    %ecx,%esi
  803b42:	72 0a                	jb     803b4e <__udivdi3+0x6a>
  803b44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b48:	0f 87 9e 00 00 00    	ja     803bec <__udivdi3+0x108>
  803b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b53:	89 fa                	mov    %edi,%edx
  803b55:	83 c4 1c             	add    $0x1c,%esp
  803b58:	5b                   	pop    %ebx
  803b59:	5e                   	pop    %esi
  803b5a:	5f                   	pop    %edi
  803b5b:	5d                   	pop    %ebp
  803b5c:	c3                   	ret    
  803b5d:	8d 76 00             	lea    0x0(%esi),%esi
  803b60:	31 ff                	xor    %edi,%edi
  803b62:	31 c0                	xor    %eax,%eax
  803b64:	89 fa                	mov    %edi,%edx
  803b66:	83 c4 1c             	add    $0x1c,%esp
  803b69:	5b                   	pop    %ebx
  803b6a:	5e                   	pop    %esi
  803b6b:	5f                   	pop    %edi
  803b6c:	5d                   	pop    %ebp
  803b6d:	c3                   	ret    
  803b6e:	66 90                	xchg   %ax,%ax
  803b70:	89 d8                	mov    %ebx,%eax
  803b72:	f7 f7                	div    %edi
  803b74:	31 ff                	xor    %edi,%edi
  803b76:	89 fa                	mov    %edi,%edx
  803b78:	83 c4 1c             	add    $0x1c,%esp
  803b7b:	5b                   	pop    %ebx
  803b7c:	5e                   	pop    %esi
  803b7d:	5f                   	pop    %edi
  803b7e:	5d                   	pop    %ebp
  803b7f:	c3                   	ret    
  803b80:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b85:	89 eb                	mov    %ebp,%ebx
  803b87:	29 fb                	sub    %edi,%ebx
  803b89:	89 f9                	mov    %edi,%ecx
  803b8b:	d3 e6                	shl    %cl,%esi
  803b8d:	89 c5                	mov    %eax,%ebp
  803b8f:	88 d9                	mov    %bl,%cl
  803b91:	d3 ed                	shr    %cl,%ebp
  803b93:	89 e9                	mov    %ebp,%ecx
  803b95:	09 f1                	or     %esi,%ecx
  803b97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e0                	shl    %cl,%eax
  803b9f:	89 c5                	mov    %eax,%ebp
  803ba1:	89 d6                	mov    %edx,%esi
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 ee                	shr    %cl,%esi
  803ba7:	89 f9                	mov    %edi,%ecx
  803ba9:	d3 e2                	shl    %cl,%edx
  803bab:	8b 44 24 08          	mov    0x8(%esp),%eax
  803baf:	88 d9                	mov    %bl,%cl
  803bb1:	d3 e8                	shr    %cl,%eax
  803bb3:	09 c2                	or     %eax,%edx
  803bb5:	89 d0                	mov    %edx,%eax
  803bb7:	89 f2                	mov    %esi,%edx
  803bb9:	f7 74 24 0c          	divl   0xc(%esp)
  803bbd:	89 d6                	mov    %edx,%esi
  803bbf:	89 c3                	mov    %eax,%ebx
  803bc1:	f7 e5                	mul    %ebp
  803bc3:	39 d6                	cmp    %edx,%esi
  803bc5:	72 19                	jb     803be0 <__udivdi3+0xfc>
  803bc7:	74 0b                	je     803bd4 <__udivdi3+0xf0>
  803bc9:	89 d8                	mov    %ebx,%eax
  803bcb:	31 ff                	xor    %edi,%edi
  803bcd:	e9 58 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd8:	89 f9                	mov    %edi,%ecx
  803bda:	d3 e2                	shl    %cl,%edx
  803bdc:	39 c2                	cmp    %eax,%edx
  803bde:	73 e9                	jae    803bc9 <__udivdi3+0xe5>
  803be0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 40 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	31 c0                	xor    %eax,%eax
  803bee:	e9 37 ff ff ff       	jmp    803b2a <__udivdi3+0x46>
  803bf3:	90                   	nop

00803bf4 <__umoddi3>:
  803bf4:	55                   	push   %ebp
  803bf5:	57                   	push   %edi
  803bf6:	56                   	push   %esi
  803bf7:	53                   	push   %ebx
  803bf8:	83 ec 1c             	sub    $0x1c,%esp
  803bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c13:	89 f3                	mov    %esi,%ebx
  803c15:	89 fa                	mov    %edi,%edx
  803c17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c1b:	89 34 24             	mov    %esi,(%esp)
  803c1e:	85 c0                	test   %eax,%eax
  803c20:	75 1a                	jne    803c3c <__umoddi3+0x48>
  803c22:	39 f7                	cmp    %esi,%edi
  803c24:	0f 86 a2 00 00 00    	jbe    803ccc <__umoddi3+0xd8>
  803c2a:	89 c8                	mov    %ecx,%eax
  803c2c:	89 f2                	mov    %esi,%edx
  803c2e:	f7 f7                	div    %edi
  803c30:	89 d0                	mov    %edx,%eax
  803c32:	31 d2                	xor    %edx,%edx
  803c34:	83 c4 1c             	add    $0x1c,%esp
  803c37:	5b                   	pop    %ebx
  803c38:	5e                   	pop    %esi
  803c39:	5f                   	pop    %edi
  803c3a:	5d                   	pop    %ebp
  803c3b:	c3                   	ret    
  803c3c:	39 f0                	cmp    %esi,%eax
  803c3e:	0f 87 ac 00 00 00    	ja     803cf0 <__umoddi3+0xfc>
  803c44:	0f bd e8             	bsr    %eax,%ebp
  803c47:	83 f5 1f             	xor    $0x1f,%ebp
  803c4a:	0f 84 ac 00 00 00    	je     803cfc <__umoddi3+0x108>
  803c50:	bf 20 00 00 00       	mov    $0x20,%edi
  803c55:	29 ef                	sub    %ebp,%edi
  803c57:	89 fe                	mov    %edi,%esi
  803c59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 e0                	shl    %cl,%eax
  803c61:	89 d7                	mov    %edx,%edi
  803c63:	89 f1                	mov    %esi,%ecx
  803c65:	d3 ef                	shr    %cl,%edi
  803c67:	09 c7                	or     %eax,%edi
  803c69:	89 e9                	mov    %ebp,%ecx
  803c6b:	d3 e2                	shl    %cl,%edx
  803c6d:	89 14 24             	mov    %edx,(%esp)
  803c70:	89 d8                	mov    %ebx,%eax
  803c72:	d3 e0                	shl    %cl,%eax
  803c74:	89 c2                	mov    %eax,%edx
  803c76:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7a:	d3 e0                	shl    %cl,%eax
  803c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c80:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c84:	89 f1                	mov    %esi,%ecx
  803c86:	d3 e8                	shr    %cl,%eax
  803c88:	09 d0                	or     %edx,%eax
  803c8a:	d3 eb                	shr    %cl,%ebx
  803c8c:	89 da                	mov    %ebx,%edx
  803c8e:	f7 f7                	div    %edi
  803c90:	89 d3                	mov    %edx,%ebx
  803c92:	f7 24 24             	mull   (%esp)
  803c95:	89 c6                	mov    %eax,%esi
  803c97:	89 d1                	mov    %edx,%ecx
  803c99:	39 d3                	cmp    %edx,%ebx
  803c9b:	0f 82 87 00 00 00    	jb     803d28 <__umoddi3+0x134>
  803ca1:	0f 84 91 00 00 00    	je     803d38 <__umoddi3+0x144>
  803ca7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cab:	29 f2                	sub    %esi,%edx
  803cad:	19 cb                	sbb    %ecx,%ebx
  803caf:	89 d8                	mov    %ebx,%eax
  803cb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cb5:	d3 e0                	shl    %cl,%eax
  803cb7:	89 e9                	mov    %ebp,%ecx
  803cb9:	d3 ea                	shr    %cl,%edx
  803cbb:	09 d0                	or     %edx,%eax
  803cbd:	89 e9                	mov    %ebp,%ecx
  803cbf:	d3 eb                	shr    %cl,%ebx
  803cc1:	89 da                	mov    %ebx,%edx
  803cc3:	83 c4 1c             	add    $0x1c,%esp
  803cc6:	5b                   	pop    %ebx
  803cc7:	5e                   	pop    %esi
  803cc8:	5f                   	pop    %edi
  803cc9:	5d                   	pop    %ebp
  803cca:	c3                   	ret    
  803ccb:	90                   	nop
  803ccc:	89 fd                	mov    %edi,%ebp
  803cce:	85 ff                	test   %edi,%edi
  803cd0:	75 0b                	jne    803cdd <__umoddi3+0xe9>
  803cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cd7:	31 d2                	xor    %edx,%edx
  803cd9:	f7 f7                	div    %edi
  803cdb:	89 c5                	mov    %eax,%ebp
  803cdd:	89 f0                	mov    %esi,%eax
  803cdf:	31 d2                	xor    %edx,%edx
  803ce1:	f7 f5                	div    %ebp
  803ce3:	89 c8                	mov    %ecx,%eax
  803ce5:	f7 f5                	div    %ebp
  803ce7:	89 d0                	mov    %edx,%eax
  803ce9:	e9 44 ff ff ff       	jmp    803c32 <__umoddi3+0x3e>
  803cee:	66 90                	xchg   %ax,%ax
  803cf0:	89 c8                	mov    %ecx,%eax
  803cf2:	89 f2                	mov    %esi,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	3b 04 24             	cmp    (%esp),%eax
  803cff:	72 06                	jb     803d07 <__umoddi3+0x113>
  803d01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d05:	77 0f                	ja     803d16 <__umoddi3+0x122>
  803d07:	89 f2                	mov    %esi,%edx
  803d09:	29 f9                	sub    %edi,%ecx
  803d0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d0f:	89 14 24             	mov    %edx,(%esp)
  803d12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d1a:	8b 14 24             	mov    (%esp),%edx
  803d1d:	83 c4 1c             	add    $0x1c,%esp
  803d20:	5b                   	pop    %ebx
  803d21:	5e                   	pop    %esi
  803d22:	5f                   	pop    %edi
  803d23:	5d                   	pop    %ebp
  803d24:	c3                   	ret    
  803d25:	8d 76 00             	lea    0x0(%esi),%esi
  803d28:	2b 04 24             	sub    (%esp),%eax
  803d2b:	19 fa                	sbb    %edi,%edx
  803d2d:	89 d1                	mov    %edx,%ecx
  803d2f:	89 c6                	mov    %eax,%esi
  803d31:	e9 71 ff ff ff       	jmp    803ca7 <__umoddi3+0xb3>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d3c:	72 ea                	jb     803d28 <__umoddi3+0x134>
  803d3e:	89 d9                	mov    %ebx,%ecx
  803d40:	e9 62 ff ff ff       	jmp    803ca7 <__umoddi3+0xb3>
