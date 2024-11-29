
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
  800060:	68 00 3d 80 00       	push   $0x803d00
  800065:	6a 11                	push   $0x11
  800067:	68 1c 3d 80 00       	push   $0x803d1c
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
  8000bc:	e8 27 1a 00 00       	call   801ae8 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 6a 1a 00 00       	call   801b33 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 38 3d 80 00       	push   $0x803d38
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 1c 3d 80 00       	push   $0x803d1c
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 29 1a 00 00       	call   801b33 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 68 3d 80 00       	push   $0x803d68
  800117:	6a 33                	push   $0x33
  800119:	68 1c 3d 80 00       	push   $0x803d1c
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 c0 19 00 00       	call   801ae8 <sys_calculate_free_frames>
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
  80015f:	e8 84 19 00 00       	call   801ae8 <sys_calculate_free_frames>
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
  80017c:	68 98 3d 80 00       	push   $0x803d98
  800181:	6a 3d                	push   $0x3d
  800183:	68 1c 3d 80 00       	push   $0x803d1c
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
  8001c7:	e8 77 1d 00 00       	call   801f43 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 14 3e 80 00       	push   $0x803e14
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 1c 3d 80 00       	push   $0x803d1c
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 f7 18 00 00       	call   801ae8 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 3a 19 00 00       	call   801b33 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 20 19 00 00       	call   801b33 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 34 3e 80 00       	push   $0x803e34
  800220:	6a 4e                	push   $0x4e
  800222:	68 1c 3d 80 00       	push   $0x803d1c
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 b7 18 00 00       	call   801ae8 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 70 3e 80 00       	push   $0x803e70
  800247:	6a 4f                	push   $0x4f
  800249:	68 1c 3d 80 00       	push   $0x803d1c
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
  80028d:	e8 b1 1c 00 00       	call   801f43 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 bc 3e 80 00       	push   $0x803ebc
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 1c 3d 80 00       	push   $0x803d1c
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 38 1b 00 00       	call   801def <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 4c 1b 00 00       	call   801e09 <gettst>
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
  8002d4:	e8 16 1b 00 00       	call   801def <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 e0 3e 80 00       	push   $0x803ee0
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 1c 3d 80 00       	push   $0x803d1c
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
  8002f3:	e8 b9 19 00 00       	call   801cb1 <sys_getenvindex>
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
  800361:	e8 cf 16 00 00       	call   801a35 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 44 3f 80 00       	push   $0x803f44
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
  800391:	68 6c 3f 80 00       	push   $0x803f6c
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
  8003c2:	68 94 3f 80 00       	push   $0x803f94
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 ec 3f 80 00       	push   $0x803fec
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 44 3f 80 00       	push   $0x803f44
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 4f 16 00 00       	call   801a4f <sys_unlock_cons>
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
  800413:	e8 65 18 00 00       	call   801c7d <sys_destroy_env>
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
  800424:	e8 ba 18 00 00       	call   801ce3 <sys_exit_env>
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
  80044d:	68 00 40 80 00       	push   $0x804000
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 05 40 80 00       	push   $0x804005
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
  80048a:	68 21 40 80 00       	push   $0x804021
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
  8004b9:	68 24 40 80 00       	push   $0x804024
  8004be:	6a 26                	push   $0x26
  8004c0:	68 70 40 80 00       	push   $0x804070
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
  80058e:	68 7c 40 80 00       	push   $0x80407c
  800593:	6a 3a                	push   $0x3a
  800595:	68 70 40 80 00       	push   $0x804070
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
  800601:	68 d0 40 80 00       	push   $0x8040d0
  800606:	6a 44                	push   $0x44
  800608:	68 70 40 80 00       	push   $0x804070
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
  80065b:	e8 93 13 00 00       	call   8019f3 <sys_cputs>
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
  8006d2:	e8 1c 13 00 00       	call   8019f3 <sys_cputs>
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
  80071c:	e8 14 13 00 00       	call   801a35 <sys_lock_cons>
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
  80073c:	e8 0e 13 00 00       	call   801a4f <sys_unlock_cons>
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
  800786:	e8 01 33 00 00       	call   803a8c <__udivdi3>
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
  8007d6:	e8 c1 33 00 00       	call   803b9c <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 34 43 80 00       	add    $0x804334,%eax
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
  800931:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
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
  800a12:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 45 43 80 00       	push   $0x804345
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
  800a37:	68 4e 43 80 00       	push   $0x80434e
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
  800a64:	be 51 43 80 00       	mov    $0x804351,%esi
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
  80146f:	68 c8 44 80 00       	push   $0x8044c8
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 ea 44 80 00       	push   $0x8044ea
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
  80148f:	e8 0a 0b 00 00       	call   801f9e <sys_sbrk>
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
  80150a:	e8 13 09 00 00       	call   801e22 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 53 0e 00 00       	call   802371 <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 25 09 00 00       	call   801e53 <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 ec 12 00 00       	call   80282d <alloc_block_BF>
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
  80158c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8015d9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801692:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a2:	e8 2e 09 00 00       	call   801fd5 <sys_allocate_user_mem>
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
  8016ea:	e8 02 09 00 00       	call   801ff1 <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 35 1b 00 00       	call   803235 <free_block>
  801700:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  80174f:	eb 2f                	jmp    801780 <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80177d:	ff 45 f4             	incl   -0xc(%ebp)
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801786:	72 c9                	jb     801751 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	ff 75 ec             	pushl  -0x14(%ebp)
  801791:	50                   	push   %eax
  801792:	e8 22 08 00 00       	call   801fb9 <sys_free_user_mem>
  801797:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80179a:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80179b:	eb 17                	jmp    8017b4 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 f8 44 80 00       	push   $0x8044f8
  8017a5:	68 85 00 00 00       	push   $0x85
  8017aa:	68 22 45 80 00       	push   $0x804522
  8017af:	e8 78 ec ff ff       	call   80042c <_panic>
	}
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 28             	sub    $0x28,%esp
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8017c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c6:	75 0a                	jne    8017d2 <smalloc+0x1c>
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	e9 9a 00 00 00       	jmp    80186c <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e5:	39 d0                	cmp    %edx,%eax
  8017e7:	73 02                	jae    8017eb <smalloc+0x35>
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	50                   	push   %eax
  8017ef:	e8 a5 fc ff ff       	call   801499 <malloc>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017fe:	75 07                	jne    801807 <smalloc+0x51>
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 65                	jmp    80186c <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801807:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80180b:	ff 75 ec             	pushl  -0x14(%ebp)
  80180e:	50                   	push   %eax
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	e8 a6 03 00 00       	call   801bc0 <sys_createSharedObject>
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801820:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801824:	74 06                	je     80182c <smalloc+0x76>
  801826:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80182a:	75 07                	jne    801833 <smalloc+0x7d>
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	eb 39                	jmp    80186c <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 ec             	pushl  -0x14(%ebp)
  801839:	68 2e 45 80 00       	push   $0x80452e
  80183e:	e8 a6 ee ff ff       	call   8006e9 <cprintf>
  801843:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801849:	a1 20 50 80 00       	mov    0x805020,%eax
  80184e:	8b 40 78             	mov    0x78(%eax),%eax
  801851:	29 c2                	sub    %eax,%edx
  801853:	89 d0                	mov    %edx,%eax
  801855:	2d 00 10 00 00       	sub    $0x1000,%eax
  80185a:	c1 e8 0c             	shr    $0xc,%eax
  80185d:	89 c2                	mov    %eax,%edx
  80185f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801862:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801869:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 68 03 00 00       	call   801bea <sys_getSizeOfSharedObject>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801888:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80188c:	75 07                	jne    801895 <sget+0x27>
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	eb 7f                	jmp    801914 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801898:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80189b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	39 d0                	cmp    %edx,%eax
  8018aa:	7d 02                	jge    8018ae <sget+0x40>
  8018ac:	89 d0                	mov    %edx,%eax
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	50                   	push   %eax
  8018b2:	e8 e2 fb ff ff       	call   801499 <malloc>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018c1:	75 07                	jne    8018ca <sget+0x5c>
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	eb 4a                	jmp    801914 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	e8 2c 03 00 00       	call   801c07 <sys_getSharedObject>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8018e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8018e9:	8b 40 78             	mov    0x78(%eax),%eax
  8018ec:	29 c2                	sub    %eax,%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018f5:	c1 e8 0c             	shr    $0xc,%eax
  8018f8:	89 c2                	mov    %eax,%edx
  8018fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018fd:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801904:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801908:	75 07                	jne    801911 <sget+0xa3>
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	eb 03                	jmp    801914 <sget+0xa6>
	return ptr;
  801911:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80191c:	8b 55 08             	mov    0x8(%ebp),%edx
  80191f:	a1 20 50 80 00       	mov    0x805020,%eax
  801924:	8b 40 78             	mov    0x78(%eax),%eax
  801927:	29 c2                	sub    %eax,%edx
  801929:	89 d0                	mov    %edx,%eax
  80192b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801930:	c1 e8 0c             	shr    $0xc,%eax
  801933:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80193a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	ff 75 f4             	pushl  -0xc(%ebp)
  801946:	e8 db 02 00 00       	call   801c26 <sys_freeSharedObject>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	68 40 45 80 00       	push   $0x804540
  801962:	68 de 00 00 00       	push   $0xde
  801967:	68 22 45 80 00       	push   $0x804522
  80196c:	e8 bb ea ff ff       	call   80042c <_panic>

00801971 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	68 66 45 80 00       	push   $0x804566
  80197f:	68 ea 00 00 00       	push   $0xea
  801984:	68 22 45 80 00       	push   $0x804522
  801989:	e8 9e ea ff ff       	call   80042c <_panic>

0080198e <shrink>:

}
void shrink(uint32 newSize)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	68 66 45 80 00       	push   $0x804566
  80199c:	68 ef 00 00 00       	push   $0xef
  8019a1:	68 22 45 80 00       	push   $0x804522
  8019a6:	e8 81 ea ff ff       	call   80042c <_panic>

008019ab <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 66 45 80 00       	push   $0x804566
  8019b9:	68 f4 00 00 00       	push   $0xf4
  8019be:	68 22 45 80 00       	push   $0x804522
  8019c3:	e8 64 ea ff ff       	call   80042c <_panic>

008019c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	57                   	push   %edi
  8019cc:	56                   	push   %esi
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019e3:	cd 30                	int    $0x30
  8019e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	5b                   	pop    %ebx
  8019ef:	5e                   	pop    %esi
  8019f0:	5f                   	pop    %edi
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	52                   	push   %edx
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	50                   	push   %eax
  801a0f:	6a 00                	push   $0x0
  801a11:	e8 b2 ff ff ff       	call   8019c8 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	90                   	nop
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 02                	push   $0x2
  801a2b:	e8 98 ff ff ff       	call   8019c8 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 03                	push   $0x3
  801a44:	e8 7f ff ff ff       	call   8019c8 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 04                	push   $0x4
  801a5e:	e8 65 ff ff ff       	call   8019c8 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 08                	push   $0x8
  801a7c:	e8 47 ff ff ff       	call   8019c8 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	56                   	push   %esi
  801a8a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a8b:	8b 75 18             	mov    0x18(%ebp),%esi
  801a8e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
  801a9c:	51                   	push   %ecx
  801a9d:	52                   	push   %edx
  801a9e:	50                   	push   %eax
  801a9f:	6a 09                	push   $0x9
  801aa1:	e8 22 ff ff ff       	call   8019c8 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 0a                	push   $0xa
  801ac3:	e8 00 ff ff ff       	call   8019c8 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	6a 0b                	push   $0xb
  801ade:	e8 e5 fe ff ff       	call   8019c8 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 0c                	push   $0xc
  801af7:	e8 cc fe ff ff       	call   8019c8 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 0d                	push   $0xd
  801b10:	e8 b3 fe ff ff       	call   8019c8 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 0e                	push   $0xe
  801b29:	e8 9a fe ff ff       	call   8019c8 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 0f                	push   $0xf
  801b42:	e8 81 fe ff ff       	call   8019c8 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 10                	push   $0x10
  801b5c:	e8 67 fe ff ff       	call   8019c8 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 11                	push   $0x11
  801b75:	e8 4e fe ff ff       	call   8019c8 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	50                   	push   %eax
  801b99:	6a 01                	push   $0x1
  801b9b:	e8 28 fe ff ff       	call   8019c8 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 14                	push   $0x14
  801bb5:	e8 0e fe ff ff       	call   8019c8 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	90                   	nop
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bcc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	51                   	push   %ecx
  801bd9:	52                   	push   %edx
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	50                   	push   %eax
  801bde:	6a 15                	push   $0x15
  801be0:	e8 e3 fd ff ff       	call   8019c8 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 16                	push   $0x16
  801bfd:	e8 c6 fd ff ff       	call   8019c8 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	51                   	push   %ecx
  801c18:	52                   	push   %edx
  801c19:	50                   	push   %eax
  801c1a:	6a 17                	push   $0x17
  801c1c:	e8 a7 fd ff ff       	call   8019c8 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 18                	push   $0x18
  801c39:	e8 8a fd ff ff       	call   8019c8 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	ff 75 14             	pushl  0x14(%ebp)
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	50                   	push   %eax
  801c55:	6a 19                	push   $0x19
  801c57:	e8 6c fd ff ff       	call   8019c8 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	50                   	push   %eax
  801c70:	6a 1a                	push   $0x1a
  801c72:	e8 51 fd ff ff       	call   8019c8 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	90                   	nop
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	50                   	push   %eax
  801c8c:	6a 1b                	push   $0x1b
  801c8e:	e8 35 fd ff ff       	call   8019c8 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 05                	push   $0x5
  801ca7:	e8 1c fd ff ff       	call   8019c8 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 06                	push   $0x6
  801cc0:	e8 03 fd ff ff       	call   8019c8 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 07                	push   $0x7
  801cd9:	e8 ea fc ff ff       	call   8019c8 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 1c                	push   $0x1c
  801cf2:	e8 d1 fc ff ff       	call   8019c8 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d06:	8d 50 04             	lea    0x4(%eax),%edx
  801d09:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 1d                	push   $0x1d
  801d16:	e8 ad fc ff ff       	call   8019c8 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d27:	89 01                	mov    %eax,(%ecx)
  801d29:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	c9                   	leave  
  801d30:	c2 04 00             	ret    $0x4

00801d33 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 10             	pushl  0x10(%ebp)
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 13                	push   $0x13
  801d45:	e8 7e fc ff ff       	call   8019c8 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 1e                	push   $0x1e
  801d5f:	e8 64 fc ff ff       	call   8019c8 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d75:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	50                   	push   %eax
  801d82:	6a 1f                	push   $0x1f
  801d84:	e8 3f fc ff ff       	call   8019c8 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <rsttst>:
void rsttst()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 21                	push   $0x21
  801d9e:	e8 25 fc ff ff       	call   8019c8 <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
	return ;
  801da6:	90                   	nop
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	8b 45 14             	mov    0x14(%ebp),%eax
  801db2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db5:	8b 55 18             	mov    0x18(%ebp),%edx
  801db8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbc:	52                   	push   %edx
  801dbd:	50                   	push   %eax
  801dbe:	ff 75 10             	pushl  0x10(%ebp)
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	6a 20                	push   $0x20
  801dc9:	e8 fa fb ff ff       	call   8019c8 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd1:	90                   	nop
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <chktst>:
void chktst(uint32 n)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	6a 22                	push   $0x22
  801de4:	e8 df fb ff ff       	call   8019c8 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <inctst>:

void inctst()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 23                	push   $0x23
  801dfe:	e8 c5 fb ff ff       	call   8019c8 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return ;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <gettst>:
uint32 gettst()
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 24                	push   $0x24
  801e18:	e8 ab fb ff ff       	call   8019c8 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 25                	push   $0x25
  801e34:	e8 8f fb ff ff       	call   8019c8 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
  801e3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e3f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e43:	75 07                	jne    801e4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e45:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4a:	eb 05                	jmp    801e51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 25                	push   $0x25
  801e65:	e8 5e fb ff ff       	call   8019c8 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
  801e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e70:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e74:	75 07                	jne    801e7d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	eb 05                	jmp    801e82 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 25                	push   $0x25
  801e96:	e8 2d fb ff ff       	call   8019c8 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
  801e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ea1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea5:	75 07                	jne    801eae <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eac:	eb 05                	jmp    801eb3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 25                	push   $0x25
  801ec7:	e8 fc fa ff ff       	call   8019c8 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed6:	75 07                	jne    801edf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed8:	b8 01 00 00 00       	mov    $0x1,%eax
  801edd:	eb 05                	jmp    801ee4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	6a 26                	push   $0x26
  801ef6:	e8 cd fa ff ff       	call   8019c8 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
	return ;
  801efe:	90                   	nop
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	53                   	push   %ebx
  801f14:	51                   	push   %ecx
  801f15:	52                   	push   %edx
  801f16:	50                   	push   %eax
  801f17:	6a 27                	push   $0x27
  801f19:	e8 aa fa ff ff       	call   8019c8 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 28                	push   $0x28
  801f39:	e8 8a fa ff ff       	call   8019c8 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	51                   	push   %ecx
  801f52:	ff 75 10             	pushl  0x10(%ebp)
  801f55:	52                   	push   %edx
  801f56:	50                   	push   %eax
  801f57:	6a 29                	push   $0x29
  801f59:	e8 6a fa ff ff       	call   8019c8 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	ff 75 10             	pushl  0x10(%ebp)
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	6a 12                	push   $0x12
  801f75:	e8 4e fa ff ff       	call   8019c8 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	52                   	push   %edx
  801f90:	50                   	push   %eax
  801f91:	6a 2a                	push   $0x2a
  801f93:	e8 30 fa ff ff       	call   8019c8 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
	return;
  801f9b:	90                   	nop
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	50                   	push   %eax
  801fad:	6a 2b                	push   $0x2b
  801faf:	e8 14 fa ff ff       	call   8019c8 <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	6a 2c                	push   $0x2c
  801fca:	e8 f9 f9 ff ff       	call   8019c8 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
	return;
  801fd2:	90                   	nop
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	6a 2d                	push   $0x2d
  801fe6:	e8 dd f9 ff ff       	call   8019c8 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
	return;
  801fee:	90                   	nop
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	83 e8 04             	sub    $0x4,%eax
  801ffd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802000:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	83 e8 04             	sub    $0x4,%eax
  802016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201c:	8b 00                	mov    (%eax),%eax
  80201e:	83 e0 01             	and    $0x1,%eax
  802021:	85 c0                	test   %eax,%eax
  802023:	0f 94 c0             	sete   %al
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80202e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802035:	8b 45 0c             	mov    0xc(%ebp),%eax
  802038:	83 f8 02             	cmp    $0x2,%eax
  80203b:	74 2b                	je     802068 <alloc_block+0x40>
  80203d:	83 f8 02             	cmp    $0x2,%eax
  802040:	7f 07                	jg     802049 <alloc_block+0x21>
  802042:	83 f8 01             	cmp    $0x1,%eax
  802045:	74 0e                	je     802055 <alloc_block+0x2d>
  802047:	eb 58                	jmp    8020a1 <alloc_block+0x79>
  802049:	83 f8 03             	cmp    $0x3,%eax
  80204c:	74 2d                	je     80207b <alloc_block+0x53>
  80204e:	83 f8 04             	cmp    $0x4,%eax
  802051:	74 3b                	je     80208e <alloc_block+0x66>
  802053:	eb 4c                	jmp    8020a1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802055:	83 ec 0c             	sub    $0xc,%esp
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	e8 11 03 00 00       	call   802371 <alloc_block_FF>
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802066:	eb 4a                	jmp    8020b2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	ff 75 08             	pushl  0x8(%ebp)
  80206e:	e8 fa 19 00 00       	call   803a6d <alloc_block_NF>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802079:	eb 37                	jmp    8020b2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	e8 a7 07 00 00       	call   80282d <alloc_block_BF>
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80208c:	eb 24                	jmp    8020b2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80208e:	83 ec 0c             	sub    $0xc,%esp
  802091:	ff 75 08             	pushl  0x8(%ebp)
  802094:	e8 b7 19 00 00       	call   803a50 <alloc_block_WF>
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80209f:	eb 11                	jmp    8020b2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 78 45 80 00       	push   $0x804578
  8020a9:	e8 3b e6 ff ff       	call   8006e9 <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp
		break;
  8020b1:	90                   	nop
	}
	return va;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	53                   	push   %ebx
  8020bb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	68 98 45 80 00       	push   $0x804598
  8020c6:	e8 1e e6 ff ff       	call   8006e9 <cprintf>
  8020cb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020ce:	83 ec 0c             	sub    $0xc,%esp
  8020d1:	68 c3 45 80 00       	push   $0x8045c3
  8020d6:	e8 0e e6 ff ff       	call   8006e9 <cprintf>
  8020db:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e4:	eb 37                	jmp    80211d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ec:	e8 19 ff ff ff       	call   80200a <is_free_block>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	0f be d8             	movsbl %al,%ebx
  8020f7:	83 ec 0c             	sub    $0xc,%esp
  8020fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fd:	e8 ef fe ff ff       	call   801ff1 <get_block_size>
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	53                   	push   %ebx
  802109:	50                   	push   %eax
  80210a:	68 db 45 80 00       	push   $0x8045db
  80210f:	e8 d5 e5 ff ff       	call   8006e9 <cprintf>
  802114:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802117:	8b 45 10             	mov    0x10(%ebp),%eax
  80211a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802121:	74 07                	je     80212a <print_blocks_list+0x73>
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 00                	mov    (%eax),%eax
  802128:	eb 05                	jmp    80212f <print_blocks_list+0x78>
  80212a:	b8 00 00 00 00       	mov    $0x0,%eax
  80212f:	89 45 10             	mov    %eax,0x10(%ebp)
  802132:	8b 45 10             	mov    0x10(%ebp),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	75 ad                	jne    8020e6 <print_blocks_list+0x2f>
  802139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213d:	75 a7                	jne    8020e6 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80213f:	83 ec 0c             	sub    $0xc,%esp
  802142:	68 98 45 80 00       	push   $0x804598
  802147:	e8 9d e5 ff ff       	call   8006e9 <cprintf>
  80214c:	83 c4 10             	add    $0x10,%esp

}
  80214f:	90                   	nop
  802150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80215b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215e:	83 e0 01             	and    $0x1,%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	74 03                	je     802168 <initialize_dynamic_allocator+0x13>
  802165:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802168:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80216c:	0f 84 c7 01 00 00    	je     802339 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802172:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802179:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80217c:	8b 55 08             	mov    0x8(%ebp),%edx
  80217f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802182:	01 d0                	add    %edx,%eax
  802184:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802189:	0f 87 ad 01 00 00    	ja     80233c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	0f 89 a5 01 00 00    	jns    80233f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80219a:	8b 55 08             	mov    0x8(%ebp),%edx
  80219d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a0:	01 d0                	add    %edx,%eax
  8021a2:	83 e8 04             	sub    $0x4,%eax
  8021a5:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b9:	e9 87 00 00 00       	jmp    802245 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8021be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c2:	75 14                	jne    8021d8 <initialize_dynamic_allocator+0x83>
  8021c4:	83 ec 04             	sub    $0x4,%esp
  8021c7:	68 f3 45 80 00       	push   $0x8045f3
  8021cc:	6a 79                	push   $0x79
  8021ce:	68 11 46 80 00       	push   $0x804611
  8021d3:	e8 54 e2 ff ff       	call   80042c <_panic>
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	74 10                	je     8021f1 <initialize_dynamic_allocator+0x9c>
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 00                	mov    (%eax),%eax
  8021e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e9:	8b 52 04             	mov    0x4(%edx),%edx
  8021ec:	89 50 04             	mov    %edx,0x4(%eax)
  8021ef:	eb 0b                	jmp    8021fc <initialize_dynamic_allocator+0xa7>
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 40 04             	mov    0x4(%eax),%eax
  8021f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	8b 40 04             	mov    0x4(%eax),%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	74 0f                	je     802215 <initialize_dynamic_allocator+0xc0>
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 04             	mov    0x4(%eax),%eax
  80220c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220f:	8b 12                	mov    (%edx),%edx
  802211:	89 10                	mov    %edx,(%eax)
  802213:	eb 0a                	jmp    80221f <initialize_dynamic_allocator+0xca>
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 00                	mov    (%eax),%eax
  80221a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802232:	a1 38 50 80 00       	mov    0x805038,%eax
  802237:	48                   	dec    %eax
  802238:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80223d:	a1 34 50 80 00       	mov    0x805034,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802249:	74 07                	je     802252 <initialize_dynamic_allocator+0xfd>
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	eb 05                	jmp    802257 <initialize_dynamic_allocator+0x102>
  802252:	b8 00 00 00 00       	mov    $0x0,%eax
  802257:	a3 34 50 80 00       	mov    %eax,0x805034
  80225c:	a1 34 50 80 00       	mov    0x805034,%eax
  802261:	85 c0                	test   %eax,%eax
  802263:	0f 85 55 ff ff ff    	jne    8021be <initialize_dynamic_allocator+0x69>
  802269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226d:	0f 85 4b ff ff ff    	jne    8021be <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802282:	a1 44 50 80 00       	mov    0x805044,%eax
  802287:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80228c:	a1 40 50 80 00       	mov    0x805040,%eax
  802291:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	83 c0 08             	add    $0x8,%eax
  80229d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	83 c0 04             	add    $0x4,%eax
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	83 ea 08             	sub    $0x8,%edx
  8022ac:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	83 e8 08             	sub    $0x8,%eax
  8022b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bc:	83 ea 08             	sub    $0x8,%edx
  8022bf:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022d8:	75 17                	jne    8022f1 <initialize_dynamic_allocator+0x19c>
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 2c 46 80 00       	push   $0x80462c
  8022e2:	68 90 00 00 00       	push   $0x90
  8022e7:	68 11 46 80 00       	push   $0x804611
  8022ec:	e8 3b e1 ff ff       	call   80042c <_panic>
  8022f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 0d                	je     802312 <initialize_dynamic_allocator+0x1bd>
  802305:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80230a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	eb 08                	jmp    80231a <initialize_dynamic_allocator+0x1c5>
  802312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802315:	a3 30 50 80 00       	mov    %eax,0x805030
  80231a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232c:	a1 38 50 80 00       	mov    0x805038,%eax
  802331:	40                   	inc    %eax
  802332:	a3 38 50 80 00       	mov    %eax,0x805038
  802337:	eb 07                	jmp    802340 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802339:	90                   	nop
  80233a:	eb 04                	jmp    802340 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80233c:	90                   	nop
  80233d:	eb 01                	jmp    802340 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80233f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802345:	8b 45 10             	mov    0x10(%ebp),%eax
  802348:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	83 e8 04             	sub    $0x4,%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	83 e0 fe             	and    $0xfffffffe,%eax
  802361:	8d 50 f8             	lea    -0x8(%eax),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	01 c2                	add    %eax,%edx
  802369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236c:	89 02                	mov    %eax,(%edx)
}
  80236e:	90                   	nop
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	83 e0 01             	and    $0x1,%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	74 03                	je     802384 <alloc_block_FF+0x13>
  802381:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802384:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802388:	77 07                	ja     802391 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80238a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802391:	a1 24 50 80 00       	mov    0x805024,%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	75 73                	jne    80240d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	83 c0 10             	add    $0x10,%eax
  8023a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b0:	01 d0                	add    %edx,%eax
  8023b2:	48                   	dec    %eax
  8023b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023be:	f7 75 ec             	divl   -0x14(%ebp)
  8023c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c4:	29 d0                	sub    %edx,%eax
  8023c6:	c1 e8 0c             	shr    $0xc,%eax
  8023c9:	83 ec 0c             	sub    $0xc,%esp
  8023cc:	50                   	push   %eax
  8023cd:	e8 b1 f0 ff ff       	call   801483 <sbrk>
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 a1 f0 ff ff       	call   801483 <sbrk>
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023eb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023ee:	83 ec 08             	sub    $0x8,%esp
  8023f1:	50                   	push   %eax
  8023f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023f5:	e8 5b fd ff ff       	call   802155 <initialize_dynamic_allocator>
  8023fa:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	68 4f 46 80 00       	push   $0x80464f
  802405:	e8 df e2 ff ff       	call   8006e9 <cprintf>
  80240a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80240d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802411:	75 0a                	jne    80241d <alloc_block_FF+0xac>
	        return NULL;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	e9 0e 04 00 00       	jmp    80282b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80241d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802424:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242c:	e9 f3 02 00 00       	jmp    802724 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802437:	83 ec 0c             	sub    $0xc,%esp
  80243a:	ff 75 bc             	pushl  -0x44(%ebp)
  80243d:	e8 af fb ff ff       	call   801ff1 <get_block_size>
  802442:	83 c4 10             	add    $0x10,%esp
  802445:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	83 c0 08             	add    $0x8,%eax
  80244e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802451:	0f 87 c5 02 00 00    	ja     80271c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	83 c0 18             	add    $0x18,%eax
  80245d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802460:	0f 87 19 02 00 00    	ja     80267f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802466:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802469:	2b 45 08             	sub    0x8(%ebp),%eax
  80246c:	83 e8 08             	sub    $0x8,%eax
  80246f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	8d 50 08             	lea    0x8(%eax),%edx
  802478:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80247b:	01 d0                	add    %edx,%eax
  80247d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	83 c0 08             	add    $0x8,%eax
  802486:	83 ec 04             	sub    $0x4,%esp
  802489:	6a 01                	push   $0x1
  80248b:	50                   	push   %eax
  80248c:	ff 75 bc             	pushl  -0x44(%ebp)
  80248f:	e8 ae fe ff ff       	call   802342 <set_block_data>
  802494:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	75 68                	jne    802509 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024a1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024a5:	75 17                	jne    8024be <alloc_block_FF+0x14d>
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	68 2c 46 80 00       	push   $0x80462c
  8024af:	68 d7 00 00 00       	push   $0xd7
  8024b4:	68 11 46 80 00       	push   $0x804611
  8024b9:	e8 6e df ff ff       	call   80042c <_panic>
  8024be:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0d                	je     8024df <alloc_block_FF+0x16e>
  8024d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024d7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024da:	89 50 04             	mov    %edx,0x4(%eax)
  8024dd:	eb 08                	jmp    8024e7 <alloc_block_FF+0x176>
  8024df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024fe:	40                   	inc    %eax
  8024ff:	a3 38 50 80 00       	mov    %eax,0x805038
  802504:	e9 dc 00 00 00       	jmp    8025e5 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	75 65                	jne    802577 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802512:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802516:	75 17                	jne    80252f <alloc_block_FF+0x1be>
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	68 60 46 80 00       	push   $0x804660
  802520:	68 db 00 00 00       	push   $0xdb
  802525:	68 11 46 80 00       	push   $0x804611
  80252a:	e8 fd de ff ff       	call   80042c <_panic>
  80252f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802535:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253e:	8b 40 04             	mov    0x4(%eax),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	74 0c                	je     802551 <alloc_block_FF+0x1e0>
  802545:	a1 30 50 80 00       	mov    0x805030,%eax
  80254a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80254d:	89 10                	mov    %edx,(%eax)
  80254f:	eb 08                	jmp    802559 <alloc_block_FF+0x1e8>
  802551:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802554:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802559:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255c:	a3 30 50 80 00       	mov    %eax,0x805030
  802561:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256a:	a1 38 50 80 00       	mov    0x805038,%eax
  80256f:	40                   	inc    %eax
  802570:	a3 38 50 80 00       	mov    %eax,0x805038
  802575:	eb 6e                	jmp    8025e5 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257b:	74 06                	je     802583 <alloc_block_FF+0x212>
  80257d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802581:	75 17                	jne    80259a <alloc_block_FF+0x229>
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	68 84 46 80 00       	push   $0x804684
  80258b:	68 df 00 00 00       	push   $0xdf
  802590:	68 11 46 80 00       	push   $0x804611
  802595:	e8 92 de ff ff       	call   80042c <_panic>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 10                	mov    (%eax),%edx
  80259f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a2:	89 10                	mov    %edx,(%eax)
  8025a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 0b                	je     8025b8 <alloc_block_FF+0x247>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025b5:	89 50 04             	mov    %edx,0x4(%eax)
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025be:	89 10                	mov    %edx,(%eax)
  8025c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c6:	89 50 04             	mov    %edx,0x4(%eax)
  8025c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	75 08                	jne    8025da <alloc_block_FF+0x269>
  8025d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025da:	a1 38 50 80 00       	mov    0x805038,%eax
  8025df:	40                   	inc    %eax
  8025e0:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e9:	75 17                	jne    802602 <alloc_block_FF+0x291>
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 f3 45 80 00       	push   $0x8045f3
  8025f3:	68 e1 00 00 00       	push   $0xe1
  8025f8:	68 11 46 80 00       	push   $0x804611
  8025fd:	e8 2a de ff ff       	call   80042c <_panic>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 10                	je     80261b <alloc_block_FF+0x2aa>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802613:	8b 52 04             	mov    0x4(%edx),%edx
  802616:	89 50 04             	mov    %edx,0x4(%eax)
  802619:	eb 0b                	jmp    802626 <alloc_block_FF+0x2b5>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	a3 30 50 80 00       	mov    %eax,0x805030
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 0f                	je     80263f <alloc_block_FF+0x2ce>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 04             	mov    0x4(%eax),%eax
  802636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802639:	8b 12                	mov    (%edx),%edx
  80263b:	89 10                	mov    %edx,(%eax)
  80263d:	eb 0a                	jmp    802649 <alloc_block_FF+0x2d8>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265c:	a1 38 50 80 00       	mov    0x805038,%eax
  802661:	48                   	dec    %eax
  802662:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	6a 00                	push   $0x0
  80266c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80266f:	ff 75 b0             	pushl  -0x50(%ebp)
  802672:	e8 cb fc ff ff       	call   802342 <set_block_data>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	e9 95 00 00 00       	jmp    802714 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	6a 01                	push   $0x1
  802684:	ff 75 b8             	pushl  -0x48(%ebp)
  802687:	ff 75 bc             	pushl  -0x44(%ebp)
  80268a:	e8 b3 fc ff ff       	call   802342 <set_block_data>
  80268f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	75 17                	jne    8026af <alloc_block_FF+0x33e>
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 f3 45 80 00       	push   $0x8045f3
  8026a0:	68 e8 00 00 00       	push   $0xe8
  8026a5:	68 11 46 80 00       	push   $0x804611
  8026aa:	e8 7d dd ff ff       	call   80042c <_panic>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	74 10                	je     8026c8 <alloc_block_FF+0x357>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c0:	8b 52 04             	mov    0x4(%edx),%edx
  8026c3:	89 50 04             	mov    %edx,0x4(%eax)
  8026c6:	eb 0b                	jmp    8026d3 <alloc_block_FF+0x362>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 0f                	je     8026ec <alloc_block_FF+0x37b>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 04             	mov    0x4(%eax),%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	8b 12                	mov    (%edx),%edx
  8026e8:	89 10                	mov    %edx,(%eax)
  8026ea:	eb 0a                	jmp    8026f6 <alloc_block_FF+0x385>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802709:	a1 38 50 80 00       	mov    0x805038,%eax
  80270e:	48                   	dec    %eax
  80270f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802714:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802717:	e9 0f 01 00 00       	jmp    80282b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80271c:	a1 34 50 80 00       	mov    0x805034,%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	74 07                	je     802731 <alloc_block_FF+0x3c0>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	eb 05                	jmp    802736 <alloc_block_FF+0x3c5>
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	a3 34 50 80 00       	mov    %eax,0x805034
  80273b:	a1 34 50 80 00       	mov    0x805034,%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 85 e9 fc ff ff    	jne    802431 <alloc_block_FF+0xc0>
  802748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274c:	0f 85 df fc ff ff    	jne    802431 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	83 c0 08             	add    $0x8,%eax
  802758:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80275b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802765:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802768:	01 d0                	add    %edx,%eax
  80276a:	48                   	dec    %eax
  80276b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80276e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802771:	ba 00 00 00 00       	mov    $0x0,%edx
  802776:	f7 75 d8             	divl   -0x28(%ebp)
  802779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80277c:	29 d0                	sub    %edx,%eax
  80277e:	c1 e8 0c             	shr    $0xc,%eax
  802781:	83 ec 0c             	sub    $0xc,%esp
  802784:	50                   	push   %eax
  802785:	e8 f9 ec ff ff       	call   801483 <sbrk>
  80278a:	83 c4 10             	add    $0x10,%esp
  80278d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802790:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802794:	75 0a                	jne    8027a0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	e9 8b 00 00 00       	jmp    80282b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027a0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ad:	01 d0                	add    %edx,%eax
  8027af:	48                   	dec    %eax
  8027b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bb:	f7 75 cc             	divl   -0x34(%ebp)
  8027be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027c1:	29 d0                	sub    %edx,%eax
  8027c3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027c9:	01 d0                	add    %edx,%eax
  8027cb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027d0:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027db:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f6:	f7 75 c4             	divl   -0x3c(%ebp)
  8027f9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027fc:	29 d0                	sub    %edx,%eax
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	6a 01                	push   $0x1
  802803:	50                   	push   %eax
  802804:	ff 75 d0             	pushl  -0x30(%ebp)
  802807:	e8 36 fb ff ff       	call   802342 <set_block_data>
  80280c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80280f:	83 ec 0c             	sub    $0xc,%esp
  802812:	ff 75 d0             	pushl  -0x30(%ebp)
  802815:	e8 1b 0a 00 00       	call   803235 <free_block>
  80281a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	ff 75 08             	pushl  0x8(%ebp)
  802823:	e8 49 fb ff ff       	call   802371 <alloc_block_FF>
  802828:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	83 e0 01             	and    $0x1,%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 03                	je     802840 <alloc_block_BF+0x13>
  80283d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802840:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802844:	77 07                	ja     80284d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802846:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80284d:	a1 24 50 80 00       	mov    0x805024,%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	75 73                	jne    8028c9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	83 c0 10             	add    $0x10,%eax
  80285c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80285f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802869:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286c:	01 d0                	add    %edx,%eax
  80286e:	48                   	dec    %eax
  80286f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802875:	ba 00 00 00 00       	mov    $0x0,%edx
  80287a:	f7 75 e0             	divl   -0x20(%ebp)
  80287d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802880:	29 d0                	sub    %edx,%eax
  802882:	c1 e8 0c             	shr    $0xc,%eax
  802885:	83 ec 0c             	sub    $0xc,%esp
  802888:	50                   	push   %eax
  802889:	e8 f5 eb ff ff       	call   801483 <sbrk>
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802894:	83 ec 0c             	sub    $0xc,%esp
  802897:	6a 00                	push   $0x0
  802899:	e8 e5 eb ff ff       	call   801483 <sbrk>
  80289e:	83 c4 10             	add    $0x10,%esp
  8028a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028a7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028aa:	83 ec 08             	sub    $0x8,%esp
  8028ad:	50                   	push   %eax
  8028ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8028b1:	e8 9f f8 ff ff       	call   802155 <initialize_dynamic_allocator>
  8028b6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028b9:	83 ec 0c             	sub    $0xc,%esp
  8028bc:	68 4f 46 80 00       	push   $0x80464f
  8028c1:	e8 23 de ff ff       	call   8006e9 <cprintf>
  8028c6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028d7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ed:	e9 1d 01 00 00       	jmp    802a0f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028f8:	83 ec 0c             	sub    $0xc,%esp
  8028fb:	ff 75 a8             	pushl  -0x58(%ebp)
  8028fe:	e8 ee f6 ff ff       	call   801ff1 <get_block_size>
  802903:	83 c4 10             	add    $0x10,%esp
  802906:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	83 c0 08             	add    $0x8,%eax
  80290f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802912:	0f 87 ef 00 00 00    	ja     802a07 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	83 c0 18             	add    $0x18,%eax
  80291e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802921:	77 1d                	ja     802940 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802929:	0f 86 d8 00 00 00    	jbe    802a07 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80292f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802932:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802935:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802938:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80293b:	e9 c7 00 00 00       	jmp    802a07 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	83 c0 08             	add    $0x8,%eax
  802946:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802949:	0f 85 9d 00 00 00    	jne    8029ec <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	6a 01                	push   $0x1
  802954:	ff 75 a4             	pushl  -0x5c(%ebp)
  802957:	ff 75 a8             	pushl  -0x58(%ebp)
  80295a:	e8 e3 f9 ff ff       	call   802342 <set_block_data>
  80295f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802962:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802966:	75 17                	jne    80297f <alloc_block_BF+0x152>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 f3 45 80 00       	push   $0x8045f3
  802970:	68 2c 01 00 00       	push   $0x12c
  802975:	68 11 46 80 00       	push   $0x804611
  80297a:	e8 ad da ff ff       	call   80042c <_panic>
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 10                	je     802998 <alloc_block_BF+0x16b>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802990:	8b 52 04             	mov    0x4(%edx),%edx
  802993:	89 50 04             	mov    %edx,0x4(%eax)
  802996:	eb 0b                	jmp    8029a3 <alloc_block_BF+0x176>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 04             	mov    0x4(%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	74 0f                	je     8029bc <alloc_block_BF+0x18f>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b6:	8b 12                	mov    (%edx),%edx
  8029b8:	89 10                	mov    %edx,(%eax)
  8029ba:	eb 0a                	jmp    8029c6 <alloc_block_BF+0x199>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8029de:	48                   	dec    %eax
  8029df:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029e7:	e9 24 04 00 00       	jmp    802e10 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ef:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029f2:	76 13                	jbe    802a07 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029f4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029fb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a01:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a04:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a07:	a1 34 50 80 00       	mov    0x805034,%eax
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a13:	74 07                	je     802a1c <alloc_block_BF+0x1ef>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	eb 05                	jmp    802a21 <alloc_block_BF+0x1f4>
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	a3 34 50 80 00       	mov    %eax,0x805034
  802a26:	a1 34 50 80 00       	mov    0x805034,%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 85 bf fe ff ff    	jne    8028f2 <alloc_block_BF+0xc5>
  802a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a37:	0f 85 b5 fe ff ff    	jne    8028f2 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a41:	0f 84 26 02 00 00    	je     802c6d <alloc_block_BF+0x440>
  802a47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a4b:	0f 85 1c 02 00 00    	jne    802c6d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a54:	2b 45 08             	sub    0x8(%ebp),%eax
  802a57:	83 e8 08             	sub    $0x8,%eax
  802a5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8d 50 08             	lea    0x8(%eax),%edx
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	83 c0 08             	add    $0x8,%eax
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	6a 01                	push   $0x1
  802a76:	50                   	push   %eax
  802a77:	ff 75 f0             	pushl  -0x10(%ebp)
  802a7a:	e8 c3 f8 ff ff       	call   802342 <set_block_data>
  802a7f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	75 68                	jne    802af4 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a8c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a90:	75 17                	jne    802aa9 <alloc_block_BF+0x27c>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 2c 46 80 00       	push   $0x80462c
  802a9a:	68 45 01 00 00       	push   $0x145
  802a9f:	68 11 46 80 00       	push   $0x804611
  802aa4:	e8 83 d9 ff ff       	call   80042c <_panic>
  802aa9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0d                	je     802aca <alloc_block_BF+0x29d>
  802abd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ac2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	eb 08                	jmp    802ad2 <alloc_block_BF+0x2a5>
  802aca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acd:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ada:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802add:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae9:	40                   	inc    %eax
  802aea:	a3 38 50 80 00       	mov    %eax,0x805038
  802aef:	e9 dc 00 00 00       	jmp    802bd0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	75 65                	jne    802b62 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802afd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b01:	75 17                	jne    802b1a <alloc_block_BF+0x2ed>
  802b03:	83 ec 04             	sub    $0x4,%esp
  802b06:	68 60 46 80 00       	push   $0x804660
  802b0b:	68 4a 01 00 00       	push   $0x14a
  802b10:	68 11 46 80 00       	push   $0x804611
  802b15:	e8 12 d9 ff ff       	call   80042c <_panic>
  802b1a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b23:	89 50 04             	mov    %edx,0x4(%eax)
  802b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0c                	je     802b3c <alloc_block_BF+0x30f>
  802b30:	a1 30 50 80 00       	mov    0x805030,%eax
  802b35:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b38:	89 10                	mov    %edx,(%eax)
  802b3a:	eb 08                	jmp    802b44 <alloc_block_BF+0x317>
  802b3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b47:	a3 30 50 80 00       	mov    %eax,0x805030
  802b4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b55:	a1 38 50 80 00       	mov    0x805038,%eax
  802b5a:	40                   	inc    %eax
  802b5b:	a3 38 50 80 00       	mov    %eax,0x805038
  802b60:	eb 6e                	jmp    802bd0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b66:	74 06                	je     802b6e <alloc_block_BF+0x341>
  802b68:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b6c:	75 17                	jne    802b85 <alloc_block_BF+0x358>
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 84 46 80 00       	push   $0x804684
  802b76:	68 4f 01 00 00       	push   $0x14f
  802b7b:	68 11 46 80 00       	push   $0x804611
  802b80:	e8 a7 d8 ff ff       	call   80042c <_panic>
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 10                	mov    (%eax),%edx
  802b8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0b                	je     802ba3 <alloc_block_BF+0x376>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb1:	89 50 04             	mov    %edx,0x4(%eax)
  802bb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	75 08                	jne    802bc5 <alloc_block_BF+0x398>
  802bbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bca:	40                   	inc    %eax
  802bcb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd4:	75 17                	jne    802bed <alloc_block_BF+0x3c0>
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	68 f3 45 80 00       	push   $0x8045f3
  802bde:	68 51 01 00 00       	push   $0x151
  802be3:	68 11 46 80 00       	push   $0x804611
  802be8:	e8 3f d8 ff ff       	call   80042c <_panic>
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	74 10                	je     802c06 <alloc_block_BF+0x3d9>
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfe:	8b 52 04             	mov    0x4(%edx),%edx
  802c01:	89 50 04             	mov    %edx,0x4(%eax)
  802c04:	eb 0b                	jmp    802c11 <alloc_block_BF+0x3e4>
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	85 c0                	test   %eax,%eax
  802c19:	74 0f                	je     802c2a <alloc_block_BF+0x3fd>
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c24:	8b 12                	mov    (%edx),%edx
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	eb 0a                	jmp    802c34 <alloc_block_BF+0x407>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c47:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4c:	48                   	dec    %eax
  802c4d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	6a 00                	push   $0x0
  802c57:	ff 75 d0             	pushl  -0x30(%ebp)
  802c5a:	ff 75 cc             	pushl  -0x34(%ebp)
  802c5d:	e8 e0 f6 ff ff       	call   802342 <set_block_data>
  802c62:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	e9 a3 01 00 00       	jmp    802e10 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c6d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c71:	0f 85 9d 00 00 00    	jne    802d14 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	6a 01                	push   $0x1
  802c7c:	ff 75 ec             	pushl  -0x14(%ebp)
  802c7f:	ff 75 f0             	pushl  -0x10(%ebp)
  802c82:	e8 bb f6 ff ff       	call   802342 <set_block_data>
  802c87:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8e:	75 17                	jne    802ca7 <alloc_block_BF+0x47a>
  802c90:	83 ec 04             	sub    $0x4,%esp
  802c93:	68 f3 45 80 00       	push   $0x8045f3
  802c98:	68 58 01 00 00       	push   $0x158
  802c9d:	68 11 46 80 00       	push   $0x804611
  802ca2:	e8 85 d7 ff ff       	call   80042c <_panic>
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 10                	je     802cc0 <alloc_block_BF+0x493>
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb8:	8b 52 04             	mov    0x4(%edx),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 0b                	jmp    802ccb <alloc_block_BF+0x49e>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	a3 30 50 80 00       	mov    %eax,0x805030
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 0f                	je     802ce4 <alloc_block_BF+0x4b7>
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cde:	8b 12                	mov    (%edx),%edx
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	eb 0a                	jmp    802cee <alloc_block_BF+0x4c1>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d01:	a1 38 50 80 00       	mov    0x805038,%eax
  802d06:	48                   	dec    %eax
  802d07:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	e9 fc 00 00 00       	jmp    802e10 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	83 c0 08             	add    $0x8,%eax
  802d1a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d1d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d24:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d2a:	01 d0                	add    %edx,%eax
  802d2c:	48                   	dec    %eax
  802d2d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d30:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d33:	ba 00 00 00 00       	mov    $0x0,%edx
  802d38:	f7 75 c4             	divl   -0x3c(%ebp)
  802d3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d3e:	29 d0                	sub    %edx,%eax
  802d40:	c1 e8 0c             	shr    $0xc,%eax
  802d43:	83 ec 0c             	sub    $0xc,%esp
  802d46:	50                   	push   %eax
  802d47:	e8 37 e7 ff ff       	call   801483 <sbrk>
  802d4c:	83 c4 10             	add    $0x10,%esp
  802d4f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d52:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d56:	75 0a                	jne    802d62 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5d:	e9 ae 00 00 00       	jmp    802e10 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d62:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d69:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d6f:	01 d0                	add    %edx,%eax
  802d71:	48                   	dec    %eax
  802d72:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d78:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7d:	f7 75 b8             	divl   -0x48(%ebp)
  802d80:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d83:	29 d0                	sub    %edx,%eax
  802d85:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d88:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d8b:	01 d0                	add    %edx,%eax
  802d8d:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d92:	a1 40 50 80 00       	mov    0x805040,%eax
  802d97:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	68 b8 46 80 00       	push   $0x8046b8
  802da5:	e8 3f d9 ff ff       	call   8006e9 <cprintf>
  802daa:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802dad:	83 ec 08             	sub    $0x8,%esp
  802db0:	ff 75 bc             	pushl  -0x44(%ebp)
  802db3:	68 bd 46 80 00       	push   $0x8046bd
  802db8:	e8 2c d9 ff ff       	call   8006e9 <cprintf>
  802dbd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802dc0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802dc7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	48                   	dec    %eax
  802dd0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802dd3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddb:	f7 75 b0             	divl   -0x50(%ebp)
  802dde:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802de1:	29 d0                	sub    %edx,%eax
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	6a 01                	push   $0x1
  802de8:	50                   	push   %eax
  802de9:	ff 75 bc             	pushl  -0x44(%ebp)
  802dec:	e8 51 f5 ff ff       	call   802342 <set_block_data>
  802df1:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802df4:	83 ec 0c             	sub    $0xc,%esp
  802df7:	ff 75 bc             	pushl  -0x44(%ebp)
  802dfa:	e8 36 04 00 00       	call   803235 <free_block>
  802dff:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	e8 20 fa ff ff       	call   80282d <alloc_block_BF>
  802e0d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    

00802e12 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
  802e15:	53                   	push   %ebx
  802e16:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2b:	74 1e                	je     802e4b <merging+0x39>
  802e2d:	ff 75 08             	pushl  0x8(%ebp)
  802e30:	e8 bc f1 ff ff       	call   801ff1 <get_block_size>
  802e35:	83 c4 04             	add    $0x4,%esp
  802e38:	89 c2                	mov    %eax,%edx
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	01 d0                	add    %edx,%eax
  802e3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e42:	75 07                	jne    802e4b <merging+0x39>
		prev_is_free = 1;
  802e44:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4f:	74 1e                	je     802e6f <merging+0x5d>
  802e51:	ff 75 10             	pushl  0x10(%ebp)
  802e54:	e8 98 f1 ff ff       	call   801ff1 <get_block_size>
  802e59:	83 c4 04             	add    $0x4,%esp
  802e5c:	89 c2                	mov    %eax,%edx
  802e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e61:	01 d0                	add    %edx,%eax
  802e63:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e66:	75 07                	jne    802e6f <merging+0x5d>
		next_is_free = 1;
  802e68:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e73:	0f 84 cc 00 00 00    	je     802f45 <merging+0x133>
  802e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7d:	0f 84 c2 00 00 00    	je     802f45 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e83:	ff 75 08             	pushl  0x8(%ebp)
  802e86:	e8 66 f1 ff ff       	call   801ff1 <get_block_size>
  802e8b:	83 c4 04             	add    $0x4,%esp
  802e8e:	89 c3                	mov    %eax,%ebx
  802e90:	ff 75 10             	pushl  0x10(%ebp)
  802e93:	e8 59 f1 ff ff       	call   801ff1 <get_block_size>
  802e98:	83 c4 04             	add    $0x4,%esp
  802e9b:	01 c3                	add    %eax,%ebx
  802e9d:	ff 75 0c             	pushl  0xc(%ebp)
  802ea0:	e8 4c f1 ff ff       	call   801ff1 <get_block_size>
  802ea5:	83 c4 04             	add    $0x4,%esp
  802ea8:	01 d8                	add    %ebx,%eax
  802eaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ead:	6a 00                	push   $0x0
  802eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  802eb2:	ff 75 08             	pushl  0x8(%ebp)
  802eb5:	e8 88 f4 ff ff       	call   802342 <set_block_data>
  802eba:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ebd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec1:	75 17                	jne    802eda <merging+0xc8>
  802ec3:	83 ec 04             	sub    $0x4,%esp
  802ec6:	68 f3 45 80 00       	push   $0x8045f3
  802ecb:	68 7d 01 00 00       	push   $0x17d
  802ed0:	68 11 46 80 00       	push   $0x804611
  802ed5:	e8 52 d5 ff ff       	call   80042c <_panic>
  802eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	74 10                	je     802ef3 <merging+0xe1>
  802ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eeb:	8b 52 04             	mov    0x4(%edx),%edx
  802eee:	89 50 04             	mov    %edx,0x4(%eax)
  802ef1:	eb 0b                	jmp    802efe <merging+0xec>
  802ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	a3 30 50 80 00       	mov    %eax,0x805030
  802efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f01:	8b 40 04             	mov    0x4(%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 0f                	je     802f17 <merging+0x105>
  802f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0b:	8b 40 04             	mov    0x4(%eax),%eax
  802f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f11:	8b 12                	mov    (%edx),%edx
  802f13:	89 10                	mov    %edx,(%eax)
  802f15:	eb 0a                	jmp    802f21 <merging+0x10f>
  802f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f34:	a1 38 50 80 00       	mov    0x805038,%eax
  802f39:	48                   	dec    %eax
  802f3a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f3f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f40:	e9 ea 02 00 00       	jmp    80322f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f49:	74 3b                	je     802f86 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f4b:	83 ec 0c             	sub    $0xc,%esp
  802f4e:	ff 75 08             	pushl  0x8(%ebp)
  802f51:	e8 9b f0 ff ff       	call   801ff1 <get_block_size>
  802f56:	83 c4 10             	add    $0x10,%esp
  802f59:	89 c3                	mov    %eax,%ebx
  802f5b:	83 ec 0c             	sub    $0xc,%esp
  802f5e:	ff 75 10             	pushl  0x10(%ebp)
  802f61:	e8 8b f0 ff ff       	call   801ff1 <get_block_size>
  802f66:	83 c4 10             	add    $0x10,%esp
  802f69:	01 d8                	add    %ebx,%eax
  802f6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f6e:	83 ec 04             	sub    $0x4,%esp
  802f71:	6a 00                	push   $0x0
  802f73:	ff 75 e8             	pushl  -0x18(%ebp)
  802f76:	ff 75 08             	pushl  0x8(%ebp)
  802f79:	e8 c4 f3 ff ff       	call   802342 <set_block_data>
  802f7e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f81:	e9 a9 02 00 00       	jmp    80322f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f8a:	0f 84 2d 01 00 00    	je     8030bd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f90:	83 ec 0c             	sub    $0xc,%esp
  802f93:	ff 75 10             	pushl  0x10(%ebp)
  802f96:	e8 56 f0 ff ff       	call   801ff1 <get_block_size>
  802f9b:	83 c4 10             	add    $0x10,%esp
  802f9e:	89 c3                	mov    %eax,%ebx
  802fa0:	83 ec 0c             	sub    $0xc,%esp
  802fa3:	ff 75 0c             	pushl  0xc(%ebp)
  802fa6:	e8 46 f0 ff ff       	call   801ff1 <get_block_size>
  802fab:	83 c4 10             	add    $0x10,%esp
  802fae:	01 d8                	add    %ebx,%eax
  802fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	6a 00                	push   $0x0
  802fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fbb:	ff 75 10             	pushl  0x10(%ebp)
  802fbe:	e8 7f f3 ff ff       	call   802342 <set_block_data>
  802fc3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802fcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd0:	74 06                	je     802fd8 <merging+0x1c6>
  802fd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fd6:	75 17                	jne    802fef <merging+0x1dd>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 cc 46 80 00       	push   $0x8046cc
  802fe0:	68 8d 01 00 00       	push   $0x18d
  802fe5:	68 11 46 80 00       	push   $0x804611
  802fea:	e8 3d d4 ff ff       	call   80042c <_panic>
  802fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff2:	8b 50 04             	mov    0x4(%eax),%edx
  802ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803001:	89 10                	mov    %edx,(%eax)
  803003:	8b 45 0c             	mov    0xc(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0d                	je     80301a <merging+0x208>
  80300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803016:	89 10                	mov    %edx,(%eax)
  803018:	eb 08                	jmp    803022 <merging+0x210>
  80301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803022:	8b 45 0c             	mov    0xc(%ebp),%eax
  803025:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803028:	89 50 04             	mov    %edx,0x4(%eax)
  80302b:	a1 38 50 80 00       	mov    0x805038,%eax
  803030:	40                   	inc    %eax
  803031:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803036:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80303a:	75 17                	jne    803053 <merging+0x241>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 f3 45 80 00       	push   $0x8045f3
  803044:	68 8e 01 00 00       	push   $0x18e
  803049:	68 11 46 80 00       	push   $0x804611
  80304e:	e8 d9 d3 ff ff       	call   80042c <_panic>
  803053:	8b 45 0c             	mov    0xc(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 10                	je     80306c <merging+0x25a>
  80305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	8b 55 0c             	mov    0xc(%ebp),%edx
  803064:	8b 52 04             	mov    0x4(%edx),%edx
  803067:	89 50 04             	mov    %edx,0x4(%eax)
  80306a:	eb 0b                	jmp    803077 <merging+0x265>
  80306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	a3 30 50 80 00       	mov    %eax,0x805030
  803077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	74 0f                	je     803090 <merging+0x27e>
  803081:	8b 45 0c             	mov    0xc(%ebp),%eax
  803084:	8b 40 04             	mov    0x4(%eax),%eax
  803087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308a:	8b 12                	mov    (%edx),%edx
  80308c:	89 10                	mov    %edx,(%eax)
  80308e:	eb 0a                	jmp    80309a <merging+0x288>
  803090:	8b 45 0c             	mov    0xc(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80309a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b2:	48                   	dec    %eax
  8030b3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030b8:	e9 72 01 00 00       	jmp    80322f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c7:	74 79                	je     803142 <merging+0x330>
  8030c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030cd:	74 73                	je     803142 <merging+0x330>
  8030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d3:	74 06                	je     8030db <merging+0x2c9>
  8030d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d9:	75 17                	jne    8030f2 <merging+0x2e0>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 84 46 80 00       	push   $0x804684
  8030e3:	68 94 01 00 00       	push   $0x194
  8030e8:	68 11 46 80 00       	push   $0x804611
  8030ed:	e8 3a d3 ff ff       	call   80042c <_panic>
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 10                	mov    (%eax),%edx
  8030f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0b                	je     803110 <merging+0x2fe>
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310d:	89 50 04             	mov    %edx,0x4(%eax)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803116:	89 10                	mov    %edx,(%eax)
  803118:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311b:	8b 55 08             	mov    0x8(%ebp),%edx
  80311e:	89 50 04             	mov    %edx,0x4(%eax)
  803121:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	75 08                	jne    803132 <merging+0x320>
  80312a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312d:	a3 30 50 80 00       	mov    %eax,0x805030
  803132:	a1 38 50 80 00       	mov    0x805038,%eax
  803137:	40                   	inc    %eax
  803138:	a3 38 50 80 00       	mov    %eax,0x805038
  80313d:	e9 ce 00 00 00       	jmp    803210 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803142:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803146:	74 65                	je     8031ad <merging+0x39b>
  803148:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80314c:	75 17                	jne    803165 <merging+0x353>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 60 46 80 00       	push   $0x804660
  803156:	68 95 01 00 00       	push   $0x195
  80315b:	68 11 46 80 00       	push   $0x804611
  803160:	e8 c7 d2 ff ff       	call   80042c <_panic>
  803165:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80316b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0c                	je     803187 <merging+0x375>
  80317b:	a1 30 50 80 00       	mov    0x805030,%eax
  803180:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803183:	89 10                	mov    %edx,(%eax)
  803185:	eb 08                	jmp    80318f <merging+0x37d>
  803187:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80318f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803192:	a3 30 50 80 00       	mov    %eax,0x805030
  803197:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8031a5:	40                   	inc    %eax
  8031a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ab:	eb 63                	jmp    803210 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b1:	75 17                	jne    8031ca <merging+0x3b8>
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	68 2c 46 80 00       	push   $0x80462c
  8031bb:	68 98 01 00 00       	push   $0x198
  8031c0:	68 11 46 80 00       	push   $0x804611
  8031c5:	e8 62 d2 ff ff       	call   80042c <_panic>
  8031ca:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d3:	89 10                	mov    %edx,(%eax)
  8031d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 0d                	je     8031eb <merging+0x3d9>
  8031de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	eb 08                	jmp    8031f3 <merging+0x3e1>
  8031eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803205:	a1 38 50 80 00       	mov    0x805038,%eax
  80320a:	40                   	inc    %eax
  80320b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803210:	83 ec 0c             	sub    $0xc,%esp
  803213:	ff 75 10             	pushl  0x10(%ebp)
  803216:	e8 d6 ed ff ff       	call   801ff1 <get_block_size>
  80321b:	83 c4 10             	add    $0x10,%esp
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	6a 00                	push   $0x0
  803223:	50                   	push   %eax
  803224:	ff 75 10             	pushl  0x10(%ebp)
  803227:	e8 16 f1 ff ff       	call   802342 <set_block_data>
  80322c:	83 c4 10             	add    $0x10,%esp
	}
}
  80322f:	90                   	nop
  803230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
  803238:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80323b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803240:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803243:	a1 30 50 80 00       	mov    0x805030,%eax
  803248:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324b:	73 1b                	jae    803268 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80324d:	a1 30 50 80 00       	mov    0x805030,%eax
  803252:	83 ec 04             	sub    $0x4,%esp
  803255:	ff 75 08             	pushl  0x8(%ebp)
  803258:	6a 00                	push   $0x0
  80325a:	50                   	push   %eax
  80325b:	e8 b2 fb ff ff       	call   802e12 <merging>
  803260:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803263:	e9 8b 00 00 00       	jmp    8032f3 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803268:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80326d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803270:	76 18                	jbe    80328a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803272:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803277:	83 ec 04             	sub    $0x4,%esp
  80327a:	ff 75 08             	pushl  0x8(%ebp)
  80327d:	50                   	push   %eax
  80327e:	6a 00                	push   $0x0
  803280:	e8 8d fb ff ff       	call   802e12 <merging>
  803285:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803288:	eb 69                	jmp    8032f3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80328a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80328f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803292:	eb 39                	jmp    8032cd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329a:	73 29                	jae    8032c5 <free_block+0x90>
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a4:	76 1f                	jbe    8032c5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ba:	e8 53 fb ff ff       	call   802e12 <merging>
  8032bf:	83 c4 10             	add    $0x10,%esp
			break;
  8032c2:	90                   	nop
		}
	}
}
  8032c3:	eb 2e                	jmp    8032f3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8032ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d1:	74 07                	je     8032da <free_block+0xa5>
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	eb 05                	jmp    8032df <free_block+0xaa>
  8032da:	b8 00 00 00 00       	mov    $0x0,%eax
  8032df:	a3 34 50 80 00       	mov    %eax,0x805034
  8032e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	75 a7                	jne    803294 <free_block+0x5f>
  8032ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f1:	75 a1                	jne    803294 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032f3:	90                   	nop
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
  8032f9:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032fc:	ff 75 08             	pushl  0x8(%ebp)
  8032ff:	e8 ed ec ff ff       	call   801ff1 <get_block_size>
  803304:	83 c4 04             	add    $0x4,%esp
  803307:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80330a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803311:	eb 17                	jmp    80332a <copy_data+0x34>
  803313:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803316:	8b 45 0c             	mov    0xc(%ebp),%eax
  803319:	01 c2                	add    %eax,%edx
  80331b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	01 c8                	add    %ecx,%eax
  803323:	8a 00                	mov    (%eax),%al
  803325:	88 02                	mov    %al,(%edx)
  803327:	ff 45 fc             	incl   -0x4(%ebp)
  80332a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80332d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803330:	72 e1                	jb     803313 <copy_data+0x1d>
}
  803332:	90                   	nop
  803333:	c9                   	leave  
  803334:	c3                   	ret    

00803335 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803335:	55                   	push   %ebp
  803336:	89 e5                	mov    %esp,%ebp
  803338:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80333b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333f:	75 23                	jne    803364 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803341:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803345:	74 13                	je     80335a <realloc_block_FF+0x25>
  803347:	83 ec 0c             	sub    $0xc,%esp
  80334a:	ff 75 0c             	pushl  0xc(%ebp)
  80334d:	e8 1f f0 ff ff       	call   802371 <alloc_block_FF>
  803352:	83 c4 10             	add    $0x10,%esp
  803355:	e9 f4 06 00 00       	jmp    803a4e <realloc_block_FF+0x719>
		return NULL;
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	e9 ea 06 00 00       	jmp    803a4e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803364:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803368:	75 18                	jne    803382 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 c0 fe ff ff       	call   803235 <free_block>
  803375:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	e9 cc 06 00 00       	jmp    803a4e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803382:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803386:	77 07                	ja     80338f <realloc_block_FF+0x5a>
  803388:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80338f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803392:	83 e0 01             	and    $0x1,%eax
  803395:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339b:	83 c0 08             	add    $0x8,%eax
  80339e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033a1:	83 ec 0c             	sub    $0xc,%esp
  8033a4:	ff 75 08             	pushl  0x8(%ebp)
  8033a7:	e8 45 ec ff ff       	call   801ff1 <get_block_size>
  8033ac:	83 c4 10             	add    $0x10,%esp
  8033af:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b5:	83 e8 08             	sub    $0x8,%eax
  8033b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	83 e8 04             	sub    $0x4,%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033d0:	83 ec 0c             	sub    $0xc,%esp
  8033d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033d6:	e8 16 ec ff ff       	call   801ff1 <get_block_size>
  8033db:	83 c4 10             	add    $0x10,%esp
  8033de:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e4:	83 e8 08             	sub    $0x8,%eax
  8033e7:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033f0:	75 08                	jne    8033fa <realloc_block_FF+0xc5>
	{
		 return va;
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	e9 54 06 00 00       	jmp    803a4e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803400:	0f 83 e5 03 00 00    	jae    8037eb <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803409:	2b 45 0c             	sub    0xc(%ebp),%eax
  80340c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80340f:	83 ec 0c             	sub    $0xc,%esp
  803412:	ff 75 e4             	pushl  -0x1c(%ebp)
  803415:	e8 f0 eb ff ff       	call   80200a <is_free_block>
  80341a:	83 c4 10             	add    $0x10,%esp
  80341d:	84 c0                	test   %al,%al
  80341f:	0f 84 3b 01 00 00    	je     803560 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803425:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803428:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80342b:	01 d0                	add    %edx,%eax
  80342d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	6a 01                	push   $0x1
  803435:	ff 75 f0             	pushl  -0x10(%ebp)
  803438:	ff 75 08             	pushl  0x8(%ebp)
  80343b:	e8 02 ef ff ff       	call   802342 <set_block_data>
  803440:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	83 e8 04             	sub    $0x4,%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	83 e0 fe             	and    $0xfffffffe,%eax
  80344e:	89 c2                	mov    %eax,%edx
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	01 d0                	add    %edx,%eax
  803455:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	6a 00                	push   $0x0
  80345d:	ff 75 cc             	pushl  -0x34(%ebp)
  803460:	ff 75 c8             	pushl  -0x38(%ebp)
  803463:	e8 da ee ff ff       	call   802342 <set_block_data>
  803468:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80346b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80346f:	74 06                	je     803477 <realloc_block_FF+0x142>
  803471:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803475:	75 17                	jne    80348e <realloc_block_FF+0x159>
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	68 84 46 80 00       	push   $0x804684
  80347f:	68 f6 01 00 00       	push   $0x1f6
  803484:	68 11 46 80 00       	push   $0x804611
  803489:	e8 9e cf ff ff       	call   80042c <_panic>
  80348e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803491:	8b 10                	mov    (%eax),%edx
  803493:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803496:	89 10                	mov    %edx,(%eax)
  803498:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80349b:	8b 00                	mov    (%eax),%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	74 0b                	je     8034ac <realloc_block_FF+0x177>
  8034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034a9:	89 50 04             	mov    %edx,0x4(%eax)
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ba:	89 50 04             	mov    %edx,0x4(%eax)
  8034bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	75 08                	jne    8034ce <realloc_block_FF+0x199>
  8034c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d3:	40                   	inc    %eax
  8034d4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034dd:	75 17                	jne    8034f6 <realloc_block_FF+0x1c1>
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	68 f3 45 80 00       	push   $0x8045f3
  8034e7:	68 f7 01 00 00       	push   $0x1f7
  8034ec:	68 11 46 80 00       	push   $0x804611
  8034f1:	e8 36 cf ff ff       	call   80042c <_panic>
  8034f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 10                	je     80350f <realloc_block_FF+0x1da>
  8034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803507:	8b 52 04             	mov    0x4(%edx),%edx
  80350a:	89 50 04             	mov    %edx,0x4(%eax)
  80350d:	eb 0b                	jmp    80351a <realloc_block_FF+0x1e5>
  80350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	a3 30 50 80 00       	mov    %eax,0x805030
  80351a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351d:	8b 40 04             	mov    0x4(%eax),%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	74 0f                	je     803533 <realloc_block_FF+0x1fe>
  803524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80352d:	8b 12                	mov    (%edx),%edx
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	eb 0a                	jmp    80353d <realloc_block_FF+0x208>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80353d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 38 50 80 00       	mov    0x805038,%eax
  803555:	48                   	dec    %eax
  803556:	a3 38 50 80 00       	mov    %eax,0x805038
  80355b:	e9 83 02 00 00       	jmp    8037e3 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803560:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803564:	0f 86 69 02 00 00    	jbe    8037d3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80356a:	83 ec 04             	sub    $0x4,%esp
  80356d:	6a 01                	push   $0x1
  80356f:	ff 75 f0             	pushl  -0x10(%ebp)
  803572:	ff 75 08             	pushl  0x8(%ebp)
  803575:	e8 c8 ed ff ff       	call   802342 <set_block_data>
  80357a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	83 e8 04             	sub    $0x4,%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	83 e0 fe             	and    $0xfffffffe,%eax
  803588:	89 c2                	mov    %eax,%edx
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	01 d0                	add    %edx,%eax
  80358f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803592:	a1 38 50 80 00       	mov    0x805038,%eax
  803597:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80359a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80359e:	75 68                	jne    803608 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a4:	75 17                	jne    8035bd <realloc_block_FF+0x288>
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	68 2c 46 80 00       	push   $0x80462c
  8035ae:	68 06 02 00 00       	push   $0x206
  8035b3:	68 11 46 80 00       	push   $0x804611
  8035b8:	e8 6f ce ff ff       	call   80042c <_panic>
  8035bd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 0d                	je     8035de <realloc_block_FF+0x2a9>
  8035d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d9:	89 50 04             	mov    %edx,0x4(%eax)
  8035dc:	eb 08                	jmp    8035e6 <realloc_block_FF+0x2b1>
  8035de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fd:	40                   	inc    %eax
  8035fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803603:	e9 b0 01 00 00       	jmp    8037b8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803608:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803610:	76 68                	jbe    80367a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803616:	75 17                	jne    80362f <realloc_block_FF+0x2fa>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 2c 46 80 00       	push   $0x80462c
  803620:	68 0b 02 00 00       	push   $0x20b
  803625:	68 11 46 80 00       	push   $0x804611
  80362a:	e8 fd cd ff ff       	call   80042c <_panic>
  80362f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	74 0d                	je     803650 <realloc_block_FF+0x31b>
  803643:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80364b:	89 50 04             	mov    %edx,0x4(%eax)
  80364e:	eb 08                	jmp    803658 <realloc_block_FF+0x323>
  803650:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803653:	a3 30 50 80 00       	mov    %eax,0x805030
  803658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366a:	a1 38 50 80 00       	mov    0x805038,%eax
  80366f:	40                   	inc    %eax
  803670:	a3 38 50 80 00       	mov    %eax,0x805038
  803675:	e9 3e 01 00 00       	jmp    8037b8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80367a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80367f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803682:	73 68                	jae    8036ec <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803684:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803688:	75 17                	jne    8036a1 <realloc_block_FF+0x36c>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 60 46 80 00       	push   $0x804660
  803692:	68 10 02 00 00       	push   $0x210
  803697:	68 11 46 80 00       	push   $0x804611
  80369c:	e8 8b cd ff ff       	call   80042c <_panic>
  8036a1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 0c                	je     8036c3 <realloc_block_FF+0x38e>
  8036b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036bf:	89 10                	mov    %edx,(%eax)
  8036c1:	eb 08                	jmp    8036cb <realloc_block_FF+0x396>
  8036c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8036d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e1:	40                   	inc    %eax
  8036e2:	a3 38 50 80 00       	mov    %eax,0x805038
  8036e7:	e9 cc 00 00 00       	jmp    8037b8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036fb:	e9 8a 00 00 00       	jmp    80378a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803706:	73 7a                	jae    803782 <realloc_block_FF+0x44d>
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 00                	mov    (%eax),%eax
  80370d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803710:	73 70                	jae    803782 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803716:	74 06                	je     80371e <realloc_block_FF+0x3e9>
  803718:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80371c:	75 17                	jne    803735 <realloc_block_FF+0x400>
  80371e:	83 ec 04             	sub    $0x4,%esp
  803721:	68 84 46 80 00       	push   $0x804684
  803726:	68 1a 02 00 00       	push   $0x21a
  80372b:	68 11 46 80 00       	push   $0x804611
  803730:	e8 f7 cc ff ff       	call   80042c <_panic>
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	8b 10                	mov    (%eax),%edx
  80373a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373d:	89 10                	mov    %edx,(%eax)
  80373f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	74 0b                	je     803753 <realloc_block_FF+0x41e>
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803750:	89 50 04             	mov    %edx,0x4(%eax)
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803759:	89 10                	mov    %edx,(%eax)
  80375b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803761:	89 50 04             	mov    %edx,0x4(%eax)
  803764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	75 08                	jne    803775 <realloc_block_FF+0x440>
  80376d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803770:	a3 30 50 80 00       	mov    %eax,0x805030
  803775:	a1 38 50 80 00       	mov    0x805038,%eax
  80377a:	40                   	inc    %eax
  80377b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803780:	eb 36                	jmp    8037b8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803782:	a1 34 50 80 00       	mov    0x805034,%eax
  803787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80378a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378e:	74 07                	je     803797 <realloc_block_FF+0x462>
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	eb 05                	jmp    80379c <realloc_block_FF+0x467>
  803797:	b8 00 00 00 00       	mov    $0x0,%eax
  80379c:	a3 34 50 80 00       	mov    %eax,0x805034
  8037a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	0f 85 52 ff ff ff    	jne    803700 <realloc_block_FF+0x3cb>
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	0f 85 48 ff ff ff    	jne    803700 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037b8:	83 ec 04             	sub    $0x4,%esp
  8037bb:	6a 00                	push   $0x0
  8037bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8037c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037c3:	e8 7a eb ff ff       	call   802342 <set_block_data>
  8037c8:	83 c4 10             	add    $0x10,%esp
				return va;
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	e9 7b 02 00 00       	jmp    803a4e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8037d3:	83 ec 0c             	sub    $0xc,%esp
  8037d6:	68 01 47 80 00       	push   $0x804701
  8037db:	e8 09 cf ff ff       	call   8006e9 <cprintf>
  8037e0:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	e9 63 02 00 00       	jmp    803a4e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ee:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037f1:	0f 86 4d 02 00 00    	jbe    803a44 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037f7:	83 ec 0c             	sub    $0xc,%esp
  8037fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037fd:	e8 08 e8 ff ff       	call   80200a <is_free_block>
  803802:	83 c4 10             	add    $0x10,%esp
  803805:	84 c0                	test   %al,%al
  803807:	0f 84 37 02 00 00    	je     803a44 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80380d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803810:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803813:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803816:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803819:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80381c:	76 38                	jbe    803856 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80381e:	83 ec 0c             	sub    $0xc,%esp
  803821:	ff 75 08             	pushl  0x8(%ebp)
  803824:	e8 0c fa ff ff       	call   803235 <free_block>
  803829:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80382c:	83 ec 0c             	sub    $0xc,%esp
  80382f:	ff 75 0c             	pushl  0xc(%ebp)
  803832:	e8 3a eb ff ff       	call   802371 <alloc_block_FF>
  803837:	83 c4 10             	add    $0x10,%esp
  80383a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80383d:	83 ec 08             	sub    $0x8,%esp
  803840:	ff 75 c0             	pushl  -0x40(%ebp)
  803843:	ff 75 08             	pushl  0x8(%ebp)
  803846:	e8 ab fa ff ff       	call   8032f6 <copy_data>
  80384b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80384e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803851:	e9 f8 01 00 00       	jmp    803a4e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803859:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80385c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80385f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803863:	0f 87 a0 00 00 00    	ja     803909 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803869:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80386d:	75 17                	jne    803886 <realloc_block_FF+0x551>
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	68 f3 45 80 00       	push   $0x8045f3
  803877:	68 38 02 00 00       	push   $0x238
  80387c:	68 11 46 80 00       	push   $0x804611
  803881:	e8 a6 cb ff ff       	call   80042c <_panic>
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	8b 00                	mov    (%eax),%eax
  80388b:	85 c0                	test   %eax,%eax
  80388d:	74 10                	je     80389f <realloc_block_FF+0x56a>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803897:	8b 52 04             	mov    0x4(%edx),%edx
  80389a:	89 50 04             	mov    %edx,0x4(%eax)
  80389d:	eb 0b                	jmp    8038aa <realloc_block_FF+0x575>
  80389f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a2:	8b 40 04             	mov    0x4(%eax),%eax
  8038a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	8b 40 04             	mov    0x4(%eax),%eax
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	74 0f                	je     8038c3 <realloc_block_FF+0x58e>
  8038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038bd:	8b 12                	mov    (%edx),%edx
  8038bf:	89 10                	mov    %edx,(%eax)
  8038c1:	eb 0a                	jmp    8038cd <realloc_block_FF+0x598>
  8038c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e5:	48                   	dec    %eax
  8038e6:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f1:	01 d0                	add    %edx,%eax
  8038f3:	83 ec 04             	sub    $0x4,%esp
  8038f6:	6a 01                	push   $0x1
  8038f8:	50                   	push   %eax
  8038f9:	ff 75 08             	pushl  0x8(%ebp)
  8038fc:	e8 41 ea ff ff       	call   802342 <set_block_data>
  803901:	83 c4 10             	add    $0x10,%esp
  803904:	e9 36 01 00 00       	jmp    803a3f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803909:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80390c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80390f:	01 d0                	add    %edx,%eax
  803911:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803914:	83 ec 04             	sub    $0x4,%esp
  803917:	6a 01                	push   $0x1
  803919:	ff 75 f0             	pushl  -0x10(%ebp)
  80391c:	ff 75 08             	pushl  0x8(%ebp)
  80391f:	e8 1e ea ff ff       	call   802342 <set_block_data>
  803924:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	83 e8 04             	sub    $0x4,%eax
  80392d:	8b 00                	mov    (%eax),%eax
  80392f:	83 e0 fe             	and    $0xfffffffe,%eax
  803932:	89 c2                	mov    %eax,%edx
  803934:	8b 45 08             	mov    0x8(%ebp),%eax
  803937:	01 d0                	add    %edx,%eax
  803939:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80393c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803940:	74 06                	je     803948 <realloc_block_FF+0x613>
  803942:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803946:	75 17                	jne    80395f <realloc_block_FF+0x62a>
  803948:	83 ec 04             	sub    $0x4,%esp
  80394b:	68 84 46 80 00       	push   $0x804684
  803950:	68 44 02 00 00       	push   $0x244
  803955:	68 11 46 80 00       	push   $0x804611
  80395a:	e8 cd ca ff ff       	call   80042c <_panic>
  80395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803962:	8b 10                	mov    (%eax),%edx
  803964:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803967:	89 10                	mov    %edx,(%eax)
  803969:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	85 c0                	test   %eax,%eax
  803970:	74 0b                	je     80397d <realloc_block_FF+0x648>
  803972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803975:	8b 00                	mov    (%eax),%eax
  803977:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80397a:	89 50 04             	mov    %edx,0x4(%eax)
  80397d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803980:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803983:	89 10                	mov    %edx,(%eax)
  803985:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80398b:	89 50 04             	mov    %edx,0x4(%eax)
  80398e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	75 08                	jne    80399f <realloc_block_FF+0x66a>
  803997:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80399a:	a3 30 50 80 00       	mov    %eax,0x805030
  80399f:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a4:	40                   	inc    %eax
  8039a5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039ae:	75 17                	jne    8039c7 <realloc_block_FF+0x692>
  8039b0:	83 ec 04             	sub    $0x4,%esp
  8039b3:	68 f3 45 80 00       	push   $0x8045f3
  8039b8:	68 45 02 00 00       	push   $0x245
  8039bd:	68 11 46 80 00       	push   $0x804611
  8039c2:	e8 65 ca ff ff       	call   80042c <_panic>
  8039c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	74 10                	je     8039e0 <realloc_block_FF+0x6ab>
  8039d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d8:	8b 52 04             	mov    0x4(%edx),%edx
  8039db:	89 50 04             	mov    %edx,0x4(%eax)
  8039de:	eb 0b                	jmp    8039eb <realloc_block_FF+0x6b6>
  8039e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e3:	8b 40 04             	mov    0x4(%eax),%eax
  8039e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8039eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ee:	8b 40 04             	mov    0x4(%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 0f                	je     803a04 <realloc_block_FF+0x6cf>
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	8b 40 04             	mov    0x4(%eax),%eax
  8039fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039fe:	8b 12                	mov    (%edx),%edx
  803a00:	89 10                	mov    %edx,(%eax)
  803a02:	eb 0a                	jmp    803a0e <realloc_block_FF+0x6d9>
  803a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a21:	a1 38 50 80 00       	mov    0x805038,%eax
  803a26:	48                   	dec    %eax
  803a27:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a2c:	83 ec 04             	sub    $0x4,%esp
  803a2f:	6a 00                	push   $0x0
  803a31:	ff 75 bc             	pushl  -0x44(%ebp)
  803a34:	ff 75 b8             	pushl  -0x48(%ebp)
  803a37:	e8 06 e9 ff ff       	call   802342 <set_block_data>
  803a3c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a42:	eb 0a                	jmp    803a4e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a44:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a4e:	c9                   	leave  
  803a4f:	c3                   	ret    

00803a50 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a50:	55                   	push   %ebp
  803a51:	89 e5                	mov    %esp,%ebp
  803a53:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a56:	83 ec 04             	sub    $0x4,%esp
  803a59:	68 08 47 80 00       	push   $0x804708
  803a5e:	68 58 02 00 00       	push   $0x258
  803a63:	68 11 46 80 00       	push   $0x804611
  803a68:	e8 bf c9 ff ff       	call   80042c <_panic>

00803a6d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a6d:	55                   	push   %ebp
  803a6e:	89 e5                	mov    %esp,%ebp
  803a70:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	68 30 47 80 00       	push   $0x804730
  803a7b:	68 61 02 00 00       	push   $0x261
  803a80:	68 11 46 80 00       	push   $0x804611
  803a85:	e8 a2 c9 ff ff       	call   80042c <_panic>
  803a8a:	66 90                	xchg   %ax,%ax

00803a8c <__udivdi3>:
  803a8c:	55                   	push   %ebp
  803a8d:	57                   	push   %edi
  803a8e:	56                   	push   %esi
  803a8f:	53                   	push   %ebx
  803a90:	83 ec 1c             	sub    $0x1c,%esp
  803a93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aa3:	89 ca                	mov    %ecx,%edx
  803aa5:	89 f8                	mov    %edi,%eax
  803aa7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aab:	85 f6                	test   %esi,%esi
  803aad:	75 2d                	jne    803adc <__udivdi3+0x50>
  803aaf:	39 cf                	cmp    %ecx,%edi
  803ab1:	77 65                	ja     803b18 <__udivdi3+0x8c>
  803ab3:	89 fd                	mov    %edi,%ebp
  803ab5:	85 ff                	test   %edi,%edi
  803ab7:	75 0b                	jne    803ac4 <__udivdi3+0x38>
  803ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  803abe:	31 d2                	xor    %edx,%edx
  803ac0:	f7 f7                	div    %edi
  803ac2:	89 c5                	mov    %eax,%ebp
  803ac4:	31 d2                	xor    %edx,%edx
  803ac6:	89 c8                	mov    %ecx,%eax
  803ac8:	f7 f5                	div    %ebp
  803aca:	89 c1                	mov    %eax,%ecx
  803acc:	89 d8                	mov    %ebx,%eax
  803ace:	f7 f5                	div    %ebp
  803ad0:	89 cf                	mov    %ecx,%edi
  803ad2:	89 fa                	mov    %edi,%edx
  803ad4:	83 c4 1c             	add    $0x1c,%esp
  803ad7:	5b                   	pop    %ebx
  803ad8:	5e                   	pop    %esi
  803ad9:	5f                   	pop    %edi
  803ada:	5d                   	pop    %ebp
  803adb:	c3                   	ret    
  803adc:	39 ce                	cmp    %ecx,%esi
  803ade:	77 28                	ja     803b08 <__udivdi3+0x7c>
  803ae0:	0f bd fe             	bsr    %esi,%edi
  803ae3:	83 f7 1f             	xor    $0x1f,%edi
  803ae6:	75 40                	jne    803b28 <__udivdi3+0x9c>
  803ae8:	39 ce                	cmp    %ecx,%esi
  803aea:	72 0a                	jb     803af6 <__udivdi3+0x6a>
  803aec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803af0:	0f 87 9e 00 00 00    	ja     803b94 <__udivdi3+0x108>
  803af6:	b8 01 00 00 00       	mov    $0x1,%eax
  803afb:	89 fa                	mov    %edi,%edx
  803afd:	83 c4 1c             	add    $0x1c,%esp
  803b00:	5b                   	pop    %ebx
  803b01:	5e                   	pop    %esi
  803b02:	5f                   	pop    %edi
  803b03:	5d                   	pop    %ebp
  803b04:	c3                   	ret    
  803b05:	8d 76 00             	lea    0x0(%esi),%esi
  803b08:	31 ff                	xor    %edi,%edi
  803b0a:	31 c0                	xor    %eax,%eax
  803b0c:	89 fa                	mov    %edi,%edx
  803b0e:	83 c4 1c             	add    $0x1c,%esp
  803b11:	5b                   	pop    %ebx
  803b12:	5e                   	pop    %esi
  803b13:	5f                   	pop    %edi
  803b14:	5d                   	pop    %ebp
  803b15:	c3                   	ret    
  803b16:	66 90                	xchg   %ax,%ax
  803b18:	89 d8                	mov    %ebx,%eax
  803b1a:	f7 f7                	div    %edi
  803b1c:	31 ff                	xor    %edi,%edi
  803b1e:	89 fa                	mov    %edi,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b2d:	89 eb                	mov    %ebp,%ebx
  803b2f:	29 fb                	sub    %edi,%ebx
  803b31:	89 f9                	mov    %edi,%ecx
  803b33:	d3 e6                	shl    %cl,%esi
  803b35:	89 c5                	mov    %eax,%ebp
  803b37:	88 d9                	mov    %bl,%cl
  803b39:	d3 ed                	shr    %cl,%ebp
  803b3b:	89 e9                	mov    %ebp,%ecx
  803b3d:	09 f1                	or     %esi,%ecx
  803b3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b43:	89 f9                	mov    %edi,%ecx
  803b45:	d3 e0                	shl    %cl,%eax
  803b47:	89 c5                	mov    %eax,%ebp
  803b49:	89 d6                	mov    %edx,%esi
  803b4b:	88 d9                	mov    %bl,%cl
  803b4d:	d3 ee                	shr    %cl,%esi
  803b4f:	89 f9                	mov    %edi,%ecx
  803b51:	d3 e2                	shl    %cl,%edx
  803b53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b57:	88 d9                	mov    %bl,%cl
  803b59:	d3 e8                	shr    %cl,%eax
  803b5b:	09 c2                	or     %eax,%edx
  803b5d:	89 d0                	mov    %edx,%eax
  803b5f:	89 f2                	mov    %esi,%edx
  803b61:	f7 74 24 0c          	divl   0xc(%esp)
  803b65:	89 d6                	mov    %edx,%esi
  803b67:	89 c3                	mov    %eax,%ebx
  803b69:	f7 e5                	mul    %ebp
  803b6b:	39 d6                	cmp    %edx,%esi
  803b6d:	72 19                	jb     803b88 <__udivdi3+0xfc>
  803b6f:	74 0b                	je     803b7c <__udivdi3+0xf0>
  803b71:	89 d8                	mov    %ebx,%eax
  803b73:	31 ff                	xor    %edi,%edi
  803b75:	e9 58 ff ff ff       	jmp    803ad2 <__udivdi3+0x46>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b80:	89 f9                	mov    %edi,%ecx
  803b82:	d3 e2                	shl    %cl,%edx
  803b84:	39 c2                	cmp    %eax,%edx
  803b86:	73 e9                	jae    803b71 <__udivdi3+0xe5>
  803b88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b8b:	31 ff                	xor    %edi,%edi
  803b8d:	e9 40 ff ff ff       	jmp    803ad2 <__udivdi3+0x46>
  803b92:	66 90                	xchg   %ax,%ax
  803b94:	31 c0                	xor    %eax,%eax
  803b96:	e9 37 ff ff ff       	jmp    803ad2 <__udivdi3+0x46>
  803b9b:	90                   	nop

00803b9c <__umoddi3>:
  803b9c:	55                   	push   %ebp
  803b9d:	57                   	push   %edi
  803b9e:	56                   	push   %esi
  803b9f:	53                   	push   %ebx
  803ba0:	83 ec 1c             	sub    $0x1c,%esp
  803ba3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ba7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803baf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bbb:	89 f3                	mov    %esi,%ebx
  803bbd:	89 fa                	mov    %edi,%edx
  803bbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bc3:	89 34 24             	mov    %esi,(%esp)
  803bc6:	85 c0                	test   %eax,%eax
  803bc8:	75 1a                	jne    803be4 <__umoddi3+0x48>
  803bca:	39 f7                	cmp    %esi,%edi
  803bcc:	0f 86 a2 00 00 00    	jbe    803c74 <__umoddi3+0xd8>
  803bd2:	89 c8                	mov    %ecx,%eax
  803bd4:	89 f2                	mov    %esi,%edx
  803bd6:	f7 f7                	div    %edi
  803bd8:	89 d0                	mov    %edx,%eax
  803bda:	31 d2                	xor    %edx,%edx
  803bdc:	83 c4 1c             	add    $0x1c,%esp
  803bdf:	5b                   	pop    %ebx
  803be0:	5e                   	pop    %esi
  803be1:	5f                   	pop    %edi
  803be2:	5d                   	pop    %ebp
  803be3:	c3                   	ret    
  803be4:	39 f0                	cmp    %esi,%eax
  803be6:	0f 87 ac 00 00 00    	ja     803c98 <__umoddi3+0xfc>
  803bec:	0f bd e8             	bsr    %eax,%ebp
  803bef:	83 f5 1f             	xor    $0x1f,%ebp
  803bf2:	0f 84 ac 00 00 00    	je     803ca4 <__umoddi3+0x108>
  803bf8:	bf 20 00 00 00       	mov    $0x20,%edi
  803bfd:	29 ef                	sub    %ebp,%edi
  803bff:	89 fe                	mov    %edi,%esi
  803c01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c05:	89 e9                	mov    %ebp,%ecx
  803c07:	d3 e0                	shl    %cl,%eax
  803c09:	89 d7                	mov    %edx,%edi
  803c0b:	89 f1                	mov    %esi,%ecx
  803c0d:	d3 ef                	shr    %cl,%edi
  803c0f:	09 c7                	or     %eax,%edi
  803c11:	89 e9                	mov    %ebp,%ecx
  803c13:	d3 e2                	shl    %cl,%edx
  803c15:	89 14 24             	mov    %edx,(%esp)
  803c18:	89 d8                	mov    %ebx,%eax
  803c1a:	d3 e0                	shl    %cl,%eax
  803c1c:	89 c2                	mov    %eax,%edx
  803c1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c22:	d3 e0                	shl    %cl,%eax
  803c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c2c:	89 f1                	mov    %esi,%ecx
  803c2e:	d3 e8                	shr    %cl,%eax
  803c30:	09 d0                	or     %edx,%eax
  803c32:	d3 eb                	shr    %cl,%ebx
  803c34:	89 da                	mov    %ebx,%edx
  803c36:	f7 f7                	div    %edi
  803c38:	89 d3                	mov    %edx,%ebx
  803c3a:	f7 24 24             	mull   (%esp)
  803c3d:	89 c6                	mov    %eax,%esi
  803c3f:	89 d1                	mov    %edx,%ecx
  803c41:	39 d3                	cmp    %edx,%ebx
  803c43:	0f 82 87 00 00 00    	jb     803cd0 <__umoddi3+0x134>
  803c49:	0f 84 91 00 00 00    	je     803ce0 <__umoddi3+0x144>
  803c4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c53:	29 f2                	sub    %esi,%edx
  803c55:	19 cb                	sbb    %ecx,%ebx
  803c57:	89 d8                	mov    %ebx,%eax
  803c59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c5d:	d3 e0                	shl    %cl,%eax
  803c5f:	89 e9                	mov    %ebp,%ecx
  803c61:	d3 ea                	shr    %cl,%edx
  803c63:	09 d0                	or     %edx,%eax
  803c65:	89 e9                	mov    %ebp,%ecx
  803c67:	d3 eb                	shr    %cl,%ebx
  803c69:	89 da                	mov    %ebx,%edx
  803c6b:	83 c4 1c             	add    $0x1c,%esp
  803c6e:	5b                   	pop    %ebx
  803c6f:	5e                   	pop    %esi
  803c70:	5f                   	pop    %edi
  803c71:	5d                   	pop    %ebp
  803c72:	c3                   	ret    
  803c73:	90                   	nop
  803c74:	89 fd                	mov    %edi,%ebp
  803c76:	85 ff                	test   %edi,%edi
  803c78:	75 0b                	jne    803c85 <__umoddi3+0xe9>
  803c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c7f:	31 d2                	xor    %edx,%edx
  803c81:	f7 f7                	div    %edi
  803c83:	89 c5                	mov    %eax,%ebp
  803c85:	89 f0                	mov    %esi,%eax
  803c87:	31 d2                	xor    %edx,%edx
  803c89:	f7 f5                	div    %ebp
  803c8b:	89 c8                	mov    %ecx,%eax
  803c8d:	f7 f5                	div    %ebp
  803c8f:	89 d0                	mov    %edx,%eax
  803c91:	e9 44 ff ff ff       	jmp    803bda <__umoddi3+0x3e>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	89 c8                	mov    %ecx,%eax
  803c9a:	89 f2                	mov    %esi,%edx
  803c9c:	83 c4 1c             	add    $0x1c,%esp
  803c9f:	5b                   	pop    %ebx
  803ca0:	5e                   	pop    %esi
  803ca1:	5f                   	pop    %edi
  803ca2:	5d                   	pop    %ebp
  803ca3:	c3                   	ret    
  803ca4:	3b 04 24             	cmp    (%esp),%eax
  803ca7:	72 06                	jb     803caf <__umoddi3+0x113>
  803ca9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cad:	77 0f                	ja     803cbe <__umoddi3+0x122>
  803caf:	89 f2                	mov    %esi,%edx
  803cb1:	29 f9                	sub    %edi,%ecx
  803cb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cb7:	89 14 24             	mov    %edx,(%esp)
  803cba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cc2:	8b 14 24             	mov    (%esp),%edx
  803cc5:	83 c4 1c             	add    $0x1c,%esp
  803cc8:	5b                   	pop    %ebx
  803cc9:	5e                   	pop    %esi
  803cca:	5f                   	pop    %edi
  803ccb:	5d                   	pop    %ebp
  803ccc:	c3                   	ret    
  803ccd:	8d 76 00             	lea    0x0(%esi),%esi
  803cd0:	2b 04 24             	sub    (%esp),%eax
  803cd3:	19 fa                	sbb    %edi,%edx
  803cd5:	89 d1                	mov    %edx,%ecx
  803cd7:	89 c6                	mov    %eax,%esi
  803cd9:	e9 71 ff ff ff       	jmp    803c4f <__umoddi3+0xb3>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ce4:	72 ea                	jb     803cd0 <__umoddi3+0x134>
  803ce6:	89 d9                	mov    %ebx,%ecx
  803ce8:	e9 62 ff ff ff       	jmp    803c4f <__umoddi3+0xb3>
