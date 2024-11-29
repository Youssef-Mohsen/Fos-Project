
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
  800060:	68 e0 3d 80 00       	push   $0x803de0
  800065:	6a 11                	push   $0x11
  800067:	68 fc 3d 80 00       	push   $0x803dfc
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
  8000bc:	e8 02 1b 00 00       	call   801bc3 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 45 1b 00 00       	call   801c0e <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 18 3e 80 00       	push   $0x803e18
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 fc 3d 80 00       	push   $0x803dfc
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 04 1b 00 00       	call   801c0e <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 48 3e 80 00       	push   $0x803e48
  800117:	6a 33                	push   $0x33
  800119:	68 fc 3d 80 00       	push   $0x803dfc
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 9b 1a 00 00       	call   801bc3 <sys_calculate_free_frames>
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
  80015f:	e8 5f 1a 00 00       	call   801bc3 <sys_calculate_free_frames>
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
  80017c:	68 78 3e 80 00       	push   $0x803e78
  800181:	6a 3d                	push   $0x3d
  800183:	68 fc 3d 80 00       	push   $0x803dfc
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
  8001c7:	e8 52 1e 00 00       	call   80201e <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 f4 3e 80 00       	push   $0x803ef4
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 fc 3d 80 00       	push   $0x803dfc
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 d2 19 00 00       	call   801bc3 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 15 1a 00 00       	call   801c0e <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 fb 19 00 00       	call   801c0e <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 14 3f 80 00       	push   $0x803f14
  800220:	6a 4e                	push   $0x4e
  800222:	68 fc 3d 80 00       	push   $0x803dfc
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 92 19 00 00       	call   801bc3 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 50 3f 80 00       	push   $0x803f50
  800247:	6a 4f                	push   $0x4f
  800249:	68 fc 3d 80 00       	push   $0x803dfc
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
  80028d:	e8 8c 1d 00 00       	call   80201e <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 9c 3f 80 00       	push   $0x803f9c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 fc 3d 80 00       	push   $0x803dfc
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 13 1c 00 00       	call   801eca <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 27 1c 00 00       	call   801ee4 <gettst>
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
  8002d4:	e8 f1 1b 00 00       	call   801eca <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 c0 3f 80 00       	push   $0x803fc0
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 fc 3d 80 00       	push   $0x803dfc
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
  8002f3:	e8 94 1a 00 00       	call   801d8c <sys_getenvindex>
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
  800361:	e8 aa 17 00 00       	call   801b10 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 24 40 80 00       	push   $0x804024
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
  800391:	68 4c 40 80 00       	push   $0x80404c
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
  8003c2:	68 74 40 80 00       	push   $0x804074
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 cc 40 80 00       	push   $0x8040cc
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 24 40 80 00       	push   $0x804024
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 2a 17 00 00       	call   801b2a <sys_unlock_cons>
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
  800413:	e8 40 19 00 00       	call   801d58 <sys_destroy_env>
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
  800424:	e8 95 19 00 00       	call   801dbe <sys_exit_env>
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
  80043b:	a1 50 50 80 00       	mov    0x805050,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 16                	je     80045a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800444:	a1 50 50 80 00       	mov    0x805050,%eax
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 e0 40 80 00       	push   $0x8040e0
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 e5 40 80 00       	push   $0x8040e5
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
  80048a:	68 01 41 80 00       	push   $0x804101
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
  8004b9:	68 04 41 80 00       	push   $0x804104
  8004be:	6a 26                	push   $0x26
  8004c0:	68 50 41 80 00       	push   $0x804150
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
  80058e:	68 5c 41 80 00       	push   $0x80415c
  800593:	6a 3a                	push   $0x3a
  800595:	68 50 41 80 00       	push   $0x804150
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
  800601:	68 b0 41 80 00       	push   $0x8041b0
  800606:	6a 44                	push   $0x44
  800608:	68 50 41 80 00       	push   $0x804150
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
  800640:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  80065b:	e8 6e 14 00 00       	call   801ace <sys_cputs>
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
  8006b5:	a0 2c 50 80 00       	mov    0x80502c,%al
  8006ba:	0f b6 c0             	movzbl %al,%eax
  8006bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	50                   	push   %eax
  8006c7:	52                   	push   %edx
  8006c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ce:	83 c0 08             	add    $0x8,%eax
  8006d1:	50                   	push   %eax
  8006d2:	e8 f7 13 00 00       	call   801ace <sys_cputs>
  8006d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006da:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  8006ef:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  80071c:	e8 ef 13 00 00       	call   801b10 <sys_lock_cons>
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
  80073c:	e8 e9 13 00 00       	call   801b2a <sys_unlock_cons>
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
  800786:	e8 dd 33 00 00       	call   803b68 <__udivdi3>
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
  8007d6:	e8 9d 34 00 00       	call   803c78 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 14 44 80 00       	add    $0x804414,%eax
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
  800931:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  800a12:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 25 44 80 00       	push   $0x804425
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
  800a37:	68 2e 44 80 00       	push   $0x80442e
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
  800a64:	be 31 44 80 00       	mov    $0x804431,%esi
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
  800c5c:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800c63:	eb 2c                	jmp    800c91 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c65:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  80146f:	68 a8 45 80 00       	push   $0x8045a8
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 ca 45 80 00       	push   $0x8045ca
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
  80148f:	e8 e5 0b 00 00       	call   802079 <sys_sbrk>
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
  80150a:	e8 ee 09 00 00       	call   801efd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 2e 0f 00 00       	call   80244c <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 00 0a 00 00       	call   801f2e <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 c7 13 00 00       	call   802908 <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801575:	a1 20 50 80 00       	mov    0x805020,%eax
  80157a:	8b 40 78             	mov    0x78(%eax),%eax
  80157d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801580:	29 c2                	sub    %eax,%edx
  801582:	89 d0                	mov    %edx,%eax
  801584:	2d 00 10 00 00       	sub    $0x1000,%eax
  801589:	c1 e8 0c             	shr    $0xc,%eax
  80158c:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	0f 85 ab 00 00 00    	jne    801646 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	05 00 10 00 00       	add    $0x1000,%eax
  8015a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8015a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
  8015d9:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	74 08                	je     8015ec <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  801630:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164a:	75 16                	jne    801662 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80164c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801653:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80165a:	0f 86 15 ff ff ff    	jbe    801575 <malloc+0xdc>
  801660:	eb 01                	jmp    801663 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801692:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a2:	e8 09 0a 00 00       	call   8020b0 <sys_allocate_user_mem>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	eb 07                	jmp    8016b3 <malloc+0x21a>
		//cprintf("91\n");
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
  8016ea:	e8 dd 09 00 00       	call   8020cc <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 10 1c 00 00       	call   803310 <free_block>
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
  801735:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801772:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801779:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	e8 07 09 00 00       	call   802094 <sys_free_user_mem>
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
  8017a0:	68 d8 45 80 00       	push   $0x8045d8
  8017a5:	68 88 00 00 00       	push   $0x88
  8017aa:	68 02 46 80 00       	push   $0x804602
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
  8017ce:	e9 ec 00 00 00       	jmp    8018bf <smalloc+0x108>
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
  8017ff:	75 0a                	jne    80180b <smalloc+0x54>
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	e9 b4 00 00 00       	jmp    8018bf <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80180b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80180f:	ff 75 ec             	pushl  -0x14(%ebp)
  801812:	50                   	push   %eax
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 7d 04 00 00       	call   801c9b <sys_createSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801824:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801828:	74 06                	je     801830 <smalloc+0x79>
  80182a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80182e:	75 0a                	jne    80183a <smalloc+0x83>
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	e9 85 00 00 00       	jmp    8018bf <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	ff 75 ec             	pushl  -0x14(%ebp)
  801840:	68 0e 46 80 00       	push   $0x80460e
  801845:	e8 9f ee ff ff       	call   8006e9 <cprintf>
  80184a:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80184d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801850:	a1 20 50 80 00       	mov    0x805020,%eax
  801855:	8b 40 78             	mov    0x78(%eax),%eax
  801858:	29 c2                	sub    %eax,%edx
  80185a:	89 d0                	mov    %edx,%eax
  80185c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801861:	c1 e8 0c             	shr    $0xc,%eax
  801864:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80186a:	42                   	inc    %edx
  80186b:	89 15 24 50 80 00    	mov    %edx,0x805024
  801871:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801877:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80187e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801881:	a1 20 50 80 00       	mov    0x805020,%eax
  801886:	8b 40 78             	mov    0x78(%eax),%eax
  801889:	29 c2                	sub    %eax,%edx
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801892:	c1 e8 0c             	shr    $0xc,%eax
  801895:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80189c:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a1:	8b 50 10             	mov    0x10(%eax),%edx
  8018a4:	89 c8                	mov    %ecx,%eax
  8018a6:	c1 e0 02             	shl    $0x2,%eax
  8018a9:	89 c1                	mov    %eax,%ecx
  8018ab:	c1 e1 09             	shl    $0x9,%ecx
  8018ae:	01 c8                	add    %ecx,%eax
  8018b0:	01 c2                	add    %eax,%edx
  8018b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b5:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	e8 f0 03 00 00       	call   801cc5 <sys_getSizeOfSharedObject>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018db:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018df:	75 0a                	jne    8018eb <sget+0x2a>
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e6:	e9 e7 00 00 00       	jmp    8019d2 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fe:	39 d0                	cmp    %edx,%eax
  801900:	73 02                	jae    801904 <sget+0x43>
  801902:	89 d0                	mov    %edx,%eax
  801904:	83 ec 0c             	sub    $0xc,%esp
  801907:	50                   	push   %eax
  801908:	e8 8c fb ff ff       	call   801499 <malloc>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801913:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801917:	75 0a                	jne    801923 <sget+0x62>
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
  80191e:	e9 af 00 00 00       	jmp    8019d2 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	ff 75 e8             	pushl  -0x18(%ebp)
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 ae 03 00 00       	call   801ce2 <sys_getSharedObject>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80193a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193d:	a1 20 50 80 00       	mov    0x805020,%eax
  801942:	8b 40 78             	mov    0x78(%eax),%eax
  801945:	29 c2                	sub    %eax,%edx
  801947:	89 d0                	mov    %edx,%eax
  801949:	2d 00 10 00 00       	sub    $0x1000,%eax
  80194e:	c1 e8 0c             	shr    $0xc,%eax
  801951:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801957:	42                   	inc    %edx
  801958:	89 15 24 50 80 00    	mov    %edx,0x805024
  80195e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801964:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80196b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80196e:	a1 20 50 80 00       	mov    0x805020,%eax
  801973:	8b 40 78             	mov    0x78(%eax),%eax
  801976:	29 c2                	sub    %eax,%edx
  801978:	89 d0                	mov    %edx,%eax
  80197a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80197f:	c1 e8 0c             	shr    $0xc,%eax
  801982:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801989:	a1 20 50 80 00       	mov    0x805020,%eax
  80198e:	8b 50 10             	mov    0x10(%eax),%edx
  801991:	89 c8                	mov    %ecx,%eax
  801993:	c1 e0 02             	shl    $0x2,%eax
  801996:	89 c1                	mov    %eax,%ecx
  801998:	c1 e1 09             	shl    $0x9,%ecx
  80199b:	01 c8                	add    %ecx,%eax
  80199d:	01 c2                	add    %eax,%edx
  80199f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  8019a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8019ae:	8b 40 10             	mov    0x10(%eax),%eax
  8019b1:	83 ec 08             	sub    $0x8,%esp
  8019b4:	50                   	push   %eax
  8019b5:	68 1d 46 80 00       	push   $0x80461d
  8019ba:	e8 2a ed ff ff       	call   8006e9 <cprintf>
  8019bf:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019c2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019c6:	75 07                	jne    8019cf <sget+0x10e>
  8019c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cd:	eb 03                	jmp    8019d2 <sget+0x111>
	return ptr;
  8019cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  8019da:	8b 55 08             	mov    0x8(%ebp),%edx
  8019dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8019e2:	8b 40 78             	mov    0x78(%eax),%eax
  8019e5:	29 c2                	sub    %eax,%edx
  8019e7:	89 d0                	mov    %edx,%eax
  8019e9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019ee:	c1 e8 0c             	shr    $0xc,%eax
  8019f1:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8019fd:	8b 50 10             	mov    0x10(%eax),%edx
  801a00:	89 c8                	mov    %ecx,%eax
  801a02:	c1 e0 02             	shl    $0x2,%eax
  801a05:	89 c1                	mov    %eax,%ecx
  801a07:	c1 e1 09             	shl    $0x9,%ecx
  801a0a:	01 c8                	add    %ecx,%eax
  801a0c:	01 d0                	add    %edx,%eax
  801a0e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a21:	e8 db 02 00 00       	call   801d01 <sys_freeSharedObject>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 2c 46 80 00       	push   $0x80462c
  801a3d:	68 e5 00 00 00       	push   $0xe5
  801a42:	68 02 46 80 00       	push   $0x804602
  801a47:	e8 e0 e9 ff ff       	call   80042c <_panic>

00801a4c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 52 46 80 00       	push   $0x804652
  801a5a:	68 f1 00 00 00       	push   $0xf1
  801a5f:	68 02 46 80 00       	push   $0x804602
  801a64:	e8 c3 e9 ff ff       	call   80042c <_panic>

00801a69 <shrink>:

}
void shrink(uint32 newSize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 52 46 80 00       	push   $0x804652
  801a77:	68 f6 00 00 00       	push   $0xf6
  801a7c:	68 02 46 80 00       	push   $0x804602
  801a81:	e8 a6 e9 ff ff       	call   80042c <_panic>

00801a86 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 52 46 80 00       	push   $0x804652
  801a94:	68 fb 00 00 00       	push   $0xfb
  801a99:	68 02 46 80 00       	push   $0x804602
  801a9e:	e8 89 e9 ff ff       	call   80042c <_panic>

00801aa3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	57                   	push   %edi
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801abb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801abe:	cd 30                	int    $0x30
  801ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5f                   	pop    %edi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    

00801ace <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ada:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	50                   	push   %eax
  801aea:	6a 00                	push   $0x0
  801aec:	e8 b2 ff ff ff       	call   801aa3 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 02                	push   $0x2
  801b06:	e8 98 ff ff ff       	call   801aa3 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 03                	push   $0x3
  801b1f:	e8 7f ff ff ff       	call   801aa3 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 04                	push   $0x4
  801b39:	e8 65 ff ff ff       	call   801aa3 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 08                	push   $0x8
  801b57:	e8 47 ff ff ff       	call   801aa3 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	56                   	push   %esi
  801b65:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b66:	8b 75 18             	mov    0x18(%ebp),%esi
  801b69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	51                   	push   %ecx
  801b78:	52                   	push   %edx
  801b79:	50                   	push   %eax
  801b7a:	6a 09                	push   $0x9
  801b7c:	e8 22 ff ff ff       	call   801aa3 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    

00801b8b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 0a                	push   $0xa
  801b9e:	e8 00 ff ff ff       	call   801aa3 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 0b                	push   $0xb
  801bb9:	e8 e5 fe ff ff       	call   801aa3 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 0c                	push   $0xc
  801bd2:	e8 cc fe ff ff       	call   801aa3 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 0d                	push   $0xd
  801beb:	e8 b3 fe ff ff       	call   801aa3 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 0e                	push   $0xe
  801c04:	e8 9a fe ff ff       	call   801aa3 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 0f                	push   $0xf
  801c1d:	e8 81 fe ff ff       	call   801aa3 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	6a 10                	push   $0x10
  801c37:	e8 67 fe ff ff       	call   801aa3 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 11                	push   $0x11
  801c50:	e8 4e fe ff ff       	call   801aa3 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_cputc>:

void
sys_cputc(const char c)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c67:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	50                   	push   %eax
  801c74:	6a 01                	push   $0x1
  801c76:	e8 28 fe ff ff       	call   801aa3 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 14                	push   $0x14
  801c90:	e8 0e fe ff ff       	call   801aa3 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ca7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801caa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	51                   	push   %ecx
  801cb4:	52                   	push   %edx
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	50                   	push   %eax
  801cb9:	6a 15                	push   $0x15
  801cbb:	e8 e3 fd ff ff       	call   801aa3 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 16                	push   $0x16
  801cd8:	e8 c6 fd ff ff       	call   801aa3 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ce5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 17                	push   $0x17
  801cf7:	e8 a7 fd ff ff       	call   801aa3 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 18                	push   $0x18
  801d14:	e8 8a fd ff ff       	call   801aa3 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	ff 75 14             	pushl  0x14(%ebp)
  801d29:	ff 75 10             	pushl  0x10(%ebp)
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	50                   	push   %eax
  801d30:	6a 19                	push   $0x19
  801d32:	e8 6c fd ff ff       	call   801aa3 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 1a                	push   $0x1a
  801d4d:	e8 51 fd ff ff       	call   801aa3 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	50                   	push   %eax
  801d67:	6a 1b                	push   $0x1b
  801d69:	e8 35 fd ff ff       	call   801aa3 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 05                	push   $0x5
  801d82:	e8 1c fd ff ff       	call   801aa3 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 06                	push   $0x6
  801d9b:	e8 03 fd ff ff       	call   801aa3 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 07                	push   $0x7
  801db4:	e8 ea fc ff ff       	call   801aa3 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_exit_env>:


void sys_exit_env(void)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 1c                	push   $0x1c
  801dcd:	e8 d1 fc ff ff       	call   801aa3 <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	90                   	nop
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dde:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801de1:	8d 50 04             	lea    0x4(%eax),%edx
  801de4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	52                   	push   %edx
  801dee:	50                   	push   %eax
  801def:	6a 1d                	push   $0x1d
  801df1:	e8 ad fc ff ff       	call   801aa3 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
	return result;
  801df9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e02:	89 01                	mov    %eax,(%ecx)
  801e04:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	c9                   	leave  
  801e0b:	c2 04 00             	ret    $0x4

00801e0e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 13                	push   $0x13
  801e20:	e8 7e fc ff ff       	call   801aa3 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return ;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_rcr2>:
uint32 sys_rcr2()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 1e                	push   $0x1e
  801e3a:	e8 64 fc ff ff       	call   801aa3 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e50:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	50                   	push   %eax
  801e5d:	6a 1f                	push   $0x1f
  801e5f:	e8 3f fc ff ff       	call   801aa3 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <rsttst>:
void rsttst()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 21                	push   $0x21
  801e79:	e8 25 fc ff ff       	call   801aa3 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e90:	8b 55 18             	mov    0x18(%ebp),%edx
  801e93:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 20                	push   $0x20
  801ea4:	e8 fa fb ff ff       	call   801aa3 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <chktst>:
void chktst(uint32 n)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	6a 22                	push   $0x22
  801ebf:	e8 df fb ff ff       	call   801aa3 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <inctst>:

void inctst()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 23                	push   $0x23
  801ed9:	e8 c5 fb ff ff       	call   801aa3 <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee1:	90                   	nop
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <gettst>:
uint32 gettst()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 24                	push   $0x24
  801ef3:	e8 ab fb ff ff       	call   801aa3 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 25                	push   $0x25
  801f0f:	e8 8f fb ff ff       	call   801aa3 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
  801f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f1a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f1e:	75 07                	jne    801f27 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f20:	b8 01 00 00 00       	mov    $0x1,%eax
  801f25:	eb 05                	jmp    801f2c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 25                	push   $0x25
  801f40:	e8 5e fb ff ff       	call   801aa3 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
  801f48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f4b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f4f:	75 07                	jne    801f58 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f51:	b8 01 00 00 00       	mov    $0x1,%eax
  801f56:	eb 05                	jmp    801f5d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 25                	push   $0x25
  801f71:	e8 2d fb ff ff       	call   801aa3 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
  801f79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f7c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f80:	75 07                	jne    801f89 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f82:	b8 01 00 00 00       	mov    $0x1,%eax
  801f87:	eb 05                	jmp    801f8e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 25                	push   $0x25
  801fa2:	e8 fc fa ff ff       	call   801aa3 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
  801faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fb1:	75 07                	jne    801fba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb8:	eb 05                	jmp    801fbf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 08             	pushl  0x8(%ebp)
  801fcf:	6a 26                	push   $0x26
  801fd1:	e8 cd fa ff ff       	call   801aa3 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd9:	90                   	nop
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fe0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	53                   	push   %ebx
  801fef:	51                   	push   %ecx
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	6a 27                	push   $0x27
  801ff4:	e8 aa fa ff ff       	call   801aa3 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802004:	8b 55 0c             	mov    0xc(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	52                   	push   %edx
  802011:	50                   	push   %eax
  802012:	6a 28                	push   $0x28
  802014:	e8 8a fa ff ff       	call   801aa3 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802021:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802024:	8b 55 0c             	mov    0xc(%ebp),%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	51                   	push   %ecx
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 29                	push   $0x29
  802034:	e8 6a fa ff ff       	call   801aa3 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	ff 75 10             	pushl  0x10(%ebp)
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	ff 75 08             	pushl  0x8(%ebp)
  80204e:	6a 12                	push   $0x12
  802050:	e8 4e fa ff ff       	call   801aa3 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
	return ;
  802058:	90                   	nop
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80205e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	52                   	push   %edx
  80206b:	50                   	push   %eax
  80206c:	6a 2a                	push   $0x2a
  80206e:	e8 30 fa ff ff       	call   801aa3 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
	return;
  802076:	90                   	nop
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	50                   	push   %eax
  802088:	6a 2b                	push   $0x2b
  80208a:	e8 14 fa ff ff       	call   801aa3 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	ff 75 0c             	pushl  0xc(%ebp)
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	6a 2c                	push   $0x2c
  8020a5:	e8 f9 f9 ff ff       	call   801aa3 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
	return;
  8020ad:	90                   	nop
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	ff 75 0c             	pushl  0xc(%ebp)
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	6a 2d                	push   $0x2d
  8020c1:	e8 dd f9 ff ff       	call   801aa3 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
	return;
  8020c9:	90                   	nop
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	83 e8 04             	sub    $0x4,%eax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	83 e8 04             	sub    $0x4,%eax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f7:	8b 00                	mov    (%eax),%eax
  8020f9:	83 e0 01             	and    $0x1,%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	0f 94 c0             	sete   %al
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802110:	8b 45 0c             	mov    0xc(%ebp),%eax
  802113:	83 f8 02             	cmp    $0x2,%eax
  802116:	74 2b                	je     802143 <alloc_block+0x40>
  802118:	83 f8 02             	cmp    $0x2,%eax
  80211b:	7f 07                	jg     802124 <alloc_block+0x21>
  80211d:	83 f8 01             	cmp    $0x1,%eax
  802120:	74 0e                	je     802130 <alloc_block+0x2d>
  802122:	eb 58                	jmp    80217c <alloc_block+0x79>
  802124:	83 f8 03             	cmp    $0x3,%eax
  802127:	74 2d                	je     802156 <alloc_block+0x53>
  802129:	83 f8 04             	cmp    $0x4,%eax
  80212c:	74 3b                	je     802169 <alloc_block+0x66>
  80212e:	eb 4c                	jmp    80217c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 11 03 00 00       	call   80244c <alloc_block_FF>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802141:	eb 4a                	jmp    80218d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	e8 fa 19 00 00       	call   803b48 <alloc_block_NF>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802154:	eb 37                	jmp    80218d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	e8 a7 07 00 00       	call   802908 <alloc_block_BF>
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802167:	eb 24                	jmp    80218d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 08             	pushl  0x8(%ebp)
  80216f:	e8 b7 19 00 00       	call   803b2b <alloc_block_WF>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80217a:	eb 11                	jmp    80218d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	68 64 46 80 00       	push   $0x804664
  802184:	e8 60 e5 ff ff       	call   8006e9 <cprintf>
  802189:	83 c4 10             	add    $0x10,%esp
		break;
  80218c:	90                   	nop
	}
	return va;
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	53                   	push   %ebx
  802196:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	68 84 46 80 00       	push   $0x804684
  8021a1:	e8 43 e5 ff ff       	call   8006e9 <cprintf>
  8021a6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	68 af 46 80 00       	push   $0x8046af
  8021b1:	e8 33 e5 ff ff       	call   8006e9 <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bf:	eb 37                	jmp    8021f8 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c7:	e8 19 ff ff ff       	call   8020e5 <is_free_block>
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	0f be d8             	movsbl %al,%ebx
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d8:	e8 ef fe ff ff       	call   8020cc <get_block_size>
  8021dd:	83 c4 10             	add    $0x10,%esp
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	53                   	push   %ebx
  8021e4:	50                   	push   %eax
  8021e5:	68 c7 46 80 00       	push   $0x8046c7
  8021ea:	e8 fa e4 ff ff       	call   8006e9 <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fc:	74 07                	je     802205 <print_blocks_list+0x73>
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 00                	mov    (%eax),%eax
  802203:	eb 05                	jmp    80220a <print_blocks_list+0x78>
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	89 45 10             	mov    %eax,0x10(%ebp)
  80220d:	8b 45 10             	mov    0x10(%ebp),%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	75 ad                	jne    8021c1 <print_blocks_list+0x2f>
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802218:	75 a7                	jne    8021c1 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	68 84 46 80 00       	push   $0x804684
  802222:	e8 c2 e4 ff ff       	call   8006e9 <cprintf>
  802227:	83 c4 10             	add    $0x10,%esp

}
  80222a:	90                   	nop
  80222b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802236:	8b 45 0c             	mov    0xc(%ebp),%eax
  802239:	83 e0 01             	and    $0x1,%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	74 03                	je     802243 <initialize_dynamic_allocator+0x13>
  802240:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802243:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802247:	0f 84 c7 01 00 00    	je     802414 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80224d:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802254:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802257:	8b 55 08             	mov    0x8(%ebp),%edx
  80225a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225d:	01 d0                	add    %edx,%eax
  80225f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802264:	0f 87 ad 01 00 00    	ja     802417 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	0f 89 a5 01 00 00    	jns    80241a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802275:	8b 55 08             	mov    0x8(%ebp),%edx
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	01 d0                	add    %edx,%eax
  80227d:	83 e8 04             	sub    $0x4,%eax
  802280:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80228c:	a1 30 50 80 00       	mov    0x805030,%eax
  802291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802294:	e9 87 00 00 00       	jmp    802320 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229d:	75 14                	jne    8022b3 <initialize_dynamic_allocator+0x83>
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 df 46 80 00       	push   $0x8046df
  8022a7:	6a 79                	push   $0x79
  8022a9:	68 fd 46 80 00       	push   $0x8046fd
  8022ae:	e8 79 e1 ff ff       	call   80042c <_panic>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	74 10                	je     8022cc <initialize_dynamic_allocator+0x9c>
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c4:	8b 52 04             	mov    0x4(%edx),%edx
  8022c7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ca:	eb 0b                	jmp    8022d7 <initialize_dynamic_allocator+0xa7>
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 04             	mov    0x4(%eax),%eax
  8022d2:	a3 34 50 80 00       	mov    %eax,0x805034
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 04             	mov    0x4(%eax),%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	74 0f                	je     8022f0 <initialize_dynamic_allocator+0xc0>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 40 04             	mov    0x4(%eax),%eax
  8022e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ea:	8b 12                	mov    (%edx),%edx
  8022ec:	89 10                	mov    %edx,(%eax)
  8022ee:	eb 0a                	jmp    8022fa <initialize_dynamic_allocator+0xca>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802312:	48                   	dec    %eax
  802313:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802318:	a1 38 50 80 00       	mov    0x805038,%eax
  80231d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802324:	74 07                	je     80232d <initialize_dynamic_allocator+0xfd>
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	eb 05                	jmp    802332 <initialize_dynamic_allocator+0x102>
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
  802332:	a3 38 50 80 00       	mov    %eax,0x805038
  802337:	a1 38 50 80 00       	mov    0x805038,%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	0f 85 55 ff ff ff    	jne    802299 <initialize_dynamic_allocator+0x69>
  802344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802348:	0f 85 4b ff ff ff    	jne    802299 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80235d:	a1 48 50 80 00       	mov    0x805048,%eax
  802362:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802367:	a1 44 50 80 00       	mov    0x805044,%eax
  80236c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	83 c0 08             	add    $0x8,%eax
  802378:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	83 c0 04             	add    $0x4,%eax
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	83 ea 08             	sub    $0x8,%edx
  802387:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	01 d0                	add    %edx,%eax
  802391:	83 e8 08             	sub    $0x8,%eax
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	83 ea 08             	sub    $0x8,%edx
  80239a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023b3:	75 17                	jne    8023cc <initialize_dynamic_allocator+0x19c>
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	68 18 47 80 00       	push   $0x804718
  8023bd:	68 90 00 00 00       	push   $0x90
  8023c2:	68 fd 46 80 00       	push   $0x8046fd
  8023c7:	e8 60 e0 ff ff       	call   80042c <_panic>
  8023cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d5:	89 10                	mov    %edx,(%eax)
  8023d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	74 0d                	je     8023ed <initialize_dynamic_allocator+0x1bd>
  8023e0:	a1 30 50 80 00       	mov    0x805030,%eax
  8023e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e8:	89 50 04             	mov    %edx,0x4(%eax)
  8023eb:	eb 08                	jmp    8023f5 <initialize_dynamic_allocator+0x1c5>
  8023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f0:	a3 34 50 80 00       	mov    %eax,0x805034
  8023f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802407:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80240c:	40                   	inc    %eax
  80240d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802412:	eb 07                	jmp    80241b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802414:	90                   	nop
  802415:	eb 04                	jmp    80241b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802417:	90                   	nop
  802418:	eb 01                	jmp    80241b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80241a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802420:	8b 45 10             	mov    0x10(%ebp),%eax
  802423:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8d 50 fc             	lea    -0x4(%eax),%edx
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	83 e8 04             	sub    $0x4,%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	83 e0 fe             	and    $0xfffffffe,%eax
  80243c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	01 c2                	add    %eax,%edx
  802444:	8b 45 0c             	mov    0xc(%ebp),%eax
  802447:	89 02                	mov    %eax,(%edx)
}
  802449:	90                   	nop
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    

0080244c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	83 e0 01             	and    $0x1,%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 03                	je     80245f <alloc_block_FF+0x13>
  80245c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80245f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802463:	77 07                	ja     80246c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802465:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80246c:	a1 28 50 80 00       	mov    0x805028,%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	75 73                	jne    8024e8 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	83 c0 10             	add    $0x10,%eax
  80247b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80247e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802485:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248b:	01 d0                	add    %edx,%eax
  80248d:	48                   	dec    %eax
  80248e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802494:	ba 00 00 00 00       	mov    $0x0,%edx
  802499:	f7 75 ec             	divl   -0x14(%ebp)
  80249c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80249f:	29 d0                	sub    %edx,%eax
  8024a1:	c1 e8 0c             	shr    $0xc,%eax
  8024a4:	83 ec 0c             	sub    $0xc,%esp
  8024a7:	50                   	push   %eax
  8024a8:	e8 d6 ef ff ff       	call   801483 <sbrk>
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	6a 00                	push   $0x0
  8024b8:	e8 c6 ef ff ff       	call   801483 <sbrk>
  8024bd:	83 c4 10             	add    $0x10,%esp
  8024c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024c9:	83 ec 08             	sub    $0x8,%esp
  8024cc:	50                   	push   %eax
  8024cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024d0:	e8 5b fd ff ff       	call   802230 <initialize_dynamic_allocator>
  8024d5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024d8:	83 ec 0c             	sub    $0xc,%esp
  8024db:	68 3b 47 80 00       	push   $0x80473b
  8024e0:	e8 04 e2 ff ff       	call   8006e9 <cprintf>
  8024e5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ec:	75 0a                	jne    8024f8 <alloc_block_FF+0xac>
	        return NULL;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	e9 0e 04 00 00       	jmp    802906 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024ff:	a1 30 50 80 00       	mov    0x805030,%eax
  802504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802507:	e9 f3 02 00 00       	jmp    8027ff <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	ff 75 bc             	pushl  -0x44(%ebp)
  802518:	e8 af fb ff ff       	call   8020cc <get_block_size>
  80251d:	83 c4 10             	add    $0x10,%esp
  802520:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	83 c0 08             	add    $0x8,%eax
  802529:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80252c:	0f 87 c5 02 00 00    	ja     8027f7 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	83 c0 18             	add    $0x18,%eax
  802538:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80253b:	0f 87 19 02 00 00    	ja     80275a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802541:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802544:	2b 45 08             	sub    0x8(%ebp),%eax
  802547:	83 e8 08             	sub    $0x8,%eax
  80254a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	8d 50 08             	lea    0x8(%eax),%edx
  802553:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802556:	01 d0                	add    %edx,%eax
  802558:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	83 c0 08             	add    $0x8,%eax
  802561:	83 ec 04             	sub    $0x4,%esp
  802564:	6a 01                	push   $0x1
  802566:	50                   	push   %eax
  802567:	ff 75 bc             	pushl  -0x44(%ebp)
  80256a:	e8 ae fe ff ff       	call   80241d <set_block_data>
  80256f:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	75 68                	jne    8025e4 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80257c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802580:	75 17                	jne    802599 <alloc_block_FF+0x14d>
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	68 18 47 80 00       	push   $0x804718
  80258a:	68 d7 00 00 00       	push   $0xd7
  80258f:	68 fd 46 80 00       	push   $0x8046fd
  802594:	e8 93 de ff ff       	call   80042c <_panic>
  802599:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80259f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a2:	89 10                	mov    %edx,(%eax)
  8025a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 0d                	je     8025ba <alloc_block_FF+0x16e>
  8025ad:	a1 30 50 80 00       	mov    0x805030,%eax
  8025b2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025b5:	89 50 04             	mov    %edx,0x4(%eax)
  8025b8:	eb 08                	jmp    8025c2 <alloc_block_FF+0x176>
  8025ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8025c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025d9:	40                   	inc    %eax
  8025da:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025df:	e9 dc 00 00 00       	jmp    8026c0 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 00                	mov    (%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	75 65                	jne    802652 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025ed:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025f1:	75 17                	jne    80260a <alloc_block_FF+0x1be>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 4c 47 80 00       	push   $0x80474c
  8025fb:	68 db 00 00 00       	push   $0xdb
  802600:	68 fd 46 80 00       	push   $0x8046fd
  802605:	e8 22 de ff ff       	call   80042c <_panic>
  80260a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802610:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802613:	89 50 04             	mov    %edx,0x4(%eax)
  802616:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802619:	8b 40 04             	mov    0x4(%eax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	74 0c                	je     80262c <alloc_block_FF+0x1e0>
  802620:	a1 34 50 80 00       	mov    0x805034,%eax
  802625:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802628:	89 10                	mov    %edx,(%eax)
  80262a:	eb 08                	jmp    802634 <alloc_block_FF+0x1e8>
  80262c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262f:	a3 30 50 80 00       	mov    %eax,0x805030
  802634:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802637:	a3 34 50 80 00       	mov    %eax,0x805034
  80263c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802645:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80264a:	40                   	inc    %eax
  80264b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802650:	eb 6e                	jmp    8026c0 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	74 06                	je     80265e <alloc_block_FF+0x212>
  802658:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80265c:	75 17                	jne    802675 <alloc_block_FF+0x229>
  80265e:	83 ec 04             	sub    $0x4,%esp
  802661:	68 70 47 80 00       	push   $0x804770
  802666:	68 df 00 00 00       	push   $0xdf
  80266b:	68 fd 46 80 00       	push   $0x8046fd
  802670:	e8 b7 dd ff ff       	call   80042c <_panic>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 10                	mov    (%eax),%edx
  80267a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267d:	89 10                	mov    %edx,(%eax)
  80267f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 0b                	je     802693 <alloc_block_FF+0x247>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 00                	mov    (%eax),%eax
  80268d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802690:	89 50 04             	mov    %edx,0x4(%eax)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802699:	89 10                	mov    %edx,(%eax)
  80269b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a1:	89 50 04             	mov    %edx,0x4(%eax)
  8026a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 08                	jne    8026b5 <alloc_block_FF+0x269>
  8026ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8026b5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026ba:	40                   	inc    %eax
  8026bb:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	75 17                	jne    8026dd <alloc_block_FF+0x291>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 df 46 80 00       	push   $0x8046df
  8026ce:	68 e1 00 00 00       	push   $0xe1
  8026d3:	68 fd 46 80 00       	push   $0x8046fd
  8026d8:	e8 4f dd ff ff       	call   80042c <_panic>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 10                	je     8026f6 <alloc_block_FF+0x2aa>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ee:	8b 52 04             	mov    0x4(%edx),%edx
  8026f1:	89 50 04             	mov    %edx,0x4(%eax)
  8026f4:	eb 0b                	jmp    802701 <alloc_block_FF+0x2b5>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	a3 34 50 80 00       	mov    %eax,0x805034
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 0f                	je     80271a <alloc_block_FF+0x2ce>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 12                	mov    (%edx),%edx
  802716:	89 10                	mov    %edx,(%eax)
  802718:	eb 0a                	jmp    802724 <alloc_block_FF+0x2d8>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	a3 30 50 80 00       	mov    %eax,0x805030
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802737:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80273c:	48                   	dec    %eax
  80273d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	6a 00                	push   $0x0
  802747:	ff 75 b4             	pushl  -0x4c(%ebp)
  80274a:	ff 75 b0             	pushl  -0x50(%ebp)
  80274d:	e8 cb fc ff ff       	call   80241d <set_block_data>
  802752:	83 c4 10             	add    $0x10,%esp
  802755:	e9 95 00 00 00       	jmp    8027ef <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80275a:	83 ec 04             	sub    $0x4,%esp
  80275d:	6a 01                	push   $0x1
  80275f:	ff 75 b8             	pushl  -0x48(%ebp)
  802762:	ff 75 bc             	pushl  -0x44(%ebp)
  802765:	e8 b3 fc ff ff       	call   80241d <set_block_data>
  80276a:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	75 17                	jne    80278a <alloc_block_FF+0x33e>
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	68 df 46 80 00       	push   $0x8046df
  80277b:	68 e8 00 00 00       	push   $0xe8
  802780:	68 fd 46 80 00       	push   $0x8046fd
  802785:	e8 a2 dc ff ff       	call   80042c <_panic>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	74 10                	je     8027a3 <alloc_block_FF+0x357>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	8b 52 04             	mov    0x4(%edx),%edx
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	eb 0b                	jmp    8027ae <alloc_block_FF+0x362>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 0f                	je     8027c7 <alloc_block_FF+0x37b>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	8b 12                	mov    (%edx),%edx
  8027c3:	89 10                	mov    %edx,(%eax)
  8027c5:	eb 0a                	jmp    8027d1 <alloc_block_FF+0x385>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027e9:	48                   	dec    %eax
  8027ea:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  8027ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027f2:	e9 0f 01 00 00       	jmp    802906 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	74 07                	je     80280c <alloc_block_FF+0x3c0>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <alloc_block_FF+0x3c5>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	a3 38 50 80 00       	mov    %eax,0x805038
  802816:	a1 38 50 80 00       	mov    0x805038,%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 85 e9 fc ff ff    	jne    80250c <alloc_block_FF+0xc0>
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	0f 85 df fc ff ff    	jne    80250c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80282d:	8b 45 08             	mov    0x8(%ebp),%eax
  802830:	83 c0 08             	add    $0x8,%eax
  802833:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802836:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80283d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802840:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802843:	01 d0                	add    %edx,%eax
  802845:	48                   	dec    %eax
  802846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284c:	ba 00 00 00 00       	mov    $0x0,%edx
  802851:	f7 75 d8             	divl   -0x28(%ebp)
  802854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802857:	29 d0                	sub    %edx,%eax
  802859:	c1 e8 0c             	shr    $0xc,%eax
  80285c:	83 ec 0c             	sub    $0xc,%esp
  80285f:	50                   	push   %eax
  802860:	e8 1e ec ff ff       	call   801483 <sbrk>
  802865:	83 c4 10             	add    $0x10,%esp
  802868:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80286b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80286f:	75 0a                	jne    80287b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
  802876:	e9 8b 00 00 00       	jmp    802906 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80287b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802882:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802885:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	48                   	dec    %eax
  80288b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80288e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802891:	ba 00 00 00 00       	mov    $0x0,%edx
  802896:	f7 75 cc             	divl   -0x34(%ebp)
  802899:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80289c:	29 d0                	sub    %edx,%eax
  80289e:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  8028ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8028b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028b6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d1:	f7 75 c4             	divl   -0x3c(%ebp)
  8028d4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028d7:	29 d0                	sub    %edx,%eax
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	6a 01                	push   $0x1
  8028de:	50                   	push   %eax
  8028df:	ff 75 d0             	pushl  -0x30(%ebp)
  8028e2:	e8 36 fb ff ff       	call   80241d <set_block_data>
  8028e7:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028ea:	83 ec 0c             	sub    $0xc,%esp
  8028ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f0:	e8 1b 0a 00 00       	call   803310 <free_block>
  8028f5:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028f8:	83 ec 0c             	sub    $0xc,%esp
  8028fb:	ff 75 08             	pushl  0x8(%ebp)
  8028fe:	e8 49 fb ff ff       	call   80244c <alloc_block_FF>
  802903:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
  80290b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	83 e0 01             	and    $0x1,%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 03                	je     80291b <alloc_block_BF+0x13>
  802918:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80291b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80291f:	77 07                	ja     802928 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802921:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802928:	a1 28 50 80 00       	mov    0x805028,%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	75 73                	jne    8029a4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	83 c0 10             	add    $0x10,%eax
  802937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80293a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802941:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802947:	01 d0                	add    %edx,%eax
  802949:	48                   	dec    %eax
  80294a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80294d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802950:	ba 00 00 00 00       	mov    $0x0,%edx
  802955:	f7 75 e0             	divl   -0x20(%ebp)
  802958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80295b:	29 d0                	sub    %edx,%eax
  80295d:	c1 e8 0c             	shr    $0xc,%eax
  802960:	83 ec 0c             	sub    $0xc,%esp
  802963:	50                   	push   %eax
  802964:	e8 1a eb ff ff       	call   801483 <sbrk>
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80296f:	83 ec 0c             	sub    $0xc,%esp
  802972:	6a 00                	push   $0x0
  802974:	e8 0a eb ff ff       	call   801483 <sbrk>
  802979:	83 c4 10             	add    $0x10,%esp
  80297c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80297f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802982:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802985:	83 ec 08             	sub    $0x8,%esp
  802988:	50                   	push   %eax
  802989:	ff 75 d8             	pushl  -0x28(%ebp)
  80298c:	e8 9f f8 ff ff       	call   802230 <initialize_dynamic_allocator>
  802991:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802994:	83 ec 0c             	sub    $0xc,%esp
  802997:	68 3b 47 80 00       	push   $0x80473b
  80299c:	e8 48 dd ff ff       	call   8006e9 <cprintf>
  8029a1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029b2:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029c0:	a1 30 50 80 00       	mov    0x805030,%eax
  8029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c8:	e9 1d 01 00 00       	jmp    802aea <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029d3:	83 ec 0c             	sub    $0xc,%esp
  8029d6:	ff 75 a8             	pushl  -0x58(%ebp)
  8029d9:	e8 ee f6 ff ff       	call   8020cc <get_block_size>
  8029de:	83 c4 10             	add    $0x10,%esp
  8029e1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	83 c0 08             	add    $0x8,%eax
  8029ea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ed:	0f 87 ef 00 00 00    	ja     802ae2 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	83 c0 18             	add    $0x18,%eax
  8029f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029fc:	77 1d                	ja     802a1b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a01:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a04:	0f 86 d8 00 00 00    	jbe    802ae2 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a0a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a10:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a16:	e9 c7 00 00 00       	jmp    802ae2 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	83 c0 08             	add    $0x8,%eax
  802a21:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a24:	0f 85 9d 00 00 00    	jne    802ac7 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	6a 01                	push   $0x1
  802a2f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a32:	ff 75 a8             	pushl  -0x58(%ebp)
  802a35:	e8 e3 f9 ff ff       	call   80241d <set_block_data>
  802a3a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a41:	75 17                	jne    802a5a <alloc_block_BF+0x152>
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 df 46 80 00       	push   $0x8046df
  802a4b:	68 2c 01 00 00       	push   $0x12c
  802a50:	68 fd 46 80 00       	push   $0x8046fd
  802a55:	e8 d2 d9 ff ff       	call   80042c <_panic>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 10                	je     802a73 <alloc_block_BF+0x16b>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6b:	8b 52 04             	mov    0x4(%edx),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	eb 0b                	jmp    802a7e <alloc_block_BF+0x176>
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	a3 34 50 80 00       	mov    %eax,0x805034
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0f                	je     802a97 <alloc_block_BF+0x18f>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	8b 12                	mov    (%edx),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 0a                	jmp    802aa1 <alloc_block_BF+0x199>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ab9:	48                   	dec    %eax
  802aba:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802abf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ac2:	e9 24 04 00 00       	jmp    802eeb <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802acd:	76 13                	jbe    802ae2 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802acf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ad6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802adc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802adf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ae2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aee:	74 07                	je     802af7 <alloc_block_BF+0x1ef>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	eb 05                	jmp    802afc <alloc_block_BF+0x1f4>
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
  802afc:	a3 38 50 80 00       	mov    %eax,0x805038
  802b01:	a1 38 50 80 00       	mov    0x805038,%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	0f 85 bf fe ff ff    	jne    8029cd <alloc_block_BF+0xc5>
  802b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b12:	0f 85 b5 fe ff ff    	jne    8029cd <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1c:	0f 84 26 02 00 00    	je     802d48 <alloc_block_BF+0x440>
  802b22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b26:	0f 85 1c 02 00 00    	jne    802d48 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b32:	83 e8 08             	sub    $0x8,%eax
  802b35:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8d 50 08             	lea    0x8(%eax),%edx
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	01 d0                	add    %edx,%eax
  802b43:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	83 c0 08             	add    $0x8,%eax
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	6a 01                	push   $0x1
  802b51:	50                   	push   %eax
  802b52:	ff 75 f0             	pushl  -0x10(%ebp)
  802b55:	e8 c3 f8 ff ff       	call   80241d <set_block_data>
  802b5a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 40 04             	mov    0x4(%eax),%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	75 68                	jne    802bcf <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b67:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b6b:	75 17                	jne    802b84 <alloc_block_BF+0x27c>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 18 47 80 00       	push   $0x804718
  802b75:	68 45 01 00 00       	push   $0x145
  802b7a:	68 fd 46 80 00       	push   $0x8046fd
  802b7f:	e8 a8 d8 ff ff       	call   80042c <_panic>
  802b84:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0d                	je     802ba5 <alloc_block_BF+0x29d>
  802b98:	a1 30 50 80 00       	mov    0x805030,%eax
  802b9d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	eb 08                	jmp    802bad <alloc_block_BF+0x2a5>
  802ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba8:	a3 34 50 80 00       	mov    %eax,0x805034
  802bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bc4:	40                   	inc    %eax
  802bc5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bca:	e9 dc 00 00 00       	jmp    802cab <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	75 65                	jne    802c3d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bd8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bdc:	75 17                	jne    802bf5 <alloc_block_BF+0x2ed>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 4c 47 80 00       	push   $0x80474c
  802be6:	68 4a 01 00 00       	push   $0x14a
  802beb:	68 fd 46 80 00       	push   $0x8046fd
  802bf0:	e8 37 d8 ff ff       	call   80042c <_panic>
  802bf5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802bfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfe:	89 50 04             	mov    %edx,0x4(%eax)
  802c01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 0c                	je     802c17 <alloc_block_BF+0x30f>
  802c0b:	a1 34 50 80 00       	mov    0x805034,%eax
  802c10:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c13:	89 10                	mov    %edx,(%eax)
  802c15:	eb 08                	jmp    802c1f <alloc_block_BF+0x317>
  802c17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c22:	a3 34 50 80 00       	mov    %eax,0x805034
  802c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c30:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c35:	40                   	inc    %eax
  802c36:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c3b:	eb 6e                	jmp    802cab <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c41:	74 06                	je     802c49 <alloc_block_BF+0x341>
  802c43:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c47:	75 17                	jne    802c60 <alloc_block_BF+0x358>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 70 47 80 00       	push   $0x804770
  802c51:	68 4f 01 00 00       	push   $0x14f
  802c56:	68 fd 46 80 00       	push   $0x8046fd
  802c5b:	e8 cc d7 ff ff       	call   80042c <_panic>
  802c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c63:	8b 10                	mov    (%eax),%edx
  802c65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 0b                	je     802c7e <alloc_block_BF+0x376>
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	75 08                	jne    802ca0 <alloc_block_BF+0x398>
  802c98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c9b:	a3 34 50 80 00       	mov    %eax,0x805034
  802ca0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ca5:	40                   	inc    %eax
  802ca6:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802caf:	75 17                	jne    802cc8 <alloc_block_BF+0x3c0>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 df 46 80 00       	push   $0x8046df
  802cb9:	68 51 01 00 00       	push   $0x151
  802cbe:	68 fd 46 80 00       	push   $0x8046fd
  802cc3:	e8 64 d7 ff ff       	call   80042c <_panic>
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 10                	je     802ce1 <alloc_block_BF+0x3d9>
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd9:	8b 52 04             	mov    0x4(%edx),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 0b                	jmp    802cec <alloc_block_BF+0x3e4>
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	a3 34 50 80 00       	mov    %eax,0x805034
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 0f                	je     802d05 <alloc_block_BF+0x3fd>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cff:	8b 12                	mov    (%edx),%edx
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	eb 0a                	jmp    802d0f <alloc_block_BF+0x407>
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d22:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d27:	48                   	dec    %eax
  802d28:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802d2d:	83 ec 04             	sub    $0x4,%esp
  802d30:	6a 00                	push   $0x0
  802d32:	ff 75 d0             	pushl  -0x30(%ebp)
  802d35:	ff 75 cc             	pushl  -0x34(%ebp)
  802d38:	e8 e0 f6 ff ff       	call   80241d <set_block_data>
  802d3d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d43:	e9 a3 01 00 00       	jmp    802eeb <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d48:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d4c:	0f 85 9d 00 00 00    	jne    802def <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	6a 01                	push   $0x1
  802d57:	ff 75 ec             	pushl  -0x14(%ebp)
  802d5a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d5d:	e8 bb f6 ff ff       	call   80241d <set_block_data>
  802d62:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d69:	75 17                	jne    802d82 <alloc_block_BF+0x47a>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 df 46 80 00       	push   $0x8046df
  802d73:	68 58 01 00 00       	push   $0x158
  802d78:	68 fd 46 80 00       	push   $0x8046fd
  802d7d:	e8 aa d6 ff ff       	call   80042c <_panic>
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	74 10                	je     802d9b <alloc_block_BF+0x493>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d93:	8b 52 04             	mov    0x4(%edx),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	eb 0b                	jmp    802da6 <alloc_block_BF+0x49e>
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	a3 34 50 80 00       	mov    %eax,0x805034
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 0f                	je     802dbf <alloc_block_BF+0x4b7>
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db9:	8b 12                	mov    (%edx),%edx
  802dbb:	89 10                	mov    %edx,(%eax)
  802dbd:	eb 0a                	jmp    802dc9 <alloc_block_BF+0x4c1>
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802de1:	48                   	dec    %eax
  802de2:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	e9 fc 00 00 00       	jmp    802eeb <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	83 c0 08             	add    $0x8,%eax
  802df5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802df8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e05:	01 d0                	add    %edx,%eax
  802e07:	48                   	dec    %eax
  802e08:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e13:	f7 75 c4             	divl   -0x3c(%ebp)
  802e16:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e19:	29 d0                	sub    %edx,%eax
  802e1b:	c1 e8 0c             	shr    $0xc,%eax
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	50                   	push   %eax
  802e22:	e8 5c e6 ff ff       	call   801483 <sbrk>
  802e27:	83 c4 10             	add    $0x10,%esp
  802e2a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e2d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e31:	75 0a                	jne    802e3d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e33:	b8 00 00 00 00       	mov    $0x0,%eax
  802e38:	e9 ae 00 00 00       	jmp    802eeb <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e3d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e44:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e4a:	01 d0                	add    %edx,%eax
  802e4c:	48                   	dec    %eax
  802e4d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e50:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e53:	ba 00 00 00 00       	mov    $0x0,%edx
  802e58:	f7 75 b8             	divl   -0x48(%ebp)
  802e5b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e5e:	29 d0                	sub    %edx,%eax
  802e60:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e63:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e66:	01 d0                	add    %edx,%eax
  802e68:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802e6d:	a1 44 50 80 00       	mov    0x805044,%eax
  802e72:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e78:	83 ec 0c             	sub    $0xc,%esp
  802e7b:	68 a4 47 80 00       	push   $0x8047a4
  802e80:	e8 64 d8 ff ff       	call   8006e9 <cprintf>
  802e85:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e88:	83 ec 08             	sub    $0x8,%esp
  802e8b:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8e:	68 a9 47 80 00       	push   $0x8047a9
  802e93:	e8 51 d8 ff ff       	call   8006e9 <cprintf>
  802e98:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e9b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ea2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ea5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	48                   	dec    %eax
  802eab:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802eae:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb6:	f7 75 b0             	divl   -0x50(%ebp)
  802eb9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ebc:	29 d0                	sub    %edx,%eax
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	6a 01                	push   $0x1
  802ec3:	50                   	push   %eax
  802ec4:	ff 75 bc             	pushl  -0x44(%ebp)
  802ec7:	e8 51 f5 ff ff       	call   80241d <set_block_data>
  802ecc:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ecf:	83 ec 0c             	sub    $0xc,%esp
  802ed2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ed5:	e8 36 04 00 00       	call   803310 <free_block>
  802eda:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802edd:	83 ec 0c             	sub    $0xc,%esp
  802ee0:	ff 75 08             	pushl  0x8(%ebp)
  802ee3:	e8 20 fa ff ff       	call   802908 <alloc_block_BF>
  802ee8:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eeb:	c9                   	leave  
  802eec:	c3                   	ret    

00802eed <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802eed:	55                   	push   %ebp
  802eee:	89 e5                	mov    %esp,%ebp
  802ef0:	53                   	push   %ebx
  802ef1:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ef4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802efb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	74 1e                	je     802f26 <merging+0x39>
  802f08:	ff 75 08             	pushl  0x8(%ebp)
  802f0b:	e8 bc f1 ff ff       	call   8020cc <get_block_size>
  802f10:	83 c4 04             	add    $0x4,%esp
  802f13:	89 c2                	mov    %eax,%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	01 d0                	add    %edx,%eax
  802f1a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f1d:	75 07                	jne    802f26 <merging+0x39>
		prev_is_free = 1;
  802f1f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2a:	74 1e                	je     802f4a <merging+0x5d>
  802f2c:	ff 75 10             	pushl  0x10(%ebp)
  802f2f:	e8 98 f1 ff ff       	call   8020cc <get_block_size>
  802f34:	83 c4 04             	add    $0x4,%esp
  802f37:	89 c2                	mov    %eax,%edx
  802f39:	8b 45 10             	mov    0x10(%ebp),%eax
  802f3c:	01 d0                	add    %edx,%eax
  802f3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f41:	75 07                	jne    802f4a <merging+0x5d>
		next_is_free = 1;
  802f43:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4e:	0f 84 cc 00 00 00    	je     803020 <merging+0x133>
  802f54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f58:	0f 84 c2 00 00 00    	je     803020 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f5e:	ff 75 08             	pushl  0x8(%ebp)
  802f61:	e8 66 f1 ff ff       	call   8020cc <get_block_size>
  802f66:	83 c4 04             	add    $0x4,%esp
  802f69:	89 c3                	mov    %eax,%ebx
  802f6b:	ff 75 10             	pushl  0x10(%ebp)
  802f6e:	e8 59 f1 ff ff       	call   8020cc <get_block_size>
  802f73:	83 c4 04             	add    $0x4,%esp
  802f76:	01 c3                	add    %eax,%ebx
  802f78:	ff 75 0c             	pushl  0xc(%ebp)
  802f7b:	e8 4c f1 ff ff       	call   8020cc <get_block_size>
  802f80:	83 c4 04             	add    $0x4,%esp
  802f83:	01 d8                	add    %ebx,%eax
  802f85:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f88:	6a 00                	push   $0x0
  802f8a:	ff 75 ec             	pushl  -0x14(%ebp)
  802f8d:	ff 75 08             	pushl  0x8(%ebp)
  802f90:	e8 88 f4 ff ff       	call   80241d <set_block_data>
  802f95:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f9c:	75 17                	jne    802fb5 <merging+0xc8>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 df 46 80 00       	push   $0x8046df
  802fa6:	68 7d 01 00 00       	push   $0x17d
  802fab:	68 fd 46 80 00       	push   $0x8046fd
  802fb0:	e8 77 d4 ff ff       	call   80042c <_panic>
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 10                	je     802fce <merging+0xe1>
  802fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc6:	8b 52 04             	mov    0x4(%edx),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 0b                	jmp    802fd9 <merging+0xec>
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	a3 34 50 80 00       	mov    %eax,0x805034
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0f                	je     802ff2 <merging+0x105>
  802fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fec:	8b 12                	mov    (%edx),%edx
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	eb 0a                	jmp    802ffc <merging+0x10f>
  802ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803005:	8b 45 0c             	mov    0xc(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803014:	48                   	dec    %eax
  803015:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80301a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80301b:	e9 ea 02 00 00       	jmp    80330a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803020:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803024:	74 3b                	je     803061 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	ff 75 08             	pushl  0x8(%ebp)
  80302c:	e8 9b f0 ff ff       	call   8020cc <get_block_size>
  803031:	83 c4 10             	add    $0x10,%esp
  803034:	89 c3                	mov    %eax,%ebx
  803036:	83 ec 0c             	sub    $0xc,%esp
  803039:	ff 75 10             	pushl  0x10(%ebp)
  80303c:	e8 8b f0 ff ff       	call   8020cc <get_block_size>
  803041:	83 c4 10             	add    $0x10,%esp
  803044:	01 d8                	add    %ebx,%eax
  803046:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	6a 00                	push   $0x0
  80304e:	ff 75 e8             	pushl  -0x18(%ebp)
  803051:	ff 75 08             	pushl  0x8(%ebp)
  803054:	e8 c4 f3 ff ff       	call   80241d <set_block_data>
  803059:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80305c:	e9 a9 02 00 00       	jmp    80330a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803065:	0f 84 2d 01 00 00    	je     803198 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80306b:	83 ec 0c             	sub    $0xc,%esp
  80306e:	ff 75 10             	pushl  0x10(%ebp)
  803071:	e8 56 f0 ff ff       	call   8020cc <get_block_size>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 c3                	mov    %eax,%ebx
  80307b:	83 ec 0c             	sub    $0xc,%esp
  80307e:	ff 75 0c             	pushl  0xc(%ebp)
  803081:	e8 46 f0 ff ff       	call   8020cc <get_block_size>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	01 d8                	add    %ebx,%eax
  80308b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	6a 00                	push   $0x0
  803093:	ff 75 e4             	pushl  -0x1c(%ebp)
  803096:	ff 75 10             	pushl  0x10(%ebp)
  803099:	e8 7f f3 ff ff       	call   80241d <set_block_data>
  80309e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ab:	74 06                	je     8030b3 <merging+0x1c6>
  8030ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030b1:	75 17                	jne    8030ca <merging+0x1dd>
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	68 b8 47 80 00       	push   $0x8047b8
  8030bb:	68 8d 01 00 00       	push   $0x18d
  8030c0:	68 fd 46 80 00       	push   $0x8046fd
  8030c5:	e8 62 d3 ff ff       	call   80042c <_panic>
  8030ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030cd:	8b 50 04             	mov    0x4(%eax),%edx
  8030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0d                	je     8030f5 <merging+0x208>
  8030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f1:	89 10                	mov    %edx,(%eax)
  8030f3:	eb 08                	jmp    8030fd <merging+0x210>
  8030f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803100:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803103:	89 50 04             	mov    %edx,0x4(%eax)
  803106:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80310b:	40                   	inc    %eax
  80310c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803111:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803115:	75 17                	jne    80312e <merging+0x241>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 df 46 80 00       	push   $0x8046df
  80311f:	68 8e 01 00 00       	push   $0x18e
  803124:	68 fd 46 80 00       	push   $0x8046fd
  803129:	e8 fe d2 ff ff       	call   80042c <_panic>
  80312e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 10                	je     803147 <merging+0x25a>
  803137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80313f:	8b 52 04             	mov    0x4(%edx),%edx
  803142:	89 50 04             	mov    %edx,0x4(%eax)
  803145:	eb 0b                	jmp    803152 <merging+0x265>
  803147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	a3 34 50 80 00       	mov    %eax,0x805034
  803152:	8b 45 0c             	mov    0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 0f                	je     80316b <merging+0x27e>
  80315c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	8b 55 0c             	mov    0xc(%ebp),%edx
  803165:	8b 12                	mov    (%edx),%edx
  803167:	89 10                	mov    %edx,(%eax)
  803169:	eb 0a                	jmp    803175 <merging+0x288>
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	a3 30 50 80 00       	mov    %eax,0x805030
  803175:	8b 45 0c             	mov    0xc(%ebp),%eax
  803178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80318d:	48                   	dec    %eax
  80318e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803193:	e9 72 01 00 00       	jmp    80330a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803198:	8b 45 10             	mov    0x10(%ebp),%eax
  80319b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80319e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a2:	74 79                	je     80321d <merging+0x330>
  8031a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a8:	74 73                	je     80321d <merging+0x330>
  8031aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ae:	74 06                	je     8031b6 <merging+0x2c9>
  8031b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b4:	75 17                	jne    8031cd <merging+0x2e0>
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	68 70 47 80 00       	push   $0x804770
  8031be:	68 94 01 00 00       	push   $0x194
  8031c3:	68 fd 46 80 00       	push   $0x8046fd
  8031c8:	e8 5f d2 ff ff       	call   80042c <_panic>
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	8b 10                	mov    (%eax),%edx
  8031d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d5:	89 10                	mov    %edx,(%eax)
  8031d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	74 0b                	je     8031eb <merging+0x2fe>
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	8b 00                	mov    (%eax),%eax
  8031e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e8:	89 50 04             	mov    %edx,0x4(%eax)
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f9:	89 50 04             	mov    %edx,0x4(%eax)
  8031fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	75 08                	jne    80320d <merging+0x320>
  803205:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803208:	a3 34 50 80 00       	mov    %eax,0x805034
  80320d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803212:	40                   	inc    %eax
  803213:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803218:	e9 ce 00 00 00       	jmp    8032eb <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80321d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803221:	74 65                	je     803288 <merging+0x39b>
  803223:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803227:	75 17                	jne    803240 <merging+0x353>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 4c 47 80 00       	push   $0x80474c
  803231:	68 95 01 00 00       	push   $0x195
  803236:	68 fd 46 80 00       	push   $0x8046fd
  80323b:	e8 ec d1 ff ff       	call   80042c <_panic>
  803240:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803246:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803249:	89 50 04             	mov    %edx,0x4(%eax)
  80324c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0c                	je     803262 <merging+0x375>
  803256:	a1 34 50 80 00       	mov    0x805034,%eax
  80325b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	eb 08                	jmp    80326a <merging+0x37d>
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	a3 30 50 80 00       	mov    %eax,0x805030
  80326a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326d:	a3 34 50 80 00       	mov    %eax,0x805034
  803272:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803280:	40                   	inc    %eax
  803281:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803286:	eb 63                	jmp    8032eb <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803288:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80328c:	75 17                	jne    8032a5 <merging+0x3b8>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 18 47 80 00       	push   $0x804718
  803296:	68 98 01 00 00       	push   $0x198
  80329b:	68 fd 46 80 00       	push   $0x8046fd
  8032a0:	e8 87 d1 ff ff       	call   80042c <_panic>
  8032a5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0d                	je     8032c6 <merging+0x3d9>
  8032b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8032be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032c1:	89 50 04             	mov    %edx,0x4(%eax)
  8032c4:	eb 08                	jmp    8032ce <merging+0x3e1>
  8032c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8032ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032e5:	40                   	inc    %eax
  8032e6:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8032eb:	83 ec 0c             	sub    $0xc,%esp
  8032ee:	ff 75 10             	pushl  0x10(%ebp)
  8032f1:	e8 d6 ed ff ff       	call   8020cc <get_block_size>
  8032f6:	83 c4 10             	add    $0x10,%esp
  8032f9:	83 ec 04             	sub    $0x4,%esp
  8032fc:	6a 00                	push   $0x0
  8032fe:	50                   	push   %eax
  8032ff:	ff 75 10             	pushl  0x10(%ebp)
  803302:	e8 16 f1 ff ff       	call   80241d <set_block_data>
  803307:	83 c4 10             	add    $0x10,%esp
	}
}
  80330a:	90                   	nop
  80330b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80330e:	c9                   	leave  
  80330f:	c3                   	ret    

00803310 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803310:	55                   	push   %ebp
  803311:	89 e5                	mov    %esp,%ebp
  803313:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803316:	a1 30 50 80 00       	mov    0x805030,%eax
  80331b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80331e:	a1 34 50 80 00       	mov    0x805034,%eax
  803323:	3b 45 08             	cmp    0x8(%ebp),%eax
  803326:	73 1b                	jae    803343 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803328:	a1 34 50 80 00       	mov    0x805034,%eax
  80332d:	83 ec 04             	sub    $0x4,%esp
  803330:	ff 75 08             	pushl  0x8(%ebp)
  803333:	6a 00                	push   $0x0
  803335:	50                   	push   %eax
  803336:	e8 b2 fb ff ff       	call   802eed <merging>
  80333b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80333e:	e9 8b 00 00 00       	jmp    8033ce <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803343:	a1 30 50 80 00       	mov    0x805030,%eax
  803348:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334b:	76 18                	jbe    803365 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80334d:	a1 30 50 80 00       	mov    0x805030,%eax
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	ff 75 08             	pushl  0x8(%ebp)
  803358:	50                   	push   %eax
  803359:	6a 00                	push   $0x0
  80335b:	e8 8d fb ff ff       	call   802eed <merging>
  803360:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803363:	eb 69                	jmp    8033ce <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803365:	a1 30 50 80 00       	mov    0x805030,%eax
  80336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336d:	eb 39                	jmp    8033a8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	3b 45 08             	cmp    0x8(%ebp),%eax
  803375:	73 29                	jae    8033a0 <free_block+0x90>
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337f:	76 1f                	jbe    8033a0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	ff 75 08             	pushl  0x8(%ebp)
  80338f:	ff 75 f0             	pushl  -0x10(%ebp)
  803392:	ff 75 f4             	pushl  -0xc(%ebp)
  803395:	e8 53 fb ff ff       	call   802eed <merging>
  80339a:	83 c4 10             	add    $0x10,%esp
			break;
  80339d:	90                   	nop
		}
	}
}
  80339e:	eb 2e                	jmp    8033ce <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ac:	74 07                	je     8033b5 <free_block+0xa5>
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	eb 05                	jmp    8033ba <free_block+0xaa>
  8033b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ba:	a3 38 50 80 00       	mov    %eax,0x805038
  8033bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	75 a7                	jne    80336f <free_block+0x5f>
  8033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cc:	75 a1                	jne    80336f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033ce:	90                   	nop
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033d7:	ff 75 08             	pushl  0x8(%ebp)
  8033da:	e8 ed ec ff ff       	call   8020cc <get_block_size>
  8033df:	83 c4 04             	add    $0x4,%esp
  8033e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033ec:	eb 17                	jmp    803405 <copy_data+0x34>
  8033ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f4:	01 c2                	add    %eax,%edx
  8033f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	01 c8                	add    %ecx,%eax
  8033fe:	8a 00                	mov    (%eax),%al
  803400:	88 02                	mov    %al,(%edx)
  803402:	ff 45 fc             	incl   -0x4(%ebp)
  803405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803408:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80340b:	72 e1                	jb     8033ee <copy_data+0x1d>
}
  80340d:	90                   	nop
  80340e:	c9                   	leave  
  80340f:	c3                   	ret    

00803410 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803410:	55                   	push   %ebp
  803411:	89 e5                	mov    %esp,%ebp
  803413:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803416:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341a:	75 23                	jne    80343f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80341c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803420:	74 13                	je     803435 <realloc_block_FF+0x25>
  803422:	83 ec 0c             	sub    $0xc,%esp
  803425:	ff 75 0c             	pushl  0xc(%ebp)
  803428:	e8 1f f0 ff ff       	call   80244c <alloc_block_FF>
  80342d:	83 c4 10             	add    $0x10,%esp
  803430:	e9 f4 06 00 00       	jmp    803b29 <realloc_block_FF+0x719>
		return NULL;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
  80343a:	e9 ea 06 00 00       	jmp    803b29 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80343f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803443:	75 18                	jne    80345d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803445:	83 ec 0c             	sub    $0xc,%esp
  803448:	ff 75 08             	pushl  0x8(%ebp)
  80344b:	e8 c0 fe ff ff       	call   803310 <free_block>
  803450:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803453:	b8 00 00 00 00       	mov    $0x0,%eax
  803458:	e9 cc 06 00 00       	jmp    803b29 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80345d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803461:	77 07                	ja     80346a <realloc_block_FF+0x5a>
  803463:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80346a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346d:	83 e0 01             	and    $0x1,%eax
  803470:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803473:	8b 45 0c             	mov    0xc(%ebp),%eax
  803476:	83 c0 08             	add    $0x8,%eax
  803479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	ff 75 08             	pushl  0x8(%ebp)
  803482:	e8 45 ec ff ff       	call   8020cc <get_block_size>
  803487:	83 c4 10             	add    $0x10,%esp
  80348a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80348d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803490:	83 e8 08             	sub    $0x8,%eax
  803493:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	83 e8 04             	sub    $0x4,%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	83 e0 fe             	and    $0xfffffffe,%eax
  8034a1:	89 c2                	mov    %eax,%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	01 d0                	add    %edx,%eax
  8034a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034ab:	83 ec 0c             	sub    $0xc,%esp
  8034ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b1:	e8 16 ec ff ff       	call   8020cc <get_block_size>
  8034b6:	83 c4 10             	add    $0x10,%esp
  8034b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bf:	83 e8 08             	sub    $0x8,%eax
  8034c2:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034cb:	75 08                	jne    8034d5 <realloc_block_FF+0xc5>
	{
		 return va;
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	e9 54 06 00 00       	jmp    803b29 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034db:	0f 83 e5 03 00 00    	jae    8038c6 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e4:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034ea:	83 ec 0c             	sub    $0xc,%esp
  8034ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f0:	e8 f0 eb ff ff       	call   8020e5 <is_free_block>
  8034f5:	83 c4 10             	add    $0x10,%esp
  8034f8:	84 c0                	test   %al,%al
  8034fa:	0f 84 3b 01 00 00    	je     80363b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803500:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803503:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803506:	01 d0                	add    %edx,%eax
  803508:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	6a 01                	push   $0x1
  803510:	ff 75 f0             	pushl  -0x10(%ebp)
  803513:	ff 75 08             	pushl  0x8(%ebp)
  803516:	e8 02 ef ff ff       	call   80241d <set_block_data>
  80351b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	83 e8 04             	sub    $0x4,%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	83 e0 fe             	and    $0xfffffffe,%eax
  803529:	89 c2                	mov    %eax,%edx
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	01 d0                	add    %edx,%eax
  803530:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803533:	83 ec 04             	sub    $0x4,%esp
  803536:	6a 00                	push   $0x0
  803538:	ff 75 cc             	pushl  -0x34(%ebp)
  80353b:	ff 75 c8             	pushl  -0x38(%ebp)
  80353e:	e8 da ee ff ff       	call   80241d <set_block_data>
  803543:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803546:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80354a:	74 06                	je     803552 <realloc_block_FF+0x142>
  80354c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803550:	75 17                	jne    803569 <realloc_block_FF+0x159>
  803552:	83 ec 04             	sub    $0x4,%esp
  803555:	68 70 47 80 00       	push   $0x804770
  80355a:	68 f6 01 00 00       	push   $0x1f6
  80355f:	68 fd 46 80 00       	push   $0x8046fd
  803564:	e8 c3 ce ff ff       	call   80042c <_panic>
  803569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356c:	8b 10                	mov    (%eax),%edx
  80356e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803571:	89 10                	mov    %edx,(%eax)
  803573:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	74 0b                	je     803587 <realloc_block_FF+0x177>
  80357c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	75 08                	jne    8035a9 <realloc_block_FF+0x199>
  8035a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8035a9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035ae:	40                   	inc    %eax
  8035af:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035b8:	75 17                	jne    8035d1 <realloc_block_FF+0x1c1>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 df 46 80 00       	push   $0x8046df
  8035c2:	68 f7 01 00 00       	push   $0x1f7
  8035c7:	68 fd 46 80 00       	push   $0x8046fd
  8035cc:	e8 5b ce ff ff       	call   80042c <_panic>
  8035d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 10                	je     8035ea <realloc_block_FF+0x1da>
  8035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035e2:	8b 52 04             	mov    0x4(%edx),%edx
  8035e5:	89 50 04             	mov    %edx,0x4(%eax)
  8035e8:	eb 0b                	jmp    8035f5 <realloc_block_FF+0x1e5>
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	a3 34 50 80 00       	mov    %eax,0x805034
  8035f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 0f                	je     80360e <realloc_block_FF+0x1fe>
  8035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803602:	8b 40 04             	mov    0x4(%eax),%eax
  803605:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803608:	8b 12                	mov    (%edx),%edx
  80360a:	89 10                	mov    %edx,(%eax)
  80360c:	eb 0a                	jmp    803618 <realloc_block_FF+0x208>
  80360e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	a3 30 50 80 00       	mov    %eax,0x805030
  803618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803630:	48                   	dec    %eax
  803631:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803636:	e9 83 02 00 00       	jmp    8038be <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80363b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80363f:	0f 86 69 02 00 00    	jbe    8038ae <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	6a 01                	push   $0x1
  80364a:	ff 75 f0             	pushl  -0x10(%ebp)
  80364d:	ff 75 08             	pushl  0x8(%ebp)
  803650:	e8 c8 ed ff ff       	call   80241d <set_block_data>
  803655:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	83 e8 04             	sub    $0x4,%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	83 e0 fe             	and    $0xfffffffe,%eax
  803663:	89 c2                	mov    %eax,%edx
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	01 d0                	add    %edx,%eax
  80366a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80366d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803672:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803675:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803679:	75 68                	jne    8036e3 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80367b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80367f:	75 17                	jne    803698 <realloc_block_FF+0x288>
  803681:	83 ec 04             	sub    $0x4,%esp
  803684:	68 18 47 80 00       	push   $0x804718
  803689:	68 06 02 00 00       	push   $0x206
  80368e:	68 fd 46 80 00       	push   $0x8046fd
  803693:	e8 94 cd ff ff       	call   80042c <_panic>
  803698:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a1:	89 10                	mov    %edx,(%eax)
  8036a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	85 c0                	test   %eax,%eax
  8036aa:	74 0d                	je     8036b9 <realloc_block_FF+0x2a9>
  8036ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8036b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b4:	89 50 04             	mov    %edx,0x4(%eax)
  8036b7:	eb 08                	jmp    8036c1 <realloc_block_FF+0x2b1>
  8036b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036d8:	40                   	inc    %eax
  8036d9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036de:	e9 b0 01 00 00       	jmp    803893 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036eb:	76 68                	jbe    803755 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036f1:	75 17                	jne    80370a <realloc_block_FF+0x2fa>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 18 47 80 00       	push   $0x804718
  8036fb:	68 0b 02 00 00       	push   $0x20b
  803700:	68 fd 46 80 00       	push   $0x8046fd
  803705:	e8 22 cd ff ff       	call   80042c <_panic>
  80370a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803713:	89 10                	mov    %edx,(%eax)
  803715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0d                	je     80372b <realloc_block_FF+0x31b>
  80371e:	a1 30 50 80 00       	mov    0x805030,%eax
  803723:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803726:	89 50 04             	mov    %edx,0x4(%eax)
  803729:	eb 08                	jmp    803733 <realloc_block_FF+0x323>
  80372b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372e:	a3 34 50 80 00       	mov    %eax,0x805034
  803733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803736:	a3 30 50 80 00       	mov    %eax,0x805030
  80373b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803745:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803750:	e9 3e 01 00 00       	jmp    803893 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803755:	a1 30 50 80 00       	mov    0x805030,%eax
  80375a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80375d:	73 68                	jae    8037c7 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80375f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803763:	75 17                	jne    80377c <realloc_block_FF+0x36c>
  803765:	83 ec 04             	sub    $0x4,%esp
  803768:	68 4c 47 80 00       	push   $0x80474c
  80376d:	68 10 02 00 00       	push   $0x210
  803772:	68 fd 46 80 00       	push   $0x8046fd
  803777:	e8 b0 cc ff ff       	call   80042c <_panic>
  80377c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803785:	89 50 04             	mov    %edx,0x4(%eax)
  803788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80378b:	8b 40 04             	mov    0x4(%eax),%eax
  80378e:	85 c0                	test   %eax,%eax
  803790:	74 0c                	je     80379e <realloc_block_FF+0x38e>
  803792:	a1 34 50 80 00       	mov    0x805034,%eax
  803797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	eb 08                	jmp    8037a6 <realloc_block_FF+0x396>
  80379e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	a3 34 50 80 00       	mov    %eax,0x805034
  8037ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037bc:	40                   	inc    %eax
  8037bd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037c2:	e9 cc 00 00 00       	jmp    803893 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8037d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d6:	e9 8a 00 00 00       	jmp    803865 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037e1:	73 7a                	jae    80385d <realloc_block_FF+0x44d>
  8037e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037eb:	73 70                	jae    80385d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f1:	74 06                	je     8037f9 <realloc_block_FF+0x3e9>
  8037f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037f7:	75 17                	jne    803810 <realloc_block_FF+0x400>
  8037f9:	83 ec 04             	sub    $0x4,%esp
  8037fc:	68 70 47 80 00       	push   $0x804770
  803801:	68 1a 02 00 00       	push   $0x21a
  803806:	68 fd 46 80 00       	push   $0x8046fd
  80380b:	e8 1c cc ff ff       	call   80042c <_panic>
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	8b 10                	mov    (%eax),%edx
  803815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 0b                	je     80382e <realloc_block_FF+0x41e>
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80382b:	89 50 04             	mov    %edx,0x4(%eax)
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803834:	89 10                	mov    %edx,(%eax)
  803836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80383c:	89 50 04             	mov    %edx,0x4(%eax)
  80383f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	75 08                	jne    803850 <realloc_block_FF+0x440>
  803848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80384b:	a3 34 50 80 00       	mov    %eax,0x805034
  803850:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803855:	40                   	inc    %eax
  803856:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  80385b:	eb 36                	jmp    803893 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80385d:	a1 38 50 80 00       	mov    0x805038,%eax
  803862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803869:	74 07                	je     803872 <realloc_block_FF+0x462>
  80386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	eb 05                	jmp    803877 <realloc_block_FF+0x467>
  803872:	b8 00 00 00 00       	mov    $0x0,%eax
  803877:	a3 38 50 80 00       	mov    %eax,0x805038
  80387c:	a1 38 50 80 00       	mov    0x805038,%eax
  803881:	85 c0                	test   %eax,%eax
  803883:	0f 85 52 ff ff ff    	jne    8037db <realloc_block_FF+0x3cb>
  803889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388d:	0f 85 48 ff ff ff    	jne    8037db <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803893:	83 ec 04             	sub    $0x4,%esp
  803896:	6a 00                	push   $0x0
  803898:	ff 75 d8             	pushl  -0x28(%ebp)
  80389b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80389e:	e8 7a eb ff ff       	call   80241d <set_block_data>
  8038a3:	83 c4 10             	add    $0x10,%esp
				return va;
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	e9 7b 02 00 00       	jmp    803b29 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038ae:	83 ec 0c             	sub    $0xc,%esp
  8038b1:	68 ed 47 80 00       	push   $0x8047ed
  8038b6:	e8 2e ce ff ff       	call   8006e9 <cprintf>
  8038bb:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	e9 63 02 00 00       	jmp    803b29 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038cc:	0f 86 4d 02 00 00    	jbe    803b1f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038d2:	83 ec 0c             	sub    $0xc,%esp
  8038d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038d8:	e8 08 e8 ff ff       	call   8020e5 <is_free_block>
  8038dd:	83 c4 10             	add    $0x10,%esp
  8038e0:	84 c0                	test   %al,%al
  8038e2:	0f 84 37 02 00 00    	je     803b1f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038eb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038f4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038f7:	76 38                	jbe    803931 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038f9:	83 ec 0c             	sub    $0xc,%esp
  8038fc:	ff 75 08             	pushl  0x8(%ebp)
  8038ff:	e8 0c fa ff ff       	call   803310 <free_block>
  803904:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803907:	83 ec 0c             	sub    $0xc,%esp
  80390a:	ff 75 0c             	pushl  0xc(%ebp)
  80390d:	e8 3a eb ff ff       	call   80244c <alloc_block_FF>
  803912:	83 c4 10             	add    $0x10,%esp
  803915:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803918:	83 ec 08             	sub    $0x8,%esp
  80391b:	ff 75 c0             	pushl  -0x40(%ebp)
  80391e:	ff 75 08             	pushl  0x8(%ebp)
  803921:	e8 ab fa ff ff       	call   8033d1 <copy_data>
  803926:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803929:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80392c:	e9 f8 01 00 00       	jmp    803b29 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803931:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803934:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803937:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80393a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80393e:	0f 87 a0 00 00 00    	ja     8039e4 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803948:	75 17                	jne    803961 <realloc_block_FF+0x551>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 df 46 80 00       	push   $0x8046df
  803952:	68 38 02 00 00       	push   $0x238
  803957:	68 fd 46 80 00       	push   $0x8046fd
  80395c:	e8 cb ca ff ff       	call   80042c <_panic>
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	74 10                	je     80397a <realloc_block_FF+0x56a>
  80396a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396d:	8b 00                	mov    (%eax),%eax
  80396f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803972:	8b 52 04             	mov    0x4(%edx),%edx
  803975:	89 50 04             	mov    %edx,0x4(%eax)
  803978:	eb 0b                	jmp    803985 <realloc_block_FF+0x575>
  80397a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	a3 34 50 80 00       	mov    %eax,0x805034
  803985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	74 0f                	je     80399e <realloc_block_FF+0x58e>
  80398f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803992:	8b 40 04             	mov    0x4(%eax),%eax
  803995:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803998:	8b 12                	mov    (%edx),%edx
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	eb 0a                	jmp    8039a8 <realloc_block_FF+0x598>
  80399e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a1:	8b 00                	mov    (%eax),%eax
  8039a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039bb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039c0:	48                   	dec    %eax
  8039c1:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039cc:	01 d0                	add    %edx,%eax
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	6a 01                	push   $0x1
  8039d3:	50                   	push   %eax
  8039d4:	ff 75 08             	pushl  0x8(%ebp)
  8039d7:	e8 41 ea ff ff       	call   80241d <set_block_data>
  8039dc:	83 c4 10             	add    $0x10,%esp
  8039df:	e9 36 01 00 00       	jmp    803b1a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039ea:	01 d0                	add    %edx,%eax
  8039ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039ef:	83 ec 04             	sub    $0x4,%esp
  8039f2:	6a 01                	push   $0x1
  8039f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8039f7:	ff 75 08             	pushl  0x8(%ebp)
  8039fa:	e8 1e ea ff ff       	call   80241d <set_block_data>
  8039ff:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	83 e8 04             	sub    $0x4,%eax
  803a08:	8b 00                	mov    (%eax),%eax
  803a0a:	83 e0 fe             	and    $0xfffffffe,%eax
  803a0d:	89 c2                	mov    %eax,%edx
  803a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a12:	01 d0                	add    %edx,%eax
  803a14:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a1b:	74 06                	je     803a23 <realloc_block_FF+0x613>
  803a1d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a21:	75 17                	jne    803a3a <realloc_block_FF+0x62a>
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	68 70 47 80 00       	push   $0x804770
  803a2b:	68 44 02 00 00       	push   $0x244
  803a30:	68 fd 46 80 00       	push   $0x8046fd
  803a35:	e8 f2 c9 ff ff       	call   80042c <_panic>
  803a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3d:	8b 10                	mov    (%eax),%edx
  803a3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a42:	89 10                	mov    %edx,(%eax)
  803a44:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	85 c0                	test   %eax,%eax
  803a4b:	74 0b                	je     803a58 <realloc_block_FF+0x648>
  803a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a50:	8b 00                	mov    (%eax),%eax
  803a52:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a55:	89 50 04             	mov    %edx,0x4(%eax)
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a5e:	89 10                	mov    %edx,(%eax)
  803a60:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a66:	89 50 04             	mov    %edx,0x4(%eax)
  803a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a6c:	8b 00                	mov    (%eax),%eax
  803a6e:	85 c0                	test   %eax,%eax
  803a70:	75 08                	jne    803a7a <realloc_block_FF+0x66a>
  803a72:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a75:	a3 34 50 80 00       	mov    %eax,0x805034
  803a7a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a7f:	40                   	inc    %eax
  803a80:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a89:	75 17                	jne    803aa2 <realloc_block_FF+0x692>
  803a8b:	83 ec 04             	sub    $0x4,%esp
  803a8e:	68 df 46 80 00       	push   $0x8046df
  803a93:	68 45 02 00 00       	push   $0x245
  803a98:	68 fd 46 80 00       	push   $0x8046fd
  803a9d:	e8 8a c9 ff ff       	call   80042c <_panic>
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	74 10                	je     803abb <realloc_block_FF+0x6ab>
  803aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aae:	8b 00                	mov    (%eax),%eax
  803ab0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab3:	8b 52 04             	mov    0x4(%edx),%edx
  803ab6:	89 50 04             	mov    %edx,0x4(%eax)
  803ab9:	eb 0b                	jmp    803ac6 <realloc_block_FF+0x6b6>
  803abb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abe:	8b 40 04             	mov    0x4(%eax),%eax
  803ac1:	a3 34 50 80 00       	mov    %eax,0x805034
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	8b 40 04             	mov    0x4(%eax),%eax
  803acc:	85 c0                	test   %eax,%eax
  803ace:	74 0f                	je     803adf <realloc_block_FF+0x6cf>
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 40 04             	mov    0x4(%eax),%eax
  803ad6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad9:	8b 12                	mov    (%edx),%edx
  803adb:	89 10                	mov    %edx,(%eax)
  803add:	eb 0a                	jmp    803ae9 <realloc_block_FF+0x6d9>
  803adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae2:	8b 00                	mov    (%eax),%eax
  803ae4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b01:	48                   	dec    %eax
  803b02:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	6a 00                	push   $0x0
  803b0c:	ff 75 bc             	pushl  -0x44(%ebp)
  803b0f:	ff 75 b8             	pushl  -0x48(%ebp)
  803b12:	e8 06 e9 ff ff       	call   80241d <set_block_data>
  803b17:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1d:	eb 0a                	jmp    803b29 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b1f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b29:	c9                   	leave  
  803b2a:	c3                   	ret    

00803b2b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b2b:	55                   	push   %ebp
  803b2c:	89 e5                	mov    %esp,%ebp
  803b2e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b31:	83 ec 04             	sub    $0x4,%esp
  803b34:	68 f4 47 80 00       	push   $0x8047f4
  803b39:	68 58 02 00 00       	push   $0x258
  803b3e:	68 fd 46 80 00       	push   $0x8046fd
  803b43:	e8 e4 c8 ff ff       	call   80042c <_panic>

00803b48 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b48:	55                   	push   %ebp
  803b49:	89 e5                	mov    %esp,%ebp
  803b4b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b4e:	83 ec 04             	sub    $0x4,%esp
  803b51:	68 1c 48 80 00       	push   $0x80481c
  803b56:	68 61 02 00 00       	push   $0x261
  803b5b:	68 fd 46 80 00       	push   $0x8046fd
  803b60:	e8 c7 c8 ff ff       	call   80042c <_panic>
  803b65:	66 90                	xchg   %ax,%ax
  803b67:	90                   	nop

00803b68 <__udivdi3>:
  803b68:	55                   	push   %ebp
  803b69:	57                   	push   %edi
  803b6a:	56                   	push   %esi
  803b6b:	53                   	push   %ebx
  803b6c:	83 ec 1c             	sub    $0x1c,%esp
  803b6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b7f:	89 ca                	mov    %ecx,%edx
  803b81:	89 f8                	mov    %edi,%eax
  803b83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b87:	85 f6                	test   %esi,%esi
  803b89:	75 2d                	jne    803bb8 <__udivdi3+0x50>
  803b8b:	39 cf                	cmp    %ecx,%edi
  803b8d:	77 65                	ja     803bf4 <__udivdi3+0x8c>
  803b8f:	89 fd                	mov    %edi,%ebp
  803b91:	85 ff                	test   %edi,%edi
  803b93:	75 0b                	jne    803ba0 <__udivdi3+0x38>
  803b95:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9a:	31 d2                	xor    %edx,%edx
  803b9c:	f7 f7                	div    %edi
  803b9e:	89 c5                	mov    %eax,%ebp
  803ba0:	31 d2                	xor    %edx,%edx
  803ba2:	89 c8                	mov    %ecx,%eax
  803ba4:	f7 f5                	div    %ebp
  803ba6:	89 c1                	mov    %eax,%ecx
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f5                	div    %ebp
  803bac:	89 cf                	mov    %ecx,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	39 ce                	cmp    %ecx,%esi
  803bba:	77 28                	ja     803be4 <__udivdi3+0x7c>
  803bbc:	0f bd fe             	bsr    %esi,%edi
  803bbf:	83 f7 1f             	xor    $0x1f,%edi
  803bc2:	75 40                	jne    803c04 <__udivdi3+0x9c>
  803bc4:	39 ce                	cmp    %ecx,%esi
  803bc6:	72 0a                	jb     803bd2 <__udivdi3+0x6a>
  803bc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bcc:	0f 87 9e 00 00 00    	ja     803c70 <__udivdi3+0x108>
  803bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd7:	89 fa                	mov    %edi,%edx
  803bd9:	83 c4 1c             	add    $0x1c,%esp
  803bdc:	5b                   	pop    %ebx
  803bdd:	5e                   	pop    %esi
  803bde:	5f                   	pop    %edi
  803bdf:	5d                   	pop    %ebp
  803be0:	c3                   	ret    
  803be1:	8d 76 00             	lea    0x0(%esi),%esi
  803be4:	31 ff                	xor    %edi,%edi
  803be6:	31 c0                	xor    %eax,%eax
  803be8:	89 fa                	mov    %edi,%edx
  803bea:	83 c4 1c             	add    $0x1c,%esp
  803bed:	5b                   	pop    %ebx
  803bee:	5e                   	pop    %esi
  803bef:	5f                   	pop    %edi
  803bf0:	5d                   	pop    %ebp
  803bf1:	c3                   	ret    
  803bf2:	66 90                	xchg   %ax,%ax
  803bf4:	89 d8                	mov    %ebx,%eax
  803bf6:	f7 f7                	div    %edi
  803bf8:	31 ff                	xor    %edi,%edi
  803bfa:	89 fa                	mov    %edi,%edx
  803bfc:	83 c4 1c             	add    $0x1c,%esp
  803bff:	5b                   	pop    %ebx
  803c00:	5e                   	pop    %esi
  803c01:	5f                   	pop    %edi
  803c02:	5d                   	pop    %ebp
  803c03:	c3                   	ret    
  803c04:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c09:	89 eb                	mov    %ebp,%ebx
  803c0b:	29 fb                	sub    %edi,%ebx
  803c0d:	89 f9                	mov    %edi,%ecx
  803c0f:	d3 e6                	shl    %cl,%esi
  803c11:	89 c5                	mov    %eax,%ebp
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 ed                	shr    %cl,%ebp
  803c17:	89 e9                	mov    %ebp,%ecx
  803c19:	09 f1                	or     %esi,%ecx
  803c1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c1f:	89 f9                	mov    %edi,%ecx
  803c21:	d3 e0                	shl    %cl,%eax
  803c23:	89 c5                	mov    %eax,%ebp
  803c25:	89 d6                	mov    %edx,%esi
  803c27:	88 d9                	mov    %bl,%cl
  803c29:	d3 ee                	shr    %cl,%esi
  803c2b:	89 f9                	mov    %edi,%ecx
  803c2d:	d3 e2                	shl    %cl,%edx
  803c2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 e8                	shr    %cl,%eax
  803c37:	09 c2                	or     %eax,%edx
  803c39:	89 d0                	mov    %edx,%eax
  803c3b:	89 f2                	mov    %esi,%edx
  803c3d:	f7 74 24 0c          	divl   0xc(%esp)
  803c41:	89 d6                	mov    %edx,%esi
  803c43:	89 c3                	mov    %eax,%ebx
  803c45:	f7 e5                	mul    %ebp
  803c47:	39 d6                	cmp    %edx,%esi
  803c49:	72 19                	jb     803c64 <__udivdi3+0xfc>
  803c4b:	74 0b                	je     803c58 <__udivdi3+0xf0>
  803c4d:	89 d8                	mov    %ebx,%eax
  803c4f:	31 ff                	xor    %edi,%edi
  803c51:	e9 58 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c5c:	89 f9                	mov    %edi,%ecx
  803c5e:	d3 e2                	shl    %cl,%edx
  803c60:	39 c2                	cmp    %eax,%edx
  803c62:	73 e9                	jae    803c4d <__udivdi3+0xe5>
  803c64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c67:	31 ff                	xor    %edi,%edi
  803c69:	e9 40 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c6e:	66 90                	xchg   %ax,%ax
  803c70:	31 c0                	xor    %eax,%eax
  803c72:	e9 37 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c77:	90                   	nop

00803c78 <__umoddi3>:
  803c78:	55                   	push   %ebp
  803c79:	57                   	push   %edi
  803c7a:	56                   	push   %esi
  803c7b:	53                   	push   %ebx
  803c7c:	83 ec 1c             	sub    $0x1c,%esp
  803c7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c83:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c97:	89 f3                	mov    %esi,%ebx
  803c99:	89 fa                	mov    %edi,%edx
  803c9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c9f:	89 34 24             	mov    %esi,(%esp)
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	75 1a                	jne    803cc0 <__umoddi3+0x48>
  803ca6:	39 f7                	cmp    %esi,%edi
  803ca8:	0f 86 a2 00 00 00    	jbe    803d50 <__umoddi3+0xd8>
  803cae:	89 c8                	mov    %ecx,%eax
  803cb0:	89 f2                	mov    %esi,%edx
  803cb2:	f7 f7                	div    %edi
  803cb4:	89 d0                	mov    %edx,%eax
  803cb6:	31 d2                	xor    %edx,%edx
  803cb8:	83 c4 1c             	add    $0x1c,%esp
  803cbb:	5b                   	pop    %ebx
  803cbc:	5e                   	pop    %esi
  803cbd:	5f                   	pop    %edi
  803cbe:	5d                   	pop    %ebp
  803cbf:	c3                   	ret    
  803cc0:	39 f0                	cmp    %esi,%eax
  803cc2:	0f 87 ac 00 00 00    	ja     803d74 <__umoddi3+0xfc>
  803cc8:	0f bd e8             	bsr    %eax,%ebp
  803ccb:	83 f5 1f             	xor    $0x1f,%ebp
  803cce:	0f 84 ac 00 00 00    	je     803d80 <__umoddi3+0x108>
  803cd4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd9:	29 ef                	sub    %ebp,%edi
  803cdb:	89 fe                	mov    %edi,%esi
  803cdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ce1:	89 e9                	mov    %ebp,%ecx
  803ce3:	d3 e0                	shl    %cl,%eax
  803ce5:	89 d7                	mov    %edx,%edi
  803ce7:	89 f1                	mov    %esi,%ecx
  803ce9:	d3 ef                	shr    %cl,%edi
  803ceb:	09 c7                	or     %eax,%edi
  803ced:	89 e9                	mov    %ebp,%ecx
  803cef:	d3 e2                	shl    %cl,%edx
  803cf1:	89 14 24             	mov    %edx,(%esp)
  803cf4:	89 d8                	mov    %ebx,%eax
  803cf6:	d3 e0                	shl    %cl,%eax
  803cf8:	89 c2                	mov    %eax,%edx
  803cfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfe:	d3 e0                	shl    %cl,%eax
  803d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d08:	89 f1                	mov    %esi,%ecx
  803d0a:	d3 e8                	shr    %cl,%eax
  803d0c:	09 d0                	or     %edx,%eax
  803d0e:	d3 eb                	shr    %cl,%ebx
  803d10:	89 da                	mov    %ebx,%edx
  803d12:	f7 f7                	div    %edi
  803d14:	89 d3                	mov    %edx,%ebx
  803d16:	f7 24 24             	mull   (%esp)
  803d19:	89 c6                	mov    %eax,%esi
  803d1b:	89 d1                	mov    %edx,%ecx
  803d1d:	39 d3                	cmp    %edx,%ebx
  803d1f:	0f 82 87 00 00 00    	jb     803dac <__umoddi3+0x134>
  803d25:	0f 84 91 00 00 00    	je     803dbc <__umoddi3+0x144>
  803d2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d2f:	29 f2                	sub    %esi,%edx
  803d31:	19 cb                	sbb    %ecx,%ebx
  803d33:	89 d8                	mov    %ebx,%eax
  803d35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d39:	d3 e0                	shl    %cl,%eax
  803d3b:	89 e9                	mov    %ebp,%ecx
  803d3d:	d3 ea                	shr    %cl,%edx
  803d3f:	09 d0                	or     %edx,%eax
  803d41:	89 e9                	mov    %ebp,%ecx
  803d43:	d3 eb                	shr    %cl,%ebx
  803d45:	89 da                	mov    %ebx,%edx
  803d47:	83 c4 1c             	add    $0x1c,%esp
  803d4a:	5b                   	pop    %ebx
  803d4b:	5e                   	pop    %esi
  803d4c:	5f                   	pop    %edi
  803d4d:	5d                   	pop    %ebp
  803d4e:	c3                   	ret    
  803d4f:	90                   	nop
  803d50:	89 fd                	mov    %edi,%ebp
  803d52:	85 ff                	test   %edi,%edi
  803d54:	75 0b                	jne    803d61 <__umoddi3+0xe9>
  803d56:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5b:	31 d2                	xor    %edx,%edx
  803d5d:	f7 f7                	div    %edi
  803d5f:	89 c5                	mov    %eax,%ebp
  803d61:	89 f0                	mov    %esi,%eax
  803d63:	31 d2                	xor    %edx,%edx
  803d65:	f7 f5                	div    %ebp
  803d67:	89 c8                	mov    %ecx,%eax
  803d69:	f7 f5                	div    %ebp
  803d6b:	89 d0                	mov    %edx,%eax
  803d6d:	e9 44 ff ff ff       	jmp    803cb6 <__umoddi3+0x3e>
  803d72:	66 90                	xchg   %ax,%ax
  803d74:	89 c8                	mov    %ecx,%eax
  803d76:	89 f2                	mov    %esi,%edx
  803d78:	83 c4 1c             	add    $0x1c,%esp
  803d7b:	5b                   	pop    %ebx
  803d7c:	5e                   	pop    %esi
  803d7d:	5f                   	pop    %edi
  803d7e:	5d                   	pop    %ebp
  803d7f:	c3                   	ret    
  803d80:	3b 04 24             	cmp    (%esp),%eax
  803d83:	72 06                	jb     803d8b <__umoddi3+0x113>
  803d85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d89:	77 0f                	ja     803d9a <__umoddi3+0x122>
  803d8b:	89 f2                	mov    %esi,%edx
  803d8d:	29 f9                	sub    %edi,%ecx
  803d8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d93:	89 14 24             	mov    %edx,(%esp)
  803d96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d9e:	8b 14 24             	mov    (%esp),%edx
  803da1:	83 c4 1c             	add    $0x1c,%esp
  803da4:	5b                   	pop    %ebx
  803da5:	5e                   	pop    %esi
  803da6:	5f                   	pop    %edi
  803da7:	5d                   	pop    %ebp
  803da8:	c3                   	ret    
  803da9:	8d 76 00             	lea    0x0(%esi),%esi
  803dac:	2b 04 24             	sub    (%esp),%eax
  803daf:	19 fa                	sbb    %edi,%edx
  803db1:	89 d1                	mov    %edx,%ecx
  803db3:	89 c6                	mov    %eax,%esi
  803db5:	e9 71 ff ff ff       	jmp    803d2b <__umoddi3+0xb3>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dc0:	72 ea                	jb     803dac <__umoddi3+0x134>
  803dc2:	89 d9                	mov    %ebx,%ecx
  803dc4:	e9 62 ff ff ff       	jmp    803d2b <__umoddi3+0xb3>
