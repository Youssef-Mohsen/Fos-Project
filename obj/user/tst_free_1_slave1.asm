
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
  800060:	68 20 3c 80 00       	push   $0x803c20
  800065:	6a 11                	push   $0x11
  800067:	68 3c 3c 80 00       	push   $0x803c3c
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
  8000bc:	e8 52 19 00 00       	call   801a13 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 95 19 00 00       	call   801a5e <sys_pf_calculate_allocated_pages>
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
  8000f4:	68 58 3c 80 00       	push   $0x803c58
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 3c 3c 80 00       	push   $0x803c3c
  800100:	e8 27 03 00 00       	call   80042c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 54 19 00 00       	call   801a5e <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 88 3c 80 00       	push   $0x803c88
  800117:	6a 33                	push   $0x33
  800119:	68 3c 3c 80 00       	push   $0x803c3c
  80011e:	e8 09 03 00 00       	call   80042c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 eb 18 00 00       	call   801a13 <sys_calculate_free_frames>
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
  80015f:	e8 af 18 00 00       	call   801a13 <sys_calculate_free_frames>
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
  800181:	6a 3d                	push   $0x3d
  800183:	68 3c 3c 80 00       	push   $0x803c3c
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
  8001c7:	e8 a2 1c 00 00       	call   801e6e <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 34 3d 80 00       	push   $0x803d34
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 3c 3c 80 00       	push   $0x803c3c
  8001e7:	e8 40 02 00 00       	call   80042c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 22 18 00 00       	call   801a13 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 65 18 00 00       	call   801a5e <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 ad 14 00 00       	call   8016b8 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 4b 18 00 00       	call   801a5e <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 54 3d 80 00       	push   $0x803d54
  800220:	6a 4e                	push   $0x4e
  800222:	68 3c 3c 80 00       	push   $0x803c3c
  800227:	e8 00 02 00 00       	call   80042c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 e2 17 00 00       	call   801a13 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 90 3d 80 00       	push   $0x803d90
  800247:	6a 4f                	push   $0x4f
  800249:	68 3c 3c 80 00       	push   $0x803c3c
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
  80028d:	e8 dc 1b 00 00       	call   801e6e <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 dc 3d 80 00       	push   $0x803ddc
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 3c 3c 80 00       	push   $0x803c3c
  8002ad:	e8 7a 01 00 00       	call   80042c <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 63 1a 00 00       	call   801d1a <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 77 1a 00 00       	call   801d34 <gettst>
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
  8002d4:	e8 41 1a 00 00       	call   801d1a <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 00 3e 80 00       	push   $0x803e00
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 3c 3c 80 00       	push   $0x803c3c
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
  8002f3:	e8 e4 18 00 00       	call   801bdc <sys_getenvindex>
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
  800361:	e8 fa 15 00 00       	call   801960 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 64 3e 80 00       	push   $0x803e64
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
  800391:	68 8c 3e 80 00       	push   $0x803e8c
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
  8003c2:	68 b4 3e 80 00       	push   $0x803eb4
  8003c7:	e8 1d 03 00 00       	call   8006e9 <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	68 0c 3f 80 00       	push   $0x803f0c
  8003e3:	e8 01 03 00 00       	call   8006e9 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	68 64 3e 80 00       	push   $0x803e64
  8003f3:	e8 f1 02 00 00       	call   8006e9 <cprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003fb:	e8 7a 15 00 00       	call   80197a <sys_unlock_cons>
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
  800413:	e8 90 17 00 00       	call   801ba8 <sys_destroy_env>
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
  800424:	e8 e5 17 00 00       	call   801c0e <sys_exit_env>
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
  80044d:	68 20 3f 80 00       	push   $0x803f20
  800452:	e8 92 02 00 00       	call   8006e9 <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 00 50 80 00       	mov    0x805000,%eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	50                   	push   %eax
  800466:	68 25 3f 80 00       	push   $0x803f25
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
  80048a:	68 41 3f 80 00       	push   $0x803f41
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
  8004b9:	68 44 3f 80 00       	push   $0x803f44
  8004be:	6a 26                	push   $0x26
  8004c0:	68 90 3f 80 00       	push   $0x803f90
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
  80058e:	68 9c 3f 80 00       	push   $0x803f9c
  800593:	6a 3a                	push   $0x3a
  800595:	68 90 3f 80 00       	push   $0x803f90
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
  800601:	68 f0 3f 80 00       	push   $0x803ff0
  800606:	6a 44                	push   $0x44
  800608:	68 90 3f 80 00       	push   $0x803f90
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
  80065b:	e8 be 12 00 00       	call   80191e <sys_cputs>
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
  8006d2:	e8 47 12 00 00       	call   80191e <sys_cputs>
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
  80071c:	e8 3f 12 00 00       	call   801960 <sys_lock_cons>
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
  80073c:	e8 39 12 00 00       	call   80197a <sys_unlock_cons>
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
  800786:	e8 2d 32 00 00       	call   8039b8 <__udivdi3>
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
  8007d6:	e8 ed 32 00 00       	call   803ac8 <__umoddi3>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	05 54 42 80 00       	add    $0x804254,%eax
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
  800931:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  800a12:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800a19:	85 f6                	test   %esi,%esi
  800a1b:	75 19                	jne    800a36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a1d:	53                   	push   %ebx
  800a1e:	68 65 42 80 00       	push   $0x804265
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
  800a37:	68 6e 42 80 00       	push   $0x80426e
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
  800a64:	be 71 42 80 00       	mov    $0x804271,%esi
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
  80146f:	68 e8 43 80 00       	push   $0x8043e8
  801474:	68 3f 01 00 00       	push   $0x13f
  801479:	68 0a 44 80 00       	push   $0x80440a
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
  80148f:	e8 35 0a 00 00       	call   801ec9 <sys_sbrk>
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
  80150a:	e8 3e 08 00 00       	call   801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 16                	je     801529 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 7e 0d 00 00       	call   80229c <alloc_block_FF>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	e9 8a 01 00 00       	jmp    8016b3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801529:	e8 50 08 00 00       	call   801d7e <sys_isUHeapPlacementStrategyBESTFIT>
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 84 7d 01 00 00    	je     8016b3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	e8 17 12 00 00       	call   802758 <alloc_block_BF>
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
  8016a2:	e8 59 08 00 00       	call   801f00 <sys_allocate_user_mem>
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
  8016ea:	e8 2d 08 00 00       	call   801f1c <get_block_size>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 60 1a 00 00       	call   803160 <free_block>
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
  801792:	e8 4d 07 00 00       	call   801ee4 <sys_free_user_mem>
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
  8017a0:	68 18 44 80 00       	push   $0x804418
  8017a5:	68 84 00 00 00       	push   $0x84
  8017aa:	68 42 44 80 00       	push   $0x804442
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
  801812:	e8 d4 02 00 00       	call   801aeb <sys_createSharedObject>
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
  801833:	68 4e 44 80 00       	push   $0x80444e
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
  801848:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	68 54 44 80 00       	push   $0x804454
  801853:	68 a4 00 00 00       	push   $0xa4
  801858:	68 42 44 80 00       	push   $0x804442
  80185d:	e8 ca eb ff ff       	call   80042c <_panic>

00801862 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	68 78 44 80 00       	push   $0x804478
  801870:	68 bc 00 00 00       	push   $0xbc
  801875:	68 42 44 80 00       	push   $0x804442
  80187a:	e8 ad eb ff ff       	call   80042c <_panic>

0080187f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 9c 44 80 00       	push   $0x80449c
  80188d:	68 d3 00 00 00       	push   $0xd3
  801892:	68 42 44 80 00       	push   $0x804442
  801897:	e8 90 eb ff ff       	call   80042c <_panic>

0080189c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 c2 44 80 00       	push   $0x8044c2
  8018aa:	68 df 00 00 00       	push   $0xdf
  8018af:	68 42 44 80 00       	push   $0x804442
  8018b4:	e8 73 eb ff ff       	call   80042c <_panic>

008018b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 c2 44 80 00       	push   $0x8044c2
  8018c7:	68 e4 00 00 00       	push   $0xe4
  8018cc:	68 42 44 80 00       	push   $0x804442
  8018d1:	e8 56 eb ff ff       	call   80042c <_panic>

008018d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 c2 44 80 00       	push   $0x8044c2
  8018e4:	68 e9 00 00 00       	push   $0xe9
  8018e9:	68 42 44 80 00       	push   $0x804442
  8018ee:	e8 39 eb ff ff       	call   80042c <_panic>

008018f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	57                   	push   %edi
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801905:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801908:	8b 7d 18             	mov    0x18(%ebp),%edi
  80190b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80190e:	cd 30                	int    $0x30
  801910:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801913:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5f                   	pop    %edi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	8b 45 10             	mov    0x10(%ebp),%eax
  801927:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	52                   	push   %edx
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	50                   	push   %eax
  80193a:	6a 00                	push   $0x0
  80193c:	e8 b2 ff ff ff       	call   8018f3 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	90                   	nop
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_cgetc>:

int
sys_cgetc(void)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 02                	push   $0x2
  801956:	e8 98 ff ff ff       	call   8018f3 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 03                	push   $0x3
  80196f:	e8 7f ff ff ff       	call   8018f3 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 04                	push   $0x4
  801989:	e8 65 ff ff ff       	call   8018f3 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	6a 08                	push   $0x8
  8019a7:	e8 47 ff ff ff       	call   8018f3 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8019b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	51                   	push   %ecx
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	6a 09                	push   $0x9
  8019cc:	e8 22 ff ff ff       	call   8018f3 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5d                   	pop    %ebp
  8019da:	c3                   	ret    

008019db <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	52                   	push   %edx
  8019eb:	50                   	push   %eax
  8019ec:	6a 0a                	push   $0xa
  8019ee:	e8 00 ff ff ff       	call   8018f3 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	6a 0b                	push   $0xb
  801a09:	e8 e5 fe ff ff       	call   8018f3 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 0c                	push   $0xc
  801a22:	e8 cc fe ff ff       	call   8018f3 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 0d                	push   $0xd
  801a3b:	e8 b3 fe ff ff       	call   8018f3 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 0e                	push   $0xe
  801a54:	e8 9a fe ff ff       	call   8018f3 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 0f                	push   $0xf
  801a6d:	e8 81 fe ff ff       	call   8018f3 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	6a 10                	push   $0x10
  801a87:	e8 67 fe ff ff       	call   8018f3 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 11                	push   $0x11
  801aa0:	e8 4e fe ff ff       	call   8018f3 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_cputc>:

void
sys_cputc(const char c)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ab7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 01                	push   $0x1
  801ac6:	e8 28 fe ff ff       	call   8018f3 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 14                	push   $0x14
  801ae0:	e8 0e fe ff ff       	call   8018f3 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801afa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	51                   	push   %ecx
  801b04:	52                   	push   %edx
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	50                   	push   %eax
  801b09:	6a 15                	push   $0x15
  801b0b:	e8 e3 fd ff ff       	call   8018f3 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 16                	push   $0x16
  801b28:	e8 c6 fd ff ff       	call   8018f3 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	51                   	push   %ecx
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 17                	push   $0x17
  801b47:	e8 a7 fd ff ff       	call   8018f3 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 18                	push   $0x18
  801b64:	e8 8a fd ff ff       	call   8018f3 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 14             	pushl  0x14(%ebp)
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 19                	push   $0x19
  801b82:	e8 6c fd ff ff       	call   8018f3 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 1a                	push   $0x1a
  801b9d:	e8 51 fd ff ff       	call   8018f3 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	50                   	push   %eax
  801bb7:	6a 1b                	push   $0x1b
  801bb9:	e8 35 fd ff ff       	call   8018f3 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 05                	push   $0x5
  801bd2:	e8 1c fd ff ff       	call   8018f3 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 06                	push   $0x6
  801beb:	e8 03 fd ff ff       	call   8018f3 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 07                	push   $0x7
  801c04:	e8 ea fc ff ff       	call   8018f3 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_exit_env>:


void sys_exit_env(void)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 1c                	push   $0x1c
  801c1d:	e8 d1 fc ff ff       	call   8018f3 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c31:	8d 50 04             	lea    0x4(%eax),%edx
  801c34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	52                   	push   %edx
  801c3e:	50                   	push   %eax
  801c3f:	6a 1d                	push   $0x1d
  801c41:	e8 ad fc ff ff       	call   8018f3 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return result;
  801c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c52:	89 01                	mov    %eax,(%ecx)
  801c54:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	c9                   	leave  
  801c5b:	c2 04 00             	ret    $0x4

00801c5e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	ff 75 08             	pushl  0x8(%ebp)
  801c6e:	6a 13                	push   $0x13
  801c70:	e8 7e fc ff ff       	call   8018f3 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
	return ;
  801c78:	90                   	nop
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_rcr2>:
uint32 sys_rcr2()
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 1e                	push   $0x1e
  801c8a:	e8 64 fc ff ff       	call   8018f3 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	50                   	push   %eax
  801cad:	6a 1f                	push   $0x1f
  801caf:	e8 3f fc ff ff       	call   8018f3 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <rsttst>:
void rsttst()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 21                	push   $0x21
  801cc9:	e8 25 fc ff ff       	call   8018f3 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ce3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	ff 75 10             	pushl  0x10(%ebp)
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	6a 20                	push   $0x20
  801cf4:	e8 fa fb ff ff       	call   8018f3 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <chktst>:
void chktst(uint32 n)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 22                	push   $0x22
  801d0f:	e8 df fb ff ff       	call   8018f3 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <inctst>:

void inctst()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 23                	push   $0x23
  801d29:	e8 c5 fb ff ff       	call   8018f3 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <gettst>:
uint32 gettst()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 24                	push   $0x24
  801d43:	e8 ab fb ff ff       	call   8018f3 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 25                	push   $0x25
  801d5f:	e8 8f fb ff ff       	call   8018f3 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
  801d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d6e:	75 07                	jne    801d77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d70:	b8 01 00 00 00       	mov    $0x1,%eax
  801d75:	eb 05                	jmp    801d7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 25                	push   $0x25
  801d90:	e8 5e fb ff ff       	call   8018f3 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d9f:	75 07                	jne    801da8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da1:	b8 01 00 00 00       	mov    $0x1,%eax
  801da6:	eb 05                	jmp    801dad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 25                	push   $0x25
  801dc1:	e8 2d fb ff ff       	call   8018f3 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
  801dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dcc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd0:	75 07                	jne    801dd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	eb 05                	jmp    801dde <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 25                	push   $0x25
  801df2:	e8 fc fa ff ff       	call   8018f3 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
  801dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dfd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e01:	75 07                	jne    801e0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e03:	b8 01 00 00 00       	mov    $0x1,%eax
  801e08:	eb 05                	jmp    801e0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 26                	push   $0x26
  801e21:	e8 cd fa ff ff       	call   8018f3 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	53                   	push   %ebx
  801e3f:	51                   	push   %ecx
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 27                	push   $0x27
  801e44:	e8 aa fa ff ff       	call   8018f3 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	52                   	push   %edx
  801e61:	50                   	push   %eax
  801e62:	6a 28                	push   $0x28
  801e64:	e8 8a fa ff ff       	call   8018f3 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	51                   	push   %ecx
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	52                   	push   %edx
  801e81:	50                   	push   %eax
  801e82:	6a 29                	push   $0x29
  801e84:	e8 6a fa ff ff       	call   8018f3 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	ff 75 10             	pushl  0x10(%ebp)
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	6a 12                	push   $0x12
  801ea0:	e8 4e fa ff ff       	call   8018f3 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	52                   	push   %edx
  801ebb:	50                   	push   %eax
  801ebc:	6a 2a                	push   $0x2a
  801ebe:	e8 30 fa ff ff       	call   8018f3 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
	return;
  801ec6:	90                   	nop
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	50                   	push   %eax
  801ed8:	6a 2b                	push   $0x2b
  801eda:	e8 14 fa ff ff       	call   8018f3 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	6a 2c                	push   $0x2c
  801ef5:	e8 f9 f9 ff ff       	call   8018f3 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	ff 75 08             	pushl  0x8(%ebp)
  801f0f:	6a 2d                	push   $0x2d
  801f11:	e8 dd f9 ff ff       	call   8018f3 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return;
  801f19:	90                   	nop
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	83 e8 04             	sub    $0x4,%eax
  801f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2e:	8b 00                	mov    (%eax),%eax
  801f30:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	83 e8 04             	sub    $0x4,%eax
  801f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f47:	8b 00                	mov    (%eax),%eax
  801f49:	83 e0 01             	and    $0x1,%eax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	0f 94 c0             	sete   %al
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	83 f8 02             	cmp    $0x2,%eax
  801f66:	74 2b                	je     801f93 <alloc_block+0x40>
  801f68:	83 f8 02             	cmp    $0x2,%eax
  801f6b:	7f 07                	jg     801f74 <alloc_block+0x21>
  801f6d:	83 f8 01             	cmp    $0x1,%eax
  801f70:	74 0e                	je     801f80 <alloc_block+0x2d>
  801f72:	eb 58                	jmp    801fcc <alloc_block+0x79>
  801f74:	83 f8 03             	cmp    $0x3,%eax
  801f77:	74 2d                	je     801fa6 <alloc_block+0x53>
  801f79:	83 f8 04             	cmp    $0x4,%eax
  801f7c:	74 3b                	je     801fb9 <alloc_block+0x66>
  801f7e:	eb 4c                	jmp    801fcc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	e8 11 03 00 00       	call   80229c <alloc_block_FF>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f91:	eb 4a                	jmp    801fdd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f93:	83 ec 0c             	sub    $0xc,%esp
  801f96:	ff 75 08             	pushl  0x8(%ebp)
  801f99:	e8 fa 19 00 00       	call   803998 <alloc_block_NF>
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fa4:	eb 37                	jmp    801fdd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	e8 a7 07 00 00       	call   802758 <alloc_block_BF>
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fb7:	eb 24                	jmp    801fdd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	e8 b7 19 00 00       	call   80397b <alloc_block_WF>
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fca:	eb 11                	jmp    801fdd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	68 d4 44 80 00       	push   $0x8044d4
  801fd4:	e8 10 e7 ff ff       	call   8006e9 <cprintf>
  801fd9:	83 c4 10             	add    $0x10,%esp
		break;
  801fdc:	90                   	nop
	}
	return va;
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	53                   	push   %ebx
  801fe6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	68 f4 44 80 00       	push   $0x8044f4
  801ff1:	e8 f3 e6 ff ff       	call   8006e9 <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	68 1f 45 80 00       	push   $0x80451f
  802001:	e8 e3 e6 ff ff       	call   8006e9 <cprintf>
  802006:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200f:	eb 37                	jmp    802048 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 f4             	pushl  -0xc(%ebp)
  802017:	e8 19 ff ff ff       	call   801f35 <is_free_block>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	0f be d8             	movsbl %al,%ebx
  802022:	83 ec 0c             	sub    $0xc,%esp
  802025:	ff 75 f4             	pushl  -0xc(%ebp)
  802028:	e8 ef fe ff ff       	call   801f1c <get_block_size>
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	83 ec 04             	sub    $0x4,%esp
  802033:	53                   	push   %ebx
  802034:	50                   	push   %eax
  802035:	68 37 45 80 00       	push   $0x804537
  80203a:	e8 aa e6 ff ff       	call   8006e9 <cprintf>
  80203f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802042:	8b 45 10             	mov    0x10(%ebp),%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	74 07                	je     802055 <print_blocks_list+0x73>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	eb 05                	jmp    80205a <print_blocks_list+0x78>
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	89 45 10             	mov    %eax,0x10(%ebp)
  80205d:	8b 45 10             	mov    0x10(%ebp),%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	75 ad                	jne    802011 <print_blocks_list+0x2f>
  802064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802068:	75 a7                	jne    802011 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	68 f4 44 80 00       	push   $0x8044f4
  802072:	e8 72 e6 ff ff       	call   8006e9 <cprintf>
  802077:	83 c4 10             	add    $0x10,%esp

}
  80207a:	90                   	nop
  80207b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802086:	8b 45 0c             	mov    0xc(%ebp),%eax
  802089:	83 e0 01             	and    $0x1,%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	74 03                	je     802093 <initialize_dynamic_allocator+0x13>
  802090:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802093:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802097:	0f 84 c7 01 00 00    	je     802264 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80209d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020a4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020b4:	0f 87 ad 01 00 00    	ja     802267 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	0f 89 a5 01 00 00    	jns    80226a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	83 e8 04             	sub    $0x4,%eax
  8020d0:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e4:	e9 87 00 00 00       	jmp    802170 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ed:	75 14                	jne    802103 <initialize_dynamic_allocator+0x83>
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 4f 45 80 00       	push   $0x80454f
  8020f7:	6a 79                	push   $0x79
  8020f9:	68 6d 45 80 00       	push   $0x80456d
  8020fe:	e8 29 e3 ff ff       	call   80042c <_panic>
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	74 10                	je     80211c <initialize_dynamic_allocator+0x9c>
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	8b 52 04             	mov    0x4(%edx),%edx
  802117:	89 50 04             	mov    %edx,0x4(%eax)
  80211a:	eb 0b                	jmp    802127 <initialize_dynamic_allocator+0xa7>
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 40 04             	mov    0x4(%eax),%eax
  802122:	a3 30 50 80 00       	mov    %eax,0x805030
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 40 04             	mov    0x4(%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	74 0f                	je     802140 <initialize_dynamic_allocator+0xc0>
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 40 04             	mov    0x4(%eax),%eax
  802137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213a:	8b 12                	mov    (%edx),%edx
  80213c:	89 10                	mov    %edx,(%eax)
  80213e:	eb 0a                	jmp    80214a <initialize_dynamic_allocator+0xca>
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215d:	a1 38 50 80 00       	mov    0x805038,%eax
  802162:	48                   	dec    %eax
  802163:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802168:	a1 34 50 80 00       	mov    0x805034,%eax
  80216d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802170:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802174:	74 07                	je     80217d <initialize_dynamic_allocator+0xfd>
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	eb 05                	jmp    802182 <initialize_dynamic_allocator+0x102>
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	a3 34 50 80 00       	mov    %eax,0x805034
  802187:	a1 34 50 80 00       	mov    0x805034,%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	0f 85 55 ff ff ff    	jne    8020e9 <initialize_dynamic_allocator+0x69>
  802194:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802198:	0f 85 4b ff ff ff    	jne    8020e9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021ad:	a1 44 50 80 00       	mov    0x805044,%eax
  8021b2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	83 c0 08             	add    $0x8,%eax
  8021c8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	83 c0 04             	add    $0x4,%eax
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	83 ea 08             	sub    $0x8,%edx
  8021d7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	01 d0                	add    %edx,%eax
  8021e1:	83 e8 08             	sub    $0x8,%eax
  8021e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e7:	83 ea 08             	sub    $0x8,%edx
  8021ea:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802203:	75 17                	jne    80221c <initialize_dynamic_allocator+0x19c>
  802205:	83 ec 04             	sub    $0x4,%esp
  802208:	68 88 45 80 00       	push   $0x804588
  80220d:	68 90 00 00 00       	push   $0x90
  802212:	68 6d 45 80 00       	push   $0x80456d
  802217:	e8 10 e2 ff ff       	call   80042c <_panic>
  80221c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802225:	89 10                	mov    %edx,(%eax)
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0d                	je     80223d <initialize_dynamic_allocator+0x1bd>
  802230:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802235:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802238:	89 50 04             	mov    %edx,0x4(%eax)
  80223b:	eb 08                	jmp    802245 <initialize_dynamic_allocator+0x1c5>
  80223d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802240:	a3 30 50 80 00       	mov    %eax,0x805030
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802257:	a1 38 50 80 00       	mov    0x805038,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 38 50 80 00       	mov    %eax,0x805038
  802262:	eb 07                	jmp    80226b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802264:	90                   	nop
  802265:	eb 04                	jmp    80226b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802267:	90                   	nop
  802268:	eb 01                	jmp    80226b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80226a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802270:	8b 45 10             	mov    0x10(%ebp),%eax
  802273:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	8d 50 fc             	lea    -0x4(%eax),%edx
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	83 e8 04             	sub    $0x4,%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	83 e0 fe             	and    $0xfffffffe,%eax
  80228c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	01 c2                	add    %eax,%edx
  802294:	8b 45 0c             	mov    0xc(%ebp),%eax
  802297:	89 02                	mov    %eax,(%edx)
}
  802299:	90                   	nop
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	83 e0 01             	and    $0x1,%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	74 03                	je     8022af <alloc_block_FF+0x13>
  8022ac:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022af:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022b3:	77 07                	ja     8022bc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022b5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022bc:	a1 24 50 80 00       	mov    0x805024,%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	75 73                	jne    802338 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	83 c0 10             	add    $0x10,%eax
  8022cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022ce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022db:	01 d0                	add    %edx,%eax
  8022dd:	48                   	dec    %eax
  8022de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e9:	f7 75 ec             	divl   -0x14(%ebp)
  8022ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ef:	29 d0                	sub    %edx,%eax
  8022f1:	c1 e8 0c             	shr    $0xc,%eax
  8022f4:	83 ec 0c             	sub    $0xc,%esp
  8022f7:	50                   	push   %eax
  8022f8:	e8 86 f1 ff ff       	call   801483 <sbrk>
  8022fd:	83 c4 10             	add    $0x10,%esp
  802300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	6a 00                	push   $0x0
  802308:	e8 76 f1 ff ff       	call   801483 <sbrk>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802316:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802319:	83 ec 08             	sub    $0x8,%esp
  80231c:	50                   	push   %eax
  80231d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802320:	e8 5b fd ff ff       	call   802080 <initialize_dynamic_allocator>
  802325:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	68 ab 45 80 00       	push   $0x8045ab
  802330:	e8 b4 e3 ff ff       	call   8006e9 <cprintf>
  802335:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233c:	75 0a                	jne    802348 <alloc_block_FF+0xac>
	        return NULL;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	e9 0e 04 00 00       	jmp    802756 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80234f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802357:	e9 f3 02 00 00       	jmp    80264f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802362:	83 ec 0c             	sub    $0xc,%esp
  802365:	ff 75 bc             	pushl  -0x44(%ebp)
  802368:	e8 af fb ff ff       	call   801f1c <get_block_size>
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	83 c0 08             	add    $0x8,%eax
  802379:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80237c:	0f 87 c5 02 00 00    	ja     802647 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	83 c0 18             	add    $0x18,%eax
  802388:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80238b:	0f 87 19 02 00 00    	ja     8025aa <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802391:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802394:	2b 45 08             	sub    0x8(%ebp),%eax
  802397:	83 e8 08             	sub    $0x8,%eax
  80239a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	8d 50 08             	lea    0x8(%eax),%edx
  8023a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023a6:	01 d0                	add    %edx,%eax
  8023a8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	83 c0 08             	add    $0x8,%eax
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	6a 01                	push   $0x1
  8023b6:	50                   	push   %eax
  8023b7:	ff 75 bc             	pushl  -0x44(%ebp)
  8023ba:	e8 ae fe ff ff       	call   80226d <set_block_data>
  8023bf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 40 04             	mov    0x4(%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 68                	jne    802434 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023cc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023d0:	75 17                	jne    8023e9 <alloc_block_FF+0x14d>
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 88 45 80 00       	push   $0x804588
  8023da:	68 d7 00 00 00       	push   $0xd7
  8023df:	68 6d 45 80 00       	push   $0x80456d
  8023e4:	e8 43 e0 ff ff       	call   80042c <_panic>
  8023e9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f2:	89 10                	mov    %edx,(%eax)
  8023f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 0d                	je     80240a <alloc_block_FF+0x16e>
  8023fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802402:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	eb 08                	jmp    802412 <alloc_block_FF+0x176>
  80240a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240d:	a3 30 50 80 00       	mov    %eax,0x805030
  802412:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802415:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802424:	a1 38 50 80 00       	mov    0x805038,%eax
  802429:	40                   	inc    %eax
  80242a:	a3 38 50 80 00       	mov    %eax,0x805038
  80242f:	e9 dc 00 00 00       	jmp    802510 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 65                	jne    8024a2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80243d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802441:	75 17                	jne    80245a <alloc_block_FF+0x1be>
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	68 bc 45 80 00       	push   $0x8045bc
  80244b:	68 db 00 00 00       	push   $0xdb
  802450:	68 6d 45 80 00       	push   $0x80456d
  802455:	e8 d2 df ff ff       	call   80042c <_panic>
  80245a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802469:	8b 40 04             	mov    0x4(%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 0c                	je     80247c <alloc_block_FF+0x1e0>
  802470:	a1 30 50 80 00       	mov    0x805030,%eax
  802475:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802478:	89 10                	mov    %edx,(%eax)
  80247a:	eb 08                	jmp    802484 <alloc_block_FF+0x1e8>
  80247c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802484:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802487:	a3 30 50 80 00       	mov    %eax,0x805030
  80248c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802495:	a1 38 50 80 00       	mov    0x805038,%eax
  80249a:	40                   	inc    %eax
  80249b:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a0:	eb 6e                	jmp    802510 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	74 06                	je     8024ae <alloc_block_FF+0x212>
  8024a8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ac:	75 17                	jne    8024c5 <alloc_block_FF+0x229>
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	68 e0 45 80 00       	push   $0x8045e0
  8024b6:	68 df 00 00 00       	push   $0xdf
  8024bb:	68 6d 45 80 00       	push   $0x80456d
  8024c0:	e8 67 df ff ff       	call   80042c <_panic>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 10                	mov    (%eax),%edx
  8024ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cd:	89 10                	mov    %edx,(%eax)
  8024cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 0b                	je     8024e3 <alloc_block_FF+0x247>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f1:	89 50 04             	mov    %edx,0x4(%eax)
  8024f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	75 08                	jne    802505 <alloc_block_FF+0x269>
  8024fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802500:	a3 30 50 80 00       	mov    %eax,0x805030
  802505:	a1 38 50 80 00       	mov    0x805038,%eax
  80250a:	40                   	inc    %eax
  80250b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_FF+0x291>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 4f 45 80 00       	push   $0x80454f
  80251e:	68 e1 00 00 00       	push   $0xe1
  802523:	68 6d 45 80 00       	push   $0x80456d
  802528:	e8 ff de ff ff       	call   80042c <_panic>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 10                	je     802546 <alloc_block_FF+0x2aa>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253e:	8b 52 04             	mov    0x4(%edx),%edx
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	eb 0b                	jmp    802551 <alloc_block_FF+0x2b5>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	a3 30 50 80 00       	mov    %eax,0x805030
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 0f                	je     80256a <alloc_block_FF+0x2ce>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802564:	8b 12                	mov    (%edx),%edx
  802566:	89 10                	mov    %edx,(%eax)
  802568:	eb 0a                	jmp    802574 <alloc_block_FF+0x2d8>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802587:	a1 38 50 80 00       	mov    0x805038,%eax
  80258c:	48                   	dec    %eax
  80258d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	6a 00                	push   $0x0
  802597:	ff 75 b4             	pushl  -0x4c(%ebp)
  80259a:	ff 75 b0             	pushl  -0x50(%ebp)
  80259d:	e8 cb fc ff ff       	call   80226d <set_block_data>
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	e9 95 00 00 00       	jmp    80263f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	6a 01                	push   $0x1
  8025af:	ff 75 b8             	pushl  -0x48(%ebp)
  8025b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8025b5:	e8 b3 fc ff ff       	call   80226d <set_block_data>
  8025ba:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	75 17                	jne    8025da <alloc_block_FF+0x33e>
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 4f 45 80 00       	push   $0x80454f
  8025cb:	68 e8 00 00 00       	push   $0xe8
  8025d0:	68 6d 45 80 00       	push   $0x80456d
  8025d5:	e8 52 de ff ff       	call   80042c <_panic>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 10                	je     8025f3 <alloc_block_FF+0x357>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025eb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ee:	89 50 04             	mov    %edx,0x4(%eax)
  8025f1:	eb 0b                	jmp    8025fe <alloc_block_FF+0x362>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0f                	je     802617 <alloc_block_FF+0x37b>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	8b 12                	mov    (%edx),%edx
  802613:	89 10                	mov    %edx,(%eax)
  802615:	eb 0a                	jmp    802621 <alloc_block_FF+0x385>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802634:	a1 38 50 80 00       	mov    0x805038,%eax
  802639:	48                   	dec    %eax
  80263a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80263f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802642:	e9 0f 01 00 00       	jmp    802756 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802647:	a1 34 50 80 00       	mov    0x805034,%eax
  80264c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802653:	74 07                	je     80265c <alloc_block_FF+0x3c0>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	eb 05                	jmp    802661 <alloc_block_FF+0x3c5>
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
  802661:	a3 34 50 80 00       	mov    %eax,0x805034
  802666:	a1 34 50 80 00       	mov    0x805034,%eax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	0f 85 e9 fc ff ff    	jne    80235c <alloc_block_FF+0xc0>
  802673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802677:	0f 85 df fc ff ff    	jne    80235c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	83 c0 08             	add    $0x8,%eax
  802683:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802686:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80268d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802690:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802693:	01 d0                	add    %edx,%eax
  802695:	48                   	dec    %eax
  802696:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80269c:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a1:	f7 75 d8             	divl   -0x28(%ebp)
  8026a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a7:	29 d0                	sub    %edx,%eax
  8026a9:	c1 e8 0c             	shr    $0xc,%eax
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	50                   	push   %eax
  8026b0:	e8 ce ed ff ff       	call   801483 <sbrk>
  8026b5:	83 c4 10             	add    $0x10,%esp
  8026b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026bb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026bf:	75 0a                	jne    8026cb <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c6:	e9 8b 00 00 00       	jmp    802756 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026cb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d8:	01 d0                	add    %edx,%eax
  8026da:	48                   	dec    %eax
  8026db:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e6:	f7 75 cc             	divl   -0x34(%ebp)
  8026e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026ec:	29 d0                	sub    %edx,%eax
  8026ee:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f4:	01 d0                	add    %edx,%eax
  8026f6:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802700:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802706:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80270d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802710:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802713:	01 d0                	add    %edx,%eax
  802715:	48                   	dec    %eax
  802716:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802719:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80271c:	ba 00 00 00 00       	mov    $0x0,%edx
  802721:	f7 75 c4             	divl   -0x3c(%ebp)
  802724:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802727:	29 d0                	sub    %edx,%eax
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	6a 01                	push   $0x1
  80272e:	50                   	push   %eax
  80272f:	ff 75 d0             	pushl  -0x30(%ebp)
  802732:	e8 36 fb ff ff       	call   80226d <set_block_data>
  802737:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80273a:	83 ec 0c             	sub    $0xc,%esp
  80273d:	ff 75 d0             	pushl  -0x30(%ebp)
  802740:	e8 1b 0a 00 00       	call   803160 <free_block>
  802745:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802748:	83 ec 0c             	sub    $0xc,%esp
  80274b:	ff 75 08             	pushl  0x8(%ebp)
  80274e:	e8 49 fb ff ff       	call   80229c <alloc_block_FF>
  802753:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	83 e0 01             	and    $0x1,%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 03                	je     80276b <alloc_block_BF+0x13>
  802768:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80276b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80276f:	77 07                	ja     802778 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802771:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802778:	a1 24 50 80 00       	mov    0x805024,%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 73                	jne    8027f4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	83 c0 10             	add    $0x10,%eax
  802787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80278a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802791:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	48                   	dec    %eax
  80279a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80279d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a5:	f7 75 e0             	divl   -0x20(%ebp)
  8027a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027ab:	29 d0                	sub    %edx,%eax
  8027ad:	c1 e8 0c             	shr    $0xc,%eax
  8027b0:	83 ec 0c             	sub    $0xc,%esp
  8027b3:	50                   	push   %eax
  8027b4:	e8 ca ec ff ff       	call   801483 <sbrk>
  8027b9:	83 c4 10             	add    $0x10,%esp
  8027bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027bf:	83 ec 0c             	sub    $0xc,%esp
  8027c2:	6a 00                	push   $0x0
  8027c4:	e8 ba ec ff ff       	call   801483 <sbrk>
  8027c9:	83 c4 10             	add    $0x10,%esp
  8027cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027d5:	83 ec 08             	sub    $0x8,%esp
  8027d8:	50                   	push   %eax
  8027d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8027dc:	e8 9f f8 ff ff       	call   802080 <initialize_dynamic_allocator>
  8027e1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027e4:	83 ec 0c             	sub    $0xc,%esp
  8027e7:	68 ab 45 80 00       	push   $0x8045ab
  8027ec:	e8 f8 de ff ff       	call   8006e9 <cprintf>
  8027f1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802802:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802810:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	e9 1d 01 00 00       	jmp    80293a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802823:	83 ec 0c             	sub    $0xc,%esp
  802826:	ff 75 a8             	pushl  -0x58(%ebp)
  802829:	e8 ee f6 ff ff       	call   801f1c <get_block_size>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	83 c0 08             	add    $0x8,%eax
  80283a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80283d:	0f 87 ef 00 00 00    	ja     802932 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	83 c0 18             	add    $0x18,%eax
  802849:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80284c:	77 1d                	ja     80286b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802854:	0f 86 d8 00 00 00    	jbe    802932 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80285a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80285d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802860:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802866:	e9 c7 00 00 00       	jmp    802932 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	83 c0 08             	add    $0x8,%eax
  802871:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802874:	0f 85 9d 00 00 00    	jne    802917 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	6a 01                	push   $0x1
  80287f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802882:	ff 75 a8             	pushl  -0x58(%ebp)
  802885:	e8 e3 f9 ff ff       	call   80226d <set_block_data>
  80288a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80288d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_BF+0x152>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 4f 45 80 00       	push   $0x80454f
  80289b:	68 2c 01 00 00       	push   $0x12c
  8028a0:	68 6d 45 80 00       	push   $0x80456d
  8028a5:	e8 82 db ff ff       	call   80042c <_panic>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 10                	je     8028c3 <alloc_block_BF+0x16b>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	8b 52 04             	mov    0x4(%edx),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 0b                	jmp    8028ce <alloc_block_BF+0x176>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0f                	je     8028e7 <alloc_block_BF+0x18f>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	8b 12                	mov    (%edx),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 0a                	jmp    8028f1 <alloc_block_BF+0x199>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802904:	a1 38 50 80 00       	mov    0x805038,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80290f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802912:	e9 24 04 00 00       	jmp    802d3b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80291d:	76 13                	jbe    802932 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80291f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802926:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802929:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80292c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80292f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802932:	a1 34 50 80 00       	mov    0x805034,%eax
  802937:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293e:	74 07                	je     802947 <alloc_block_BF+0x1ef>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	eb 05                	jmp    80294c <alloc_block_BF+0x1f4>
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
  80294c:	a3 34 50 80 00       	mov    %eax,0x805034
  802951:	a1 34 50 80 00       	mov    0x805034,%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	0f 85 bf fe ff ff    	jne    80281d <alloc_block_BF+0xc5>
  80295e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802962:	0f 85 b5 fe ff ff    	jne    80281d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296c:	0f 84 26 02 00 00    	je     802b98 <alloc_block_BF+0x440>
  802972:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802976:	0f 85 1c 02 00 00    	jne    802b98 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80297c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297f:	2b 45 08             	sub    0x8(%ebp),%eax
  802982:	83 e8 08             	sub    $0x8,%eax
  802985:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	8d 50 08             	lea    0x8(%eax),%edx
  80298e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802991:	01 d0                	add    %edx,%eax
  802993:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	83 c0 08             	add    $0x8,%eax
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	6a 01                	push   $0x1
  8029a1:	50                   	push   %eax
  8029a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8029a5:	e8 c3 f8 ff ff       	call   80226d <set_block_data>
  8029aa:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	75 68                	jne    802a1f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029bb:	75 17                	jne    8029d4 <alloc_block_BF+0x27c>
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	68 88 45 80 00       	push   $0x804588
  8029c5:	68 45 01 00 00       	push   $0x145
  8029ca:	68 6d 45 80 00       	push   $0x80456d
  8029cf:	e8 58 da ff ff       	call   80042c <_panic>
  8029d4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dd:	89 10                	mov    %edx,(%eax)
  8029df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 0d                	je     8029f5 <alloc_block_BF+0x29d>
  8029e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f0:	89 50 04             	mov    %edx,0x4(%eax)
  8029f3:	eb 08                	jmp    8029fd <alloc_block_BF+0x2a5>
  8029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a00:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a14:	40                   	inc    %eax
  802a15:	a3 38 50 80 00       	mov    %eax,0x805038
  802a1a:	e9 dc 00 00 00       	jmp    802afb <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	75 65                	jne    802a8d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a28:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a2c:	75 17                	jne    802a45 <alloc_block_BF+0x2ed>
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	68 bc 45 80 00       	push   $0x8045bc
  802a36:	68 4a 01 00 00       	push   $0x14a
  802a3b:	68 6d 45 80 00       	push   $0x80456d
  802a40:	e8 e7 d9 ff ff       	call   80042c <_panic>
  802a45:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	89 50 04             	mov    %edx,0x4(%eax)
  802a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a54:	8b 40 04             	mov    0x4(%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 0c                	je     802a67 <alloc_block_BF+0x30f>
  802a5b:	a1 30 50 80 00       	mov    0x805030,%eax
  802a60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 08                	jmp    802a6f <alloc_block_BF+0x317>
  802a67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a72:	a3 30 50 80 00       	mov    %eax,0x805030
  802a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a80:	a1 38 50 80 00       	mov    0x805038,%eax
  802a85:	40                   	inc    %eax
  802a86:	a3 38 50 80 00       	mov    %eax,0x805038
  802a8b:	eb 6e                	jmp    802afb <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a91:	74 06                	je     802a99 <alloc_block_BF+0x341>
  802a93:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a97:	75 17                	jne    802ab0 <alloc_block_BF+0x358>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 e0 45 80 00       	push   $0x8045e0
  802aa1:	68 4f 01 00 00       	push   $0x14f
  802aa6:	68 6d 45 80 00       	push   $0x80456d
  802aab:	e8 7c d9 ff ff       	call   80042c <_panic>
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 10                	mov    (%eax),%edx
  802ab5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab8:	89 10                	mov    %edx,(%eax)
  802aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 0b                	je     802ace <alloc_block_BF+0x376>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	75 08                	jne    802af0 <alloc_block_BF+0x398>
  802ae8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aeb:	a3 30 50 80 00       	mov    %eax,0x805030
  802af0:	a1 38 50 80 00       	mov    0x805038,%eax
  802af5:	40                   	inc    %eax
  802af6:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802afb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aff:	75 17                	jne    802b18 <alloc_block_BF+0x3c0>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 4f 45 80 00       	push   $0x80454f
  802b09:	68 51 01 00 00       	push   $0x151
  802b0e:	68 6d 45 80 00       	push   $0x80456d
  802b13:	e8 14 d9 ff ff       	call   80042c <_panic>
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 10                	je     802b31 <alloc_block_BF+0x3d9>
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b29:	8b 52 04             	mov    0x4(%edx),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 0b                	jmp    802b3c <alloc_block_BF+0x3e4>
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0f                	je     802b55 <alloc_block_BF+0x3fd>
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4f:	8b 12                	mov    (%edx),%edx
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	eb 0a                	jmp    802b5f <alloc_block_BF+0x407>
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 38 50 80 00       	mov    0x805038,%eax
  802b77:	48                   	dec    %eax
  802b78:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	6a 00                	push   $0x0
  802b82:	ff 75 d0             	pushl  -0x30(%ebp)
  802b85:	ff 75 cc             	pushl  -0x34(%ebp)
  802b88:	e8 e0 f6 ff ff       	call   80226d <set_block_data>
  802b8d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	e9 a3 01 00 00       	jmp    802d3b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b98:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b9c:	0f 85 9d 00 00 00    	jne    802c3f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	6a 01                	push   $0x1
  802ba7:	ff 75 ec             	pushl  -0x14(%ebp)
  802baa:	ff 75 f0             	pushl  -0x10(%ebp)
  802bad:	e8 bb f6 ff ff       	call   80226d <set_block_data>
  802bb2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb9:	75 17                	jne    802bd2 <alloc_block_BF+0x47a>
  802bbb:	83 ec 04             	sub    $0x4,%esp
  802bbe:	68 4f 45 80 00       	push   $0x80454f
  802bc3:	68 58 01 00 00       	push   $0x158
  802bc8:	68 6d 45 80 00       	push   $0x80456d
  802bcd:	e8 5a d8 ff ff       	call   80042c <_panic>
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 10                	je     802beb <alloc_block_BF+0x493>
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be3:	8b 52 04             	mov    0x4(%edx),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	eb 0b                	jmp    802bf6 <alloc_block_BF+0x49e>
  802beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0f                	je     802c0f <alloc_block_BF+0x4b7>
  802c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c09:	8b 12                	mov    (%edx),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	eb 0a                	jmp    802c19 <alloc_block_BF+0x4c1>
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c31:	48                   	dec    %eax
  802c32:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	e9 fc 00 00 00       	jmp    802d3b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	83 c0 08             	add    $0x8,%eax
  802c45:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c48:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c4f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c55:	01 d0                	add    %edx,%eax
  802c57:	48                   	dec    %eax
  802c58:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c63:	f7 75 c4             	divl   -0x3c(%ebp)
  802c66:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c69:	29 d0                	sub    %edx,%eax
  802c6b:	c1 e8 0c             	shr    $0xc,%eax
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	50                   	push   %eax
  802c72:	e8 0c e8 ff ff       	call   801483 <sbrk>
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c7d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c81:	75 0a                	jne    802c8d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c83:	b8 00 00 00 00       	mov    $0x0,%eax
  802c88:	e9 ae 00 00 00       	jmp    802d3b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c8d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c94:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c97:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c9a:	01 d0                	add    %edx,%eax
  802c9c:	48                   	dec    %eax
  802c9d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ca0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca8:	f7 75 b8             	divl   -0x48(%ebp)
  802cab:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cae:	29 d0                	sub    %edx,%eax
  802cb0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cb3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cb6:	01 d0                	add    %edx,%eax
  802cb8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cbd:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cc8:	83 ec 0c             	sub    $0xc,%esp
  802ccb:	68 14 46 80 00       	push   $0x804614
  802cd0:	e8 14 da ff ff       	call   8006e9 <cprintf>
  802cd5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cd8:	83 ec 08             	sub    $0x8,%esp
  802cdb:	ff 75 bc             	pushl  -0x44(%ebp)
  802cde:	68 19 46 80 00       	push   $0x804619
  802ce3:	e8 01 da ff ff       	call   8006e9 <cprintf>
  802ce8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ceb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cf2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cf5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	48                   	dec    %eax
  802cfb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cfe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d01:	ba 00 00 00 00       	mov    $0x0,%edx
  802d06:	f7 75 b0             	divl   -0x50(%ebp)
  802d09:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d0c:	29 d0                	sub    %edx,%eax
  802d0e:	83 ec 04             	sub    $0x4,%esp
  802d11:	6a 01                	push   $0x1
  802d13:	50                   	push   %eax
  802d14:	ff 75 bc             	pushl  -0x44(%ebp)
  802d17:	e8 51 f5 ff ff       	call   80226d <set_block_data>
  802d1c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d1f:	83 ec 0c             	sub    $0xc,%esp
  802d22:	ff 75 bc             	pushl  -0x44(%ebp)
  802d25:	e8 36 04 00 00       	call   803160 <free_block>
  802d2a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d2d:	83 ec 0c             	sub    $0xc,%esp
  802d30:	ff 75 08             	pushl  0x8(%ebp)
  802d33:	e8 20 fa ff ff       	call   802758 <alloc_block_BF>
  802d38:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d3b:	c9                   	leave  
  802d3c:	c3                   	ret    

00802d3d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d3d:	55                   	push   %ebp
  802d3e:	89 e5                	mov    %esp,%ebp
  802d40:	53                   	push   %ebx
  802d41:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d56:	74 1e                	je     802d76 <merging+0x39>
  802d58:	ff 75 08             	pushl  0x8(%ebp)
  802d5b:	e8 bc f1 ff ff       	call   801f1c <get_block_size>
  802d60:	83 c4 04             	add    $0x4,%esp
  802d63:	89 c2                	mov    %eax,%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	01 d0                	add    %edx,%eax
  802d6a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d6d:	75 07                	jne    802d76 <merging+0x39>
		prev_is_free = 1;
  802d6f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7a:	74 1e                	je     802d9a <merging+0x5d>
  802d7c:	ff 75 10             	pushl  0x10(%ebp)
  802d7f:	e8 98 f1 ff ff       	call   801f1c <get_block_size>
  802d84:	83 c4 04             	add    $0x4,%esp
  802d87:	89 c2                	mov    %eax,%edx
  802d89:	8b 45 10             	mov    0x10(%ebp),%eax
  802d8c:	01 d0                	add    %edx,%eax
  802d8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d91:	75 07                	jne    802d9a <merging+0x5d>
		next_is_free = 1;
  802d93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9e:	0f 84 cc 00 00 00    	je     802e70 <merging+0x133>
  802da4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da8:	0f 84 c2 00 00 00    	je     802e70 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dae:	ff 75 08             	pushl  0x8(%ebp)
  802db1:	e8 66 f1 ff ff       	call   801f1c <get_block_size>
  802db6:	83 c4 04             	add    $0x4,%esp
  802db9:	89 c3                	mov    %eax,%ebx
  802dbb:	ff 75 10             	pushl  0x10(%ebp)
  802dbe:	e8 59 f1 ff ff       	call   801f1c <get_block_size>
  802dc3:	83 c4 04             	add    $0x4,%esp
  802dc6:	01 c3                	add    %eax,%ebx
  802dc8:	ff 75 0c             	pushl  0xc(%ebp)
  802dcb:	e8 4c f1 ff ff       	call   801f1c <get_block_size>
  802dd0:	83 c4 04             	add    $0x4,%esp
  802dd3:	01 d8                	add    %ebx,%eax
  802dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dd8:	6a 00                	push   $0x0
  802dda:	ff 75 ec             	pushl  -0x14(%ebp)
  802ddd:	ff 75 08             	pushl  0x8(%ebp)
  802de0:	e8 88 f4 ff ff       	call   80226d <set_block_data>
  802de5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dec:	75 17                	jne    802e05 <merging+0xc8>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 4f 45 80 00       	push   $0x80454f
  802df6:	68 7d 01 00 00       	push   $0x17d
  802dfb:	68 6d 45 80 00       	push   $0x80456d
  802e00:	e8 27 d6 ff ff       	call   80042c <_panic>
  802e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e08:	8b 00                	mov    (%eax),%eax
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	74 10                	je     802e1e <merging+0xe1>
  802e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e11:	8b 00                	mov    (%eax),%eax
  802e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e16:	8b 52 04             	mov    0x4(%edx),%edx
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	eb 0b                	jmp    802e29 <merging+0xec>
  802e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	a3 30 50 80 00       	mov    %eax,0x805030
  802e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 0f                	je     802e42 <merging+0x105>
  802e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3c:	8b 12                	mov    (%edx),%edx
  802e3e:	89 10                	mov    %edx,(%eax)
  802e40:	eb 0a                	jmp    802e4c <merging+0x10f>
  802e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802e64:	48                   	dec    %eax
  802e65:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e6a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e6b:	e9 ea 02 00 00       	jmp    80315a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e74:	74 3b                	je     802eb1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e76:	83 ec 0c             	sub    $0xc,%esp
  802e79:	ff 75 08             	pushl  0x8(%ebp)
  802e7c:	e8 9b f0 ff ff       	call   801f1c <get_block_size>
  802e81:	83 c4 10             	add    $0x10,%esp
  802e84:	89 c3                	mov    %eax,%ebx
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	ff 75 10             	pushl  0x10(%ebp)
  802e8c:	e8 8b f0 ff ff       	call   801f1c <get_block_size>
  802e91:	83 c4 10             	add    $0x10,%esp
  802e94:	01 d8                	add    %ebx,%eax
  802e96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	6a 00                	push   $0x0
  802e9e:	ff 75 e8             	pushl  -0x18(%ebp)
  802ea1:	ff 75 08             	pushl  0x8(%ebp)
  802ea4:	e8 c4 f3 ff ff       	call   80226d <set_block_data>
  802ea9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eac:	e9 a9 02 00 00       	jmp    80315a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802eb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb5:	0f 84 2d 01 00 00    	je     802fe8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ebb:	83 ec 0c             	sub    $0xc,%esp
  802ebe:	ff 75 10             	pushl  0x10(%ebp)
  802ec1:	e8 56 f0 ff ff       	call   801f1c <get_block_size>
  802ec6:	83 c4 10             	add    $0x10,%esp
  802ec9:	89 c3                	mov    %eax,%ebx
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	ff 75 0c             	pushl  0xc(%ebp)
  802ed1:	e8 46 f0 ff ff       	call   801f1c <get_block_size>
  802ed6:	83 c4 10             	add    $0x10,%esp
  802ed9:	01 d8                	add    %ebx,%eax
  802edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ede:	83 ec 04             	sub    $0x4,%esp
  802ee1:	6a 00                	push   $0x0
  802ee3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ee6:	ff 75 10             	pushl  0x10(%ebp)
  802ee9:	e8 7f f3 ff ff       	call   80226d <set_block_data>
  802eee:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ef7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802efb:	74 06                	je     802f03 <merging+0x1c6>
  802efd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f01:	75 17                	jne    802f1a <merging+0x1dd>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 28 46 80 00       	push   $0x804628
  802f0b:	68 8d 01 00 00       	push   $0x18d
  802f10:	68 6d 45 80 00       	push   $0x80456d
  802f15:	e8 12 d5 ff ff       	call   80042c <_panic>
  802f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1d:	8b 50 04             	mov    0x4(%eax),%edx
  802f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f23:	89 50 04             	mov    %edx,0x4(%eax)
  802f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2c:	89 10                	mov    %edx,(%eax)
  802f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0d                	je     802f45 <merging+0x208>
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f41:	89 10                	mov    %edx,(%eax)
  802f43:	eb 08                	jmp    802f4d <merging+0x210>
  802f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5b:	40                   	inc    %eax
  802f5c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f65:	75 17                	jne    802f7e <merging+0x241>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 4f 45 80 00       	push   $0x80454f
  802f6f:	68 8e 01 00 00       	push   $0x18e
  802f74:	68 6d 45 80 00       	push   $0x80456d
  802f79:	e8 ae d4 ff ff       	call   80042c <_panic>
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 10                	je     802f97 <merging+0x25a>
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8f:	8b 52 04             	mov    0x4(%edx),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	eb 0b                	jmp    802fa2 <merging+0x265>
  802f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0f                	je     802fbb <merging+0x27e>
  802fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb5:	8b 12                	mov    (%edx),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 0a                	jmp    802fc5 <merging+0x288>
  802fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fdd:	48                   	dec    %eax
  802fde:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe3:	e9 72 01 00 00       	jmp    80315a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  802feb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff2:	74 79                	je     80306d <merging+0x330>
  802ff4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff8:	74 73                	je     80306d <merging+0x330>
  802ffa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffe:	74 06                	je     803006 <merging+0x2c9>
  803000:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803004:	75 17                	jne    80301d <merging+0x2e0>
  803006:	83 ec 04             	sub    $0x4,%esp
  803009:	68 e0 45 80 00       	push   $0x8045e0
  80300e:	68 94 01 00 00       	push   $0x194
  803013:	68 6d 45 80 00       	push   $0x80456d
  803018:	e8 0f d4 ff ff       	call   80042c <_panic>
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	8b 10                	mov    (%eax),%edx
  803022:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803025:	89 10                	mov    %edx,(%eax)
  803027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	74 0b                	je     80303b <merging+0x2fe>
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803038:	89 50 04             	mov    %edx,0x4(%eax)
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803046:	8b 55 08             	mov    0x8(%ebp),%edx
  803049:	89 50 04             	mov    %edx,0x4(%eax)
  80304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	75 08                	jne    80305d <merging+0x320>
  803055:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803058:	a3 30 50 80 00       	mov    %eax,0x805030
  80305d:	a1 38 50 80 00       	mov    0x805038,%eax
  803062:	40                   	inc    %eax
  803063:	a3 38 50 80 00       	mov    %eax,0x805038
  803068:	e9 ce 00 00 00       	jmp    80313b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80306d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803071:	74 65                	je     8030d8 <merging+0x39b>
  803073:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803077:	75 17                	jne    803090 <merging+0x353>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 bc 45 80 00       	push   $0x8045bc
  803081:	68 95 01 00 00       	push   $0x195
  803086:	68 6d 45 80 00       	push   $0x80456d
  80308b:	e8 9c d3 ff ff       	call   80042c <_panic>
  803090:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803096:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803099:	89 50 04             	mov    %edx,0x4(%eax)
  80309c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0c                	je     8030b2 <merging+0x375>
  8030a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8030ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ae:	89 10                	mov    %edx,(%eax)
  8030b0:	eb 08                	jmp    8030ba <merging+0x37d>
  8030b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d0:	40                   	inc    %eax
  8030d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8030d6:	eb 63                	jmp    80313b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030dc:	75 17                	jne    8030f5 <merging+0x3b8>
  8030de:	83 ec 04             	sub    $0x4,%esp
  8030e1:	68 88 45 80 00       	push   $0x804588
  8030e6:	68 98 01 00 00       	push   $0x198
  8030eb:	68 6d 45 80 00       	push   $0x80456d
  8030f0:	e8 37 d3 ff ff       	call   80042c <_panic>
  8030f5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0d                	je     803116 <merging+0x3d9>
  803109:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80310e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	eb 08                	jmp    80311e <merging+0x3e1>
  803116:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803119:	a3 30 50 80 00       	mov    %eax,0x805030
  80311e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803121:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803126:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 38 50 80 00       	mov    0x805038,%eax
  803135:	40                   	inc    %eax
  803136:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80313b:	83 ec 0c             	sub    $0xc,%esp
  80313e:	ff 75 10             	pushl  0x10(%ebp)
  803141:	e8 d6 ed ff ff       	call   801f1c <get_block_size>
  803146:	83 c4 10             	add    $0x10,%esp
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	6a 00                	push   $0x0
  80314e:	50                   	push   %eax
  80314f:	ff 75 10             	pushl  0x10(%ebp)
  803152:	e8 16 f1 ff ff       	call   80226d <set_block_data>
  803157:	83 c4 10             	add    $0x10,%esp
	}
}
  80315a:	90                   	nop
  80315b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803166:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80316b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80316e:	a1 30 50 80 00       	mov    0x805030,%eax
  803173:	3b 45 08             	cmp    0x8(%ebp),%eax
  803176:	73 1b                	jae    803193 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803178:	a1 30 50 80 00       	mov    0x805030,%eax
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	ff 75 08             	pushl  0x8(%ebp)
  803183:	6a 00                	push   $0x0
  803185:	50                   	push   %eax
  803186:	e8 b2 fb ff ff       	call   802d3d <merging>
  80318b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80318e:	e9 8b 00 00 00       	jmp    80321e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803193:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803198:	3b 45 08             	cmp    0x8(%ebp),%eax
  80319b:	76 18                	jbe    8031b5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80319d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	ff 75 08             	pushl  0x8(%ebp)
  8031a8:	50                   	push   %eax
  8031a9:	6a 00                	push   $0x0
  8031ab:	e8 8d fb ff ff       	call   802d3d <merging>
  8031b0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031b3:	eb 69                	jmp    80321e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bd:	eb 39                	jmp    8031f8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c5:	73 29                	jae    8031f0 <free_block+0x90>
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cf:	76 1f                	jbe    8031f0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	ff 75 08             	pushl  0x8(%ebp)
  8031df:	ff 75 f0             	pushl  -0x10(%ebp)
  8031e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8031e5:	e8 53 fb ff ff       	call   802d3d <merging>
  8031ea:	83 c4 10             	add    $0x10,%esp
			break;
  8031ed:	90                   	nop
		}
	}
}
  8031ee:	eb 2e                	jmp    80321e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031f0:	a1 34 50 80 00       	mov    0x805034,%eax
  8031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fc:	74 07                	je     803205 <free_block+0xa5>
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	eb 05                	jmp    80320a <free_block+0xaa>
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	a3 34 50 80 00       	mov    %eax,0x805034
  80320f:	a1 34 50 80 00       	mov    0x805034,%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	75 a7                	jne    8031bf <free_block+0x5f>
  803218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321c:	75 a1                	jne    8031bf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80321e:	90                   	nop
  80321f:	c9                   	leave  
  803220:	c3                   	ret    

00803221 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803221:	55                   	push   %ebp
  803222:	89 e5                	mov    %esp,%ebp
  803224:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	e8 ed ec ff ff       	call   801f1c <get_block_size>
  80322f:	83 c4 04             	add    $0x4,%esp
  803232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80323c:	eb 17                	jmp    803255 <copy_data+0x34>
  80323e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803241:	8b 45 0c             	mov    0xc(%ebp),%eax
  803244:	01 c2                	add    %eax,%edx
  803246:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	01 c8                	add    %ecx,%eax
  80324e:	8a 00                	mov    (%eax),%al
  803250:	88 02                	mov    %al,(%edx)
  803252:	ff 45 fc             	incl   -0x4(%ebp)
  803255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80325b:	72 e1                	jb     80323e <copy_data+0x1d>
}
  80325d:	90                   	nop
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
  803263:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326a:	75 23                	jne    80328f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80326c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803270:	74 13                	je     803285 <realloc_block_FF+0x25>
  803272:	83 ec 0c             	sub    $0xc,%esp
  803275:	ff 75 0c             	pushl  0xc(%ebp)
  803278:	e8 1f f0 ff ff       	call   80229c <alloc_block_FF>
  80327d:	83 c4 10             	add    $0x10,%esp
  803280:	e9 f4 06 00 00       	jmp    803979 <realloc_block_FF+0x719>
		return NULL;
  803285:	b8 00 00 00 00       	mov    $0x0,%eax
  80328a:	e9 ea 06 00 00       	jmp    803979 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80328f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803293:	75 18                	jne    8032ad <realloc_block_FF+0x4d>
	{
		free_block(va);
  803295:	83 ec 0c             	sub    $0xc,%esp
  803298:	ff 75 08             	pushl  0x8(%ebp)
  80329b:	e8 c0 fe ff ff       	call   803160 <free_block>
  8032a0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a8:	e9 cc 06 00 00       	jmp    803979 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032ad:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032b1:	77 07                	ja     8032ba <realloc_block_FF+0x5a>
  8032b3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bd:	83 e0 01             	and    $0x1,%eax
  8032c0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c6:	83 c0 08             	add    $0x8,%eax
  8032c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032cc:	83 ec 0c             	sub    $0xc,%esp
  8032cf:	ff 75 08             	pushl  0x8(%ebp)
  8032d2:	e8 45 ec ff ff       	call   801f1c <get_block_size>
  8032d7:	83 c4 10             	add    $0x10,%esp
  8032da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e0:	83 e8 08             	sub    $0x8,%eax
  8032e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	83 e8 04             	sub    $0x4,%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	83 e0 fe             	and    $0xfffffffe,%eax
  8032f1:	89 c2                	mov    %eax,%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	01 d0                	add    %edx,%eax
  8032f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032fb:	83 ec 0c             	sub    $0xc,%esp
  8032fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803301:	e8 16 ec ff ff       	call   801f1c <get_block_size>
  803306:	83 c4 10             	add    $0x10,%esp
  803309:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80330c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330f:	83 e8 08             	sub    $0x8,%eax
  803312:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803315:	8b 45 0c             	mov    0xc(%ebp),%eax
  803318:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80331b:	75 08                	jne    803325 <realloc_block_FF+0xc5>
	{
		 return va;
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	e9 54 06 00 00       	jmp    803979 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803325:	8b 45 0c             	mov    0xc(%ebp),%eax
  803328:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80332b:	0f 83 e5 03 00 00    	jae    803716 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	2b 45 0c             	sub    0xc(%ebp),%eax
  803337:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80333a:	83 ec 0c             	sub    $0xc,%esp
  80333d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803340:	e8 f0 eb ff ff       	call   801f35 <is_free_block>
  803345:	83 c4 10             	add    $0x10,%esp
  803348:	84 c0                	test   %al,%al
  80334a:	0f 84 3b 01 00 00    	je     80348b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803350:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803353:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803356:	01 d0                	add    %edx,%eax
  803358:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80335b:	83 ec 04             	sub    $0x4,%esp
  80335e:	6a 01                	push   $0x1
  803360:	ff 75 f0             	pushl  -0x10(%ebp)
  803363:	ff 75 08             	pushl  0x8(%ebp)
  803366:	e8 02 ef ff ff       	call   80226d <set_block_data>
  80336b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	83 e8 04             	sub    $0x4,%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	83 e0 fe             	and    $0xfffffffe,%eax
  803379:	89 c2                	mov    %eax,%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	01 d0                	add    %edx,%eax
  803380:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	6a 00                	push   $0x0
  803388:	ff 75 cc             	pushl  -0x34(%ebp)
  80338b:	ff 75 c8             	pushl  -0x38(%ebp)
  80338e:	e8 da ee ff ff       	call   80226d <set_block_data>
  803393:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803396:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80339a:	74 06                	je     8033a2 <realloc_block_FF+0x142>
  80339c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033a0:	75 17                	jne    8033b9 <realloc_block_FF+0x159>
  8033a2:	83 ec 04             	sub    $0x4,%esp
  8033a5:	68 e0 45 80 00       	push   $0x8045e0
  8033aa:	68 f6 01 00 00       	push   $0x1f6
  8033af:	68 6d 45 80 00       	push   $0x80456d
  8033b4:	e8 73 d0 ff ff       	call   80042c <_panic>
  8033b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bc:	8b 10                	mov    (%eax),%edx
  8033be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c1:	89 10                	mov    %edx,(%eax)
  8033c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 0b                	je     8033d7 <realloc_block_FF+0x177>
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033da:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033dd:	89 10                	mov    %edx,(%eax)
  8033df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	75 08                	jne    8033f9 <realloc_block_FF+0x199>
  8033f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fe:	40                   	inc    %eax
  8033ff:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803404:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803408:	75 17                	jne    803421 <realloc_block_FF+0x1c1>
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 4f 45 80 00       	push   $0x80454f
  803412:	68 f7 01 00 00       	push   $0x1f7
  803417:	68 6d 45 80 00       	push   $0x80456d
  80341c:	e8 0b d0 ff ff       	call   80042c <_panic>
  803421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 10                	je     80343a <realloc_block_FF+0x1da>
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803432:	8b 52 04             	mov    0x4(%edx),%edx
  803435:	89 50 04             	mov    %edx,0x4(%eax)
  803438:	eb 0b                	jmp    803445 <realloc_block_FF+0x1e5>
  80343a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	a3 30 50 80 00       	mov    %eax,0x805030
  803445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 0f                	je     80345e <realloc_block_FF+0x1fe>
  80344f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803458:	8b 12                	mov    (%edx),%edx
  80345a:	89 10                	mov    %edx,(%eax)
  80345c:	eb 0a                	jmp    803468 <realloc_block_FF+0x208>
  80345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803474:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347b:	a1 38 50 80 00       	mov    0x805038,%eax
  803480:	48                   	dec    %eax
  803481:	a3 38 50 80 00       	mov    %eax,0x805038
  803486:	e9 83 02 00 00       	jmp    80370e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80348b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80348f:	0f 86 69 02 00 00    	jbe    8036fe <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	6a 01                	push   $0x1
  80349a:	ff 75 f0             	pushl  -0x10(%ebp)
  80349d:	ff 75 08             	pushl  0x8(%ebp)
  8034a0:	e8 c8 ed ff ff       	call   80226d <set_block_data>
  8034a5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	83 e8 04             	sub    $0x4,%eax
  8034ae:	8b 00                	mov    (%eax),%eax
  8034b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8034b3:	89 c2                	mov    %eax,%edx
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	01 d0                	add    %edx,%eax
  8034ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034c5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034c9:	75 68                	jne    803533 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034cf:	75 17                	jne    8034e8 <realloc_block_FF+0x288>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 88 45 80 00       	push   $0x804588
  8034d9:	68 06 02 00 00       	push   $0x206
  8034de:	68 6d 45 80 00       	push   $0x80456d
  8034e3:	e8 44 cf ff ff       	call   80042c <_panic>
  8034e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f1:	89 10                	mov    %edx,(%eax)
  8034f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 0d                	je     803509 <realloc_block_FF+0x2a9>
  8034fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803504:	89 50 04             	mov    %edx,0x4(%eax)
  803507:	eb 08                	jmp    803511 <realloc_block_FF+0x2b1>
  803509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350c:	a3 30 50 80 00       	mov    %eax,0x805030
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803519:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 38 50 80 00       	mov    0x805038,%eax
  803528:	40                   	inc    %eax
  803529:	a3 38 50 80 00       	mov    %eax,0x805038
  80352e:	e9 b0 01 00 00       	jmp    8036e3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803533:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803538:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80353b:	76 68                	jbe    8035a5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80353d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803541:	75 17                	jne    80355a <realloc_block_FF+0x2fa>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 88 45 80 00       	push   $0x804588
  80354b:	68 0b 02 00 00       	push   $0x20b
  803550:	68 6d 45 80 00       	push   $0x80456d
  803555:	e8 d2 ce ff ff       	call   80042c <_panic>
  80355a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	89 10                	mov    %edx,(%eax)
  803565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	85 c0                	test   %eax,%eax
  80356c:	74 0d                	je     80357b <realloc_block_FF+0x31b>
  80356e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803573:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	eb 08                	jmp    803583 <realloc_block_FF+0x323>
  80357b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357e:	a3 30 50 80 00       	mov    %eax,0x805030
  803583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803586:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803595:	a1 38 50 80 00       	mov    0x805038,%eax
  80359a:	40                   	inc    %eax
  80359b:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a0:	e9 3e 01 00 00       	jmp    8036e3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ad:	73 68                	jae    803617 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b3:	75 17                	jne    8035cc <realloc_block_FF+0x36c>
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	68 bc 45 80 00       	push   $0x8045bc
  8035bd:	68 10 02 00 00       	push   $0x210
  8035c2:	68 6d 45 80 00       	push   $0x80456d
  8035c7:	e8 60 ce ff ff       	call   80042c <_panic>
  8035cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	74 0c                	je     8035ee <realloc_block_FF+0x38e>
  8035e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8035e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ea:	89 10                	mov    %edx,(%eax)
  8035ec:	eb 08                	jmp    8035f6 <realloc_block_FF+0x396>
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803607:	a1 38 50 80 00       	mov    0x805038,%eax
  80360c:	40                   	inc    %eax
  80360d:	a3 38 50 80 00       	mov    %eax,0x805038
  803612:	e9 cc 00 00 00       	jmp    8036e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80361e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803626:	e9 8a 00 00 00       	jmp    8036b5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803631:	73 7a                	jae    8036ad <realloc_block_FF+0x44d>
  803633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80363b:	73 70                	jae    8036ad <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80363d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803641:	74 06                	je     803649 <realloc_block_FF+0x3e9>
  803643:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803647:	75 17                	jne    803660 <realloc_block_FF+0x400>
  803649:	83 ec 04             	sub    $0x4,%esp
  80364c:	68 e0 45 80 00       	push   $0x8045e0
  803651:	68 1a 02 00 00       	push   $0x21a
  803656:	68 6d 45 80 00       	push   $0x80456d
  80365b:	e8 cc cd ff ff       	call   80042c <_panic>
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 10                	mov    (%eax),%edx
  803665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366d:	8b 00                	mov    (%eax),%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	74 0b                	je     80367e <realloc_block_FF+0x41e>
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	8b 00                	mov    (%eax),%eax
  803678:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%eax)
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803684:	89 10                	mov    %edx,(%eax)
  803686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80368c:	89 50 04             	mov    %edx,0x4(%eax)
  80368f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	75 08                	jne    8036a0 <realloc_block_FF+0x440>
  803698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369b:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a5:	40                   	inc    %eax
  8036a6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036ab:	eb 36                	jmp    8036e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8036b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b9:	74 07                	je     8036c2 <realloc_block_FF+0x462>
  8036bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036be:	8b 00                	mov    (%eax),%eax
  8036c0:	eb 05                	jmp    8036c7 <realloc_block_FF+0x467>
  8036c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8036cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	0f 85 52 ff ff ff    	jne    80362b <realloc_block_FF+0x3cb>
  8036d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036dd:	0f 85 48 ff ff ff    	jne    80362b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	6a 00                	push   $0x0
  8036e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8036eb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036ee:	e8 7a eb ff ff       	call   80226d <set_block_data>
  8036f3:	83 c4 10             	add    $0x10,%esp
				return va;
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	e9 7b 02 00 00       	jmp    803979 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036fe:	83 ec 0c             	sub    $0xc,%esp
  803701:	68 5d 46 80 00       	push   $0x80465d
  803706:	e8 de cf ff ff       	call   8006e9 <cprintf>
  80370b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	e9 63 02 00 00       	jmp    803979 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803716:	8b 45 0c             	mov    0xc(%ebp),%eax
  803719:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80371c:	0f 86 4d 02 00 00    	jbe    80396f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	ff 75 e4             	pushl  -0x1c(%ebp)
  803728:	e8 08 e8 ff ff       	call   801f35 <is_free_block>
  80372d:	83 c4 10             	add    $0x10,%esp
  803730:	84 c0                	test   %al,%al
  803732:	0f 84 37 02 00 00    	je     80396f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80373e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803741:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803744:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803747:	76 38                	jbe    803781 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803749:	83 ec 0c             	sub    $0xc,%esp
  80374c:	ff 75 08             	pushl  0x8(%ebp)
  80374f:	e8 0c fa ff ff       	call   803160 <free_block>
  803754:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803757:	83 ec 0c             	sub    $0xc,%esp
  80375a:	ff 75 0c             	pushl  0xc(%ebp)
  80375d:	e8 3a eb ff ff       	call   80229c <alloc_block_FF>
  803762:	83 c4 10             	add    $0x10,%esp
  803765:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803768:	83 ec 08             	sub    $0x8,%esp
  80376b:	ff 75 c0             	pushl  -0x40(%ebp)
  80376e:	ff 75 08             	pushl  0x8(%ebp)
  803771:	e8 ab fa ff ff       	call   803221 <copy_data>
  803776:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803779:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80377c:	e9 f8 01 00 00       	jmp    803979 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803781:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803784:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803787:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80378a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80378e:	0f 87 a0 00 00 00    	ja     803834 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803794:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803798:	75 17                	jne    8037b1 <realloc_block_FF+0x551>
  80379a:	83 ec 04             	sub    $0x4,%esp
  80379d:	68 4f 45 80 00       	push   $0x80454f
  8037a2:	68 38 02 00 00       	push   $0x238
  8037a7:	68 6d 45 80 00       	push   $0x80456d
  8037ac:	e8 7b cc ff ff       	call   80042c <_panic>
  8037b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	85 c0                	test   %eax,%eax
  8037b8:	74 10                	je     8037ca <realloc_block_FF+0x56a>
  8037ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c2:	8b 52 04             	mov    0x4(%edx),%edx
  8037c5:	89 50 04             	mov    %edx,0x4(%eax)
  8037c8:	eb 0b                	jmp    8037d5 <realloc_block_FF+0x575>
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	8b 40 04             	mov    0x4(%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 0f                	je     8037ee <realloc_block_FF+0x58e>
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e8:	8b 12                	mov    (%edx),%edx
  8037ea:	89 10                	mov    %edx,(%eax)
  8037ec:	eb 0a                	jmp    8037f8 <realloc_block_FF+0x598>
  8037ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380b:	a1 38 50 80 00       	mov    0x805038,%eax
  803810:	48                   	dec    %eax
  803811:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803816:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803819:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381c:	01 d0                	add    %edx,%eax
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	6a 01                	push   $0x1
  803823:	50                   	push   %eax
  803824:	ff 75 08             	pushl  0x8(%ebp)
  803827:	e8 41 ea ff ff       	call   80226d <set_block_data>
  80382c:	83 c4 10             	add    $0x10,%esp
  80382f:	e9 36 01 00 00       	jmp    80396a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803837:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80383a:	01 d0                	add    %edx,%eax
  80383c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	6a 01                	push   $0x1
  803844:	ff 75 f0             	pushl  -0x10(%ebp)
  803847:	ff 75 08             	pushl  0x8(%ebp)
  80384a:	e8 1e ea ff ff       	call   80226d <set_block_data>
  80384f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	83 e8 04             	sub    $0x4,%eax
  803858:	8b 00                	mov    (%eax),%eax
  80385a:	83 e0 fe             	and    $0xfffffffe,%eax
  80385d:	89 c2                	mov    %eax,%edx
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	01 d0                	add    %edx,%eax
  803864:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803867:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80386b:	74 06                	je     803873 <realloc_block_FF+0x613>
  80386d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803871:	75 17                	jne    80388a <realloc_block_FF+0x62a>
  803873:	83 ec 04             	sub    $0x4,%esp
  803876:	68 e0 45 80 00       	push   $0x8045e0
  80387b:	68 44 02 00 00       	push   $0x244
  803880:	68 6d 45 80 00       	push   $0x80456d
  803885:	e8 a2 cb ff ff       	call   80042c <_panic>
  80388a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388d:	8b 10                	mov    (%eax),%edx
  80388f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803892:	89 10                	mov    %edx,(%eax)
  803894:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803897:	8b 00                	mov    (%eax),%eax
  803899:	85 c0                	test   %eax,%eax
  80389b:	74 0b                	je     8038a8 <realloc_block_FF+0x648>
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 00                	mov    (%eax),%eax
  8038a2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038a5:	89 50 04             	mov    %edx,0x4(%eax)
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038ae:	89 10                	mov    %edx,(%eax)
  8038b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b6:	89 50 04             	mov    %edx,0x4(%eax)
  8038b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	75 08                	jne    8038ca <realloc_block_FF+0x66a>
  8038c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cf:	40                   	inc    %eax
  8038d0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d9:	75 17                	jne    8038f2 <realloc_block_FF+0x692>
  8038db:	83 ec 04             	sub    $0x4,%esp
  8038de:	68 4f 45 80 00       	push   $0x80454f
  8038e3:	68 45 02 00 00       	push   $0x245
  8038e8:	68 6d 45 80 00       	push   $0x80456d
  8038ed:	e8 3a cb ff ff       	call   80042c <_panic>
  8038f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 10                	je     80390b <realloc_block_FF+0x6ab>
  8038fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fe:	8b 00                	mov    (%eax),%eax
  803900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803903:	8b 52 04             	mov    0x4(%edx),%edx
  803906:	89 50 04             	mov    %edx,0x4(%eax)
  803909:	eb 0b                	jmp    803916 <realloc_block_FF+0x6b6>
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	a3 30 50 80 00       	mov    %eax,0x805030
  803916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803919:	8b 40 04             	mov    0x4(%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 0f                	je     80392f <realloc_block_FF+0x6cf>
  803920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803923:	8b 40 04             	mov    0x4(%eax),%eax
  803926:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803929:	8b 12                	mov    (%edx),%edx
  80392b:	89 10                	mov    %edx,(%eax)
  80392d:	eb 0a                	jmp    803939 <realloc_block_FF+0x6d9>
  80392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803932:	8b 00                	mov    (%eax),%eax
  803934:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394c:	a1 38 50 80 00       	mov    0x805038,%eax
  803951:	48                   	dec    %eax
  803952:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803957:	83 ec 04             	sub    $0x4,%esp
  80395a:	6a 00                	push   $0x0
  80395c:	ff 75 bc             	pushl  -0x44(%ebp)
  80395f:	ff 75 b8             	pushl  -0x48(%ebp)
  803962:	e8 06 e9 ff ff       	call   80226d <set_block_data>
  803967:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	eb 0a                	jmp    803979 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80396f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803976:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803979:	c9                   	leave  
  80397a:	c3                   	ret    

0080397b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80397b:	55                   	push   %ebp
  80397c:	89 e5                	mov    %esp,%ebp
  80397e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803981:	83 ec 04             	sub    $0x4,%esp
  803984:	68 64 46 80 00       	push   $0x804664
  803989:	68 58 02 00 00       	push   $0x258
  80398e:	68 6d 45 80 00       	push   $0x80456d
  803993:	e8 94 ca ff ff       	call   80042c <_panic>

00803998 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803998:	55                   	push   %ebp
  803999:	89 e5                	mov    %esp,%ebp
  80399b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80399e:	83 ec 04             	sub    $0x4,%esp
  8039a1:	68 8c 46 80 00       	push   $0x80468c
  8039a6:	68 61 02 00 00       	push   $0x261
  8039ab:	68 6d 45 80 00       	push   $0x80456d
  8039b0:	e8 77 ca ff ff       	call   80042c <_panic>
  8039b5:	66 90                	xchg   %ax,%ax
  8039b7:	90                   	nop

008039b8 <__udivdi3>:
  8039b8:	55                   	push   %ebp
  8039b9:	57                   	push   %edi
  8039ba:	56                   	push   %esi
  8039bb:	53                   	push   %ebx
  8039bc:	83 ec 1c             	sub    $0x1c,%esp
  8039bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039cf:	89 ca                	mov    %ecx,%edx
  8039d1:	89 f8                	mov    %edi,%eax
  8039d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039d7:	85 f6                	test   %esi,%esi
  8039d9:	75 2d                	jne    803a08 <__udivdi3+0x50>
  8039db:	39 cf                	cmp    %ecx,%edi
  8039dd:	77 65                	ja     803a44 <__udivdi3+0x8c>
  8039df:	89 fd                	mov    %edi,%ebp
  8039e1:	85 ff                	test   %edi,%edi
  8039e3:	75 0b                	jne    8039f0 <__udivdi3+0x38>
  8039e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ea:	31 d2                	xor    %edx,%edx
  8039ec:	f7 f7                	div    %edi
  8039ee:	89 c5                	mov    %eax,%ebp
  8039f0:	31 d2                	xor    %edx,%edx
  8039f2:	89 c8                	mov    %ecx,%eax
  8039f4:	f7 f5                	div    %ebp
  8039f6:	89 c1                	mov    %eax,%ecx
  8039f8:	89 d8                	mov    %ebx,%eax
  8039fa:	f7 f5                	div    %ebp
  8039fc:	89 cf                	mov    %ecx,%edi
  8039fe:	89 fa                	mov    %edi,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	39 ce                	cmp    %ecx,%esi
  803a0a:	77 28                	ja     803a34 <__udivdi3+0x7c>
  803a0c:	0f bd fe             	bsr    %esi,%edi
  803a0f:	83 f7 1f             	xor    $0x1f,%edi
  803a12:	75 40                	jne    803a54 <__udivdi3+0x9c>
  803a14:	39 ce                	cmp    %ecx,%esi
  803a16:	72 0a                	jb     803a22 <__udivdi3+0x6a>
  803a18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a1c:	0f 87 9e 00 00 00    	ja     803ac0 <__udivdi3+0x108>
  803a22:	b8 01 00 00 00       	mov    $0x1,%eax
  803a27:	89 fa                	mov    %edi,%edx
  803a29:	83 c4 1c             	add    $0x1c,%esp
  803a2c:	5b                   	pop    %ebx
  803a2d:	5e                   	pop    %esi
  803a2e:	5f                   	pop    %edi
  803a2f:	5d                   	pop    %ebp
  803a30:	c3                   	ret    
  803a31:	8d 76 00             	lea    0x0(%esi),%esi
  803a34:	31 ff                	xor    %edi,%edi
  803a36:	31 c0                	xor    %eax,%eax
  803a38:	89 fa                	mov    %edi,%edx
  803a3a:	83 c4 1c             	add    $0x1c,%esp
  803a3d:	5b                   	pop    %ebx
  803a3e:	5e                   	pop    %esi
  803a3f:	5f                   	pop    %edi
  803a40:	5d                   	pop    %ebp
  803a41:	c3                   	ret    
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	89 d8                	mov    %ebx,%eax
  803a46:	f7 f7                	div    %edi
  803a48:	31 ff                	xor    %edi,%edi
  803a4a:	89 fa                	mov    %edi,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a59:	89 eb                	mov    %ebp,%ebx
  803a5b:	29 fb                	sub    %edi,%ebx
  803a5d:	89 f9                	mov    %edi,%ecx
  803a5f:	d3 e6                	shl    %cl,%esi
  803a61:	89 c5                	mov    %eax,%ebp
  803a63:	88 d9                	mov    %bl,%cl
  803a65:	d3 ed                	shr    %cl,%ebp
  803a67:	89 e9                	mov    %ebp,%ecx
  803a69:	09 f1                	or     %esi,%ecx
  803a6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a6f:	89 f9                	mov    %edi,%ecx
  803a71:	d3 e0                	shl    %cl,%eax
  803a73:	89 c5                	mov    %eax,%ebp
  803a75:	89 d6                	mov    %edx,%esi
  803a77:	88 d9                	mov    %bl,%cl
  803a79:	d3 ee                	shr    %cl,%esi
  803a7b:	89 f9                	mov    %edi,%ecx
  803a7d:	d3 e2                	shl    %cl,%edx
  803a7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 e8                	shr    %cl,%eax
  803a87:	09 c2                	or     %eax,%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	89 f2                	mov    %esi,%edx
  803a8d:	f7 74 24 0c          	divl   0xc(%esp)
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	89 c3                	mov    %eax,%ebx
  803a95:	f7 e5                	mul    %ebp
  803a97:	39 d6                	cmp    %edx,%esi
  803a99:	72 19                	jb     803ab4 <__udivdi3+0xfc>
  803a9b:	74 0b                	je     803aa8 <__udivdi3+0xf0>
  803a9d:	89 d8                	mov    %ebx,%eax
  803a9f:	31 ff                	xor    %edi,%edi
  803aa1:	e9 58 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aac:	89 f9                	mov    %edi,%ecx
  803aae:	d3 e2                	shl    %cl,%edx
  803ab0:	39 c2                	cmp    %eax,%edx
  803ab2:	73 e9                	jae    803a9d <__udivdi3+0xe5>
  803ab4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ab7:	31 ff                	xor    %edi,%edi
  803ab9:	e9 40 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	31 c0                	xor    %eax,%eax
  803ac2:	e9 37 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803ac7:	90                   	nop

00803ac8 <__umoddi3>:
  803ac8:	55                   	push   %ebp
  803ac9:	57                   	push   %edi
  803aca:	56                   	push   %esi
  803acb:	53                   	push   %ebx
  803acc:	83 ec 1c             	sub    $0x1c,%esp
  803acf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ad3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803adf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ae7:	89 f3                	mov    %esi,%ebx
  803ae9:	89 fa                	mov    %edi,%edx
  803aeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aef:	89 34 24             	mov    %esi,(%esp)
  803af2:	85 c0                	test   %eax,%eax
  803af4:	75 1a                	jne    803b10 <__umoddi3+0x48>
  803af6:	39 f7                	cmp    %esi,%edi
  803af8:	0f 86 a2 00 00 00    	jbe    803ba0 <__umoddi3+0xd8>
  803afe:	89 c8                	mov    %ecx,%eax
  803b00:	89 f2                	mov    %esi,%edx
  803b02:	f7 f7                	div    %edi
  803b04:	89 d0                	mov    %edx,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	39 f0                	cmp    %esi,%eax
  803b12:	0f 87 ac 00 00 00    	ja     803bc4 <__umoddi3+0xfc>
  803b18:	0f bd e8             	bsr    %eax,%ebp
  803b1b:	83 f5 1f             	xor    $0x1f,%ebp
  803b1e:	0f 84 ac 00 00 00    	je     803bd0 <__umoddi3+0x108>
  803b24:	bf 20 00 00 00       	mov    $0x20,%edi
  803b29:	29 ef                	sub    %ebp,%edi
  803b2b:	89 fe                	mov    %edi,%esi
  803b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b31:	89 e9                	mov    %ebp,%ecx
  803b33:	d3 e0                	shl    %cl,%eax
  803b35:	89 d7                	mov    %edx,%edi
  803b37:	89 f1                	mov    %esi,%ecx
  803b39:	d3 ef                	shr    %cl,%edi
  803b3b:	09 c7                	or     %eax,%edi
  803b3d:	89 e9                	mov    %ebp,%ecx
  803b3f:	d3 e2                	shl    %cl,%edx
  803b41:	89 14 24             	mov    %edx,(%esp)
  803b44:	89 d8                	mov    %ebx,%eax
  803b46:	d3 e0                	shl    %cl,%eax
  803b48:	89 c2                	mov    %eax,%edx
  803b4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4e:	d3 e0                	shl    %cl,%eax
  803b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b54:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b58:	89 f1                	mov    %esi,%ecx
  803b5a:	d3 e8                	shr    %cl,%eax
  803b5c:	09 d0                	or     %edx,%eax
  803b5e:	d3 eb                	shr    %cl,%ebx
  803b60:	89 da                	mov    %ebx,%edx
  803b62:	f7 f7                	div    %edi
  803b64:	89 d3                	mov    %edx,%ebx
  803b66:	f7 24 24             	mull   (%esp)
  803b69:	89 c6                	mov    %eax,%esi
  803b6b:	89 d1                	mov    %edx,%ecx
  803b6d:	39 d3                	cmp    %edx,%ebx
  803b6f:	0f 82 87 00 00 00    	jb     803bfc <__umoddi3+0x134>
  803b75:	0f 84 91 00 00 00    	je     803c0c <__umoddi3+0x144>
  803b7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b7f:	29 f2                	sub    %esi,%edx
  803b81:	19 cb                	sbb    %ecx,%ebx
  803b83:	89 d8                	mov    %ebx,%eax
  803b85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b89:	d3 e0                	shl    %cl,%eax
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	d3 ea                	shr    %cl,%edx
  803b8f:	09 d0                	or     %edx,%eax
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 eb                	shr    %cl,%ebx
  803b95:	89 da                	mov    %ebx,%edx
  803b97:	83 c4 1c             	add    $0x1c,%esp
  803b9a:	5b                   	pop    %ebx
  803b9b:	5e                   	pop    %esi
  803b9c:	5f                   	pop    %edi
  803b9d:	5d                   	pop    %ebp
  803b9e:	c3                   	ret    
  803b9f:	90                   	nop
  803ba0:	89 fd                	mov    %edi,%ebp
  803ba2:	85 ff                	test   %edi,%edi
  803ba4:	75 0b                	jne    803bb1 <__umoddi3+0xe9>
  803ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bab:	31 d2                	xor    %edx,%edx
  803bad:	f7 f7                	div    %edi
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 f0                	mov    %esi,%eax
  803bb3:	31 d2                	xor    %edx,%edx
  803bb5:	f7 f5                	div    %ebp
  803bb7:	89 c8                	mov    %ecx,%eax
  803bb9:	f7 f5                	div    %ebp
  803bbb:	89 d0                	mov    %edx,%eax
  803bbd:	e9 44 ff ff ff       	jmp    803b06 <__umoddi3+0x3e>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	89 c8                	mov    %ecx,%eax
  803bc6:	89 f2                	mov    %esi,%edx
  803bc8:	83 c4 1c             	add    $0x1c,%esp
  803bcb:	5b                   	pop    %ebx
  803bcc:	5e                   	pop    %esi
  803bcd:	5f                   	pop    %edi
  803bce:	5d                   	pop    %ebp
  803bcf:	c3                   	ret    
  803bd0:	3b 04 24             	cmp    (%esp),%eax
  803bd3:	72 06                	jb     803bdb <__umoddi3+0x113>
  803bd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd9:	77 0f                	ja     803bea <__umoddi3+0x122>
  803bdb:	89 f2                	mov    %esi,%edx
  803bdd:	29 f9                	sub    %edi,%ecx
  803bdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803be3:	89 14 24             	mov    %edx,(%esp)
  803be6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bea:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bee:	8b 14 24             	mov    (%esp),%edx
  803bf1:	83 c4 1c             	add    $0x1c,%esp
  803bf4:	5b                   	pop    %ebx
  803bf5:	5e                   	pop    %esi
  803bf6:	5f                   	pop    %edi
  803bf7:	5d                   	pop    %ebp
  803bf8:	c3                   	ret    
  803bf9:	8d 76 00             	lea    0x0(%esi),%esi
  803bfc:	2b 04 24             	sub    (%esp),%eax
  803bff:	19 fa                	sbb    %edi,%edx
  803c01:	89 d1                	mov    %edx,%ecx
  803c03:	89 c6                	mov    %eax,%esi
  803c05:	e9 71 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c10:	72 ea                	jb     803bfc <__umoddi3+0x134>
  803c12:	89 d9                	mov    %ebx,%ecx
  803c14:	e9 62 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
