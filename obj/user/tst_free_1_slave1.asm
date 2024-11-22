
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
  800060:	68 a0 3c 80 00       	push   $0x803ca0
  800065:	6a 11                	push   $0x11
  800067:	68 bc 3c 80 00       	push   $0x803cbc
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
  8000bc:	e8 ba 19 00 00       	call   801a7b <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 fd 19 00 00       	call   801ac6 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 d8 3c 80 00       	push   $0x803cd8
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 bc 3c 80 00       	push   $0x803cbc
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 bc 19 00 00       	call   801ac6 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 08 3d 80 00       	push   $0x803d08
  800117:	6a 33                	push   $0x33
  800119:	68 bc 3c 80 00       	push   $0x803cbc
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 53 19 00 00       	call   801a7b <sys_calculate_free_frames>
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
  80015f:	e8 17 19 00 00       	call   801a7b <sys_calculate_free_frames>
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
  80017c:	68 38 3d 80 00       	push   $0x803d38
  800181:	6a 3d                	push   $0x3d
  800183:	68 bc 3c 80 00       	push   $0x803cbc
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
  8001c7:	e8 0a 1d 00 00       	call   801ed6 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 b4 3d 80 00       	push   $0x803db4
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 bc 3c 80 00       	push   $0x803cbc
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 8a 18 00 00       	call   801a7b <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 cd 18 00 00       	call   801ac6 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 b3 18 00 00       	call   801ac6 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 d4 3d 80 00       	push   $0x803dd4
  800220:	6a 4e                	push   $0x4e
  800222:	68 bc 3c 80 00       	push   $0x803cbc
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 4a 18 00 00       	call   801a7b <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 10 3e 80 00       	push   $0x803e10
  800247:	6a 4f                	push   $0x4f
  800249:	68 bc 3c 80 00       	push   $0x803cbc
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
  80028d:	e8 44 1c 00 00       	call   801ed6 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 5c 3e 80 00       	push   $0x803e5c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 bc 3c 80 00       	push   $0x803cbc
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 cb 1a 00 00       	call   801d82 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 df 1a 00 00       	call   801d9c <gettst>
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
  8002d4:	e8 a9 1a 00 00       	call   801d82 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 80 3e 80 00       	push   $0x803e80
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 bc 3c 80 00       	push   $0x803cbc
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
  8002f3:	e8 4c 19 00 00       	call   801c44 <sys_getenvindex>
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
  800361:	e8 62 16 00 00       	call   8019c8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 e4 3e 80 00       	push   $0x803ee4
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
  800391:	68 0c 3f 80 00       	push   $0x803f0c
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
  8003c2:	68 34 3f 80 00       	push   $0x803f34
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 8c 3f 80 00       	push   $0x803f8c
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 e4 3e 80 00       	push   $0x803ee4
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 e2 15 00 00       	call   8019e2 <sys_unlock_cons>
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
  800413:	e8 f8 17 00 00       	call   801c10 <sys_destroy_env>
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
  800424:	e8 4d 18 00 00       	call   801c76 <sys_exit_env>
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
  80044d:	68 a0 3f 80 00       	push   $0x803fa0
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 a5 3f 80 00       	push   $0x803fa5
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
  80048a:	68 c1 3f 80 00       	push   $0x803fc1
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
  8004b9:	68 c4 3f 80 00       	push   $0x803fc4
  8004be:	6a 26                	push   $0x26
  8004c0:	68 10 40 80 00       	push   $0x804010
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
  80058e:	68 1c 40 80 00       	push   $0x80401c
  800593:	6a 3a                	push   $0x3a
  800595:	68 10 40 80 00       	push   $0x804010
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
  800601:	68 70 40 80 00       	push   $0x804070
  800606:	6a 44                	push   $0x44
  800608:	68 10 40 80 00       	push   $0x804010
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
  80065b:	e8 26 13 00 00       	call   801986 <sys_cputs>
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
  8006d2:	e8 af 12 00 00       	call   801986 <sys_cputs>
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
  80071c:	e8 a7 12 00 00       	call   8019c8 <sys_lock_cons>
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
  80073c:	e8 a1 12 00 00       	call   8019e2 <sys_unlock_cons>
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
  800786:	e8 95 32 00 00       	call   803a20 <__udivdi3>
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
  8007d6:	e8 55 33 00 00       	call   803b30 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800931:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  800a12:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 e5 42 80 00       	push   $0x8042e5
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
  800a37:	68 ee 42 80 00       	push   $0x8042ee
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
  800a64:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  80146f:	68 68 44 80 00       	push   $0x804468
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 8a 44 80 00       	push   $0x80448a
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
  80148f:	e8 9d 0a 00 00       	call   801f31 <sys_sbrk>
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
  80150a:	e8 a6 08 00 00       	call   801db5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 e6 0d 00 00       	call   802304 <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 b8 08 00 00       	call   801de6 <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 7f 12 00 00       	call   8027c0 <alloc_block_BF>
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
  80158c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8015d9:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801630:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801692:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a2:	e8 c1 08 00 00       	call   801f68 <sys_allocate_user_mem>
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
  8016ea:	e8 95 08 00 00       	call   801f84 <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 c8 1a 00 00       	call   8031c8 <free_block>
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
  801735:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801772:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801792:	e8 b5 07 00 00       	call   801f4c <sys_free_user_mem>
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
  8017a0:	68 98 44 80 00       	push   $0x804498
  8017a5:	68 84 00 00 00       	push   $0x84
  8017aa:	68 c2 44 80 00       	push   $0x8044c2
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
  8017c6:	75 07                	jne    8017cf <smalloc+0x19>
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	eb 74                	jmp    801843 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e2:	39 d0                	cmp    %edx,%eax
  8017e4:	73 02                	jae    8017e8 <smalloc+0x32>
  8017e6:	89 d0                	mov    %edx,%eax
  8017e8:	83 ec 0c             	sub    $0xc,%esp
  8017eb:	50                   	push   %eax
  8017ec:	e8 a8 fc ff ff       	call   801499 <malloc>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017fb:	75 07                	jne    801804 <smalloc+0x4e>
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801802:	eb 3f                	jmp    801843 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801804:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801808:	ff 75 ec             	pushl  -0x14(%ebp)
  80180b:	50                   	push   %eax
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	e8 3c 03 00 00       	call   801b53 <sys_createSharedObject>
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80181d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801821:	74 06                	je     801829 <smalloc+0x73>
  801823:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801827:	75 07                	jne    801830 <smalloc+0x7a>
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	eb 13                	jmp    801843 <smalloc+0x8d>
	 cprintf("153\n");
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	68 ce 44 80 00       	push   $0x8044ce
  801838:	e8 ac ee ff ff       	call   8006e9 <cprintf>
  80183d:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801840:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	e8 24 03 00 00       	call   801b7d <sys_getSizeOfSharedObject>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80185f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801863:	75 07                	jne    80186c <sget+0x27>
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	eb 5c                	jmp    8018c8 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801872:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801879:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187f:	39 d0                	cmp    %edx,%eax
  801881:	7d 02                	jge    801885 <sget+0x40>
  801883:	89 d0                	mov    %edx,%eax
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	50                   	push   %eax
  801889:	e8 0b fc ff ff       	call   801499 <malloc>
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801894:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801898:	75 07                	jne    8018a1 <sget+0x5c>
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
  80189f:	eb 27                	jmp    8018c8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	ff 75 08             	pushl  0x8(%ebp)
  8018ad:	e8 e8 02 00 00       	call   801b9a <sys_getSharedObject>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018b8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018bc:	75 07                	jne    8018c5 <sget+0x80>
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c3:	eb 03                	jmp    8018c8 <sget+0x83>
	return ptr;
  8018c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	68 d4 44 80 00       	push   $0x8044d4
  8018d8:	68 c2 00 00 00       	push   $0xc2
  8018dd:	68 c2 44 80 00       	push   $0x8044c2
  8018e2:	e8 45 eb ff ff       	call   80042c <_panic>

008018e7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	68 f8 44 80 00       	push   $0x8044f8
  8018f5:	68 d9 00 00 00       	push   $0xd9
  8018fa:	68 c2 44 80 00       	push   $0x8044c2
  8018ff:	e8 28 eb ff ff       	call   80042c <_panic>

00801904 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	68 1e 45 80 00       	push   $0x80451e
  801912:	68 e5 00 00 00       	push   $0xe5
  801917:	68 c2 44 80 00       	push   $0x8044c2
  80191c:	e8 0b eb ff ff       	call   80042c <_panic>

00801921 <shrink>:

}
void shrink(uint32 newSize)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 1e 45 80 00       	push   $0x80451e
  80192f:	68 ea 00 00 00       	push   $0xea
  801934:	68 c2 44 80 00       	push   $0x8044c2
  801939:	e8 ee ea ff ff       	call   80042c <_panic>

0080193e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 1e 45 80 00       	push   $0x80451e
  80194c:	68 ef 00 00 00       	push   $0xef
  801951:	68 c2 44 80 00       	push   $0x8044c2
  801956:	e8 d1 ea ff ff       	call   80042c <_panic>

0080195b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	57                   	push   %edi
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801970:	8b 7d 18             	mov    0x18(%ebp),%edi
  801973:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801976:	cd 30                	int    $0x30
  801978:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5f                   	pop    %edi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801992:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	52                   	push   %edx
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	50                   	push   %eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	e8 b2 ff ff ff       	call   80195b <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	90                   	nop
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_cgetc>:

int
sys_cgetc(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 02                	push   $0x2
  8019be:	e8 98 ff ff ff       	call   80195b <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 03                	push   $0x3
  8019d7:	e8 7f ff ff ff       	call   80195b <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 04                	push   $0x4
  8019f1:	e8 65 ff ff ff       	call   80195b <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 08                	push   $0x8
  801a0f:	e8 47 ff ff ff       	call   80195b <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	56                   	push   %esi
  801a1d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a1e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	56                   	push   %esi
  801a2e:	53                   	push   %ebx
  801a2f:	51                   	push   %ecx
  801a30:	52                   	push   %edx
  801a31:	50                   	push   %eax
  801a32:	6a 09                	push   $0x9
  801a34:	e8 22 ff ff ff       	call   80195b <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	52                   	push   %edx
  801a53:	50                   	push   %eax
  801a54:	6a 0a                	push   $0xa
  801a56:	e8 00 ff ff ff       	call   80195b <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	6a 0b                	push   $0xb
  801a71:	e8 e5 fe ff ff       	call   80195b <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 0c                	push   $0xc
  801a8a:	e8 cc fe ff ff       	call   80195b <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 0d                	push   $0xd
  801aa3:	e8 b3 fe ff ff       	call   80195b <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0e                	push   $0xe
  801abc:	e8 9a fe ff ff       	call   80195b <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 0f                	push   $0xf
  801ad5:	e8 81 fe ff ff       	call   80195b <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 10                	push   $0x10
  801aef:	e8 67 fe ff ff       	call   80195b <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 11                	push   $0x11
  801b08:	e8 4e fe ff ff       	call   80195b <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b1f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	50                   	push   %eax
  801b2c:	6a 01                	push   $0x1
  801b2e:	e8 28 fe ff ff       	call   80195b <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 14                	push   $0x14
  801b48:	e8 0e fe ff ff       	call   80195b <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b62:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	51                   	push   %ecx
  801b6c:	52                   	push   %edx
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	50                   	push   %eax
  801b71:	6a 15                	push   $0x15
  801b73:	e8 e3 fd ff ff       	call   80195b <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 16                	push   $0x16
  801b90:	e8 c6 fd ff ff       	call   80195b <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	51                   	push   %ecx
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 17                	push   $0x17
  801baf:	e8 a7 fd ff ff       	call   80195b <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 18                	push   $0x18
  801bcc:	e8 8a fd ff ff       	call   80195b <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 14             	pushl  0x14(%ebp)
  801be1:	ff 75 10             	pushl  0x10(%ebp)
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	50                   	push   %eax
  801be8:	6a 19                	push   $0x19
  801bea:	e8 6c fd ff ff       	call   80195b <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	50                   	push   %eax
  801c03:	6a 1a                	push   $0x1a
  801c05:	e8 51 fd ff ff       	call   80195b <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	50                   	push   %eax
  801c1f:	6a 1b                	push   $0x1b
  801c21:	e8 35 fd ff ff       	call   80195b <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 05                	push   $0x5
  801c3a:	e8 1c fd ff ff       	call   80195b <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 06                	push   $0x6
  801c53:	e8 03 fd ff ff       	call   80195b <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 07                	push   $0x7
  801c6c:	e8 ea fc ff ff       	call   80195b <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_exit_env>:


void sys_exit_env(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 1c                	push   $0x1c
  801c85:	e8 d1 fc ff ff       	call   80195b <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c96:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c99:	8d 50 04             	lea    0x4(%eax),%edx
  801c9c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	52                   	push   %edx
  801ca6:	50                   	push   %eax
  801ca7:	6a 1d                	push   $0x1d
  801ca9:	e8 ad fc ff ff       	call   80195b <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cba:	89 01                	mov    %eax,(%ecx)
  801cbc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	c9                   	leave  
  801cc3:	c2 04 00             	ret    $0x4

00801cc6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	ff 75 08             	pushl  0x8(%ebp)
  801cd6:	6a 13                	push   $0x13
  801cd8:	e8 7e fc ff ff       	call   80195b <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 1e                	push   $0x1e
  801cf2:	e8 64 fc ff ff       	call   80195b <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d08:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	50                   	push   %eax
  801d15:	6a 1f                	push   $0x1f
  801d17:	e8 3f fc ff ff       	call   80195b <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <rsttst>:
void rsttst()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 21                	push   $0x21
  801d31:	e8 25 fc ff ff       	call   80195b <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 45 14             	mov    0x14(%ebp),%eax
  801d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d48:	8b 55 18             	mov    0x18(%ebp),%edx
  801d4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	ff 75 10             	pushl  0x10(%ebp)
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	6a 20                	push   $0x20
  801d5c:	e8 fa fb ff ff       	call   80195b <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return ;
  801d64:	90                   	nop
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <chktst>:
void chktst(uint32 n)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 22                	push   $0x22
  801d77:	e8 df fb ff ff       	call   80195b <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <inctst>:

void inctst()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 23                	push   $0x23
  801d91:	e8 c5 fb ff ff       	call   80195b <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
	return ;
  801d99:	90                   	nop
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <gettst>:
uint32 gettst()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 24                	push   $0x24
  801dab:	e8 ab fb ff ff       	call   80195b <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 25                	push   $0x25
  801dc7:	e8 8f fb ff ff       	call   80195b <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dd6:	75 07                	jne    801ddf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddd:	eb 05                	jmp    801de4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 25                	push   $0x25
  801df8:	e8 5e fb ff ff       	call   80195b <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e03:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e07:	75 07                	jne    801e10 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0e:	eb 05                	jmp    801e15 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 25                	push   $0x25
  801e29:	e8 2d fb ff ff       	call   80195b <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
  801e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e34:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e38:	75 07                	jne    801e41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3f:	eb 05                	jmp    801e46 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 25                	push   $0x25
  801e5a:	e8 fc fa ff ff       	call   80195b <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
  801e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e65:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e69:	75 07                	jne    801e72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e70:	eb 05                	jmp    801e77 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	6a 26                	push   $0x26
  801e89:	e8 cd fa ff ff       	call   80195b <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	53                   	push   %ebx
  801ea7:	51                   	push   %ecx
  801ea8:	52                   	push   %edx
  801ea9:	50                   	push   %eax
  801eaa:	6a 27                	push   $0x27
  801eac:	e8 aa fa ff ff       	call   80195b <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 28                	push   $0x28
  801ecc:	e8 8a fa ff ff       	call   80195b <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ed9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	51                   	push   %ecx
  801ee5:	ff 75 10             	pushl  0x10(%ebp)
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	6a 29                	push   $0x29
  801eec:	e8 6a fa ff ff       	call   80195b <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	ff 75 10             	pushl  0x10(%ebp)
  801f00:	ff 75 0c             	pushl  0xc(%ebp)
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	6a 12                	push   $0x12
  801f08:	e8 4e fa ff ff       	call   80195b <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f10:	90                   	nop
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	6a 2a                	push   $0x2a
  801f26:	e8 30 fa ff ff       	call   80195b <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
	return;
  801f2e:	90                   	nop
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	50                   	push   %eax
  801f40:	6a 2b                	push   $0x2b
  801f42:	e8 14 fa ff ff       	call   80195b <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	ff 75 08             	pushl  0x8(%ebp)
  801f5b:	6a 2c                	push   $0x2c
  801f5d:	e8 f9 f9 ff ff       	call   80195b <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
	return;
  801f65:	90                   	nop
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	ff 75 08             	pushl  0x8(%ebp)
  801f77:	6a 2d                	push   $0x2d
  801f79:	e8 dd f9 ff ff       	call   80195b <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
	return;
  801f81:	90                   	nop
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	83 e8 04             	sub    $0x4,%eax
  801f90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f96:	8b 00                	mov    (%eax),%eax
  801f98:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	83 e8 04             	sub    $0x4,%eax
  801fa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	83 e0 01             	and    $0x1,%eax
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	0f 94 c0             	sete   %al
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcb:	83 f8 02             	cmp    $0x2,%eax
  801fce:	74 2b                	je     801ffb <alloc_block+0x40>
  801fd0:	83 f8 02             	cmp    $0x2,%eax
  801fd3:	7f 07                	jg     801fdc <alloc_block+0x21>
  801fd5:	83 f8 01             	cmp    $0x1,%eax
  801fd8:	74 0e                	je     801fe8 <alloc_block+0x2d>
  801fda:	eb 58                	jmp    802034 <alloc_block+0x79>
  801fdc:	83 f8 03             	cmp    $0x3,%eax
  801fdf:	74 2d                	je     80200e <alloc_block+0x53>
  801fe1:	83 f8 04             	cmp    $0x4,%eax
  801fe4:	74 3b                	je     802021 <alloc_block+0x66>
  801fe6:	eb 4c                	jmp    802034 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	e8 11 03 00 00       	call   802304 <alloc_block_FF>
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff9:	eb 4a                	jmp    802045 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	e8 fa 19 00 00       	call   803a00 <alloc_block_NF>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80200c:	eb 37                	jmp    802045 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	e8 a7 07 00 00       	call   8027c0 <alloc_block_BF>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80201f:	eb 24                	jmp    802045 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	e8 b7 19 00 00       	call   8039e3 <alloc_block_WF>
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802032:	eb 11                	jmp    802045 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	68 30 45 80 00       	push   $0x804530
  80203c:	e8 a8 e6 ff ff       	call   8006e9 <cprintf>
  802041:	83 c4 10             	add    $0x10,%esp
		break;
  802044:	90                   	nop
	}
	return va;
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	53                   	push   %ebx
  80204e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	68 50 45 80 00       	push   $0x804550
  802059:	e8 8b e6 ff ff       	call   8006e9 <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	68 7b 45 80 00       	push   $0x80457b
  802069:	e8 7b e6 ff ff       	call   8006e9 <cprintf>
  80206e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802077:	eb 37                	jmp    8020b0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	ff 75 f4             	pushl  -0xc(%ebp)
  80207f:	e8 19 ff ff ff       	call   801f9d <is_free_block>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	0f be d8             	movsbl %al,%ebx
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 f4             	pushl  -0xc(%ebp)
  802090:	e8 ef fe ff ff       	call   801f84 <get_block_size>
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	53                   	push   %ebx
  80209c:	50                   	push   %eax
  80209d:	68 93 45 80 00       	push   $0x804593
  8020a2:	e8 42 e6 ff ff       	call   8006e9 <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b4:	74 07                	je     8020bd <print_blocks_list+0x73>
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	eb 05                	jmp    8020c2 <print_blocks_list+0x78>
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	89 45 10             	mov    %eax,0x10(%ebp)
  8020c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 ad                	jne    802079 <print_blocks_list+0x2f>
  8020cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d0:	75 a7                	jne    802079 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	68 50 45 80 00       	push   $0x804550
  8020da:	e8 0a e6 ff ff       	call   8006e9 <cprintf>
  8020df:	83 c4 10             	add    $0x10,%esp

}
  8020e2:	90                   	nop
  8020e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f1:	83 e0 01             	and    $0x1,%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 03                	je     8020fb <initialize_dynamic_allocator+0x13>
  8020f8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ff:	0f 84 c7 01 00 00    	je     8022cc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802105:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80210c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80210f:	8b 55 08             	mov    0x8(%ebp),%edx
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	01 d0                	add    %edx,%eax
  802117:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80211c:	0f 87 ad 01 00 00    	ja     8022cf <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 89 a5 01 00 00    	jns    8022d2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80212d:	8b 55 08             	mov    0x8(%ebp),%edx
  802130:	8b 45 0c             	mov    0xc(%ebp),%eax
  802133:	01 d0                	add    %edx,%eax
  802135:	83 e8 04             	sub    $0x4,%eax
  802138:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80213d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802144:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802149:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214c:	e9 87 00 00 00       	jmp    8021d8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802151:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802155:	75 14                	jne    80216b <initialize_dynamic_allocator+0x83>
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	68 ab 45 80 00       	push   $0x8045ab
  80215f:	6a 79                	push   $0x79
  802161:	68 c9 45 80 00       	push   $0x8045c9
  802166:	e8 c1 e2 ff ff       	call   80042c <_panic>
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	85 c0                	test   %eax,%eax
  802172:	74 10                	je     802184 <initialize_dynamic_allocator+0x9c>
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	8b 52 04             	mov    0x4(%edx),%edx
  80217f:	89 50 04             	mov    %edx,0x4(%eax)
  802182:	eb 0b                	jmp    80218f <initialize_dynamic_allocator+0xa7>
  802184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802187:	8b 40 04             	mov    0x4(%eax),%eax
  80218a:	a3 30 50 80 00       	mov    %eax,0x805030
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 40 04             	mov    0x4(%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0f                	je     8021a8 <initialize_dynamic_allocator+0xc0>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 04             	mov    0x4(%eax),%eax
  80219f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a2:	8b 12                	mov    (%edx),%edx
  8021a4:	89 10                	mov    %edx,(%eax)
  8021a6:	eb 0a                	jmp    8021b2 <initialize_dynamic_allocator+0xca>
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 00                	mov    (%eax),%eax
  8021ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ca:	48                   	dec    %eax
  8021cb:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021d0:	a1 34 50 80 00       	mov    0x805034,%eax
  8021d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dc:	74 07                	je     8021e5 <initialize_dynamic_allocator+0xfd>
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	eb 05                	jmp    8021ea <initialize_dynamic_allocator+0x102>
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8021ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	0f 85 55 ff ff ff    	jne    802151 <initialize_dynamic_allocator+0x69>
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	0f 85 4b ff ff ff    	jne    802151 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802215:	a1 44 50 80 00       	mov    0x805044,%eax
  80221a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80221f:	a1 40 50 80 00       	mov    0x805040,%eax
  802224:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	83 c0 08             	add    $0x8,%eax
  802230:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	83 c0 04             	add    $0x4,%eax
  802239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223c:	83 ea 08             	sub    $0x8,%edx
  80223f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	83 e8 08             	sub    $0x8,%eax
  80224c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224f:	83 ea 08             	sub    $0x8,%edx
  802252:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802254:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80225d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802260:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802267:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80226b:	75 17                	jne    802284 <initialize_dynamic_allocator+0x19c>
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	68 e4 45 80 00       	push   $0x8045e4
  802275:	68 90 00 00 00       	push   $0x90
  80227a:	68 c9 45 80 00       	push   $0x8045c9
  80227f:	e8 a8 e1 ff ff       	call   80042c <_panic>
  802284:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80228a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228d:	89 10                	mov    %edx,(%eax)
  80228f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	74 0d                	je     8022a5 <initialize_dynamic_allocator+0x1bd>
  802298:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80229d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022a0:	89 50 04             	mov    %edx,0x4(%eax)
  8022a3:	eb 08                	jmp    8022ad <initialize_dynamic_allocator+0x1c5>
  8022a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8022c4:	40                   	inc    %eax
  8022c5:	a3 38 50 80 00       	mov    %eax,0x805038
  8022ca:	eb 07                	jmp    8022d3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022cc:	90                   	nop
  8022cd:	eb 04                	jmp    8022d3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022cf:	90                   	nop
  8022d0:	eb 01                	jmp    8022d3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022d2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022db:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	83 e8 04             	sub    $0x4,%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	83 e0 fe             	and    $0xfffffffe,%eax
  8022f4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	01 c2                	add    %eax,%edx
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	89 02                	mov    %eax,(%edx)
}
  802301:	90                   	nop
  802302:	5d                   	pop    %ebp
  802303:	c3                   	ret    

00802304 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	83 e0 01             	and    $0x1,%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	74 03                	je     802317 <alloc_block_FF+0x13>
  802314:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802317:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80231b:	77 07                	ja     802324 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80231d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802324:	a1 24 50 80 00       	mov    0x805024,%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	75 73                	jne    8023a0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	83 c0 10             	add    $0x10,%eax
  802333:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802336:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80233d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802343:	01 d0                	add    %edx,%eax
  802345:	48                   	dec    %eax
  802346:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80234c:	ba 00 00 00 00       	mov    $0x0,%edx
  802351:	f7 75 ec             	divl   -0x14(%ebp)
  802354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802357:	29 d0                	sub    %edx,%eax
  802359:	c1 e8 0c             	shr    $0xc,%eax
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	50                   	push   %eax
  802360:	e8 1e f1 ff ff       	call   801483 <sbrk>
  802365:	83 c4 10             	add    $0x10,%esp
  802368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	6a 00                	push   $0x0
  802370:	e8 0e f1 ff ff       	call   801483 <sbrk>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80237b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802381:	83 ec 08             	sub    $0x8,%esp
  802384:	50                   	push   %eax
  802385:	ff 75 e4             	pushl  -0x1c(%ebp)
  802388:	e8 5b fd ff ff       	call   8020e8 <initialize_dynamic_allocator>
  80238d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802390:	83 ec 0c             	sub    $0xc,%esp
  802393:	68 07 46 80 00       	push   $0x804607
  802398:	e8 4c e3 ff ff       	call   8006e9 <cprintf>
  80239d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a4:	75 0a                	jne    8023b0 <alloc_block_FF+0xac>
	        return NULL;
  8023a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ab:	e9 0e 04 00 00       	jmp    8027be <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bf:	e9 f3 02 00 00       	jmp    8026b7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023ca:	83 ec 0c             	sub    $0xc,%esp
  8023cd:	ff 75 bc             	pushl  -0x44(%ebp)
  8023d0:	e8 af fb ff ff       	call   801f84 <get_block_size>
  8023d5:	83 c4 10             	add    $0x10,%esp
  8023d8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	83 c0 08             	add    $0x8,%eax
  8023e1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023e4:	0f 87 c5 02 00 00    	ja     8026af <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	83 c0 18             	add    $0x18,%eax
  8023f0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023f3:	0f 87 19 02 00 00    	ja     802612 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ff:	83 e8 08             	sub    $0x8,%eax
  802402:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8d 50 08             	lea    0x8(%eax),%edx
  80240b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	83 c0 08             	add    $0x8,%eax
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	6a 01                	push   $0x1
  80241e:	50                   	push   %eax
  80241f:	ff 75 bc             	pushl  -0x44(%ebp)
  802422:	e8 ae fe ff ff       	call   8022d5 <set_block_data>
  802427:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	75 68                	jne    80249c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802434:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802438:	75 17                	jne    802451 <alloc_block_FF+0x14d>
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	68 e4 45 80 00       	push   $0x8045e4
  802442:	68 d7 00 00 00       	push   $0xd7
  802447:	68 c9 45 80 00       	push   $0x8045c9
  80244c:	e8 db df ff ff       	call   80042c <_panic>
  802451:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802457:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245a:	89 10                	mov    %edx,(%eax)
  80245c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0d                	je     802472 <alloc_block_FF+0x16e>
  802465:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80246a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80246d:	89 50 04             	mov    %edx,0x4(%eax)
  802470:	eb 08                	jmp    80247a <alloc_block_FF+0x176>
  802472:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802475:	a3 30 50 80 00       	mov    %eax,0x805030
  80247a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802482:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802485:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248c:	a1 38 50 80 00       	mov    0x805038,%eax
  802491:	40                   	inc    %eax
  802492:	a3 38 50 80 00       	mov    %eax,0x805038
  802497:	e9 dc 00 00 00       	jmp    802578 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	75 65                	jne    80250a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024a5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024a9:	75 17                	jne    8024c2 <alloc_block_FF+0x1be>
  8024ab:	83 ec 04             	sub    $0x4,%esp
  8024ae:	68 18 46 80 00       	push   $0x804618
  8024b3:	68 db 00 00 00       	push   $0xdb
  8024b8:	68 c9 45 80 00       	push   $0x8045c9
  8024bd:	e8 6a df ff ff       	call   80042c <_panic>
  8024c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 0c                	je     8024e4 <alloc_block_FF+0x1e0>
  8024d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8024dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e0:	89 10                	mov    %edx,(%eax)
  8024e2:	eb 08                	jmp    8024ec <alloc_block_FF+0x1e8>
  8024e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8024f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802502:	40                   	inc    %eax
  802503:	a3 38 50 80 00       	mov    %eax,0x805038
  802508:	eb 6e                	jmp    802578 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	74 06                	je     802516 <alloc_block_FF+0x212>
  802510:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_FF+0x229>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 3c 46 80 00       	push   $0x80463c
  80251e:	68 df 00 00 00       	push   $0xdf
  802523:	68 c9 45 80 00       	push   $0x8045c9
  802528:	e8 ff de ff ff       	call   80042c <_panic>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 10                	mov    (%eax),%edx
  802532:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802535:	89 10                	mov    %edx,(%eax)
  802537:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 0b                	je     80254b <alloc_block_FF+0x247>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802548:	89 50 04             	mov    %edx,0x4(%eax)
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802551:	89 10                	mov    %edx,(%eax)
  802553:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	75 08                	jne    80256d <alloc_block_FF+0x269>
  802565:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802568:	a3 30 50 80 00       	mov    %eax,0x805030
  80256d:	a1 38 50 80 00       	mov    0x805038,%eax
  802572:	40                   	inc    %eax
  802573:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257c:	75 17                	jne    802595 <alloc_block_FF+0x291>
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	68 ab 45 80 00       	push   $0x8045ab
  802586:	68 e1 00 00 00       	push   $0xe1
  80258b:	68 c9 45 80 00       	push   $0x8045c9
  802590:	e8 97 de ff ff       	call   80042c <_panic>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	74 10                	je     8025ae <alloc_block_FF+0x2aa>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a6:	8b 52 04             	mov    0x4(%edx),%edx
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ac:	eb 0b                	jmp    8025b9 <alloc_block_FF+0x2b5>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 0f                	je     8025d2 <alloc_block_FF+0x2ce>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cc:	8b 12                	mov    (%edx),%edx
  8025ce:	89 10                	mov    %edx,(%eax)
  8025d0:	eb 0a                	jmp    8025dc <alloc_block_FF+0x2d8>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f4:	48                   	dec    %eax
  8025f5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	6a 00                	push   $0x0
  8025ff:	ff 75 b4             	pushl  -0x4c(%ebp)
  802602:	ff 75 b0             	pushl  -0x50(%ebp)
  802605:	e8 cb fc ff ff       	call   8022d5 <set_block_data>
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	e9 95 00 00 00       	jmp    8026a7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	6a 01                	push   $0x1
  802617:	ff 75 b8             	pushl  -0x48(%ebp)
  80261a:	ff 75 bc             	pushl  -0x44(%ebp)
  80261d:	e8 b3 fc ff ff       	call   8022d5 <set_block_data>
  802622:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802629:	75 17                	jne    802642 <alloc_block_FF+0x33e>
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 ab 45 80 00       	push   $0x8045ab
  802633:	68 e8 00 00 00       	push   $0xe8
  802638:	68 c9 45 80 00       	push   $0x8045c9
  80263d:	e8 ea dd ff ff       	call   80042c <_panic>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	74 10                	je     80265b <alloc_block_FF+0x357>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	8b 52 04             	mov    0x4(%edx),%edx
  802656:	89 50 04             	mov    %edx,0x4(%eax)
  802659:	eb 0b                	jmp    802666 <alloc_block_FF+0x362>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	a3 30 50 80 00       	mov    %eax,0x805030
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 0f                	je     80267f <alloc_block_FF+0x37b>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802679:	8b 12                	mov    (%edx),%edx
  80267b:	89 10                	mov    %edx,(%eax)
  80267d:	eb 0a                	jmp    802689 <alloc_block_FF+0x385>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269c:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a1:	48                   	dec    %eax
  8026a2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026aa:	e9 0f 01 00 00       	jmp    8027be <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026af:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	74 07                	je     8026c4 <alloc_block_FF+0x3c0>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <alloc_block_FF+0x3c5>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	0f 85 e9 fc ff ff    	jne    8023c4 <alloc_block_FF+0xc0>
  8026db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026df:	0f 85 df fc ff ff    	jne    8023c4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	83 c0 08             	add    $0x8,%eax
  8026eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026ee:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026fb:	01 d0                	add    %edx,%eax
  8026fd:	48                   	dec    %eax
  8026fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802704:	ba 00 00 00 00       	mov    $0x0,%edx
  802709:	f7 75 d8             	divl   -0x28(%ebp)
  80270c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270f:	29 d0                	sub    %edx,%eax
  802711:	c1 e8 0c             	shr    $0xc,%eax
  802714:	83 ec 0c             	sub    $0xc,%esp
  802717:	50                   	push   %eax
  802718:	e8 66 ed ff ff       	call   801483 <sbrk>
  80271d:	83 c4 10             	add    $0x10,%esp
  802720:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802723:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802727:	75 0a                	jne    802733 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	e9 8b 00 00 00       	jmp    8027be <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802733:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80273a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80273d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802740:	01 d0                	add    %edx,%eax
  802742:	48                   	dec    %eax
  802743:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802746:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802749:	ba 00 00 00 00       	mov    $0x0,%edx
  80274e:	f7 75 cc             	divl   -0x34(%ebp)
  802751:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802754:	29 d0                	sub    %edx,%eax
  802756:	8d 50 fc             	lea    -0x4(%eax),%edx
  802759:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802763:	a1 40 50 80 00       	mov    0x805040,%eax
  802768:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80276e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802775:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802778:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80277b:	01 d0                	add    %edx,%eax
  80277d:	48                   	dec    %eax
  80277e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802781:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802784:	ba 00 00 00 00       	mov    $0x0,%edx
  802789:	f7 75 c4             	divl   -0x3c(%ebp)
  80278c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80278f:	29 d0                	sub    %edx,%eax
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	6a 01                	push   $0x1
  802796:	50                   	push   %eax
  802797:	ff 75 d0             	pushl  -0x30(%ebp)
  80279a:	e8 36 fb ff ff       	call   8022d5 <set_block_data>
  80279f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	ff 75 d0             	pushl  -0x30(%ebp)
  8027a8:	e8 1b 0a 00 00       	call   8031c8 <free_block>
  8027ad:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027b0:	83 ec 0c             	sub    $0xc,%esp
  8027b3:	ff 75 08             	pushl  0x8(%ebp)
  8027b6:	e8 49 fb ff ff       	call   802304 <alloc_block_FF>
  8027bb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	83 e0 01             	and    $0x1,%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	74 03                	je     8027d3 <alloc_block_BF+0x13>
  8027d0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027d3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027d7:	77 07                	ja     8027e0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027d9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	75 73                	jne    80285c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	83 c0 10             	add    $0x10,%eax
  8027ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027f2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ff:	01 d0                	add    %edx,%eax
  802801:	48                   	dec    %eax
  802802:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802808:	ba 00 00 00 00       	mov    $0x0,%edx
  80280d:	f7 75 e0             	divl   -0x20(%ebp)
  802810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802813:	29 d0                	sub    %edx,%eax
  802815:	c1 e8 0c             	shr    $0xc,%eax
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	50                   	push   %eax
  80281c:	e8 62 ec ff ff       	call   801483 <sbrk>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	6a 00                	push   $0x0
  80282c:	e8 52 ec ff ff       	call   801483 <sbrk>
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80283a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80283d:	83 ec 08             	sub    $0x8,%esp
  802840:	50                   	push   %eax
  802841:	ff 75 d8             	pushl  -0x28(%ebp)
  802844:	e8 9f f8 ff ff       	call   8020e8 <initialize_dynamic_allocator>
  802849:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80284c:	83 ec 0c             	sub    $0xc,%esp
  80284f:	68 07 46 80 00       	push   $0x804607
  802854:	e8 90 de ff ff       	call   8006e9 <cprintf>
  802859:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80285c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802863:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80286a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802878:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80287d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802880:	e9 1d 01 00 00       	jmp    8029a2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80288b:	83 ec 0c             	sub    $0xc,%esp
  80288e:	ff 75 a8             	pushl  -0x58(%ebp)
  802891:	e8 ee f6 ff ff       	call   801f84 <get_block_size>
  802896:	83 c4 10             	add    $0x10,%esp
  802899:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	83 c0 08             	add    $0x8,%eax
  8028a2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a5:	0f 87 ef 00 00 00    	ja     80299a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	83 c0 18             	add    $0x18,%eax
  8028b1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b4:	77 1d                	ja     8028d3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028bc:	0f 86 d8 00 00 00    	jbe    80299a <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028ce:	e9 c7 00 00 00       	jmp    80299a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	83 c0 08             	add    $0x8,%eax
  8028d9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028dc:	0f 85 9d 00 00 00    	jne    80297f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	6a 01                	push   $0x1
  8028e7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028ea:	ff 75 a8             	pushl  -0x58(%ebp)
  8028ed:	e8 e3 f9 ff ff       	call   8022d5 <set_block_data>
  8028f2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f9:	75 17                	jne    802912 <alloc_block_BF+0x152>
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	68 ab 45 80 00       	push   $0x8045ab
  802903:	68 2c 01 00 00       	push   $0x12c
  802908:	68 c9 45 80 00       	push   $0x8045c9
  80290d:	e8 1a db ff ff       	call   80042c <_panic>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 10                	je     80292b <alloc_block_BF+0x16b>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802923:	8b 52 04             	mov    0x4(%edx),%edx
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	eb 0b                	jmp    802936 <alloc_block_BF+0x176>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	a3 30 50 80 00       	mov    %eax,0x805030
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 0f                	je     80294f <alloc_block_BF+0x18f>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802949:	8b 12                	mov    (%edx),%edx
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	eb 0a                	jmp    802959 <alloc_block_BF+0x199>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296c:	a1 38 50 80 00       	mov    0x805038,%eax
  802971:	48                   	dec    %eax
  802972:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802977:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80297a:	e9 24 04 00 00       	jmp    802da3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802985:	76 13                	jbe    80299a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802987:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80298e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802991:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802994:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802997:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80299a:	a1 34 50 80 00       	mov    0x805034,%eax
  80299f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a6:	74 07                	je     8029af <alloc_block_BF+0x1ef>
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 00                	mov    (%eax),%eax
  8029ad:	eb 05                	jmp    8029b4 <alloc_block_BF+0x1f4>
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	a3 34 50 80 00       	mov    %eax,0x805034
  8029b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	0f 85 bf fe ff ff    	jne    802885 <alloc_block_BF+0xc5>
  8029c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ca:	0f 85 b5 fe ff ff    	jne    802885 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d4:	0f 84 26 02 00 00    	je     802c00 <alloc_block_BF+0x440>
  8029da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029de:	0f 85 1c 02 00 00    	jne    802c00 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ea:	83 e8 08             	sub    $0x8,%eax
  8029ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8d 50 08             	lea    0x8(%eax),%edx
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	83 c0 08             	add    $0x8,%eax
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	6a 01                	push   $0x1
  802a09:	50                   	push   %eax
  802a0a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a0d:	e8 c3 f8 ff ff       	call   8022d5 <set_block_data>
  802a12:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	75 68                	jne    802a87 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a1f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a23:	75 17                	jne    802a3c <alloc_block_BF+0x27c>
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 e4 45 80 00       	push   $0x8045e4
  802a2d:	68 45 01 00 00       	push   $0x145
  802a32:	68 c9 45 80 00       	push   $0x8045c9
  802a37:	e8 f0 d9 ff ff       	call   80042c <_panic>
  802a3c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	74 0d                	je     802a5d <alloc_block_BF+0x29d>
  802a50:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a55:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a58:	89 50 04             	mov    %edx,0x4(%eax)
  802a5b:	eb 08                	jmp    802a65 <alloc_block_BF+0x2a5>
  802a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a60:	a3 30 50 80 00       	mov    %eax,0x805030
  802a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a68:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a77:	a1 38 50 80 00       	mov    0x805038,%eax
  802a7c:	40                   	inc    %eax
  802a7d:	a3 38 50 80 00       	mov    %eax,0x805038
  802a82:	e9 dc 00 00 00       	jmp    802b63 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	75 65                	jne    802af5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a94:	75 17                	jne    802aad <alloc_block_BF+0x2ed>
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	68 18 46 80 00       	push   $0x804618
  802a9e:	68 4a 01 00 00       	push   $0x14a
  802aa3:	68 c9 45 80 00       	push   $0x8045c9
  802aa8:	e8 7f d9 ff ff       	call   80042c <_panic>
  802aad:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ab3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab6:	89 50 04             	mov    %edx,0x4(%eax)
  802ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abc:	8b 40 04             	mov    0x4(%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 0c                	je     802acf <alloc_block_BF+0x30f>
  802ac3:	a1 30 50 80 00       	mov    0x805030,%eax
  802ac8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802acb:	89 10                	mov    %edx,(%eax)
  802acd:	eb 08                	jmp    802ad7 <alloc_block_BF+0x317>
  802acf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ad7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ada:	a3 30 50 80 00       	mov    %eax,0x805030
  802adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae8:	a1 38 50 80 00       	mov    0x805038,%eax
  802aed:	40                   	inc    %eax
  802aee:	a3 38 50 80 00       	mov    %eax,0x805038
  802af3:	eb 6e                	jmp    802b63 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af9:	74 06                	je     802b01 <alloc_block_BF+0x341>
  802afb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aff:	75 17                	jne    802b18 <alloc_block_BF+0x358>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 3c 46 80 00       	push   $0x80463c
  802b09:	68 4f 01 00 00       	push   $0x14f
  802b0e:	68 c9 45 80 00       	push   $0x8045c9
  802b13:	e8 14 d9 ff ff       	call   80042c <_panic>
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	8b 10                	mov    (%eax),%edx
  802b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b20:	89 10                	mov    %edx,(%eax)
  802b22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 0b                	je     802b36 <alloc_block_BF+0x376>
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b33:	89 50 04             	mov    %edx,0x4(%eax)
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b44:	89 50 04             	mov    %edx,0x4(%eax)
  802b47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	75 08                	jne    802b58 <alloc_block_BF+0x398>
  802b50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b53:	a3 30 50 80 00       	mov    %eax,0x805030
  802b58:	a1 38 50 80 00       	mov    0x805038,%eax
  802b5d:	40                   	inc    %eax
  802b5e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b67:	75 17                	jne    802b80 <alloc_block_BF+0x3c0>
  802b69:	83 ec 04             	sub    $0x4,%esp
  802b6c:	68 ab 45 80 00       	push   $0x8045ab
  802b71:	68 51 01 00 00       	push   $0x151
  802b76:	68 c9 45 80 00       	push   $0x8045c9
  802b7b:	e8 ac d8 ff ff       	call   80042c <_panic>
  802b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 10                	je     802b99 <alloc_block_BF+0x3d9>
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b91:	8b 52 04             	mov    0x4(%edx),%edx
  802b94:	89 50 04             	mov    %edx,0x4(%eax)
  802b97:	eb 0b                	jmp    802ba4 <alloc_block_BF+0x3e4>
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 0f                	je     802bbd <alloc_block_BF+0x3fd>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb7:	8b 12                	mov    (%edx),%edx
  802bb9:	89 10                	mov    %edx,(%eax)
  802bbb:	eb 0a                	jmp    802bc7 <alloc_block_BF+0x407>
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bda:	a1 38 50 80 00       	mov    0x805038,%eax
  802bdf:	48                   	dec    %eax
  802be0:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802be5:	83 ec 04             	sub    $0x4,%esp
  802be8:	6a 00                	push   $0x0
  802bea:	ff 75 d0             	pushl  -0x30(%ebp)
  802bed:	ff 75 cc             	pushl  -0x34(%ebp)
  802bf0:	e8 e0 f6 ff ff       	call   8022d5 <set_block_data>
  802bf5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	e9 a3 01 00 00       	jmp    802da3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c00:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c04:	0f 85 9d 00 00 00    	jne    802ca7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	6a 01                	push   $0x1
  802c0f:	ff 75 ec             	pushl  -0x14(%ebp)
  802c12:	ff 75 f0             	pushl  -0x10(%ebp)
  802c15:	e8 bb f6 ff ff       	call   8022d5 <set_block_data>
  802c1a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c21:	75 17                	jne    802c3a <alloc_block_BF+0x47a>
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	68 ab 45 80 00       	push   $0x8045ab
  802c2b:	68 58 01 00 00       	push   $0x158
  802c30:	68 c9 45 80 00       	push   $0x8045c9
  802c35:	e8 f2 d7 ff ff       	call   80042c <_panic>
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 10                	je     802c53 <alloc_block_BF+0x493>
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4b:	8b 52 04             	mov    0x4(%edx),%edx
  802c4e:	89 50 04             	mov    %edx,0x4(%eax)
  802c51:	eb 0b                	jmp    802c5e <alloc_block_BF+0x49e>
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	a3 30 50 80 00       	mov    %eax,0x805030
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	85 c0                	test   %eax,%eax
  802c66:	74 0f                	je     802c77 <alloc_block_BF+0x4b7>
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c71:	8b 12                	mov    (%edx),%edx
  802c73:	89 10                	mov    %edx,(%eax)
  802c75:	eb 0a                	jmp    802c81 <alloc_block_BF+0x4c1>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c94:	a1 38 50 80 00       	mov    0x805038,%eax
  802c99:	48                   	dec    %eax
  802c9a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	e9 fc 00 00 00       	jmp    802da3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	83 c0 08             	add    $0x8,%eax
  802cad:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cb0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cb7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	48                   	dec    %eax
  802cc0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ccb:	f7 75 c4             	divl   -0x3c(%ebp)
  802cce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd1:	29 d0                	sub    %edx,%eax
  802cd3:	c1 e8 0c             	shr    $0xc,%eax
  802cd6:	83 ec 0c             	sub    $0xc,%esp
  802cd9:	50                   	push   %eax
  802cda:	e8 a4 e7 ff ff       	call   801483 <sbrk>
  802cdf:	83 c4 10             	add    $0x10,%esp
  802ce2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ce5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ce9:	75 0a                	jne    802cf5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	e9 ae 00 00 00       	jmp    802da3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cf5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cfc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d02:	01 d0                	add    %edx,%eax
  802d04:	48                   	dec    %eax
  802d05:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d10:	f7 75 b8             	divl   -0x48(%ebp)
  802d13:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d16:	29 d0                	sub    %edx,%eax
  802d18:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d1b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d1e:	01 d0                	add    %edx,%eax
  802d20:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d25:	a1 40 50 80 00       	mov    0x805040,%eax
  802d2a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d30:	83 ec 0c             	sub    $0xc,%esp
  802d33:	68 70 46 80 00       	push   $0x804670
  802d38:	e8 ac d9 ff ff       	call   8006e9 <cprintf>
  802d3d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d40:	83 ec 08             	sub    $0x8,%esp
  802d43:	ff 75 bc             	pushl  -0x44(%ebp)
  802d46:	68 75 46 80 00       	push   $0x804675
  802d4b:	e8 99 d9 ff ff       	call   8006e9 <cprintf>
  802d50:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d53:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d5a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d60:	01 d0                	add    %edx,%eax
  802d62:	48                   	dec    %eax
  802d63:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d66:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d69:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6e:	f7 75 b0             	divl   -0x50(%ebp)
  802d71:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d74:	29 d0                	sub    %edx,%eax
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	6a 01                	push   $0x1
  802d7b:	50                   	push   %eax
  802d7c:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7f:	e8 51 f5 ff ff       	call   8022d5 <set_block_data>
  802d84:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d8d:	e8 36 04 00 00       	call   8031c8 <free_block>
  802d92:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 08             	pushl  0x8(%ebp)
  802d9b:	e8 20 fa ff ff       	call   8027c0 <alloc_block_BF>
  802da0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802da3:	c9                   	leave  
  802da4:	c3                   	ret    

00802da5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802da5:	55                   	push   %ebp
  802da6:	89 e5                	mov    %esp,%ebp
  802da8:	53                   	push   %ebx
  802da9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802db3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbe:	74 1e                	je     802dde <merging+0x39>
  802dc0:	ff 75 08             	pushl  0x8(%ebp)
  802dc3:	e8 bc f1 ff ff       	call   801f84 <get_block_size>
  802dc8:	83 c4 04             	add    $0x4,%esp
  802dcb:	89 c2                	mov    %eax,%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	01 d0                	add    %edx,%eax
  802dd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dd5:	75 07                	jne    802dde <merging+0x39>
		prev_is_free = 1;
  802dd7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de2:	74 1e                	je     802e02 <merging+0x5d>
  802de4:	ff 75 10             	pushl  0x10(%ebp)
  802de7:	e8 98 f1 ff ff       	call   801f84 <get_block_size>
  802dec:	83 c4 04             	add    $0x4,%esp
  802def:	89 c2                	mov    %eax,%edx
  802df1:	8b 45 10             	mov    0x10(%ebp),%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802df9:	75 07                	jne    802e02 <merging+0x5d>
		next_is_free = 1;
  802dfb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	0f 84 cc 00 00 00    	je     802ed8 <merging+0x133>
  802e0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e10:	0f 84 c2 00 00 00    	je     802ed8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e16:	ff 75 08             	pushl  0x8(%ebp)
  802e19:	e8 66 f1 ff ff       	call   801f84 <get_block_size>
  802e1e:	83 c4 04             	add    $0x4,%esp
  802e21:	89 c3                	mov    %eax,%ebx
  802e23:	ff 75 10             	pushl  0x10(%ebp)
  802e26:	e8 59 f1 ff ff       	call   801f84 <get_block_size>
  802e2b:	83 c4 04             	add    $0x4,%esp
  802e2e:	01 c3                	add    %eax,%ebx
  802e30:	ff 75 0c             	pushl  0xc(%ebp)
  802e33:	e8 4c f1 ff ff       	call   801f84 <get_block_size>
  802e38:	83 c4 04             	add    $0x4,%esp
  802e3b:	01 d8                	add    %ebx,%eax
  802e3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e40:	6a 00                	push   $0x0
  802e42:	ff 75 ec             	pushl  -0x14(%ebp)
  802e45:	ff 75 08             	pushl  0x8(%ebp)
  802e48:	e8 88 f4 ff ff       	call   8022d5 <set_block_data>
  802e4d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e54:	75 17                	jne    802e6d <merging+0xc8>
  802e56:	83 ec 04             	sub    $0x4,%esp
  802e59:	68 ab 45 80 00       	push   $0x8045ab
  802e5e:	68 7d 01 00 00       	push   $0x17d
  802e63:	68 c9 45 80 00       	push   $0x8045c9
  802e68:	e8 bf d5 ff ff       	call   80042c <_panic>
  802e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 10                	je     802e86 <merging+0xe1>
  802e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7e:	8b 52 04             	mov    0x4(%edx),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	eb 0b                	jmp    802e91 <merging+0xec>
  802e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e94:	8b 40 04             	mov    0x4(%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0f                	je     802eaa <merging+0x105>
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea4:	8b 12                	mov    (%edx),%edx
  802ea6:	89 10                	mov    %edx,(%eax)
  802ea8:	eb 0a                	jmp    802eb4 <merging+0x10f>
  802eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ed2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ed3:	e9 ea 02 00 00       	jmp    8031c2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edc:	74 3b                	je     802f19 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ede:	83 ec 0c             	sub    $0xc,%esp
  802ee1:	ff 75 08             	pushl  0x8(%ebp)
  802ee4:	e8 9b f0 ff ff       	call   801f84 <get_block_size>
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	89 c3                	mov    %eax,%ebx
  802eee:	83 ec 0c             	sub    $0xc,%esp
  802ef1:	ff 75 10             	pushl  0x10(%ebp)
  802ef4:	e8 8b f0 ff ff       	call   801f84 <get_block_size>
  802ef9:	83 c4 10             	add    $0x10,%esp
  802efc:	01 d8                	add    %ebx,%eax
  802efe:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	6a 00                	push   $0x0
  802f06:	ff 75 e8             	pushl  -0x18(%ebp)
  802f09:	ff 75 08             	pushl  0x8(%ebp)
  802f0c:	e8 c4 f3 ff ff       	call   8022d5 <set_block_data>
  802f11:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f14:	e9 a9 02 00 00       	jmp    8031c2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1d:	0f 84 2d 01 00 00    	je     803050 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	ff 75 10             	pushl  0x10(%ebp)
  802f29:	e8 56 f0 ff ff       	call   801f84 <get_block_size>
  802f2e:	83 c4 10             	add    $0x10,%esp
  802f31:	89 c3                	mov    %eax,%ebx
  802f33:	83 ec 0c             	sub    $0xc,%esp
  802f36:	ff 75 0c             	pushl  0xc(%ebp)
  802f39:	e8 46 f0 ff ff       	call   801f84 <get_block_size>
  802f3e:	83 c4 10             	add    $0x10,%esp
  802f41:	01 d8                	add    %ebx,%eax
  802f43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f46:	83 ec 04             	sub    $0x4,%esp
  802f49:	6a 00                	push   $0x0
  802f4b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f4e:	ff 75 10             	pushl  0x10(%ebp)
  802f51:	e8 7f f3 ff ff       	call   8022d5 <set_block_data>
  802f56:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f59:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f63:	74 06                	je     802f6b <merging+0x1c6>
  802f65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f69:	75 17                	jne    802f82 <merging+0x1dd>
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 84 46 80 00       	push   $0x804684
  802f73:	68 8d 01 00 00       	push   $0x18d
  802f78:	68 c9 45 80 00       	push   $0x8045c9
  802f7d:	e8 aa d4 ff ff       	call   80042c <_panic>
  802f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f85:	8b 50 04             	mov    0x4(%eax),%edx
  802f88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8b:	89 50 04             	mov    %edx,0x4(%eax)
  802f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f94:	89 10                	mov    %edx,(%eax)
  802f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0d                	je     802fad <merging+0x208>
  802fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa3:	8b 40 04             	mov    0x4(%eax),%eax
  802fa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	eb 08                	jmp    802fb5 <merging+0x210>
  802fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fbb:	89 50 04             	mov    %edx,0x4(%eax)
  802fbe:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc3:	40                   	inc    %eax
  802fc4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fcd:	75 17                	jne    802fe6 <merging+0x241>
  802fcf:	83 ec 04             	sub    $0x4,%esp
  802fd2:	68 ab 45 80 00       	push   $0x8045ab
  802fd7:	68 8e 01 00 00       	push   $0x18e
  802fdc:	68 c9 45 80 00       	push   $0x8045c9
  802fe1:	e8 46 d4 ff ff       	call   80042c <_panic>
  802fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 10                	je     802fff <merging+0x25a>
  802fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff7:	8b 52 04             	mov    0x4(%edx),%edx
  802ffa:	89 50 04             	mov    %edx,0x4(%eax)
  802ffd:	eb 0b                	jmp    80300a <merging+0x265>
  802fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	a3 30 50 80 00       	mov    %eax,0x805030
  80300a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0f                	je     803023 <merging+0x27e>
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80301d:	8b 12                	mov    (%edx),%edx
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	eb 0a                	jmp    80302d <merging+0x288>
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80302d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803036:	8b 45 0c             	mov    0xc(%ebp),%eax
  803039:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803040:	a1 38 50 80 00       	mov    0x805038,%eax
  803045:	48                   	dec    %eax
  803046:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80304b:	e9 72 01 00 00       	jmp    8031c2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803050:	8b 45 10             	mov    0x10(%ebp),%eax
  803053:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305a:	74 79                	je     8030d5 <merging+0x330>
  80305c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803060:	74 73                	je     8030d5 <merging+0x330>
  803062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803066:	74 06                	je     80306e <merging+0x2c9>
  803068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306c:	75 17                	jne    803085 <merging+0x2e0>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 3c 46 80 00       	push   $0x80463c
  803076:	68 94 01 00 00       	push   $0x194
  80307b:	68 c9 45 80 00       	push   $0x8045c9
  803080:	e8 a7 d3 ff ff       	call   80042c <_panic>
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 10                	mov    (%eax),%edx
  80308a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 0b                	je     8030a3 <merging+0x2fe>
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a0:	89 50 04             	mov    %edx,0x4(%eax)
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a9:	89 10                	mov    %edx,(%eax)
  8030ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b1:	89 50 04             	mov    %edx,0x4(%eax)
  8030b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	75 08                	jne    8030c5 <merging+0x320>
  8030bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ca:	40                   	inc    %eax
  8030cb:	a3 38 50 80 00       	mov    %eax,0x805038
  8030d0:	e9 ce 00 00 00       	jmp    8031a3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d9:	74 65                	je     803140 <merging+0x39b>
  8030db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030df:	75 17                	jne    8030f8 <merging+0x353>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 18 46 80 00       	push   $0x804618
  8030e9:	68 95 01 00 00       	push   $0x195
  8030ee:	68 c9 45 80 00       	push   $0x8045c9
  8030f3:	e8 34 d3 ff ff       	call   80042c <_panic>
  8030f8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0c                	je     80311a <merging+0x375>
  80310e:	a1 30 50 80 00       	mov    0x805030,%eax
  803113:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803116:	89 10                	mov    %edx,(%eax)
  803118:	eb 08                	jmp    803122 <merging+0x37d>
  80311a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803125:	a3 30 50 80 00       	mov    %eax,0x805030
  80312a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803133:	a1 38 50 80 00       	mov    0x805038,%eax
  803138:	40                   	inc    %eax
  803139:	a3 38 50 80 00       	mov    %eax,0x805038
  80313e:	eb 63                	jmp    8031a3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803140:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803144:	75 17                	jne    80315d <merging+0x3b8>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 e4 45 80 00       	push   $0x8045e4
  80314e:	68 98 01 00 00       	push   $0x198
  803153:	68 c9 45 80 00       	push   $0x8045c9
  803158:	e8 cf d2 ff ff       	call   80042c <_panic>
  80315d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	89 10                	mov    %edx,(%eax)
  803168:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0d                	je     80317e <merging+0x3d9>
  803171:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803176:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803179:	89 50 04             	mov    %edx,0x4(%eax)
  80317c:	eb 08                	jmp    803186 <merging+0x3e1>
  80317e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803181:	a3 30 50 80 00       	mov    %eax,0x805030
  803186:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803189:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80318e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803198:	a1 38 50 80 00       	mov    0x805038,%eax
  80319d:	40                   	inc    %eax
  80319e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031a3:	83 ec 0c             	sub    $0xc,%esp
  8031a6:	ff 75 10             	pushl  0x10(%ebp)
  8031a9:	e8 d6 ed ff ff       	call   801f84 <get_block_size>
  8031ae:	83 c4 10             	add    $0x10,%esp
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	6a 00                	push   $0x0
  8031b6:	50                   	push   %eax
  8031b7:	ff 75 10             	pushl  0x10(%ebp)
  8031ba:	e8 16 f1 ff ff       	call   8022d5 <set_block_data>
  8031bf:	83 c4 10             	add    $0x10,%esp
	}
}
  8031c2:	90                   	nop
  8031c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031de:	73 1b                	jae    8031fb <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031e0:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	ff 75 08             	pushl  0x8(%ebp)
  8031eb:	6a 00                	push   $0x0
  8031ed:	50                   	push   %eax
  8031ee:	e8 b2 fb ff ff       	call   802da5 <merging>
  8031f3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f6:	e9 8b 00 00 00       	jmp    803286 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803200:	3b 45 08             	cmp    0x8(%ebp),%eax
  803203:	76 18                	jbe    80321d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803205:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	ff 75 08             	pushl  0x8(%ebp)
  803210:	50                   	push   %eax
  803211:	6a 00                	push   $0x0
  803213:	e8 8d fb ff ff       	call   802da5 <merging>
  803218:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80321b:	eb 69                	jmp    803286 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80321d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803225:	eb 39                	jmp    803260 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80322d:	73 29                	jae    803258 <free_block+0x90>
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	3b 45 08             	cmp    0x8(%ebp),%eax
  803237:	76 1f                	jbe    803258 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	ff 75 08             	pushl  0x8(%ebp)
  803247:	ff 75 f0             	pushl  -0x10(%ebp)
  80324a:	ff 75 f4             	pushl  -0xc(%ebp)
  80324d:	e8 53 fb ff ff       	call   802da5 <merging>
  803252:	83 c4 10             	add    $0x10,%esp
			break;
  803255:	90                   	nop
		}
	}
}
  803256:	eb 2e                	jmp    803286 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803258:	a1 34 50 80 00       	mov    0x805034,%eax
  80325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803264:	74 07                	je     80326d <free_block+0xa5>
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	eb 05                	jmp    803272 <free_block+0xaa>
  80326d:	b8 00 00 00 00       	mov    $0x0,%eax
  803272:	a3 34 50 80 00       	mov    %eax,0x805034
  803277:	a1 34 50 80 00       	mov    0x805034,%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	75 a7                	jne    803227 <free_block+0x5f>
  803280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803284:	75 a1                	jne    803227 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803286:	90                   	nop
  803287:	c9                   	leave  
  803288:	c3                   	ret    

00803289 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803289:	55                   	push   %ebp
  80328a:	89 e5                	mov    %esp,%ebp
  80328c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80328f:	ff 75 08             	pushl  0x8(%ebp)
  803292:	e8 ed ec ff ff       	call   801f84 <get_block_size>
  803297:	83 c4 04             	add    $0x4,%esp
  80329a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80329d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032a4:	eb 17                	jmp    8032bd <copy_data+0x34>
  8032a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ac:	01 c2                	add    %eax,%edx
  8032ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	01 c8                	add    %ecx,%eax
  8032b6:	8a 00                	mov    (%eax),%al
  8032b8:	88 02                	mov    %al,(%edx)
  8032ba:	ff 45 fc             	incl   -0x4(%ebp)
  8032bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032c3:	72 e1                	jb     8032a6 <copy_data+0x1d>
}
  8032c5:	90                   	nop
  8032c6:	c9                   	leave  
  8032c7:	c3                   	ret    

008032c8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032c8:	55                   	push   %ebp
  8032c9:	89 e5                	mov    %esp,%ebp
  8032cb:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 23                	jne    8032f7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d8:	74 13                	je     8032ed <realloc_block_FF+0x25>
  8032da:	83 ec 0c             	sub    $0xc,%esp
  8032dd:	ff 75 0c             	pushl  0xc(%ebp)
  8032e0:	e8 1f f0 ff ff       	call   802304 <alloc_block_FF>
  8032e5:	83 c4 10             	add    $0x10,%esp
  8032e8:	e9 f4 06 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
		return NULL;
  8032ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f2:	e9 ea 06 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032fb:	75 18                	jne    803315 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032fd:	83 ec 0c             	sub    $0xc,%esp
  803300:	ff 75 08             	pushl  0x8(%ebp)
  803303:	e8 c0 fe ff ff       	call   8031c8 <free_block>
  803308:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80330b:	b8 00 00 00 00       	mov    $0x0,%eax
  803310:	e9 cc 06 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803315:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803319:	77 07                	ja     803322 <realloc_block_FF+0x5a>
  80331b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803322:	8b 45 0c             	mov    0xc(%ebp),%eax
  803325:	83 e0 01             	and    $0x1,%eax
  803328:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80332b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332e:	83 c0 08             	add    $0x8,%eax
  803331:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803334:	83 ec 0c             	sub    $0xc,%esp
  803337:	ff 75 08             	pushl  0x8(%ebp)
  80333a:	e8 45 ec ff ff       	call   801f84 <get_block_size>
  80333f:	83 c4 10             	add    $0x10,%esp
  803342:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803348:	83 e8 08             	sub    $0x8,%eax
  80334b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80334e:	8b 45 08             	mov    0x8(%ebp),%eax
  803351:	83 e8 04             	sub    $0x4,%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	83 e0 fe             	and    $0xfffffffe,%eax
  803359:	89 c2                	mov    %eax,%edx
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	01 d0                	add    %edx,%eax
  803360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803363:	83 ec 0c             	sub    $0xc,%esp
  803366:	ff 75 e4             	pushl  -0x1c(%ebp)
  803369:	e8 16 ec ff ff       	call   801f84 <get_block_size>
  80336e:	83 c4 10             	add    $0x10,%esp
  803371:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803377:	83 e8 08             	sub    $0x8,%eax
  80337a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803383:	75 08                	jne    80338d <realloc_block_FF+0xc5>
	{
		 return va;
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	e9 54 06 00 00       	jmp    8039e1 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80338d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803390:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803393:	0f 83 e5 03 00 00    	jae    80377e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80339f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033a2:	83 ec 0c             	sub    $0xc,%esp
  8033a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a8:	e8 f0 eb ff ff       	call   801f9d <is_free_block>
  8033ad:	83 c4 10             	add    $0x10,%esp
  8033b0:	84 c0                	test   %al,%al
  8033b2:	0f 84 3b 01 00 00    	je     8034f3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033c3:	83 ec 04             	sub    $0x4,%esp
  8033c6:	6a 01                	push   $0x1
  8033c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8033cb:	ff 75 08             	pushl  0x8(%ebp)
  8033ce:	e8 02 ef ff ff       	call   8022d5 <set_block_data>
  8033d3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	83 e8 04             	sub    $0x4,%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	83 e0 fe             	and    $0xfffffffe,%eax
  8033e1:	89 c2                	mov    %eax,%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	01 d0                	add    %edx,%eax
  8033e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033eb:	83 ec 04             	sub    $0x4,%esp
  8033ee:	6a 00                	push   $0x0
  8033f0:	ff 75 cc             	pushl  -0x34(%ebp)
  8033f3:	ff 75 c8             	pushl  -0x38(%ebp)
  8033f6:	e8 da ee ff ff       	call   8022d5 <set_block_data>
  8033fb:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803402:	74 06                	je     80340a <realloc_block_FF+0x142>
  803404:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803408:	75 17                	jne    803421 <realloc_block_FF+0x159>
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 3c 46 80 00       	push   $0x80463c
  803412:	68 f6 01 00 00       	push   $0x1f6
  803417:	68 c9 45 80 00       	push   $0x8045c9
  80341c:	e8 0b d0 ff ff       	call   80042c <_panic>
  803421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803424:	8b 10                	mov    (%eax),%edx
  803426:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 0b                	je     80343f <realloc_block_FF+0x177>
  803434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803445:	89 10                	mov    %edx,(%eax)
  803447:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344d:	89 50 04             	mov    %edx,0x4(%eax)
  803450:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	75 08                	jne    803461 <realloc_block_FF+0x199>
  803459:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345c:	a3 30 50 80 00       	mov    %eax,0x805030
  803461:	a1 38 50 80 00       	mov    0x805038,%eax
  803466:	40                   	inc    %eax
  803467:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80346c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803470:	75 17                	jne    803489 <realloc_block_FF+0x1c1>
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	68 ab 45 80 00       	push   $0x8045ab
  80347a:	68 f7 01 00 00       	push   $0x1f7
  80347f:	68 c9 45 80 00       	push   $0x8045c9
  803484:	e8 a3 cf ff ff       	call   80042c <_panic>
  803489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 10                	je     8034a2 <realloc_block_FF+0x1da>
  803492:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80349a:	8b 52 04             	mov    0x4(%edx),%edx
  80349d:	89 50 04             	mov    %edx,0x4(%eax)
  8034a0:	eb 0b                	jmp    8034ad <realloc_block_FF+0x1e5>
  8034a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	74 0f                	je     8034c6 <realloc_block_FF+0x1fe>
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c0:	8b 12                	mov    (%edx),%edx
  8034c2:	89 10                	mov    %edx,(%eax)
  8034c4:	eb 0a                	jmp    8034d0 <realloc_block_FF+0x208>
  8034c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e8:	48                   	dec    %eax
  8034e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ee:	e9 83 02 00 00       	jmp    803776 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034f3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034f7:	0f 86 69 02 00 00    	jbe    803766 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	6a 01                	push   $0x1
  803502:	ff 75 f0             	pushl  -0x10(%ebp)
  803505:	ff 75 08             	pushl  0x8(%ebp)
  803508:	e8 c8 ed ff ff       	call   8022d5 <set_block_data>
  80350d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	83 e8 04             	sub    $0x4,%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	83 e0 fe             	and    $0xfffffffe,%eax
  80351b:	89 c2                	mov    %eax,%edx
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	01 d0                	add    %edx,%eax
  803522:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803525:	a1 38 50 80 00       	mov    0x805038,%eax
  80352a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80352d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803531:	75 68                	jne    80359b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803533:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803537:	75 17                	jne    803550 <realloc_block_FF+0x288>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 e4 45 80 00       	push   $0x8045e4
  803541:	68 06 02 00 00       	push   $0x206
  803546:	68 c9 45 80 00       	push   $0x8045c9
  80354b:	e8 dc ce ff ff       	call   80042c <_panic>
  803550:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <realloc_block_FF+0x2a9>
  803564:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803569:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	eb 08                	jmp    803579 <realloc_block_FF+0x2b1>
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	a3 30 50 80 00       	mov    %eax,0x805030
  803579:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803584:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358b:	a1 38 50 80 00       	mov    0x805038,%eax
  803590:	40                   	inc    %eax
  803591:	a3 38 50 80 00       	mov    %eax,0x805038
  803596:	e9 b0 01 00 00       	jmp    80374b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80359b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035a3:	76 68                	jbe    80360d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a9:	75 17                	jne    8035c2 <realloc_block_FF+0x2fa>
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	68 e4 45 80 00       	push   $0x8045e4
  8035b3:	68 0b 02 00 00       	push   $0x20b
  8035b8:	68 c9 45 80 00       	push   $0x8045c9
  8035bd:	e8 6a ce ff ff       	call   80042c <_panic>
  8035c2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cb:	89 10                	mov    %edx,(%eax)
  8035cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	74 0d                	je     8035e3 <realloc_block_FF+0x31b>
  8035d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035de:	89 50 04             	mov    %edx,0x4(%eax)
  8035e1:	eb 08                	jmp    8035eb <realloc_block_FF+0x323>
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803602:	40                   	inc    %eax
  803603:	a3 38 50 80 00       	mov    %eax,0x805038
  803608:	e9 3e 01 00 00       	jmp    80374b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80360d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803612:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803615:	73 68                	jae    80367f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803617:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80361b:	75 17                	jne    803634 <realloc_block_FF+0x36c>
  80361d:	83 ec 04             	sub    $0x4,%esp
  803620:	68 18 46 80 00       	push   $0x804618
  803625:	68 10 02 00 00       	push   $0x210
  80362a:	68 c9 45 80 00       	push   $0x8045c9
  80362f:	e8 f8 cd ff ff       	call   80042c <_panic>
  803634:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80363a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363d:	89 50 04             	mov    %edx,0x4(%eax)
  803640:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	85 c0                	test   %eax,%eax
  803648:	74 0c                	je     803656 <realloc_block_FF+0x38e>
  80364a:	a1 30 50 80 00       	mov    0x805030,%eax
  80364f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803652:	89 10                	mov    %edx,(%eax)
  803654:	eb 08                	jmp    80365e <realloc_block_FF+0x396>
  803656:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803659:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80365e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803661:	a3 30 50 80 00       	mov    %eax,0x805030
  803666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366f:	a1 38 50 80 00       	mov    0x805038,%eax
  803674:	40                   	inc    %eax
  803675:	a3 38 50 80 00       	mov    %eax,0x805038
  80367a:	e9 cc 00 00 00       	jmp    80374b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80367f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803686:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368e:	e9 8a 00 00 00       	jmp    80371d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803699:	73 7a                	jae    803715 <realloc_block_FF+0x44d>
  80369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a3:	73 70                	jae    803715 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a9:	74 06                	je     8036b1 <realloc_block_FF+0x3e9>
  8036ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036af:	75 17                	jne    8036c8 <realloc_block_FF+0x400>
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	68 3c 46 80 00       	push   $0x80463c
  8036b9:	68 1a 02 00 00       	push   $0x21a
  8036be:	68 c9 45 80 00       	push   $0x8045c9
  8036c3:	e8 64 cd ff ff       	call   80042c <_panic>
  8036c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cb:	8b 10                	mov    (%eax),%edx
  8036cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d0:	89 10                	mov    %edx,(%eax)
  8036d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 0b                	je     8036e6 <realloc_block_FF+0x41e>
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%eax)
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	75 08                	jne    803708 <realloc_block_FF+0x440>
  803700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803703:	a3 30 50 80 00       	mov    %eax,0x805030
  803708:	a1 38 50 80 00       	mov    0x805038,%eax
  80370d:	40                   	inc    %eax
  80370e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803713:	eb 36                	jmp    80374b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803715:	a1 34 50 80 00       	mov    0x805034,%eax
  80371a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803721:	74 07                	je     80372a <realloc_block_FF+0x462>
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	eb 05                	jmp    80372f <realloc_block_FF+0x467>
  80372a:	b8 00 00 00 00       	mov    $0x0,%eax
  80372f:	a3 34 50 80 00       	mov    %eax,0x805034
  803734:	a1 34 50 80 00       	mov    0x805034,%eax
  803739:	85 c0                	test   %eax,%eax
  80373b:	0f 85 52 ff ff ff    	jne    803693 <realloc_block_FF+0x3cb>
  803741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803745:	0f 85 48 ff ff ff    	jne    803693 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	6a 00                	push   $0x0
  803750:	ff 75 d8             	pushl  -0x28(%ebp)
  803753:	ff 75 d4             	pushl  -0x2c(%ebp)
  803756:	e8 7a eb ff ff       	call   8022d5 <set_block_data>
  80375b:	83 c4 10             	add    $0x10,%esp
				return va;
  80375e:	8b 45 08             	mov    0x8(%ebp),%eax
  803761:	e9 7b 02 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803766:	83 ec 0c             	sub    $0xc,%esp
  803769:	68 b9 46 80 00       	push   $0x8046b9
  80376e:	e8 76 cf ff ff       	call   8006e9 <cprintf>
  803773:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	e9 63 02 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80377e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803781:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803784:	0f 86 4d 02 00 00    	jbe    8039d7 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80378a:	83 ec 0c             	sub    $0xc,%esp
  80378d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803790:	e8 08 e8 ff ff       	call   801f9d <is_free_block>
  803795:	83 c4 10             	add    $0x10,%esp
  803798:	84 c0                	test   %al,%al
  80379a:	0f 84 37 02 00 00    	je     8039d7 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037ac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037af:	76 38                	jbe    8037e9 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037b1:	83 ec 0c             	sub    $0xc,%esp
  8037b4:	ff 75 08             	pushl  0x8(%ebp)
  8037b7:	e8 0c fa ff ff       	call   8031c8 <free_block>
  8037bc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037bf:	83 ec 0c             	sub    $0xc,%esp
  8037c2:	ff 75 0c             	pushl  0xc(%ebp)
  8037c5:	e8 3a eb ff ff       	call   802304 <alloc_block_FF>
  8037ca:	83 c4 10             	add    $0x10,%esp
  8037cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037d0:	83 ec 08             	sub    $0x8,%esp
  8037d3:	ff 75 c0             	pushl  -0x40(%ebp)
  8037d6:	ff 75 08             	pushl  0x8(%ebp)
  8037d9:	e8 ab fa ff ff       	call   803289 <copy_data>
  8037de:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037e4:	e9 f8 01 00 00       	jmp    8039e1 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ec:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037f2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037f6:	0f 87 a0 00 00 00    	ja     80389c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803800:	75 17                	jne    803819 <realloc_block_FF+0x551>
  803802:	83 ec 04             	sub    $0x4,%esp
  803805:	68 ab 45 80 00       	push   $0x8045ab
  80380a:	68 38 02 00 00       	push   $0x238
  80380f:	68 c9 45 80 00       	push   $0x8045c9
  803814:	e8 13 cc ff ff       	call   80042c <_panic>
  803819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	74 10                	je     803832 <realloc_block_FF+0x56a>
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382a:	8b 52 04             	mov    0x4(%edx),%edx
  80382d:	89 50 04             	mov    %edx,0x4(%eax)
  803830:	eb 0b                	jmp    80383d <realloc_block_FF+0x575>
  803832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803835:	8b 40 04             	mov    0x4(%eax),%eax
  803838:	a3 30 50 80 00       	mov    %eax,0x805030
  80383d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803840:	8b 40 04             	mov    0x4(%eax),%eax
  803843:	85 c0                	test   %eax,%eax
  803845:	74 0f                	je     803856 <realloc_block_FF+0x58e>
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	8b 40 04             	mov    0x4(%eax),%eax
  80384d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803850:	8b 12                	mov    (%edx),%edx
  803852:	89 10                	mov    %edx,(%eax)
  803854:	eb 0a                	jmp    803860 <realloc_block_FF+0x598>
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	8b 00                	mov    (%eax),%eax
  80385b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803873:	a1 38 50 80 00       	mov    0x805038,%eax
  803878:	48                   	dec    %eax
  803879:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80387e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803884:	01 d0                	add    %edx,%eax
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	6a 01                	push   $0x1
  80388b:	50                   	push   %eax
  80388c:	ff 75 08             	pushl  0x8(%ebp)
  80388f:	e8 41 ea ff ff       	call   8022d5 <set_block_data>
  803894:	83 c4 10             	add    $0x10,%esp
  803897:	e9 36 01 00 00       	jmp    8039d2 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80389c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80389f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038a2:	01 d0                	add    %edx,%eax
  8038a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	6a 01                	push   $0x1
  8038ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8038af:	ff 75 08             	pushl  0x8(%ebp)
  8038b2:	e8 1e ea ff ff       	call   8022d5 <set_block_data>
  8038b7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	83 e8 04             	sub    $0x4,%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	83 e0 fe             	and    $0xfffffffe,%eax
  8038c5:	89 c2                	mov    %eax,%edx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	01 d0                	add    %edx,%eax
  8038cc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d3:	74 06                	je     8038db <realloc_block_FF+0x613>
  8038d5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038d9:	75 17                	jne    8038f2 <realloc_block_FF+0x62a>
  8038db:	83 ec 04             	sub    $0x4,%esp
  8038de:	68 3c 46 80 00       	push   $0x80463c
  8038e3:	68 44 02 00 00       	push   $0x244
  8038e8:	68 c9 45 80 00       	push   $0x8045c9
  8038ed:	e8 3a cb ff ff       	call   80042c <_panic>
  8038f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f5:	8b 10                	mov    (%eax),%edx
  8038f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038fa:	89 10                	mov    %edx,(%eax)
  8038fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ff:	8b 00                	mov    (%eax),%eax
  803901:	85 c0                	test   %eax,%eax
  803903:	74 0b                	je     803910 <realloc_block_FF+0x648>
  803905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80390d:	89 50 04             	mov    %edx,0x4(%eax)
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391e:	89 50 04             	mov    %edx,0x4(%eax)
  803921:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803924:	8b 00                	mov    (%eax),%eax
  803926:	85 c0                	test   %eax,%eax
  803928:	75 08                	jne    803932 <realloc_block_FF+0x66a>
  80392a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392d:	a3 30 50 80 00       	mov    %eax,0x805030
  803932:	a1 38 50 80 00       	mov    0x805038,%eax
  803937:	40                   	inc    %eax
  803938:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80393d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803941:	75 17                	jne    80395a <realloc_block_FF+0x692>
  803943:	83 ec 04             	sub    $0x4,%esp
  803946:	68 ab 45 80 00       	push   $0x8045ab
  80394b:	68 45 02 00 00       	push   $0x245
  803950:	68 c9 45 80 00       	push   $0x8045c9
  803955:	e8 d2 ca ff ff       	call   80042c <_panic>
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	8b 00                	mov    (%eax),%eax
  80395f:	85 c0                	test   %eax,%eax
  803961:	74 10                	je     803973 <realloc_block_FF+0x6ab>
  803963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396b:	8b 52 04             	mov    0x4(%edx),%edx
  80396e:	89 50 04             	mov    %edx,0x4(%eax)
  803971:	eb 0b                	jmp    80397e <realloc_block_FF+0x6b6>
  803973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803976:	8b 40 04             	mov    0x4(%eax),%eax
  803979:	a3 30 50 80 00       	mov    %eax,0x805030
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 40 04             	mov    0x4(%eax),%eax
  803984:	85 c0                	test   %eax,%eax
  803986:	74 0f                	je     803997 <realloc_block_FF+0x6cf>
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	8b 40 04             	mov    0x4(%eax),%eax
  80398e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803991:	8b 12                	mov    (%edx),%edx
  803993:	89 10                	mov    %edx,(%eax)
  803995:	eb 0a                	jmp    8039a1 <realloc_block_FF+0x6d9>
  803997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399a:	8b 00                	mov    (%eax),%eax
  80399c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b9:	48                   	dec    %eax
  8039ba:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039bf:	83 ec 04             	sub    $0x4,%esp
  8039c2:	6a 00                	push   $0x0
  8039c4:	ff 75 bc             	pushl  -0x44(%ebp)
  8039c7:	ff 75 b8             	pushl  -0x48(%ebp)
  8039ca:	e8 06 e9 ff ff       	call   8022d5 <set_block_data>
  8039cf:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d5:	eb 0a                	jmp    8039e1 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039d7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039e1:	c9                   	leave  
  8039e2:	c3                   	ret    

008039e3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039e3:	55                   	push   %ebp
  8039e4:	89 e5                	mov    %esp,%ebp
  8039e6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039e9:	83 ec 04             	sub    $0x4,%esp
  8039ec:	68 c0 46 80 00       	push   $0x8046c0
  8039f1:	68 58 02 00 00       	push   $0x258
  8039f6:	68 c9 45 80 00       	push   $0x8045c9
  8039fb:	e8 2c ca ff ff       	call   80042c <_panic>

00803a00 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a00:	55                   	push   %ebp
  803a01:	89 e5                	mov    %esp,%ebp
  803a03:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	68 e8 46 80 00       	push   $0x8046e8
  803a0e:	68 61 02 00 00       	push   $0x261
  803a13:	68 c9 45 80 00       	push   $0x8045c9
  803a18:	e8 0f ca ff ff       	call   80042c <_panic>
  803a1d:	66 90                	xchg   %ax,%ax
  803a1f:	90                   	nop

00803a20 <__udivdi3>:
  803a20:	55                   	push   %ebp
  803a21:	57                   	push   %edi
  803a22:	56                   	push   %esi
  803a23:	53                   	push   %ebx
  803a24:	83 ec 1c             	sub    $0x1c,%esp
  803a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a37:	89 ca                	mov    %ecx,%edx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a3f:	85 f6                	test   %esi,%esi
  803a41:	75 2d                	jne    803a70 <__udivdi3+0x50>
  803a43:	39 cf                	cmp    %ecx,%edi
  803a45:	77 65                	ja     803aac <__udivdi3+0x8c>
  803a47:	89 fd                	mov    %edi,%ebp
  803a49:	85 ff                	test   %edi,%edi
  803a4b:	75 0b                	jne    803a58 <__udivdi3+0x38>
  803a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a52:	31 d2                	xor    %edx,%edx
  803a54:	f7 f7                	div    %edi
  803a56:	89 c5                	mov    %eax,%ebp
  803a58:	31 d2                	xor    %edx,%edx
  803a5a:	89 c8                	mov    %ecx,%eax
  803a5c:	f7 f5                	div    %ebp
  803a5e:	89 c1                	mov    %eax,%ecx
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f5                	div    %ebp
  803a64:	89 cf                	mov    %ecx,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 ce                	cmp    %ecx,%esi
  803a72:	77 28                	ja     803a9c <__udivdi3+0x7c>
  803a74:	0f bd fe             	bsr    %esi,%edi
  803a77:	83 f7 1f             	xor    $0x1f,%edi
  803a7a:	75 40                	jne    803abc <__udivdi3+0x9c>
  803a7c:	39 ce                	cmp    %ecx,%esi
  803a7e:	72 0a                	jb     803a8a <__udivdi3+0x6a>
  803a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a84:	0f 87 9e 00 00 00    	ja     803b28 <__udivdi3+0x108>
  803a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8f:	89 fa                	mov    %edi,%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	31 c0                	xor    %eax,%eax
  803aa0:	89 fa                	mov    %edi,%edx
  803aa2:	83 c4 1c             	add    $0x1c,%esp
  803aa5:	5b                   	pop    %ebx
  803aa6:	5e                   	pop    %esi
  803aa7:	5f                   	pop    %edi
  803aa8:	5d                   	pop    %ebp
  803aa9:	c3                   	ret    
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	89 d8                	mov    %ebx,%eax
  803aae:	f7 f7                	div    %edi
  803ab0:	31 ff                	xor    %edi,%edi
  803ab2:	89 fa                	mov    %edi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ac1:	89 eb                	mov    %ebp,%ebx
  803ac3:	29 fb                	sub    %edi,%ebx
  803ac5:	89 f9                	mov    %edi,%ecx
  803ac7:	d3 e6                	shl    %cl,%esi
  803ac9:	89 c5                	mov    %eax,%ebp
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ed                	shr    %cl,%ebp
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	09 f1                	or     %esi,%ecx
  803ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ad7:	89 f9                	mov    %edi,%ecx
  803ad9:	d3 e0                	shl    %cl,%eax
  803adb:	89 c5                	mov    %eax,%ebp
  803add:	89 d6                	mov    %edx,%esi
  803adf:	88 d9                	mov    %bl,%cl
  803ae1:	d3 ee                	shr    %cl,%esi
  803ae3:	89 f9                	mov    %edi,%ecx
  803ae5:	d3 e2                	shl    %cl,%edx
  803ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aeb:	88 d9                	mov    %bl,%cl
  803aed:	d3 e8                	shr    %cl,%eax
  803aef:	09 c2                	or     %eax,%edx
  803af1:	89 d0                	mov    %edx,%eax
  803af3:	89 f2                	mov    %esi,%edx
  803af5:	f7 74 24 0c          	divl   0xc(%esp)
  803af9:	89 d6                	mov    %edx,%esi
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	f7 e5                	mul    %ebp
  803aff:	39 d6                	cmp    %edx,%esi
  803b01:	72 19                	jb     803b1c <__udivdi3+0xfc>
  803b03:	74 0b                	je     803b10 <__udivdi3+0xf0>
  803b05:	89 d8                	mov    %ebx,%eax
  803b07:	31 ff                	xor    %edi,%edi
  803b09:	e9 58 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b14:	89 f9                	mov    %edi,%ecx
  803b16:	d3 e2                	shl    %cl,%edx
  803b18:	39 c2                	cmp    %eax,%edx
  803b1a:	73 e9                	jae    803b05 <__udivdi3+0xe5>
  803b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b1f:	31 ff                	xor    %edi,%edi
  803b21:	e9 40 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	31 c0                	xor    %eax,%eax
  803b2a:	e9 37 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b2f:	90                   	nop

00803b30 <__umoddi3>:
  803b30:	55                   	push   %ebp
  803b31:	57                   	push   %edi
  803b32:	56                   	push   %esi
  803b33:	53                   	push   %ebx
  803b34:	83 ec 1c             	sub    $0x1c,%esp
  803b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b4f:	89 f3                	mov    %esi,%ebx
  803b51:	89 fa                	mov    %edi,%edx
  803b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b57:	89 34 24             	mov    %esi,(%esp)
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	75 1a                	jne    803b78 <__umoddi3+0x48>
  803b5e:	39 f7                	cmp    %esi,%edi
  803b60:	0f 86 a2 00 00 00    	jbe    803c08 <__umoddi3+0xd8>
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	89 f2                	mov    %esi,%edx
  803b6a:	f7 f7                	div    %edi
  803b6c:	89 d0                	mov    %edx,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 f0                	cmp    %esi,%eax
  803b7a:	0f 87 ac 00 00 00    	ja     803c2c <__umoddi3+0xfc>
  803b80:	0f bd e8             	bsr    %eax,%ebp
  803b83:	83 f5 1f             	xor    $0x1f,%ebp
  803b86:	0f 84 ac 00 00 00    	je     803c38 <__umoddi3+0x108>
  803b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b91:	29 ef                	sub    %ebp,%edi
  803b93:	89 fe                	mov    %edi,%esi
  803b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b99:	89 e9                	mov    %ebp,%ecx
  803b9b:	d3 e0                	shl    %cl,%eax
  803b9d:	89 d7                	mov    %edx,%edi
  803b9f:	89 f1                	mov    %esi,%ecx
  803ba1:	d3 ef                	shr    %cl,%edi
  803ba3:	09 c7                	or     %eax,%edi
  803ba5:	89 e9                	mov    %ebp,%ecx
  803ba7:	d3 e2                	shl    %cl,%edx
  803ba9:	89 14 24             	mov    %edx,(%esp)
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	d3 e0                	shl    %cl,%eax
  803bb0:	89 c2                	mov    %eax,%edx
  803bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb6:	d3 e0                	shl    %cl,%eax
  803bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc0:	89 f1                	mov    %esi,%ecx
  803bc2:	d3 e8                	shr    %cl,%eax
  803bc4:	09 d0                	or     %edx,%eax
  803bc6:	d3 eb                	shr    %cl,%ebx
  803bc8:	89 da                	mov    %ebx,%edx
  803bca:	f7 f7                	div    %edi
  803bcc:	89 d3                	mov    %edx,%ebx
  803bce:	f7 24 24             	mull   (%esp)
  803bd1:	89 c6                	mov    %eax,%esi
  803bd3:	89 d1                	mov    %edx,%ecx
  803bd5:	39 d3                	cmp    %edx,%ebx
  803bd7:	0f 82 87 00 00 00    	jb     803c64 <__umoddi3+0x134>
  803bdd:	0f 84 91 00 00 00    	je     803c74 <__umoddi3+0x144>
  803be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803be7:	29 f2                	sub    %esi,%edx
  803be9:	19 cb                	sbb    %ecx,%ebx
  803beb:	89 d8                	mov    %ebx,%eax
  803bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	d3 ea                	shr    %cl,%edx
  803bf7:	09 d0                	or     %edx,%eax
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 eb                	shr    %cl,%ebx
  803bfd:	89 da                	mov    %ebx,%edx
  803bff:	83 c4 1c             	add    $0x1c,%esp
  803c02:	5b                   	pop    %ebx
  803c03:	5e                   	pop    %esi
  803c04:	5f                   	pop    %edi
  803c05:	5d                   	pop    %ebp
  803c06:	c3                   	ret    
  803c07:	90                   	nop
  803c08:	89 fd                	mov    %edi,%ebp
  803c0a:	85 ff                	test   %edi,%edi
  803c0c:	75 0b                	jne    803c19 <__umoddi3+0xe9>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f7                	div    %edi
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 f0                	mov    %esi,%eax
  803c1b:	31 d2                	xor    %edx,%edx
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 c8                	mov    %ecx,%eax
  803c21:	f7 f5                	div    %ebp
  803c23:	89 d0                	mov    %edx,%eax
  803c25:	e9 44 ff ff ff       	jmp    803b6e <__umoddi3+0x3e>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	89 c8                	mov    %ecx,%eax
  803c2e:	89 f2                	mov    %esi,%edx
  803c30:	83 c4 1c             	add    $0x1c,%esp
  803c33:	5b                   	pop    %ebx
  803c34:	5e                   	pop    %esi
  803c35:	5f                   	pop    %edi
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    
  803c38:	3b 04 24             	cmp    (%esp),%eax
  803c3b:	72 06                	jb     803c43 <__umoddi3+0x113>
  803c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c41:	77 0f                	ja     803c52 <__umoddi3+0x122>
  803c43:	89 f2                	mov    %esi,%edx
  803c45:	29 f9                	sub    %edi,%ecx
  803c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c4b:	89 14 24             	mov    %edx,(%esp)
  803c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c56:	8b 14 24             	mov    (%esp),%edx
  803c59:	83 c4 1c             	add    $0x1c,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5e                   	pop    %esi
  803c5e:	5f                   	pop    %edi
  803c5f:	5d                   	pop    %ebp
  803c60:	c3                   	ret    
  803c61:	8d 76 00             	lea    0x0(%esi),%esi
  803c64:	2b 04 24             	sub    (%esp),%eax
  803c67:	19 fa                	sbb    %edi,%edx
  803c69:	89 d1                	mov    %edx,%ecx
  803c6b:	89 c6                	mov    %eax,%esi
  803c6d:	e9 71 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c78:	72 ea                	jb     803c64 <__umoddi3+0x134>
  803c7a:	89 d9                	mov    %ebx,%ecx
  803c7c:	e9 62 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
