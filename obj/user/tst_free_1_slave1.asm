
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
  800060:	68 80 3c 80 00       	push   $0x803c80
  800065:	6a 11                	push   $0x11
  800067:	68 9c 3c 80 00       	push   $0x803c9c
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
  8000bc:	e8 aa 19 00 00       	call   801a6b <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 ed 19 00 00       	call   801ab6 <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 b8 3c 80 00       	push   $0x803cb8
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 9c 3c 80 00       	push   $0x803c9c
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 ac 19 00 00       	call   801ab6 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 e8 3c 80 00       	push   $0x803ce8
  800117:	6a 33                	push   $0x33
  800119:	68 9c 3c 80 00       	push   $0x803c9c
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 43 19 00 00       	call   801a6b <sys_calculate_free_frames>
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
  80015f:	e8 07 19 00 00       	call   801a6b <sys_calculate_free_frames>
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
  800181:	6a 3d                	push   $0x3d
  800183:	68 9c 3c 80 00       	push   $0x803c9c
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
  8001c7:	e8 fa 1c 00 00       	call   801ec6 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 94 3d 80 00       	push   $0x803d94
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 9c 3c 80 00       	push   $0x803c9c
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 7a 18 00 00       	call   801a6b <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 bd 18 00 00       	call   801ab6 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 a3 18 00 00       	call   801ab6 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 b4 3d 80 00       	push   $0x803db4
  800220:	6a 4e                	push   $0x4e
  800222:	68 9c 3c 80 00       	push   $0x803c9c
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 3a 18 00 00       	call   801a6b <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 f0 3d 80 00       	push   $0x803df0
  800247:	6a 4f                	push   $0x4f
  800249:	68 9c 3c 80 00       	push   $0x803c9c
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
  80028d:	e8 34 1c 00 00       	call   801ec6 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 3c 3e 80 00       	push   $0x803e3c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 9c 3c 80 00       	push   $0x803c9c
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 bb 1a 00 00       	call   801d72 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 cf 1a 00 00       	call   801d8c <gettst>
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
  8002d4:	e8 99 1a 00 00       	call   801d72 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 60 3e 80 00       	push   $0x803e60
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 9c 3c 80 00       	push   $0x803c9c
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
  8002f3:	e8 3c 19 00 00       	call   801c34 <sys_getenvindex>
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
  800361:	e8 52 16 00 00       	call   8019b8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 c4 3e 80 00       	push   $0x803ec4
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
  800391:	68 ec 3e 80 00       	push   $0x803eec
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
  8003c2:	68 14 3f 80 00       	push   $0x803f14
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 6c 3f 80 00       	push   $0x803f6c
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 c4 3e 80 00       	push   $0x803ec4
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 d2 15 00 00       	call   8019d2 <sys_unlock_cons>
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
  800413:	e8 e8 17 00 00       	call   801c00 <sys_destroy_env>
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
  800424:	e8 3d 18 00 00       	call   801c66 <sys_exit_env>
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
  80044d:	68 80 3f 80 00       	push   $0x803f80
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 85 3f 80 00       	push   $0x803f85
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
  80048a:	68 a1 3f 80 00       	push   $0x803fa1
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
  8004b9:	68 a4 3f 80 00       	push   $0x803fa4
  8004be:	6a 26                	push   $0x26
  8004c0:	68 f0 3f 80 00       	push   $0x803ff0
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
  80058e:	68 fc 3f 80 00       	push   $0x803ffc
  800593:	6a 3a                	push   $0x3a
  800595:	68 f0 3f 80 00       	push   $0x803ff0
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
  800601:	68 50 40 80 00       	push   $0x804050
  800606:	6a 44                	push   $0x44
  800608:	68 f0 3f 80 00       	push   $0x803ff0
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
  80065b:	e8 16 13 00 00       	call   801976 <sys_cputs>
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
  8006d2:	e8 9f 12 00 00       	call   801976 <sys_cputs>
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
  80071c:	e8 97 12 00 00       	call   8019b8 <sys_lock_cons>
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
  80073c:	e8 91 12 00 00       	call   8019d2 <sys_unlock_cons>
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
  800786:	e8 85 32 00 00       	call   803a10 <__udivdi3>
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
  8007d6:	e8 45 33 00 00       	call   803b20 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  800931:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  800a12:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 c5 42 80 00       	push   $0x8042c5
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
  800a37:	68 ce 42 80 00       	push   $0x8042ce
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
  800a64:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  80146f:	68 48 44 80 00       	push   $0x804448
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 6a 44 80 00       	push   $0x80446a
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
  80148f:	e8 8d 0a 00 00       	call   801f21 <sys_sbrk>
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
  80150a:	e8 96 08 00 00       	call   801da5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 d6 0d 00 00       	call   8022f4 <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 a8 08 00 00       	call   801dd6 <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 6f 12 00 00       	call   8027b0 <alloc_block_BF>
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
  8016a2:	e8 b1 08 00 00       	call   801f58 <sys_allocate_user_mem>
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
  8016ea:	e8 85 08 00 00       	call   801f74 <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 b8 1a 00 00       	call   8031b8 <free_block>
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
  801792:	e8 a5 07 00 00       	call   801f3c <sys_free_user_mem>
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
  8017a0:	68 78 44 80 00       	push   $0x804478
  8017a5:	68 84 00 00 00       	push   $0x84
  8017aa:	68 a2 44 80 00       	push   $0x8044a2
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
  8017cd:	eb 64                	jmp    801833 <smalloc+0x7d>
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
  801802:	eb 2f                	jmp    801833 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801804:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801808:	ff 75 ec             	pushl  -0x14(%ebp)
  80180b:	50                   	push   %eax
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	e8 2c 03 00 00       	call   801b43 <sys_createSharedObject>
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80181d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801821:	74 06                	je     801829 <smalloc+0x73>
  801823:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801827:	75 07                	jne    801830 <smalloc+0x7a>
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	eb 03                	jmp    801833 <smalloc+0x7d>
	 return ptr;
  801830:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	e8 24 03 00 00       	call   801b6d <sys_getSizeOfSharedObject>
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80184f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801853:	75 07                	jne    80185c <sget+0x27>
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	eb 5c                	jmp    8018b8 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801862:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801869:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186f:	39 d0                	cmp    %edx,%eax
  801871:	7d 02                	jge    801875 <sget+0x40>
  801873:	89 d0                	mov    %edx,%eax
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	50                   	push   %eax
  801879:	e8 1b fc ff ff       	call   801499 <malloc>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801884:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801888:	75 07                	jne    801891 <sget+0x5c>
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	eb 27                	jmp    8018b8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	ff 75 e8             	pushl  -0x18(%ebp)
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	e8 e8 02 00 00       	call   801b8a <sys_getSharedObject>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018a8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018ac:	75 07                	jne    8018b5 <sget+0x80>
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b3:	eb 03                	jmp    8018b8 <sget+0x83>
	return ptr;
  8018b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 b0 44 80 00       	push   $0x8044b0
  8018c8:	68 c1 00 00 00       	push   $0xc1
  8018cd:	68 a2 44 80 00       	push   $0x8044a2
  8018d2:	e8 55 eb ff ff       	call   80042c <_panic>

008018d7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 d4 44 80 00       	push   $0x8044d4
  8018e5:	68 d8 00 00 00       	push   $0xd8
  8018ea:	68 a2 44 80 00       	push   $0x8044a2
  8018ef:	e8 38 eb ff ff       	call   80042c <_panic>

008018f4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	68 fa 44 80 00       	push   $0x8044fa
  801902:	68 e4 00 00 00       	push   $0xe4
  801907:	68 a2 44 80 00       	push   $0x8044a2
  80190c:	e8 1b eb ff ff       	call   80042c <_panic>

00801911 <shrink>:

}
void shrink(uint32 newSize)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	68 fa 44 80 00       	push   $0x8044fa
  80191f:	68 e9 00 00 00       	push   $0xe9
  801924:	68 a2 44 80 00       	push   $0x8044a2
  801929:	e8 fe ea ff ff       	call   80042c <_panic>

0080192e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 fa 44 80 00       	push   $0x8044fa
  80193c:	68 ee 00 00 00       	push   $0xee
  801941:	68 a2 44 80 00       	push   $0x8044a2
  801946:	e8 e1 ea ff ff       	call   80042c <_panic>

0080194b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801960:	8b 7d 18             	mov    0x18(%ebp),%edi
  801963:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801966:	cd 30                	int    $0x30
  801968:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	8b 45 10             	mov    0x10(%ebp),%eax
  80197f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801982:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	6a 00                	push   $0x0
  801994:	e8 b2 ff ff ff       	call   80194b <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_cgetc>:

int
sys_cgetc(void)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 02                	push   $0x2
  8019ae:	e8 98 ff ff ff       	call   80194b <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 03                	push   $0x3
  8019c7:	e8 7f ff ff ff       	call   80194b <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 04                	push   $0x4
  8019e1:	e8 65 ff ff ff       	call   80194b <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	50                   	push   %eax
  8019fd:	6a 08                	push   $0x8
  8019ff:	e8 47 ff ff ff       	call   80194b <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a0e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	51                   	push   %ecx
  801a20:	52                   	push   %edx
  801a21:	50                   	push   %eax
  801a22:	6a 09                	push   $0x9
  801a24:	e8 22 ff ff ff       	call   80194b <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    

00801a33 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 0a                	push   $0xa
  801a46:	e8 00 ff ff ff       	call   80194b <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 0b                	push   $0xb
  801a61:	e8 e5 fe ff ff       	call   80194b <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 0c                	push   $0xc
  801a7a:	e8 cc fe ff ff       	call   80194b <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 0d                	push   $0xd
  801a93:	e8 b3 fe ff ff       	call   80194b <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 0e                	push   $0xe
  801aac:	e8 9a fe ff ff       	call   80194b <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 0f                	push   $0xf
  801ac5:	e8 81 fe ff ff       	call   80194b <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 10                	push   $0x10
  801adf:	e8 67 fe ff ff       	call   80194b <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 11                	push   $0x11
  801af8:	e8 4e fe ff ff       	call   80194b <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	50                   	push   %eax
  801b1c:	6a 01                	push   $0x1
  801b1e:	e8 28 fe ff ff       	call   80194b <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 14                	push   $0x14
  801b38:	e8 0e fe ff ff       	call   80194b <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 04             	sub    $0x4,%esp
  801b49:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b52:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	51                   	push   %ecx
  801b5c:	52                   	push   %edx
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	50                   	push   %eax
  801b61:	6a 15                	push   $0x15
  801b63:	e8 e3 fd ff ff       	call   80194b <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 16                	push   $0x16
  801b80:	e8 c6 fd ff ff       	call   80194b <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	51                   	push   %ecx
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 17                	push   $0x17
  801b9f:	e8 a7 fd ff ff       	call   80194b <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 18                	push   $0x18
  801bbc:	e8 8a fd ff ff       	call   80194b <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 14             	pushl  0x14(%ebp)
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	50                   	push   %eax
  801bd8:	6a 19                	push   $0x19
  801bda:	e8 6c fd ff ff       	call   80194b <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	50                   	push   %eax
  801bf3:	6a 1a                	push   $0x1a
  801bf5:	e8 51 fd ff ff       	call   80194b <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	90                   	nop
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	50                   	push   %eax
  801c0f:	6a 1b                	push   $0x1b
  801c11:	e8 35 fd ff ff       	call   80194b <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 05                	push   $0x5
  801c2a:	e8 1c fd ff ff       	call   80194b <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 06                	push   $0x6
  801c43:	e8 03 fd ff ff       	call   80194b <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 07                	push   $0x7
  801c5c:	e8 ea fc ff ff       	call   80194b <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_exit_env>:


void sys_exit_env(void)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 1c                	push   $0x1c
  801c75:	e8 d1 fc ff ff       	call   80194b <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	90                   	nop
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c89:	8d 50 04             	lea    0x4(%eax),%edx
  801c8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	6a 1d                	push   $0x1d
  801c99:	e8 ad fc ff ff       	call   80194b <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
	return result;
  801ca1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801caa:	89 01                	mov    %eax,(%ecx)
  801cac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	c9                   	leave  
  801cb3:	c2 04 00             	ret    $0x4

00801cb6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	ff 75 10             	pushl  0x10(%ebp)
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 13                	push   $0x13
  801cc8:	e8 7e fc ff ff       	call   80194b <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 1e                	push   $0x1e
  801ce2:	e8 64 fc ff ff       	call   80194b <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 04             	sub    $0x4,%esp
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	50                   	push   %eax
  801d05:	6a 1f                	push   $0x1f
  801d07:	e8 3f fc ff ff       	call   80194b <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <rsttst>:
void rsttst()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 21                	push   $0x21
  801d21:	e8 25 fc ff ff       	call   80194b <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return ;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 04             	sub    $0x4,%esp
  801d32:	8b 45 14             	mov    0x14(%ebp),%eax
  801d35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d38:	8b 55 18             	mov    0x18(%ebp),%edx
  801d3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d3f:	52                   	push   %edx
  801d40:	50                   	push   %eax
  801d41:	ff 75 10             	pushl  0x10(%ebp)
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 20                	push   $0x20
  801d4c:	e8 fa fb ff ff       	call   80194b <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <chktst>:
void chktst(uint32 n)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 22                	push   $0x22
  801d67:	e8 df fb ff ff       	call   80194b <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <inctst>:

void inctst()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 23                	push   $0x23
  801d81:	e8 c5 fb ff ff       	call   80194b <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return ;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <gettst>:
uint32 gettst()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 24                	push   $0x24
  801d9b:	e8 ab fb ff ff       	call   80194b <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801db7:	e8 8f fb ff ff       	call   80194b <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801de8:	e8 5e fb ff ff       	call   80194b <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 25                	push   $0x25
  801e19:	e8 2d fb ff ff       	call   80194b <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e24:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 25                	push   $0x25
  801e4a:	e8 fc fa ff ff       	call   80194b <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e55:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e59:	75 07                	jne    801e62 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	eb 05                	jmp    801e67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 26                	push   $0x26
  801e79:	e8 cd fa ff ff       	call   80194b <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	53                   	push   %ebx
  801e97:	51                   	push   %ecx
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 27                	push   $0x27
  801e9c:	e8 aa fa ff ff       	call   80194b <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	52                   	push   %edx
  801eb9:	50                   	push   %eax
  801eba:	6a 28                	push   $0x28
  801ebc:	e8 8a fa ff ff       	call   80194b <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ec9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	51                   	push   %ecx
  801ed5:	ff 75 10             	pushl  0x10(%ebp)
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	6a 29                	push   $0x29
  801edc:	e8 6a fa ff ff       	call   80194b <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	ff 75 10             	pushl  0x10(%ebp)
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	6a 12                	push   $0x12
  801ef8:	e8 4e fa ff ff       	call   80194b <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 2a                	push   $0x2a
  801f16:	e8 30 fa ff ff       	call   80194b <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return;
  801f1e:	90                   	nop
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	50                   	push   %eax
  801f30:	6a 2b                	push   $0x2b
  801f32:	e8 14 fa ff ff       	call   80194b <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	6a 2c                	push   $0x2c
  801f4d:	e8 f9 f9 ff ff       	call   80194b <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
	return;
  801f55:	90                   	nop
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	6a 2d                	push   $0x2d
  801f69:	e8 dd f9 ff ff       	call   80194b <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	83 e8 04             	sub    $0x4,%eax
  801f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	83 e8 04             	sub    $0x4,%eax
  801f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9f:	8b 00                	mov    (%eax),%eax
  801fa1:	83 e0 01             	and    $0x1,%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	0f 94 c0             	sete   %al
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	83 f8 02             	cmp    $0x2,%eax
  801fbe:	74 2b                	je     801feb <alloc_block+0x40>
  801fc0:	83 f8 02             	cmp    $0x2,%eax
  801fc3:	7f 07                	jg     801fcc <alloc_block+0x21>
  801fc5:	83 f8 01             	cmp    $0x1,%eax
  801fc8:	74 0e                	je     801fd8 <alloc_block+0x2d>
  801fca:	eb 58                	jmp    802024 <alloc_block+0x79>
  801fcc:	83 f8 03             	cmp    $0x3,%eax
  801fcf:	74 2d                	je     801ffe <alloc_block+0x53>
  801fd1:	83 f8 04             	cmp    $0x4,%eax
  801fd4:	74 3b                	je     802011 <alloc_block+0x66>
  801fd6:	eb 4c                	jmp    802024 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	ff 75 08             	pushl  0x8(%ebp)
  801fde:	e8 11 03 00 00       	call   8022f4 <alloc_block_FF>
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe9:	eb 4a                	jmp    802035 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	e8 fa 19 00 00       	call   8039f0 <alloc_block_NF>
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ffc:	eb 37                	jmp    802035 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	e8 a7 07 00 00       	call   8027b0 <alloc_block_BF>
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80200f:	eb 24                	jmp    802035 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	e8 b7 19 00 00       	call   8039d3 <alloc_block_WF>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802022:	eb 11                	jmp    802035 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	68 0c 45 80 00       	push   $0x80450c
  80202c:	e8 b8 e6 ff ff       	call   8006e9 <cprintf>
  802031:	83 c4 10             	add    $0x10,%esp
		break;
  802034:	90                   	nop
	}
	return va;
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	53                   	push   %ebx
  80203e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	68 2c 45 80 00       	push   $0x80452c
  802049:	e8 9b e6 ff ff       	call   8006e9 <cprintf>
  80204e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	68 57 45 80 00       	push   $0x804557
  802059:	e8 8b e6 ff ff       	call   8006e9 <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802067:	eb 37                	jmp    8020a0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	ff 75 f4             	pushl  -0xc(%ebp)
  80206f:	e8 19 ff ff ff       	call   801f8d <is_free_block>
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	0f be d8             	movsbl %al,%ebx
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	ff 75 f4             	pushl  -0xc(%ebp)
  802080:	e8 ef fe ff ff       	call   801f74 <get_block_size>
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	53                   	push   %ebx
  80208c:	50                   	push   %eax
  80208d:	68 6f 45 80 00       	push   $0x80456f
  802092:	e8 52 e6 ff ff       	call   8006e9 <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80209a:	8b 45 10             	mov    0x10(%ebp),%eax
  80209d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a4:	74 07                	je     8020ad <print_blocks_list+0x73>
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 00                	mov    (%eax),%eax
  8020ab:	eb 05                	jmp    8020b2 <print_blocks_list+0x78>
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	89 45 10             	mov    %eax,0x10(%ebp)
  8020b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	75 ad                	jne    802069 <print_blocks_list+0x2f>
  8020bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c0:	75 a7                	jne    802069 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	68 2c 45 80 00       	push   $0x80452c
  8020ca:	e8 1a e6 ff ff       	call   8006e9 <cprintf>
  8020cf:	83 c4 10             	add    $0x10,%esp

}
  8020d2:	90                   	nop
  8020d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	83 e0 01             	and    $0x1,%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	74 03                	je     8020eb <initialize_dynamic_allocator+0x13>
  8020e8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ef:	0f 84 c7 01 00 00    	je     8022bc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020f5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020fc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	01 d0                	add    %edx,%eax
  802107:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80210c:	0f 87 ad 01 00 00    	ja     8022bf <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	85 c0                	test   %eax,%eax
  802117:	0f 89 a5 01 00 00    	jns    8022c2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80211d:	8b 55 08             	mov    0x8(%ebp),%edx
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	01 d0                	add    %edx,%eax
  802125:	83 e8 04             	sub    $0x4,%eax
  802128:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80212d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802134:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213c:	e9 87 00 00 00       	jmp    8021c8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802145:	75 14                	jne    80215b <initialize_dynamic_allocator+0x83>
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 87 45 80 00       	push   $0x804587
  80214f:	6a 79                	push   $0x79
  802151:	68 a5 45 80 00       	push   $0x8045a5
  802156:	e8 d1 e2 ff ff       	call   80042c <_panic>
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	74 10                	je     802174 <initialize_dynamic_allocator+0x9c>
  802164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802167:	8b 00                	mov    (%eax),%eax
  802169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216c:	8b 52 04             	mov    0x4(%edx),%edx
  80216f:	89 50 04             	mov    %edx,0x4(%eax)
  802172:	eb 0b                	jmp    80217f <initialize_dynamic_allocator+0xa7>
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 40 04             	mov    0x4(%eax),%eax
  80217a:	a3 30 50 80 00       	mov    %eax,0x805030
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	74 0f                	je     802198 <initialize_dynamic_allocator+0xc0>
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 40 04             	mov    0x4(%eax),%eax
  80218f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802192:	8b 12                	mov    (%edx),%edx
  802194:	89 10                	mov    %edx,(%eax)
  802196:	eb 0a                	jmp    8021a2 <initialize_dynamic_allocator+0xca>
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ba:	48                   	dec    %eax
  8021bb:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8021c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cc:	74 07                	je     8021d5 <initialize_dynamic_allocator+0xfd>
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	eb 05                	jmp    8021da <initialize_dynamic_allocator+0x102>
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	a3 34 50 80 00       	mov    %eax,0x805034
  8021df:	a1 34 50 80 00       	mov    0x805034,%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	0f 85 55 ff ff ff    	jne    802141 <initialize_dynamic_allocator+0x69>
  8021ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f0:	0f 85 4b ff ff ff    	jne    802141 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802205:	a1 44 50 80 00       	mov    0x805044,%eax
  80220a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80220f:	a1 40 50 80 00       	mov    0x805040,%eax
  802214:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	83 c0 08             	add    $0x8,%eax
  802220:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	83 c0 04             	add    $0x4,%eax
  802229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222c:	83 ea 08             	sub    $0x8,%edx
  80222f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	01 d0                	add    %edx,%eax
  802239:	83 e8 08             	sub    $0x8,%eax
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223f:	83 ea 08             	sub    $0x8,%edx
  802242:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225b:	75 17                	jne    802274 <initialize_dynamic_allocator+0x19c>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 c0 45 80 00       	push   $0x8045c0
  802265:	68 90 00 00 00       	push   $0x90
  80226a:	68 a5 45 80 00       	push   $0x8045a5
  80226f:	e8 b8 e1 ff ff       	call   80042c <_panic>
  802274:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80227a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227d:	89 10                	mov    %edx,(%eax)
  80227f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 0d                	je     802295 <initialize_dynamic_allocator+0x1bd>
  802288:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80228d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802290:	89 50 04             	mov    %edx,0x4(%eax)
  802293:	eb 08                	jmp    80229d <initialize_dynamic_allocator+0x1c5>
  802295:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802298:	a3 30 50 80 00       	mov    %eax,0x805030
  80229d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022af:	a1 38 50 80 00       	mov    0x805038,%eax
  8022b4:	40                   	inc    %eax
  8022b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8022ba:	eb 07                	jmp    8022c3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022bc:	90                   	nop
  8022bd:	eb 04                	jmp    8022c3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022bf:	90                   	nop
  8022c0:	eb 01                	jmp    8022c3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022c2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cb:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	83 e8 04             	sub    $0x4,%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8022e4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	01 c2                	add    %eax,%edx
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	89 02                	mov    %eax,(%edx)
}
  8022f1:	90                   	nop
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    

008022f4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	83 e0 01             	and    $0x1,%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	74 03                	je     802307 <alloc_block_FF+0x13>
  802304:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802307:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80230b:	77 07                	ja     802314 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80230d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802314:	a1 24 50 80 00       	mov    0x805024,%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	75 73                	jne    802390 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	83 c0 10             	add    $0x10,%eax
  802323:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802326:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80232d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802333:	01 d0                	add    %edx,%eax
  802335:	48                   	dec    %eax
  802336:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233c:	ba 00 00 00 00       	mov    $0x0,%edx
  802341:	f7 75 ec             	divl   -0x14(%ebp)
  802344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802347:	29 d0                	sub    %edx,%eax
  802349:	c1 e8 0c             	shr    $0xc,%eax
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	50                   	push   %eax
  802350:	e8 2e f1 ff ff       	call   801483 <sbrk>
  802355:	83 c4 10             	add    $0x10,%esp
  802358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80235b:	83 ec 0c             	sub    $0xc,%esp
  80235e:	6a 00                	push   $0x0
  802360:	e8 1e f1 ff ff       	call   801483 <sbrk>
  802365:	83 c4 10             	add    $0x10,%esp
  802368:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80236b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802371:	83 ec 08             	sub    $0x8,%esp
  802374:	50                   	push   %eax
  802375:	ff 75 e4             	pushl  -0x1c(%ebp)
  802378:	e8 5b fd ff ff       	call   8020d8 <initialize_dynamic_allocator>
  80237d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	68 e3 45 80 00       	push   $0x8045e3
  802388:	e8 5c e3 ff ff       	call   8006e9 <cprintf>
  80238d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802394:	75 0a                	jne    8023a0 <alloc_block_FF+0xac>
	        return NULL;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	e9 0e 04 00 00       	jmp    8027ae <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023af:	e9 f3 02 00 00       	jmp    8026a7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023ba:	83 ec 0c             	sub    $0xc,%esp
  8023bd:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c0:	e8 af fb ff ff       	call   801f74 <get_block_size>
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	83 c0 08             	add    $0x8,%eax
  8023d1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023d4:	0f 87 c5 02 00 00    	ja     80269f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	83 c0 18             	add    $0x18,%eax
  8023e0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023e3:	0f 87 19 02 00 00    	ja     802602 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ef:	83 e8 08             	sub    $0x8,%eax
  8023f2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	8d 50 08             	lea    0x8(%eax),%edx
  8023fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023fe:	01 d0                	add    %edx,%eax
  802400:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	83 c0 08             	add    $0x8,%eax
  802409:	83 ec 04             	sub    $0x4,%esp
  80240c:	6a 01                	push   $0x1
  80240e:	50                   	push   %eax
  80240f:	ff 75 bc             	pushl  -0x44(%ebp)
  802412:	e8 ae fe ff ff       	call   8022c5 <set_block_data>
  802417:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	75 68                	jne    80248c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802424:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802428:	75 17                	jne    802441 <alloc_block_FF+0x14d>
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	68 c0 45 80 00       	push   $0x8045c0
  802432:	68 d7 00 00 00       	push   $0xd7
  802437:	68 a5 45 80 00       	push   $0x8045a5
  80243c:	e8 eb df ff ff       	call   80042c <_panic>
  802441:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802447:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244a:	89 10                	mov    %edx,(%eax)
  80244c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 0d                	je     802462 <alloc_block_FF+0x16e>
  802455:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80245a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
  802460:	eb 08                	jmp    80246a <alloc_block_FF+0x176>
  802462:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802465:	a3 30 50 80 00       	mov    %eax,0x805030
  80246a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802472:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247c:	a1 38 50 80 00       	mov    0x805038,%eax
  802481:	40                   	inc    %eax
  802482:	a3 38 50 80 00       	mov    %eax,0x805038
  802487:	e9 dc 00 00 00       	jmp    802568 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	75 65                	jne    8024fa <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802495:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802499:	75 17                	jne    8024b2 <alloc_block_FF+0x1be>
  80249b:	83 ec 04             	sub    $0x4,%esp
  80249e:	68 f4 45 80 00       	push   $0x8045f4
  8024a3:	68 db 00 00 00       	push   $0xdb
  8024a8:	68 a5 45 80 00       	push   $0x8045a5
  8024ad:	e8 7a df ff ff       	call   80042c <_panic>
  8024b2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0c                	je     8024d4 <alloc_block_FF+0x1e0>
  8024c8:	a1 30 50 80 00       	mov    0x805030,%eax
  8024cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d0:	89 10                	mov    %edx,(%eax)
  8024d2:	eb 08                	jmp    8024dc <alloc_block_FF+0x1e8>
  8024d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024df:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f2:	40                   	inc    %eax
  8024f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8024f8:	eb 6e                	jmp    802568 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fe:	74 06                	je     802506 <alloc_block_FF+0x212>
  802500:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802504:	75 17                	jne    80251d <alloc_block_FF+0x229>
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	68 18 46 80 00       	push   $0x804618
  80250e:	68 df 00 00 00       	push   $0xdf
  802513:	68 a5 45 80 00       	push   $0x8045a5
  802518:	e8 0f df ff ff       	call   80042c <_panic>
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 10                	mov    (%eax),%edx
  802522:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802525:	89 10                	mov    %edx,(%eax)
  802527:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 0b                	je     80253b <alloc_block_FF+0x247>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802541:	89 10                	mov    %edx,(%eax)
  802543:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802549:	89 50 04             	mov    %edx,0x4(%eax)
  80254c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	75 08                	jne    80255d <alloc_block_FF+0x269>
  802555:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802558:	a3 30 50 80 00       	mov    %eax,0x805030
  80255d:	a1 38 50 80 00       	mov    0x805038,%eax
  802562:	40                   	inc    %eax
  802563:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256c:	75 17                	jne    802585 <alloc_block_FF+0x291>
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	68 87 45 80 00       	push   $0x804587
  802576:	68 e1 00 00 00       	push   $0xe1
  80257b:	68 a5 45 80 00       	push   $0x8045a5
  802580:	e8 a7 de ff ff       	call   80042c <_panic>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 10                	je     80259e <alloc_block_FF+0x2aa>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802596:	8b 52 04             	mov    0x4(%edx),%edx
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	eb 0b                	jmp    8025a9 <alloc_block_FF+0x2b5>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 0f                	je     8025c2 <alloc_block_FF+0x2ce>
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 04             	mov    0x4(%eax),%eax
  8025b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bc:	8b 12                	mov    (%edx),%edx
  8025be:	89 10                	mov    %edx,(%eax)
  8025c0:	eb 0a                	jmp    8025cc <alloc_block_FF+0x2d8>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025df:	a1 38 50 80 00       	mov    0x805038,%eax
  8025e4:	48                   	dec    %eax
  8025e5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	6a 00                	push   $0x0
  8025ef:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025f2:	ff 75 b0             	pushl  -0x50(%ebp)
  8025f5:	e8 cb fc ff ff       	call   8022c5 <set_block_data>
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	e9 95 00 00 00       	jmp    802697 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	6a 01                	push   $0x1
  802607:	ff 75 b8             	pushl  -0x48(%ebp)
  80260a:	ff 75 bc             	pushl  -0x44(%ebp)
  80260d:	e8 b3 fc ff ff       	call   8022c5 <set_block_data>
  802612:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	75 17                	jne    802632 <alloc_block_FF+0x33e>
  80261b:	83 ec 04             	sub    $0x4,%esp
  80261e:	68 87 45 80 00       	push   $0x804587
  802623:	68 e8 00 00 00       	push   $0xe8
  802628:	68 a5 45 80 00       	push   $0x8045a5
  80262d:	e8 fa dd ff ff       	call   80042c <_panic>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	74 10                	je     80264b <alloc_block_FF+0x357>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802643:	8b 52 04             	mov    0x4(%edx),%edx
  802646:	89 50 04             	mov    %edx,0x4(%eax)
  802649:	eb 0b                	jmp    802656 <alloc_block_FF+0x362>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	a3 30 50 80 00       	mov    %eax,0x805030
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	74 0f                	je     80266f <alloc_block_FF+0x37b>
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 04             	mov    0x4(%eax),%eax
  802666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802669:	8b 12                	mov    (%edx),%edx
  80266b:	89 10                	mov    %edx,(%eax)
  80266d:	eb 0a                	jmp    802679 <alloc_block_FF+0x385>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268c:	a1 38 50 80 00       	mov    0x805038,%eax
  802691:	48                   	dec    %eax
  802692:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802697:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80269a:	e9 0f 01 00 00       	jmp    8027ae <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80269f:	a1 34 50 80 00       	mov    0x805034,%eax
  8026a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ab:	74 07                	je     8026b4 <alloc_block_FF+0x3c0>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	eb 05                	jmp    8026b9 <alloc_block_FF+0x3c5>
  8026b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8026be:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 85 e9 fc ff ff    	jne    8023b4 <alloc_block_FF+0xc0>
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	0f 85 df fc ff ff    	jne    8023b4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	83 c0 08             	add    $0x8,%eax
  8026db:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026de:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026eb:	01 d0                	add    %edx,%eax
  8026ed:	48                   	dec    %eax
  8026ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f9:	f7 75 d8             	divl   -0x28(%ebp)
  8026fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ff:	29 d0                	sub    %edx,%eax
  802701:	c1 e8 0c             	shr    $0xc,%eax
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	50                   	push   %eax
  802708:	e8 76 ed ff ff       	call   801483 <sbrk>
  80270d:	83 c4 10             	add    $0x10,%esp
  802710:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802713:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802717:	75 0a                	jne    802723 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	e9 8b 00 00 00       	jmp    8027ae <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802723:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80272a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	48                   	dec    %eax
  802733:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802736:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802739:	ba 00 00 00 00       	mov    $0x0,%edx
  80273e:	f7 75 cc             	divl   -0x34(%ebp)
  802741:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802744:	29 d0                	sub    %edx,%eax
  802746:	8d 50 fc             	lea    -0x4(%eax),%edx
  802749:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802753:	a1 40 50 80 00       	mov    0x805040,%eax
  802758:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80275e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802765:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802768:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	48                   	dec    %eax
  80276e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802771:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802774:	ba 00 00 00 00       	mov    $0x0,%edx
  802779:	f7 75 c4             	divl   -0x3c(%ebp)
  80277c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80277f:	29 d0                	sub    %edx,%eax
  802781:	83 ec 04             	sub    $0x4,%esp
  802784:	6a 01                	push   $0x1
  802786:	50                   	push   %eax
  802787:	ff 75 d0             	pushl  -0x30(%ebp)
  80278a:	e8 36 fb ff ff       	call   8022c5 <set_block_data>
  80278f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802792:	83 ec 0c             	sub    $0xc,%esp
  802795:	ff 75 d0             	pushl  -0x30(%ebp)
  802798:	e8 1b 0a 00 00       	call   8031b8 <free_block>
  80279d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	ff 75 08             	pushl  0x8(%ebp)
  8027a6:	e8 49 fb ff ff       	call   8022f4 <alloc_block_FF>
  8027ab:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	83 e0 01             	and    $0x1,%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 03                	je     8027c3 <alloc_block_BF+0x13>
  8027c0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027c3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027c7:	77 07                	ja     8027d0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027c9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027d0:	a1 24 50 80 00       	mov    0x805024,%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	75 73                	jne    80284c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	83 c0 10             	add    $0x10,%eax
  8027df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027e2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ef:	01 d0                	add    %edx,%eax
  8027f1:	48                   	dec    %eax
  8027f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fd:	f7 75 e0             	divl   -0x20(%ebp)
  802800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802803:	29 d0                	sub    %edx,%eax
  802805:	c1 e8 0c             	shr    $0xc,%eax
  802808:	83 ec 0c             	sub    $0xc,%esp
  80280b:	50                   	push   %eax
  80280c:	e8 72 ec ff ff       	call   801483 <sbrk>
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802817:	83 ec 0c             	sub    $0xc,%esp
  80281a:	6a 00                	push   $0x0
  80281c:	e8 62 ec ff ff       	call   801483 <sbrk>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80282a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80282d:	83 ec 08             	sub    $0x8,%esp
  802830:	50                   	push   %eax
  802831:	ff 75 d8             	pushl  -0x28(%ebp)
  802834:	e8 9f f8 ff ff       	call   8020d8 <initialize_dynamic_allocator>
  802839:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80283c:	83 ec 0c             	sub    $0xc,%esp
  80283f:	68 e3 45 80 00       	push   $0x8045e3
  802844:	e8 a0 de ff ff       	call   8006e9 <cprintf>
  802849:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80284c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80285a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802861:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802868:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	e9 1d 01 00 00       	jmp    802992 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	ff 75 a8             	pushl  -0x58(%ebp)
  802881:	e8 ee f6 ff ff       	call   801f74 <get_block_size>
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	83 c0 08             	add    $0x8,%eax
  802892:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802895:	0f 87 ef 00 00 00    	ja     80298a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	83 c0 18             	add    $0x18,%eax
  8028a1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a4:	77 1d                	ja     8028c3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ac:	0f 86 d8 00 00 00    	jbe    80298a <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028b8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028be:	e9 c7 00 00 00       	jmp    80298a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	83 c0 08             	add    $0x8,%eax
  8028c9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028cc:	0f 85 9d 00 00 00    	jne    80296f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	6a 01                	push   $0x1
  8028d7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028da:	ff 75 a8             	pushl  -0x58(%ebp)
  8028dd:	e8 e3 f9 ff ff       	call   8022c5 <set_block_data>
  8028e2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e9:	75 17                	jne    802902 <alloc_block_BF+0x152>
  8028eb:	83 ec 04             	sub    $0x4,%esp
  8028ee:	68 87 45 80 00       	push   $0x804587
  8028f3:	68 2c 01 00 00       	push   $0x12c
  8028f8:	68 a5 45 80 00       	push   $0x8045a5
  8028fd:	e8 2a db ff ff       	call   80042c <_panic>
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	85 c0                	test   %eax,%eax
  802909:	74 10                	je     80291b <alloc_block_BF+0x16b>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802913:	8b 52 04             	mov    0x4(%edx),%edx
  802916:	89 50 04             	mov    %edx,0x4(%eax)
  802919:	eb 0b                	jmp    802926 <alloc_block_BF+0x176>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	a3 30 50 80 00       	mov    %eax,0x805030
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	74 0f                	je     80293f <alloc_block_BF+0x18f>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802939:	8b 12                	mov    (%edx),%edx
  80293b:	89 10                	mov    %edx,(%eax)
  80293d:	eb 0a                	jmp    802949 <alloc_block_BF+0x199>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295c:	a1 38 50 80 00       	mov    0x805038,%eax
  802961:	48                   	dec    %eax
  802962:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802967:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80296a:	e9 24 04 00 00       	jmp    802d93 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802975:	76 13                	jbe    80298a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802977:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80297e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802981:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802984:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802987:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80298a:	a1 34 50 80 00       	mov    0x805034,%eax
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	74 07                	je     80299f <alloc_block_BF+0x1ef>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	eb 05                	jmp    8029a4 <alloc_block_BF+0x1f4>
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a9:	a1 34 50 80 00       	mov    0x805034,%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	0f 85 bf fe ff ff    	jne    802875 <alloc_block_BF+0xc5>
  8029b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ba:	0f 85 b5 fe ff ff    	jne    802875 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c4:	0f 84 26 02 00 00    	je     802bf0 <alloc_block_BF+0x440>
  8029ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ce:	0f 85 1c 02 00 00    	jne    802bf0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029da:	83 e8 08             	sub    $0x8,%eax
  8029dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	8d 50 08             	lea    0x8(%eax),%edx
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	01 d0                	add    %edx,%eax
  8029eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	83 c0 08             	add    $0x8,%eax
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	6a 01                	push   $0x1
  8029f9:	50                   	push   %eax
  8029fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8029fd:	e8 c3 f8 ff ff       	call   8022c5 <set_block_data>
  802a02:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 40 04             	mov    0x4(%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	75 68                	jne    802a77 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a0f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a13:	75 17                	jne    802a2c <alloc_block_BF+0x27c>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 c0 45 80 00       	push   $0x8045c0
  802a1d:	68 45 01 00 00       	push   $0x145
  802a22:	68 a5 45 80 00       	push   $0x8045a5
  802a27:	e8 00 da ff ff       	call   80042c <_panic>
  802a2c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 0d                	je     802a4d <alloc_block_BF+0x29d>
  802a40:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a45:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	eb 08                	jmp    802a55 <alloc_block_BF+0x2a5>
  802a4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a50:	a3 30 50 80 00       	mov    %eax,0x805030
  802a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6c:	40                   	inc    %eax
  802a6d:	a3 38 50 80 00       	mov    %eax,0x805038
  802a72:	e9 dc 00 00 00       	jmp    802b53 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	75 65                	jne    802ae5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a80:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a84:	75 17                	jne    802a9d <alloc_block_BF+0x2ed>
  802a86:	83 ec 04             	sub    $0x4,%esp
  802a89:	68 f4 45 80 00       	push   $0x8045f4
  802a8e:	68 4a 01 00 00       	push   $0x14a
  802a93:	68 a5 45 80 00       	push   $0x8045a5
  802a98:	e8 8f d9 ff ff       	call   80042c <_panic>
  802a9d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa6:	89 50 04             	mov    %edx,0x4(%eax)
  802aa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0c                	je     802abf <alloc_block_BF+0x30f>
  802ab3:	a1 30 50 80 00       	mov    0x805030,%eax
  802ab8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	eb 08                	jmp    802ac7 <alloc_block_BF+0x317>
  802abf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aca:	a3 30 50 80 00       	mov    %eax,0x805030
  802acf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad8:	a1 38 50 80 00       	mov    0x805038,%eax
  802add:	40                   	inc    %eax
  802ade:	a3 38 50 80 00       	mov    %eax,0x805038
  802ae3:	eb 6e                	jmp    802b53 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ae5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae9:	74 06                	je     802af1 <alloc_block_BF+0x341>
  802aeb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aef:	75 17                	jne    802b08 <alloc_block_BF+0x358>
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	68 18 46 80 00       	push   $0x804618
  802af9:	68 4f 01 00 00       	push   $0x14f
  802afe:	68 a5 45 80 00       	push   $0x8045a5
  802b03:	e8 24 d9 ff ff       	call   80042c <_panic>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 10                	mov    (%eax),%edx
  802b0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b10:	89 10                	mov    %edx,(%eax)
  802b12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	74 0b                	je     802b26 <alloc_block_BF+0x376>
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b23:	89 50 04             	mov    %edx,0x4(%eax)
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2c:	89 10                	mov    %edx,(%eax)
  802b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b34:	89 50 04             	mov    %edx,0x4(%eax)
  802b37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	75 08                	jne    802b48 <alloc_block_BF+0x398>
  802b40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b43:	a3 30 50 80 00       	mov    %eax,0x805030
  802b48:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4d:	40                   	inc    %eax
  802b4e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_BF+0x3c0>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 87 45 80 00       	push   $0x804587
  802b61:	68 51 01 00 00       	push   $0x151
  802b66:	68 a5 45 80 00       	push   $0x8045a5
  802b6b:	e8 bc d8 ff ff       	call   80042c <_panic>
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_BF+0x3d9>
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_BF+0x3e4>
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_BF+0x3fd>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_BF+0x407>
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 38 50 80 00       	mov    0x805038,%eax
  802bcf:	48                   	dec    %eax
  802bd0:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	6a 00                	push   $0x0
  802bda:	ff 75 d0             	pushl  -0x30(%ebp)
  802bdd:	ff 75 cc             	pushl  -0x34(%ebp)
  802be0:	e8 e0 f6 ff ff       	call   8022c5 <set_block_data>
  802be5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	e9 a3 01 00 00       	jmp    802d93 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bf0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bf4:	0f 85 9d 00 00 00    	jne    802c97 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	6a 01                	push   $0x1
  802bff:	ff 75 ec             	pushl  -0x14(%ebp)
  802c02:	ff 75 f0             	pushl  -0x10(%ebp)
  802c05:	e8 bb f6 ff ff       	call   8022c5 <set_block_data>
  802c0a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c11:	75 17                	jne    802c2a <alloc_block_BF+0x47a>
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 87 45 80 00       	push   $0x804587
  802c1b:	68 58 01 00 00       	push   $0x158
  802c20:	68 a5 45 80 00       	push   $0x8045a5
  802c25:	e8 02 d8 ff ff       	call   80042c <_panic>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 10                	je     802c43 <alloc_block_BF+0x493>
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	8b 52 04             	mov    0x4(%edx),%edx
  802c3e:	89 50 04             	mov    %edx,0x4(%eax)
  802c41:	eb 0b                	jmp    802c4e <alloc_block_BF+0x49e>
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 0f                	je     802c67 <alloc_block_BF+0x4b7>
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c61:	8b 12                	mov    (%edx),%edx
  802c63:	89 10                	mov    %edx,(%eax)
  802c65:	eb 0a                	jmp    802c71 <alloc_block_BF+0x4c1>
  802c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c84:	a1 38 50 80 00       	mov    0x805038,%eax
  802c89:	48                   	dec    %eax
  802c8a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	e9 fc 00 00 00       	jmp    802d93 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	83 c0 08             	add    $0x8,%eax
  802c9d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ca0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ca7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802caa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cad:	01 d0                	add    %edx,%eax
  802caf:	48                   	dec    %eax
  802cb0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbb:	f7 75 c4             	divl   -0x3c(%ebp)
  802cbe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc1:	29 d0                	sub    %edx,%eax
  802cc3:	c1 e8 0c             	shr    $0xc,%eax
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	50                   	push   %eax
  802cca:	e8 b4 e7 ff ff       	call   801483 <sbrk>
  802ccf:	83 c4 10             	add    $0x10,%esp
  802cd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cd5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cd9:	75 0a                	jne    802ce5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce0:	e9 ae 00 00 00       	jmp    802d93 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ce5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cf2:	01 d0                	add    %edx,%eax
  802cf4:	48                   	dec    %eax
  802cf5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cf8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  802d00:	f7 75 b8             	divl   -0x48(%ebp)
  802d03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d06:	29 d0                	sub    %edx,%eax
  802d08:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d0b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d0e:	01 d0                	add    %edx,%eax
  802d10:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d15:	a1 40 50 80 00       	mov    0x805040,%eax
  802d1a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d20:	83 ec 0c             	sub    $0xc,%esp
  802d23:	68 4c 46 80 00       	push   $0x80464c
  802d28:	e8 bc d9 ff ff       	call   8006e9 <cprintf>
  802d2d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d30:	83 ec 08             	sub    $0x8,%esp
  802d33:	ff 75 bc             	pushl  -0x44(%ebp)
  802d36:	68 51 46 80 00       	push   $0x804651
  802d3b:	e8 a9 d9 ff ff       	call   8006e9 <cprintf>
  802d40:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d43:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d4a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	48                   	dec    %eax
  802d53:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d59:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5e:	f7 75 b0             	divl   -0x50(%ebp)
  802d61:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d64:	29 d0                	sub    %edx,%eax
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	6a 01                	push   $0x1
  802d6b:	50                   	push   %eax
  802d6c:	ff 75 bc             	pushl  -0x44(%ebp)
  802d6f:	e8 51 f5 ff ff       	call   8022c5 <set_block_data>
  802d74:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7d:	e8 36 04 00 00       	call   8031b8 <free_block>
  802d82:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	ff 75 08             	pushl  0x8(%ebp)
  802d8b:	e8 20 fa ff ff       	call   8027b0 <alloc_block_BF>
  802d90:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d93:	c9                   	leave  
  802d94:	c3                   	ret    

00802d95 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
  802d98:	53                   	push   %ebx
  802d99:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802da3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dae:	74 1e                	je     802dce <merging+0x39>
  802db0:	ff 75 08             	pushl  0x8(%ebp)
  802db3:	e8 bc f1 ff ff       	call   801f74 <get_block_size>
  802db8:	83 c4 04             	add    $0x4,%esp
  802dbb:	89 c2                	mov    %eax,%edx
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	01 d0                	add    %edx,%eax
  802dc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dc5:	75 07                	jne    802dce <merging+0x39>
		prev_is_free = 1;
  802dc7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd2:	74 1e                	je     802df2 <merging+0x5d>
  802dd4:	ff 75 10             	pushl  0x10(%ebp)
  802dd7:	e8 98 f1 ff ff       	call   801f74 <get_block_size>
  802ddc:	83 c4 04             	add    $0x4,%esp
  802ddf:	89 c2                	mov    %eax,%edx
  802de1:	8b 45 10             	mov    0x10(%ebp),%eax
  802de4:	01 d0                	add    %edx,%eax
  802de6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802de9:	75 07                	jne    802df2 <merging+0x5d>
		next_is_free = 1;
  802deb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802df2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df6:	0f 84 cc 00 00 00    	je     802ec8 <merging+0x133>
  802dfc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e00:	0f 84 c2 00 00 00    	je     802ec8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e06:	ff 75 08             	pushl  0x8(%ebp)
  802e09:	e8 66 f1 ff ff       	call   801f74 <get_block_size>
  802e0e:	83 c4 04             	add    $0x4,%esp
  802e11:	89 c3                	mov    %eax,%ebx
  802e13:	ff 75 10             	pushl  0x10(%ebp)
  802e16:	e8 59 f1 ff ff       	call   801f74 <get_block_size>
  802e1b:	83 c4 04             	add    $0x4,%esp
  802e1e:	01 c3                	add    %eax,%ebx
  802e20:	ff 75 0c             	pushl  0xc(%ebp)
  802e23:	e8 4c f1 ff ff       	call   801f74 <get_block_size>
  802e28:	83 c4 04             	add    $0x4,%esp
  802e2b:	01 d8                	add    %ebx,%eax
  802e2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e30:	6a 00                	push   $0x0
  802e32:	ff 75 ec             	pushl  -0x14(%ebp)
  802e35:	ff 75 08             	pushl  0x8(%ebp)
  802e38:	e8 88 f4 ff ff       	call   8022c5 <set_block_data>
  802e3d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e44:	75 17                	jne    802e5d <merging+0xc8>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 87 45 80 00       	push   $0x804587
  802e4e:	68 7d 01 00 00       	push   $0x17d
  802e53:	68 a5 45 80 00       	push   $0x8045a5
  802e58:	e8 cf d5 ff ff       	call   80042c <_panic>
  802e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 10                	je     802e76 <merging+0xe1>
  802e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6e:	8b 52 04             	mov    0x4(%edx),%edx
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	eb 0b                	jmp    802e81 <merging+0xec>
  802e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	a3 30 50 80 00       	mov    %eax,0x805030
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0f                	je     802e9a <merging+0x105>
  802e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e94:	8b 12                	mov    (%edx),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 0a                	jmp    802ea4 <merging+0x10f>
  802e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ebc:	48                   	dec    %eax
  802ebd:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ec2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec3:	e9 ea 02 00 00       	jmp    8031b2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecc:	74 3b                	je     802f09 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ece:	83 ec 0c             	sub    $0xc,%esp
  802ed1:	ff 75 08             	pushl  0x8(%ebp)
  802ed4:	e8 9b f0 ff ff       	call   801f74 <get_block_size>
  802ed9:	83 c4 10             	add    $0x10,%esp
  802edc:	89 c3                	mov    %eax,%ebx
  802ede:	83 ec 0c             	sub    $0xc,%esp
  802ee1:	ff 75 10             	pushl  0x10(%ebp)
  802ee4:	e8 8b f0 ff ff       	call   801f74 <get_block_size>
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	01 d8                	add    %ebx,%eax
  802eee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	6a 00                	push   $0x0
  802ef6:	ff 75 e8             	pushl  -0x18(%ebp)
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	e8 c4 f3 ff ff       	call   8022c5 <set_block_data>
  802f01:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f04:	e9 a9 02 00 00       	jmp    8031b2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0d:	0f 84 2d 01 00 00    	je     803040 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f13:	83 ec 0c             	sub    $0xc,%esp
  802f16:	ff 75 10             	pushl  0x10(%ebp)
  802f19:	e8 56 f0 ff ff       	call   801f74 <get_block_size>
  802f1e:	83 c4 10             	add    $0x10,%esp
  802f21:	89 c3                	mov    %eax,%ebx
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	ff 75 0c             	pushl  0xc(%ebp)
  802f29:	e8 46 f0 ff ff       	call   801f74 <get_block_size>
  802f2e:	83 c4 10             	add    $0x10,%esp
  802f31:	01 d8                	add    %ebx,%eax
  802f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	6a 00                	push   $0x0
  802f3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f3e:	ff 75 10             	pushl  0x10(%ebp)
  802f41:	e8 7f f3 ff ff       	call   8022c5 <set_block_data>
  802f46:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f49:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f53:	74 06                	je     802f5b <merging+0x1c6>
  802f55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f59:	75 17                	jne    802f72 <merging+0x1dd>
  802f5b:	83 ec 04             	sub    $0x4,%esp
  802f5e:	68 60 46 80 00       	push   $0x804660
  802f63:	68 8d 01 00 00       	push   $0x18d
  802f68:	68 a5 45 80 00       	push   $0x8045a5
  802f6d:	e8 ba d4 ff ff       	call   80042c <_panic>
  802f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f75:	8b 50 04             	mov    0x4(%eax),%edx
  802f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7b:	89 50 04             	mov    %edx,0x4(%eax)
  802f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 0d                	je     802f9d <merging+0x208>
  802f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f93:	8b 40 04             	mov    0x4(%eax),%eax
  802f96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f99:	89 10                	mov    %edx,(%eax)
  802f9b:	eb 08                	jmp    802fa5 <merging+0x210>
  802f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fab:	89 50 04             	mov    %edx,0x4(%eax)
  802fae:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb3:	40                   	inc    %eax
  802fb4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbd:	75 17                	jne    802fd6 <merging+0x241>
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 87 45 80 00       	push   $0x804587
  802fc7:	68 8e 01 00 00       	push   $0x18e
  802fcc:	68 a5 45 80 00       	push   $0x8045a5
  802fd1:	e8 56 d4 ff ff       	call   80042c <_panic>
  802fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 10                	je     802fef <merging+0x25a>
  802fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe7:	8b 52 04             	mov    0x4(%edx),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 0b                	jmp    802ffa <merging+0x265>
  802fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 0f                	je     803013 <merging+0x27e>
  803004:	8b 45 0c             	mov    0xc(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300d:	8b 12                	mov    (%edx),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	eb 0a                	jmp    80301d <merging+0x288>
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	8b 45 0c             	mov    0xc(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 38 50 80 00       	mov    0x805038,%eax
  803035:	48                   	dec    %eax
  803036:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80303b:	e9 72 01 00 00       	jmp    8031b2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803040:	8b 45 10             	mov    0x10(%ebp),%eax
  803043:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304a:	74 79                	je     8030c5 <merging+0x330>
  80304c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803050:	74 73                	je     8030c5 <merging+0x330>
  803052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803056:	74 06                	je     80305e <merging+0x2c9>
  803058:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305c:	75 17                	jne    803075 <merging+0x2e0>
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	68 18 46 80 00       	push   $0x804618
  803066:	68 94 01 00 00       	push   $0x194
  80306b:	68 a5 45 80 00       	push   $0x8045a5
  803070:	e8 b7 d3 ff ff       	call   80042c <_panic>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 10                	mov    (%eax),%edx
  80307a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307d:	89 10                	mov    %edx,(%eax)
  80307f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	85 c0                	test   %eax,%eax
  803086:	74 0b                	je     803093 <merging+0x2fe>
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803090:	89 50 04             	mov    %edx,0x4(%eax)
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803099:	89 10                	mov    %edx,(%eax)
  80309b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309e:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	75 08                	jne    8030b5 <merging+0x320>
  8030ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ba:	40                   	inc    %eax
  8030bb:	a3 38 50 80 00       	mov    %eax,0x805038
  8030c0:	e9 ce 00 00 00       	jmp    803193 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c9:	74 65                	je     803130 <merging+0x39b>
  8030cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030cf:	75 17                	jne    8030e8 <merging+0x353>
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	68 f4 45 80 00       	push   $0x8045f4
  8030d9:	68 95 01 00 00       	push   $0x195
  8030de:	68 a5 45 80 00       	push   $0x8045a5
  8030e3:	e8 44 d3 ff ff       	call   80042c <_panic>
  8030e8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0c                	je     80310a <merging+0x375>
  8030fe:	a1 30 50 80 00       	mov    0x805030,%eax
  803103:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803106:	89 10                	mov    %edx,(%eax)
  803108:	eb 08                	jmp    803112 <merging+0x37d>
  80310a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803112:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803115:	a3 30 50 80 00       	mov    %eax,0x805030
  80311a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803123:	a1 38 50 80 00       	mov    0x805038,%eax
  803128:	40                   	inc    %eax
  803129:	a3 38 50 80 00       	mov    %eax,0x805038
  80312e:	eb 63                	jmp    803193 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803130:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803134:	75 17                	jne    80314d <merging+0x3b8>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 c0 45 80 00       	push   $0x8045c0
  80313e:	68 98 01 00 00       	push   $0x198
  803143:	68 a5 45 80 00       	push   $0x8045a5
  803148:	e8 df d2 ff ff       	call   80042c <_panic>
  80314d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803153:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803156:	89 10                	mov    %edx,(%eax)
  803158:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0d                	je     80316e <merging+0x3d9>
  803161:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803166:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 08                	jmp    803176 <merging+0x3e1>
  80316e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803171:	a3 30 50 80 00       	mov    %eax,0x805030
  803176:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803179:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80317e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 38 50 80 00       	mov    0x805038,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803193:	83 ec 0c             	sub    $0xc,%esp
  803196:	ff 75 10             	pushl  0x10(%ebp)
  803199:	e8 d6 ed ff ff       	call   801f74 <get_block_size>
  80319e:	83 c4 10             	add    $0x10,%esp
  8031a1:	83 ec 04             	sub    $0x4,%esp
  8031a4:	6a 00                	push   $0x0
  8031a6:	50                   	push   %eax
  8031a7:	ff 75 10             	pushl  0x10(%ebp)
  8031aa:	e8 16 f1 ff ff       	call   8022c5 <set_block_data>
  8031af:	83 c4 10             	add    $0x10,%esp
	}
}
  8031b2:	90                   	nop
  8031b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b6:	c9                   	leave  
  8031b7:	c3                   	ret    

008031b8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031b8:	55                   	push   %ebp
  8031b9:	89 e5                	mov    %esp,%ebp
  8031bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ce:	73 1b                	jae    8031eb <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031d0:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	ff 75 08             	pushl  0x8(%ebp)
  8031db:	6a 00                	push   $0x0
  8031dd:	50                   	push   %eax
  8031de:	e8 b2 fb ff ff       	call   802d95 <merging>
  8031e3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e6:	e9 8b 00 00 00       	jmp    803276 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f3:	76 18                	jbe    80320d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	ff 75 08             	pushl  0x8(%ebp)
  803200:	50                   	push   %eax
  803201:	6a 00                	push   $0x0
  803203:	e8 8d fb ff ff       	call   802d95 <merging>
  803208:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80320b:	eb 69                	jmp    803276 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803215:	eb 39                	jmp    803250 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321d:	73 29                	jae    803248 <free_block+0x90>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	3b 45 08             	cmp    0x8(%ebp),%eax
  803227:	76 1f                	jbe    803248 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	ff 75 08             	pushl  0x8(%ebp)
  803237:	ff 75 f0             	pushl  -0x10(%ebp)
  80323a:	ff 75 f4             	pushl  -0xc(%ebp)
  80323d:	e8 53 fb ff ff       	call   802d95 <merging>
  803242:	83 c4 10             	add    $0x10,%esp
			break;
  803245:	90                   	nop
		}
	}
}
  803246:	eb 2e                	jmp    803276 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803248:	a1 34 50 80 00       	mov    0x805034,%eax
  80324d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803254:	74 07                	je     80325d <free_block+0xa5>
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	eb 05                	jmp    803262 <free_block+0xaa>
  80325d:	b8 00 00 00 00       	mov    $0x0,%eax
  803262:	a3 34 50 80 00       	mov    %eax,0x805034
  803267:	a1 34 50 80 00       	mov    0x805034,%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	75 a7                	jne    803217 <free_block+0x5f>
  803270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803274:	75 a1                	jne    803217 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803276:	90                   	nop
  803277:	c9                   	leave  
  803278:	c3                   	ret    

00803279 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
  80327c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80327f:	ff 75 08             	pushl  0x8(%ebp)
  803282:	e8 ed ec ff ff       	call   801f74 <get_block_size>
  803287:	83 c4 04             	add    $0x4,%esp
  80328a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80328d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803294:	eb 17                	jmp    8032ad <copy_data+0x34>
  803296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329c:	01 c2                	add    %eax,%edx
  80329e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	01 c8                	add    %ecx,%eax
  8032a6:	8a 00                	mov    (%eax),%al
  8032a8:	88 02                	mov    %al,(%edx)
  8032aa:	ff 45 fc             	incl   -0x4(%ebp)
  8032ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032b3:	72 e1                	jb     803296 <copy_data+0x1d>
}
  8032b5:	90                   	nop
  8032b6:	c9                   	leave  
  8032b7:	c3                   	ret    

008032b8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c2:	75 23                	jne    8032e7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c8:	74 13                	je     8032dd <realloc_block_FF+0x25>
  8032ca:	83 ec 0c             	sub    $0xc,%esp
  8032cd:	ff 75 0c             	pushl  0xc(%ebp)
  8032d0:	e8 1f f0 ff ff       	call   8022f4 <alloc_block_FF>
  8032d5:	83 c4 10             	add    $0x10,%esp
  8032d8:	e9 f4 06 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
		return NULL;
  8032dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e2:	e9 ea 06 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032eb:	75 18                	jne    803305 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032ed:	83 ec 0c             	sub    $0xc,%esp
  8032f0:	ff 75 08             	pushl  0x8(%ebp)
  8032f3:	e8 c0 fe ff ff       	call   8031b8 <free_block>
  8032f8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803300:	e9 cc 06 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803305:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803309:	77 07                	ja     803312 <realloc_block_FF+0x5a>
  80330b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803312:	8b 45 0c             	mov    0xc(%ebp),%eax
  803315:	83 e0 01             	and    $0x1,%eax
  803318:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80331b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331e:	83 c0 08             	add    $0x8,%eax
  803321:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803324:	83 ec 0c             	sub    $0xc,%esp
  803327:	ff 75 08             	pushl  0x8(%ebp)
  80332a:	e8 45 ec ff ff       	call   801f74 <get_block_size>
  80332f:	83 c4 10             	add    $0x10,%esp
  803332:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803338:	83 e8 08             	sub    $0x8,%eax
  80333b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	83 e8 04             	sub    $0x4,%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	83 e0 fe             	and    $0xfffffffe,%eax
  803349:	89 c2                	mov    %eax,%edx
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	01 d0                	add    %edx,%eax
  803350:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803353:	83 ec 0c             	sub    $0xc,%esp
  803356:	ff 75 e4             	pushl  -0x1c(%ebp)
  803359:	e8 16 ec ff ff       	call   801f74 <get_block_size>
  80335e:	83 c4 10             	add    $0x10,%esp
  803361:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803367:	83 e8 08             	sub    $0x8,%eax
  80336a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80336d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803370:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803373:	75 08                	jne    80337d <realloc_block_FF+0xc5>
	{
		 return va;
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	e9 54 06 00 00       	jmp    8039d1 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803383:	0f 83 e5 03 00 00    	jae    80376e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80338f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803392:	83 ec 0c             	sub    $0xc,%esp
  803395:	ff 75 e4             	pushl  -0x1c(%ebp)
  803398:	e8 f0 eb ff ff       	call   801f8d <is_free_block>
  80339d:	83 c4 10             	add    $0x10,%esp
  8033a0:	84 c0                	test   %al,%al
  8033a2:	0f 84 3b 01 00 00    	je     8034e3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ae:	01 d0                	add    %edx,%eax
  8033b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033b3:	83 ec 04             	sub    $0x4,%esp
  8033b6:	6a 01                	push   $0x1
  8033b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	e8 02 ef ff ff       	call   8022c5 <set_block_data>
  8033c3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	83 e8 04             	sub    $0x4,%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	83 e0 fe             	and    $0xfffffffe,%eax
  8033d1:	89 c2                	mov    %eax,%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	01 d0                	add    %edx,%eax
  8033d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033db:	83 ec 04             	sub    $0x4,%esp
  8033de:	6a 00                	push   $0x0
  8033e0:	ff 75 cc             	pushl  -0x34(%ebp)
  8033e3:	ff 75 c8             	pushl  -0x38(%ebp)
  8033e6:	e8 da ee ff ff       	call   8022c5 <set_block_data>
  8033eb:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f2:	74 06                	je     8033fa <realloc_block_FF+0x142>
  8033f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033f8:	75 17                	jne    803411 <realloc_block_FF+0x159>
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 18 46 80 00       	push   $0x804618
  803402:	68 f6 01 00 00       	push   $0x1f6
  803407:	68 a5 45 80 00       	push   $0x8045a5
  80340c:	e8 1b d0 ff ff       	call   80042c <_panic>
  803411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803414:	8b 10                	mov    (%eax),%edx
  803416:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 0b                	je     80342f <realloc_block_FF+0x177>
  803424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342c:	89 50 04             	mov    %edx,0x4(%eax)
  80342f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803432:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	75 08                	jne    803451 <realloc_block_FF+0x199>
  803449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344c:	a3 30 50 80 00       	mov    %eax,0x805030
  803451:	a1 38 50 80 00       	mov    0x805038,%eax
  803456:	40                   	inc    %eax
  803457:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80345c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803460:	75 17                	jne    803479 <realloc_block_FF+0x1c1>
  803462:	83 ec 04             	sub    $0x4,%esp
  803465:	68 87 45 80 00       	push   $0x804587
  80346a:	68 f7 01 00 00       	push   $0x1f7
  80346f:	68 a5 45 80 00       	push   $0x8045a5
  803474:	e8 b3 cf ff ff       	call   80042c <_panic>
  803479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	85 c0                	test   %eax,%eax
  803480:	74 10                	je     803492 <realloc_block_FF+0x1da>
  803482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348a:	8b 52 04             	mov    0x4(%edx),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	eb 0b                	jmp    80349d <realloc_block_FF+0x1e5>
  803492:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803495:	8b 40 04             	mov    0x4(%eax),%eax
  803498:	a3 30 50 80 00       	mov    %eax,0x805030
  80349d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	85 c0                	test   %eax,%eax
  8034a5:	74 0f                	je     8034b6 <realloc_block_FF+0x1fe>
  8034a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034aa:	8b 40 04             	mov    0x4(%eax),%eax
  8034ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b0:	8b 12                	mov    (%edx),%edx
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	eb 0a                	jmp    8034c0 <realloc_block_FF+0x208>
  8034b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b9:	8b 00                	mov    (%eax),%eax
  8034bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d8:	48                   	dec    %eax
  8034d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8034de:	e9 83 02 00 00       	jmp    803766 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034e3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034e7:	0f 86 69 02 00 00    	jbe    803756 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	6a 01                	push   $0x1
  8034f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f5:	ff 75 08             	pushl  0x8(%ebp)
  8034f8:	e8 c8 ed ff ff       	call   8022c5 <set_block_data>
  8034fd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	83 e8 04             	sub    $0x4,%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	83 e0 fe             	and    $0xfffffffe,%eax
  80350b:	89 c2                	mov    %eax,%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	01 d0                	add    %edx,%eax
  803512:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803515:	a1 38 50 80 00       	mov    0x805038,%eax
  80351a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80351d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803521:	75 68                	jne    80358b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803523:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803527:	75 17                	jne    803540 <realloc_block_FF+0x288>
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	68 c0 45 80 00       	push   $0x8045c0
  803531:	68 06 02 00 00       	push   $0x206
  803536:	68 a5 45 80 00       	push   $0x8045a5
  80353b:	e8 ec ce ff ff       	call   80042c <_panic>
  803540:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	74 0d                	je     803561 <realloc_block_FF+0x2a9>
  803554:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803559:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355c:	89 50 04             	mov    %edx,0x4(%eax)
  80355f:	eb 08                	jmp    803569 <realloc_block_FF+0x2b1>
  803561:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803564:	a3 30 50 80 00       	mov    %eax,0x805030
  803569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357b:	a1 38 50 80 00       	mov    0x805038,%eax
  803580:	40                   	inc    %eax
  803581:	a3 38 50 80 00       	mov    %eax,0x805038
  803586:	e9 b0 01 00 00       	jmp    80373b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80358b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803590:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803593:	76 68                	jbe    8035fd <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803595:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803599:	75 17                	jne    8035b2 <realloc_block_FF+0x2fa>
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	68 c0 45 80 00       	push   $0x8045c0
  8035a3:	68 0b 02 00 00       	push   $0x20b
  8035a8:	68 a5 45 80 00       	push   $0x8045a5
  8035ad:	e8 7a ce ff ff       	call   80042c <_panic>
  8035b2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bb:	89 10                	mov    %edx,(%eax)
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	74 0d                	je     8035d3 <realloc_block_FF+0x31b>
  8035c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ce:	89 50 04             	mov    %edx,0x4(%eax)
  8035d1:	eb 08                	jmp    8035db <realloc_block_FF+0x323>
  8035d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f2:	40                   	inc    %eax
  8035f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f8:	e9 3e 01 00 00       	jmp    80373b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803602:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803605:	73 68                	jae    80366f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x36c>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 f4 45 80 00       	push   $0x8045f4
  803615:	68 10 02 00 00       	push   $0x210
  80361a:	68 a5 45 80 00       	push   $0x8045a5
  80361f:	e8 08 ce ff ff       	call   80042c <_panic>
  803624:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0c                	je     803646 <realloc_block_FF+0x38e>
  80363a:	a1 30 50 80 00       	mov    0x805030,%eax
  80363f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803642:	89 10                	mov    %edx,(%eax)
  803644:	eb 08                	jmp    80364e <realloc_block_FF+0x396>
  803646:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803649:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803651:	a3 30 50 80 00       	mov    %eax,0x805030
  803656:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365f:	a1 38 50 80 00       	mov    0x805038,%eax
  803664:	40                   	inc    %eax
  803665:	a3 38 50 80 00       	mov    %eax,0x805038
  80366a:	e9 cc 00 00 00       	jmp    80373b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80366f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803676:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80367b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367e:	e9 8a 00 00 00       	jmp    80370d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803689:	73 7a                	jae    803705 <realloc_block_FF+0x44d>
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 00                	mov    (%eax),%eax
  803690:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803693:	73 70                	jae    803705 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803699:	74 06                	je     8036a1 <realloc_block_FF+0x3e9>
  80369b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80369f:	75 17                	jne    8036b8 <realloc_block_FF+0x400>
  8036a1:	83 ec 04             	sub    $0x4,%esp
  8036a4:	68 18 46 80 00       	push   $0x804618
  8036a9:	68 1a 02 00 00       	push   $0x21a
  8036ae:	68 a5 45 80 00       	push   $0x8045a5
  8036b3:	e8 74 cd ff ff       	call   80042c <_panic>
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	8b 10                	mov    (%eax),%edx
  8036bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c0:	89 10                	mov    %edx,(%eax)
  8036c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	74 0b                	je     8036d6 <realloc_block_FF+0x41e>
  8036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d3:	89 50 04             	mov    %edx,0x4(%eax)
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036dc:	89 10                	mov    %edx,(%eax)
  8036de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e4:	89 50 04             	mov    %edx,0x4(%eax)
  8036e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	85 c0                	test   %eax,%eax
  8036ee:	75 08                	jne    8036f8 <realloc_block_FF+0x440>
  8036f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803703:	eb 36                	jmp    80373b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803705:	a1 34 50 80 00       	mov    0x805034,%eax
  80370a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803711:	74 07                	je     80371a <realloc_block_FF+0x462>
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	8b 00                	mov    (%eax),%eax
  803718:	eb 05                	jmp    80371f <realloc_block_FF+0x467>
  80371a:	b8 00 00 00 00       	mov    $0x0,%eax
  80371f:	a3 34 50 80 00       	mov    %eax,0x805034
  803724:	a1 34 50 80 00       	mov    0x805034,%eax
  803729:	85 c0                	test   %eax,%eax
  80372b:	0f 85 52 ff ff ff    	jne    803683 <realloc_block_FF+0x3cb>
  803731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803735:	0f 85 48 ff ff ff    	jne    803683 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80373b:	83 ec 04             	sub    $0x4,%esp
  80373e:	6a 00                	push   $0x0
  803740:	ff 75 d8             	pushl  -0x28(%ebp)
  803743:	ff 75 d4             	pushl  -0x2c(%ebp)
  803746:	e8 7a eb ff ff       	call   8022c5 <set_block_data>
  80374b:	83 c4 10             	add    $0x10,%esp
				return va;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	e9 7b 02 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803756:	83 ec 0c             	sub    $0xc,%esp
  803759:	68 95 46 80 00       	push   $0x804695
  80375e:	e8 86 cf ff ff       	call   8006e9 <cprintf>
  803763:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	e9 63 02 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80376e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803771:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803774:	0f 86 4d 02 00 00    	jbe    8039c7 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80377a:	83 ec 0c             	sub    $0xc,%esp
  80377d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803780:	e8 08 e8 ff ff       	call   801f8d <is_free_block>
  803785:	83 c4 10             	add    $0x10,%esp
  803788:	84 c0                	test   %al,%al
  80378a:	0f 84 37 02 00 00    	je     8039c7 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803790:	8b 45 0c             	mov    0xc(%ebp),%eax
  803793:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803796:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803799:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80379c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80379f:	76 38                	jbe    8037d9 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037a1:	83 ec 0c             	sub    $0xc,%esp
  8037a4:	ff 75 08             	pushl  0x8(%ebp)
  8037a7:	e8 0c fa ff ff       	call   8031b8 <free_block>
  8037ac:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037af:	83 ec 0c             	sub    $0xc,%esp
  8037b2:	ff 75 0c             	pushl  0xc(%ebp)
  8037b5:	e8 3a eb ff ff       	call   8022f4 <alloc_block_FF>
  8037ba:	83 c4 10             	add    $0x10,%esp
  8037bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037c0:	83 ec 08             	sub    $0x8,%esp
  8037c3:	ff 75 c0             	pushl  -0x40(%ebp)
  8037c6:	ff 75 08             	pushl  0x8(%ebp)
  8037c9:	e8 ab fa ff ff       	call   803279 <copy_data>
  8037ce:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037d4:	e9 f8 01 00 00       	jmp    8039d1 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037dc:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037df:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037e2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037e6:	0f 87 a0 00 00 00    	ja     80388c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f0:	75 17                	jne    803809 <realloc_block_FF+0x551>
  8037f2:	83 ec 04             	sub    $0x4,%esp
  8037f5:	68 87 45 80 00       	push   $0x804587
  8037fa:	68 38 02 00 00       	push   $0x238
  8037ff:	68 a5 45 80 00       	push   $0x8045a5
  803804:	e8 23 cc ff ff       	call   80042c <_panic>
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	74 10                	je     803822 <realloc_block_FF+0x56a>
  803812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80381a:	8b 52 04             	mov    0x4(%edx),%edx
  80381d:	89 50 04             	mov    %edx,0x4(%eax)
  803820:	eb 0b                	jmp    80382d <realloc_block_FF+0x575>
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	8b 40 04             	mov    0x4(%eax),%eax
  803828:	a3 30 50 80 00       	mov    %eax,0x805030
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 40 04             	mov    0x4(%eax),%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	74 0f                	je     803846 <realloc_block_FF+0x58e>
  803837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383a:	8b 40 04             	mov    0x4(%eax),%eax
  80383d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803840:	8b 12                	mov    (%edx),%edx
  803842:	89 10                	mov    %edx,(%eax)
  803844:	eb 0a                	jmp    803850 <realloc_block_FF+0x598>
  803846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803849:	8b 00                	mov    (%eax),%eax
  80384b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803863:	a1 38 50 80 00       	mov    0x805038,%eax
  803868:	48                   	dec    %eax
  803869:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80386e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803874:	01 d0                	add    %edx,%eax
  803876:	83 ec 04             	sub    $0x4,%esp
  803879:	6a 01                	push   $0x1
  80387b:	50                   	push   %eax
  80387c:	ff 75 08             	pushl  0x8(%ebp)
  80387f:	e8 41 ea ff ff       	call   8022c5 <set_block_data>
  803884:	83 c4 10             	add    $0x10,%esp
  803887:	e9 36 01 00 00       	jmp    8039c2 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80388c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803892:	01 d0                	add    %edx,%eax
  803894:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803897:	83 ec 04             	sub    $0x4,%esp
  80389a:	6a 01                	push   $0x1
  80389c:	ff 75 f0             	pushl  -0x10(%ebp)
  80389f:	ff 75 08             	pushl  0x8(%ebp)
  8038a2:	e8 1e ea ff ff       	call   8022c5 <set_block_data>
  8038a7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	83 e8 04             	sub    $0x4,%eax
  8038b0:	8b 00                	mov    (%eax),%eax
  8038b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8038b5:	89 c2                	mov    %eax,%edx
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	01 d0                	add    %edx,%eax
  8038bc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c3:	74 06                	je     8038cb <realloc_block_FF+0x613>
  8038c5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038c9:	75 17                	jne    8038e2 <realloc_block_FF+0x62a>
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	68 18 46 80 00       	push   $0x804618
  8038d3:	68 44 02 00 00       	push   $0x244
  8038d8:	68 a5 45 80 00       	push   $0x8045a5
  8038dd:	e8 4a cb ff ff       	call   80042c <_panic>
  8038e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e5:	8b 10                	mov    (%eax),%edx
  8038e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ea:	89 10                	mov    %edx,(%eax)
  8038ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ef:	8b 00                	mov    (%eax),%eax
  8038f1:	85 c0                	test   %eax,%eax
  8038f3:	74 0b                	je     803900 <realloc_block_FF+0x648>
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fd:	89 50 04             	mov    %edx,0x4(%eax)
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803906:	89 10                	mov    %edx,(%eax)
  803908:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390e:	89 50 04             	mov    %edx,0x4(%eax)
  803911:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	75 08                	jne    803922 <realloc_block_FF+0x66a>
  80391a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391d:	a3 30 50 80 00       	mov    %eax,0x805030
  803922:	a1 38 50 80 00       	mov    0x805038,%eax
  803927:	40                   	inc    %eax
  803928:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80392d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803931:	75 17                	jne    80394a <realloc_block_FF+0x692>
  803933:	83 ec 04             	sub    $0x4,%esp
  803936:	68 87 45 80 00       	push   $0x804587
  80393b:	68 45 02 00 00       	push   $0x245
  803940:	68 a5 45 80 00       	push   $0x8045a5
  803945:	e8 e2 ca ff ff       	call   80042c <_panic>
  80394a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	85 c0                	test   %eax,%eax
  803951:	74 10                	je     803963 <realloc_block_FF+0x6ab>
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	8b 00                	mov    (%eax),%eax
  803958:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395b:	8b 52 04             	mov    0x4(%edx),%edx
  80395e:	89 50 04             	mov    %edx,0x4(%eax)
  803961:	eb 0b                	jmp    80396e <realloc_block_FF+0x6b6>
  803963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803966:	8b 40 04             	mov    0x4(%eax),%eax
  803969:	a3 30 50 80 00       	mov    %eax,0x805030
  80396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803971:	8b 40 04             	mov    0x4(%eax),%eax
  803974:	85 c0                	test   %eax,%eax
  803976:	74 0f                	je     803987 <realloc_block_FF+0x6cf>
  803978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397b:	8b 40 04             	mov    0x4(%eax),%eax
  80397e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803981:	8b 12                	mov    (%edx),%edx
  803983:	89 10                	mov    %edx,(%eax)
  803985:	eb 0a                	jmp    803991 <realloc_block_FF+0x6d9>
  803987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398a:	8b 00                	mov    (%eax),%eax
  80398c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a9:	48                   	dec    %eax
  8039aa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039af:	83 ec 04             	sub    $0x4,%esp
  8039b2:	6a 00                	push   $0x0
  8039b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8039b7:	ff 75 b8             	pushl  -0x48(%ebp)
  8039ba:	e8 06 e9 ff ff       	call   8022c5 <set_block_data>
  8039bf:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	eb 0a                	jmp    8039d1 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039c7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039d1:	c9                   	leave  
  8039d2:	c3                   	ret    

008039d3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039d3:	55                   	push   %ebp
  8039d4:	89 e5                	mov    %esp,%ebp
  8039d6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039d9:	83 ec 04             	sub    $0x4,%esp
  8039dc:	68 9c 46 80 00       	push   $0x80469c
  8039e1:	68 58 02 00 00       	push   $0x258
  8039e6:	68 a5 45 80 00       	push   $0x8045a5
  8039eb:	e8 3c ca ff ff       	call   80042c <_panic>

008039f0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039f0:	55                   	push   %ebp
  8039f1:	89 e5                	mov    %esp,%ebp
  8039f3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039f6:	83 ec 04             	sub    $0x4,%esp
  8039f9:	68 c4 46 80 00       	push   $0x8046c4
  8039fe:	68 61 02 00 00       	push   $0x261
  803a03:	68 a5 45 80 00       	push   $0x8045a5
  803a08:	e8 1f ca ff ff       	call   80042c <_panic>
  803a0d:	66 90                	xchg   %ax,%ax
  803a0f:	90                   	nop

00803a10 <__udivdi3>:
  803a10:	55                   	push   %ebp
  803a11:	57                   	push   %edi
  803a12:	56                   	push   %esi
  803a13:	53                   	push   %ebx
  803a14:	83 ec 1c             	sub    $0x1c,%esp
  803a17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a27:	89 ca                	mov    %ecx,%edx
  803a29:	89 f8                	mov    %edi,%eax
  803a2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a2f:	85 f6                	test   %esi,%esi
  803a31:	75 2d                	jne    803a60 <__udivdi3+0x50>
  803a33:	39 cf                	cmp    %ecx,%edi
  803a35:	77 65                	ja     803a9c <__udivdi3+0x8c>
  803a37:	89 fd                	mov    %edi,%ebp
  803a39:	85 ff                	test   %edi,%edi
  803a3b:	75 0b                	jne    803a48 <__udivdi3+0x38>
  803a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a42:	31 d2                	xor    %edx,%edx
  803a44:	f7 f7                	div    %edi
  803a46:	89 c5                	mov    %eax,%ebp
  803a48:	31 d2                	xor    %edx,%edx
  803a4a:	89 c8                	mov    %ecx,%eax
  803a4c:	f7 f5                	div    %ebp
  803a4e:	89 c1                	mov    %eax,%ecx
  803a50:	89 d8                	mov    %ebx,%eax
  803a52:	f7 f5                	div    %ebp
  803a54:	89 cf                	mov    %ecx,%edi
  803a56:	89 fa                	mov    %edi,%edx
  803a58:	83 c4 1c             	add    $0x1c,%esp
  803a5b:	5b                   	pop    %ebx
  803a5c:	5e                   	pop    %esi
  803a5d:	5f                   	pop    %edi
  803a5e:	5d                   	pop    %ebp
  803a5f:	c3                   	ret    
  803a60:	39 ce                	cmp    %ecx,%esi
  803a62:	77 28                	ja     803a8c <__udivdi3+0x7c>
  803a64:	0f bd fe             	bsr    %esi,%edi
  803a67:	83 f7 1f             	xor    $0x1f,%edi
  803a6a:	75 40                	jne    803aac <__udivdi3+0x9c>
  803a6c:	39 ce                	cmp    %ecx,%esi
  803a6e:	72 0a                	jb     803a7a <__udivdi3+0x6a>
  803a70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a74:	0f 87 9e 00 00 00    	ja     803b18 <__udivdi3+0x108>
  803a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7f:	89 fa                	mov    %edi,%edx
  803a81:	83 c4 1c             	add    $0x1c,%esp
  803a84:	5b                   	pop    %ebx
  803a85:	5e                   	pop    %esi
  803a86:	5f                   	pop    %edi
  803a87:	5d                   	pop    %ebp
  803a88:	c3                   	ret    
  803a89:	8d 76 00             	lea    0x0(%esi),%esi
  803a8c:	31 ff                	xor    %edi,%edi
  803a8e:	31 c0                	xor    %eax,%eax
  803a90:	89 fa                	mov    %edi,%edx
  803a92:	83 c4 1c             	add    $0x1c,%esp
  803a95:	5b                   	pop    %ebx
  803a96:	5e                   	pop    %esi
  803a97:	5f                   	pop    %edi
  803a98:	5d                   	pop    %ebp
  803a99:	c3                   	ret    
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	89 d8                	mov    %ebx,%eax
  803a9e:	f7 f7                	div    %edi
  803aa0:	31 ff                	xor    %edi,%edi
  803aa2:	89 fa                	mov    %edi,%edx
  803aa4:	83 c4 1c             	add    $0x1c,%esp
  803aa7:	5b                   	pop    %ebx
  803aa8:	5e                   	pop    %esi
  803aa9:	5f                   	pop    %edi
  803aaa:	5d                   	pop    %ebp
  803aab:	c3                   	ret    
  803aac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ab1:	89 eb                	mov    %ebp,%ebx
  803ab3:	29 fb                	sub    %edi,%ebx
  803ab5:	89 f9                	mov    %edi,%ecx
  803ab7:	d3 e6                	shl    %cl,%esi
  803ab9:	89 c5                	mov    %eax,%ebp
  803abb:	88 d9                	mov    %bl,%cl
  803abd:	d3 ed                	shr    %cl,%ebp
  803abf:	89 e9                	mov    %ebp,%ecx
  803ac1:	09 f1                	or     %esi,%ecx
  803ac3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ac7:	89 f9                	mov    %edi,%ecx
  803ac9:	d3 e0                	shl    %cl,%eax
  803acb:	89 c5                	mov    %eax,%ebp
  803acd:	89 d6                	mov    %edx,%esi
  803acf:	88 d9                	mov    %bl,%cl
  803ad1:	d3 ee                	shr    %cl,%esi
  803ad3:	89 f9                	mov    %edi,%ecx
  803ad5:	d3 e2                	shl    %cl,%edx
  803ad7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803adb:	88 d9                	mov    %bl,%cl
  803add:	d3 e8                	shr    %cl,%eax
  803adf:	09 c2                	or     %eax,%edx
  803ae1:	89 d0                	mov    %edx,%eax
  803ae3:	89 f2                	mov    %esi,%edx
  803ae5:	f7 74 24 0c          	divl   0xc(%esp)
  803ae9:	89 d6                	mov    %edx,%esi
  803aeb:	89 c3                	mov    %eax,%ebx
  803aed:	f7 e5                	mul    %ebp
  803aef:	39 d6                	cmp    %edx,%esi
  803af1:	72 19                	jb     803b0c <__udivdi3+0xfc>
  803af3:	74 0b                	je     803b00 <__udivdi3+0xf0>
  803af5:	89 d8                	mov    %ebx,%eax
  803af7:	31 ff                	xor    %edi,%edi
  803af9:	e9 58 ff ff ff       	jmp    803a56 <__udivdi3+0x46>
  803afe:	66 90                	xchg   %ax,%ax
  803b00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b04:	89 f9                	mov    %edi,%ecx
  803b06:	d3 e2                	shl    %cl,%edx
  803b08:	39 c2                	cmp    %eax,%edx
  803b0a:	73 e9                	jae    803af5 <__udivdi3+0xe5>
  803b0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b0f:	31 ff                	xor    %edi,%edi
  803b11:	e9 40 ff ff ff       	jmp    803a56 <__udivdi3+0x46>
  803b16:	66 90                	xchg   %ax,%ax
  803b18:	31 c0                	xor    %eax,%eax
  803b1a:	e9 37 ff ff ff       	jmp    803a56 <__udivdi3+0x46>
  803b1f:	90                   	nop

00803b20 <__umoddi3>:
  803b20:	55                   	push   %ebp
  803b21:	57                   	push   %edi
  803b22:	56                   	push   %esi
  803b23:	53                   	push   %ebx
  803b24:	83 ec 1c             	sub    $0x1c,%esp
  803b27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b3f:	89 f3                	mov    %esi,%ebx
  803b41:	89 fa                	mov    %edi,%edx
  803b43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b47:	89 34 24             	mov    %esi,(%esp)
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	75 1a                	jne    803b68 <__umoddi3+0x48>
  803b4e:	39 f7                	cmp    %esi,%edi
  803b50:	0f 86 a2 00 00 00    	jbe    803bf8 <__umoddi3+0xd8>
  803b56:	89 c8                	mov    %ecx,%eax
  803b58:	89 f2                	mov    %esi,%edx
  803b5a:	f7 f7                	div    %edi
  803b5c:	89 d0                	mov    %edx,%eax
  803b5e:	31 d2                	xor    %edx,%edx
  803b60:	83 c4 1c             	add    $0x1c,%esp
  803b63:	5b                   	pop    %ebx
  803b64:	5e                   	pop    %esi
  803b65:	5f                   	pop    %edi
  803b66:	5d                   	pop    %ebp
  803b67:	c3                   	ret    
  803b68:	39 f0                	cmp    %esi,%eax
  803b6a:	0f 87 ac 00 00 00    	ja     803c1c <__umoddi3+0xfc>
  803b70:	0f bd e8             	bsr    %eax,%ebp
  803b73:	83 f5 1f             	xor    $0x1f,%ebp
  803b76:	0f 84 ac 00 00 00    	je     803c28 <__umoddi3+0x108>
  803b7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b81:	29 ef                	sub    %ebp,%edi
  803b83:	89 fe                	mov    %edi,%esi
  803b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b89:	89 e9                	mov    %ebp,%ecx
  803b8b:	d3 e0                	shl    %cl,%eax
  803b8d:	89 d7                	mov    %edx,%edi
  803b8f:	89 f1                	mov    %esi,%ecx
  803b91:	d3 ef                	shr    %cl,%edi
  803b93:	09 c7                	or     %eax,%edi
  803b95:	89 e9                	mov    %ebp,%ecx
  803b97:	d3 e2                	shl    %cl,%edx
  803b99:	89 14 24             	mov    %edx,(%esp)
  803b9c:	89 d8                	mov    %ebx,%eax
  803b9e:	d3 e0                	shl    %cl,%eax
  803ba0:	89 c2                	mov    %eax,%edx
  803ba2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba6:	d3 e0                	shl    %cl,%eax
  803ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb0:	89 f1                	mov    %esi,%ecx
  803bb2:	d3 e8                	shr    %cl,%eax
  803bb4:	09 d0                	or     %edx,%eax
  803bb6:	d3 eb                	shr    %cl,%ebx
  803bb8:	89 da                	mov    %ebx,%edx
  803bba:	f7 f7                	div    %edi
  803bbc:	89 d3                	mov    %edx,%ebx
  803bbe:	f7 24 24             	mull   (%esp)
  803bc1:	89 c6                	mov    %eax,%esi
  803bc3:	89 d1                	mov    %edx,%ecx
  803bc5:	39 d3                	cmp    %edx,%ebx
  803bc7:	0f 82 87 00 00 00    	jb     803c54 <__umoddi3+0x134>
  803bcd:	0f 84 91 00 00 00    	je     803c64 <__umoddi3+0x144>
  803bd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bd7:	29 f2                	sub    %esi,%edx
  803bd9:	19 cb                	sbb    %ecx,%ebx
  803bdb:	89 d8                	mov    %ebx,%eax
  803bdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803be1:	d3 e0                	shl    %cl,%eax
  803be3:	89 e9                	mov    %ebp,%ecx
  803be5:	d3 ea                	shr    %cl,%edx
  803be7:	09 d0                	or     %edx,%eax
  803be9:	89 e9                	mov    %ebp,%ecx
  803beb:	d3 eb                	shr    %cl,%ebx
  803bed:	89 da                	mov    %ebx,%edx
  803bef:	83 c4 1c             	add    $0x1c,%esp
  803bf2:	5b                   	pop    %ebx
  803bf3:	5e                   	pop    %esi
  803bf4:	5f                   	pop    %edi
  803bf5:	5d                   	pop    %ebp
  803bf6:	c3                   	ret    
  803bf7:	90                   	nop
  803bf8:	89 fd                	mov    %edi,%ebp
  803bfa:	85 ff                	test   %edi,%edi
  803bfc:	75 0b                	jne    803c09 <__umoddi3+0xe9>
  803bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803c03:	31 d2                	xor    %edx,%edx
  803c05:	f7 f7                	div    %edi
  803c07:	89 c5                	mov    %eax,%ebp
  803c09:	89 f0                	mov    %esi,%eax
  803c0b:	31 d2                	xor    %edx,%edx
  803c0d:	f7 f5                	div    %ebp
  803c0f:	89 c8                	mov    %ecx,%eax
  803c11:	f7 f5                	div    %ebp
  803c13:	89 d0                	mov    %edx,%eax
  803c15:	e9 44 ff ff ff       	jmp    803b5e <__umoddi3+0x3e>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	89 c8                	mov    %ecx,%eax
  803c1e:	89 f2                	mov    %esi,%edx
  803c20:	83 c4 1c             	add    $0x1c,%esp
  803c23:	5b                   	pop    %ebx
  803c24:	5e                   	pop    %esi
  803c25:	5f                   	pop    %edi
  803c26:	5d                   	pop    %ebp
  803c27:	c3                   	ret    
  803c28:	3b 04 24             	cmp    (%esp),%eax
  803c2b:	72 06                	jb     803c33 <__umoddi3+0x113>
  803c2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c31:	77 0f                	ja     803c42 <__umoddi3+0x122>
  803c33:	89 f2                	mov    %esi,%edx
  803c35:	29 f9                	sub    %edi,%ecx
  803c37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c3b:	89 14 24             	mov    %edx,(%esp)
  803c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c46:	8b 14 24             	mov    (%esp),%edx
  803c49:	83 c4 1c             	add    $0x1c,%esp
  803c4c:	5b                   	pop    %ebx
  803c4d:	5e                   	pop    %esi
  803c4e:	5f                   	pop    %edi
  803c4f:	5d                   	pop    %ebp
  803c50:	c3                   	ret    
  803c51:	8d 76 00             	lea    0x0(%esi),%esi
  803c54:	2b 04 24             	sub    (%esp),%eax
  803c57:	19 fa                	sbb    %edi,%edx
  803c59:	89 d1                	mov    %edx,%ecx
  803c5b:	89 c6                	mov    %eax,%esi
  803c5d:	e9 71 ff ff ff       	jmp    803bd3 <__umoddi3+0xb3>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c68:	72 ea                	jb     803c54 <__umoddi3+0x134>
  803c6a:	89 d9                	mov    %ebx,%ecx
  803c6c:	e9 62 ff ff ff       	jmp    803bd3 <__umoddi3+0xb3>
