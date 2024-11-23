
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 a0 06 00 00       	call   8006d6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 54             	sub    $0x54,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 c0 40 80 00       	push   $0x8040c0
  800061:	6a 13                	push   $0x13
  800063:	68 dc 40 80 00       	push   $0x8040dc
  800068:	e8 a8 07 00 00       	call   800815 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 f4 40 80 00       	push   $0x8040f4
  80008a:	e8 43 0a 00 00       	call   800ad2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 28 41 80 00       	push   $0x804128
  80009a:	e8 33 0a 00 00       	call   800ad2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 84 41 80 00       	push   $0x804184
  8000aa:	e8 23 0a 00 00       	call   800ad2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 99 1f 00 00       	call   80205e <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 b8 41 80 00       	push   $0x8041b8
  8000d0:	e8 fd 09 00 00       	call   800ad2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 d1 1d 00 00       	call   801eae <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 ec 41 80 00       	push   $0x8041ec
  8000ef:	e8 ab 1a 00 00       	call   801b9f <smalloc>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800100:	74 17                	je     800119 <_main+0xe1>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 f0 41 80 00       	push   $0x8041f0
  800111:	e8 bc 09 00 00       	call   800ad2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 86 1d 00 00       	call   801eae <sys_calculate_free_frames>
  800128:	29 c3                	sub    %eax,%ebx
  80012a:	89 d8                	mov    %ebx,%eax
  80012c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80012f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800132:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800135:	7c 0b                	jl     800142 <_main+0x10a>
  800137:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80013a:	83 c0 02             	add    $0x2,%eax
  80013d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800140:	7d 27                	jge    800169 <_main+0x131>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800142:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800149:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80014c:	e8 5d 1d 00 00       	call   801eae <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 5c 42 80 00       	push   $0x80425c
  800161:	e8 6c 09 00 00       	call   800ad2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
		cprintf("50\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 f4 42 80 00       	push   $0x8042f4
  800171:	e8 5c 09 00 00       	call   800ad2 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
		sfree(x);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 58 1b 00 00       	call   801cdc <sfree>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("52\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 f8 42 80 00       	push   $0x8042f8
  80018f:	e8 3e 09 00 00       	call   800ad2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800197:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80019e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a1:	e8 08 1d 00 00       	call   801eae <sys_calculate_free_frames>
  8001a6:	29 c3                	sub    %eax,%ebx
  8001a8:	89 d8                	mov    %ebx,%eax
  8001aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff !=  expected)
  8001ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001b3:	74 27                	je     8001dc <_main+0x1a4>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8001b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001bc:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001bf:	e8 ea 1c 00 00       	call   801eae <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001cf:	68 fc 42 80 00       	push   $0x8042fc
  8001d4:	e8 f9 08 00 00       	call   800ad2 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 47 43 80 00       	push   $0x804347
  8001e4:	e8 e9 08 00 00       	call   800ad2 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8001ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001f0:	74 04                	je     8001f6 <_main+0x1be>
  8001f2:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8001f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 60 43 80 00       	push   $0x804360
  800205:	e8 c8 08 00 00       	call   800ad2 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  80020d:	e8 9c 1c 00 00       	call   801eae <sys_calculate_free_frames>
  800212:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	6a 01                	push   $0x1
  80021a:	68 00 10 00 00       	push   $0x1000
  80021f:	68 95 43 80 00       	push   $0x804395
  800224:	e8 76 19 00 00       	call   801b9f <smalloc>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	6a 01                	push   $0x1
  800234:	68 00 10 00 00       	push   $0x1000
  800239:	68 ec 41 80 00       	push   $0x8041ec
  80023e:	e8 5c 19 00 00       	call   801b9f <smalloc>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800249:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80024d:	75 17                	jne    800266 <_main+0x22e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 98 43 80 00       	push   $0x804398
  80025e:	e8 6f 08 00 00       	call   800ad2 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800266:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80026d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800270:	e8 39 1c 00 00       	call   801eae <sys_calculate_free_frames>
  800275:	29 c3                	sub    %eax,%ebx
  800277:	89 d8                	mov    %ebx,%eax
  800279:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80027c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800282:	7c 0b                	jl     80028f <_main+0x257>
  800284:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800287:	83 c0 02             	add    $0x2,%eax
  80028a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80028d:	7d 17                	jge    8002a6 <_main+0x26e>
			{is_correct = 0; cprintf("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 f0 43 80 00       	push   $0x8043f0
  80029e:	e8 2f 08 00 00       	call   800ad2 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ac:	e8 2b 1a 00 00       	call   801cdc <sfree>
  8002b1:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8002b4:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002be:	e8 eb 1b 00 00       	call   801eae <sys_calculate_free_frames>
  8002c3:	29 c3                	sub    %eax,%ebx
  8002c5:	89 d8                	mov    %ebx,%eax
  8002c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff !=  expected)
  8002ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002cd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002d0:	74 27                	je     8002f9 <_main+0x2c1>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002d9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002dc:	e8 cd 1b 00 00       	call   801eae <sys_calculate_free_frames>
  8002e1:	29 c3                	sub    %eax,%ebx
  8002e3:	89 d8                	mov    %ebx,%eax
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ec:	68 fc 42 80 00       	push   $0x8042fc
  8002f1:	e8 dc 07 00 00       	call   800ad2 <cprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ff:	e8 d8 19 00 00       	call   801cdc <sfree>
  800304:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  800307:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80030e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800311:	e8 98 1b 00 00       	call   801eae <sys_calculate_free_frames>
  800316:	29 c3                	sub    %eax,%ebx
  800318:	89 d8                	mov    %ebx,%eax
  80031a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff !=  expected)
  80031d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800320:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800323:	74 27                	je     80034c <_main+0x314>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800325:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80032f:	e8 7a 1b 00 00       	call   801eae <sys_calculate_free_frames>
  800334:	29 c3                	sub    %eax,%ebx
  800336:	89 d8                	mov    %ebx,%eax
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	50                   	push   %eax
  80033c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033f:	68 fc 42 80 00       	push   $0x8042fc
  800344:	e8 89 07 00 00       	call   800ad2 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 45 44 80 00       	push   $0x804445
  800354:	e8 79 07 00 00       	call   800ad2 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  80035c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800360:	74 04                	je     800366 <_main+0x32e>
  800362:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800366:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 5c 44 80 00       	push   $0x80445c
  800375:	e8 58 07 00 00       	call   800ad2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80037d:	e8 2c 1b 00 00       	call   801eae <sys_calculate_free_frames>
  800382:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	6a 01                	push   $0x1
  80038a:	68 01 30 00 00       	push   $0x3001
  80038f:	68 91 44 80 00       	push   $0x804491
  800394:	e8 06 18 00 00       	call   801b9f <smalloc>
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	6a 01                	push   $0x1
  8003a4:	68 00 10 00 00       	push   $0x1000
  8003a9:	68 93 44 80 00       	push   $0x804493
  8003ae:	e8 ec 17 00 00       	call   801b9f <smalloc>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  8003b9:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003c0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003c3:	e8 e6 1a 00 00       	call   801eae <sys_calculate_free_frames>
  8003c8:	29 c3                	sub    %eax,%ebx
  8003ca:	89 d8                	mov    %ebx,%eax
  8003cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  8003cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8003d5:	7c 0b                	jl     8003e2 <_main+0x3aa>
  8003d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003da:	83 c0 02             	add    $0x2,%eax
  8003dd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8003e0:	7d 27                	jge    800409 <_main+0x3d1>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8003e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e9:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003ec:	e8 bd 1a 00 00       	call   801eae <sys_calculate_free_frames>
  8003f1:	29 c3                	sub    %eax,%ebx
  8003f3:	89 d8                	mov    %ebx,%eax
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003fb:	50                   	push   %eax
  8003fc:	68 5c 42 80 00       	push   $0x80425c
  800401:	e8 cc 06 00 00       	call   800ad2 <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	ff 75 bc             	pushl  -0x44(%ebp)
  80040f:	e8 c8 18 00 00       	call   801cdc <sfree>
  800414:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800417:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80041e:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800421:	e8 88 1a 00 00       	call   801eae <sys_calculate_free_frames>
  800426:	29 c3                	sub    %eax,%ebx
  800428:	89 d8                	mov    %ebx,%eax
  80042a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80042d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800430:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800433:	74 27                	je     80045c <_main+0x424>
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80043f:	e8 6a 1a 00 00       	call   801eae <sys_calculate_free_frames>
  800444:	29 c3                	sub    %eax,%ebx
  800446:	89 d8                	mov    %ebx,%eax
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80044f:	68 fc 42 80 00       	push   $0x8042fc
  800454:	e8 79 06 00 00       	call   800ad2 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	6a 01                	push   $0x1
  800461:	68 ff 1f 00 00       	push   $0x1fff
  800466:	68 95 44 80 00       	push   $0x804495
  80046b:	e8 2f 17 00 00       	call   801b9f <smalloc>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800476:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80047d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800480:	e8 29 1a 00 00       	call   801eae <sys_calculate_free_frames>
  800485:	29 c3                	sub    %eax,%ebx
  800487:	89 d8                	mov    %ebx,%eax
  800489:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  80048c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80048f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800492:	74 27                	je     8004bb <_main+0x483>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800494:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80049e:	e8 0b 1a 00 00       	call   801eae <sys_calculate_free_frames>
  8004a3:	29 c3                	sub    %eax,%ebx
  8004a5:	89 d8                	mov    %ebx,%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 5c 42 80 00       	push   $0x80425c
  8004b3:	e8 1a 06 00 00       	call   800ad2 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004c1:	e8 16 18 00 00       	call   801cdc <sfree>
  8004c6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004c9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004d0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d3:	e8 d6 19 00 00       	call   801eae <sys_calculate_free_frames>
  8004d8:	29 c3                	sub    %eax,%ebx
  8004da:	89 d8                	mov    %ebx,%eax
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004e5:	74 27                	je     80050e <_main+0x4d6>
  8004e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ee:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004f1:	e8 b8 19 00 00       	call   801eae <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 d4             	pushl  -0x2c(%ebp)
  800501:	68 fc 42 80 00       	push   $0x8042fc
  800506:	e8 c7 05 00 00       	call   800ad2 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	ff 75 b8             	pushl  -0x48(%ebp)
  800514:	e8 c3 17 00 00       	call   801cdc <sfree>
  800519:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  80051c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800523:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800526:	e8 83 19 00 00       	call   801eae <sys_calculate_free_frames>
  80052b:	29 c3                	sub    %eax,%ebx
  80052d:	89 d8                	mov    %ebx,%eax
  80052f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800538:	74 27                	je     800561 <_main+0x529>
  80053a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800541:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800544:	e8 65 19 00 00       	call   801eae <sys_calculate_free_frames>
  800549:	29 c3                	sub    %eax,%ebx
  80054b:	89 d8                	mov    %ebx,%eax
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	50                   	push   %eax
  800551:	ff 75 d4             	pushl  -0x2c(%ebp)
  800554:	68 fc 42 80 00       	push   $0x8042fc
  800559:	e8 74 05 00 00       	call   800ad2 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800561:	e8 48 19 00 00       	call   801eae <sys_calculate_free_frames>
  800566:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80056c:	89 c2                	mov    %eax,%edx
  80056e:	01 d2                	add    %edx,%edx
  800570:	01 d0                	add    %edx,%eax
  800572:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800575:	83 ec 04             	sub    $0x4,%esp
  800578:	6a 01                	push   $0x1
  80057a:	50                   	push   %eax
  80057b:	68 91 44 80 00       	push   $0x804491
  800580:	e8 1a 16 00 00       	call   801b9f <smalloc>
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80058b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	01 c0                	add    %eax,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80059b:	83 ec 04             	sub    $0x4,%esp
  80059e:	6a 01                	push   $0x1
  8005a0:	50                   	push   %eax
  8005a1:	68 93 44 80 00       	push   $0x804493
  8005a6:	e8 f4 15 00 00       	call   801b9f <smalloc>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  8005b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b4:	01 c0                	add    %eax,%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	6a 01                	push   $0x1
  8005c2:	50                   	push   %eax
  8005c3:	68 95 44 80 00       	push   $0x804495
  8005c8:	e8 d2 15 00 00       	call   801b9f <smalloc>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005d3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005da:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005dd:	e8 cc 18 00 00       	call   801eae <sys_calculate_free_frames>
  8005e2:	29 c3                	sub    %eax,%ebx
  8005e4:	89 d8                	mov    %ebx,%eax
  8005e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  8005e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ec:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005ef:	7c 0b                	jl     8005fc <_main+0x5c4>
  8005f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f4:	83 c0 02             	add    $0x2,%eax
  8005f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8005fa:	7d 27                	jge    800623 <_main+0x5eb>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8005fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800603:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800606:	e8 a3 18 00 00       	call   801eae <sys_calculate_free_frames>
  80060b:	29 c3                	sub    %eax,%ebx
  80060d:	89 d8                	mov    %ebx,%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 d4             	pushl  -0x2c(%ebp)
  800615:	50                   	push   %eax
  800616:	68 5c 42 80 00       	push   $0x80425c
  80061b:	e8 b2 04 00 00       	call   800ad2 <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800623:	e8 86 18 00 00       	call   801eae <sys_calculate_free_frames>
  800628:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800631:	e8 a6 16 00 00       	call   801cdc <sfree>
  800636:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	ff 75 bc             	pushl  -0x44(%ebp)
  80063f:	e8 98 16 00 00       	call   801cdc <sfree>
  800644:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	ff 75 b8             	pushl  -0x48(%ebp)
  80064d:	e8 8a 16 00 00       	call   801cdc <sfree>
  800652:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800655:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80065c:	e8 4d 18 00 00       	call   801eae <sys_calculate_free_frames>
  800661:	89 c2                	mov    %eax,%edx
  800663:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800666:	29 c2                	sub    %eax,%edx
  800668:	89 d0                	mov    %edx,%eax
  80066a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80066d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800670:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800673:	74 27                	je     80069c <_main+0x664>
  800675:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80067c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80067f:	e8 2a 18 00 00       	call   801eae <sys_calculate_free_frames>
  800684:	29 c3                	sub    %eax,%ebx
  800686:	89 d8                	mov    %ebx,%eax
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80068f:	68 fc 42 80 00       	push   $0x8042fc
  800694:	e8 39 04 00 00       	call   800ad2 <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	68 97 44 80 00       	push   $0x804497
  8006a4:	e8 29 04 00 00       	call   800ad2 <cprintf>
  8006a9:	83 c4 10             	add    $0x10,%esp
	if (is_correct)	eval+=50;
  8006ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006b0:	74 04                	je     8006b6 <_main+0x67e>
  8006b2:	83 45 f4 32          	addl   $0x32,-0xc(%ebp)
	is_correct = 1;
  8006b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of freeSharedObjects [4] completed. Eval = %d%%\n\n", eval);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c3:	68 b0 44 80 00       	push   $0x8044b0
  8006c8:	e8 05 04 00 00       	call   800ad2 <cprintf>
  8006cd:	83 c4 10             	add    $0x10,%esp

	return;
  8006d0:	90                   	nop
}
  8006d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d4:	c9                   	leave  
  8006d5:	c3                   	ret    

008006d6 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006dc:	e8 96 19 00 00       	call   802077 <sys_getenvindex>
  8006e1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8006e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e7:	89 d0                	mov    %edx,%eax
  8006e9:	c1 e0 03             	shl    $0x3,%eax
  8006ec:	01 d0                	add    %edx,%eax
  8006ee:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006f5:	01 c8                	add    %ecx,%eax
  8006f7:	01 c0                	add    %eax,%eax
  8006f9:	01 d0                	add    %edx,%eax
  8006fb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800702:	01 c8                	add    %ecx,%eax
  800704:	01 d0                	add    %edx,%eax
  800706:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80070b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800710:	a1 20 50 80 00       	mov    0x805020,%eax
  800715:	8a 40 20             	mov    0x20(%eax),%al
  800718:	84 c0                	test   %al,%al
  80071a:	74 0d                	je     800729 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80071c:	a1 20 50 80 00       	mov    0x805020,%eax
  800721:	83 c0 20             	add    $0x20,%eax
  800724:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800729:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80072d:	7e 0a                	jle    800739 <libmain+0x63>
		binaryname = argv[0];
  80072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	e8 f1 f8 ff ff       	call   800038 <_main>
  800747:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80074a:	e8 ac 16 00 00       	call   801dfb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	68 04 45 80 00       	push   $0x804504
  800757:	e8 76 03 00 00       	call   800ad2 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80076a:	a1 20 50 80 00       	mov    0x805020,%eax
  80076f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	52                   	push   %edx
  800779:	50                   	push   %eax
  80077a:	68 2c 45 80 00       	push   $0x80452c
  80077f:	e8 4e 03 00 00       	call   800ad2 <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800787:	a1 20 50 80 00       	mov    0x805020,%eax
  80078c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800792:	a1 20 50 80 00       	mov    0x805020,%eax
  800797:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80079d:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a2:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8007a8:	51                   	push   %ecx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	68 54 45 80 00       	push   $0x804554
  8007b0:	e8 1d 03 00 00       	call   800ad2 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	50                   	push   %eax
  8007c7:	68 ac 45 80 00       	push   $0x8045ac
  8007cc:	e8 01 03 00 00       	call   800ad2 <cprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	68 04 45 80 00       	push   $0x804504
  8007dc:	e8 f1 02 00 00       	call   800ad2 <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007e4:	e8 2c 16 00 00       	call   801e15 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8007e9:	e8 19 00 00 00       	call   800807 <exit>
}
  8007ee:	90                   	nop
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	6a 00                	push   $0x0
  8007fc:	e8 42 18 00 00       	call   802043 <sys_destroy_env>
  800801:	83 c4 10             	add    $0x10,%esp
}
  800804:	90                   	nop
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <exit>:

void
exit(void)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80080d:	e8 97 18 00 00       	call   8020a9 <sys_exit_env>
}
  800812:	90                   	nop
  800813:	c9                   	leave  
  800814:	c3                   	ret    

00800815 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80081b:	8d 45 10             	lea    0x10(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800824:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800829:	85 c0                	test   %eax,%eax
  80082b:	74 16                	je     800843 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80082d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	50                   	push   %eax
  800836:	68 c0 45 80 00       	push   $0x8045c0
  80083b:	e8 92 02 00 00       	call   800ad2 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800843:	a1 00 50 80 00       	mov    0x805000,%eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	50                   	push   %eax
  80084f:	68 c5 45 80 00       	push   $0x8045c5
  800854:	e8 79 02 00 00       	call   800ad2 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80085c:	8b 45 10             	mov    0x10(%ebp),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 f4             	pushl  -0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	e8 fc 01 00 00       	call   800a67 <vcprintf>
  80086b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	6a 00                	push   $0x0
  800873:	68 e1 45 80 00       	push   $0x8045e1
  800878:	e8 ea 01 00 00       	call   800a67 <vcprintf>
  80087d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800880:	e8 82 ff ff ff       	call   800807 <exit>

	// should not return here
	while (1) ;
  800885:	eb fe                	jmp    800885 <_panic+0x70>

00800887 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80088d:	a1 20 50 80 00       	mov    0x805020,%eax
  800892:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089b:	39 c2                	cmp    %eax,%edx
  80089d:	74 14                	je     8008b3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80089f:	83 ec 04             	sub    $0x4,%esp
  8008a2:	68 e4 45 80 00       	push   $0x8045e4
  8008a7:	6a 26                	push   $0x26
  8008a9:	68 30 46 80 00       	push   $0x804630
  8008ae:	e8 62 ff ff ff       	call   800815 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008c1:	e9 c5 00 00 00       	jmp    80098b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	01 d0                	add    %edx,%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	85 c0                	test   %eax,%eax
  8008d9:	75 08                	jne    8008e3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008db:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008de:	e9 a5 00 00 00       	jmp    800988 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008f1:	eb 69                	jmp    80095c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8008f8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	c1 e0 03             	shl    $0x3,%eax
  80090a:	01 c8                	add    %ecx,%eax
  80090c:	8a 40 04             	mov    0x4(%eax),%al
  80090f:	84 c0                	test   %al,%al
  800911:	75 46                	jne    800959 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800913:	a1 20 50 80 00       	mov    0x805020,%eax
  800918:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80091e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800921:	89 d0                	mov    %edx,%eax
  800923:	01 c0                	add    %eax,%eax
  800925:	01 d0                	add    %edx,%eax
  800927:	c1 e0 03             	shl    $0x3,%eax
  80092a:	01 c8                	add    %ecx,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800931:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800939:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80093b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	01 c8                	add    %ecx,%eax
  80094a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80094c:	39 c2                	cmp    %eax,%edx
  80094e:	75 09                	jne    800959 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800950:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800957:	eb 15                	jmp    80096e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800959:	ff 45 e8             	incl   -0x18(%ebp)
  80095c:	a1 20 50 80 00       	mov    0x805020,%eax
  800961:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80096a:	39 c2                	cmp    %eax,%edx
  80096c:	77 85                	ja     8008f3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80096e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800972:	75 14                	jne    800988 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800974:	83 ec 04             	sub    $0x4,%esp
  800977:	68 3c 46 80 00       	push   $0x80463c
  80097c:	6a 3a                	push   $0x3a
  80097e:	68 30 46 80 00       	push   $0x804630
  800983:	e8 8d fe ff ff       	call   800815 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800988:	ff 45 f0             	incl   -0x10(%ebp)
  80098b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800991:	0f 8c 2f ff ff ff    	jl     8008c6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800997:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80099e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009a5:	eb 26                	jmp    8009cd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8009ac:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8009b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	c1 e0 03             	shl    $0x3,%eax
  8009be:	01 c8                	add    %ecx,%eax
  8009c0:	8a 40 04             	mov    0x4(%eax),%al
  8009c3:	3c 01                	cmp    $0x1,%al
  8009c5:	75 03                	jne    8009ca <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009c7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ca:	ff 45 e0             	incl   -0x20(%ebp)
  8009cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8009d2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009db:	39 c2                	cmp    %eax,%edx
  8009dd:	77 c8                	ja     8009a7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009e5:	74 14                	je     8009fb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	68 90 46 80 00       	push   $0x804690
  8009ef:	6a 44                	push   $0x44
  8009f1:	68 30 46 80 00       	push   $0x804630
  8009f6:	e8 1a fe ff ff       	call   800815 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009fb:	90                   	nop
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	8d 48 01             	lea    0x1(%eax),%ecx
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0f:	89 0a                	mov    %ecx,(%edx)
  800a11:	8b 55 08             	mov    0x8(%ebp),%edx
  800a14:	88 d1                	mov    %dl,%cl
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a27:	75 2c                	jne    800a55 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a29:	a0 28 50 80 00       	mov    0x805028,%al
  800a2e:	0f b6 c0             	movzbl %al,%eax
  800a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a34:	8b 12                	mov    (%edx),%edx
  800a36:	89 d1                	mov    %edx,%ecx
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	83 c2 08             	add    $0x8,%edx
  800a3e:	83 ec 04             	sub    $0x4,%esp
  800a41:	50                   	push   %eax
  800a42:	51                   	push   %ecx
  800a43:	52                   	push   %edx
  800a44:	e8 70 13 00 00       	call   801db9 <sys_cputs>
  800a49:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8b 40 04             	mov    0x4(%eax),%eax
  800a5b:	8d 50 01             	lea    0x1(%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a64:	90                   	nop
  800a65:	c9                   	leave  
  800a66:	c3                   	ret    

00800a67 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a70:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a77:	00 00 00 
	b.cnt = 0;
  800a7a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a81:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	ff 75 08             	pushl  0x8(%ebp)
  800a8a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	68 fe 09 80 00       	push   $0x8009fe
  800a96:	e8 11 02 00 00       	call   800cac <vprintfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a9e:	a0 28 50 80 00       	mov    0x805028,%al
  800aa3:	0f b6 c0             	movzbl %al,%eax
  800aa6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	50                   	push   %eax
  800ab0:	52                   	push   %edx
  800ab1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab7:	83 c0 08             	add    $0x8,%eax
  800aba:	50                   	push   %eax
  800abb:	e8 f9 12 00 00       	call   801db9 <sys_cputs>
  800ac0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ac3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800aca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ad8:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800adf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	e8 73 ff ff ff       	call   800a67 <vcprintf>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b05:	e8 f1 12 00 00       	call   801dfb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	ff 75 f4             	pushl  -0xc(%ebp)
  800b19:	50                   	push   %eax
  800b1a:	e8 48 ff ff ff       	call   800a67 <vcprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b25:	e8 eb 12 00 00       	call   801e15 <sys_unlock_cons>
	return cnt;
  800b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	53                   	push   %ebx
  800b33:	83 ec 14             	sub    $0x14,%esp
  800b36:	8b 45 10             	mov    0x10(%ebp),%eax
  800b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b42:	8b 45 18             	mov    0x18(%ebp),%eax
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4d:	77 55                	ja     800ba4 <printnum+0x75>
  800b4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b52:	72 05                	jb     800b59 <printnum+0x2a>
  800b54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b57:	77 4b                	ja     800ba4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	52                   	push   %edx
  800b68:	50                   	push   %eax
  800b69:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6f:	e8 dc 32 00 00       	call   803e50 <__udivdi3>
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	83 ec 04             	sub    $0x4,%esp
  800b7a:	ff 75 20             	pushl  0x20(%ebp)
  800b7d:	53                   	push   %ebx
  800b7e:	ff 75 18             	pushl  0x18(%ebp)
  800b81:	52                   	push   %edx
  800b82:	50                   	push   %eax
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 a1 ff ff ff       	call   800b2f <printnum>
  800b8e:	83 c4 20             	add    $0x20,%esp
  800b91:	eb 1a                	jmp    800bad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 20             	pushl  0x20(%ebp)
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba4:	ff 4d 1c             	decl   0x1c(%ebp)
  800ba7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bab:	7f e6                	jg     800b93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbb:	53                   	push   %ebx
  800bbc:	51                   	push   %ecx
  800bbd:	52                   	push   %edx
  800bbe:	50                   	push   %eax
  800bbf:	e8 9c 33 00 00       	call   803f60 <__umoddi3>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	05 f4 48 80 00       	add    $0x8048f4,%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f be c0             	movsbl %al,%eax
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	50                   	push   %eax
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
}
  800be0:	90                   	nop
  800be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bed:	7e 1c                	jle    800c0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	8d 50 08             	lea    0x8(%eax),%edx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 10                	mov    %edx,(%eax)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	83 e8 08             	sub    $0x8,%eax
  800c04:	8b 50 04             	mov    0x4(%eax),%edx
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	eb 40                	jmp    800c4b <getuint+0x65>
	else if (lflag)
  800c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0f:	74 1e                	je     800c2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 00                	mov    (%eax),%eax
  800c16:	8d 50 04             	lea    0x4(%eax),%edx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 10                	mov    %edx,(%eax)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	83 e8 04             	sub    $0x4,%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	eb 1c                	jmp    800c4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 50 04             	lea    0x4(%eax),%edx
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	89 10                	mov    %edx,(%eax)
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	83 e8 04             	sub    $0x4,%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c54:	7e 1c                	jle    800c72 <getint+0x25>
		return va_arg(*ap, long long);
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	8d 50 08             	lea    0x8(%eax),%edx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	89 10                	mov    %edx,(%eax)
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8b 00                	mov    (%eax),%eax
  800c68:	83 e8 08             	sub    $0x8,%eax
  800c6b:	8b 50 04             	mov    0x4(%eax),%edx
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	eb 38                	jmp    800caa <getint+0x5d>
	else if (lflag)
  800c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c76:	74 1a                	je     800c92 <getint+0x45>
		return va_arg(*ap, long);
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8b 00                	mov    (%eax),%eax
  800c7d:	8d 50 04             	lea    0x4(%eax),%edx
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 10                	mov    %edx,(%eax)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	99                   	cltd   
  800c90:	eb 18                	jmp    800caa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	8d 50 04             	lea    0x4(%eax),%edx
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	89 10                	mov    %edx,(%eax)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8b 00                	mov    (%eax),%eax
  800ca4:	83 e8 04             	sub    $0x4,%eax
  800ca7:	8b 00                	mov    (%eax),%eax
  800ca9:	99                   	cltd   
}
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb4:	eb 17                	jmp    800ccd <vprintfmt+0x21>
			if (ch == '\0')
  800cb6:	85 db                	test   %ebx,%ebx
  800cb8:	0f 84 c1 03 00 00    	je     80107f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	53                   	push   %ebx
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	ff d0                	call   *%eax
  800cca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd0:	8d 50 01             	lea    0x1(%eax),%edx
  800cd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	0f b6 d8             	movzbl %al,%ebx
  800cdb:	83 fb 25             	cmp    $0x25,%ebx
  800cde:	75 d6                	jne    800cb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ceb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 10             	mov    %edx,0x10(%ebp)
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 d8             	movzbl %al,%ebx
  800d0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d11:	83 f8 5b             	cmp    $0x5b,%eax
  800d14:	0f 87 3d 03 00 00    	ja     801057 <vprintfmt+0x3ab>
  800d1a:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
  800d21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d27:	eb d7                	jmp    800d00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d2d:	eb d1                	jmp    800d00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d39:	89 d0                	mov    %edx,%eax
  800d3b:	c1 e0 02             	shl    $0x2,%eax
  800d3e:	01 d0                	add    %edx,%eax
  800d40:	01 c0                	add    %eax,%eax
  800d42:	01 d8                	add    %ebx,%eax
  800d44:	83 e8 30             	sub    $0x30,%eax
  800d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d52:	83 fb 2f             	cmp    $0x2f,%ebx
  800d55:	7e 3e                	jle    800d95 <vprintfmt+0xe9>
  800d57:	83 fb 39             	cmp    $0x39,%ebx
  800d5a:	7f 39                	jg     800d95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d5f:	eb d5                	jmp    800d36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 c0 04             	add    $0x4,%eax
  800d67:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d75:	eb 1f                	jmp    800d96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7b:	79 83                	jns    800d00 <vprintfmt+0x54>
				width = 0;
  800d7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d84:	e9 77 ff ff ff       	jmp    800d00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d90:	e9 6b ff ff ff       	jmp    800d00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9a:	0f 89 60 ff ff ff    	jns    800d00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dad:	e9 4e ff ff ff       	jmp    800d00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800db2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800db5:	e9 46 ff ff ff       	jmp    800d00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dba:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbd:	83 c0 04             	add    $0x4,%eax
  800dc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc6:	83 e8 04             	sub    $0x4,%eax
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	50                   	push   %eax
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	ff d0                	call   *%eax
  800dd7:	83 c4 10             	add    $0x10,%esp
			break;
  800dda:	e9 9b 02 00 00       	jmp    80107a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 c0 04             	add    $0x4,%eax
  800de5:	89 45 14             	mov    %eax,0x14(%ebp)
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	83 e8 04             	sub    $0x4,%eax
  800dee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df0:	85 db                	test   %ebx,%ebx
  800df2:	79 02                	jns    800df6 <vprintfmt+0x14a>
				err = -err;
  800df4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800df6:	83 fb 64             	cmp    $0x64,%ebx
  800df9:	7f 0b                	jg     800e06 <vprintfmt+0x15a>
  800dfb:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  800e02:	85 f6                	test   %esi,%esi
  800e04:	75 19                	jne    800e1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e06:	53                   	push   %ebx
  800e07:	68 05 49 80 00       	push   $0x804905
  800e0c:	ff 75 0c             	pushl  0xc(%ebp)
  800e0f:	ff 75 08             	pushl  0x8(%ebp)
  800e12:	e8 70 02 00 00       	call   801087 <printfmt>
  800e17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e1a:	e9 5b 02 00 00       	jmp    80107a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e1f:	56                   	push   %esi
  800e20:	68 0e 49 80 00       	push   $0x80490e
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	ff 75 08             	pushl  0x8(%ebp)
  800e2b:	e8 57 02 00 00       	call   801087 <printfmt>
  800e30:	83 c4 10             	add    $0x10,%esp
			break;
  800e33:	e9 42 02 00 00       	jmp    80107a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e38:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3b:	83 c0 04             	add    $0x4,%eax
  800e3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 e8 04             	sub    $0x4,%eax
  800e47:	8b 30                	mov    (%eax),%esi
  800e49:	85 f6                	test   %esi,%esi
  800e4b:	75 05                	jne    800e52 <vprintfmt+0x1a6>
				p = "(null)";
  800e4d:	be 11 49 80 00       	mov    $0x804911,%esi
			if (width > 0 && padc != '-')
  800e52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e56:	7e 6d                	jle    800ec5 <vprintfmt+0x219>
  800e58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e5c:	74 67                	je     800ec5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	50                   	push   %eax
  800e65:	56                   	push   %esi
  800e66:	e8 1e 03 00 00       	call   801189 <strnlen>
  800e6b:	83 c4 10             	add    $0x10,%esp
  800e6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e71:	eb 16                	jmp    800e89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	50                   	push   %eax
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	ff d0                	call   *%eax
  800e83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e86:	ff 4d e4             	decl   -0x1c(%ebp)
  800e89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8d:	7f e4                	jg     800e73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8f:	eb 34                	jmp    800ec5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e95:	74 1c                	je     800eb3 <vprintfmt+0x207>
  800e97:	83 fb 1f             	cmp    $0x1f,%ebx
  800e9a:	7e 05                	jle    800ea1 <vprintfmt+0x1f5>
  800e9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800e9f:	7e 12                	jle    800eb3 <vprintfmt+0x207>
					putch('?', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 3f                	push   $0x3f
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
  800eb1:	eb 0f                	jmp    800ec2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	53                   	push   %ebx
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec5:	89 f0                	mov    %esi,%eax
  800ec7:	8d 70 01             	lea    0x1(%eax),%esi
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	0f be d8             	movsbl %al,%ebx
  800ecf:	85 db                	test   %ebx,%ebx
  800ed1:	74 24                	je     800ef7 <vprintfmt+0x24b>
  800ed3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed7:	78 b8                	js     800e91 <vprintfmt+0x1e5>
  800ed9:	ff 4d e0             	decl   -0x20(%ebp)
  800edc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee0:	79 af                	jns    800e91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee2:	eb 13                	jmp    800ef7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	6a 20                	push   $0x20
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800efb:	7f e7                	jg     800ee4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800efd:	e9 78 01 00 00       	jmp    80107a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	ff 75 e8             	pushl  -0x18(%ebp)
  800f08:	8d 45 14             	lea    0x14(%ebp),%eax
  800f0b:	50                   	push   %eax
  800f0c:	e8 3c fd ff ff       	call   800c4d <getint>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f20:	85 d2                	test   %edx,%edx
  800f22:	79 23                	jns    800f47 <vprintfmt+0x29b>
				putch('-', putdat);
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	6a 2d                	push   $0x2d
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	ff d0                	call   *%eax
  800f31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3a:	f7 d8                	neg    %eax
  800f3c:	83 d2 00             	adc    $0x0,%edx
  800f3f:	f7 da                	neg    %edx
  800f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f4e:	e9 bc 00 00 00       	jmp    80100f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	ff 75 e8             	pushl  -0x18(%ebp)
  800f59:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5c:	50                   	push   %eax
  800f5d:	e8 84 fc ff ff       	call   800be6 <getuint>
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f72:	e9 98 00 00 00       	jmp    80100f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 58                	push   $0x58
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	6a 58                	push   $0x58
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f97:	83 ec 08             	sub    $0x8,%esp
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	6a 58                	push   $0x58
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	ff d0                	call   *%eax
  800fa4:	83 c4 10             	add    $0x10,%esp
			break;
  800fa7:	e9 ce 00 00 00       	jmp    80107a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fac:	83 ec 08             	sub    $0x8,%esp
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	6a 30                	push   $0x30
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	ff d0                	call   *%eax
  800fb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fbc:	83 ec 08             	sub    $0x8,%esp
  800fbf:	ff 75 0c             	pushl  0xc(%ebp)
  800fc2:	6a 78                	push   $0x78
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	ff d0                	call   *%eax
  800fc9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 c0 04             	add    $0x4,%eax
  800fd2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd8:	83 e8 04             	sub    $0x4,%eax
  800fdb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fe7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fee:	eb 1f                	jmp    80100f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 e7 fb ff ff       	call   800be6 <getuint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801008:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801016:	83 ec 04             	sub    $0x4,%esp
  801019:	52                   	push   %edx
  80101a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101d:	50                   	push   %eax
  80101e:	ff 75 f4             	pushl  -0xc(%ebp)
  801021:	ff 75 f0             	pushl  -0x10(%ebp)
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	ff 75 08             	pushl  0x8(%ebp)
  80102a:	e8 00 fb ff ff       	call   800b2f <printnum>
  80102f:	83 c4 20             	add    $0x20,%esp
			break;
  801032:	eb 46                	jmp    80107a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801034:	83 ec 08             	sub    $0x8,%esp
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	53                   	push   %ebx
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	ff d0                	call   *%eax
  801040:	83 c4 10             	add    $0x10,%esp
			break;
  801043:	eb 35                	jmp    80107a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801045:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80104c:	eb 2c                	jmp    80107a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80104e:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  801055:	eb 23                	jmp    80107a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	ff 75 0c             	pushl  0xc(%ebp)
  80105d:	6a 25                	push   $0x25
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	ff d0                	call   *%eax
  801064:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801067:	ff 4d 10             	decl   0x10(%ebp)
  80106a:	eb 03                	jmp    80106f <vprintfmt+0x3c3>
  80106c:	ff 4d 10             	decl   0x10(%ebp)
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	48                   	dec    %eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 25                	cmp    $0x25,%al
  801077:	75 f3                	jne    80106c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801079:	90                   	nop
		}
	}
  80107a:	e9 35 fc ff ff       	jmp    800cb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80107f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80108d:	8d 45 10             	lea    0x10(%ebp),%eax
  801090:	83 c0 04             	add    $0x4,%eax
  801093:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	ff 75 f4             	pushl  -0xc(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	ff 75 08             	pushl  0x8(%ebp)
  8010a3:	e8 04 fc ff ff       	call   800cac <vprintfmt>
  8010a8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010ab:	90                   	nop
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	8b 40 08             	mov    0x8(%eax),%eax
  8010b7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	8b 10                	mov    (%eax),%edx
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 40 04             	mov    0x4(%eax),%eax
  8010cb:	39 c2                	cmp    %eax,%edx
  8010cd:	73 12                	jae    8010e1 <sprintputch+0x33>
		*b->buf++ = ch;
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	8b 00                	mov    (%eax),%eax
  8010d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010da:	89 0a                	mov    %ecx,(%edx)
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	88 10                	mov    %dl,(%eax)
}
  8010e1:	90                   	nop
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	01 d0                	add    %edx,%eax
  8010fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	74 06                	je     801111 <vsnprintf+0x2d>
  80110b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110f:	7f 07                	jg     801118 <vsnprintf+0x34>
		return -E_INVAL;
  801111:	b8 03 00 00 00       	mov    $0x3,%eax
  801116:	eb 20                	jmp    801138 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801118:	ff 75 14             	pushl  0x14(%ebp)
  80111b:	ff 75 10             	pushl  0x10(%ebp)
  80111e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801121:	50                   	push   %eax
  801122:	68 ae 10 80 00       	push   $0x8010ae
  801127:	e8 80 fb ff ff       	call   800cac <vprintfmt>
  80112c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80112f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801132:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801140:	8d 45 10             	lea    0x10(%ebp),%eax
  801143:	83 c0 04             	add    $0x4,%eax
  801146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	ff 75 f4             	pushl  -0xc(%ebp)
  80114f:	50                   	push   %eax
  801150:	ff 75 0c             	pushl  0xc(%ebp)
  801153:	ff 75 08             	pushl  0x8(%ebp)
  801156:	e8 89 ff ff ff       	call   8010e4 <vsnprintf>
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801161:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801173:	eb 06                	jmp    80117b <strlen+0x15>
		n++;
  801175:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801178:	ff 45 08             	incl   0x8(%ebp)
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	84 c0                	test   %al,%al
  801182:	75 f1                	jne    801175 <strlen+0xf>
		n++;
	return n;
  801184:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801196:	eb 09                	jmp    8011a1 <strnlen+0x18>
		n++;
  801198:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80119b:	ff 45 08             	incl   0x8(%ebp)
  80119e:	ff 4d 0c             	decl   0xc(%ebp)
  8011a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a5:	74 09                	je     8011b0 <strnlen+0x27>
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	84 c0                	test   %al,%al
  8011ae:	75 e8                	jne    801198 <strnlen+0xf>
		n++;
	return n;
  8011b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011c1:	90                   	nop
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8d 50 01             	lea    0x1(%eax),%edx
  8011c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d4:	8a 12                	mov    (%edx),%dl
  8011d6:	88 10                	mov    %dl,(%eax)
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	84 c0                	test   %al,%al
  8011dc:	75 e4                	jne    8011c2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f6:	eb 1f                	jmp    801217 <strncpy+0x34>
		*dst++ = *src;
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	8a 12                	mov    (%edx),%dl
  801206:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 03                	je     801214 <strncpy+0x31>
			src++;
  801211:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801214:	ff 45 fc             	incl   -0x4(%ebp)
  801217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80121d:	72 d9                	jb     8011f8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801230:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801234:	74 30                	je     801266 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801236:	eb 16                	jmp    80124e <strlcpy+0x2a>
			*dst++ = *src++;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8d 50 01             	lea    0x1(%eax),%edx
  80123e:	89 55 08             	mov    %edx,0x8(%ebp)
  801241:	8b 55 0c             	mov    0xc(%ebp),%edx
  801244:	8d 4a 01             	lea    0x1(%edx),%ecx
  801247:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80124a:	8a 12                	mov    (%edx),%dl
  80124c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80124e:	ff 4d 10             	decl   0x10(%ebp)
  801251:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801255:	74 09                	je     801260 <strlcpy+0x3c>
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 d8                	jne    801238 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126c:	29 c2                	sub    %eax,%edx
  80126e:	89 d0                	mov    %edx,%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801275:	eb 06                	jmp    80127d <strcmp+0xb>
		p++, q++;
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	84 c0                	test   %al,%al
  801284:	74 0e                	je     801294 <strcmp+0x22>
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 10                	mov    (%eax),%dl
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	38 c2                	cmp    %al,%dl
  801292:	74 e3                	je     801277 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	0f b6 d0             	movzbl %al,%edx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	0f b6 c0             	movzbl %al,%eax
  8012a4:	29 c2                	sub    %eax,%edx
  8012a6:	89 d0                	mov    %edx,%eax
}
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012ad:	eb 09                	jmp    8012b8 <strncmp+0xe>
		n--, p++, q++;
  8012af:	ff 4d 10             	decl   0x10(%ebp)
  8012b2:	ff 45 08             	incl   0x8(%ebp)
  8012b5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bc:	74 17                	je     8012d5 <strncmp+0x2b>
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	84 c0                	test   %al,%al
  8012c5:	74 0e                	je     8012d5 <strncmp+0x2b>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 10                	mov    (%eax),%dl
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	38 c2                	cmp    %al,%dl
  8012d3:	74 da                	je     8012af <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d9:	75 07                	jne    8012e2 <strncmp+0x38>
		return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e0:	eb 14                	jmp    8012f6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f b6 d0             	movzbl %al,%edx
  8012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f b6 c0             	movzbl %al,%eax
  8012f2:	29 c2                	sub    %eax,%edx
  8012f4:	89 d0                	mov    %edx,%eax
}
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801304:	eb 12                	jmp    801318 <strchr+0x20>
		if (*s == c)
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80130e:	75 05                	jne    801315 <strchr+0x1d>
			return (char *) s;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	eb 11                	jmp    801326 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801315:	ff 45 08             	incl   0x8(%ebp)
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	84 c0                	test   %al,%al
  80131f:	75 e5                	jne    801306 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801321:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801334:	eb 0d                	jmp    801343 <strfind+0x1b>
		if (*s == c)
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80133e:	74 0e                	je     80134e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801340:	ff 45 08             	incl   0x8(%ebp)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	84 c0                	test   %al,%al
  80134a:	75 ea                	jne    801336 <strfind+0xe>
  80134c:	eb 01                	jmp    80134f <strfind+0x27>
		if (*s == c)
			break;
  80134e:	90                   	nop
	return (char *) s;
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801366:	eb 0e                	jmp    801376 <memset+0x22>
		*p++ = c;
  801368:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136b:	8d 50 01             	lea    0x1(%eax),%edx
  80136e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801371:	8b 55 0c             	mov    0xc(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801376:	ff 4d f8             	decl   -0x8(%ebp)
  801379:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80137d:	79 e9                	jns    801368 <memset+0x14>
		*p++ = c;

	return v;
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801396:	eb 16                	jmp    8013ae <memcpy+0x2a>
		*d++ = *s++;
  801398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139b:	8d 50 01             	lea    0x1(%eax),%edx
  80139e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013aa:	8a 12                	mov    (%edx),%dl
  8013ac:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	75 dd                	jne    801398 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013d8:	73 50                	jae    80142a <memmove+0x6a>
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013e5:	76 43                	jbe    80142a <memmove+0x6a>
		s += n;
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013f3:	eb 10                	jmp    801405 <memmove+0x45>
			*--d = *--s;
  8013f5:	ff 4d f8             	decl   -0x8(%ebp)
  8013f8:	ff 4d fc             	decl   -0x4(%ebp)
  8013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fe:	8a 10                	mov    (%eax),%dl
  801400:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801403:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140b:	89 55 10             	mov    %edx,0x10(%ebp)
  80140e:	85 c0                	test   %eax,%eax
  801410:	75 e3                	jne    8013f5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801412:	eb 23                	jmp    801437 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	8d 50 01             	lea    0x1(%eax),%edx
  80141a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80141d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801420:	8d 4a 01             	lea    0x1(%edx),%ecx
  801423:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801426:	8a 12                	mov    (%edx),%dl
  801428:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801430:	89 55 10             	mov    %edx,0x10(%ebp)
  801433:	85 c0                	test   %eax,%eax
  801435:	75 dd                	jne    801414 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80144e:	eb 2a                	jmp    80147a <memcmp+0x3e>
		if (*s1 != *s2)
  801450:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801453:	8a 10                	mov    (%eax),%dl
  801455:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	38 c2                	cmp    %al,%dl
  80145c:	74 16                	je     801474 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80145e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	0f b6 d0             	movzbl %al,%edx
  801466:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f b6 c0             	movzbl %al,%eax
  80146e:	29 c2                	sub    %eax,%edx
  801470:	89 d0                	mov    %edx,%eax
  801472:	eb 18                	jmp    80148c <memcmp+0x50>
		s1++, s2++;
  801474:	ff 45 fc             	incl   -0x4(%ebp)
  801477:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801480:	89 55 10             	mov    %edx,0x10(%ebp)
  801483:	85 c0                	test   %eax,%eax
  801485:	75 c9                	jne    801450 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 d0                	add    %edx,%eax
  80149c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80149f:	eb 15                	jmp    8014b6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f b6 d0             	movzbl %al,%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	0f b6 c0             	movzbl %al,%eax
  8014af:	39 c2                	cmp    %eax,%edx
  8014b1:	74 0d                	je     8014c0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014b3:	ff 45 08             	incl   0x8(%ebp)
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014bc:	72 e3                	jb     8014a1 <memfind+0x13>
  8014be:	eb 01                	jmp    8014c1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014c0:	90                   	nop
	return (void *) s;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014da:	eb 03                	jmp    8014df <strtol+0x19>
		s++;
  8014dc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3c 20                	cmp    $0x20,%al
  8014e6:	74 f4                	je     8014dc <strtol+0x16>
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	3c 09                	cmp    $0x9,%al
  8014ef:	74 eb                	je     8014dc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 2b                	cmp    $0x2b,%al
  8014f8:	75 05                	jne    8014ff <strtol+0x39>
		s++;
  8014fa:	ff 45 08             	incl   0x8(%ebp)
  8014fd:	eb 13                	jmp    801512 <strtol+0x4c>
	else if (*s == '-')
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	3c 2d                	cmp    $0x2d,%al
  801506:	75 0a                	jne    801512 <strtol+0x4c>
		s++, neg = 1;
  801508:	ff 45 08             	incl   0x8(%ebp)
  80150b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801512:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801516:	74 06                	je     80151e <strtol+0x58>
  801518:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80151c:	75 20                	jne    80153e <strtol+0x78>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 30                	cmp    $0x30,%al
  801525:	75 17                	jne    80153e <strtol+0x78>
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	40                   	inc    %eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	3c 78                	cmp    $0x78,%al
  80152f:	75 0d                	jne    80153e <strtol+0x78>
		s += 2, base = 16;
  801531:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801535:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80153c:	eb 28                	jmp    801566 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80153e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801542:	75 15                	jne    801559 <strtol+0x93>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	3c 30                	cmp    $0x30,%al
  80154b:	75 0c                	jne    801559 <strtol+0x93>
		s++, base = 8;
  80154d:	ff 45 08             	incl   0x8(%ebp)
  801550:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801557:	eb 0d                	jmp    801566 <strtol+0xa0>
	else if (base == 0)
  801559:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155d:	75 07                	jne    801566 <strtol+0xa0>
		base = 10;
  80155f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	3c 2f                	cmp    $0x2f,%al
  80156d:	7e 19                	jle    801588 <strtol+0xc2>
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	3c 39                	cmp    $0x39,%al
  801576:	7f 10                	jg     801588 <strtol+0xc2>
			dig = *s - '0';
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	0f be c0             	movsbl %al,%eax
  801580:	83 e8 30             	sub    $0x30,%eax
  801583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801586:	eb 42                	jmp    8015ca <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	3c 60                	cmp    $0x60,%al
  80158f:	7e 19                	jle    8015aa <strtol+0xe4>
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	3c 7a                	cmp    $0x7a,%al
  801598:	7f 10                	jg     8015aa <strtol+0xe4>
			dig = *s - 'a' + 10;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	0f be c0             	movsbl %al,%eax
  8015a2:	83 e8 57             	sub    $0x57,%eax
  8015a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015a8:	eb 20                	jmp    8015ca <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	3c 40                	cmp    $0x40,%al
  8015b1:	7e 39                	jle    8015ec <strtol+0x126>
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3c 5a                	cmp    $0x5a,%al
  8015ba:	7f 30                	jg     8015ec <strtol+0x126>
			dig = *s - 'A' + 10;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f be c0             	movsbl %al,%eax
  8015c4:	83 e8 37             	sub    $0x37,%eax
  8015c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015d0:	7d 19                	jge    8015eb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015d2:	ff 45 08             	incl   0x8(%ebp)
  8015d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015e6:	e9 7b ff ff ff       	jmp    801566 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015eb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f0:	74 08                	je     8015fa <strtol+0x134>
		*endptr = (char *) s;
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015fe:	74 07                	je     801607 <strtol+0x141>
  801600:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801603:	f7 d8                	neg    %eax
  801605:	eb 03                	jmp    80160a <strtol+0x144>
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <ltostr>:

void
ltostr(long value, char *str)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801612:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801619:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801624:	79 13                	jns    801639 <ltostr+0x2d>
	{
		neg = 1;
  801626:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801633:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801636:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801641:	99                   	cltd   
  801642:	f7 f9                	idiv   %ecx
  801644:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801647:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164a:	8d 50 01             	lea    0x1(%eax),%edx
  80164d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801650:	89 c2                	mov    %eax,%edx
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	01 d0                	add    %edx,%eax
  801657:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80165a:	83 c2 30             	add    $0x30,%edx
  80165d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80165f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801662:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801667:	f7 e9                	imul   %ecx
  801669:	c1 fa 02             	sar    $0x2,%edx
  80166c:	89 c8                	mov    %ecx,%eax
  80166e:	c1 f8 1f             	sar    $0x1f,%eax
  801671:	29 c2                	sub    %eax,%edx
  801673:	89 d0                	mov    %edx,%eax
  801675:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801678:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80167c:	75 bb                	jne    801639 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80167e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	48                   	dec    %eax
  801689:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80168c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801690:	74 3d                	je     8016cf <ltostr+0xc3>
		start = 1 ;
  801692:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801699:	eb 34                	jmp    8016cf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80169b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	01 d0                	add    %edx,%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ae:	01 c2                	add    %eax,%edx
  8016b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 c8                	add    %ecx,%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	01 c2                	add    %eax,%edx
  8016c4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016c7:	88 02                	mov    %al,(%edx)
		start++ ;
  8016c9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016cc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016d5:	7c c4                	jl     80169b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016e2:	90                   	nop
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	e8 73 fa ff ff       	call   801166 <strlen>
  8016f3:	83 c4 04             	add    $0x4,%esp
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	e8 65 fa ff ff       	call   801166 <strlen>
  801701:	83 c4 04             	add    $0x4,%esp
  801704:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801707:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801715:	eb 17                	jmp    80172e <strcconcat+0x49>
		final[s] = str1[s] ;
  801717:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171a:	8b 45 10             	mov    0x10(%ebp),%eax
  80171d:	01 c2                	add    %eax,%edx
  80171f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	01 c8                	add    %ecx,%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80172b:	ff 45 fc             	incl   -0x4(%ebp)
  80172e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801731:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801734:	7c e1                	jl     801717 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801736:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80173d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801744:	eb 1f                	jmp    801765 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801746:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80174f:	89 c2                	mov    %eax,%edx
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	01 c2                	add    %eax,%edx
  801756:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	01 c8                	add    %ecx,%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801762:	ff 45 f8             	incl   -0x8(%ebp)
  801765:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801768:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80176b:	7c d9                	jl     801746 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80176d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801770:	8b 45 10             	mov    0x10(%ebp),%eax
  801773:	01 d0                	add    %edx,%eax
  801775:	c6 00 00             	movb   $0x0,(%eax)
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80177e:	8b 45 14             	mov    0x14(%ebp),%eax
  801781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801787:	8b 45 14             	mov    0x14(%ebp),%eax
  80178a:	8b 00                	mov    (%eax),%eax
  80178c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	01 d0                	add    %edx,%eax
  801798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80179e:	eb 0c                	jmp    8017ac <strsplit+0x31>
			*string++ = 0;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8d 50 01             	lea    0x1(%eax),%edx
  8017a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8017a9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	84 c0                	test   %al,%al
  8017b3:	74 18                	je     8017cd <strsplit+0x52>
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	0f be c0             	movsbl %al,%eax
  8017bd:	50                   	push   %eax
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	e8 32 fb ff ff       	call   8012f8 <strchr>
  8017c6:	83 c4 08             	add    $0x8,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	75 d3                	jne    8017a0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	84 c0                	test   %al,%al
  8017d4:	74 5a                	je     801830 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d9:	8b 00                	mov    (%eax),%eax
  8017db:	83 f8 0f             	cmp    $0xf,%eax
  8017de:	75 07                	jne    8017e7 <strsplit+0x6c>
		{
			return 0;
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	eb 66                	jmp    80184d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8017ef:	8b 55 14             	mov    0x14(%ebp),%edx
  8017f2:	89 0a                	mov    %ecx,(%edx)
  8017f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 c2                	add    %eax,%edx
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801805:	eb 03                	jmp    80180a <strsplit+0x8f>
			string++;
  801807:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	84 c0                	test   %al,%al
  801811:	74 8b                	je     80179e <strsplit+0x23>
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	0f be c0             	movsbl %al,%eax
  80181b:	50                   	push   %eax
  80181c:	ff 75 0c             	pushl  0xc(%ebp)
  80181f:	e8 d4 fa ff ff       	call   8012f8 <strchr>
  801824:	83 c4 08             	add    $0x8,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	74 dc                	je     801807 <strsplit+0x8c>
			string++;
	}
  80182b:	e9 6e ff ff ff       	jmp    80179e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801830:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801831:	8b 45 14             	mov    0x14(%ebp),%eax
  801834:	8b 00                	mov    (%eax),%eax
  801836:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183d:	8b 45 10             	mov    0x10(%ebp),%eax
  801840:	01 d0                	add    %edx,%eax
  801842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801848:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	68 88 4a 80 00       	push   $0x804a88
  80185d:	68 3f 01 00 00       	push   $0x13f
  801862:	68 aa 4a 80 00       	push   $0x804aaa
  801867:	e8 a9 ef ff ff       	call   800815 <_panic>

0080186c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	e8 e7 0a 00 00       	call   802364 <sys_sbrk>
  80187d:	83 c4 10             	add    $0x10,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188c:	75 0a                	jne    801898 <malloc+0x16>
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	e9 07 02 00 00       	jmp    801a9f <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801898:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80189f:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	48                   	dec    %eax
  8018a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b3:	f7 75 dc             	divl   -0x24(%ebp)
  8018b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018b9:	29 d0                	sub    %edx,%eax
  8018bb:	c1 e8 0c             	shr    $0xc,%eax
  8018be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8018c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c6:	8b 40 78             	mov    0x78(%eax),%eax
  8018c9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8018ce:	29 c2                	sub    %eax,%edx
  8018d0:	89 d0                	mov    %edx,%eax
  8018d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8018d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018dd:	c1 e8 0c             	shr    $0xc,%eax
  8018e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8018e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018ea:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018f1:	77 42                	ja     801935 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018f3:	e8 f0 08 00 00       	call   8021e8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 16                	je     801912 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 30 0e 00 00       	call   802737 <alloc_block_FF>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190d:	e9 8a 01 00 00       	jmp    801a9c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801912:	e8 02 09 00 00       	call   802219 <sys_isUHeapPlacementStrategyBESTFIT>
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 84 7d 01 00 00    	je     801a9c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 c9 12 00 00       	call   802bf3 <alloc_block_BF>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801930:	e9 67 01 00 00       	jmp    801a9c <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801938:	48                   	dec    %eax
  801939:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80193c:	0f 86 53 01 00 00    	jbe    801a95 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801942:	a1 20 50 80 00       	mov    0x805020,%eax
  801947:	8b 40 78             	mov    0x78(%eax),%eax
  80194a:	05 00 10 00 00       	add    $0x1000,%eax
  80194f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801952:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801959:	e9 de 00 00 00       	jmp    801a3c <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80195e:	a1 20 50 80 00       	mov    0x805020,%eax
  801963:	8b 40 78             	mov    0x78(%eax),%eax
  801966:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801969:	29 c2                	sub    %eax,%edx
  80196b:	89 d0                	mov    %edx,%eax
  80196d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801972:	c1 e8 0c             	shr    $0xc,%eax
  801975:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80197c:	85 c0                	test   %eax,%eax
  80197e:	0f 85 ab 00 00 00    	jne    801a2f <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801987:	05 00 10 00 00       	add    $0x1000,%eax
  80198c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80198f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801996:	eb 47                	jmp    8019df <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801998:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80199f:	76 0a                	jbe    8019ab <malloc+0x129>
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a6:	e9 f4 00 00 00       	jmp    801a9f <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8019ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8019b0:	8b 40 78             	mov    0x78(%eax),%eax
  8019b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019b6:	29 c2                	sub    %eax,%edx
  8019b8:	89 d0                	mov    %edx,%eax
  8019ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019bf:	c1 e8 0c             	shr    $0xc,%eax
  8019c2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	74 08                	je     8019d5 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8019cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8019d3:	eb 5a                	jmp    801a2f <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8019d5:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8019dc:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8019df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019e2:	48                   	dec    %eax
  8019e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019e6:	77 b0                	ja     801998 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8019e8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8019ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019f6:	eb 2f                	jmp    801a27 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8019f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019fb:	c1 e0 0c             	shl    $0xc,%eax
  8019fe:	89 c2                	mov    %eax,%edx
  801a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a03:	01 c2                	add    %eax,%edx
  801a05:	a1 20 50 80 00       	mov    0x805020,%eax
  801a0a:	8b 40 78             	mov    0x78(%eax),%eax
  801a0d:	29 c2                	sub    %eax,%edx
  801a0f:	89 d0                	mov    %edx,%eax
  801a11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a16:	c1 e8 0c             	shr    $0xc,%eax
  801a19:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801a20:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801a24:	ff 45 e0             	incl   -0x20(%ebp)
  801a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a2d:	72 c9                	jb     8019f8 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a33:	75 16                	jne    801a4b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801a35:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801a3c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801a43:	0f 86 15 ff ff ff    	jbe    80195e <malloc+0xdc>
  801a49:	eb 01                	jmp    801a4c <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801a4b:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801a4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a50:	75 07                	jne    801a59 <malloc+0x1d7>
  801a52:	b8 00 00 00 00       	mov    $0x0,%eax
  801a57:	eb 46                	jmp    801a9f <malloc+0x21d>
		ptr = (void*)i;
  801a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801a5f:	a1 20 50 80 00       	mov    0x805020,%eax
  801a64:	8b 40 78             	mov    0x78(%eax),%eax
  801a67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a6a:	29 c2                	sub    %eax,%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a73:	c1 e8 0c             	shr    $0xc,%eax
  801a76:	89 c2                	mov    %eax,%edx
  801a78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a7b:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	ff 75 f0             	pushl  -0x10(%ebp)
  801a8b:	e8 0b 09 00 00       	call   80239b <sys_allocate_user_mem>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	eb 07                	jmp    801a9c <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	eb 03                	jmp    801a9f <malloc+0x21d>
	}
	return ptr;
  801a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801aa7:	a1 20 50 80 00       	mov    0x805020,%eax
  801aac:	8b 40 78             	mov    0x78(%eax),%eax
  801aaf:	05 00 10 00 00       	add    $0x1000,%eax
  801ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801ab7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801abe:	a1 20 50 80 00       	mov    0x805020,%eax
  801ac3:	8b 50 78             	mov    0x78(%eax),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	39 c2                	cmp    %eax,%edx
  801acb:	76 24                	jbe    801af1 <free+0x50>
		size = get_block_size(va);
  801acd:	83 ec 0c             	sub    $0xc,%esp
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	e8 df 08 00 00       	call   8023b7 <get_block_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 12 1b 00 00       	call   8035fb <free_block>
  801ae9:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801aec:	e9 ac 00 00 00       	jmp    801b9d <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af7:	0f 82 89 00 00 00    	jb     801b86 <free+0xe5>
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801b05:	77 7f                	ja     801b86 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801b07:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0a:	a1 20 50 80 00       	mov    0x805020,%eax
  801b0f:	8b 40 78             	mov    0x78(%eax),%eax
  801b12:	29 c2                	sub    %eax,%edx
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b1b:	c1 e8 0c             	shr    $0xc,%eax
  801b1e:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801b25:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2b:	c1 e0 0c             	shl    $0xc,%eax
  801b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801b38:	eb 2f                	jmp    801b69 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3d:	c1 e0 0c             	shl    $0xc,%eax
  801b40:	89 c2                	mov    %eax,%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	01 c2                	add    %eax,%edx
  801b47:	a1 20 50 80 00       	mov    0x805020,%eax
  801b4c:	8b 40 78             	mov    0x78(%eax),%eax
  801b4f:	29 c2                	sub    %eax,%edx
  801b51:	89 d0                	mov    %edx,%eax
  801b53:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b58:	c1 e8 0c             	shr    $0xc,%eax
  801b5b:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801b62:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801b66:	ff 45 f4             	incl   -0xc(%ebp)
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b6f:	72 c9                	jb     801b3a <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	ff 75 ec             	pushl  -0x14(%ebp)
  801b7a:	50                   	push   %eax
  801b7b:	e8 ff 07 00 00       	call   80237f <sys_free_user_mem>
  801b80:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801b83:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801b84:	eb 17                	jmp    801b9d <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	68 b8 4a 80 00       	push   $0x804ab8
  801b8e:	68 85 00 00 00       	push   $0x85
  801b93:	68 e2 4a 80 00       	push   $0x804ae2
  801b98:	e8 78 ec ff ff       	call   800815 <_panic>
	}
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 28             	sub    $0x28,%esp
  801ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801baf:	75 0a                	jne    801bbb <smalloc+0x1c>
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb6:	e9 9a 00 00 00       	jmp    801c55 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bce:	39 d0                	cmp    %edx,%eax
  801bd0:	73 02                	jae    801bd4 <smalloc+0x35>
  801bd2:	89 d0                	mov    %edx,%eax
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	50                   	push   %eax
  801bd8:	e8 a5 fc ff ff       	call   801882 <malloc>
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801be7:	75 07                	jne    801bf0 <smalloc+0x51>
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	eb 65                	jmp    801c55 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bf0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bf4:	ff 75 ec             	pushl  -0x14(%ebp)
  801bf7:	50                   	push   %eax
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 83 03 00 00       	call   801f86 <sys_createSharedObject>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801c09:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801c0d:	74 06                	je     801c15 <smalloc+0x76>
  801c0f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801c13:	75 07                	jne    801c1c <smalloc+0x7d>
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1a:	eb 39                	jmp    801c55 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801c1c:	83 ec 08             	sub    $0x8,%esp
  801c1f:	ff 75 ec             	pushl  -0x14(%ebp)
  801c22:	68 ee 4a 80 00       	push   $0x804aee
  801c27:	e8 a6 ee ff ff       	call   800ad2 <cprintf>
  801c2c:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c32:	a1 20 50 80 00       	mov    0x805020,%eax
  801c37:	8b 40 78             	mov    0x78(%eax),%eax
  801c3a:	29 c2                	sub    %eax,%edx
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c43:	c1 e8 0c             	shr    $0xc,%eax
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c4b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 45 03 00 00       	call   801fb0 <sys_getSizeOfSharedObject>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c71:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c75:	75 07                	jne    801c7e <sget+0x27>
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7c:	eb 5c                	jmp    801cda <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c84:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c91:	39 d0                	cmp    %edx,%eax
  801c93:	7d 02                	jge    801c97 <sget+0x40>
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	50                   	push   %eax
  801c9b:	e8 e2 fb ff ff       	call   801882 <malloc>
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ca6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801caa:	75 07                	jne    801cb3 <sget+0x5c>
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb1:	eb 27                	jmp    801cda <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	e8 09 03 00 00       	call   801fcd <sys_getSharedObject>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801cca:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801cce:	75 07                	jne    801cd7 <sget+0x80>
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd5:	eb 03                	jmp    801cda <sget+0x83>
	return ptr;
  801cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce5:	a1 20 50 80 00       	mov    0x805020,%eax
  801cea:	8b 40 78             	mov    0x78(%eax),%eax
  801ced:	29 c2                	sub    %eax,%edx
  801cef:	89 d0                	mov    %edx,%eax
  801cf1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cf6:	c1 e8 0c             	shr    $0xc,%eax
  801cf9:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801d03:	83 ec 08             	sub    $0x8,%esp
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0c:	e8 db 02 00 00       	call   801fec <sys_freeSharedObject>
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801d17:	90                   	nop
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	68 00 4b 80 00       	push   $0x804b00
  801d28:	68 dd 00 00 00       	push   $0xdd
  801d2d:	68 e2 4a 80 00       	push   $0x804ae2
  801d32:	e8 de ea ff ff       	call   800815 <_panic>

00801d37 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	68 26 4b 80 00       	push   $0x804b26
  801d45:	68 e9 00 00 00       	push   $0xe9
  801d4a:	68 e2 4a 80 00       	push   $0x804ae2
  801d4f:	e8 c1 ea ff ff       	call   800815 <_panic>

00801d54 <shrink>:

}
void shrink(uint32 newSize)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	68 26 4b 80 00       	push   $0x804b26
  801d62:	68 ee 00 00 00       	push   $0xee
  801d67:	68 e2 4a 80 00       	push   $0x804ae2
  801d6c:	e8 a4 ea ff ff       	call   800815 <_panic>

00801d71 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 26 4b 80 00       	push   $0x804b26
  801d7f:	68 f3 00 00 00       	push   $0xf3
  801d84:	68 e2 4a 80 00       	push   $0x804ae2
  801d89:	e8 87 ea ff ff       	call   800815 <_panic>

00801d8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801da6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801da9:	cd 30                	int    $0x30
  801dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5e                   	pop    %esi
  801db6:	5f                   	pop    %edi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dc5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	52                   	push   %edx
  801dd1:	ff 75 0c             	pushl  0xc(%ebp)
  801dd4:	50                   	push   %eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	e8 b2 ff ff ff       	call   801d8e <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	90                   	nop
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 02                	push   $0x2
  801df1:	e8 98 ff ff ff       	call   801d8e <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_lock_cons>:

void sys_lock_cons(void)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 03                	push   $0x3
  801e0a:	e8 7f ff ff ff       	call   801d8e <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	90                   	nop
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 04                	push   $0x4
  801e24:	e8 65 ff ff ff       	call   801d8e <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	90                   	nop
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	6a 08                	push   $0x8
  801e42:	e8 47 ff ff ff       	call   801d8e <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	56                   	push   %esi
  801e50:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e51:	8b 75 18             	mov    0x18(%ebp),%esi
  801e54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	51                   	push   %ecx
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	6a 09                	push   $0x9
  801e67:	e8 22 ff ff ff       	call   801d8e <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 0a                	push   $0xa
  801e89:	e8 00 ff ff ff       	call   801d8e <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 0b                	push   $0xb
  801ea4:	e8 e5 fe ff ff       	call   801d8e <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 0c                	push   $0xc
  801ebd:	e8 cc fe ff ff       	call   801d8e <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 0d                	push   $0xd
  801ed6:	e8 b3 fe ff ff       	call   801d8e <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 0e                	push   $0xe
  801eef:	e8 9a fe ff ff       	call   801d8e <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 0f                	push   $0xf
  801f08:	e8 81 fe ff ff       	call   801d8e <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 10                	push   $0x10
  801f22:	e8 67 fe ff ff       	call   801d8e <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 11                	push   $0x11
  801f3b:	e8 4e fe ff ff       	call   801d8e <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	90                   	nop
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	50                   	push   %eax
  801f5f:	6a 01                	push   $0x1
  801f61:	e8 28 fe ff ff       	call   801d8e <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	90                   	nop
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 14                	push   $0x14
  801f7b:	e8 0e fe ff ff       	call   801d8e <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	90                   	nop
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f92:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f95:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	6a 00                	push   $0x0
  801f9e:	51                   	push   %ecx
  801f9f:	52                   	push   %edx
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	50                   	push   %eax
  801fa4:	6a 15                	push   $0x15
  801fa6:	e8 e3 fd ff ff       	call   801d8e <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	52                   	push   %edx
  801fc0:	50                   	push   %eax
  801fc1:	6a 16                	push   $0x16
  801fc3:	e8 c6 fd ff ff       	call   801d8e <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	51                   	push   %ecx
  801fde:	52                   	push   %edx
  801fdf:	50                   	push   %eax
  801fe0:	6a 17                	push   $0x17
  801fe2:	e8 a7 fd ff ff       	call   801d8e <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	52                   	push   %edx
  801ffc:	50                   	push   %eax
  801ffd:	6a 18                	push   $0x18
  801fff:	e8 8a fd ff ff       	call   801d8e <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	ff 75 14             	pushl  0x14(%ebp)
  802014:	ff 75 10             	pushl  0x10(%ebp)
  802017:	ff 75 0c             	pushl  0xc(%ebp)
  80201a:	50                   	push   %eax
  80201b:	6a 19                	push   $0x19
  80201d:	e8 6c fd ff ff       	call   801d8e <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	50                   	push   %eax
  802036:	6a 1a                	push   $0x1a
  802038:	e8 51 fd ff ff       	call   801d8e <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	90                   	nop
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	50                   	push   %eax
  802052:	6a 1b                	push   $0x1b
  802054:	e8 35 fd ff ff       	call   801d8e <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 05                	push   $0x5
  80206d:	e8 1c fd ff ff       	call   801d8e <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 06                	push   $0x6
  802086:	e8 03 fd ff ff       	call   801d8e <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 07                	push   $0x7
  80209f:	e8 ea fc ff ff       	call   801d8e <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_exit_env>:


void sys_exit_env(void)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 1c                	push   $0x1c
  8020b8:	e8 d1 fc ff ff       	call   801d8e <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020cc:	8d 50 04             	lea    0x4(%eax),%edx
  8020cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	6a 1d                	push   $0x1d
  8020dc:	e8 ad fc ff ff       	call   801d8e <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
	return result;
  8020e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ed:	89 01                	mov    %eax,(%ecx)
  8020ef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	c9                   	leave  
  8020f6:	c2 04 00             	ret    $0x4

008020f9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	ff 75 10             	pushl  0x10(%ebp)
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	6a 13                	push   $0x13
  80210b:	e8 7e fc ff ff       	call   801d8e <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
	return ;
  802113:	90                   	nop
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_rcr2>:
uint32 sys_rcr2()
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 1e                	push   $0x1e
  802125:	e8 64 fc ff ff       	call   801d8e <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80213b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	50                   	push   %eax
  802148:	6a 1f                	push   $0x1f
  80214a:	e8 3f fc ff ff       	call   801d8e <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
	return ;
  802152:	90                   	nop
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <rsttst>:
void rsttst()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 21                	push   $0x21
  802164:	e8 25 fc ff ff       	call   801d8e <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
	return ;
  80216c:	90                   	nop
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	8b 45 14             	mov    0x14(%ebp),%eax
  802178:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80217b:	8b 55 18             	mov    0x18(%ebp),%edx
  80217e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802182:	52                   	push   %edx
  802183:	50                   	push   %eax
  802184:	ff 75 10             	pushl  0x10(%ebp)
  802187:	ff 75 0c             	pushl  0xc(%ebp)
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	6a 20                	push   $0x20
  80218f:	e8 fa fb ff ff       	call   801d8e <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return ;
  802197:	90                   	nop
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <chktst>:
void chktst(uint32 n)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	ff 75 08             	pushl  0x8(%ebp)
  8021a8:	6a 22                	push   $0x22
  8021aa:	e8 df fb ff ff       	call   801d8e <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b2:	90                   	nop
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <inctst>:

void inctst()
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 23                	push   $0x23
  8021c4:	e8 c5 fb ff ff       	call   801d8e <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cc:	90                   	nop
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <gettst>:
uint32 gettst()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 24                	push   $0x24
  8021de:	e8 ab fb ff ff       	call   801d8e <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 25                	push   $0x25
  8021fa:	e8 8f fb ff ff       	call   801d8e <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
  802202:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802205:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802209:	75 07                	jne    802212 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80220b:	b8 01 00 00 00       	mov    $0x1,%eax
  802210:	eb 05                	jmp    802217 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 25                	push   $0x25
  80222b:	e8 5e fb ff ff       	call   801d8e <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
  802233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802236:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80223a:	75 07                	jne    802243 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80223c:	b8 01 00 00 00       	mov    $0x1,%eax
  802241:	eb 05                	jmp    802248 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 25                	push   $0x25
  80225c:	e8 2d fb ff ff       	call   801d8e <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
  802264:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802267:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80226b:	75 07                	jne    802274 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80226d:	b8 01 00 00 00       	mov    $0x1,%eax
  802272:	eb 05                	jmp    802279 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802274:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 25                	push   $0x25
  80228d:	e8 fc fa ff ff       	call   801d8e <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
  802295:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802298:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80229c:	75 07                	jne    8022a5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	eb 05                	jmp    8022aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	ff 75 08             	pushl  0x8(%ebp)
  8022ba:	6a 26                	push   $0x26
  8022bc:	e8 cd fa ff ff       	call   801d8e <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c4:	90                   	nop
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	53                   	push   %ebx
  8022da:	51                   	push   %ecx
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	6a 27                	push   $0x27
  8022df:	e8 aa fa ff ff       	call   801d8e <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	6a 28                	push   $0x28
  8022ff:	e8 8a fa ff ff       	call   801d8e <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80230c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80230f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	6a 00                	push   $0x0
  802317:	51                   	push   %ecx
  802318:	ff 75 10             	pushl  0x10(%ebp)
  80231b:	52                   	push   %edx
  80231c:	50                   	push   %eax
  80231d:	6a 29                	push   $0x29
  80231f:	e8 6a fa ff ff       	call   801d8e <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	ff 75 10             	pushl  0x10(%ebp)
  802333:	ff 75 0c             	pushl  0xc(%ebp)
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	6a 12                	push   $0x12
  80233b:	e8 4e fa ff ff       	call   801d8e <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
	return ;
  802343:	90                   	nop
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	52                   	push   %edx
  802356:	50                   	push   %eax
  802357:	6a 2a                	push   $0x2a
  802359:	e8 30 fa ff ff       	call   801d8e <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
	return;
  802361:	90                   	nop
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	50                   	push   %eax
  802373:	6a 2b                	push   $0x2b
  802375:	e8 14 fa ff ff       	call   801d8e <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	ff 75 08             	pushl  0x8(%ebp)
  80238e:	6a 2c                	push   $0x2c
  802390:	e8 f9 f9 ff ff       	call   801d8e <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
	return;
  802398:	90                   	nop
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	ff 75 0c             	pushl  0xc(%ebp)
  8023a7:	ff 75 08             	pushl  0x8(%ebp)
  8023aa:	6a 2d                	push   $0x2d
  8023ac:	e8 dd f9 ff ff       	call   801d8e <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
	return;
  8023b4:	90                   	nop
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	83 e8 04             	sub    $0x4,%eax
  8023c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8023c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	83 e8 04             	sub    $0x4,%eax
  8023dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8023df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	83 e0 01             	and    $0x1,%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 94 c0             	sete   %al
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8023f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fe:	83 f8 02             	cmp    $0x2,%eax
  802401:	74 2b                	je     80242e <alloc_block+0x40>
  802403:	83 f8 02             	cmp    $0x2,%eax
  802406:	7f 07                	jg     80240f <alloc_block+0x21>
  802408:	83 f8 01             	cmp    $0x1,%eax
  80240b:	74 0e                	je     80241b <alloc_block+0x2d>
  80240d:	eb 58                	jmp    802467 <alloc_block+0x79>
  80240f:	83 f8 03             	cmp    $0x3,%eax
  802412:	74 2d                	je     802441 <alloc_block+0x53>
  802414:	83 f8 04             	cmp    $0x4,%eax
  802417:	74 3b                	je     802454 <alloc_block+0x66>
  802419:	eb 4c                	jmp    802467 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	e8 11 03 00 00       	call   802737 <alloc_block_FF>
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80242c:	eb 4a                	jmp    802478 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	ff 75 08             	pushl  0x8(%ebp)
  802434:	e8 fa 19 00 00       	call   803e33 <alloc_block_NF>
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80243f:	eb 37                	jmp    802478 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	ff 75 08             	pushl  0x8(%ebp)
  802447:	e8 a7 07 00 00       	call   802bf3 <alloc_block_BF>
  80244c:	83 c4 10             	add    $0x10,%esp
  80244f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802452:	eb 24                	jmp    802478 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	ff 75 08             	pushl  0x8(%ebp)
  80245a:	e8 b7 19 00 00       	call   803e16 <alloc_block_WF>
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802465:	eb 11                	jmp    802478 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	68 38 4b 80 00       	push   $0x804b38
  80246f:	e8 5e e6 ff ff       	call   800ad2 <cprintf>
  802474:	83 c4 10             	add    $0x10,%esp
		break;
  802477:	90                   	nop
	}
	return va;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	53                   	push   %ebx
  802481:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802484:	83 ec 0c             	sub    $0xc,%esp
  802487:	68 58 4b 80 00       	push   $0x804b58
  80248c:	e8 41 e6 ff ff       	call   800ad2 <cprintf>
  802491:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	68 83 4b 80 00       	push   $0x804b83
  80249c:	e8 31 e6 ff ff       	call   800ad2 <cprintf>
  8024a1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024aa:	eb 37                	jmp    8024e3 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8024ac:	83 ec 0c             	sub    $0xc,%esp
  8024af:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b2:	e8 19 ff ff ff       	call   8023d0 <is_free_block>
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	0f be d8             	movsbl %al,%ebx
  8024bd:	83 ec 0c             	sub    $0xc,%esp
  8024c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c3:	e8 ef fe ff ff       	call   8023b7 <get_block_size>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	83 ec 04             	sub    $0x4,%esp
  8024ce:	53                   	push   %ebx
  8024cf:	50                   	push   %eax
  8024d0:	68 9b 4b 80 00       	push   $0x804b9b
  8024d5:	e8 f8 e5 ff ff       	call   800ad2 <cprintf>
  8024da:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	74 07                	je     8024f0 <print_blocks_list+0x73>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	eb 05                	jmp    8024f5 <print_blocks_list+0x78>
  8024f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f5:	89 45 10             	mov    %eax,0x10(%ebp)
  8024f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	75 ad                	jne    8024ac <print_blocks_list+0x2f>
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	75 a7                	jne    8024ac <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	68 58 4b 80 00       	push   $0x804b58
  80250d:	e8 c0 e5 ff ff       	call   800ad2 <cprintf>
  802512:	83 c4 10             	add    $0x10,%esp

}
  802515:	90                   	nop
  802516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802521:	8b 45 0c             	mov    0xc(%ebp),%eax
  802524:	83 e0 01             	and    $0x1,%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 03                	je     80252e <initialize_dynamic_allocator+0x13>
  80252b:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80252e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802532:	0f 84 c7 01 00 00    	je     8026ff <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802538:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80253f:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802542:	8b 55 08             	mov    0x8(%ebp),%edx
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	01 d0                	add    %edx,%eax
  80254a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80254f:	0f 87 ad 01 00 00    	ja     802702 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	0f 89 a5 01 00 00    	jns    802705 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802560:	8b 55 08             	mov    0x8(%ebp),%edx
  802563:	8b 45 0c             	mov    0xc(%ebp),%eax
  802566:	01 d0                	add    %edx,%eax
  802568:	83 e8 04             	sub    $0x4,%eax
  80256b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802577:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257f:	e9 87 00 00 00       	jmp    80260b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802588:	75 14                	jne    80259e <initialize_dynamic_allocator+0x83>
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	68 b3 4b 80 00       	push   $0x804bb3
  802592:	6a 79                	push   $0x79
  802594:	68 d1 4b 80 00       	push   $0x804bd1
  802599:	e8 77 e2 ff ff       	call   800815 <_panic>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 10                	je     8025b7 <initialize_dynamic_allocator+0x9c>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025af:	8b 52 04             	mov    0x4(%edx),%edx
  8025b2:	89 50 04             	mov    %edx,0x4(%eax)
  8025b5:	eb 0b                	jmp    8025c2 <initialize_dynamic_allocator+0xa7>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 0f                	je     8025db <initialize_dynamic_allocator+0xc0>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	8b 12                	mov    (%edx),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 0a                	jmp    8025e5 <initialize_dynamic_allocator+0xca>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fd:	48                   	dec    %eax
  8025fe:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802603:	a1 34 50 80 00       	mov    0x805034,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	74 07                	je     802618 <initialize_dynamic_allocator+0xfd>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	eb 05                	jmp    80261d <initialize_dynamic_allocator+0x102>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 34 50 80 00       	mov    %eax,0x805034
  802622:	a1 34 50 80 00       	mov    0x805034,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 85 55 ff ff ff    	jne    802584 <initialize_dynamic_allocator+0x69>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	0f 85 4b ff ff ff    	jne    802584 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802648:	a1 44 50 80 00       	mov    0x805044,%eax
  80264d:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802652:	a1 40 50 80 00       	mov    0x805040,%eax
  802657:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	83 c0 08             	add    $0x8,%eax
  802663:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	83 c0 04             	add    $0x4,%eax
  80266c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266f:	83 ea 08             	sub    $0x8,%edx
  802672:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802674:	8b 55 0c             	mov    0xc(%ebp),%edx
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	01 d0                	add    %edx,%eax
  80267c:	83 e8 08             	sub    $0x8,%eax
  80267f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802682:	83 ea 08             	sub    $0x8,%edx
  802685:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80269a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80269e:	75 17                	jne    8026b7 <initialize_dynamic_allocator+0x19c>
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	68 ec 4b 80 00       	push   $0x804bec
  8026a8:	68 90 00 00 00       	push   $0x90
  8026ad:	68 d1 4b 80 00       	push   $0x804bd1
  8026b2:	e8 5e e1 ff ff       	call   800815 <_panic>
  8026b7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c0:	89 10                	mov    %edx,(%eax)
  8026c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 0d                	je     8026d8 <initialize_dynamic_allocator+0x1bd>
  8026cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d3:	89 50 04             	mov    %edx,0x4(%eax)
  8026d6:	eb 08                	jmp    8026e0 <initialize_dynamic_allocator+0x1c5>
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8026f7:	40                   	inc    %eax
  8026f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8026fd:	eb 07                	jmp    802706 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8026ff:	90                   	nop
  802700:	eb 04                	jmp    802706 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802702:	90                   	nop
  802703:	eb 01                	jmp    802706 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802705:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80270b:	8b 45 10             	mov    0x10(%ebp),%eax
  80270e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	8d 50 fc             	lea    -0x4(%eax),%edx
  802717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	83 e8 04             	sub    $0x4,%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	83 e0 fe             	and    $0xfffffffe,%eax
  802727:	8d 50 f8             	lea    -0x8(%eax),%edx
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	01 c2                	add    %eax,%edx
  80272f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802732:	89 02                	mov    %eax,(%edx)
}
  802734:	90                   	nop
  802735:	5d                   	pop    %ebp
  802736:	c3                   	ret    

00802737 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
  80273a:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	83 e0 01             	and    $0x1,%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 03                	je     80274a <alloc_block_FF+0x13>
  802747:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80274a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80274e:	77 07                	ja     802757 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802750:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802757:	a1 24 50 80 00       	mov    0x805024,%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	75 73                	jne    8027d3 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	83 c0 10             	add    $0x10,%eax
  802766:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802769:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802770:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802776:	01 d0                	add    %edx,%eax
  802778:	48                   	dec    %eax
  802779:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80277c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277f:	ba 00 00 00 00       	mov    $0x0,%edx
  802784:	f7 75 ec             	divl   -0x14(%ebp)
  802787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278a:	29 d0                	sub    %edx,%eax
  80278c:	c1 e8 0c             	shr    $0xc,%eax
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	50                   	push   %eax
  802793:	e8 d4 f0 ff ff       	call   80186c <sbrk>
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80279e:	83 ec 0c             	sub    $0xc,%esp
  8027a1:	6a 00                	push   $0x0
  8027a3:	e8 c4 f0 ff ff       	call   80186c <sbrk>
  8027a8:	83 c4 10             	add    $0x10,%esp
  8027ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027b4:	83 ec 08             	sub    $0x8,%esp
  8027b7:	50                   	push   %eax
  8027b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027bb:	e8 5b fd ff ff       	call   80251b <initialize_dynamic_allocator>
  8027c0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	68 0f 4c 80 00       	push   $0x804c0f
  8027cb:	e8 02 e3 ff ff       	call   800ad2 <cprintf>
  8027d0:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8027d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027d7:	75 0a                	jne    8027e3 <alloc_block_FF+0xac>
	        return NULL;
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	e9 0e 04 00 00       	jmp    802bf1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8027e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	e9 f3 02 00 00       	jmp    802aea <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8027fd:	83 ec 0c             	sub    $0xc,%esp
  802800:	ff 75 bc             	pushl  -0x44(%ebp)
  802803:	e8 af fb ff ff       	call   8023b7 <get_block_size>
  802808:	83 c4 10             	add    $0x10,%esp
  80280b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	83 c0 08             	add    $0x8,%eax
  802814:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802817:	0f 87 c5 02 00 00    	ja     802ae2 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	83 c0 18             	add    $0x18,%eax
  802823:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802826:	0f 87 19 02 00 00    	ja     802a45 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80282c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80282f:	2b 45 08             	sub    0x8(%ebp),%eax
  802832:	83 e8 08             	sub    $0x8,%eax
  802835:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	8d 50 08             	lea    0x8(%eax),%edx
  80283e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802841:	01 d0                	add    %edx,%eax
  802843:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	83 c0 08             	add    $0x8,%eax
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	6a 01                	push   $0x1
  802851:	50                   	push   %eax
  802852:	ff 75 bc             	pushl  -0x44(%ebp)
  802855:	e8 ae fe ff ff       	call   802708 <set_block_data>
  80285a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	75 68                	jne    8028cf <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802867:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80286b:	75 17                	jne    802884 <alloc_block_FF+0x14d>
  80286d:	83 ec 04             	sub    $0x4,%esp
  802870:	68 ec 4b 80 00       	push   $0x804bec
  802875:	68 d7 00 00 00       	push   $0xd7
  80287a:	68 d1 4b 80 00       	push   $0x804bd1
  80287f:	e8 91 df ff ff       	call   800815 <_panic>
  802884:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80288a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80288d:	89 10                	mov    %edx,(%eax)
  80288f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	74 0d                	je     8028a5 <alloc_block_FF+0x16e>
  802898:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80289d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	eb 08                	jmp    8028ad <alloc_block_FF+0x176>
  8028a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c4:	40                   	inc    %eax
  8028c5:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ca:	e9 dc 00 00 00       	jmp    8029ab <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	75 65                	jne    80293d <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028d8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028dc:	75 17                	jne    8028f5 <alloc_block_FF+0x1be>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 20 4c 80 00       	push   $0x804c20
  8028e6:	68 db 00 00 00       	push   $0xdb
  8028eb:	68 d1 4b 80 00       	push   $0x804bd1
  8028f0:	e8 20 df ff ff       	call   800815 <_panic>
  8028f5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028fe:	89 50 04             	mov    %edx,0x4(%eax)
  802901:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802904:	8b 40 04             	mov    0x4(%eax),%eax
  802907:	85 c0                	test   %eax,%eax
  802909:	74 0c                	je     802917 <alloc_block_FF+0x1e0>
  80290b:	a1 30 50 80 00       	mov    0x805030,%eax
  802910:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802913:	89 10                	mov    %edx,(%eax)
  802915:	eb 08                	jmp    80291f <alloc_block_FF+0x1e8>
  802917:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80291a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80291f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802922:	a3 30 50 80 00       	mov    %eax,0x805030
  802927:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802930:	a1 38 50 80 00       	mov    0x805038,%eax
  802935:	40                   	inc    %eax
  802936:	a3 38 50 80 00       	mov    %eax,0x805038
  80293b:	eb 6e                	jmp    8029ab <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80293d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802941:	74 06                	je     802949 <alloc_block_FF+0x212>
  802943:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802947:	75 17                	jne    802960 <alloc_block_FF+0x229>
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	68 44 4c 80 00       	push   $0x804c44
  802951:	68 df 00 00 00       	push   $0xdf
  802956:	68 d1 4b 80 00       	push   $0x804bd1
  80295b:	e8 b5 de ff ff       	call   800815 <_panic>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 10                	mov    (%eax),%edx
  802965:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0b                	je     80297e <alloc_block_FF+0x247>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%eax)
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	75 08                	jne    8029a0 <alloc_block_FF+0x269>
  802998:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299b:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a5:	40                   	inc    %eax
  8029a6:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8029ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029af:	75 17                	jne    8029c8 <alloc_block_FF+0x291>
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 b3 4b 80 00       	push   $0x804bb3
  8029b9:	68 e1 00 00 00       	push   $0xe1
  8029be:	68 d1 4b 80 00       	push   $0x804bd1
  8029c3:	e8 4d de ff ff       	call   800815 <_panic>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 10                	je     8029e1 <alloc_block_FF+0x2aa>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d9:	8b 52 04             	mov    0x4(%edx),%edx
  8029dc:	89 50 04             	mov    %edx,0x4(%eax)
  8029df:	eb 0b                	jmp    8029ec <alloc_block_FF+0x2b5>
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 0f                	je     802a05 <alloc_block_FF+0x2ce>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ff:	8b 12                	mov    (%edx),%edx
  802a01:	89 10                	mov    %edx,(%eax)
  802a03:	eb 0a                	jmp    802a0f <alloc_block_FF+0x2d8>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a22:	a1 38 50 80 00       	mov    0x805038,%eax
  802a27:	48                   	dec    %eax
  802a28:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	6a 00                	push   $0x0
  802a32:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a35:	ff 75 b0             	pushl  -0x50(%ebp)
  802a38:	e8 cb fc ff ff       	call   802708 <set_block_data>
  802a3d:	83 c4 10             	add    $0x10,%esp
  802a40:	e9 95 00 00 00       	jmp    802ada <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	6a 01                	push   $0x1
  802a4a:	ff 75 b8             	pushl  -0x48(%ebp)
  802a4d:	ff 75 bc             	pushl  -0x44(%ebp)
  802a50:	e8 b3 fc ff ff       	call   802708 <set_block_data>
  802a55:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_FF+0x33e>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 b3 4b 80 00       	push   $0x804bb3
  802a66:	68 e8 00 00 00       	push   $0xe8
  802a6b:	68 d1 4b 80 00       	push   $0x804bd1
  802a70:	e8 a0 dd ff ff       	call   800815 <_panic>
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 10                	je     802a8e <alloc_block_FF+0x357>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a86:	8b 52 04             	mov    0x4(%edx),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 0b                	jmp    802a99 <alloc_block_FF+0x362>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	a3 30 50 80 00       	mov    %eax,0x805030
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0f                	je     802ab2 <alloc_block_FF+0x37b>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aac:	8b 12                	mov    (%edx),%edx
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	eb 0a                	jmp    802abc <alloc_block_FF+0x385>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad4:	48                   	dec    %eax
  802ad5:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802ada:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802add:	e9 0f 01 00 00       	jmp    802bf1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ae2:	a1 34 50 80 00       	mov    0x805034,%eax
  802ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aee:	74 07                	je     802af7 <alloc_block_FF+0x3c0>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	eb 05                	jmp    802afc <alloc_block_FF+0x3c5>
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
  802afc:	a3 34 50 80 00       	mov    %eax,0x805034
  802b01:	a1 34 50 80 00       	mov    0x805034,%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	0f 85 e9 fc ff ff    	jne    8027f7 <alloc_block_FF+0xc0>
  802b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b12:	0f 85 df fc ff ff    	jne    8027f7 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	83 c0 08             	add    $0x8,%eax
  802b1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b21:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b2e:	01 d0                	add    %edx,%eax
  802b30:	48                   	dec    %eax
  802b31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b37:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3c:	f7 75 d8             	divl   -0x28(%ebp)
  802b3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b42:	29 d0                	sub    %edx,%eax
  802b44:	c1 e8 0c             	shr    $0xc,%eax
  802b47:	83 ec 0c             	sub    $0xc,%esp
  802b4a:	50                   	push   %eax
  802b4b:	e8 1c ed ff ff       	call   80186c <sbrk>
  802b50:	83 c4 10             	add    $0x10,%esp
  802b53:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b56:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b5a:	75 0a                	jne    802b66 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b61:	e9 8b 00 00 00       	jmp    802bf1 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b66:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b73:	01 d0                	add    %edx,%eax
  802b75:	48                   	dec    %eax
  802b76:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b79:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b81:	f7 75 cc             	divl   -0x34(%ebp)
  802b84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b87:	29 d0                	sub    %edx,%eax
  802b89:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b8f:	01 d0                	add    %edx,%eax
  802b91:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b96:	a1 40 50 80 00       	mov    0x805040,%eax
  802b9b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ba1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ba8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bae:	01 d0                	add    %edx,%eax
  802bb0:	48                   	dec    %eax
  802bb1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bb4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbc:	f7 75 c4             	divl   -0x3c(%ebp)
  802bbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bc2:	29 d0                	sub    %edx,%eax
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	6a 01                	push   $0x1
  802bc9:	50                   	push   %eax
  802bca:	ff 75 d0             	pushl  -0x30(%ebp)
  802bcd:	e8 36 fb ff ff       	call   802708 <set_block_data>
  802bd2:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802bd5:	83 ec 0c             	sub    $0xc,%esp
  802bd8:	ff 75 d0             	pushl  -0x30(%ebp)
  802bdb:	e8 1b 0a 00 00       	call   8035fb <free_block>
  802be0:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	ff 75 08             	pushl  0x8(%ebp)
  802be9:	e8 49 fb ff ff       	call   802737 <alloc_block_FF>
  802bee:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
  802bf6:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	83 e0 01             	and    $0x1,%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 03                	je     802c06 <alloc_block_BF+0x13>
  802c03:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c06:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c0a:	77 07                	ja     802c13 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c0c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c13:	a1 24 50 80 00       	mov    0x805024,%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	75 73                	jne    802c8f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	83 c0 10             	add    $0x10,%eax
  802c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c25:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	48                   	dec    %eax
  802c35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c40:	f7 75 e0             	divl   -0x20(%ebp)
  802c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c46:	29 d0                	sub    %edx,%eax
  802c48:	c1 e8 0c             	shr    $0xc,%eax
  802c4b:	83 ec 0c             	sub    $0xc,%esp
  802c4e:	50                   	push   %eax
  802c4f:	e8 18 ec ff ff       	call   80186c <sbrk>
  802c54:	83 c4 10             	add    $0x10,%esp
  802c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c5a:	83 ec 0c             	sub    $0xc,%esp
  802c5d:	6a 00                	push   $0x0
  802c5f:	e8 08 ec ff ff       	call   80186c <sbrk>
  802c64:	83 c4 10             	add    $0x10,%esp
  802c67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c6d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c70:	83 ec 08             	sub    $0x8,%esp
  802c73:	50                   	push   %eax
  802c74:	ff 75 d8             	pushl  -0x28(%ebp)
  802c77:	e8 9f f8 ff ff       	call   80251b <initialize_dynamic_allocator>
  802c7c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c7f:	83 ec 0c             	sub    $0xc,%esp
  802c82:	68 0f 4c 80 00       	push   $0x804c0f
  802c87:	e8 46 de ff ff       	call   800ad2 <cprintf>
  802c8c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c9d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ca4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802cab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb3:	e9 1d 01 00 00       	jmp    802dd5 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802cbe:	83 ec 0c             	sub    $0xc,%esp
  802cc1:	ff 75 a8             	pushl  -0x58(%ebp)
  802cc4:	e8 ee f6 ff ff       	call   8023b7 <get_block_size>
  802cc9:	83 c4 10             	add    $0x10,%esp
  802ccc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	83 c0 08             	add    $0x8,%eax
  802cd5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cd8:	0f 87 ef 00 00 00    	ja     802dcd <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	83 c0 18             	add    $0x18,%eax
  802ce4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ce7:	77 1d                	ja     802d06 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cec:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cef:	0f 86 d8 00 00 00    	jbe    802dcd <alloc_block_BF+0x1da>
				{
					best_va = va;
  802cf5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802cfb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d01:	e9 c7 00 00 00       	jmp    802dcd <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	83 c0 08             	add    $0x8,%eax
  802d0c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d0f:	0f 85 9d 00 00 00    	jne    802db2 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	6a 01                	push   $0x1
  802d1a:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d1d:	ff 75 a8             	pushl  -0x58(%ebp)
  802d20:	e8 e3 f9 ff ff       	call   802708 <set_block_data>
  802d25:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	75 17                	jne    802d45 <alloc_block_BF+0x152>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 b3 4b 80 00       	push   $0x804bb3
  802d36:	68 2c 01 00 00       	push   $0x12c
  802d3b:	68 d1 4b 80 00       	push   $0x804bd1
  802d40:	e8 d0 da ff ff       	call   800815 <_panic>
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 10                	je     802d5e <alloc_block_BF+0x16b>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d56:	8b 52 04             	mov    0x4(%edx),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 0b                	jmp    802d69 <alloc_block_BF+0x176>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	a3 30 50 80 00       	mov    %eax,0x805030
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0f                	je     802d82 <alloc_block_BF+0x18f>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7c:	8b 12                	mov    (%edx),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 0a                	jmp    802d8c <alloc_block_BF+0x199>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802da4:	48                   	dec    %eax
  802da5:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802daa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dad:	e9 24 04 00 00       	jmp    8031d6 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802db8:	76 13                	jbe    802dcd <alloc_block_BF+0x1da>
					{
						internal = 1;
  802dba:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802dc1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802dc7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802dcd:	a1 34 50 80 00       	mov    0x805034,%eax
  802dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd9:	74 07                	je     802de2 <alloc_block_BF+0x1ef>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	eb 05                	jmp    802de7 <alloc_block_BF+0x1f4>
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	a3 34 50 80 00       	mov    %eax,0x805034
  802dec:	a1 34 50 80 00       	mov    0x805034,%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	0f 85 bf fe ff ff    	jne    802cb8 <alloc_block_BF+0xc5>
  802df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfd:	0f 85 b5 fe ff ff    	jne    802cb8 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e07:	0f 84 26 02 00 00    	je     803033 <alloc_block_BF+0x440>
  802e0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e11:	0f 85 1c 02 00 00    	jne    803033 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802e1d:	83 e8 08             	sub    $0x8,%eax
  802e20:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8d 50 08             	lea    0x8(%eax),%edx
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	01 d0                	add    %edx,%eax
  802e2e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	83 c0 08             	add    $0x8,%eax
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	6a 01                	push   $0x1
  802e3c:	50                   	push   %eax
  802e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  802e40:	e8 c3 f8 ff ff       	call   802708 <set_block_data>
  802e45:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	75 68                	jne    802eba <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e52:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e56:	75 17                	jne    802e6f <alloc_block_BF+0x27c>
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	68 ec 4b 80 00       	push   $0x804bec
  802e60:	68 45 01 00 00       	push   $0x145
  802e65:	68 d1 4b 80 00       	push   $0x804bd1
  802e6a:	e8 a6 d9 ff ff       	call   800815 <_panic>
  802e6f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e78:	89 10                	mov    %edx,(%eax)
  802e7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	85 c0                	test   %eax,%eax
  802e81:	74 0d                	je     802e90 <alloc_block_BF+0x29d>
  802e83:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e88:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e8b:	89 50 04             	mov    %edx,0x4(%eax)
  802e8e:	eb 08                	jmp    802e98 <alloc_block_BF+0x2a5>
  802e90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e93:	a3 30 50 80 00       	mov    %eax,0x805030
  802e98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaa:	a1 38 50 80 00       	mov    0x805038,%eax
  802eaf:	40                   	inc    %eax
  802eb0:	a3 38 50 80 00       	mov    %eax,0x805038
  802eb5:	e9 dc 00 00 00       	jmp    802f96 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	75 65                	jne    802f28 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ec3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ec7:	75 17                	jne    802ee0 <alloc_block_BF+0x2ed>
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	68 20 4c 80 00       	push   $0x804c20
  802ed1:	68 4a 01 00 00       	push   $0x14a
  802ed6:	68 d1 4b 80 00       	push   $0x804bd1
  802edb:	e8 35 d9 ff ff       	call   800815 <_panic>
  802ee0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ee6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eef:	8b 40 04             	mov    0x4(%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0c                	je     802f02 <alloc_block_BF+0x30f>
  802ef6:	a1 30 50 80 00       	mov    0x805030,%eax
  802efb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802efe:	89 10                	mov    %edx,(%eax)
  802f00:	eb 08                	jmp    802f0a <alloc_block_BF+0x317>
  802f02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f05:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f20:	40                   	inc    %eax
  802f21:	a3 38 50 80 00       	mov    %eax,0x805038
  802f26:	eb 6e                	jmp    802f96 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2c:	74 06                	je     802f34 <alloc_block_BF+0x341>
  802f2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f32:	75 17                	jne    802f4b <alloc_block_BF+0x358>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 44 4c 80 00       	push   $0x804c44
  802f3c:	68 4f 01 00 00       	push   $0x14f
  802f41:	68 d1 4b 80 00       	push   $0x804bd1
  802f46:	e8 ca d8 ff ff       	call   800815 <_panic>
  802f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4e:	8b 10                	mov    (%eax),%edx
  802f50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f53:	89 10                	mov    %edx,(%eax)
  802f55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 0b                	je     802f69 <alloc_block_BF+0x376>
  802f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f66:	89 50 04             	mov    %edx,0x4(%eax)
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f6f:	89 10                	mov    %edx,(%eax)
  802f71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	75 08                	jne    802f8b <alloc_block_BF+0x398>
  802f83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f86:	a3 30 50 80 00       	mov    %eax,0x805030
  802f8b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f90:	40                   	inc    %eax
  802f91:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9a:	75 17                	jne    802fb3 <alloc_block_BF+0x3c0>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 b3 4b 80 00       	push   $0x804bb3
  802fa4:	68 51 01 00 00       	push   $0x151
  802fa9:	68 d1 4b 80 00       	push   $0x804bd1
  802fae:	e8 62 d8 ff ff       	call   800815 <_panic>
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 10                	je     802fcc <alloc_block_BF+0x3d9>
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc4:	8b 52 04             	mov    0x4(%edx),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 0b                	jmp    802fd7 <alloc_block_BF+0x3e4>
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0f                	je     802ff0 <alloc_block_BF+0x3fd>
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fea:	8b 12                	mov    (%edx),%edx
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	eb 0a                	jmp    802ffa <alloc_block_BF+0x407>
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 38 50 80 00       	mov    0x805038,%eax
  803012:	48                   	dec    %eax
  803013:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803018:	83 ec 04             	sub    $0x4,%esp
  80301b:	6a 00                	push   $0x0
  80301d:	ff 75 d0             	pushl  -0x30(%ebp)
  803020:	ff 75 cc             	pushl  -0x34(%ebp)
  803023:	e8 e0 f6 ff ff       	call   802708 <set_block_data>
  803028:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80302b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302e:	e9 a3 01 00 00       	jmp    8031d6 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803033:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803037:	0f 85 9d 00 00 00    	jne    8030da <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	6a 01                	push   $0x1
  803042:	ff 75 ec             	pushl  -0x14(%ebp)
  803045:	ff 75 f0             	pushl  -0x10(%ebp)
  803048:	e8 bb f6 ff ff       	call   802708 <set_block_data>
  80304d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803050:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803054:	75 17                	jne    80306d <alloc_block_BF+0x47a>
  803056:	83 ec 04             	sub    $0x4,%esp
  803059:	68 b3 4b 80 00       	push   $0x804bb3
  80305e:	68 58 01 00 00       	push   $0x158
  803063:	68 d1 4b 80 00       	push   $0x804bd1
  803068:	e8 a8 d7 ff ff       	call   800815 <_panic>
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 10                	je     803086 <alloc_block_BF+0x493>
  803076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307e:	8b 52 04             	mov    0x4(%edx),%edx
  803081:	89 50 04             	mov    %edx,0x4(%eax)
  803084:	eb 0b                	jmp    803091 <alloc_block_BF+0x49e>
  803086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	a3 30 50 80 00       	mov    %eax,0x805030
  803091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803094:	8b 40 04             	mov    0x4(%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0f                	je     8030aa <alloc_block_BF+0x4b7>
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a4:	8b 12                	mov    (%edx),%edx
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	eb 0a                	jmp    8030b4 <alloc_block_BF+0x4c1>
  8030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030cc:	48                   	dec    %eax
  8030cd:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d5:	e9 fc 00 00 00       	jmp    8031d6 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	83 c0 08             	add    $0x8,%eax
  8030e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8030e3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030f0:	01 d0                	add    %edx,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8030f6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8030fe:	f7 75 c4             	divl   -0x3c(%ebp)
  803101:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803104:	29 d0                	sub    %edx,%eax
  803106:	c1 e8 0c             	shr    $0xc,%eax
  803109:	83 ec 0c             	sub    $0xc,%esp
  80310c:	50                   	push   %eax
  80310d:	e8 5a e7 ff ff       	call   80186c <sbrk>
  803112:	83 c4 10             	add    $0x10,%esp
  803115:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803118:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80311c:	75 0a                	jne    803128 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80311e:	b8 00 00 00 00       	mov    $0x0,%eax
  803123:	e9 ae 00 00 00       	jmp    8031d6 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803128:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80312f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803132:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803135:	01 d0                	add    %edx,%eax
  803137:	48                   	dec    %eax
  803138:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80313b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80313e:	ba 00 00 00 00       	mov    $0x0,%edx
  803143:	f7 75 b8             	divl   -0x48(%ebp)
  803146:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803149:	29 d0                	sub    %edx,%eax
  80314b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80314e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803151:	01 d0                	add    %edx,%eax
  803153:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803158:	a1 40 50 80 00       	mov    0x805040,%eax
  80315d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803163:	83 ec 0c             	sub    $0xc,%esp
  803166:	68 78 4c 80 00       	push   $0x804c78
  80316b:	e8 62 d9 ff ff       	call   800ad2 <cprintf>
  803170:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803173:	83 ec 08             	sub    $0x8,%esp
  803176:	ff 75 bc             	pushl  -0x44(%ebp)
  803179:	68 7d 4c 80 00       	push   $0x804c7d
  80317e:	e8 4f d9 ff ff       	call   800ad2 <cprintf>
  803183:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803186:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80318d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803190:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803193:	01 d0                	add    %edx,%eax
  803195:	48                   	dec    %eax
  803196:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803199:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80319c:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a1:	f7 75 b0             	divl   -0x50(%ebp)
  8031a4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031a7:	29 d0                	sub    %edx,%eax
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	6a 01                	push   $0x1
  8031ae:	50                   	push   %eax
  8031af:	ff 75 bc             	pushl  -0x44(%ebp)
  8031b2:	e8 51 f5 ff ff       	call   802708 <set_block_data>
  8031b7:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8031ba:	83 ec 0c             	sub    $0xc,%esp
  8031bd:	ff 75 bc             	pushl  -0x44(%ebp)
  8031c0:	e8 36 04 00 00       	call   8035fb <free_block>
  8031c5:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8031c8:	83 ec 0c             	sub    $0xc,%esp
  8031cb:	ff 75 08             	pushl  0x8(%ebp)
  8031ce:	e8 20 fa ff ff       	call   802bf3 <alloc_block_BF>
  8031d3:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8031d6:	c9                   	leave  
  8031d7:	c3                   	ret    

008031d8 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8031d8:	55                   	push   %ebp
  8031d9:	89 e5                	mov    %esp,%ebp
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8031df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8031ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f1:	74 1e                	je     803211 <merging+0x39>
  8031f3:	ff 75 08             	pushl  0x8(%ebp)
  8031f6:	e8 bc f1 ff ff       	call   8023b7 <get_block_size>
  8031fb:	83 c4 04             	add    $0x4,%esp
  8031fe:	89 c2                	mov    %eax,%edx
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	01 d0                	add    %edx,%eax
  803205:	3b 45 10             	cmp    0x10(%ebp),%eax
  803208:	75 07                	jne    803211 <merging+0x39>
		prev_is_free = 1;
  80320a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803211:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803215:	74 1e                	je     803235 <merging+0x5d>
  803217:	ff 75 10             	pushl  0x10(%ebp)
  80321a:	e8 98 f1 ff ff       	call   8023b7 <get_block_size>
  80321f:	83 c4 04             	add    $0x4,%esp
  803222:	89 c2                	mov    %eax,%edx
  803224:	8b 45 10             	mov    0x10(%ebp),%eax
  803227:	01 d0                	add    %edx,%eax
  803229:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80322c:	75 07                	jne    803235 <merging+0x5d>
		next_is_free = 1;
  80322e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803239:	0f 84 cc 00 00 00    	je     80330b <merging+0x133>
  80323f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803243:	0f 84 c2 00 00 00    	je     80330b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803249:	ff 75 08             	pushl  0x8(%ebp)
  80324c:	e8 66 f1 ff ff       	call   8023b7 <get_block_size>
  803251:	83 c4 04             	add    $0x4,%esp
  803254:	89 c3                	mov    %eax,%ebx
  803256:	ff 75 10             	pushl  0x10(%ebp)
  803259:	e8 59 f1 ff ff       	call   8023b7 <get_block_size>
  80325e:	83 c4 04             	add    $0x4,%esp
  803261:	01 c3                	add    %eax,%ebx
  803263:	ff 75 0c             	pushl  0xc(%ebp)
  803266:	e8 4c f1 ff ff       	call   8023b7 <get_block_size>
  80326b:	83 c4 04             	add    $0x4,%esp
  80326e:	01 d8                	add    %ebx,%eax
  803270:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803273:	6a 00                	push   $0x0
  803275:	ff 75 ec             	pushl  -0x14(%ebp)
  803278:	ff 75 08             	pushl  0x8(%ebp)
  80327b:	e8 88 f4 ff ff       	call   802708 <set_block_data>
  803280:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803287:	75 17                	jne    8032a0 <merging+0xc8>
  803289:	83 ec 04             	sub    $0x4,%esp
  80328c:	68 b3 4b 80 00       	push   $0x804bb3
  803291:	68 7d 01 00 00       	push   $0x17d
  803296:	68 d1 4b 80 00       	push   $0x804bd1
  80329b:	e8 75 d5 ff ff       	call   800815 <_panic>
  8032a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 10                	je     8032b9 <merging+0xe1>
  8032a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b1:	8b 52 04             	mov    0x4(%edx),%edx
  8032b4:	89 50 04             	mov    %edx,0x4(%eax)
  8032b7:	eb 0b                	jmp    8032c4 <merging+0xec>
  8032b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 0f                	je     8032dd <merging+0x105>
  8032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d1:	8b 40 04             	mov    0x4(%eax),%eax
  8032d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d7:	8b 12                	mov    (%edx),%edx
  8032d9:	89 10                	mov    %edx,(%eax)
  8032db:	eb 0a                	jmp    8032e7 <merging+0x10f>
  8032dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ff:	48                   	dec    %eax
  803300:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803305:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803306:	e9 ea 02 00 00       	jmp    8035f5 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80330b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330f:	74 3b                	je     80334c <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803311:	83 ec 0c             	sub    $0xc,%esp
  803314:	ff 75 08             	pushl  0x8(%ebp)
  803317:	e8 9b f0 ff ff       	call   8023b7 <get_block_size>
  80331c:	83 c4 10             	add    $0x10,%esp
  80331f:	89 c3                	mov    %eax,%ebx
  803321:	83 ec 0c             	sub    $0xc,%esp
  803324:	ff 75 10             	pushl  0x10(%ebp)
  803327:	e8 8b f0 ff ff       	call   8023b7 <get_block_size>
  80332c:	83 c4 10             	add    $0x10,%esp
  80332f:	01 d8                	add    %ebx,%eax
  803331:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	6a 00                	push   $0x0
  803339:	ff 75 e8             	pushl  -0x18(%ebp)
  80333c:	ff 75 08             	pushl  0x8(%ebp)
  80333f:	e8 c4 f3 ff ff       	call   802708 <set_block_data>
  803344:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803347:	e9 a9 02 00 00       	jmp    8035f5 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80334c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803350:	0f 84 2d 01 00 00    	je     803483 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803356:	83 ec 0c             	sub    $0xc,%esp
  803359:	ff 75 10             	pushl  0x10(%ebp)
  80335c:	e8 56 f0 ff ff       	call   8023b7 <get_block_size>
  803361:	83 c4 10             	add    $0x10,%esp
  803364:	89 c3                	mov    %eax,%ebx
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	ff 75 0c             	pushl  0xc(%ebp)
  80336c:	e8 46 f0 ff ff       	call   8023b7 <get_block_size>
  803371:	83 c4 10             	add    $0x10,%esp
  803374:	01 d8                	add    %ebx,%eax
  803376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	6a 00                	push   $0x0
  80337e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803381:	ff 75 10             	pushl  0x10(%ebp)
  803384:	e8 7f f3 ff ff       	call   802708 <set_block_data>
  803389:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80338c:	8b 45 10             	mov    0x10(%ebp),%eax
  80338f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803392:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803396:	74 06                	je     80339e <merging+0x1c6>
  803398:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80339c:	75 17                	jne    8033b5 <merging+0x1dd>
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 8c 4c 80 00       	push   $0x804c8c
  8033a6:	68 8d 01 00 00       	push   $0x18d
  8033ab:	68 d1 4b 80 00       	push   $0x804bd1
  8033b0:	e8 60 d4 ff ff       	call   800815 <_panic>
  8033b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b8:	8b 50 04             	mov    0x4(%eax),%edx
  8033bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033be:	89 50 04             	mov    %edx,0x4(%eax)
  8033c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c7:	89 10                	mov    %edx,(%eax)
  8033c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	74 0d                	je     8033e0 <merging+0x208>
  8033d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	eb 08                	jmp    8033e8 <merging+0x210>
  8033e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ee:	89 50 04             	mov    %edx,0x4(%eax)
  8033f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f6:	40                   	inc    %eax
  8033f7:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8033fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803400:	75 17                	jne    803419 <merging+0x241>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 b3 4b 80 00       	push   $0x804bb3
  80340a:	68 8e 01 00 00       	push   $0x18e
  80340f:	68 d1 4b 80 00       	push   $0x804bd1
  803414:	e8 fc d3 ff ff       	call   800815 <_panic>
  803419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 10                	je     803432 <merging+0x25a>
  803422:	8b 45 0c             	mov    0xc(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342a:	8b 52 04             	mov    0x4(%edx),%edx
  80342d:	89 50 04             	mov    %edx,0x4(%eax)
  803430:	eb 0b                	jmp    80343d <merging+0x265>
  803432:	8b 45 0c             	mov    0xc(%ebp),%eax
  803435:	8b 40 04             	mov    0x4(%eax),%eax
  803438:	a3 30 50 80 00       	mov    %eax,0x805030
  80343d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803440:	8b 40 04             	mov    0x4(%eax),%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	74 0f                	je     803456 <merging+0x27e>
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	8b 40 04             	mov    0x4(%eax),%eax
  80344d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803450:	8b 12                	mov    (%edx),%edx
  803452:	89 10                	mov    %edx,(%eax)
  803454:	eb 0a                	jmp    803460 <merging+0x288>
  803456:	8b 45 0c             	mov    0xc(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803460:	8b 45 0c             	mov    0xc(%ebp),%eax
  803463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803473:	a1 38 50 80 00       	mov    0x805038,%eax
  803478:	48                   	dec    %eax
  803479:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80347e:	e9 72 01 00 00       	jmp    8035f5 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803483:	8b 45 10             	mov    0x10(%ebp),%eax
  803486:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348d:	74 79                	je     803508 <merging+0x330>
  80348f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803493:	74 73                	je     803508 <merging+0x330>
  803495:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803499:	74 06                	je     8034a1 <merging+0x2c9>
  80349b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80349f:	75 17                	jne    8034b8 <merging+0x2e0>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 44 4c 80 00       	push   $0x804c44
  8034a9:	68 94 01 00 00       	push   $0x194
  8034ae:	68 d1 4b 80 00       	push   $0x804bd1
  8034b3:	e8 5d d3 ff ff       	call   800815 <_panic>
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	8b 10                	mov    (%eax),%edx
  8034bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0b                	je     8034d6 <merging+0x2fe>
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	75 08                	jne    8034f8 <merging+0x320>
  8034f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fd:	40                   	inc    %eax
  8034fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803503:	e9 ce 00 00 00       	jmp    8035d6 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350c:	74 65                	je     803573 <merging+0x39b>
  80350e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803512:	75 17                	jne    80352b <merging+0x353>
  803514:	83 ec 04             	sub    $0x4,%esp
  803517:	68 20 4c 80 00       	push   $0x804c20
  80351c:	68 95 01 00 00       	push   $0x195
  803521:	68 d1 4b 80 00       	push   $0x804bd1
  803526:	e8 ea d2 ff ff       	call   800815 <_panic>
  80352b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803534:	89 50 04             	mov    %edx,0x4(%eax)
  803537:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353a:	8b 40 04             	mov    0x4(%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	74 0c                	je     80354d <merging+0x375>
  803541:	a1 30 50 80 00       	mov    0x805030,%eax
  803546:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	eb 08                	jmp    803555 <merging+0x37d>
  80354d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803550:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803558:	a3 30 50 80 00       	mov    %eax,0x805030
  80355d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803566:	a1 38 50 80 00       	mov    0x805038,%eax
  80356b:	40                   	inc    %eax
  80356c:	a3 38 50 80 00       	mov    %eax,0x805038
  803571:	eb 63                	jmp    8035d6 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803573:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803577:	75 17                	jne    803590 <merging+0x3b8>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 ec 4b 80 00       	push   $0x804bec
  803581:	68 98 01 00 00       	push   $0x198
  803586:	68 d1 4b 80 00       	push   $0x804bd1
  80358b:	e8 85 d2 ff ff       	call   800815 <_panic>
  803590:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803596:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 0d                	je     8035b1 <merging+0x3d9>
  8035a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 08                	jmp    8035b9 <merging+0x3e1>
  8035b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8035d6:	83 ec 0c             	sub    $0xc,%esp
  8035d9:	ff 75 10             	pushl  0x10(%ebp)
  8035dc:	e8 d6 ed ff ff       	call   8023b7 <get_block_size>
  8035e1:	83 c4 10             	add    $0x10,%esp
  8035e4:	83 ec 04             	sub    $0x4,%esp
  8035e7:	6a 00                	push   $0x0
  8035e9:	50                   	push   %eax
  8035ea:	ff 75 10             	pushl  0x10(%ebp)
  8035ed:	e8 16 f1 ff ff       	call   802708 <set_block_data>
  8035f2:	83 c4 10             	add    $0x10,%esp
	}
}
  8035f5:	90                   	nop
  8035f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    

008035fb <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
  8035fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803601:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803606:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803609:	a1 30 50 80 00       	mov    0x805030,%eax
  80360e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803611:	73 1b                	jae    80362e <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803613:	a1 30 50 80 00       	mov    0x805030,%eax
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	ff 75 08             	pushl  0x8(%ebp)
  80361e:	6a 00                	push   $0x0
  803620:	50                   	push   %eax
  803621:	e8 b2 fb ff ff       	call   8031d8 <merging>
  803626:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803629:	e9 8b 00 00 00       	jmp    8036b9 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80362e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803633:	3b 45 08             	cmp    0x8(%ebp),%eax
  803636:	76 18                	jbe    803650 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803638:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	ff 75 08             	pushl  0x8(%ebp)
  803643:	50                   	push   %eax
  803644:	6a 00                	push   $0x0
  803646:	e8 8d fb ff ff       	call   8031d8 <merging>
  80364b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80364e:	eb 69                	jmp    8036b9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803650:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803655:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803658:	eb 39                	jmp    803693 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803660:	73 29                	jae    80368b <free_block+0x90>
  803662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	3b 45 08             	cmp    0x8(%ebp),%eax
  80366a:	76 1f                	jbe    80368b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	ff 75 08             	pushl  0x8(%ebp)
  80367a:	ff 75 f0             	pushl  -0x10(%ebp)
  80367d:	ff 75 f4             	pushl  -0xc(%ebp)
  803680:	e8 53 fb ff ff       	call   8031d8 <merging>
  803685:	83 c4 10             	add    $0x10,%esp
			break;
  803688:	90                   	nop
		}
	}
}
  803689:	eb 2e                	jmp    8036b9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80368b:	a1 34 50 80 00       	mov    0x805034,%eax
  803690:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803697:	74 07                	je     8036a0 <free_block+0xa5>
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	eb 05                	jmp    8036a5 <free_block+0xaa>
  8036a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8036aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	75 a7                	jne    80365a <free_block+0x5f>
  8036b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b7:	75 a1                	jne    80365a <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036b9:	90                   	nop
  8036ba:	c9                   	leave  
  8036bb:	c3                   	ret    

008036bc <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
  8036bf:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8036c2:	ff 75 08             	pushl  0x8(%ebp)
  8036c5:	e8 ed ec ff ff       	call   8023b7 <get_block_size>
  8036ca:	83 c4 04             	add    $0x4,%esp
  8036cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8036d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8036d7:	eb 17                	jmp    8036f0 <copy_data+0x34>
  8036d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036df:	01 c2                	add    %eax,%edx
  8036e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	01 c8                	add    %ecx,%eax
  8036e9:	8a 00                	mov    (%eax),%al
  8036eb:	88 02                	mov    %al,(%edx)
  8036ed:	ff 45 fc             	incl   -0x4(%ebp)
  8036f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036f6:	72 e1                	jb     8036d9 <copy_data+0x1d>
}
  8036f8:	90                   	nop
  8036f9:	c9                   	leave  
  8036fa:	c3                   	ret    

008036fb <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8036fb:	55                   	push   %ebp
  8036fc:	89 e5                	mov    %esp,%ebp
  8036fe:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803705:	75 23                	jne    80372a <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80370b:	74 13                	je     803720 <realloc_block_FF+0x25>
  80370d:	83 ec 0c             	sub    $0xc,%esp
  803710:	ff 75 0c             	pushl  0xc(%ebp)
  803713:	e8 1f f0 ff ff       	call   802737 <alloc_block_FF>
  803718:	83 c4 10             	add    $0x10,%esp
  80371b:	e9 f4 06 00 00       	jmp    803e14 <realloc_block_FF+0x719>
		return NULL;
  803720:	b8 00 00 00 00       	mov    $0x0,%eax
  803725:	e9 ea 06 00 00       	jmp    803e14 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80372a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80372e:	75 18                	jne    803748 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803730:	83 ec 0c             	sub    $0xc,%esp
  803733:	ff 75 08             	pushl  0x8(%ebp)
  803736:	e8 c0 fe ff ff       	call   8035fb <free_block>
  80373b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80373e:	b8 00 00 00 00       	mov    $0x0,%eax
  803743:	e9 cc 06 00 00       	jmp    803e14 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803748:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80374c:	77 07                	ja     803755 <realloc_block_FF+0x5a>
  80374e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803755:	8b 45 0c             	mov    0xc(%ebp),%eax
  803758:	83 e0 01             	and    $0x1,%eax
  80375b:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80375e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803761:	83 c0 08             	add    $0x8,%eax
  803764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 08             	pushl  0x8(%ebp)
  80376d:	e8 45 ec ff ff       	call   8023b7 <get_block_size>
  803772:	83 c4 10             	add    $0x10,%esp
  803775:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377b:	83 e8 08             	sub    $0x8,%eax
  80377e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	83 e8 04             	sub    $0x4,%eax
  803787:	8b 00                	mov    (%eax),%eax
  803789:	83 e0 fe             	and    $0xfffffffe,%eax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	01 d0                	add    %edx,%eax
  803793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803796:	83 ec 0c             	sub    $0xc,%esp
  803799:	ff 75 e4             	pushl  -0x1c(%ebp)
  80379c:	e8 16 ec ff ff       	call   8023b7 <get_block_size>
  8037a1:	83 c4 10             	add    $0x10,%esp
  8037a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037aa:	83 e8 08             	sub    $0x8,%eax
  8037ad:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8037b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b6:	75 08                	jne    8037c0 <realloc_block_FF+0xc5>
	{
		 return va;
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	e9 54 06 00 00       	jmp    803e14 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8037c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037c6:	0f 83 e5 03 00 00    	jae    803bb1 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cf:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8037d5:	83 ec 0c             	sub    $0xc,%esp
  8037d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037db:	e8 f0 eb ff ff       	call   8023d0 <is_free_block>
  8037e0:	83 c4 10             	add    $0x10,%esp
  8037e3:	84 c0                	test   %al,%al
  8037e5:	0f 84 3b 01 00 00    	je     803926 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8037eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037f1:	01 d0                	add    %edx,%eax
  8037f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8037f6:	83 ec 04             	sub    $0x4,%esp
  8037f9:	6a 01                	push   $0x1
  8037fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8037fe:	ff 75 08             	pushl  0x8(%ebp)
  803801:	e8 02 ef ff ff       	call   802708 <set_block_data>
  803806:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
  80380c:	83 e8 04             	sub    $0x4,%eax
  80380f:	8b 00                	mov    (%eax),%eax
  803811:	83 e0 fe             	and    $0xfffffffe,%eax
  803814:	89 c2                	mov    %eax,%edx
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	01 d0                	add    %edx,%eax
  80381b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	6a 00                	push   $0x0
  803823:	ff 75 cc             	pushl  -0x34(%ebp)
  803826:	ff 75 c8             	pushl  -0x38(%ebp)
  803829:	e8 da ee ff ff       	call   802708 <set_block_data>
  80382e:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803831:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803835:	74 06                	je     80383d <realloc_block_FF+0x142>
  803837:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80383b:	75 17                	jne    803854 <realloc_block_FF+0x159>
  80383d:	83 ec 04             	sub    $0x4,%esp
  803840:	68 44 4c 80 00       	push   $0x804c44
  803845:	68 f6 01 00 00       	push   $0x1f6
  80384a:	68 d1 4b 80 00       	push   $0x804bd1
  80384f:	e8 c1 cf ff ff       	call   800815 <_panic>
  803854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803857:	8b 10                	mov    (%eax),%edx
  803859:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80385c:	89 10                	mov    %edx,(%eax)
  80385e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803861:	8b 00                	mov    (%eax),%eax
  803863:	85 c0                	test   %eax,%eax
  803865:	74 0b                	je     803872 <realloc_block_FF+0x177>
  803867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80386f:	89 50 04             	mov    %edx,0x4(%eax)
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803878:	89 10                	mov    %edx,(%eax)
  80387a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80387d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803880:	89 50 04             	mov    %edx,0x4(%eax)
  803883:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803886:	8b 00                	mov    (%eax),%eax
  803888:	85 c0                	test   %eax,%eax
  80388a:	75 08                	jne    803894 <realloc_block_FF+0x199>
  80388c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80388f:	a3 30 50 80 00       	mov    %eax,0x805030
  803894:	a1 38 50 80 00       	mov    0x805038,%eax
  803899:	40                   	inc    %eax
  80389a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80389f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038a3:	75 17                	jne    8038bc <realloc_block_FF+0x1c1>
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	68 b3 4b 80 00       	push   $0x804bb3
  8038ad:	68 f7 01 00 00       	push   $0x1f7
  8038b2:	68 d1 4b 80 00       	push   $0x804bd1
  8038b7:	e8 59 cf ff ff       	call   800815 <_panic>
  8038bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	85 c0                	test   %eax,%eax
  8038c3:	74 10                	je     8038d5 <realloc_block_FF+0x1da>
  8038c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038cd:	8b 52 04             	mov    0x4(%edx),%edx
  8038d0:	89 50 04             	mov    %edx,0x4(%eax)
  8038d3:	eb 0b                	jmp    8038e0 <realloc_block_FF+0x1e5>
  8038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d8:	8b 40 04             	mov    0x4(%eax),%eax
  8038db:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e3:	8b 40 04             	mov    0x4(%eax),%eax
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	74 0f                	je     8038f9 <realloc_block_FF+0x1fe>
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	8b 40 04             	mov    0x4(%eax),%eax
  8038f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f3:	8b 12                	mov    (%edx),%edx
  8038f5:	89 10                	mov    %edx,(%eax)
  8038f7:	eb 0a                	jmp    803903 <realloc_block_FF+0x208>
  8038f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803916:	a1 38 50 80 00       	mov    0x805038,%eax
  80391b:	48                   	dec    %eax
  80391c:	a3 38 50 80 00       	mov    %eax,0x805038
  803921:	e9 83 02 00 00       	jmp    803ba9 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803926:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80392a:	0f 86 69 02 00 00    	jbe    803b99 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803930:	83 ec 04             	sub    $0x4,%esp
  803933:	6a 01                	push   $0x1
  803935:	ff 75 f0             	pushl  -0x10(%ebp)
  803938:	ff 75 08             	pushl  0x8(%ebp)
  80393b:	e8 c8 ed ff ff       	call   802708 <set_block_data>
  803940:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	83 e8 04             	sub    $0x4,%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	83 e0 fe             	and    $0xfffffffe,%eax
  80394e:	89 c2                	mov    %eax,%edx
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	01 d0                	add    %edx,%eax
  803955:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803958:	a1 38 50 80 00       	mov    0x805038,%eax
  80395d:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803960:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803964:	75 68                	jne    8039ce <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803966:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80396a:	75 17                	jne    803983 <realloc_block_FF+0x288>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 ec 4b 80 00       	push   $0x804bec
  803974:	68 06 02 00 00       	push   $0x206
  803979:	68 d1 4b 80 00       	push   $0x804bd1
  80397e:	e8 92 ce ff ff       	call   800815 <_panic>
  803983:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803989:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398c:	89 10                	mov    %edx,(%eax)
  80398e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	74 0d                	je     8039a4 <realloc_block_FF+0x2a9>
  803997:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80399c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	eb 08                	jmp    8039ac <realloc_block_FF+0x2b1>
  8039a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039be:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c3:	40                   	inc    %eax
  8039c4:	a3 38 50 80 00       	mov    %eax,0x805038
  8039c9:	e9 b0 01 00 00       	jmp    803b7e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8039ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039d3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039d6:	76 68                	jbe    803a40 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039dc:	75 17                	jne    8039f5 <realloc_block_FF+0x2fa>
  8039de:	83 ec 04             	sub    $0x4,%esp
  8039e1:	68 ec 4b 80 00       	push   $0x804bec
  8039e6:	68 0b 02 00 00       	push   $0x20b
  8039eb:	68 d1 4b 80 00       	push   $0x804bd1
  8039f0:	e8 20 ce ff ff       	call   800815 <_panic>
  8039f5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039fe:	89 10                	mov    %edx,(%eax)
  803a00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	74 0d                	je     803a16 <realloc_block_FF+0x31b>
  803a09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a11:	89 50 04             	mov    %edx,0x4(%eax)
  803a14:	eb 08                	jmp    803a1e <realloc_block_FF+0x323>
  803a16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a19:	a3 30 50 80 00       	mov    %eax,0x805030
  803a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a30:	a1 38 50 80 00       	mov    0x805038,%eax
  803a35:	40                   	inc    %eax
  803a36:	a3 38 50 80 00       	mov    %eax,0x805038
  803a3b:	e9 3e 01 00 00       	jmp    803b7e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a40:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a45:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a48:	73 68                	jae    803ab2 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a4e:	75 17                	jne    803a67 <realloc_block_FF+0x36c>
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 20 4c 80 00       	push   $0x804c20
  803a58:	68 10 02 00 00       	push   $0x210
  803a5d:	68 d1 4b 80 00       	push   $0x804bd1
  803a62:	e8 ae cd ff ff       	call   800815 <_panic>
  803a67:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a70:	89 50 04             	mov    %edx,0x4(%eax)
  803a73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a76:	8b 40 04             	mov    0x4(%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 0c                	je     803a89 <realloc_block_FF+0x38e>
  803a7d:	a1 30 50 80 00       	mov    0x805030,%eax
  803a82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a85:	89 10                	mov    %edx,(%eax)
  803a87:	eb 08                	jmp    803a91 <realloc_block_FF+0x396>
  803a89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a94:	a3 30 50 80 00       	mov    %eax,0x805030
  803a99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa2:	a1 38 50 80 00       	mov    0x805038,%eax
  803aa7:	40                   	inc    %eax
  803aa8:	a3 38 50 80 00       	mov    %eax,0x805038
  803aad:	e9 cc 00 00 00       	jmp    803b7e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803ab9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac1:	e9 8a 00 00 00       	jmp    803b50 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803acc:	73 7a                	jae    803b48 <realloc_block_FF+0x44d>
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ad6:	73 70                	jae    803b48 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803adc:	74 06                	je     803ae4 <realloc_block_FF+0x3e9>
  803ade:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ae2:	75 17                	jne    803afb <realloc_block_FF+0x400>
  803ae4:	83 ec 04             	sub    $0x4,%esp
  803ae7:	68 44 4c 80 00       	push   $0x804c44
  803aec:	68 1a 02 00 00       	push   $0x21a
  803af1:	68 d1 4b 80 00       	push   $0x804bd1
  803af6:	e8 1a cd ff ff       	call   800815 <_panic>
  803afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afe:	8b 10                	mov    (%eax),%edx
  803b00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b03:	89 10                	mov    %edx,(%eax)
  803b05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	85 c0                	test   %eax,%eax
  803b0c:	74 0b                	je     803b19 <realloc_block_FF+0x41e>
  803b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b11:	8b 00                	mov    (%eax),%eax
  803b13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b16:	89 50 04             	mov    %edx,0x4(%eax)
  803b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b1f:	89 10                	mov    %edx,(%eax)
  803b21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b27:	89 50 04             	mov    %edx,0x4(%eax)
  803b2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	75 08                	jne    803b3b <realloc_block_FF+0x440>
  803b33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b36:	a3 30 50 80 00       	mov    %eax,0x805030
  803b3b:	a1 38 50 80 00       	mov    0x805038,%eax
  803b40:	40                   	inc    %eax
  803b41:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b46:	eb 36                	jmp    803b7e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b48:	a1 34 50 80 00       	mov    0x805034,%eax
  803b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b54:	74 07                	je     803b5d <realloc_block_FF+0x462>
  803b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b59:	8b 00                	mov    (%eax),%eax
  803b5b:	eb 05                	jmp    803b62 <realloc_block_FF+0x467>
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b62:	a3 34 50 80 00       	mov    %eax,0x805034
  803b67:	a1 34 50 80 00       	mov    0x805034,%eax
  803b6c:	85 c0                	test   %eax,%eax
  803b6e:	0f 85 52 ff ff ff    	jne    803ac6 <realloc_block_FF+0x3cb>
  803b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b78:	0f 85 48 ff ff ff    	jne    803ac6 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b7e:	83 ec 04             	sub    $0x4,%esp
  803b81:	6a 00                	push   $0x0
  803b83:	ff 75 d8             	pushl  -0x28(%ebp)
  803b86:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b89:	e8 7a eb ff ff       	call   802708 <set_block_data>
  803b8e:	83 c4 10             	add    $0x10,%esp
				return va;
  803b91:	8b 45 08             	mov    0x8(%ebp),%eax
  803b94:	e9 7b 02 00 00       	jmp    803e14 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b99:	83 ec 0c             	sub    $0xc,%esp
  803b9c:	68 c1 4c 80 00       	push   $0x804cc1
  803ba1:	e8 2c cf ff ff       	call   800ad2 <cprintf>
  803ba6:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bac:	e9 63 02 00 00       	jmp    803e14 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bb7:	0f 86 4d 02 00 00    	jbe    803e0a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803bbd:	83 ec 0c             	sub    $0xc,%esp
  803bc0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bc3:	e8 08 e8 ff ff       	call   8023d0 <is_free_block>
  803bc8:	83 c4 10             	add    $0x10,%esp
  803bcb:	84 c0                	test   %al,%al
  803bcd:	0f 84 37 02 00 00    	je     803e0a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803bd9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803bdc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803bdf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803be2:	76 38                	jbe    803c1c <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803be4:	83 ec 0c             	sub    $0xc,%esp
  803be7:	ff 75 08             	pushl  0x8(%ebp)
  803bea:	e8 0c fa ff ff       	call   8035fb <free_block>
  803bef:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803bf2:	83 ec 0c             	sub    $0xc,%esp
  803bf5:	ff 75 0c             	pushl  0xc(%ebp)
  803bf8:	e8 3a eb ff ff       	call   802737 <alloc_block_FF>
  803bfd:	83 c4 10             	add    $0x10,%esp
  803c00:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c03:	83 ec 08             	sub    $0x8,%esp
  803c06:	ff 75 c0             	pushl  -0x40(%ebp)
  803c09:	ff 75 08             	pushl  0x8(%ebp)
  803c0c:	e8 ab fa ff ff       	call   8036bc <copy_data>
  803c11:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c14:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c17:	e9 f8 01 00 00       	jmp    803e14 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c22:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c25:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c29:	0f 87 a0 00 00 00    	ja     803ccf <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c33:	75 17                	jne    803c4c <realloc_block_FF+0x551>
  803c35:	83 ec 04             	sub    $0x4,%esp
  803c38:	68 b3 4b 80 00       	push   $0x804bb3
  803c3d:	68 38 02 00 00       	push   $0x238
  803c42:	68 d1 4b 80 00       	push   $0x804bd1
  803c47:	e8 c9 cb ff ff       	call   800815 <_panic>
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	8b 00                	mov    (%eax),%eax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	74 10                	je     803c65 <realloc_block_FF+0x56a>
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c5d:	8b 52 04             	mov    0x4(%edx),%edx
  803c60:	89 50 04             	mov    %edx,0x4(%eax)
  803c63:	eb 0b                	jmp    803c70 <realloc_block_FF+0x575>
  803c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c68:	8b 40 04             	mov    0x4(%eax),%eax
  803c6b:	a3 30 50 80 00       	mov    %eax,0x805030
  803c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c73:	8b 40 04             	mov    0x4(%eax),%eax
  803c76:	85 c0                	test   %eax,%eax
  803c78:	74 0f                	je     803c89 <realloc_block_FF+0x58e>
  803c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7d:	8b 40 04             	mov    0x4(%eax),%eax
  803c80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c83:	8b 12                	mov    (%edx),%edx
  803c85:	89 10                	mov    %edx,(%eax)
  803c87:	eb 0a                	jmp    803c93 <realloc_block_FF+0x598>
  803c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca6:	a1 38 50 80 00       	mov    0x805038,%eax
  803cab:	48                   	dec    %eax
  803cac:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803cb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb7:	01 d0                	add    %edx,%eax
  803cb9:	83 ec 04             	sub    $0x4,%esp
  803cbc:	6a 01                	push   $0x1
  803cbe:	50                   	push   %eax
  803cbf:	ff 75 08             	pushl  0x8(%ebp)
  803cc2:	e8 41 ea ff ff       	call   802708 <set_block_data>
  803cc7:	83 c4 10             	add    $0x10,%esp
  803cca:	e9 36 01 00 00       	jmp    803e05 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ccf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cd5:	01 d0                	add    %edx,%eax
  803cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803cda:	83 ec 04             	sub    $0x4,%esp
  803cdd:	6a 01                	push   $0x1
  803cdf:	ff 75 f0             	pushl  -0x10(%ebp)
  803ce2:	ff 75 08             	pushl  0x8(%ebp)
  803ce5:	e8 1e ea ff ff       	call   802708 <set_block_data>
  803cea:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ced:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf0:	83 e8 04             	sub    $0x4,%eax
  803cf3:	8b 00                	mov    (%eax),%eax
  803cf5:	83 e0 fe             	and    $0xfffffffe,%eax
  803cf8:	89 c2                	mov    %eax,%edx
  803cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfd:	01 d0                	add    %edx,%eax
  803cff:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d06:	74 06                	je     803d0e <realloc_block_FF+0x613>
  803d08:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d0c:	75 17                	jne    803d25 <realloc_block_FF+0x62a>
  803d0e:	83 ec 04             	sub    $0x4,%esp
  803d11:	68 44 4c 80 00       	push   $0x804c44
  803d16:	68 44 02 00 00       	push   $0x244
  803d1b:	68 d1 4b 80 00       	push   $0x804bd1
  803d20:	e8 f0 ca ff ff       	call   800815 <_panic>
  803d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d28:	8b 10                	mov    (%eax),%edx
  803d2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d2d:	89 10                	mov    %edx,(%eax)
  803d2f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	85 c0                	test   %eax,%eax
  803d36:	74 0b                	je     803d43 <realloc_block_FF+0x648>
  803d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3b:	8b 00                	mov    (%eax),%eax
  803d3d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d40:	89 50 04             	mov    %edx,0x4(%eax)
  803d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d46:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d49:	89 10                	mov    %edx,(%eax)
  803d4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d51:	89 50 04             	mov    %edx,0x4(%eax)
  803d54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	85 c0                	test   %eax,%eax
  803d5b:	75 08                	jne    803d65 <realloc_block_FF+0x66a>
  803d5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d60:	a3 30 50 80 00       	mov    %eax,0x805030
  803d65:	a1 38 50 80 00       	mov    0x805038,%eax
  803d6a:	40                   	inc    %eax
  803d6b:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d74:	75 17                	jne    803d8d <realloc_block_FF+0x692>
  803d76:	83 ec 04             	sub    $0x4,%esp
  803d79:	68 b3 4b 80 00       	push   $0x804bb3
  803d7e:	68 45 02 00 00       	push   $0x245
  803d83:	68 d1 4b 80 00       	push   $0x804bd1
  803d88:	e8 88 ca ff ff       	call   800815 <_panic>
  803d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	85 c0                	test   %eax,%eax
  803d94:	74 10                	je     803da6 <realloc_block_FF+0x6ab>
  803d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d99:	8b 00                	mov    (%eax),%eax
  803d9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d9e:	8b 52 04             	mov    0x4(%edx),%edx
  803da1:	89 50 04             	mov    %edx,0x4(%eax)
  803da4:	eb 0b                	jmp    803db1 <realloc_block_FF+0x6b6>
  803da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da9:	8b 40 04             	mov    0x4(%eax),%eax
  803dac:	a3 30 50 80 00       	mov    %eax,0x805030
  803db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db4:	8b 40 04             	mov    0x4(%eax),%eax
  803db7:	85 c0                	test   %eax,%eax
  803db9:	74 0f                	je     803dca <realloc_block_FF+0x6cf>
  803dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbe:	8b 40 04             	mov    0x4(%eax),%eax
  803dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dc4:	8b 12                	mov    (%edx),%edx
  803dc6:	89 10                	mov    %edx,(%eax)
  803dc8:	eb 0a                	jmp    803dd4 <realloc_block_FF+0x6d9>
  803dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcd:	8b 00                	mov    (%eax),%eax
  803dcf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de7:	a1 38 50 80 00       	mov    0x805038,%eax
  803dec:	48                   	dec    %eax
  803ded:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803df2:	83 ec 04             	sub    $0x4,%esp
  803df5:	6a 00                	push   $0x0
  803df7:	ff 75 bc             	pushl  -0x44(%ebp)
  803dfa:	ff 75 b8             	pushl  -0x48(%ebp)
  803dfd:	e8 06 e9 ff ff       	call   802708 <set_block_data>
  803e02:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e05:	8b 45 08             	mov    0x8(%ebp),%eax
  803e08:	eb 0a                	jmp    803e14 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e0a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e14:	c9                   	leave  
  803e15:	c3                   	ret    

00803e16 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e16:	55                   	push   %ebp
  803e17:	89 e5                	mov    %esp,%ebp
  803e19:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e1c:	83 ec 04             	sub    $0x4,%esp
  803e1f:	68 c8 4c 80 00       	push   $0x804cc8
  803e24:	68 58 02 00 00       	push   $0x258
  803e29:	68 d1 4b 80 00       	push   $0x804bd1
  803e2e:	e8 e2 c9 ff ff       	call   800815 <_panic>

00803e33 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e33:	55                   	push   %ebp
  803e34:	89 e5                	mov    %esp,%ebp
  803e36:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e39:	83 ec 04             	sub    $0x4,%esp
  803e3c:	68 f0 4c 80 00       	push   $0x804cf0
  803e41:	68 61 02 00 00       	push   $0x261
  803e46:	68 d1 4b 80 00       	push   $0x804bd1
  803e4b:	e8 c5 c9 ff ff       	call   800815 <_panic>

00803e50 <__udivdi3>:
  803e50:	55                   	push   %ebp
  803e51:	57                   	push   %edi
  803e52:	56                   	push   %esi
  803e53:	53                   	push   %ebx
  803e54:	83 ec 1c             	sub    $0x1c,%esp
  803e57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e67:	89 ca                	mov    %ecx,%edx
  803e69:	89 f8                	mov    %edi,%eax
  803e6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e6f:	85 f6                	test   %esi,%esi
  803e71:	75 2d                	jne    803ea0 <__udivdi3+0x50>
  803e73:	39 cf                	cmp    %ecx,%edi
  803e75:	77 65                	ja     803edc <__udivdi3+0x8c>
  803e77:	89 fd                	mov    %edi,%ebp
  803e79:	85 ff                	test   %edi,%edi
  803e7b:	75 0b                	jne    803e88 <__udivdi3+0x38>
  803e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e82:	31 d2                	xor    %edx,%edx
  803e84:	f7 f7                	div    %edi
  803e86:	89 c5                	mov    %eax,%ebp
  803e88:	31 d2                	xor    %edx,%edx
  803e8a:	89 c8                	mov    %ecx,%eax
  803e8c:	f7 f5                	div    %ebp
  803e8e:	89 c1                	mov    %eax,%ecx
  803e90:	89 d8                	mov    %ebx,%eax
  803e92:	f7 f5                	div    %ebp
  803e94:	89 cf                	mov    %ecx,%edi
  803e96:	89 fa                	mov    %edi,%edx
  803e98:	83 c4 1c             	add    $0x1c,%esp
  803e9b:	5b                   	pop    %ebx
  803e9c:	5e                   	pop    %esi
  803e9d:	5f                   	pop    %edi
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    
  803ea0:	39 ce                	cmp    %ecx,%esi
  803ea2:	77 28                	ja     803ecc <__udivdi3+0x7c>
  803ea4:	0f bd fe             	bsr    %esi,%edi
  803ea7:	83 f7 1f             	xor    $0x1f,%edi
  803eaa:	75 40                	jne    803eec <__udivdi3+0x9c>
  803eac:	39 ce                	cmp    %ecx,%esi
  803eae:	72 0a                	jb     803eba <__udivdi3+0x6a>
  803eb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803eb4:	0f 87 9e 00 00 00    	ja     803f58 <__udivdi3+0x108>
  803eba:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebf:	89 fa                	mov    %edi,%edx
  803ec1:	83 c4 1c             	add    $0x1c,%esp
  803ec4:	5b                   	pop    %ebx
  803ec5:	5e                   	pop    %esi
  803ec6:	5f                   	pop    %edi
  803ec7:	5d                   	pop    %ebp
  803ec8:	c3                   	ret    
  803ec9:	8d 76 00             	lea    0x0(%esi),%esi
  803ecc:	31 ff                	xor    %edi,%edi
  803ece:	31 c0                	xor    %eax,%eax
  803ed0:	89 fa                	mov    %edi,%edx
  803ed2:	83 c4 1c             	add    $0x1c,%esp
  803ed5:	5b                   	pop    %ebx
  803ed6:	5e                   	pop    %esi
  803ed7:	5f                   	pop    %edi
  803ed8:	5d                   	pop    %ebp
  803ed9:	c3                   	ret    
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	89 d8                	mov    %ebx,%eax
  803ede:	f7 f7                	div    %edi
  803ee0:	31 ff                	xor    %edi,%edi
  803ee2:	89 fa                	mov    %edi,%edx
  803ee4:	83 c4 1c             	add    $0x1c,%esp
  803ee7:	5b                   	pop    %ebx
  803ee8:	5e                   	pop    %esi
  803ee9:	5f                   	pop    %edi
  803eea:	5d                   	pop    %ebp
  803eeb:	c3                   	ret    
  803eec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ef1:	89 eb                	mov    %ebp,%ebx
  803ef3:	29 fb                	sub    %edi,%ebx
  803ef5:	89 f9                	mov    %edi,%ecx
  803ef7:	d3 e6                	shl    %cl,%esi
  803ef9:	89 c5                	mov    %eax,%ebp
  803efb:	88 d9                	mov    %bl,%cl
  803efd:	d3 ed                	shr    %cl,%ebp
  803eff:	89 e9                	mov    %ebp,%ecx
  803f01:	09 f1                	or     %esi,%ecx
  803f03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f07:	89 f9                	mov    %edi,%ecx
  803f09:	d3 e0                	shl    %cl,%eax
  803f0b:	89 c5                	mov    %eax,%ebp
  803f0d:	89 d6                	mov    %edx,%esi
  803f0f:	88 d9                	mov    %bl,%cl
  803f11:	d3 ee                	shr    %cl,%esi
  803f13:	89 f9                	mov    %edi,%ecx
  803f15:	d3 e2                	shl    %cl,%edx
  803f17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f1b:	88 d9                	mov    %bl,%cl
  803f1d:	d3 e8                	shr    %cl,%eax
  803f1f:	09 c2                	or     %eax,%edx
  803f21:	89 d0                	mov    %edx,%eax
  803f23:	89 f2                	mov    %esi,%edx
  803f25:	f7 74 24 0c          	divl   0xc(%esp)
  803f29:	89 d6                	mov    %edx,%esi
  803f2b:	89 c3                	mov    %eax,%ebx
  803f2d:	f7 e5                	mul    %ebp
  803f2f:	39 d6                	cmp    %edx,%esi
  803f31:	72 19                	jb     803f4c <__udivdi3+0xfc>
  803f33:	74 0b                	je     803f40 <__udivdi3+0xf0>
  803f35:	89 d8                	mov    %ebx,%eax
  803f37:	31 ff                	xor    %edi,%edi
  803f39:	e9 58 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f3e:	66 90                	xchg   %ax,%ax
  803f40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f44:	89 f9                	mov    %edi,%ecx
  803f46:	d3 e2                	shl    %cl,%edx
  803f48:	39 c2                	cmp    %eax,%edx
  803f4a:	73 e9                	jae    803f35 <__udivdi3+0xe5>
  803f4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f4f:	31 ff                	xor    %edi,%edi
  803f51:	e9 40 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f56:	66 90                	xchg   %ax,%ax
  803f58:	31 c0                	xor    %eax,%eax
  803f5a:	e9 37 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f5f:	90                   	nop

00803f60 <__umoddi3>:
  803f60:	55                   	push   %ebp
  803f61:	57                   	push   %edi
  803f62:	56                   	push   %esi
  803f63:	53                   	push   %ebx
  803f64:	83 ec 1c             	sub    $0x1c,%esp
  803f67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f7f:	89 f3                	mov    %esi,%ebx
  803f81:	89 fa                	mov    %edi,%edx
  803f83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f87:	89 34 24             	mov    %esi,(%esp)
  803f8a:	85 c0                	test   %eax,%eax
  803f8c:	75 1a                	jne    803fa8 <__umoddi3+0x48>
  803f8e:	39 f7                	cmp    %esi,%edi
  803f90:	0f 86 a2 00 00 00    	jbe    804038 <__umoddi3+0xd8>
  803f96:	89 c8                	mov    %ecx,%eax
  803f98:	89 f2                	mov    %esi,%edx
  803f9a:	f7 f7                	div    %edi
  803f9c:	89 d0                	mov    %edx,%eax
  803f9e:	31 d2                	xor    %edx,%edx
  803fa0:	83 c4 1c             	add    $0x1c,%esp
  803fa3:	5b                   	pop    %ebx
  803fa4:	5e                   	pop    %esi
  803fa5:	5f                   	pop    %edi
  803fa6:	5d                   	pop    %ebp
  803fa7:	c3                   	ret    
  803fa8:	39 f0                	cmp    %esi,%eax
  803faa:	0f 87 ac 00 00 00    	ja     80405c <__umoddi3+0xfc>
  803fb0:	0f bd e8             	bsr    %eax,%ebp
  803fb3:	83 f5 1f             	xor    $0x1f,%ebp
  803fb6:	0f 84 ac 00 00 00    	je     804068 <__umoddi3+0x108>
  803fbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803fc1:	29 ef                	sub    %ebp,%edi
  803fc3:	89 fe                	mov    %edi,%esi
  803fc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fc9:	89 e9                	mov    %ebp,%ecx
  803fcb:	d3 e0                	shl    %cl,%eax
  803fcd:	89 d7                	mov    %edx,%edi
  803fcf:	89 f1                	mov    %esi,%ecx
  803fd1:	d3 ef                	shr    %cl,%edi
  803fd3:	09 c7                	or     %eax,%edi
  803fd5:	89 e9                	mov    %ebp,%ecx
  803fd7:	d3 e2                	shl    %cl,%edx
  803fd9:	89 14 24             	mov    %edx,(%esp)
  803fdc:	89 d8                	mov    %ebx,%eax
  803fde:	d3 e0                	shl    %cl,%eax
  803fe0:	89 c2                	mov    %eax,%edx
  803fe2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fe6:	d3 e0                	shl    %cl,%eax
  803fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff0:	89 f1                	mov    %esi,%ecx
  803ff2:	d3 e8                	shr    %cl,%eax
  803ff4:	09 d0                	or     %edx,%eax
  803ff6:	d3 eb                	shr    %cl,%ebx
  803ff8:	89 da                	mov    %ebx,%edx
  803ffa:	f7 f7                	div    %edi
  803ffc:	89 d3                	mov    %edx,%ebx
  803ffe:	f7 24 24             	mull   (%esp)
  804001:	89 c6                	mov    %eax,%esi
  804003:	89 d1                	mov    %edx,%ecx
  804005:	39 d3                	cmp    %edx,%ebx
  804007:	0f 82 87 00 00 00    	jb     804094 <__umoddi3+0x134>
  80400d:	0f 84 91 00 00 00    	je     8040a4 <__umoddi3+0x144>
  804013:	8b 54 24 04          	mov    0x4(%esp),%edx
  804017:	29 f2                	sub    %esi,%edx
  804019:	19 cb                	sbb    %ecx,%ebx
  80401b:	89 d8                	mov    %ebx,%eax
  80401d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804021:	d3 e0                	shl    %cl,%eax
  804023:	89 e9                	mov    %ebp,%ecx
  804025:	d3 ea                	shr    %cl,%edx
  804027:	09 d0                	or     %edx,%eax
  804029:	89 e9                	mov    %ebp,%ecx
  80402b:	d3 eb                	shr    %cl,%ebx
  80402d:	89 da                	mov    %ebx,%edx
  80402f:	83 c4 1c             	add    $0x1c,%esp
  804032:	5b                   	pop    %ebx
  804033:	5e                   	pop    %esi
  804034:	5f                   	pop    %edi
  804035:	5d                   	pop    %ebp
  804036:	c3                   	ret    
  804037:	90                   	nop
  804038:	89 fd                	mov    %edi,%ebp
  80403a:	85 ff                	test   %edi,%edi
  80403c:	75 0b                	jne    804049 <__umoddi3+0xe9>
  80403e:	b8 01 00 00 00       	mov    $0x1,%eax
  804043:	31 d2                	xor    %edx,%edx
  804045:	f7 f7                	div    %edi
  804047:	89 c5                	mov    %eax,%ebp
  804049:	89 f0                	mov    %esi,%eax
  80404b:	31 d2                	xor    %edx,%edx
  80404d:	f7 f5                	div    %ebp
  80404f:	89 c8                	mov    %ecx,%eax
  804051:	f7 f5                	div    %ebp
  804053:	89 d0                	mov    %edx,%eax
  804055:	e9 44 ff ff ff       	jmp    803f9e <__umoddi3+0x3e>
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	89 c8                	mov    %ecx,%eax
  80405e:	89 f2                	mov    %esi,%edx
  804060:	83 c4 1c             	add    $0x1c,%esp
  804063:	5b                   	pop    %ebx
  804064:	5e                   	pop    %esi
  804065:	5f                   	pop    %edi
  804066:	5d                   	pop    %ebp
  804067:	c3                   	ret    
  804068:	3b 04 24             	cmp    (%esp),%eax
  80406b:	72 06                	jb     804073 <__umoddi3+0x113>
  80406d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804071:	77 0f                	ja     804082 <__umoddi3+0x122>
  804073:	89 f2                	mov    %esi,%edx
  804075:	29 f9                	sub    %edi,%ecx
  804077:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80407b:	89 14 24             	mov    %edx,(%esp)
  80407e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804082:	8b 44 24 04          	mov    0x4(%esp),%eax
  804086:	8b 14 24             	mov    (%esp),%edx
  804089:	83 c4 1c             	add    $0x1c,%esp
  80408c:	5b                   	pop    %ebx
  80408d:	5e                   	pop    %esi
  80408e:	5f                   	pop    %edi
  80408f:	5d                   	pop    %ebp
  804090:	c3                   	ret    
  804091:	8d 76 00             	lea    0x0(%esi),%esi
  804094:	2b 04 24             	sub    (%esp),%eax
  804097:	19 fa                	sbb    %edi,%edx
  804099:	89 d1                	mov    %edx,%ecx
  80409b:	89 c6                	mov    %eax,%esi
  80409d:	e9 71 ff ff ff       	jmp    804013 <__umoddi3+0xb3>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040a8:	72 ea                	jb     804094 <__umoddi3+0x134>
  8040aa:	89 d9                	mov    %ebx,%ecx
  8040ac:	e9 62 ff ff ff       	jmp    804013 <__umoddi3+0xb3>
