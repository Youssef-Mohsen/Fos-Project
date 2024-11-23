
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
  800060:	68 e0 3c 80 00       	push   $0x803ce0
  800065:	6a 11                	push   $0x11
  800067:	68 fc 3c 80 00       	push   $0x803cfc
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
  8000bc:	e8 04 1a 00 00       	call   801ac5 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 47 1a 00 00       	call   801b10 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 18 3d 80 00       	push   $0x803d18
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 fc 3c 80 00       	push   $0x803cfc
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 06 1a 00 00       	call   801b10 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 48 3d 80 00       	push   $0x803d48
  800117:	6a 33                	push   $0x33
  800119:	68 fc 3c 80 00       	push   $0x803cfc
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 9d 19 00 00       	call   801ac5 <sys_calculate_free_frames>
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
  80015f:	e8 61 19 00 00       	call   801ac5 <sys_calculate_free_frames>
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
  800181:	6a 3d                	push   $0x3d
  800183:	68 fc 3c 80 00       	push   $0x803cfc
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
  8001c7:	e8 54 1d 00 00       	call   801f20 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 f4 3d 80 00       	push   $0x803df4
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 fc 3c 80 00       	push   $0x803cfc
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 d4 18 00 00       	call   801ac5 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 17 19 00 00       	call   801b10 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 fd 18 00 00       	call   801b10 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 14 3e 80 00       	push   $0x803e14
  800220:	6a 4e                	push   $0x4e
  800222:	68 fc 3c 80 00       	push   $0x803cfc
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 94 18 00 00       	call   801ac5 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 50 3e 80 00       	push   $0x803e50
  800247:	6a 4f                	push   $0x4f
  800249:	68 fc 3c 80 00       	push   $0x803cfc
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
  80028d:	e8 8e 1c 00 00       	call   801f20 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 9c 3e 80 00       	push   $0x803e9c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 fc 3c 80 00       	push   $0x803cfc
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 15 1b 00 00       	call   801dcc <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 29 1b 00 00       	call   801de6 <gettst>
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
  8002d4:	e8 f3 1a 00 00       	call   801dcc <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 c0 3e 80 00       	push   $0x803ec0
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 fc 3c 80 00       	push   $0x803cfc
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
  8002f3:	e8 96 19 00 00       	call   801c8e <sys_getenvindex>
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
  800361:	e8 ac 16 00 00       	call   801a12 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 24 3f 80 00       	push   $0x803f24
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
  800391:	68 4c 3f 80 00       	push   $0x803f4c
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
  8003c2:	68 74 3f 80 00       	push   $0x803f74
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 cc 3f 80 00       	push   $0x803fcc
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 24 3f 80 00       	push   $0x803f24
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 2c 16 00 00       	call   801a2c <sys_unlock_cons>
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
  800413:	e8 42 18 00 00       	call   801c5a <sys_destroy_env>
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
  800424:	e8 97 18 00 00       	call   801cc0 <sys_exit_env>
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
  80044d:	68 e0 3f 80 00       	push   $0x803fe0
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 e5 3f 80 00       	push   $0x803fe5
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
  80048a:	68 01 40 80 00       	push   $0x804001
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
  8004b9:	68 04 40 80 00       	push   $0x804004
  8004be:	6a 26                	push   $0x26
  8004c0:	68 50 40 80 00       	push   $0x804050
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
  80058e:	68 5c 40 80 00       	push   $0x80405c
  800593:	6a 3a                	push   $0x3a
  800595:	68 50 40 80 00       	push   $0x804050
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
  800601:	68 b0 40 80 00       	push   $0x8040b0
  800606:	6a 44                	push   $0x44
  800608:	68 50 40 80 00       	push   $0x804050
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
  80065b:	e8 70 13 00 00       	call   8019d0 <sys_cputs>
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
  8006d2:	e8 f9 12 00 00       	call   8019d0 <sys_cputs>
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
  80071c:	e8 f1 12 00 00       	call   801a12 <sys_lock_cons>
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
  80073c:	e8 eb 12 00 00       	call   801a2c <sys_unlock_cons>
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
  800786:	e8 dd 32 00 00       	call   803a68 <__udivdi3>
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
  8007d6:	e8 9d 33 00 00       	call   803b78 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 14 43 80 00       	add    $0x804314,%eax
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
  800931:	8b 04 85 38 43 80 00 	mov    0x804338(,%eax,4),%eax
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
  800a12:	8b 34 9d 80 41 80 00 	mov    0x804180(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 25 43 80 00       	push   $0x804325
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
  800a37:	68 2e 43 80 00       	push   $0x80432e
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
  800a64:	be 31 43 80 00       	mov    $0x804331,%esi
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
  80146f:	68 a8 44 80 00       	push   $0x8044a8
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 ca 44 80 00       	push   $0x8044ca
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
  80148f:	e8 e7 0a 00 00       	call   801f7b <sys_sbrk>
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
  80150a:	e8 f0 08 00 00       	call   801dff <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 30 0e 00 00       	call   80234e <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 02 09 00 00       	call   801e30 <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 c9 12 00 00       	call   80280a <alloc_block_BF>
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
  8016a2:	e8 0b 09 00 00       	call   801fb2 <sys_allocate_user_mem>
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
  8016ea:	e8 df 08 00 00       	call   801fce <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 12 1b 00 00       	call   803212 <free_block>
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
  801792:	e8 ff 07 00 00       	call   801f96 <sys_free_user_mem>
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
  8017a0:	68 d8 44 80 00       	push   $0x8044d8
  8017a5:	68 85 00 00 00       	push   $0x85
  8017aa:	68 02 45 80 00       	push   $0x804502
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
  801815:	e8 83 03 00 00       	call   801b9d <sys_createSharedObject>
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
  801839:	68 0e 45 80 00       	push   $0x80450e
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
  80187d:	e8 45 03 00 00       	call   801bc7 <sys_getSizeOfSharedObject>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801888:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80188c:	75 07                	jne    801895 <sget+0x27>
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	eb 5c                	jmp    8018f1 <sget+0x83>
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
  8018c8:	eb 27                	jmp    8018f1 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	e8 09 03 00 00       	call   801be4 <sys_getSharedObject>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018e1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018e5:	75 07                	jne    8018ee <sget+0x80>
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ec:	eb 03                	jmp    8018f1 <sget+0x83>
	return ptr;
  8018ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fc:	a1 20 50 80 00       	mov    0x805020,%eax
  801901:	8b 40 78             	mov    0x78(%eax),%eax
  801904:	29 c2                	sub    %eax,%edx
  801906:	89 d0                	mov    %edx,%eax
  801908:	2d 00 10 00 00       	sub    $0x1000,%eax
  80190d:	c1 e8 0c             	shr    $0xc,%eax
  801910:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801917:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80191a:	83 ec 08             	sub    $0x8,%esp
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	e8 db 02 00 00       	call   801c03 <sys_freeSharedObject>
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	68 20 45 80 00       	push   $0x804520
  80193f:	68 dd 00 00 00       	push   $0xdd
  801944:	68 02 45 80 00       	push   $0x804502
  801949:	e8 de ea ff ff       	call   80042c <_panic>

0080194e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	68 46 45 80 00       	push   $0x804546
  80195c:	68 e9 00 00 00       	push   $0xe9
  801961:	68 02 45 80 00       	push   $0x804502
  801966:	e8 c1 ea ff ff       	call   80042c <_panic>

0080196b <shrink>:

}
void shrink(uint32 newSize)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	68 46 45 80 00       	push   $0x804546
  801979:	68 ee 00 00 00       	push   $0xee
  80197e:	68 02 45 80 00       	push   $0x804502
  801983:	e8 a4 ea ff ff       	call   80042c <_panic>

00801988 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	68 46 45 80 00       	push   $0x804546
  801996:	68 f3 00 00 00       	push   $0xf3
  80199b:	68 02 45 80 00       	push   $0x804502
  8019a0:	e8 87 ea ff ff       	call   80042c <_panic>

008019a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	57                   	push   %edi
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
  8019ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c0:	cd 30                	int    $0x30
  8019c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	e8 b2 ff ff ff       	call   8019a5 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	90                   	nop
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 02                	push   $0x2
  801a08:	e8 98 ff ff ff       	call   8019a5 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 03                	push   $0x3
  801a21:	e8 7f ff ff ff       	call   8019a5 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 04                	push   $0x4
  801a3b:	e8 65 ff ff ff       	call   8019a5 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 08                	push   $0x8
  801a59:	e8 47 ff ff ff       	call   8019a5 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a68:	8b 75 18             	mov    0x18(%ebp),%esi
  801a6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	56                   	push   %esi
  801a78:	53                   	push   %ebx
  801a79:	51                   	push   %ecx
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	6a 09                	push   $0x9
  801a7e:	e8 22 ff ff ff       	call   8019a5 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 0a                	push   $0xa
  801aa0:	e8 00 ff ff ff       	call   8019a5 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	ff 75 08             	pushl  0x8(%ebp)
  801ab9:	6a 0b                	push   $0xb
  801abb:	e8 e5 fe ff ff       	call   8019a5 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 0c                	push   $0xc
  801ad4:	e8 cc fe ff ff       	call   8019a5 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 0d                	push   $0xd
  801aed:	e8 b3 fe ff ff       	call   8019a5 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 0e                	push   $0xe
  801b06:	e8 9a fe ff ff       	call   8019a5 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 0f                	push   $0xf
  801b1f:	e8 81 fe ff ff       	call   8019a5 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 08             	pushl  0x8(%ebp)
  801b37:	6a 10                	push   $0x10
  801b39:	e8 67 fe ff ff       	call   8019a5 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 11                	push   $0x11
  801b52:	e8 4e fe ff ff       	call   8019a5 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_cputc>:

void
sys_cputc(const char c)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	50                   	push   %eax
  801b76:	6a 01                	push   $0x1
  801b78:	e8 28 fe ff ff       	call   8019a5 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 14                	push   $0x14
  801b92:	e8 0e fe ff ff       	call   8019a5 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	51                   	push   %ecx
  801bb6:	52                   	push   %edx
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	6a 15                	push   $0x15
  801bbd:	e8 e3 fd ff ff       	call   8019a5 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 16                	push   $0x16
  801bda:	e8 c6 fd ff ff       	call   8019a5 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	51                   	push   %ecx
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 17                	push   $0x17
  801bf9:	e8 a7 fd ff ff       	call   8019a5 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 18                	push   $0x18
  801c16:	e8 8a fd ff ff       	call   8019a5 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 14             	pushl  0x14(%ebp)
  801c2b:	ff 75 10             	pushl  0x10(%ebp)
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	50                   	push   %eax
  801c32:	6a 19                	push   $0x19
  801c34:	e8 6c fd ff ff       	call   8019a5 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	50                   	push   %eax
  801c4d:	6a 1a                	push   $0x1a
  801c4f:	e8 51 fd ff ff       	call   8019a5 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	50                   	push   %eax
  801c69:	6a 1b                	push   $0x1b
  801c6b:	e8 35 fd ff ff       	call   8019a5 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 05                	push   $0x5
  801c84:	e8 1c fd ff ff       	call   8019a5 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 06                	push   $0x6
  801c9d:	e8 03 fd ff ff       	call   8019a5 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 07                	push   $0x7
  801cb6:	e8 ea fc ff ff       	call   8019a5 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_exit_env>:


void sys_exit_env(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 1c                	push   $0x1c
  801ccf:	e8 d1 fc ff ff       	call   8019a5 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ce0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce3:	8d 50 04             	lea    0x4(%eax),%edx
  801ce6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 1d                	push   $0x1d
  801cf3:	e8 ad fc ff ff       	call   8019a5 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d04:	89 01                	mov    %eax,(%ecx)
  801d06:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	c9                   	leave  
  801d0d:	c2 04 00             	ret    $0x4

00801d10 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	ff 75 10             	pushl  0x10(%ebp)
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 13                	push   $0x13
  801d22:	e8 7e fc ff ff       	call   8019a5 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 1e                	push   $0x1e
  801d3c:	e8 64 fc ff ff       	call   8019a5 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d52:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	50                   	push   %eax
  801d5f:	6a 1f                	push   $0x1f
  801d61:	e8 3f fc ff ff       	call   8019a5 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return ;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <rsttst>:
void rsttst()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 21                	push   $0x21
  801d7b:	e8 25 fc ff ff       	call   8019a5 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d92:	8b 55 18             	mov    0x18(%ebp),%edx
  801d95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	ff 75 10             	pushl  0x10(%ebp)
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 20                	push   $0x20
  801da6:	e8 fa fb ff ff       	call   8019a5 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return ;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <chktst>:
void chktst(uint32 n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 22                	push   $0x22
  801dc1:	e8 df fb ff ff       	call   8019a5 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <inctst>:

void inctst()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 23                	push   $0x23
  801ddb:	e8 c5 fb ff ff       	call   8019a5 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return ;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <gettst>:
uint32 gettst()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 24                	push   $0x24
  801df5:	e8 ab fb ff ff       	call   8019a5 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 25                	push   $0x25
  801e11:	e8 8f fb ff ff       	call   8019a5 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
  801e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e1c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e20:	75 07                	jne    801e29 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	eb 05                	jmp    801e2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 25                	push   $0x25
  801e42:	e8 5e fb ff ff       	call   8019a5 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
  801e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e4d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e51:	75 07                	jne    801e5a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e53:	b8 01 00 00 00       	mov    $0x1,%eax
  801e58:	eb 05                	jmp    801e5f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 25                	push   $0x25
  801e73:	e8 2d fb ff ff       	call   8019a5 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
  801e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e7e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e82:	75 07                	jne    801e8b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e84:	b8 01 00 00 00       	mov    $0x1,%eax
  801e89:	eb 05                	jmp    801e90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 25                	push   $0x25
  801ea4:	e8 fc fa ff ff       	call   8019a5 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
  801eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eaf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb3:	75 07                	jne    801ebc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eba:	eb 05                	jmp    801ec1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 26                	push   $0x26
  801ed3:	e8 cd fa ff ff       	call   8019a5 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ee2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	53                   	push   %ebx
  801ef1:	51                   	push   %ecx
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 27                	push   $0x27
  801ef6:	e8 aa fa ff ff       	call   8019a5 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 28                	push   $0x28
  801f16:	e8 8a fa ff ff       	call   8019a5 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	51                   	push   %ecx
  801f2f:	ff 75 10             	pushl  0x10(%ebp)
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 29                	push   $0x29
  801f36:	e8 6a fa ff ff       	call   8019a5 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	ff 75 10             	pushl  0x10(%ebp)
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	6a 12                	push   $0x12
  801f52:	e8 4e fa ff ff       	call   8019a5 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5a:	90                   	nop
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 2a                	push   $0x2a
  801f70:	e8 30 fa ff ff       	call   8019a5 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
	return;
  801f78:	90                   	nop
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	50                   	push   %eax
  801f8a:	6a 2b                	push   $0x2b
  801f8c:	e8 14 fa ff ff       	call   8019a5 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	ff 75 0c             	pushl  0xc(%ebp)
  801fa2:	ff 75 08             	pushl  0x8(%ebp)
  801fa5:	6a 2c                	push   $0x2c
  801fa7:	e8 f9 f9 ff ff       	call   8019a5 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
	return;
  801faf:	90                   	nop
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	6a 2d                	push   $0x2d
  801fc3:	e8 dd f9 ff ff       	call   8019a5 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
	return;
  801fcb:	90                   	nop
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	83 e8 04             	sub    $0x4,%eax
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe0:	8b 00                	mov    (%eax),%eax
  801fe2:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	83 e8 04             	sub    $0x4,%eax
  801ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	83 e0 01             	and    $0x1,%eax
  801ffe:	85 c0                	test   %eax,%eax
  802000:	0f 94 c0             	sete   %al
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80200b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802012:	8b 45 0c             	mov    0xc(%ebp),%eax
  802015:	83 f8 02             	cmp    $0x2,%eax
  802018:	74 2b                	je     802045 <alloc_block+0x40>
  80201a:	83 f8 02             	cmp    $0x2,%eax
  80201d:	7f 07                	jg     802026 <alloc_block+0x21>
  80201f:	83 f8 01             	cmp    $0x1,%eax
  802022:	74 0e                	je     802032 <alloc_block+0x2d>
  802024:	eb 58                	jmp    80207e <alloc_block+0x79>
  802026:	83 f8 03             	cmp    $0x3,%eax
  802029:	74 2d                	je     802058 <alloc_block+0x53>
  80202b:	83 f8 04             	cmp    $0x4,%eax
  80202e:	74 3b                	je     80206b <alloc_block+0x66>
  802030:	eb 4c                	jmp    80207e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	e8 11 03 00 00       	call   80234e <alloc_block_FF>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802043:	eb 4a                	jmp    80208f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802045:	83 ec 0c             	sub    $0xc,%esp
  802048:	ff 75 08             	pushl  0x8(%ebp)
  80204b:	e8 fa 19 00 00       	call   803a4a <alloc_block_NF>
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802056:	eb 37                	jmp    80208f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802058:	83 ec 0c             	sub    $0xc,%esp
  80205b:	ff 75 08             	pushl  0x8(%ebp)
  80205e:	e8 a7 07 00 00       	call   80280a <alloc_block_BF>
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802069:	eb 24                	jmp    80208f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	ff 75 08             	pushl  0x8(%ebp)
  802071:	e8 b7 19 00 00       	call   803a2d <alloc_block_WF>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80207c:	eb 11                	jmp    80208f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80207e:	83 ec 0c             	sub    $0xc,%esp
  802081:	68 58 45 80 00       	push   $0x804558
  802086:	e8 5e e6 ff ff       	call   8006e9 <cprintf>
  80208b:	83 c4 10             	add    $0x10,%esp
		break;
  80208e:	90                   	nop
	}
	return va;
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	53                   	push   %ebx
  802098:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	68 78 45 80 00       	push   $0x804578
  8020a3:	e8 41 e6 ff ff       	call   8006e9 <cprintf>
  8020a8:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	68 a3 45 80 00       	push   $0x8045a3
  8020b3:	e8 31 e6 ff ff       	call   8006e9 <cprintf>
  8020b8:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c1:	eb 37                	jmp    8020fa <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c9:	e8 19 ff ff ff       	call   801fe7 <is_free_block>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	0f be d8             	movsbl %al,%ebx
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	e8 ef fe ff ff       	call   801fce <get_block_size>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	53                   	push   %ebx
  8020e6:	50                   	push   %eax
  8020e7:	68 bb 45 80 00       	push   $0x8045bb
  8020ec:	e8 f8 e5 ff ff       	call   8006e9 <cprintf>
  8020f1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fe:	74 07                	je     802107 <print_blocks_list+0x73>
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	eb 05                	jmp    80210c <print_blocks_list+0x78>
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
  80210c:	89 45 10             	mov    %eax,0x10(%ebp)
  80210f:	8b 45 10             	mov    0x10(%ebp),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	75 ad                	jne    8020c3 <print_blocks_list+0x2f>
  802116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211a:	75 a7                	jne    8020c3 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	68 78 45 80 00       	push   $0x804578
  802124:	e8 c0 e5 ff ff       	call   8006e9 <cprintf>
  802129:	83 c4 10             	add    $0x10,%esp

}
  80212c:	90                   	nop
  80212d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	83 e0 01             	and    $0x1,%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	74 03                	je     802145 <initialize_dynamic_allocator+0x13>
  802142:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802145:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802149:	0f 84 c7 01 00 00    	je     802316 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80214f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802156:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802159:	8b 55 08             	mov    0x8(%ebp),%edx
  80215c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215f:	01 d0                	add    %edx,%eax
  802161:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802166:	0f 87 ad 01 00 00    	ja     802319 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	85 c0                	test   %eax,%eax
  802171:	0f 89 a5 01 00 00    	jns    80231c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802177:	8b 55 08             	mov    0x8(%ebp),%edx
  80217a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217d:	01 d0                	add    %edx,%eax
  80217f:	83 e8 04             	sub    $0x4,%eax
  802182:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80218e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802196:	e9 87 00 00 00       	jmp    802222 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219f:	75 14                	jne    8021b5 <initialize_dynamic_allocator+0x83>
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	68 d3 45 80 00       	push   $0x8045d3
  8021a9:	6a 79                	push   $0x79
  8021ab:	68 f1 45 80 00       	push   $0x8045f1
  8021b0:	e8 77 e2 ff ff       	call   80042c <_panic>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	74 10                	je     8021ce <initialize_dynamic_allocator+0x9c>
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c6:	8b 52 04             	mov    0x4(%edx),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	eb 0b                	jmp    8021d9 <initialize_dynamic_allocator+0xa7>
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 40 04             	mov    0x4(%eax),%eax
  8021d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 40 04             	mov    0x4(%eax),%eax
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	74 0f                	je     8021f2 <initialize_dynamic_allocator+0xc0>
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	8b 40 04             	mov    0x4(%eax),%eax
  8021e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ec:	8b 12                	mov    (%edx),%edx
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	eb 0a                	jmp    8021fc <initialize_dynamic_allocator+0xca>
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220f:	a1 38 50 80 00       	mov    0x805038,%eax
  802214:	48                   	dec    %eax
  802215:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80221a:	a1 34 50 80 00       	mov    0x805034,%eax
  80221f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802226:	74 07                	je     80222f <initialize_dynamic_allocator+0xfd>
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	eb 05                	jmp    802234 <initialize_dynamic_allocator+0x102>
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	a3 34 50 80 00       	mov    %eax,0x805034
  802239:	a1 34 50 80 00       	mov    0x805034,%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	0f 85 55 ff ff ff    	jne    80219b <initialize_dynamic_allocator+0x69>
  802246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224a:	0f 85 4b ff ff ff    	jne    80219b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80225f:	a1 44 50 80 00       	mov    0x805044,%eax
  802264:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802269:	a1 40 50 80 00       	mov    0x805040,%eax
  80226e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	83 c0 08             	add    $0x8,%eax
  80227a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	83 c0 04             	add    $0x4,%eax
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	83 ea 08             	sub    $0x8,%edx
  802289:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	01 d0                	add    %edx,%eax
  802293:	83 e8 08             	sub    $0x8,%eax
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	83 ea 08             	sub    $0x8,%edx
  80229c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b5:	75 17                	jne    8022ce <initialize_dynamic_allocator+0x19c>
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 0c 46 80 00       	push   $0x80460c
  8022bf:	68 90 00 00 00       	push   $0x90
  8022c4:	68 f1 45 80 00       	push   $0x8045f1
  8022c9:	e8 5e e1 ff ff       	call   80042c <_panic>
  8022ce:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	89 10                	mov    %edx,(%eax)
  8022d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 0d                	je     8022ef <initialize_dynamic_allocator+0x1bd>
  8022e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022ea:	89 50 04             	mov    %edx,0x4(%eax)
  8022ed:	eb 08                	jmp    8022f7 <initialize_dynamic_allocator+0x1c5>
  8022ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802309:	a1 38 50 80 00       	mov    0x805038,%eax
  80230e:	40                   	inc    %eax
  80230f:	a3 38 50 80 00       	mov    %eax,0x805038
  802314:	eb 07                	jmp    80231d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802316:	90                   	nop
  802317:	eb 04                	jmp    80231d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802319:	90                   	nop
  80231a:	eb 01                	jmp    80231d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80231c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802322:	8b 45 10             	mov    0x10(%ebp),%eax
  802325:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	83 e8 04             	sub    $0x4,%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	83 e0 fe             	and    $0xfffffffe,%eax
  80233e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	01 c2                	add    %eax,%edx
  802346:	8b 45 0c             	mov    0xc(%ebp),%eax
  802349:	89 02                	mov    %eax,(%edx)
}
  80234b:	90                   	nop
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	83 e0 01             	and    $0x1,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	74 03                	je     802361 <alloc_block_FF+0x13>
  80235e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802361:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802365:	77 07                	ja     80236e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802367:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80236e:	a1 24 50 80 00       	mov    0x805024,%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	75 73                	jne    8023ea <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	83 c0 10             	add    $0x10,%eax
  80237d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802380:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238d:	01 d0                	add    %edx,%eax
  80238f:	48                   	dec    %eax
  802390:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802396:	ba 00 00 00 00       	mov    $0x0,%edx
  80239b:	f7 75 ec             	divl   -0x14(%ebp)
  80239e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a1:	29 d0                	sub    %edx,%eax
  8023a3:	c1 e8 0c             	shr    $0xc,%eax
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	50                   	push   %eax
  8023aa:	e8 d4 f0 ff ff       	call   801483 <sbrk>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	6a 00                	push   $0x0
  8023ba:	e8 c4 f0 ff ff       	call   801483 <sbrk>
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023cb:	83 ec 08             	sub    $0x8,%esp
  8023ce:	50                   	push   %eax
  8023cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023d2:	e8 5b fd ff ff       	call   802132 <initialize_dynamic_allocator>
  8023d7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	68 2f 46 80 00       	push   $0x80462f
  8023e2:	e8 02 e3 ff ff       	call   8006e9 <cprintf>
  8023e7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ee:	75 0a                	jne    8023fa <alloc_block_FF+0xac>
	        return NULL;
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f5:	e9 0e 04 00 00       	jmp    802808 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802401:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	e9 f3 02 00 00       	jmp    802701 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802414:	83 ec 0c             	sub    $0xc,%esp
  802417:	ff 75 bc             	pushl  -0x44(%ebp)
  80241a:	e8 af fb ff ff       	call   801fce <get_block_size>
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	83 c0 08             	add    $0x8,%eax
  80242b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80242e:	0f 87 c5 02 00 00    	ja     8026f9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	83 c0 18             	add    $0x18,%eax
  80243a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80243d:	0f 87 19 02 00 00    	ja     80265c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802443:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802446:	2b 45 08             	sub    0x8(%ebp),%eax
  802449:	83 e8 08             	sub    $0x8,%eax
  80244c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8d 50 08             	lea    0x8(%eax),%edx
  802455:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	83 c0 08             	add    $0x8,%eax
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	6a 01                	push   $0x1
  802468:	50                   	push   %eax
  802469:	ff 75 bc             	pushl  -0x44(%ebp)
  80246c:	e8 ae fe ff ff       	call   80231f <set_block_data>
  802471:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	75 68                	jne    8024e6 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80247e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802482:	75 17                	jne    80249b <alloc_block_FF+0x14d>
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 0c 46 80 00       	push   $0x80460c
  80248c:	68 d7 00 00 00       	push   $0xd7
  802491:	68 f1 45 80 00       	push   $0x8045f1
  802496:	e8 91 df ff ff       	call   80042c <_panic>
  80249b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 0d                	je     8024bc <alloc_block_FF+0x16e>
  8024af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024b4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024b7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ba:	eb 08                	jmp    8024c4 <alloc_block_FF+0x176>
  8024bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024db:	40                   	inc    %eax
  8024dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8024e1:	e9 dc 00 00 00       	jmp    8025c2 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 65                	jne    802554 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024ef:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_FF+0x1be>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 40 46 80 00       	push   $0x804640
  8024fd:	68 db 00 00 00       	push   $0xdb
  802502:	68 f1 45 80 00       	push   $0x8045f1
  802507:	e8 20 df ff ff       	call   80042c <_panic>
  80250c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802512:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 0c                	je     80252e <alloc_block_FF+0x1e0>
  802522:	a1 30 50 80 00       	mov    0x805030,%eax
  802527:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80252a:	89 10                	mov    %edx,(%eax)
  80252c:	eb 08                	jmp    802536 <alloc_block_FF+0x1e8>
  80252e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802531:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802536:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802539:	a3 30 50 80 00       	mov    %eax,0x805030
  80253e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802547:	a1 38 50 80 00       	mov    0x805038,%eax
  80254c:	40                   	inc    %eax
  80254d:	a3 38 50 80 00       	mov    %eax,0x805038
  802552:	eb 6e                	jmp    8025c2 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802558:	74 06                	je     802560 <alloc_block_FF+0x212>
  80255a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80255e:	75 17                	jne    802577 <alloc_block_FF+0x229>
  802560:	83 ec 04             	sub    $0x4,%esp
  802563:	68 64 46 80 00       	push   $0x804664
  802568:	68 df 00 00 00       	push   $0xdf
  80256d:	68 f1 45 80 00       	push   $0x8045f1
  802572:	e8 b5 de ff ff       	call   80042c <_panic>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 10                	mov    (%eax),%edx
  80257c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257f:	89 10                	mov    %edx,(%eax)
  802581:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 0b                	je     802595 <alloc_block_FF+0x247>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802592:	89 50 04             	mov    %edx,0x4(%eax)
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80259b:	89 10                	mov    %edx,(%eax)
  80259d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a3:	89 50 04             	mov    %edx,0x4(%eax)
  8025a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	75 08                	jne    8025b7 <alloc_block_FF+0x269>
  8025af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8025b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8025bc:	40                   	inc    %eax
  8025bd:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	75 17                	jne    8025df <alloc_block_FF+0x291>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 d3 45 80 00       	push   $0x8045d3
  8025d0:	68 e1 00 00 00       	push   $0xe1
  8025d5:	68 f1 45 80 00       	push   $0x8045f1
  8025da:	e8 4d de ff ff       	call   80042c <_panic>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 10                	je     8025f8 <alloc_block_FF+0x2aa>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	8b 52 04             	mov    0x4(%edx),%edx
  8025f3:	89 50 04             	mov    %edx,0x4(%eax)
  8025f6:	eb 0b                	jmp    802603 <alloc_block_FF+0x2b5>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 0f                	je     80261c <alloc_block_FF+0x2ce>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802616:	8b 12                	mov    (%edx),%edx
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	eb 0a                	jmp    802626 <alloc_block_FF+0x2d8>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802639:	a1 38 50 80 00       	mov    0x805038,%eax
  80263e:	48                   	dec    %eax
  80263f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	6a 00                	push   $0x0
  802649:	ff 75 b4             	pushl  -0x4c(%ebp)
  80264c:	ff 75 b0             	pushl  -0x50(%ebp)
  80264f:	e8 cb fc ff ff       	call   80231f <set_block_data>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	e9 95 00 00 00       	jmp    8026f1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	6a 01                	push   $0x1
  802661:	ff 75 b8             	pushl  -0x48(%ebp)
  802664:	ff 75 bc             	pushl  -0x44(%ebp)
  802667:	e8 b3 fc ff ff       	call   80231f <set_block_data>
  80266c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_FF+0x33e>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 d3 45 80 00       	push   $0x8045d3
  80267d:	68 e8 00 00 00       	push   $0xe8
  802682:	68 f1 45 80 00       	push   $0x8045f1
  802687:	e8 a0 dd ff ff       	call   80042c <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_FF+0x357>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_FF+0x362>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_FF+0x37b>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_FF+0x385>
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
	            }
	            return va;
  8026f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026f4:	e9 0f 01 00 00       	jmp    802808 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802705:	74 07                	je     80270e <alloc_block_FF+0x3c0>
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	eb 05                	jmp    802713 <alloc_block_FF+0x3c5>
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
  802713:	a3 34 50 80 00       	mov    %eax,0x805034
  802718:	a1 34 50 80 00       	mov    0x805034,%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	0f 85 e9 fc ff ff    	jne    80240e <alloc_block_FF+0xc0>
  802725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802729:	0f 85 df fc ff ff    	jne    80240e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	83 c0 08             	add    $0x8,%eax
  802735:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802738:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80273f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802742:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802745:	01 d0                	add    %edx,%eax
  802747:	48                   	dec    %eax
  802748:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80274b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274e:	ba 00 00 00 00       	mov    $0x0,%edx
  802753:	f7 75 d8             	divl   -0x28(%ebp)
  802756:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802759:	29 d0                	sub    %edx,%eax
  80275b:	c1 e8 0c             	shr    $0xc,%eax
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	50                   	push   %eax
  802762:	e8 1c ed ff ff       	call   801483 <sbrk>
  802767:	83 c4 10             	add    $0x10,%esp
  80276a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80276d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802771:	75 0a                	jne    80277d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	e9 8b 00 00 00       	jmp    802808 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80277d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802784:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802787:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278a:	01 d0                	add    %edx,%eax
  80278c:	48                   	dec    %eax
  80278d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802790:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802793:	ba 00 00 00 00       	mov    $0x0,%edx
  802798:	f7 75 cc             	divl   -0x34(%ebp)
  80279b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80279e:	29 d0                	sub    %edx,%eax
  8027a0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027a6:	01 d0                	add    %edx,%eax
  8027a8:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027b8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027c5:	01 d0                	add    %edx,%eax
  8027c7:	48                   	dec    %eax
  8027c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d3:	f7 75 c4             	divl   -0x3c(%ebp)
  8027d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027d9:	29 d0                	sub    %edx,%eax
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	6a 01                	push   $0x1
  8027e0:	50                   	push   %eax
  8027e1:	ff 75 d0             	pushl  -0x30(%ebp)
  8027e4:	e8 36 fb ff ff       	call   80231f <set_block_data>
  8027e9:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	ff 75 d0             	pushl  -0x30(%ebp)
  8027f2:	e8 1b 0a 00 00       	call   803212 <free_block>
  8027f7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027fa:	83 ec 0c             	sub    $0xc,%esp
  8027fd:	ff 75 08             	pushl  0x8(%ebp)
  802800:	e8 49 fb ff ff       	call   80234e <alloc_block_FF>
  802805:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	83 e0 01             	and    $0x1,%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 03                	je     80281d <alloc_block_BF+0x13>
  80281a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80281d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802821:	77 07                	ja     80282a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802823:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80282a:	a1 24 50 80 00       	mov    0x805024,%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	75 73                	jne    8028a6 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	83 c0 10             	add    $0x10,%eax
  802839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80283c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802849:	01 d0                	add    %edx,%eax
  80284b:	48                   	dec    %eax
  80284c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80284f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802852:	ba 00 00 00 00       	mov    $0x0,%edx
  802857:	f7 75 e0             	divl   -0x20(%ebp)
  80285a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80285d:	29 d0                	sub    %edx,%eax
  80285f:	c1 e8 0c             	shr    $0xc,%eax
  802862:	83 ec 0c             	sub    $0xc,%esp
  802865:	50                   	push   %eax
  802866:	e8 18 ec ff ff       	call   801483 <sbrk>
  80286b:	83 c4 10             	add    $0x10,%esp
  80286e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802871:	83 ec 0c             	sub    $0xc,%esp
  802874:	6a 00                	push   $0x0
  802876:	e8 08 ec ff ff       	call   801483 <sbrk>
  80287b:	83 c4 10             	add    $0x10,%esp
  80287e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802881:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802884:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802887:	83 ec 08             	sub    $0x8,%esp
  80288a:	50                   	push   %eax
  80288b:	ff 75 d8             	pushl  -0x28(%ebp)
  80288e:	e8 9f f8 ff ff       	call   802132 <initialize_dynamic_allocator>
  802893:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802896:	83 ec 0c             	sub    $0xc,%esp
  802899:	68 2f 46 80 00       	push   $0x80462f
  80289e:	e8 46 de ff ff       	call   8006e9 <cprintf>
  8028a3:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028b4:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ca:	e9 1d 01 00 00       	jmp    8029ec <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028d5:	83 ec 0c             	sub    $0xc,%esp
  8028d8:	ff 75 a8             	pushl  -0x58(%ebp)
  8028db:	e8 ee f6 ff ff       	call   801fce <get_block_size>
  8028e0:	83 c4 10             	add    $0x10,%esp
  8028e3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	83 c0 08             	add    $0x8,%eax
  8028ec:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ef:	0f 87 ef 00 00 00    	ja     8029e4 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	83 c0 18             	add    $0x18,%eax
  8028fb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028fe:	77 1d                	ja     80291d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802903:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802906:	0f 86 d8 00 00 00    	jbe    8029e4 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80290c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80290f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802912:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802915:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802918:	e9 c7 00 00 00       	jmp    8029e4 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	83 c0 08             	add    $0x8,%eax
  802923:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802926:	0f 85 9d 00 00 00    	jne    8029c9 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	6a 01                	push   $0x1
  802931:	ff 75 a4             	pushl  -0x5c(%ebp)
  802934:	ff 75 a8             	pushl  -0x58(%ebp)
  802937:	e8 e3 f9 ff ff       	call   80231f <set_block_data>
  80293c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	75 17                	jne    80295c <alloc_block_BF+0x152>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 d3 45 80 00       	push   $0x8045d3
  80294d:	68 2c 01 00 00       	push   $0x12c
  802952:	68 f1 45 80 00       	push   $0x8045f1
  802957:	e8 d0 da ff ff       	call   80042c <_panic>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 10                	je     802975 <alloc_block_BF+0x16b>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296d:	8b 52 04             	mov    0x4(%edx),%edx
  802970:	89 50 04             	mov    %edx,0x4(%eax)
  802973:	eb 0b                	jmp    802980 <alloc_block_BF+0x176>
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	a3 30 50 80 00       	mov    %eax,0x805030
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 0f                	je     802999 <alloc_block_BF+0x18f>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802993:	8b 12                	mov    (%edx),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 0a                	jmp    8029a3 <alloc_block_BF+0x199>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8029bb:	48                   	dec    %eax
  8029bc:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029c1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c4:	e9 24 04 00 00       	jmp    802ded <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029cf:	76 13                	jbe    8029e4 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029d1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029db:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f0:	74 07                	je     8029f9 <alloc_block_BF+0x1ef>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	eb 05                	jmp    8029fe <alloc_block_BF+0x1f4>
  8029f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fe:	a3 34 50 80 00       	mov    %eax,0x805034
  802a03:	a1 34 50 80 00       	mov    0x805034,%eax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	0f 85 bf fe ff ff    	jne    8028cf <alloc_block_BF+0xc5>
  802a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a14:	0f 85 b5 fe ff ff    	jne    8028cf <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a1e:	0f 84 26 02 00 00    	je     802c4a <alloc_block_BF+0x440>
  802a24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a28:	0f 85 1c 02 00 00    	jne    802c4a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	2b 45 08             	sub    0x8(%ebp),%eax
  802a34:	83 e8 08             	sub    $0x8,%eax
  802a37:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8d 50 08             	lea    0x8(%eax),%edx
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	01 d0                	add    %edx,%eax
  802a45:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	83 c0 08             	add    $0x8,%eax
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	6a 01                	push   $0x1
  802a53:	50                   	push   %eax
  802a54:	ff 75 f0             	pushl  -0x10(%ebp)
  802a57:	e8 c3 f8 ff ff       	call   80231f <set_block_data>
  802a5c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	75 68                	jne    802ad1 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a69:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a6d:	75 17                	jne    802a86 <alloc_block_BF+0x27c>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 0c 46 80 00       	push   $0x80460c
  802a77:	68 45 01 00 00       	push   $0x145
  802a7c:	68 f1 45 80 00       	push   $0x8045f1
  802a81:	e8 a6 d9 ff ff       	call   80042c <_panic>
  802a86:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	74 0d                	je     802aa7 <alloc_block_BF+0x29d>
  802a9a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a9f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)
  802aa5:	eb 08                	jmp    802aaf <alloc_block_BF+0x2a5>
  802aa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aaa:	a3 30 50 80 00       	mov    %eax,0x805030
  802aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac6:	40                   	inc    %eax
  802ac7:	a3 38 50 80 00       	mov    %eax,0x805038
  802acc:	e9 dc 00 00 00       	jmp    802bad <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	75 65                	jne    802b3f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ada:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ade:	75 17                	jne    802af7 <alloc_block_BF+0x2ed>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 40 46 80 00       	push   $0x804640
  802ae8:	68 4a 01 00 00       	push   $0x14a
  802aed:	68 f1 45 80 00       	push   $0x8045f1
  802af2:	e8 35 d9 ff ff       	call   80042c <_panic>
  802af7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802afd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
  802b03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0c                	je     802b19 <alloc_block_BF+0x30f>
  802b0d:	a1 30 50 80 00       	mov    0x805030,%eax
  802b12:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	eb 08                	jmp    802b21 <alloc_block_BF+0x317>
  802b19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b24:	a3 30 50 80 00       	mov    %eax,0x805030
  802b29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b32:	a1 38 50 80 00       	mov    0x805038,%eax
  802b37:	40                   	inc    %eax
  802b38:	a3 38 50 80 00       	mov    %eax,0x805038
  802b3d:	eb 6e                	jmp    802bad <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b43:	74 06                	je     802b4b <alloc_block_BF+0x341>
  802b45:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b49:	75 17                	jne    802b62 <alloc_block_BF+0x358>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 64 46 80 00       	push   $0x804664
  802b53:	68 4f 01 00 00       	push   $0x14f
  802b58:	68 f1 45 80 00       	push   $0x8045f1
  802b5d:	e8 ca d8 ff ff       	call   80042c <_panic>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 10                	mov    (%eax),%edx
  802b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 0b                	je     802b80 <alloc_block_BF+0x376>
  802b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b83:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8e:	89 50 04             	mov    %edx,0x4(%eax)
  802b91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	75 08                	jne    802ba2 <alloc_block_BF+0x398>
  802b9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb1:	75 17                	jne    802bca <alloc_block_BF+0x3c0>
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	68 d3 45 80 00       	push   $0x8045d3
  802bbb:	68 51 01 00 00       	push   $0x151
  802bc0:	68 f1 45 80 00       	push   $0x8045f1
  802bc5:	e8 62 d8 ff ff       	call   80042c <_panic>
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 10                	je     802be3 <alloc_block_BF+0x3d9>
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdb:	8b 52 04             	mov    0x4(%edx),%edx
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	eb 0b                	jmp    802bee <alloc_block_BF+0x3e4>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	a3 30 50 80 00       	mov    %eax,0x805030
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 0f                	je     802c07 <alloc_block_BF+0x3fd>
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	8b 40 04             	mov    0x4(%eax),%eax
  802bfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c01:	8b 12                	mov    (%edx),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	eb 0a                	jmp    802c11 <alloc_block_BF+0x407>
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c24:	a1 38 50 80 00       	mov    0x805038,%eax
  802c29:	48                   	dec    %eax
  802c2a:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	6a 00                	push   $0x0
  802c34:	ff 75 d0             	pushl  -0x30(%ebp)
  802c37:	ff 75 cc             	pushl  -0x34(%ebp)
  802c3a:	e8 e0 f6 ff ff       	call   80231f <set_block_data>
  802c3f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	e9 a3 01 00 00       	jmp    802ded <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c4a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c4e:	0f 85 9d 00 00 00    	jne    802cf1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	6a 01                	push   $0x1
  802c59:	ff 75 ec             	pushl  -0x14(%ebp)
  802c5c:	ff 75 f0             	pushl  -0x10(%ebp)
  802c5f:	e8 bb f6 ff ff       	call   80231f <set_block_data>
  802c64:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6b:	75 17                	jne    802c84 <alloc_block_BF+0x47a>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 d3 45 80 00       	push   $0x8045d3
  802c75:	68 58 01 00 00       	push   $0x158
  802c7a:	68 f1 45 80 00       	push   $0x8045f1
  802c7f:	e8 a8 d7 ff ff       	call   80042c <_panic>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 10                	je     802c9d <alloc_block_BF+0x493>
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c95:	8b 52 04             	mov    0x4(%edx),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	eb 0b                	jmp    802ca8 <alloc_block_BF+0x49e>
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	74 0f                	je     802cc1 <alloc_block_BF+0x4b7>
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbb:	8b 12                	mov    (%edx),%edx
  802cbd:	89 10                	mov    %edx,(%eax)
  802cbf:	eb 0a                	jmp    802ccb <alloc_block_BF+0x4c1>
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cde:	a1 38 50 80 00       	mov    0x805038,%eax
  802ce3:	48                   	dec    %eax
  802ce4:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cec:	e9 fc 00 00 00       	jmp    802ded <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	83 c0 08             	add    $0x8,%eax
  802cf7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cfa:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d01:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d07:	01 d0                	add    %edx,%eax
  802d09:	48                   	dec    %eax
  802d0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d10:	ba 00 00 00 00       	mov    $0x0,%edx
  802d15:	f7 75 c4             	divl   -0x3c(%ebp)
  802d18:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d1b:	29 d0                	sub    %edx,%eax
  802d1d:	c1 e8 0c             	shr    $0xc,%eax
  802d20:	83 ec 0c             	sub    $0xc,%esp
  802d23:	50                   	push   %eax
  802d24:	e8 5a e7 ff ff       	call   801483 <sbrk>
  802d29:	83 c4 10             	add    $0x10,%esp
  802d2c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d2f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d33:	75 0a                	jne    802d3f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3a:	e9 ae 00 00 00       	jmp    802ded <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d3f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d46:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d4c:	01 d0                	add    %edx,%eax
  802d4e:	48                   	dec    %eax
  802d4f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d52:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d55:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5a:	f7 75 b8             	divl   -0x48(%ebp)
  802d5d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d60:	29 d0                	sub    %edx,%eax
  802d62:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d65:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d68:	01 d0                	add    %edx,%eax
  802d6a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d6f:	a1 40 50 80 00       	mov    0x805040,%eax
  802d74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d7a:	83 ec 0c             	sub    $0xc,%esp
  802d7d:	68 98 46 80 00       	push   $0x804698
  802d82:	e8 62 d9 ff ff       	call   8006e9 <cprintf>
  802d87:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d8a:	83 ec 08             	sub    $0x8,%esp
  802d8d:	ff 75 bc             	pushl  -0x44(%ebp)
  802d90:	68 9d 46 80 00       	push   $0x80469d
  802d95:	e8 4f d9 ff ff       	call   8006e9 <cprintf>
  802d9a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d9d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802da4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802da7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802daa:	01 d0                	add    %edx,%eax
  802dac:	48                   	dec    %eax
  802dad:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802db0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802db3:	ba 00 00 00 00       	mov    $0x0,%edx
  802db8:	f7 75 b0             	divl   -0x50(%ebp)
  802dbb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dbe:	29 d0                	sub    %edx,%eax
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	6a 01                	push   $0x1
  802dc5:	50                   	push   %eax
  802dc6:	ff 75 bc             	pushl  -0x44(%ebp)
  802dc9:	e8 51 f5 ff ff       	call   80231f <set_block_data>
  802dce:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802dd1:	83 ec 0c             	sub    $0xc,%esp
  802dd4:	ff 75 bc             	pushl  -0x44(%ebp)
  802dd7:	e8 36 04 00 00       	call   803212 <free_block>
  802ddc:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ddf:	83 ec 0c             	sub    $0xc,%esp
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	e8 20 fa ff ff       	call   80280a <alloc_block_BF>
  802dea:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ded:	c9                   	leave  
  802dee:	c3                   	ret    

00802def <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802def:	55                   	push   %ebp
  802df0:	89 e5                	mov    %esp,%ebp
  802df2:	53                   	push   %ebx
  802df3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802df6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e08:	74 1e                	je     802e28 <merging+0x39>
  802e0a:	ff 75 08             	pushl  0x8(%ebp)
  802e0d:	e8 bc f1 ff ff       	call   801fce <get_block_size>
  802e12:	83 c4 04             	add    $0x4,%esp
  802e15:	89 c2                	mov    %eax,%edx
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	01 d0                	add    %edx,%eax
  802e1c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e1f:	75 07                	jne    802e28 <merging+0x39>
		prev_is_free = 1;
  802e21:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e2c:	74 1e                	je     802e4c <merging+0x5d>
  802e2e:	ff 75 10             	pushl  0x10(%ebp)
  802e31:	e8 98 f1 ff ff       	call   801fce <get_block_size>
  802e36:	83 c4 04             	add    $0x4,%esp
  802e39:	89 c2                	mov    %eax,%edx
  802e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e3e:	01 d0                	add    %edx,%eax
  802e40:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e43:	75 07                	jne    802e4c <merging+0x5d>
		next_is_free = 1;
  802e45:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	0f 84 cc 00 00 00    	je     802f22 <merging+0x133>
  802e56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5a:	0f 84 c2 00 00 00    	je     802f22 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e60:	ff 75 08             	pushl  0x8(%ebp)
  802e63:	e8 66 f1 ff ff       	call   801fce <get_block_size>
  802e68:	83 c4 04             	add    $0x4,%esp
  802e6b:	89 c3                	mov    %eax,%ebx
  802e6d:	ff 75 10             	pushl  0x10(%ebp)
  802e70:	e8 59 f1 ff ff       	call   801fce <get_block_size>
  802e75:	83 c4 04             	add    $0x4,%esp
  802e78:	01 c3                	add    %eax,%ebx
  802e7a:	ff 75 0c             	pushl  0xc(%ebp)
  802e7d:	e8 4c f1 ff ff       	call   801fce <get_block_size>
  802e82:	83 c4 04             	add    $0x4,%esp
  802e85:	01 d8                	add    %ebx,%eax
  802e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e8a:	6a 00                	push   $0x0
  802e8c:	ff 75 ec             	pushl  -0x14(%ebp)
  802e8f:	ff 75 08             	pushl  0x8(%ebp)
  802e92:	e8 88 f4 ff ff       	call   80231f <set_block_data>
  802e97:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e9e:	75 17                	jne    802eb7 <merging+0xc8>
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 d3 45 80 00       	push   $0x8045d3
  802ea8:	68 7d 01 00 00       	push   $0x17d
  802ead:	68 f1 45 80 00       	push   $0x8045f1
  802eb2:	e8 75 d5 ff ff       	call   80042c <_panic>
  802eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	74 10                	je     802ed0 <merging+0xe1>
  802ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec8:	8b 52 04             	mov    0x4(%edx),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 0b                	jmp    802edb <merging+0xec>
  802ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	a3 30 50 80 00       	mov    %eax,0x805030
  802edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	74 0f                	je     802ef4 <merging+0x105>
  802ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee8:	8b 40 04             	mov    0x4(%eax),%eax
  802eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eee:	8b 12                	mov    (%edx),%edx
  802ef0:	89 10                	mov    %edx,(%eax)
  802ef2:	eb 0a                	jmp    802efe <merging+0x10f>
  802ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f11:	a1 38 50 80 00       	mov    0x805038,%eax
  802f16:	48                   	dec    %eax
  802f17:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f1c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f1d:	e9 ea 02 00 00       	jmp    80320c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f26:	74 3b                	je     802f63 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	ff 75 08             	pushl  0x8(%ebp)
  802f2e:	e8 9b f0 ff ff       	call   801fce <get_block_size>
  802f33:	83 c4 10             	add    $0x10,%esp
  802f36:	89 c3                	mov    %eax,%ebx
  802f38:	83 ec 0c             	sub    $0xc,%esp
  802f3b:	ff 75 10             	pushl  0x10(%ebp)
  802f3e:	e8 8b f0 ff ff       	call   801fce <get_block_size>
  802f43:	83 c4 10             	add    $0x10,%esp
  802f46:	01 d8                	add    %ebx,%eax
  802f48:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	6a 00                	push   $0x0
  802f50:	ff 75 e8             	pushl  -0x18(%ebp)
  802f53:	ff 75 08             	pushl  0x8(%ebp)
  802f56:	e8 c4 f3 ff ff       	call   80231f <set_block_data>
  802f5b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f5e:	e9 a9 02 00 00       	jmp    80320c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f67:	0f 84 2d 01 00 00    	je     80309a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f6d:	83 ec 0c             	sub    $0xc,%esp
  802f70:	ff 75 10             	pushl  0x10(%ebp)
  802f73:	e8 56 f0 ff ff       	call   801fce <get_block_size>
  802f78:	83 c4 10             	add    $0x10,%esp
  802f7b:	89 c3                	mov    %eax,%ebx
  802f7d:	83 ec 0c             	sub    $0xc,%esp
  802f80:	ff 75 0c             	pushl  0xc(%ebp)
  802f83:	e8 46 f0 ff ff       	call   801fce <get_block_size>
  802f88:	83 c4 10             	add    $0x10,%esp
  802f8b:	01 d8                	add    %ebx,%eax
  802f8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	6a 00                	push   $0x0
  802f95:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f98:	ff 75 10             	pushl  0x10(%ebp)
  802f9b:	e8 7f f3 ff ff       	call   80231f <set_block_data>
  802fa0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  802fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802fa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fad:	74 06                	je     802fb5 <merging+0x1c6>
  802faf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fb3:	75 17                	jne    802fcc <merging+0x1dd>
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	68 ac 46 80 00       	push   $0x8046ac
  802fbd:	68 8d 01 00 00       	push   $0x18d
  802fc2:	68 f1 45 80 00       	push   $0x8045f1
  802fc7:	e8 60 d4 ff ff       	call   80042c <_panic>
  802fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcf:	8b 50 04             	mov    0x4(%eax),%edx
  802fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fde:	89 10                	mov    %edx,(%eax)
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 0d                	je     802ff7 <merging+0x208>
  802fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	eb 08                	jmp    802fff <merging+0x210>
  802ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803002:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	a1 38 50 80 00       	mov    0x805038,%eax
  80300d:	40                   	inc    %eax
  80300e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803013:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803017:	75 17                	jne    803030 <merging+0x241>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 d3 45 80 00       	push   $0x8045d3
  803021:	68 8e 01 00 00       	push   $0x18e
  803026:	68 f1 45 80 00       	push   $0x8045f1
  80302b:	e8 fc d3 ff ff       	call   80042c <_panic>
  803030:	8b 45 0c             	mov    0xc(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 10                	je     803049 <merging+0x25a>
  803039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803041:	8b 52 04             	mov    0x4(%edx),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 0b                	jmp    803054 <merging+0x265>
  803049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	a3 30 50 80 00       	mov    %eax,0x805030
  803054:	8b 45 0c             	mov    0xc(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0f                	je     80306d <merging+0x27e>
  80305e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	8b 55 0c             	mov    0xc(%ebp),%edx
  803067:	8b 12                	mov    (%edx),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 0a                	jmp    803077 <merging+0x288>
  80306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803080:	8b 45 0c             	mov    0xc(%ebp),%eax
  803083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308a:	a1 38 50 80 00       	mov    0x805038,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803095:	e9 72 01 00 00       	jmp    80320c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80309a:	8b 45 10             	mov    0x10(%ebp),%eax
  80309d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a4:	74 79                	je     80311f <merging+0x330>
  8030a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030aa:	74 73                	je     80311f <merging+0x330>
  8030ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b0:	74 06                	je     8030b8 <merging+0x2c9>
  8030b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030b6:	75 17                	jne    8030cf <merging+0x2e0>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 64 46 80 00       	push   $0x804664
  8030c0:	68 94 01 00 00       	push   $0x194
  8030c5:	68 f1 45 80 00       	push   $0x8045f1
  8030ca:	e8 5d d3 ff ff       	call   80042c <_panic>
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 10                	mov    (%eax),%edx
  8030d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0b                	je     8030ed <merging+0x2fe>
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fb:	89 50 04             	mov    %edx,0x4(%eax)
  8030fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	75 08                	jne    80310f <merging+0x320>
  803107:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310a:	a3 30 50 80 00       	mov    %eax,0x805030
  80310f:	a1 38 50 80 00       	mov    0x805038,%eax
  803114:	40                   	inc    %eax
  803115:	a3 38 50 80 00       	mov    %eax,0x805038
  80311a:	e9 ce 00 00 00       	jmp    8031ed <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80311f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803123:	74 65                	je     80318a <merging+0x39b>
  803125:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803129:	75 17                	jne    803142 <merging+0x353>
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	68 40 46 80 00       	push   $0x804640
  803133:	68 95 01 00 00       	push   $0x195
  803138:	68 f1 45 80 00       	push   $0x8045f1
  80313d:	e8 ea d2 ff ff       	call   80042c <_panic>
  803142:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803148:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314b:	89 50 04             	mov    %edx,0x4(%eax)
  80314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	74 0c                	je     803164 <merging+0x375>
  803158:	a1 30 50 80 00       	mov    0x805030,%eax
  80315d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803160:	89 10                	mov    %edx,(%eax)
  803162:	eb 08                	jmp    80316c <merging+0x37d>
  803164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803167:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80316c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316f:	a3 30 50 80 00       	mov    %eax,0x805030
  803174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317d:	a1 38 50 80 00       	mov    0x805038,%eax
  803182:	40                   	inc    %eax
  803183:	a3 38 50 80 00       	mov    %eax,0x805038
  803188:	eb 63                	jmp    8031ed <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80318a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80318e:	75 17                	jne    8031a7 <merging+0x3b8>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 0c 46 80 00       	push   $0x80460c
  803198:	68 98 01 00 00       	push   $0x198
  80319d:	68 f1 45 80 00       	push   $0x8045f1
  8031a2:	e8 85 d2 ff ff       	call   80042c <_panic>
  8031a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b0:	89 10                	mov    %edx,(%eax)
  8031b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	74 0d                	je     8031c8 <merging+0x3d9>
  8031bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	eb 08                	jmp    8031d0 <merging+0x3e1>
  8031c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e7:	40                   	inc    %eax
  8031e8:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031ed:	83 ec 0c             	sub    $0xc,%esp
  8031f0:	ff 75 10             	pushl  0x10(%ebp)
  8031f3:	e8 d6 ed ff ff       	call   801fce <get_block_size>
  8031f8:	83 c4 10             	add    $0x10,%esp
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	6a 00                	push   $0x0
  803200:	50                   	push   %eax
  803201:	ff 75 10             	pushl  0x10(%ebp)
  803204:	e8 16 f1 ff ff       	call   80231f <set_block_data>
  803209:	83 c4 10             	add    $0x10,%esp
	}
}
  80320c:	90                   	nop
  80320d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803210:	c9                   	leave  
  803211:	c3                   	ret    

00803212 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803212:	55                   	push   %ebp
  803213:	89 e5                	mov    %esp,%ebp
  803215:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803218:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803220:	a1 30 50 80 00       	mov    0x805030,%eax
  803225:	3b 45 08             	cmp    0x8(%ebp),%eax
  803228:	73 1b                	jae    803245 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80322a:	a1 30 50 80 00       	mov    0x805030,%eax
  80322f:	83 ec 04             	sub    $0x4,%esp
  803232:	ff 75 08             	pushl  0x8(%ebp)
  803235:	6a 00                	push   $0x0
  803237:	50                   	push   %eax
  803238:	e8 b2 fb ff ff       	call   802def <merging>
  80323d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803240:	e9 8b 00 00 00       	jmp    8032d0 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803245:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80324a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324d:	76 18                	jbe    803267 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80324f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	ff 75 08             	pushl  0x8(%ebp)
  80325a:	50                   	push   %eax
  80325b:	6a 00                	push   $0x0
  80325d:	e8 8d fb ff ff       	call   802def <merging>
  803262:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803265:	eb 69                	jmp    8032d0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803267:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80326c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326f:	eb 39                	jmp    8032aa <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	3b 45 08             	cmp    0x8(%ebp),%eax
  803277:	73 29                	jae    8032a2 <free_block+0x90>
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803281:	76 1f                	jbe    8032a2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	ff 75 08             	pushl  0x8(%ebp)
  803291:	ff 75 f0             	pushl  -0x10(%ebp)
  803294:	ff 75 f4             	pushl  -0xc(%ebp)
  803297:	e8 53 fb ff ff       	call   802def <merging>
  80329c:	83 c4 10             	add    $0x10,%esp
			break;
  80329f:	90                   	nop
		}
	}
}
  8032a0:	eb 2e                	jmp    8032d0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8032a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ae:	74 07                	je     8032b7 <free_block+0xa5>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	eb 05                	jmp    8032bc <free_block+0xaa>
  8032b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c1:	a1 34 50 80 00       	mov    0x805034,%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	75 a7                	jne    803271 <free_block+0x5f>
  8032ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ce:	75 a1                	jne    803271 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032d0:	90                   	nop
  8032d1:	c9                   	leave  
  8032d2:	c3                   	ret    

008032d3 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032d3:	55                   	push   %ebp
  8032d4:	89 e5                	mov    %esp,%ebp
  8032d6:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032d9:	ff 75 08             	pushl  0x8(%ebp)
  8032dc:	e8 ed ec ff ff       	call   801fce <get_block_size>
  8032e1:	83 c4 04             	add    $0x4,%esp
  8032e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032ee:	eb 17                	jmp    803307 <copy_data+0x34>
  8032f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f6:	01 c2                	add    %eax,%edx
  8032f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	01 c8                	add    %ecx,%eax
  803300:	8a 00                	mov    (%eax),%al
  803302:	88 02                	mov    %al,(%edx)
  803304:	ff 45 fc             	incl   -0x4(%ebp)
  803307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80330a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80330d:	72 e1                	jb     8032f0 <copy_data+0x1d>
}
  80330f:	90                   	nop
  803310:	c9                   	leave  
  803311:	c3                   	ret    

00803312 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803312:	55                   	push   %ebp
  803313:	89 e5                	mov    %esp,%ebp
  803315:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803318:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331c:	75 23                	jne    803341 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80331e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803322:	74 13                	je     803337 <realloc_block_FF+0x25>
  803324:	83 ec 0c             	sub    $0xc,%esp
  803327:	ff 75 0c             	pushl  0xc(%ebp)
  80332a:	e8 1f f0 ff ff       	call   80234e <alloc_block_FF>
  80332f:	83 c4 10             	add    $0x10,%esp
  803332:	e9 f4 06 00 00       	jmp    803a2b <realloc_block_FF+0x719>
		return NULL;
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
  80333c:	e9 ea 06 00 00       	jmp    803a2b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803341:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803345:	75 18                	jne    80335f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803347:	83 ec 0c             	sub    $0xc,%esp
  80334a:	ff 75 08             	pushl  0x8(%ebp)
  80334d:	e8 c0 fe ff ff       	call   803212 <free_block>
  803352:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803355:	b8 00 00 00 00       	mov    $0x0,%eax
  80335a:	e9 cc 06 00 00       	jmp    803a2b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80335f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803363:	77 07                	ja     80336c <realloc_block_FF+0x5a>
  803365:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336f:	83 e0 01             	and    $0x1,%eax
  803372:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803375:	8b 45 0c             	mov    0xc(%ebp),%eax
  803378:	83 c0 08             	add    $0x8,%eax
  80337b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80337e:	83 ec 0c             	sub    $0xc,%esp
  803381:	ff 75 08             	pushl  0x8(%ebp)
  803384:	e8 45 ec ff ff       	call   801fce <get_block_size>
  803389:	83 c4 10             	add    $0x10,%esp
  80338c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80338f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803392:	83 e8 08             	sub    $0x8,%eax
  803395:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	83 e8 04             	sub    $0x4,%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a3:	89 c2                	mov    %eax,%edx
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	01 d0                	add    %edx,%eax
  8033aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033b3:	e8 16 ec ff ff       	call   801fce <get_block_size>
  8033b8:	83 c4 10             	add    $0x10,%esp
  8033bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c1:	83 e8 08             	sub    $0x8,%eax
  8033c4:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033cd:	75 08                	jne    8033d7 <realloc_block_FF+0xc5>
	{
		 return va;
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	e9 54 06 00 00       	jmp    803a2b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033da:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033dd:	0f 83 e5 03 00 00    	jae    8037c8 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033ec:	83 ec 0c             	sub    $0xc,%esp
  8033ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033f2:	e8 f0 eb ff ff       	call   801fe7 <is_free_block>
  8033f7:	83 c4 10             	add    $0x10,%esp
  8033fa:	84 c0                	test   %al,%al
  8033fc:	0f 84 3b 01 00 00    	je     80353d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803402:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803405:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803408:	01 d0                	add    %edx,%eax
  80340a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	6a 01                	push   $0x1
  803412:	ff 75 f0             	pushl  -0x10(%ebp)
  803415:	ff 75 08             	pushl  0x8(%ebp)
  803418:	e8 02 ef ff ff       	call   80231f <set_block_data>
  80341d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	83 e8 04             	sub    $0x4,%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	83 e0 fe             	and    $0xfffffffe,%eax
  80342b:	89 c2                	mov    %eax,%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	01 d0                	add    %edx,%eax
  803432:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	6a 00                	push   $0x0
  80343a:	ff 75 cc             	pushl  -0x34(%ebp)
  80343d:	ff 75 c8             	pushl  -0x38(%ebp)
  803440:	e8 da ee ff ff       	call   80231f <set_block_data>
  803445:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803448:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80344c:	74 06                	je     803454 <realloc_block_FF+0x142>
  80344e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803452:	75 17                	jne    80346b <realloc_block_FF+0x159>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 64 46 80 00       	push   $0x804664
  80345c:	68 f6 01 00 00       	push   $0x1f6
  803461:	68 f1 45 80 00       	push   $0x8045f1
  803466:	e8 c1 cf ff ff       	call   80042c <_panic>
  80346b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346e:	8b 10                	mov    (%eax),%edx
  803470:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	74 0b                	je     803489 <realloc_block_FF+0x177>
  80347e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80348f:	89 10                	mov    %edx,(%eax)
  803491:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803494:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803497:	89 50 04             	mov    %edx,0x4(%eax)
  80349a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	85 c0                	test   %eax,%eax
  8034a1:	75 08                	jne    8034ab <realloc_block_FF+0x199>
  8034a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b0:	40                   	inc    %eax
  8034b1:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034ba:	75 17                	jne    8034d3 <realloc_block_FF+0x1c1>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 d3 45 80 00       	push   $0x8045d3
  8034c4:	68 f7 01 00 00       	push   $0x1f7
  8034c9:	68 f1 45 80 00       	push   $0x8045f1
  8034ce:	e8 59 cf ff ff       	call   80042c <_panic>
  8034d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 10                	je     8034ec <realloc_block_FF+0x1da>
  8034dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e4:	8b 52 04             	mov    0x4(%edx),%edx
  8034e7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ea:	eb 0b                	jmp    8034f7 <realloc_block_FF+0x1e5>
  8034ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ef:	8b 40 04             	mov    0x4(%eax),%eax
  8034f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	8b 40 04             	mov    0x4(%eax),%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	74 0f                	je     803510 <realloc_block_FF+0x1fe>
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80350a:	8b 12                	mov    (%edx),%edx
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	eb 0a                	jmp    80351a <realloc_block_FF+0x208>
  803510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80351a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352d:	a1 38 50 80 00       	mov    0x805038,%eax
  803532:	48                   	dec    %eax
  803533:	a3 38 50 80 00       	mov    %eax,0x805038
  803538:	e9 83 02 00 00       	jmp    8037c0 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80353d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803541:	0f 86 69 02 00 00    	jbe    8037b0 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	6a 01                	push   $0x1
  80354c:	ff 75 f0             	pushl  -0x10(%ebp)
  80354f:	ff 75 08             	pushl  0x8(%ebp)
  803552:	e8 c8 ed ff ff       	call   80231f <set_block_data>
  803557:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	83 e8 04             	sub    $0x4,%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	83 e0 fe             	and    $0xfffffffe,%eax
  803565:	89 c2                	mov    %eax,%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	01 d0                	add    %edx,%eax
  80356c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80356f:	a1 38 50 80 00       	mov    0x805038,%eax
  803574:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803577:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80357b:	75 68                	jne    8035e5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80357d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803581:	75 17                	jne    80359a <realloc_block_FF+0x288>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 0c 46 80 00       	push   $0x80460c
  80358b:	68 06 02 00 00       	push   $0x206
  803590:	68 f1 45 80 00       	push   $0x8045f1
  803595:	e8 92 ce ff ff       	call   80042c <_panic>
  80359a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	89 10                	mov    %edx,(%eax)
  8035a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	74 0d                	je     8035bb <realloc_block_FF+0x2a9>
  8035ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	eb 08                	jmp    8035c3 <realloc_block_FF+0x2b1>
  8035bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035be:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8035da:	40                   	inc    %eax
  8035db:	a3 38 50 80 00       	mov    %eax,0x805038
  8035e0:	e9 b0 01 00 00       	jmp    803795 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ed:	76 68                	jbe    803657 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035f3:	75 17                	jne    80360c <realloc_block_FF+0x2fa>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 0c 46 80 00       	push   $0x80460c
  8035fd:	68 0b 02 00 00       	push   $0x20b
  803602:	68 f1 45 80 00       	push   $0x8045f1
  803607:	e8 20 ce ff ff       	call   80042c <_panic>
  80360c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	89 10                	mov    %edx,(%eax)
  803617:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	74 0d                	je     80362d <realloc_block_FF+0x31b>
  803620:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803625:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803628:	89 50 04             	mov    %edx,0x4(%eax)
  80362b:	eb 08                	jmp    803635 <realloc_block_FF+0x323>
  80362d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803630:	a3 30 50 80 00       	mov    %eax,0x805030
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803640:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803647:	a1 38 50 80 00       	mov    0x805038,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 38 50 80 00       	mov    %eax,0x805038
  803652:	e9 3e 01 00 00       	jmp    803795 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803657:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80365c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80365f:	73 68                	jae    8036c9 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803661:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803665:	75 17                	jne    80367e <realloc_block_FF+0x36c>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 40 46 80 00       	push   $0x804640
  80366f:	68 10 02 00 00       	push   $0x210
  803674:	68 f1 45 80 00       	push   $0x8045f1
  803679:	e8 ae cd ff ff       	call   80042c <_panic>
  80367e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0c                	je     8036a0 <realloc_block_FF+0x38e>
  803694:	a1 30 50 80 00       	mov    0x805030,%eax
  803699:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	eb 08                	jmp    8036a8 <realloc_block_FF+0x396>
  8036a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8036be:	40                   	inc    %eax
  8036bf:	a3 38 50 80 00       	mov    %eax,0x805038
  8036c4:	e9 cc 00 00 00       	jmp    803795 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d8:	e9 8a 00 00 00       	jmp    803767 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e3:	73 7a                	jae    80375f <realloc_block_FF+0x44d>
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 00                	mov    (%eax),%eax
  8036ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ed:	73 70                	jae    80375f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f3:	74 06                	je     8036fb <realloc_block_FF+0x3e9>
  8036f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036f9:	75 17                	jne    803712 <realloc_block_FF+0x400>
  8036fb:	83 ec 04             	sub    $0x4,%esp
  8036fe:	68 64 46 80 00       	push   $0x804664
  803703:	68 1a 02 00 00       	push   $0x21a
  803708:	68 f1 45 80 00       	push   $0x8045f1
  80370d:	e8 1a cd ff ff       	call   80042c <_panic>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 10                	mov    (%eax),%edx
  803717:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0b                	je     803730 <realloc_block_FF+0x41e>
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80372d:	89 50 04             	mov    %edx,0x4(%eax)
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803736:	89 10                	mov    %edx,(%eax)
  803738:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80373e:	89 50 04             	mov    %edx,0x4(%eax)
  803741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	75 08                	jne    803752 <realloc_block_FF+0x440>
  80374a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374d:	a3 30 50 80 00       	mov    %eax,0x805030
  803752:	a1 38 50 80 00       	mov    0x805038,%eax
  803757:	40                   	inc    %eax
  803758:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80375d:	eb 36                	jmp    803795 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80375f:	a1 34 50 80 00       	mov    0x805034,%eax
  803764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376b:	74 07                	je     803774 <realloc_block_FF+0x462>
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	eb 05                	jmp    803779 <realloc_block_FF+0x467>
  803774:	b8 00 00 00 00       	mov    $0x0,%eax
  803779:	a3 34 50 80 00       	mov    %eax,0x805034
  80377e:	a1 34 50 80 00       	mov    0x805034,%eax
  803783:	85 c0                	test   %eax,%eax
  803785:	0f 85 52 ff ff ff    	jne    8036dd <realloc_block_FF+0x3cb>
  80378b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378f:	0f 85 48 ff ff ff    	jne    8036dd <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803795:	83 ec 04             	sub    $0x4,%esp
  803798:	6a 00                	push   $0x0
  80379a:	ff 75 d8             	pushl  -0x28(%ebp)
  80379d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037a0:	e8 7a eb ff ff       	call   80231f <set_block_data>
  8037a5:	83 c4 10             	add    $0x10,%esp
				return va;
  8037a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ab:	e9 7b 02 00 00       	jmp    803a2b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	68 e1 46 80 00       	push   $0x8046e1
  8037b8:	e8 2c cf ff ff       	call   8006e9 <cprintf>
  8037bd:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	e9 63 02 00 00       	jmp    803a2b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037ce:	0f 86 4d 02 00 00    	jbe    803a21 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037d4:	83 ec 0c             	sub    $0xc,%esp
  8037d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037da:	e8 08 e8 ff ff       	call   801fe7 <is_free_block>
  8037df:	83 c4 10             	add    $0x10,%esp
  8037e2:	84 c0                	test   %al,%al
  8037e4:	0f 84 37 02 00 00    	je     803a21 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037f9:	76 38                	jbe    803833 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037fb:	83 ec 0c             	sub    $0xc,%esp
  8037fe:	ff 75 08             	pushl  0x8(%ebp)
  803801:	e8 0c fa ff ff       	call   803212 <free_block>
  803806:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803809:	83 ec 0c             	sub    $0xc,%esp
  80380c:	ff 75 0c             	pushl  0xc(%ebp)
  80380f:	e8 3a eb ff ff       	call   80234e <alloc_block_FF>
  803814:	83 c4 10             	add    $0x10,%esp
  803817:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80381a:	83 ec 08             	sub    $0x8,%esp
  80381d:	ff 75 c0             	pushl  -0x40(%ebp)
  803820:	ff 75 08             	pushl  0x8(%ebp)
  803823:	e8 ab fa ff ff       	call   8032d3 <copy_data>
  803828:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80382b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80382e:	e9 f8 01 00 00       	jmp    803a2b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803833:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803836:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803839:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80383c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803840:	0f 87 a0 00 00 00    	ja     8038e6 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80384a:	75 17                	jne    803863 <realloc_block_FF+0x551>
  80384c:	83 ec 04             	sub    $0x4,%esp
  80384f:	68 d3 45 80 00       	push   $0x8045d3
  803854:	68 38 02 00 00       	push   $0x238
  803859:	68 f1 45 80 00       	push   $0x8045f1
  80385e:	e8 c9 cb ff ff       	call   80042c <_panic>
  803863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	85 c0                	test   %eax,%eax
  80386a:	74 10                	je     80387c <realloc_block_FF+0x56a>
  80386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386f:	8b 00                	mov    (%eax),%eax
  803871:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803874:	8b 52 04             	mov    0x4(%edx),%edx
  803877:	89 50 04             	mov    %edx,0x4(%eax)
  80387a:	eb 0b                	jmp    803887 <realloc_block_FF+0x575>
  80387c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	a3 30 50 80 00       	mov    %eax,0x805030
  803887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	74 0f                	je     8038a0 <realloc_block_FF+0x58e>
  803891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803894:	8b 40 04             	mov    0x4(%eax),%eax
  803897:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389a:	8b 12                	mov    (%edx),%edx
  80389c:	89 10                	mov    %edx,(%eax)
  80389e:	eb 0a                	jmp    8038aa <realloc_block_FF+0x598>
  8038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c2:	48                   	dec    %eax
  8038c3:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ce:	01 d0                	add    %edx,%eax
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	6a 01                	push   $0x1
  8038d5:	50                   	push   %eax
  8038d6:	ff 75 08             	pushl  0x8(%ebp)
  8038d9:	e8 41 ea ff ff       	call   80231f <set_block_data>
  8038de:	83 c4 10             	add    $0x10,%esp
  8038e1:	e9 36 01 00 00       	jmp    803a1c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ec:	01 d0                	add    %edx,%eax
  8038ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038f1:	83 ec 04             	sub    $0x4,%esp
  8038f4:	6a 01                	push   $0x1
  8038f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f9:	ff 75 08             	pushl  0x8(%ebp)
  8038fc:	e8 1e ea ff ff       	call   80231f <set_block_data>
  803901:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	83 e8 04             	sub    $0x4,%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	83 e0 fe             	and    $0xfffffffe,%eax
  80390f:	89 c2                	mov    %eax,%edx
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	01 d0                	add    %edx,%eax
  803916:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80391d:	74 06                	je     803925 <realloc_block_FF+0x613>
  80391f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803923:	75 17                	jne    80393c <realloc_block_FF+0x62a>
  803925:	83 ec 04             	sub    $0x4,%esp
  803928:	68 64 46 80 00       	push   $0x804664
  80392d:	68 44 02 00 00       	push   $0x244
  803932:	68 f1 45 80 00       	push   $0x8045f1
  803937:	e8 f0 ca ff ff       	call   80042c <_panic>
  80393c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393f:	8b 10                	mov    (%eax),%edx
  803941:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803944:	89 10                	mov    %edx,(%eax)
  803946:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	74 0b                	je     80395a <realloc_block_FF+0x648>
  80394f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803957:	89 50 04             	mov    %edx,0x4(%eax)
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803960:	89 10                	mov    %edx,(%eax)
  803962:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803968:	89 50 04             	mov    %edx,0x4(%eax)
  80396b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	75 08                	jne    80397c <realloc_block_FF+0x66a>
  803974:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803977:	a3 30 50 80 00       	mov    %eax,0x805030
  80397c:	a1 38 50 80 00       	mov    0x805038,%eax
  803981:	40                   	inc    %eax
  803982:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803987:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398b:	75 17                	jne    8039a4 <realloc_block_FF+0x692>
  80398d:	83 ec 04             	sub    $0x4,%esp
  803990:	68 d3 45 80 00       	push   $0x8045d3
  803995:	68 45 02 00 00       	push   $0x245
  80399a:	68 f1 45 80 00       	push   $0x8045f1
  80399f:	e8 88 ca ff ff       	call   80042c <_panic>
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 10                	je     8039bd <realloc_block_FF+0x6ab>
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	8b 00                	mov    (%eax),%eax
  8039b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b5:	8b 52 04             	mov    0x4(%edx),%edx
  8039b8:	89 50 04             	mov    %edx,0x4(%eax)
  8039bb:	eb 0b                	jmp    8039c8 <realloc_block_FF+0x6b6>
  8039bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8039c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 0f                	je     8039e1 <realloc_block_FF+0x6cf>
  8039d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d5:	8b 40 04             	mov    0x4(%eax),%eax
  8039d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039db:	8b 12                	mov    (%edx),%edx
  8039dd:	89 10                	mov    %edx,(%eax)
  8039df:	eb 0a                	jmp    8039eb <realloc_block_FF+0x6d9>
  8039e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803a03:	48                   	dec    %eax
  803a04:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a09:	83 ec 04             	sub    $0x4,%esp
  803a0c:	6a 00                	push   $0x0
  803a0e:	ff 75 bc             	pushl  -0x44(%ebp)
  803a11:	ff 75 b8             	pushl  -0x48(%ebp)
  803a14:	e8 06 e9 ff ff       	call   80231f <set_block_data>
  803a19:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1f:	eb 0a                	jmp    803a2b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a21:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a2b:	c9                   	leave  
  803a2c:	c3                   	ret    

00803a2d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a2d:	55                   	push   %ebp
  803a2e:	89 e5                	mov    %esp,%ebp
  803a30:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a33:	83 ec 04             	sub    $0x4,%esp
  803a36:	68 e8 46 80 00       	push   $0x8046e8
  803a3b:	68 58 02 00 00       	push   $0x258
  803a40:	68 f1 45 80 00       	push   $0x8045f1
  803a45:	e8 e2 c9 ff ff       	call   80042c <_panic>

00803a4a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a4a:	55                   	push   %ebp
  803a4b:	89 e5                	mov    %esp,%ebp
  803a4d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 10 47 80 00       	push   $0x804710
  803a58:	68 61 02 00 00       	push   $0x261
  803a5d:	68 f1 45 80 00       	push   $0x8045f1
  803a62:	e8 c5 c9 ff ff       	call   80042c <_panic>
  803a67:	90                   	nop

00803a68 <__udivdi3>:
  803a68:	55                   	push   %ebp
  803a69:	57                   	push   %edi
  803a6a:	56                   	push   %esi
  803a6b:	53                   	push   %ebx
  803a6c:	83 ec 1c             	sub    $0x1c,%esp
  803a6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a7f:	89 ca                	mov    %ecx,%edx
  803a81:	89 f8                	mov    %edi,%eax
  803a83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a87:	85 f6                	test   %esi,%esi
  803a89:	75 2d                	jne    803ab8 <__udivdi3+0x50>
  803a8b:	39 cf                	cmp    %ecx,%edi
  803a8d:	77 65                	ja     803af4 <__udivdi3+0x8c>
  803a8f:	89 fd                	mov    %edi,%ebp
  803a91:	85 ff                	test   %edi,%edi
  803a93:	75 0b                	jne    803aa0 <__udivdi3+0x38>
  803a95:	b8 01 00 00 00       	mov    $0x1,%eax
  803a9a:	31 d2                	xor    %edx,%edx
  803a9c:	f7 f7                	div    %edi
  803a9e:	89 c5                	mov    %eax,%ebp
  803aa0:	31 d2                	xor    %edx,%edx
  803aa2:	89 c8                	mov    %ecx,%eax
  803aa4:	f7 f5                	div    %ebp
  803aa6:	89 c1                	mov    %eax,%ecx
  803aa8:	89 d8                	mov    %ebx,%eax
  803aaa:	f7 f5                	div    %ebp
  803aac:	89 cf                	mov    %ecx,%edi
  803aae:	89 fa                	mov    %edi,%edx
  803ab0:	83 c4 1c             	add    $0x1c,%esp
  803ab3:	5b                   	pop    %ebx
  803ab4:	5e                   	pop    %esi
  803ab5:	5f                   	pop    %edi
  803ab6:	5d                   	pop    %ebp
  803ab7:	c3                   	ret    
  803ab8:	39 ce                	cmp    %ecx,%esi
  803aba:	77 28                	ja     803ae4 <__udivdi3+0x7c>
  803abc:	0f bd fe             	bsr    %esi,%edi
  803abf:	83 f7 1f             	xor    $0x1f,%edi
  803ac2:	75 40                	jne    803b04 <__udivdi3+0x9c>
  803ac4:	39 ce                	cmp    %ecx,%esi
  803ac6:	72 0a                	jb     803ad2 <__udivdi3+0x6a>
  803ac8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803acc:	0f 87 9e 00 00 00    	ja     803b70 <__udivdi3+0x108>
  803ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ad7:	89 fa                	mov    %edi,%edx
  803ad9:	83 c4 1c             	add    $0x1c,%esp
  803adc:	5b                   	pop    %ebx
  803add:	5e                   	pop    %esi
  803ade:	5f                   	pop    %edi
  803adf:	5d                   	pop    %ebp
  803ae0:	c3                   	ret    
  803ae1:	8d 76 00             	lea    0x0(%esi),%esi
  803ae4:	31 ff                	xor    %edi,%edi
  803ae6:	31 c0                	xor    %eax,%eax
  803ae8:	89 fa                	mov    %edi,%edx
  803aea:	83 c4 1c             	add    $0x1c,%esp
  803aed:	5b                   	pop    %ebx
  803aee:	5e                   	pop    %esi
  803aef:	5f                   	pop    %edi
  803af0:	5d                   	pop    %ebp
  803af1:	c3                   	ret    
  803af2:	66 90                	xchg   %ax,%ax
  803af4:	89 d8                	mov    %ebx,%eax
  803af6:	f7 f7                	div    %edi
  803af8:	31 ff                	xor    %edi,%edi
  803afa:	89 fa                	mov    %edi,%edx
  803afc:	83 c4 1c             	add    $0x1c,%esp
  803aff:	5b                   	pop    %ebx
  803b00:	5e                   	pop    %esi
  803b01:	5f                   	pop    %edi
  803b02:	5d                   	pop    %ebp
  803b03:	c3                   	ret    
  803b04:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b09:	89 eb                	mov    %ebp,%ebx
  803b0b:	29 fb                	sub    %edi,%ebx
  803b0d:	89 f9                	mov    %edi,%ecx
  803b0f:	d3 e6                	shl    %cl,%esi
  803b11:	89 c5                	mov    %eax,%ebp
  803b13:	88 d9                	mov    %bl,%cl
  803b15:	d3 ed                	shr    %cl,%ebp
  803b17:	89 e9                	mov    %ebp,%ecx
  803b19:	09 f1                	or     %esi,%ecx
  803b1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b1f:	89 f9                	mov    %edi,%ecx
  803b21:	d3 e0                	shl    %cl,%eax
  803b23:	89 c5                	mov    %eax,%ebp
  803b25:	89 d6                	mov    %edx,%esi
  803b27:	88 d9                	mov    %bl,%cl
  803b29:	d3 ee                	shr    %cl,%esi
  803b2b:	89 f9                	mov    %edi,%ecx
  803b2d:	d3 e2                	shl    %cl,%edx
  803b2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b33:	88 d9                	mov    %bl,%cl
  803b35:	d3 e8                	shr    %cl,%eax
  803b37:	09 c2                	or     %eax,%edx
  803b39:	89 d0                	mov    %edx,%eax
  803b3b:	89 f2                	mov    %esi,%edx
  803b3d:	f7 74 24 0c          	divl   0xc(%esp)
  803b41:	89 d6                	mov    %edx,%esi
  803b43:	89 c3                	mov    %eax,%ebx
  803b45:	f7 e5                	mul    %ebp
  803b47:	39 d6                	cmp    %edx,%esi
  803b49:	72 19                	jb     803b64 <__udivdi3+0xfc>
  803b4b:	74 0b                	je     803b58 <__udivdi3+0xf0>
  803b4d:	89 d8                	mov    %ebx,%eax
  803b4f:	31 ff                	xor    %edi,%edi
  803b51:	e9 58 ff ff ff       	jmp    803aae <__udivdi3+0x46>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b5c:	89 f9                	mov    %edi,%ecx
  803b5e:	d3 e2                	shl    %cl,%edx
  803b60:	39 c2                	cmp    %eax,%edx
  803b62:	73 e9                	jae    803b4d <__udivdi3+0xe5>
  803b64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b67:	31 ff                	xor    %edi,%edi
  803b69:	e9 40 ff ff ff       	jmp    803aae <__udivdi3+0x46>
  803b6e:	66 90                	xchg   %ax,%ax
  803b70:	31 c0                	xor    %eax,%eax
  803b72:	e9 37 ff ff ff       	jmp    803aae <__udivdi3+0x46>
  803b77:	90                   	nop

00803b78 <__umoddi3>:
  803b78:	55                   	push   %ebp
  803b79:	57                   	push   %edi
  803b7a:	56                   	push   %esi
  803b7b:	53                   	push   %ebx
  803b7c:	83 ec 1c             	sub    $0x1c,%esp
  803b7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b83:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b97:	89 f3                	mov    %esi,%ebx
  803b99:	89 fa                	mov    %edi,%edx
  803b9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b9f:	89 34 24             	mov    %esi,(%esp)
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	75 1a                	jne    803bc0 <__umoddi3+0x48>
  803ba6:	39 f7                	cmp    %esi,%edi
  803ba8:	0f 86 a2 00 00 00    	jbe    803c50 <__umoddi3+0xd8>
  803bae:	89 c8                	mov    %ecx,%eax
  803bb0:	89 f2                	mov    %esi,%edx
  803bb2:	f7 f7                	div    %edi
  803bb4:	89 d0                	mov    %edx,%eax
  803bb6:	31 d2                	xor    %edx,%edx
  803bb8:	83 c4 1c             	add    $0x1c,%esp
  803bbb:	5b                   	pop    %ebx
  803bbc:	5e                   	pop    %esi
  803bbd:	5f                   	pop    %edi
  803bbe:	5d                   	pop    %ebp
  803bbf:	c3                   	ret    
  803bc0:	39 f0                	cmp    %esi,%eax
  803bc2:	0f 87 ac 00 00 00    	ja     803c74 <__umoddi3+0xfc>
  803bc8:	0f bd e8             	bsr    %eax,%ebp
  803bcb:	83 f5 1f             	xor    $0x1f,%ebp
  803bce:	0f 84 ac 00 00 00    	je     803c80 <__umoddi3+0x108>
  803bd4:	bf 20 00 00 00       	mov    $0x20,%edi
  803bd9:	29 ef                	sub    %ebp,%edi
  803bdb:	89 fe                	mov    %edi,%esi
  803bdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803be1:	89 e9                	mov    %ebp,%ecx
  803be3:	d3 e0                	shl    %cl,%eax
  803be5:	89 d7                	mov    %edx,%edi
  803be7:	89 f1                	mov    %esi,%ecx
  803be9:	d3 ef                	shr    %cl,%edi
  803beb:	09 c7                	or     %eax,%edi
  803bed:	89 e9                	mov    %ebp,%ecx
  803bef:	d3 e2                	shl    %cl,%edx
  803bf1:	89 14 24             	mov    %edx,(%esp)
  803bf4:	89 d8                	mov    %ebx,%eax
  803bf6:	d3 e0                	shl    %cl,%eax
  803bf8:	89 c2                	mov    %eax,%edx
  803bfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bfe:	d3 e0                	shl    %cl,%eax
  803c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c08:	89 f1                	mov    %esi,%ecx
  803c0a:	d3 e8                	shr    %cl,%eax
  803c0c:	09 d0                	or     %edx,%eax
  803c0e:	d3 eb                	shr    %cl,%ebx
  803c10:	89 da                	mov    %ebx,%edx
  803c12:	f7 f7                	div    %edi
  803c14:	89 d3                	mov    %edx,%ebx
  803c16:	f7 24 24             	mull   (%esp)
  803c19:	89 c6                	mov    %eax,%esi
  803c1b:	89 d1                	mov    %edx,%ecx
  803c1d:	39 d3                	cmp    %edx,%ebx
  803c1f:	0f 82 87 00 00 00    	jb     803cac <__umoddi3+0x134>
  803c25:	0f 84 91 00 00 00    	je     803cbc <__umoddi3+0x144>
  803c2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c2f:	29 f2                	sub    %esi,%edx
  803c31:	19 cb                	sbb    %ecx,%ebx
  803c33:	89 d8                	mov    %ebx,%eax
  803c35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c39:	d3 e0                	shl    %cl,%eax
  803c3b:	89 e9                	mov    %ebp,%ecx
  803c3d:	d3 ea                	shr    %cl,%edx
  803c3f:	09 d0                	or     %edx,%eax
  803c41:	89 e9                	mov    %ebp,%ecx
  803c43:	d3 eb                	shr    %cl,%ebx
  803c45:	89 da                	mov    %ebx,%edx
  803c47:	83 c4 1c             	add    $0x1c,%esp
  803c4a:	5b                   	pop    %ebx
  803c4b:	5e                   	pop    %esi
  803c4c:	5f                   	pop    %edi
  803c4d:	5d                   	pop    %ebp
  803c4e:	c3                   	ret    
  803c4f:	90                   	nop
  803c50:	89 fd                	mov    %edi,%ebp
  803c52:	85 ff                	test   %edi,%edi
  803c54:	75 0b                	jne    803c61 <__umoddi3+0xe9>
  803c56:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5b:	31 d2                	xor    %edx,%edx
  803c5d:	f7 f7                	div    %edi
  803c5f:	89 c5                	mov    %eax,%ebp
  803c61:	89 f0                	mov    %esi,%eax
  803c63:	31 d2                	xor    %edx,%edx
  803c65:	f7 f5                	div    %ebp
  803c67:	89 c8                	mov    %ecx,%eax
  803c69:	f7 f5                	div    %ebp
  803c6b:	89 d0                	mov    %edx,%eax
  803c6d:	e9 44 ff ff ff       	jmp    803bb6 <__umoddi3+0x3e>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	89 c8                	mov    %ecx,%eax
  803c76:	89 f2                	mov    %esi,%edx
  803c78:	83 c4 1c             	add    $0x1c,%esp
  803c7b:	5b                   	pop    %ebx
  803c7c:	5e                   	pop    %esi
  803c7d:	5f                   	pop    %edi
  803c7e:	5d                   	pop    %ebp
  803c7f:	c3                   	ret    
  803c80:	3b 04 24             	cmp    (%esp),%eax
  803c83:	72 06                	jb     803c8b <__umoddi3+0x113>
  803c85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c89:	77 0f                	ja     803c9a <__umoddi3+0x122>
  803c8b:	89 f2                	mov    %esi,%edx
  803c8d:	29 f9                	sub    %edi,%ecx
  803c8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c93:	89 14 24             	mov    %edx,(%esp)
  803c96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c9e:	8b 14 24             	mov    (%esp),%edx
  803ca1:	83 c4 1c             	add    $0x1c,%esp
  803ca4:	5b                   	pop    %ebx
  803ca5:	5e                   	pop    %esi
  803ca6:	5f                   	pop    %edi
  803ca7:	5d                   	pop    %ebp
  803ca8:	c3                   	ret    
  803ca9:	8d 76 00             	lea    0x0(%esi),%esi
  803cac:	2b 04 24             	sub    (%esp),%eax
  803caf:	19 fa                	sbb    %edi,%edx
  803cb1:	89 d1                	mov    %edx,%ecx
  803cb3:	89 c6                	mov    %eax,%esi
  803cb5:	e9 71 ff ff ff       	jmp    803c2b <__umoddi3+0xb3>
  803cba:	66 90                	xchg   %ax,%ax
  803cbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cc0:	72 ea                	jb     803cac <__umoddi3+0x134>
  803cc2:	89 d9                	mov    %ebx,%ecx
  803cc4:	e9 62 ff ff ff       	jmp    803c2b <__umoddi3+0xb3>
