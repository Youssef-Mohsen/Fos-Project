
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
  80005c:	68 40 41 80 00       	push   $0x804140
  800061:	6a 13                	push   $0x13
  800063:	68 5c 41 80 00       	push   $0x80415c
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
  800085:	68 74 41 80 00       	push   $0x804174
  80008a:	e8 43 0a 00 00       	call   800ad2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 a8 41 80 00       	push   $0x8041a8
  80009a:	e8 33 0a 00 00       	call   800ad2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 04 42 80 00       	push   $0x804204
  8000aa:	e8 23 0a 00 00       	call   800ad2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 aa 1f 00 00       	call   80206f <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 38 42 80 00       	push   $0x804238
  8000d0:	e8 fd 09 00 00       	call   800ad2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 e2 1d 00 00       	call   801ebf <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 6c 42 80 00       	push   $0x80426c
  8000ef:	e8 ac 1a 00 00       	call   801ba0 <smalloc>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800100:	74 17                	je     800119 <_main+0xe1>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 70 42 80 00       	push   $0x804270
  800111:	e8 bc 09 00 00       	call   800ad2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 97 1d 00 00       	call   801ebf <sys_calculate_free_frames>
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
  80014c:	e8 6e 1d 00 00       	call   801ebf <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 dc 42 80 00       	push   $0x8042dc
  800161:	e8 6c 09 00 00       	call   800ad2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
		cprintf("50\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 74 43 80 00       	push   $0x804374
  800171:	e8 5c 09 00 00       	call   800ad2 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
		sfree(x);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 69 1b 00 00       	call   801ced <sfree>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("52\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 78 43 80 00       	push   $0x804378
  80018f:	e8 3e 09 00 00       	call   800ad2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800197:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80019e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a1:	e8 19 1d 00 00       	call   801ebf <sys_calculate_free_frames>
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
  8001bf:	e8 fb 1c 00 00       	call   801ebf <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001cf:	68 7c 43 80 00       	push   $0x80437c
  8001d4:	e8 f9 08 00 00       	call   800ad2 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c7 43 80 00       	push   $0x8043c7
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
  800200:	68 e0 43 80 00       	push   $0x8043e0
  800205:	e8 c8 08 00 00       	call   800ad2 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  80020d:	e8 ad 1c 00 00       	call   801ebf <sys_calculate_free_frames>
  800212:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	6a 01                	push   $0x1
  80021a:	68 00 10 00 00       	push   $0x1000
  80021f:	68 15 44 80 00       	push   $0x804415
  800224:	e8 77 19 00 00       	call   801ba0 <smalloc>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	6a 01                	push   $0x1
  800234:	68 00 10 00 00       	push   $0x1000
  800239:	68 6c 42 80 00       	push   $0x80426c
  80023e:	e8 5d 19 00 00       	call   801ba0 <smalloc>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800249:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80024d:	75 17                	jne    800266 <_main+0x22e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 18 44 80 00       	push   $0x804418
  80025e:	e8 6f 08 00 00       	call   800ad2 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800266:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80026d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800270:	e8 4a 1c 00 00       	call   801ebf <sys_calculate_free_frames>
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
  800299:	68 70 44 80 00       	push   $0x804470
  80029e:	e8 2f 08 00 00       	call   800ad2 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ac:	e8 3c 1a 00 00       	call   801ced <sfree>
  8002b1:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8002b4:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002be:	e8 fc 1b 00 00       	call   801ebf <sys_calculate_free_frames>
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
  8002dc:	e8 de 1b 00 00       	call   801ebf <sys_calculate_free_frames>
  8002e1:	29 c3                	sub    %eax,%ebx
  8002e3:	89 d8                	mov    %ebx,%eax
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ec:	68 7c 43 80 00       	push   $0x80437c
  8002f1:	e8 dc 07 00 00       	call   800ad2 <cprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ff:	e8 e9 19 00 00       	call   801ced <sfree>
  800304:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  800307:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80030e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800311:	e8 a9 1b 00 00       	call   801ebf <sys_calculate_free_frames>
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
  80032f:	e8 8b 1b 00 00       	call   801ebf <sys_calculate_free_frames>
  800334:	29 c3                	sub    %eax,%ebx
  800336:	89 d8                	mov    %ebx,%eax
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	50                   	push   %eax
  80033c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033f:	68 7c 43 80 00       	push   $0x80437c
  800344:	e8 89 07 00 00       	call   800ad2 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 c5 44 80 00       	push   $0x8044c5
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
  800370:	68 dc 44 80 00       	push   $0x8044dc
  800375:	e8 58 07 00 00       	call   800ad2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80037d:	e8 3d 1b 00 00       	call   801ebf <sys_calculate_free_frames>
  800382:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	6a 01                	push   $0x1
  80038a:	68 01 30 00 00       	push   $0x3001
  80038f:	68 11 45 80 00       	push   $0x804511
  800394:	e8 07 18 00 00       	call   801ba0 <smalloc>
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	6a 01                	push   $0x1
  8003a4:	68 00 10 00 00       	push   $0x1000
  8003a9:	68 13 45 80 00       	push   $0x804513
  8003ae:	e8 ed 17 00 00       	call   801ba0 <smalloc>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  8003b9:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003c0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003c3:	e8 f7 1a 00 00       	call   801ebf <sys_calculate_free_frames>
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
  8003ec:	e8 ce 1a 00 00       	call   801ebf <sys_calculate_free_frames>
  8003f1:	29 c3                	sub    %eax,%ebx
  8003f3:	89 d8                	mov    %ebx,%eax
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003fb:	50                   	push   %eax
  8003fc:	68 dc 42 80 00       	push   $0x8042dc
  800401:	e8 cc 06 00 00       	call   800ad2 <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	ff 75 bc             	pushl  -0x44(%ebp)
  80040f:	e8 d9 18 00 00       	call   801ced <sfree>
  800414:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800417:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80041e:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800421:	e8 99 1a 00 00       	call   801ebf <sys_calculate_free_frames>
  800426:	29 c3                	sub    %eax,%ebx
  800428:	89 d8                	mov    %ebx,%eax
  80042a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80042d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800430:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800433:	74 27                	je     80045c <_main+0x424>
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80043f:	e8 7b 1a 00 00       	call   801ebf <sys_calculate_free_frames>
  800444:	29 c3                	sub    %eax,%ebx
  800446:	89 d8                	mov    %ebx,%eax
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80044f:	68 7c 43 80 00       	push   $0x80437c
  800454:	e8 79 06 00 00       	call   800ad2 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	6a 01                	push   $0x1
  800461:	68 ff 1f 00 00       	push   $0x1fff
  800466:	68 15 45 80 00       	push   $0x804515
  80046b:	e8 30 17 00 00       	call   801ba0 <smalloc>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800476:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80047d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800480:	e8 3a 1a 00 00       	call   801ebf <sys_calculate_free_frames>
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
  80049e:	e8 1c 1a 00 00       	call   801ebf <sys_calculate_free_frames>
  8004a3:	29 c3                	sub    %eax,%ebx
  8004a5:	89 d8                	mov    %ebx,%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 dc 42 80 00       	push   $0x8042dc
  8004b3:	e8 1a 06 00 00       	call   800ad2 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004c1:	e8 27 18 00 00       	call   801ced <sfree>
  8004c6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004c9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004d0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d3:	e8 e7 19 00 00       	call   801ebf <sys_calculate_free_frames>
  8004d8:	29 c3                	sub    %eax,%ebx
  8004da:	89 d8                	mov    %ebx,%eax
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004e5:	74 27                	je     80050e <_main+0x4d6>
  8004e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ee:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004f1:	e8 c9 19 00 00       	call   801ebf <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 d4             	pushl  -0x2c(%ebp)
  800501:	68 7c 43 80 00       	push   $0x80437c
  800506:	e8 c7 05 00 00       	call   800ad2 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	ff 75 b8             	pushl  -0x48(%ebp)
  800514:	e8 d4 17 00 00       	call   801ced <sfree>
  800519:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  80051c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800523:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800526:	e8 94 19 00 00       	call   801ebf <sys_calculate_free_frames>
  80052b:	29 c3                	sub    %eax,%ebx
  80052d:	89 d8                	mov    %ebx,%eax
  80052f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800538:	74 27                	je     800561 <_main+0x529>
  80053a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800541:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800544:	e8 76 19 00 00       	call   801ebf <sys_calculate_free_frames>
  800549:	29 c3                	sub    %eax,%ebx
  80054b:	89 d8                	mov    %ebx,%eax
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	50                   	push   %eax
  800551:	ff 75 d4             	pushl  -0x2c(%ebp)
  800554:	68 7c 43 80 00       	push   $0x80437c
  800559:	e8 74 05 00 00       	call   800ad2 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800561:	e8 59 19 00 00       	call   801ebf <sys_calculate_free_frames>
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
  80057b:	68 11 45 80 00       	push   $0x804511
  800580:	e8 1b 16 00 00       	call   801ba0 <smalloc>
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
  8005a1:	68 13 45 80 00       	push   $0x804513
  8005a6:	e8 f5 15 00 00       	call   801ba0 <smalloc>
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
  8005c3:	68 15 45 80 00       	push   $0x804515
  8005c8:	e8 d3 15 00 00       	call   801ba0 <smalloc>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005d3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005da:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005dd:	e8 dd 18 00 00       	call   801ebf <sys_calculate_free_frames>
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
  800606:	e8 b4 18 00 00       	call   801ebf <sys_calculate_free_frames>
  80060b:	29 c3                	sub    %eax,%ebx
  80060d:	89 d8                	mov    %ebx,%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 d4             	pushl  -0x2c(%ebp)
  800615:	50                   	push   %eax
  800616:	68 dc 42 80 00       	push   $0x8042dc
  80061b:	e8 b2 04 00 00       	call   800ad2 <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800623:	e8 97 18 00 00       	call   801ebf <sys_calculate_free_frames>
  800628:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800631:	e8 b7 16 00 00       	call   801ced <sfree>
  800636:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	ff 75 bc             	pushl  -0x44(%ebp)
  80063f:	e8 a9 16 00 00       	call   801ced <sfree>
  800644:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	ff 75 b8             	pushl  -0x48(%ebp)
  80064d:	e8 9b 16 00 00       	call   801ced <sfree>
  800652:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800655:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80065c:	e8 5e 18 00 00       	call   801ebf <sys_calculate_free_frames>
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
  80067f:	e8 3b 18 00 00       	call   801ebf <sys_calculate_free_frames>
  800684:	29 c3                	sub    %eax,%ebx
  800686:	89 d8                	mov    %ebx,%eax
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80068f:	68 7c 43 80 00       	push   $0x80437c
  800694:	e8 39 04 00 00       	call   800ad2 <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	68 17 45 80 00       	push   $0x804517
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
  8006c3:	68 30 45 80 00       	push   $0x804530
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
  8006dc:	e8 a7 19 00 00       	call   802088 <sys_getenvindex>
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
  80074a:	e8 bd 16 00 00       	call   801e0c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	68 84 45 80 00       	push   $0x804584
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
  80077a:	68 ac 45 80 00       	push   $0x8045ac
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
  8007ab:	68 d4 45 80 00       	push   $0x8045d4
  8007b0:	e8 1d 03 00 00       	call   800ad2 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	50                   	push   %eax
  8007c7:	68 2c 46 80 00       	push   $0x80462c
  8007cc:	e8 01 03 00 00       	call   800ad2 <cprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	68 84 45 80 00       	push   $0x804584
  8007dc:	e8 f1 02 00 00       	call   800ad2 <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007e4:	e8 3d 16 00 00       	call   801e26 <sys_unlock_cons>
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
  8007fc:	e8 53 18 00 00       	call   802054 <sys_destroy_env>
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
  80080d:	e8 a8 18 00 00       	call   8020ba <sys_exit_env>
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
  800836:	68 40 46 80 00       	push   $0x804640
  80083b:	e8 92 02 00 00       	call   800ad2 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800843:	a1 00 50 80 00       	mov    0x805000,%eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	50                   	push   %eax
  80084f:	68 45 46 80 00       	push   $0x804645
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
  800873:	68 61 46 80 00       	push   $0x804661
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
  8008a2:	68 64 46 80 00       	push   $0x804664
  8008a7:	6a 26                	push   $0x26
  8008a9:	68 b0 46 80 00       	push   $0x8046b0
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
  800977:	68 bc 46 80 00       	push   $0x8046bc
  80097c:	6a 3a                	push   $0x3a
  80097e:	68 b0 46 80 00       	push   $0x8046b0
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
  8009ea:	68 10 47 80 00       	push   $0x804710
  8009ef:	6a 44                	push   $0x44
  8009f1:	68 b0 46 80 00       	push   $0x8046b0
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
  800a44:	e8 81 13 00 00       	call   801dca <sys_cputs>
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
  800abb:	e8 0a 13 00 00       	call   801dca <sys_cputs>
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
  800b05:	e8 02 13 00 00       	call   801e0c <sys_lock_cons>
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
  800b25:	e8 fc 12 00 00       	call   801e26 <sys_unlock_cons>
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
  800b6f:	e8 58 33 00 00       	call   803ecc <__udivdi3>
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
  800bbf:	e8 18 34 00 00       	call   803fdc <__umoddi3>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	05 74 49 80 00       	add    $0x804974,%eax
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
  800d1a:	8b 04 85 98 49 80 00 	mov    0x804998(,%eax,4),%eax
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
  800dfb:	8b 34 9d e0 47 80 00 	mov    0x8047e0(,%ebx,4),%esi
  800e02:	85 f6                	test   %esi,%esi
  800e04:	75 19                	jne    800e1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e06:	53                   	push   %ebx
  800e07:	68 85 49 80 00       	push   $0x804985
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
  800e20:	68 8e 49 80 00       	push   $0x80498e
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
  800e4d:	be 91 49 80 00       	mov    $0x804991,%esi
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
  801858:	68 08 4b 80 00       	push   $0x804b08
  80185d:	68 3f 01 00 00       	push   $0x13f
  801862:	68 2a 4b 80 00       	push   $0x804b2a
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
  801878:	e8 f8 0a 00 00       	call   802375 <sys_sbrk>
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
  8018f3:	e8 01 09 00 00       	call   8021f9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 16                	je     801912 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 dd 0e 00 00       	call   8027e4 <alloc_block_FF>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190d:	e9 8a 01 00 00       	jmp    801a9c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801912:	e8 13 09 00 00       	call   80222a <sys_isUHeapPlacementStrategyBESTFIT>
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 84 7d 01 00 00    	je     801a9c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 76 13 00 00       	call   802ca0 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801987:	05 00 10 00 00       	add    $0x1000,%eax
  80198c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80198f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a33:	75 16                	jne    801a4b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801a35:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801a3c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801a43:	0f 86 15 ff ff ff    	jbe    80195e <malloc+0xdc>
  801a49:	eb 01                	jmp    801a4c <malloc+0x1ca>
				}
				

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
  801a8b:	e8 1c 09 00 00       	call   8023ac <sys_allocate_user_mem>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	eb 07                	jmp    801a9c <malloc+0x21a>
		
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
  801ad3:	e8 8c 09 00 00       	call   802464 <get_block_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 9c 1b 00 00       	call   803685 <free_block>
  801ae9:	83 c4 10             	add    $0x10,%esp
		}

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
  801b38:	eb 42                	jmp    801b7c <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  801b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	e8 1a 08 00 00       	call   802390 <sys_free_user_mem>
  801b76:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801b79:	ff 45 f4             	incl   -0xc(%ebp)
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b82:	72 b6                	jb     801b3a <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801b84:	eb 17                	jmp    801b9d <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	68 38 4b 80 00       	push   $0x804b38
  801b8e:	68 87 00 00 00       	push   $0x87
  801b93:	68 62 4b 80 00       	push   $0x804b62
  801b98:	e8 78 ec ff ff       	call   800815 <_panic>
	}
}
  801b9d:	90                   	nop
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 28             	sub    $0x28,%esp
  801ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb0:	75 0a                	jne    801bbc <smalloc+0x1c>
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb7:	e9 87 00 00 00       	jmp    801c43 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcf:	39 d0                	cmp    %edx,%eax
  801bd1:	73 02                	jae    801bd5 <smalloc+0x35>
  801bd3:	89 d0                	mov    %edx,%eax
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	50                   	push   %eax
  801bd9:	e8 a4 fc ff ff       	call   801882 <malloc>
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801be4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801be8:	75 07                	jne    801bf1 <smalloc+0x51>
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	eb 52                	jmp    801c43 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bf1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bf5:	ff 75 ec             	pushl  -0x14(%ebp)
  801bf8:	50                   	push   %eax
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	e8 93 03 00 00       	call   801f97 <sys_createSharedObject>
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801c0a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801c0e:	74 06                	je     801c16 <smalloc+0x76>
  801c10:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801c14:	75 07                	jne    801c1d <smalloc+0x7d>
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1b:	eb 26                	jmp    801c43 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801c1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c20:	a1 20 50 80 00       	mov    0x805020,%eax
  801c25:	8b 40 78             	mov    0x78(%eax),%eax
  801c28:	29 c2                	sub    %eax,%edx
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c31:	c1 e8 0c             	shr    $0xc,%eax
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c39:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	e8 68 03 00 00       	call   801fc1 <sys_getSizeOfSharedObject>
  801c59:	83 c4 10             	add    $0x10,%esp
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c5f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c63:	75 07                	jne    801c6c <sget+0x27>
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	eb 7f                	jmp    801ceb <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c72:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7f:	39 d0                	cmp    %edx,%eax
  801c81:	73 02                	jae    801c85 <sget+0x40>
  801c83:	89 d0                	mov    %edx,%eax
  801c85:	83 ec 0c             	sub    $0xc,%esp
  801c88:	50                   	push   %eax
  801c89:	e8 f4 fb ff ff       	call   801882 <malloc>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c98:	75 07                	jne    801ca1 <sget+0x5c>
  801c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9f:	eb 4a                	jmp    801ceb <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ca7:	ff 75 0c             	pushl  0xc(%ebp)
  801caa:	ff 75 08             	pushl  0x8(%ebp)
  801cad:	e8 2c 03 00 00       	call   801fde <sys_getSharedObject>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801cb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbb:	a1 20 50 80 00       	mov    0x805020,%eax
  801cc0:	8b 40 78             	mov    0x78(%eax),%eax
  801cc3:	29 c2                	sub    %eax,%edx
  801cc5:	89 d0                	mov    %edx,%eax
  801cc7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ccc:	c1 e8 0c             	shr    $0xc,%eax
  801ccf:	89 c2                	mov    %eax,%edx
  801cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801cdb:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801cdf:	75 07                	jne    801ce8 <sget+0xa3>
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	eb 03                	jmp    801ceb <sget+0xa6>
	return ptr;
  801ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf6:	a1 20 50 80 00       	mov    0x805020,%eax
  801cfb:	8b 40 78             	mov    0x78(%eax),%eax
  801cfe:	29 c2                	sub    %eax,%edx
  801d00:	89 d0                	mov    %edx,%eax
  801d02:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d07:	c1 e8 0c             	shr    $0xc,%eax
  801d0a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	ff 75 08             	pushl  0x8(%ebp)
  801d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1d:	e8 db 02 00 00       	call   801ffd <sys_freeSharedObject>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801d28:	90                   	nop
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	68 70 4b 80 00       	push   $0x804b70
  801d39:	68 e4 00 00 00       	push   $0xe4
  801d3e:	68 62 4b 80 00       	push   $0x804b62
  801d43:	e8 cd ea ff ff       	call   800815 <_panic>

00801d48 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	68 96 4b 80 00       	push   $0x804b96
  801d56:	68 f0 00 00 00       	push   $0xf0
  801d5b:	68 62 4b 80 00       	push   $0x804b62
  801d60:	e8 b0 ea ff ff       	call   800815 <_panic>

00801d65 <shrink>:

}
void shrink(uint32 newSize)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	68 96 4b 80 00       	push   $0x804b96
  801d73:	68 f5 00 00 00       	push   $0xf5
  801d78:	68 62 4b 80 00       	push   $0x804b62
  801d7d:	e8 93 ea ff ff       	call   800815 <_panic>

00801d82 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	68 96 4b 80 00       	push   $0x804b96
  801d90:	68 fa 00 00 00       	push   $0xfa
  801d95:	68 62 4b 80 00       	push   $0x804b62
  801d9a:	e8 76 ea ff ff       	call   800815 <_panic>

00801d9f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	57                   	push   %edi
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801db7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dba:	cd 30                	int    $0x30
  801dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5f                   	pop    %edi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dd6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	52                   	push   %edx
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	50                   	push   %eax
  801de6:	6a 00                	push   $0x0
  801de8:	e8 b2 ff ff ff       	call   801d9f <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 02                	push   $0x2
  801e02:	e8 98 ff ff ff       	call   801d9f <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 03                	push   $0x3
  801e1b:	e8 7f ff ff ff       	call   801d9f <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 04                	push   $0x4
  801e35:	e8 65 ff ff ff       	call   801d9f <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 08                	push   $0x8
  801e53:	e8 47 ff ff ff       	call   801d9f <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e62:	8b 75 18             	mov    0x18(%ebp),%esi
  801e65:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	56                   	push   %esi
  801e72:	53                   	push   %ebx
  801e73:	51                   	push   %ecx
  801e74:	52                   	push   %edx
  801e75:	50                   	push   %eax
  801e76:	6a 09                	push   $0x9
  801e78:	e8 22 ff ff ff       	call   801d9f <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    

00801e87 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	52                   	push   %edx
  801e97:	50                   	push   %eax
  801e98:	6a 0a                	push   $0xa
  801e9a:	e8 00 ff ff ff       	call   801d9f <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	ff 75 0c             	pushl  0xc(%ebp)
  801eb0:	ff 75 08             	pushl  0x8(%ebp)
  801eb3:	6a 0b                	push   $0xb
  801eb5:	e8 e5 fe ff ff       	call   801d9f <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 0c                	push   $0xc
  801ece:	e8 cc fe ff ff       	call   801d9f <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 0d                	push   $0xd
  801ee7:	e8 b3 fe ff ff       	call   801d9f <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 0e                	push   $0xe
  801f00:	e8 9a fe ff ff       	call   801d9f <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 0f                	push   $0xf
  801f19:	e8 81 fe ff ff       	call   801d9f <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	6a 10                	push   $0x10
  801f33:	e8 67 fe ff ff       	call   801d9f <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 11                	push   $0x11
  801f4c:	e8 4e fe ff ff       	call   801d9f <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	90                   	nop
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	50                   	push   %eax
  801f70:	6a 01                	push   $0x1
  801f72:	e8 28 fe ff ff       	call   801d9f <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	90                   	nop
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 14                	push   $0x14
  801f8c:	e8 0e fe ff ff       	call   801d9f <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	90                   	nop
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fa3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fa6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	51                   	push   %ecx
  801fb0:	52                   	push   %edx
  801fb1:	ff 75 0c             	pushl  0xc(%ebp)
  801fb4:	50                   	push   %eax
  801fb5:	6a 15                	push   $0x15
  801fb7:	e8 e3 fd ff ff       	call   801d9f <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	52                   	push   %edx
  801fd1:	50                   	push   %eax
  801fd2:	6a 16                	push   $0x16
  801fd4:	e8 c6 fd ff ff       	call   801d9f <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	51                   	push   %ecx
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 17                	push   $0x17
  801ff3:	e8 a7 fd ff ff       	call   801d9f <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802000:	8b 55 0c             	mov    0xc(%ebp),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	52                   	push   %edx
  80200d:	50                   	push   %eax
  80200e:	6a 18                	push   $0x18
  802010:	e8 8a fd ff ff       	call   801d9f <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	ff 75 14             	pushl  0x14(%ebp)
  802025:	ff 75 10             	pushl  0x10(%ebp)
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	50                   	push   %eax
  80202c:	6a 19                	push   $0x19
  80202e:	e8 6c fd ff ff       	call   801d9f <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	50                   	push   %eax
  802047:	6a 1a                	push   $0x1a
  802049:	e8 51 fd ff ff       	call   801d9f <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
}
  802051:	90                   	nop
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	50                   	push   %eax
  802063:	6a 1b                	push   $0x1b
  802065:	e8 35 fd ff ff       	call   801d9f <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 05                	push   $0x5
  80207e:	e8 1c fd ff ff       	call   801d9f <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 06                	push   $0x6
  802097:	e8 03 fd ff ff       	call   801d9f <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 07                	push   $0x7
  8020b0:	e8 ea fc ff ff       	call   801d9f <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_exit_env>:


void sys_exit_env(void)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 1c                	push   $0x1c
  8020c9:	e8 d1 fc ff ff       	call   801d9f <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020dd:	8d 50 04             	lea    0x4(%eax),%edx
  8020e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	52                   	push   %edx
  8020ea:	50                   	push   %eax
  8020eb:	6a 1d                	push   $0x1d
  8020ed:	e8 ad fc ff ff       	call   801d9f <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020fe:	89 01                	mov    %eax,(%ecx)
  802100:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	c9                   	leave  
  802107:	c2 04 00             	ret    $0x4

0080210a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	ff 75 10             	pushl  0x10(%ebp)
  802114:	ff 75 0c             	pushl  0xc(%ebp)
  802117:	ff 75 08             	pushl  0x8(%ebp)
  80211a:	6a 13                	push   $0x13
  80211c:	e8 7e fc ff ff       	call   801d9f <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return ;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_rcr2>:
uint32 sys_rcr2()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 1e                	push   $0x1e
  802136:	e8 64 fc ff ff       	call   801d9f <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	50                   	push   %eax
  802159:	6a 1f                	push   $0x1f
  80215b:	e8 3f fc ff ff       	call   801d9f <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
	return ;
  802163:	90                   	nop
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <rsttst>:
void rsttst()
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 21                	push   $0x21
  802175:	e8 25 fc ff ff       	call   801d9f <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
	return ;
  80217d:	90                   	nop
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	8b 45 14             	mov    0x14(%ebp),%eax
  802189:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218c:	8b 55 18             	mov    0x18(%ebp),%edx
  80218f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	ff 75 10             	pushl  0x10(%ebp)
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	6a 20                	push   $0x20
  8021a0:	e8 fa fb ff ff       	call   801d9f <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a8:	90                   	nop
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <chktst>:
void chktst(uint32 n)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	ff 75 08             	pushl  0x8(%ebp)
  8021b9:	6a 22                	push   $0x22
  8021bb:	e8 df fb ff ff       	call   801d9f <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c3:	90                   	nop
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <inctst>:

void inctst()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 23                	push   $0x23
  8021d5:	e8 c5 fb ff ff       	call   801d9f <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dd:	90                   	nop
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <gettst>:
uint32 gettst()
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 24                	push   $0x24
  8021ef:	e8 ab fb ff ff       	call   801d9f <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 25                	push   $0x25
  80220b:	e8 8f fb ff ff       	call   801d9f <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
  802213:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802216:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221a:	75 07                	jne    802223 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221c:	b8 01 00 00 00       	mov    $0x1,%eax
  802221:	eb 05                	jmp    802228 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 25                	push   $0x25
  80223c:	e8 5e fb ff ff       	call   801d9f <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
  802244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802247:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224b:	75 07                	jne    802254 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80224d:	b8 01 00 00 00       	mov    $0x1,%eax
  802252:	eb 05                	jmp    802259 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 25                	push   $0x25
  80226d:	e8 2d fb ff ff       	call   801d9f <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
  802275:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802278:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227c:	75 07                	jne    802285 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	eb 05                	jmp    80228a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 25                	push   $0x25
  80229e:	e8 fc fa ff ff       	call   801d9f <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
  8022a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022a9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022ad:	75 07                	jne    8022b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022af:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b4:	eb 05                	jmp    8022bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	ff 75 08             	pushl  0x8(%ebp)
  8022cb:	6a 26                	push   $0x26
  8022cd:	e8 cd fa ff ff       	call   801d9f <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d5:	90                   	nop
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	53                   	push   %ebx
  8022eb:	51                   	push   %ecx
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	6a 27                	push   $0x27
  8022f0:	e8 aa fa ff ff       	call   801d9f <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 28                	push   $0x28
  802310:	e8 8a fa ff ff       	call   801d9f <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80231d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802320:	8b 55 0c             	mov    0xc(%ebp),%edx
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	6a 00                	push   $0x0
  802328:	51                   	push   %ecx
  802329:	ff 75 10             	pushl  0x10(%ebp)
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 29                	push   $0x29
  802330:	e8 6a fa ff ff       	call   801d9f <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	ff 75 10             	pushl  0x10(%ebp)
  802344:	ff 75 0c             	pushl  0xc(%ebp)
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 12                	push   $0x12
  80234c:	e8 4e fa ff ff       	call   801d9f <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	52                   	push   %edx
  802367:	50                   	push   %eax
  802368:	6a 2a                	push   $0x2a
  80236a:	e8 30 fa ff ff       	call   801d9f <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
	return;
  802372:	90                   	nop
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	50                   	push   %eax
  802384:	6a 2b                	push   $0x2b
  802386:	e8 14 fa ff ff       	call   801d9f <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	ff 75 08             	pushl  0x8(%ebp)
  80239f:	6a 2c                	push   $0x2c
  8023a1:	e8 f9 f9 ff ff       	call   801d9f <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	ff 75 0c             	pushl  0xc(%ebp)
  8023b8:	ff 75 08             	pushl  0x8(%ebp)
  8023bb:	6a 2d                	push   $0x2d
  8023bd:	e8 dd f9 ff ff       	call   801d9f <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
	return;
  8023c5:	90                   	nop
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 2e                	push   $0x2e
  8023da:	e8 c0 f9 ff ff       	call   801d9f <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
  8023e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8023e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	50                   	push   %eax
  8023f9:	6a 2f                	push   $0x2f
  8023fb:	e8 9f f9 ff ff       	call   801d9f <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
	return;
  802403:	90                   	nop
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	52                   	push   %edx
  802416:	50                   	push   %eax
  802417:	6a 30                	push   $0x30
  802419:	e8 81 f9 ff ff       	call   801d9f <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
	return;
  802421:	90                   	nop
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	50                   	push   %eax
  802436:	6a 31                	push   $0x31
  802438:	e8 62 f9 ff ff       	call   801d9f <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
  802440:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802443:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	50                   	push   %eax
  802457:	6a 32                	push   $0x32
  802459:	e8 41 f9 ff ff       	call   801d9f <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
	return;
  802461:	90                   	nop
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	83 e8 04             	sub    $0x4,%eax
  802470:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802473:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	83 e8 04             	sub    $0x4,%eax
  802489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80248c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	83 e0 01             	and    $0x1,%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	0f 94 c0             	sete   %al
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	83 f8 02             	cmp    $0x2,%eax
  8024ae:	74 2b                	je     8024db <alloc_block+0x40>
  8024b0:	83 f8 02             	cmp    $0x2,%eax
  8024b3:	7f 07                	jg     8024bc <alloc_block+0x21>
  8024b5:	83 f8 01             	cmp    $0x1,%eax
  8024b8:	74 0e                	je     8024c8 <alloc_block+0x2d>
  8024ba:	eb 58                	jmp    802514 <alloc_block+0x79>
  8024bc:	83 f8 03             	cmp    $0x3,%eax
  8024bf:	74 2d                	je     8024ee <alloc_block+0x53>
  8024c1:	83 f8 04             	cmp    $0x4,%eax
  8024c4:	74 3b                	je     802501 <alloc_block+0x66>
  8024c6:	eb 4c                	jmp    802514 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	e8 11 03 00 00       	call   8027e4 <alloc_block_FF>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024d9:	eb 4a                	jmp    802525 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	ff 75 08             	pushl  0x8(%ebp)
  8024e1:	e8 c7 19 00 00       	call   803ead <alloc_block_NF>
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024ec:	eb 37                	jmp    802525 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	e8 a7 07 00 00       	call   802ca0 <alloc_block_BF>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024ff:	eb 24                	jmp    802525 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802501:	83 ec 0c             	sub    $0xc,%esp
  802504:	ff 75 08             	pushl  0x8(%ebp)
  802507:	e8 84 19 00 00       	call   803e90 <alloc_block_WF>
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802512:	eb 11                	jmp    802525 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	68 a8 4b 80 00       	push   $0x804ba8
  80251c:	e8 b1 e5 ff ff       	call   800ad2 <cprintf>
  802521:	83 c4 10             	add    $0x10,%esp
		break;
  802524:	90                   	nop
	}
	return va;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	53                   	push   %ebx
  80252e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	68 c8 4b 80 00       	push   $0x804bc8
  802539:	e8 94 e5 ff ff       	call   800ad2 <cprintf>
  80253e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	68 f3 4b 80 00       	push   $0x804bf3
  802549:	e8 84 e5 ff ff       	call   800ad2 <cprintf>
  80254e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	eb 37                	jmp    802590 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	ff 75 f4             	pushl  -0xc(%ebp)
  80255f:	e8 19 ff ff ff       	call   80247d <is_free_block>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	0f be d8             	movsbl %al,%ebx
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	ff 75 f4             	pushl  -0xc(%ebp)
  802570:	e8 ef fe ff ff       	call   802464 <get_block_size>
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	53                   	push   %ebx
  80257c:	50                   	push   %eax
  80257d:	68 0b 4c 80 00       	push   $0x804c0b
  802582:	e8 4b e5 ff ff       	call   800ad2 <cprintf>
  802587:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80258a:	8b 45 10             	mov    0x10(%ebp),%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	74 07                	je     80259d <print_blocks_list+0x73>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	eb 05                	jmp    8025a2 <print_blocks_list+0x78>
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	89 45 10             	mov    %eax,0x10(%ebp)
  8025a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	75 ad                	jne    802559 <print_blocks_list+0x2f>
  8025ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b0:	75 a7                	jne    802559 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	68 c8 4b 80 00       	push   $0x804bc8
  8025ba:	e8 13 e5 ff ff       	call   800ad2 <cprintf>
  8025bf:	83 c4 10             	add    $0x10,%esp

}
  8025c2:	90                   	nop
  8025c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8025ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d1:	83 e0 01             	and    $0x1,%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 03                	je     8025db <initialize_dynamic_allocator+0x13>
  8025d8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8025db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025df:	0f 84 c7 01 00 00    	je     8027ac <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025e5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8025ec:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f5:	01 d0                	add    %edx,%eax
  8025f7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8025fc:	0f 87 ad 01 00 00    	ja     8027af <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 89 a5 01 00 00    	jns    8027b2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80260d:	8b 55 08             	mov    0x8(%ebp),%edx
  802610:	8b 45 0c             	mov    0xc(%ebp),%eax
  802613:	01 d0                	add    %edx,%eax
  802615:	83 e8 04             	sub    $0x4,%eax
  802618:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80261d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802624:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	e9 87 00 00 00       	jmp    8026b8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	75 14                	jne    80264b <initialize_dynamic_allocator+0x83>
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	68 23 4c 80 00       	push   $0x804c23
  80263f:	6a 79                	push   $0x79
  802641:	68 41 4c 80 00       	push   $0x804c41
  802646:	e8 ca e1 ff ff       	call   800815 <_panic>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	74 10                	je     802664 <initialize_dynamic_allocator+0x9c>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265c:	8b 52 04             	mov    0x4(%edx),%edx
  80265f:	89 50 04             	mov    %edx,0x4(%eax)
  802662:	eb 0b                	jmp    80266f <initialize_dynamic_allocator+0xa7>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	a3 30 50 80 00       	mov    %eax,0x805030
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 40 04             	mov    0x4(%eax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 0f                	je     802688 <initialize_dynamic_allocator+0xc0>
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802682:	8b 12                	mov    (%edx),%edx
  802684:	89 10                	mov    %edx,(%eax)
  802686:	eb 0a                	jmp    802692 <initialize_dynamic_allocator+0xca>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 00                	mov    (%eax),%eax
  80268d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8026aa:	48                   	dec    %eax
  8026ab:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	74 07                	je     8026c5 <initialize_dynamic_allocator+0xfd>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	eb 05                	jmp    8026ca <initialize_dynamic_allocator+0x102>
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8026cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 85 55 ff ff ff    	jne    802631 <initialize_dynamic_allocator+0x69>
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	0f 85 4b ff ff ff    	jne    802631 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8026f5:	a1 44 50 80 00       	mov    0x805044,%eax
  8026fa:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8026ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802704:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	83 c0 08             	add    $0x8,%eax
  802710:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	83 c0 04             	add    $0x4,%eax
  802719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271c:	83 ea 08             	sub    $0x8,%edx
  80271f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802721:	8b 55 0c             	mov    0xc(%ebp),%edx
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	83 e8 08             	sub    $0x8,%eax
  80272c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272f:	83 ea 08             	sub    $0x8,%edx
  802732:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802747:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80274b:	75 17                	jne    802764 <initialize_dynamic_allocator+0x19c>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 5c 4c 80 00       	push   $0x804c5c
  802755:	68 90 00 00 00       	push   $0x90
  80275a:	68 41 4c 80 00       	push   $0x804c41
  80275f:	e8 b1 e0 ff ff       	call   800815 <_panic>
  802764:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80276a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276d:	89 10                	mov    %edx,(%eax)
  80276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	74 0d                	je     802785 <initialize_dynamic_allocator+0x1bd>
  802778:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80277d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802780:	89 50 04             	mov    %edx,0x4(%eax)
  802783:	eb 08                	jmp    80278d <initialize_dynamic_allocator+0x1c5>
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	a3 30 50 80 00       	mov    %eax,0x805030
  80278d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802790:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802798:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279f:	a1 38 50 80 00       	mov    0x805038,%eax
  8027a4:	40                   	inc    %eax
  8027a5:	a3 38 50 80 00       	mov    %eax,0x805038
  8027aa:	eb 07                	jmp    8027b3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027ac:	90                   	nop
  8027ad:	eb 04                	jmp    8027b3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027af:	90                   	nop
  8027b0:	eb 01                	jmp    8027b3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027b2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8027bb:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	83 e8 04             	sub    $0x4,%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8027d4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	01 c2                	add    %eax,%edx
  8027dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027df:	89 02                	mov    %eax,(%edx)
}
  8027e1:	90                   	nop
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    

008027e4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	83 e0 01             	and    $0x1,%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 03                	je     8027f7 <alloc_block_FF+0x13>
  8027f4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027f7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027fb:	77 07                	ja     802804 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027fd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802804:	a1 24 50 80 00       	mov    0x805024,%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	75 73                	jne    802880 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	83 c0 10             	add    $0x10,%eax
  802813:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802816:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80281d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	01 d0                	add    %edx,%eax
  802825:	48                   	dec    %eax
  802826:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282c:	ba 00 00 00 00       	mov    $0x0,%edx
  802831:	f7 75 ec             	divl   -0x14(%ebp)
  802834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802837:	29 d0                	sub    %edx,%eax
  802839:	c1 e8 0c             	shr    $0xc,%eax
  80283c:	83 ec 0c             	sub    $0xc,%esp
  80283f:	50                   	push   %eax
  802840:	e8 27 f0 ff ff       	call   80186c <sbrk>
  802845:	83 c4 10             	add    $0x10,%esp
  802848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80284b:	83 ec 0c             	sub    $0xc,%esp
  80284e:	6a 00                	push   $0x0
  802850:	e8 17 f0 ff ff       	call   80186c <sbrk>
  802855:	83 c4 10             	add    $0x10,%esp
  802858:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80285b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802861:	83 ec 08             	sub    $0x8,%esp
  802864:	50                   	push   %eax
  802865:	ff 75 e4             	pushl  -0x1c(%ebp)
  802868:	e8 5b fd ff ff       	call   8025c8 <initialize_dynamic_allocator>
  80286d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802870:	83 ec 0c             	sub    $0xc,%esp
  802873:	68 7f 4c 80 00       	push   $0x804c7f
  802878:	e8 55 e2 ff ff       	call   800ad2 <cprintf>
  80287d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802880:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802884:	75 0a                	jne    802890 <alloc_block_FF+0xac>
	        return NULL;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
  80288b:	e9 0e 04 00 00       	jmp    802c9e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802897:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80289c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289f:	e9 f3 02 00 00       	jmp    802b97 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028aa:	83 ec 0c             	sub    $0xc,%esp
  8028ad:	ff 75 bc             	pushl  -0x44(%ebp)
  8028b0:	e8 af fb ff ff       	call   802464 <get_block_size>
  8028b5:	83 c4 10             	add    $0x10,%esp
  8028b8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	83 c0 08             	add    $0x8,%eax
  8028c1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028c4:	0f 87 c5 02 00 00    	ja     802b8f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	83 c0 18             	add    $0x18,%eax
  8028d0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028d3:	0f 87 19 02 00 00    	ja     802af2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8028d9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8028df:	83 e8 08             	sub    $0x8,%eax
  8028e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	8d 50 08             	lea    0x8(%eax),%edx
  8028eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028ee:	01 d0                	add    %edx,%eax
  8028f0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	83 c0 08             	add    $0x8,%eax
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	6a 01                	push   $0x1
  8028fe:	50                   	push   %eax
  8028ff:	ff 75 bc             	pushl  -0x44(%ebp)
  802902:	e8 ae fe ff ff       	call   8027b5 <set_block_data>
  802907:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	75 68                	jne    80297c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802914:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802918:	75 17                	jne    802931 <alloc_block_FF+0x14d>
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 5c 4c 80 00       	push   $0x804c5c
  802922:	68 d7 00 00 00       	push   $0xd7
  802927:	68 41 4c 80 00       	push   $0x804c41
  80292c:	e8 e4 de ff ff       	call   800815 <_panic>
  802931:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802937:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 0d                	je     802952 <alloc_block_FF+0x16e>
  802945:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80294a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80294d:	89 50 04             	mov    %edx,0x4(%eax)
  802950:	eb 08                	jmp    80295a <alloc_block_FF+0x176>
  802952:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802955:	a3 30 50 80 00       	mov    %eax,0x805030
  80295a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80295d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802962:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296c:	a1 38 50 80 00       	mov    0x805038,%eax
  802971:	40                   	inc    %eax
  802972:	a3 38 50 80 00       	mov    %eax,0x805038
  802977:	e9 dc 00 00 00       	jmp    802a58 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	75 65                	jne    8029ea <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802985:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802989:	75 17                	jne    8029a2 <alloc_block_FF+0x1be>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 90 4c 80 00       	push   $0x804c90
  802993:	68 db 00 00 00       	push   $0xdb
  802998:	68 41 4c 80 00       	push   $0x804c41
  80299d:	e8 73 de ff ff       	call   800815 <_panic>
  8029a2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ab:	89 50 04             	mov    %edx,0x4(%eax)
  8029ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b1:	8b 40 04             	mov    0x4(%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 0c                	je     8029c4 <alloc_block_FF+0x1e0>
  8029b8:	a1 30 50 80 00       	mov    0x805030,%eax
  8029bd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	eb 08                	jmp    8029cc <alloc_block_FF+0x1e8>
  8029c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8029e8:	eb 6e                	jmp    802a58 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ee:	74 06                	je     8029f6 <alloc_block_FF+0x212>
  8029f0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_FF+0x229>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 b4 4c 80 00       	push   $0x804cb4
  8029fe:	68 df 00 00 00       	push   $0xdf
  802a03:	68 41 4c 80 00       	push   $0x804c41
  802a08:	e8 08 de ff ff       	call   800815 <_panic>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 10                	mov    (%eax),%edx
  802a12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a15:	89 10                	mov    %edx,(%eax)
  802a17:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 0b                	je     802a2b <alloc_block_FF+0x247>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a28:	89 50 04             	mov    %edx,0x4(%eax)
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 08                	jne    802a4d <alloc_block_FF+0x269>
  802a45:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a48:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a52:	40                   	inc    %eax
  802a53:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_FF+0x291>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 23 4c 80 00       	push   $0x804c23
  802a66:	68 e1 00 00 00       	push   $0xe1
  802a6b:	68 41 4c 80 00       	push   $0x804c41
  802a70:	e8 a0 dd ff ff       	call   800815 <_panic>
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 10                	je     802a8e <alloc_block_FF+0x2aa>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a86:	8b 52 04             	mov    0x4(%edx),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 0b                	jmp    802a99 <alloc_block_FF+0x2b5>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	a3 30 50 80 00       	mov    %eax,0x805030
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0f                	je     802ab2 <alloc_block_FF+0x2ce>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aac:	8b 12                	mov    (%edx),%edx
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	eb 0a                	jmp    802abc <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	6a 00                	push   $0x0
  802adf:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ae2:	ff 75 b0             	pushl  -0x50(%ebp)
  802ae5:	e8 cb fc ff ff       	call   8027b5 <set_block_data>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	e9 95 00 00 00       	jmp    802b87 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	6a 01                	push   $0x1
  802af7:	ff 75 b8             	pushl  -0x48(%ebp)
  802afa:	ff 75 bc             	pushl  -0x44(%ebp)
  802afd:	e8 b3 fc ff ff       	call   8027b5 <set_block_data>
  802b02:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b09:	75 17                	jne    802b22 <alloc_block_FF+0x33e>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 23 4c 80 00       	push   $0x804c23
  802b13:	68 e8 00 00 00       	push   $0xe8
  802b18:	68 41 4c 80 00       	push   $0x804c41
  802b1d:	e8 f3 dc ff ff       	call   800815 <_panic>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 10                	je     802b3b <alloc_block_FF+0x357>
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b33:	8b 52 04             	mov    0x4(%edx),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	eb 0b                	jmp    802b46 <alloc_block_FF+0x362>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	a3 30 50 80 00       	mov    %eax,0x805030
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0f                	je     802b5f <alloc_block_FF+0x37b>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b59:	8b 12                	mov    (%edx),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	eb 0a                	jmp    802b69 <alloc_block_FF+0x385>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b81:	48                   	dec    %eax
  802b82:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802b87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b8a:	e9 0f 01 00 00       	jmp    802c9e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b8f:	a1 34 50 80 00       	mov    0x805034,%eax
  802b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9b:	74 07                	je     802ba4 <alloc_block_FF+0x3c0>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	eb 05                	jmp    802ba9 <alloc_block_FF+0x3c5>
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba9:	a3 34 50 80 00       	mov    %eax,0x805034
  802bae:	a1 34 50 80 00       	mov    0x805034,%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	0f 85 e9 fc ff ff    	jne    8028a4 <alloc_block_FF+0xc0>
  802bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbf:	0f 85 df fc ff ff    	jne    8028a4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	83 c0 08             	add    $0x8,%eax
  802bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bce:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802bd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bdb:	01 d0                	add    %edx,%eax
  802bdd:	48                   	dec    %eax
  802bde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802be1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802be4:	ba 00 00 00 00       	mov    $0x0,%edx
  802be9:	f7 75 d8             	divl   -0x28(%ebp)
  802bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bef:	29 d0                	sub    %edx,%eax
  802bf1:	c1 e8 0c             	shr    $0xc,%eax
  802bf4:	83 ec 0c             	sub    $0xc,%esp
  802bf7:	50                   	push   %eax
  802bf8:	e8 6f ec ff ff       	call   80186c <sbrk>
  802bfd:	83 c4 10             	add    $0x10,%esp
  802c00:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c03:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c07:	75 0a                	jne    802c13 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0e:	e9 8b 00 00 00       	jmp    802c9e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c13:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c20:	01 d0                	add    %edx,%eax
  802c22:	48                   	dec    %eax
  802c23:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c29:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2e:	f7 75 cc             	divl   -0x34(%ebp)
  802c31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c34:	29 d0                	sub    %edx,%eax
  802c36:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c3c:	01 d0                	add    %edx,%eax
  802c3e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802c43:	a1 40 50 80 00       	mov    0x805040,%eax
  802c48:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c4e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	48                   	dec    %eax
  802c5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c64:	ba 00 00 00 00       	mov    $0x0,%edx
  802c69:	f7 75 c4             	divl   -0x3c(%ebp)
  802c6c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c6f:	29 d0                	sub    %edx,%eax
  802c71:	83 ec 04             	sub    $0x4,%esp
  802c74:	6a 01                	push   $0x1
  802c76:	50                   	push   %eax
  802c77:	ff 75 d0             	pushl  -0x30(%ebp)
  802c7a:	e8 36 fb ff ff       	call   8027b5 <set_block_data>
  802c7f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c82:	83 ec 0c             	sub    $0xc,%esp
  802c85:	ff 75 d0             	pushl  -0x30(%ebp)
  802c88:	e8 f8 09 00 00       	call   803685 <free_block>
  802c8d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c90:	83 ec 0c             	sub    $0xc,%esp
  802c93:	ff 75 08             	pushl  0x8(%ebp)
  802c96:	e8 49 fb ff ff       	call   8027e4 <alloc_block_FF>
  802c9b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
  802ca3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	83 e0 01             	and    $0x1,%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 03                	je     802cb3 <alloc_block_BF+0x13>
  802cb0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cb3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cb7:	77 07                	ja     802cc0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cb9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cc0:	a1 24 50 80 00       	mov    0x805024,%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 73                	jne    802d3c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	83 c0 10             	add    $0x10,%eax
  802ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cd2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802cd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdf:	01 d0                	add    %edx,%eax
  802ce1:	48                   	dec    %eax
  802ce2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ced:	f7 75 e0             	divl   -0x20(%ebp)
  802cf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf3:	29 d0                	sub    %edx,%eax
  802cf5:	c1 e8 0c             	shr    $0xc,%eax
  802cf8:	83 ec 0c             	sub    $0xc,%esp
  802cfb:	50                   	push   %eax
  802cfc:	e8 6b eb ff ff       	call   80186c <sbrk>
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	6a 00                	push   $0x0
  802d0c:	e8 5b eb ff ff       	call   80186c <sbrk>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d1a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d1d:	83 ec 08             	sub    $0x8,%esp
  802d20:	50                   	push   %eax
  802d21:	ff 75 d8             	pushl  -0x28(%ebp)
  802d24:	e8 9f f8 ff ff       	call   8025c8 <initialize_dynamic_allocator>
  802d29:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d2c:	83 ec 0c             	sub    $0xc,%esp
  802d2f:	68 7f 4c 80 00       	push   $0x804c7f
  802d34:	e8 99 dd ff ff       	call   800ad2 <cprintf>
  802d39:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d4a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d51:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d58:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d60:	e9 1d 01 00 00       	jmp    802e82 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d6b:	83 ec 0c             	sub    $0xc,%esp
  802d6e:	ff 75 a8             	pushl  -0x58(%ebp)
  802d71:	e8 ee f6 ff ff       	call   802464 <get_block_size>
  802d76:	83 c4 10             	add    $0x10,%esp
  802d79:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	83 c0 08             	add    $0x8,%eax
  802d82:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d85:	0f 87 ef 00 00 00    	ja     802e7a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	83 c0 18             	add    $0x18,%eax
  802d91:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d94:	77 1d                	ja     802db3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d99:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d9c:	0f 86 d8 00 00 00    	jbe    802e7a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802da2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802da8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dae:	e9 c7 00 00 00       	jmp    802e7a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	83 c0 08             	add    $0x8,%eax
  802db9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dbc:	0f 85 9d 00 00 00    	jne    802e5f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	6a 01                	push   $0x1
  802dc7:	ff 75 a4             	pushl  -0x5c(%ebp)
  802dca:	ff 75 a8             	pushl  -0x58(%ebp)
  802dcd:	e8 e3 f9 ff ff       	call   8027b5 <set_block_data>
  802dd2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd9:	75 17                	jne    802df2 <alloc_block_BF+0x152>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 23 4c 80 00       	push   $0x804c23
  802de3:	68 2c 01 00 00       	push   $0x12c
  802de8:	68 41 4c 80 00       	push   $0x804c41
  802ded:	e8 23 da ff ff       	call   800815 <_panic>
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 10                	je     802e0b <alloc_block_BF+0x16b>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e03:	8b 52 04             	mov    0x4(%edx),%edx
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	eb 0b                	jmp    802e16 <alloc_block_BF+0x176>
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	a3 30 50 80 00       	mov    %eax,0x805030
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 0f                	je     802e2f <alloc_block_BF+0x18f>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e29:	8b 12                	mov    (%edx),%edx
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	eb 0a                	jmp    802e39 <alloc_block_BF+0x199>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e51:	48                   	dec    %eax
  802e52:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802e57:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e5a:	e9 01 04 00 00       	jmp    803260 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e62:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e65:	76 13                	jbe    802e7a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e67:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e74:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e77:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e7a:	a1 34 50 80 00       	mov    0x805034,%eax
  802e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	74 07                	je     802e8f <alloc_block_BF+0x1ef>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	eb 05                	jmp    802e94 <alloc_block_BF+0x1f4>
  802e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e94:	a3 34 50 80 00       	mov    %eax,0x805034
  802e99:	a1 34 50 80 00       	mov    0x805034,%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	0f 85 bf fe ff ff    	jne    802d65 <alloc_block_BF+0xc5>
  802ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaa:	0f 85 b5 fe ff ff    	jne    802d65 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb4:	0f 84 26 02 00 00    	je     8030e0 <alloc_block_BF+0x440>
  802eba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ebe:	0f 85 1c 02 00 00    	jne    8030e0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec7:	2b 45 08             	sub    0x8(%ebp),%eax
  802eca:	83 e8 08             	sub    $0x8,%eax
  802ecd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8d 50 08             	lea    0x8(%eax),%edx
  802ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed9:	01 d0                	add    %edx,%eax
  802edb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	83 c0 08             	add    $0x8,%eax
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	6a 01                	push   $0x1
  802ee9:	50                   	push   %eax
  802eea:	ff 75 f0             	pushl  -0x10(%ebp)
  802eed:	e8 c3 f8 ff ff       	call   8027b5 <set_block_data>
  802ef2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	75 68                	jne    802f67 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802eff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f03:	75 17                	jne    802f1c <alloc_block_BF+0x27c>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 5c 4c 80 00       	push   $0x804c5c
  802f0d:	68 45 01 00 00       	push   $0x145
  802f12:	68 41 4c 80 00       	push   $0x804c41
  802f17:	e8 f9 d8 ff ff       	call   800815 <_panic>
  802f1c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f25:	89 10                	mov    %edx,(%eax)
  802f27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0d                	je     802f3d <alloc_block_BF+0x29d>
  802f30:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f35:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 08                	jmp    802f45 <alloc_block_BF+0x2a5>
  802f3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f40:	a3 30 50 80 00       	mov    %eax,0x805030
  802f45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5c:	40                   	inc    %eax
  802f5d:	a3 38 50 80 00       	mov    %eax,0x805038
  802f62:	e9 dc 00 00 00       	jmp    803043 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	75 65                	jne    802fd5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f70:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f74:	75 17                	jne    802f8d <alloc_block_BF+0x2ed>
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 90 4c 80 00       	push   $0x804c90
  802f7e:	68 4a 01 00 00       	push   $0x14a
  802f83:	68 41 4c 80 00       	push   $0x804c41
  802f88:	e8 88 d8 ff ff       	call   800815 <_panic>
  802f8d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f96:	89 50 04             	mov    %edx,0x4(%eax)
  802f99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f9c:	8b 40 04             	mov    0x4(%eax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	74 0c                	je     802faf <alloc_block_BF+0x30f>
  802fa3:	a1 30 50 80 00       	mov    0x805030,%eax
  802fa8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fab:	89 10                	mov    %edx,(%eax)
  802fad:	eb 08                	jmp    802fb7 <alloc_block_BF+0x317>
  802faf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fb2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fba:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fcd:	40                   	inc    %eax
  802fce:	a3 38 50 80 00       	mov    %eax,0x805038
  802fd3:	eb 6e                	jmp    803043 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fd9:	74 06                	je     802fe1 <alloc_block_BF+0x341>
  802fdb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fdf:	75 17                	jne    802ff8 <alloc_block_BF+0x358>
  802fe1:	83 ec 04             	sub    $0x4,%esp
  802fe4:	68 b4 4c 80 00       	push   $0x804cb4
  802fe9:	68 4f 01 00 00       	push   $0x14f
  802fee:	68 41 4c 80 00       	push   $0x804c41
  802ff3:	e8 1d d8 ff ff       	call   800815 <_panic>
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 10                	mov    (%eax),%edx
  802ffd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803000:	89 10                	mov    %edx,(%eax)
  803002:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	74 0b                	je     803016 <alloc_block_BF+0x376>
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803013:	89 50 04             	mov    %edx,0x4(%eax)
  803016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803019:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80301c:	89 10                	mov    %edx,(%eax)
  80301e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803021:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	75 08                	jne    803038 <alloc_block_BF+0x398>
  803030:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803033:	a3 30 50 80 00       	mov    %eax,0x805030
  803038:	a1 38 50 80 00       	mov    0x805038,%eax
  80303d:	40                   	inc    %eax
  80303e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803043:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803047:	75 17                	jne    803060 <alloc_block_BF+0x3c0>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 23 4c 80 00       	push   $0x804c23
  803051:	68 51 01 00 00       	push   $0x151
  803056:	68 41 4c 80 00       	push   $0x804c41
  80305b:	e8 b5 d7 ff ff       	call   800815 <_panic>
  803060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 10                	je     803079 <alloc_block_BF+0x3d9>
  803069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803071:	8b 52 04             	mov    0x4(%edx),%edx
  803074:	89 50 04             	mov    %edx,0x4(%eax)
  803077:	eb 0b                	jmp    803084 <alloc_block_BF+0x3e4>
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	a3 30 50 80 00       	mov    %eax,0x805030
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0f                	je     80309d <alloc_block_BF+0x3fd>
  80308e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803091:	8b 40 04             	mov    0x4(%eax),%eax
  803094:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803097:	8b 12                	mov    (%edx),%edx
  803099:	89 10                	mov    %edx,(%eax)
  80309b:	eb 0a                	jmp    8030a7 <alloc_block_BF+0x407>
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8030bf:	48                   	dec    %eax
  8030c0:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	6a 00                	push   $0x0
  8030ca:	ff 75 d0             	pushl  -0x30(%ebp)
  8030cd:	ff 75 cc             	pushl  -0x34(%ebp)
  8030d0:	e8 e0 f6 ff ff       	call   8027b5 <set_block_data>
  8030d5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8030d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030db:	e9 80 01 00 00       	jmp    803260 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8030e0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8030e4:	0f 85 9d 00 00 00    	jne    803187 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	6a 01                	push   $0x1
  8030ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8030f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030f5:	e8 bb f6 ff ff       	call   8027b5 <set_block_data>
  8030fa:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8030fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803101:	75 17                	jne    80311a <alloc_block_BF+0x47a>
  803103:	83 ec 04             	sub    $0x4,%esp
  803106:	68 23 4c 80 00       	push   $0x804c23
  80310b:	68 58 01 00 00       	push   $0x158
  803110:	68 41 4c 80 00       	push   $0x804c41
  803115:	e8 fb d6 ff ff       	call   800815 <_panic>
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	74 10                	je     803133 <alloc_block_BF+0x493>
  803123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312b:	8b 52 04             	mov    0x4(%edx),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 0b                	jmp    80313e <alloc_block_BF+0x49e>
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	a3 30 50 80 00       	mov    %eax,0x805030
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	74 0f                	je     803157 <alloc_block_BF+0x4b7>
  803148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314b:	8b 40 04             	mov    0x4(%eax),%eax
  80314e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803151:	8b 12                	mov    (%edx),%edx
  803153:	89 10                	mov    %edx,(%eax)
  803155:	eb 0a                	jmp    803161 <alloc_block_BF+0x4c1>
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803174:	a1 38 50 80 00       	mov    0x805038,%eax
  803179:	48                   	dec    %eax
  80317a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80317f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803182:	e9 d9 00 00 00       	jmp    803260 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	83 c0 08             	add    $0x8,%eax
  80318d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803190:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803197:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80319a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80319d:	01 d0                	add    %edx,%eax
  80319f:	48                   	dec    %eax
  8031a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ab:	f7 75 c4             	divl   -0x3c(%ebp)
  8031ae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031b1:	29 d0                	sub    %edx,%eax
  8031b3:	c1 e8 0c             	shr    $0xc,%eax
  8031b6:	83 ec 0c             	sub    $0xc,%esp
  8031b9:	50                   	push   %eax
  8031ba:	e8 ad e6 ff ff       	call   80186c <sbrk>
  8031bf:	83 c4 10             	add    $0x10,%esp
  8031c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031c5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8031c9:	75 0a                	jne    8031d5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8031cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d0:	e9 8b 00 00 00       	jmp    803260 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8031d5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8031dc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	48                   	dec    %eax
  8031e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f0:	f7 75 b8             	divl   -0x48(%ebp)
  8031f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031f6:	29 d0                	sub    %edx,%eax
  8031f8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8031fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803205:	a1 40 50 80 00       	mov    0x805040,%eax
  80320a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803210:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803217:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80321a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321d:	01 d0                	add    %edx,%eax
  80321f:	48                   	dec    %eax
  803220:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803223:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803226:	ba 00 00 00 00       	mov    $0x0,%edx
  80322b:	f7 75 b0             	divl   -0x50(%ebp)
  80322e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803231:	29 d0                	sub    %edx,%eax
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	6a 01                	push   $0x1
  803238:	50                   	push   %eax
  803239:	ff 75 bc             	pushl  -0x44(%ebp)
  80323c:	e8 74 f5 ff ff       	call   8027b5 <set_block_data>
  803241:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803244:	83 ec 0c             	sub    $0xc,%esp
  803247:	ff 75 bc             	pushl  -0x44(%ebp)
  80324a:	e8 36 04 00 00       	call   803685 <free_block>
  80324f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	ff 75 08             	pushl  0x8(%ebp)
  803258:	e8 43 fa ff ff       	call   802ca0 <alloc_block_BF>
  80325d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803260:	c9                   	leave  
  803261:	c3                   	ret    

00803262 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803262:	55                   	push   %ebp
  803263:	89 e5                	mov    %esp,%ebp
  803265:	53                   	push   %ebx
  803266:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327b:	74 1e                	je     80329b <merging+0x39>
  80327d:	ff 75 08             	pushl  0x8(%ebp)
  803280:	e8 df f1 ff ff       	call   802464 <get_block_size>
  803285:	83 c4 04             	add    $0x4,%esp
  803288:	89 c2                	mov    %eax,%edx
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	01 d0                	add    %edx,%eax
  80328f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803292:	75 07                	jne    80329b <merging+0x39>
		prev_is_free = 1;
  803294:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80329b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329f:	74 1e                	je     8032bf <merging+0x5d>
  8032a1:	ff 75 10             	pushl  0x10(%ebp)
  8032a4:	e8 bb f1 ff ff       	call   802464 <get_block_size>
  8032a9:	83 c4 04             	add    $0x4,%esp
  8032ac:	89 c2                	mov    %eax,%edx
  8032ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8032b1:	01 d0                	add    %edx,%eax
  8032b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b6:	75 07                	jne    8032bf <merging+0x5d>
		next_is_free = 1;
  8032b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8032bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c3:	0f 84 cc 00 00 00    	je     803395 <merging+0x133>
  8032c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032cd:	0f 84 c2 00 00 00    	je     803395 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8032d3:	ff 75 08             	pushl  0x8(%ebp)
  8032d6:	e8 89 f1 ff ff       	call   802464 <get_block_size>
  8032db:	83 c4 04             	add    $0x4,%esp
  8032de:	89 c3                	mov    %eax,%ebx
  8032e0:	ff 75 10             	pushl  0x10(%ebp)
  8032e3:	e8 7c f1 ff ff       	call   802464 <get_block_size>
  8032e8:	83 c4 04             	add    $0x4,%esp
  8032eb:	01 c3                	add    %eax,%ebx
  8032ed:	ff 75 0c             	pushl  0xc(%ebp)
  8032f0:	e8 6f f1 ff ff       	call   802464 <get_block_size>
  8032f5:	83 c4 04             	add    $0x4,%esp
  8032f8:	01 d8                	add    %ebx,%eax
  8032fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032fd:	6a 00                	push   $0x0
  8032ff:	ff 75 ec             	pushl  -0x14(%ebp)
  803302:	ff 75 08             	pushl  0x8(%ebp)
  803305:	e8 ab f4 ff ff       	call   8027b5 <set_block_data>
  80330a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80330d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803311:	75 17                	jne    80332a <merging+0xc8>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 23 4c 80 00       	push   $0x804c23
  80331b:	68 7d 01 00 00       	push   $0x17d
  803320:	68 41 4c 80 00       	push   $0x804c41
  803325:	e8 eb d4 ff ff       	call   800815 <_panic>
  80332a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 10                	je     803343 <merging+0xe1>
  803333:	8b 45 0c             	mov    0xc(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80333b:	8b 52 04             	mov    0x4(%edx),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 0b                	jmp    80334e <merging+0xec>
  803343:	8b 45 0c             	mov    0xc(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	a3 30 50 80 00       	mov    %eax,0x805030
  80334e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803351:	8b 40 04             	mov    0x4(%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 0f                	je     803367 <merging+0x105>
  803358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335b:	8b 40 04             	mov    0x4(%eax),%eax
  80335e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803361:	8b 12                	mov    (%edx),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 0a                	jmp    803371 <merging+0x10f>
  803367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803371:	8b 45 0c             	mov    0xc(%ebp),%eax
  803374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 38 50 80 00       	mov    0x805038,%eax
  803389:	48                   	dec    %eax
  80338a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80338f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803390:	e9 ea 02 00 00       	jmp    80367f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803399:	74 3b                	je     8033d6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	ff 75 08             	pushl  0x8(%ebp)
  8033a1:	e8 be f0 ff ff       	call   802464 <get_block_size>
  8033a6:	83 c4 10             	add    $0x10,%esp
  8033a9:	89 c3                	mov    %eax,%ebx
  8033ab:	83 ec 0c             	sub    $0xc,%esp
  8033ae:	ff 75 10             	pushl  0x10(%ebp)
  8033b1:	e8 ae f0 ff ff       	call   802464 <get_block_size>
  8033b6:	83 c4 10             	add    $0x10,%esp
  8033b9:	01 d8                	add    %ebx,%eax
  8033bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	6a 00                	push   $0x0
  8033c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8033c6:	ff 75 08             	pushl  0x8(%ebp)
  8033c9:	e8 e7 f3 ff ff       	call   8027b5 <set_block_data>
  8033ce:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033d1:	e9 a9 02 00 00       	jmp    80367f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8033d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033da:	0f 84 2d 01 00 00    	je     80350d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8033e0:	83 ec 0c             	sub    $0xc,%esp
  8033e3:	ff 75 10             	pushl  0x10(%ebp)
  8033e6:	e8 79 f0 ff ff       	call   802464 <get_block_size>
  8033eb:	83 c4 10             	add    $0x10,%esp
  8033ee:	89 c3                	mov    %eax,%ebx
  8033f0:	83 ec 0c             	sub    $0xc,%esp
  8033f3:	ff 75 0c             	pushl  0xc(%ebp)
  8033f6:	e8 69 f0 ff ff       	call   802464 <get_block_size>
  8033fb:	83 c4 10             	add    $0x10,%esp
  8033fe:	01 d8                	add    %ebx,%eax
  803400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	6a 00                	push   $0x0
  803408:	ff 75 e4             	pushl  -0x1c(%ebp)
  80340b:	ff 75 10             	pushl  0x10(%ebp)
  80340e:	e8 a2 f3 ff ff       	call   8027b5 <set_block_data>
  803413:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803416:	8b 45 10             	mov    0x10(%ebp),%eax
  803419:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80341c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803420:	74 06                	je     803428 <merging+0x1c6>
  803422:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803426:	75 17                	jne    80343f <merging+0x1dd>
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	68 e8 4c 80 00       	push   $0x804ce8
  803430:	68 8d 01 00 00       	push   $0x18d
  803435:	68 41 4c 80 00       	push   $0x804c41
  80343a:	e8 d6 d3 ff ff       	call   800815 <_panic>
  80343f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803442:	8b 50 04             	mov    0x4(%eax),%edx
  803445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803448:	89 50 04             	mov    %edx,0x4(%eax)
  80344b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803451:	89 10                	mov    %edx,(%eax)
  803453:	8b 45 0c             	mov    0xc(%ebp),%eax
  803456:	8b 40 04             	mov    0x4(%eax),%eax
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 0d                	je     80346a <merging+0x208>
  80345d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803460:	8b 40 04             	mov    0x4(%eax),%eax
  803463:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803466:	89 10                	mov    %edx,(%eax)
  803468:	eb 08                	jmp    803472 <merging+0x210>
  80346a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803472:	8b 45 0c             	mov    0xc(%ebp),%eax
  803475:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803478:	89 50 04             	mov    %edx,0x4(%eax)
  80347b:	a1 38 50 80 00       	mov    0x805038,%eax
  803480:	40                   	inc    %eax
  803481:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803486:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80348a:	75 17                	jne    8034a3 <merging+0x241>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 23 4c 80 00       	push   $0x804c23
  803494:	68 8e 01 00 00       	push   $0x18e
  803499:	68 41 4c 80 00       	push   $0x804c41
  80349e:	e8 72 d3 ff ff       	call   800815 <_panic>
  8034a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 10                	je     8034bc <merging+0x25a>
  8034ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b4:	8b 52 04             	mov    0x4(%edx),%edx
  8034b7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ba:	eb 0b                	jmp    8034c7 <merging+0x265>
  8034bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bf:	8b 40 04             	mov    0x4(%eax),%eax
  8034c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 0f                	je     8034e0 <merging+0x27e>
  8034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034da:	8b 12                	mov    (%edx),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	eb 0a                	jmp    8034ea <merging+0x288>
  8034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803502:	48                   	dec    %eax
  803503:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803508:	e9 72 01 00 00       	jmp    80367f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80350d:	8b 45 10             	mov    0x10(%ebp),%eax
  803510:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803517:	74 79                	je     803592 <merging+0x330>
  803519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80351d:	74 73                	je     803592 <merging+0x330>
  80351f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803523:	74 06                	je     80352b <merging+0x2c9>
  803525:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803529:	75 17                	jne    803542 <merging+0x2e0>
  80352b:	83 ec 04             	sub    $0x4,%esp
  80352e:	68 b4 4c 80 00       	push   $0x804cb4
  803533:	68 94 01 00 00       	push   $0x194
  803538:	68 41 4c 80 00       	push   $0x804c41
  80353d:	e8 d3 d2 ff ff       	call   800815 <_panic>
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 10                	mov    (%eax),%edx
  803547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354a:	89 10                	mov    %edx,(%eax)
  80354c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 0b                	je     803560 <merging+0x2fe>
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80356b:	8b 55 08             	mov    0x8(%ebp),%edx
  80356e:	89 50 04             	mov    %edx,0x4(%eax)
  803571:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	75 08                	jne    803582 <merging+0x320>
  80357a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357d:	a3 30 50 80 00       	mov    %eax,0x805030
  803582:	a1 38 50 80 00       	mov    0x805038,%eax
  803587:	40                   	inc    %eax
  803588:	a3 38 50 80 00       	mov    %eax,0x805038
  80358d:	e9 ce 00 00 00       	jmp    803660 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803596:	74 65                	je     8035fd <merging+0x39b>
  803598:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80359c:	75 17                	jne    8035b5 <merging+0x353>
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	68 90 4c 80 00       	push   $0x804c90
  8035a6:	68 95 01 00 00       	push   $0x195
  8035ab:	68 41 4c 80 00       	push   $0x804c41
  8035b0:	e8 60 d2 ff ff       	call   800815 <_panic>
  8035b5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035be:	89 50 04             	mov    %edx,0x4(%eax)
  8035c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c4:	8b 40 04             	mov    0x4(%eax),%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 0c                	je     8035d7 <merging+0x375>
  8035cb:	a1 30 50 80 00       	mov    0x805030,%eax
  8035d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035d3:	89 10                	mov    %edx,(%eax)
  8035d5:	eb 08                	jmp    8035df <merging+0x37d>
  8035d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f5:	40                   	inc    %eax
  8035f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8035fb:	eb 63                	jmp    803660 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8035fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803601:	75 17                	jne    80361a <merging+0x3b8>
  803603:	83 ec 04             	sub    $0x4,%esp
  803606:	68 5c 4c 80 00       	push   $0x804c5c
  80360b:	68 98 01 00 00       	push   $0x198
  803610:	68 41 4c 80 00       	push   $0x804c41
  803615:	e8 fb d1 ff ff       	call   800815 <_panic>
  80361a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803623:	89 10                	mov    %edx,(%eax)
  803625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 0d                	je     80363b <merging+0x3d9>
  80362e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803633:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	eb 08                	jmp    803643 <merging+0x3e1>
  80363b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363e:	a3 30 50 80 00       	mov    %eax,0x805030
  803643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803646:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803655:	a1 38 50 80 00       	mov    0x805038,%eax
  80365a:	40                   	inc    %eax
  80365b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803660:	83 ec 0c             	sub    $0xc,%esp
  803663:	ff 75 10             	pushl  0x10(%ebp)
  803666:	e8 f9 ed ff ff       	call   802464 <get_block_size>
  80366b:	83 c4 10             	add    $0x10,%esp
  80366e:	83 ec 04             	sub    $0x4,%esp
  803671:	6a 00                	push   $0x0
  803673:	50                   	push   %eax
  803674:	ff 75 10             	pushl  0x10(%ebp)
  803677:	e8 39 f1 ff ff       	call   8027b5 <set_block_data>
  80367c:	83 c4 10             	add    $0x10,%esp
	}
}
  80367f:	90                   	nop
  803680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803683:	c9                   	leave  
  803684:	c3                   	ret    

00803685 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
  803688:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80368b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803690:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803693:	a1 30 50 80 00       	mov    0x805030,%eax
  803698:	3b 45 08             	cmp    0x8(%ebp),%eax
  80369b:	73 1b                	jae    8036b8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80369d:	a1 30 50 80 00       	mov    0x805030,%eax
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	ff 75 08             	pushl  0x8(%ebp)
  8036a8:	6a 00                	push   $0x0
  8036aa:	50                   	push   %eax
  8036ab:	e8 b2 fb ff ff       	call   803262 <merging>
  8036b0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036b3:	e9 8b 00 00 00       	jmp    803743 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8036b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036c0:	76 18                	jbe    8036da <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8036c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	ff 75 08             	pushl  0x8(%ebp)
  8036cd:	50                   	push   %eax
  8036ce:	6a 00                	push   $0x0
  8036d0:	e8 8d fb ff ff       	call   803262 <merging>
  8036d5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036d8:	eb 69                	jmp    803743 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e2:	eb 39                	jmp    80371d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ea:	73 29                	jae    803715 <free_block+0x90>
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f4:	76 1f                	jbe    803715 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	ff 75 08             	pushl  0x8(%ebp)
  803704:	ff 75 f0             	pushl  -0x10(%ebp)
  803707:	ff 75 f4             	pushl  -0xc(%ebp)
  80370a:	e8 53 fb ff ff       	call   803262 <merging>
  80370f:	83 c4 10             	add    $0x10,%esp
			break;
  803712:	90                   	nop
		}
	}
}
  803713:	eb 2e                	jmp    803743 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803715:	a1 34 50 80 00       	mov    0x805034,%eax
  80371a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803721:	74 07                	je     80372a <free_block+0xa5>
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	eb 05                	jmp    80372f <free_block+0xaa>
  80372a:	b8 00 00 00 00       	mov    $0x0,%eax
  80372f:	a3 34 50 80 00       	mov    %eax,0x805034
  803734:	a1 34 50 80 00       	mov    0x805034,%eax
  803739:	85 c0                	test   %eax,%eax
  80373b:	75 a7                	jne    8036e4 <free_block+0x5f>
  80373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803741:	75 a1                	jne    8036e4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803743:	90                   	nop
  803744:	c9                   	leave  
  803745:	c3                   	ret    

00803746 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803746:	55                   	push   %ebp
  803747:	89 e5                	mov    %esp,%ebp
  803749:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80374c:	ff 75 08             	pushl  0x8(%ebp)
  80374f:	e8 10 ed ff ff       	call   802464 <get_block_size>
  803754:	83 c4 04             	add    $0x4,%esp
  803757:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80375a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803761:	eb 17                	jmp    80377a <copy_data+0x34>
  803763:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803766:	8b 45 0c             	mov    0xc(%ebp),%eax
  803769:	01 c2                	add    %eax,%edx
  80376b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	01 c8                	add    %ecx,%eax
  803773:	8a 00                	mov    (%eax),%al
  803775:	88 02                	mov    %al,(%edx)
  803777:	ff 45 fc             	incl   -0x4(%ebp)
  80377a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80377d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803780:	72 e1                	jb     803763 <copy_data+0x1d>
}
  803782:	90                   	nop
  803783:	c9                   	leave  
  803784:	c3                   	ret    

00803785 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
  803788:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80378b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378f:	75 23                	jne    8037b4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803791:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803795:	74 13                	je     8037aa <realloc_block_FF+0x25>
  803797:	83 ec 0c             	sub    $0xc,%esp
  80379a:	ff 75 0c             	pushl  0xc(%ebp)
  80379d:	e8 42 f0 ff ff       	call   8027e4 <alloc_block_FF>
  8037a2:	83 c4 10             	add    $0x10,%esp
  8037a5:	e9 e4 06 00 00       	jmp    803e8e <realloc_block_FF+0x709>
		return NULL;
  8037aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8037af:	e9 da 06 00 00       	jmp    803e8e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8037b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037b8:	75 18                	jne    8037d2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8037ba:	83 ec 0c             	sub    $0xc,%esp
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	e8 c0 fe ff ff       	call   803685 <free_block>
  8037c5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cd:	e9 bc 06 00 00       	jmp    803e8e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8037d2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8037d6:	77 07                	ja     8037df <realloc_block_FF+0x5a>
  8037d8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8037df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e2:	83 e0 01             	and    $0x1,%eax
  8037e5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8037e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037eb:	83 c0 08             	add    $0x8,%eax
  8037ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8037f1:	83 ec 0c             	sub    $0xc,%esp
  8037f4:	ff 75 08             	pushl  0x8(%ebp)
  8037f7:	e8 68 ec ff ff       	call   802464 <get_block_size>
  8037fc:	83 c4 10             	add    $0x10,%esp
  8037ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803805:	83 e8 08             	sub    $0x8,%eax
  803808:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	83 e8 04             	sub    $0x4,%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	83 e0 fe             	and    $0xfffffffe,%eax
  803816:	89 c2                	mov    %eax,%edx
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	01 d0                	add    %edx,%eax
  80381d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803820:	83 ec 0c             	sub    $0xc,%esp
  803823:	ff 75 e4             	pushl  -0x1c(%ebp)
  803826:	e8 39 ec ff ff       	call   802464 <get_block_size>
  80382b:	83 c4 10             	add    $0x10,%esp
  80382e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803834:	83 e8 08             	sub    $0x8,%eax
  803837:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80383a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803840:	75 08                	jne    80384a <realloc_block_FF+0xc5>
	{
		 return va;
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	e9 44 06 00 00       	jmp    803e8e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80384a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803850:	0f 83 d5 03 00 00    	jae    803c2b <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803856:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803859:	2b 45 0c             	sub    0xc(%ebp),%eax
  80385c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80385f:	83 ec 0c             	sub    $0xc,%esp
  803862:	ff 75 e4             	pushl  -0x1c(%ebp)
  803865:	e8 13 ec ff ff       	call   80247d <is_free_block>
  80386a:	83 c4 10             	add    $0x10,%esp
  80386d:	84 c0                	test   %al,%al
  80386f:	0f 84 3b 01 00 00    	je     8039b0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803875:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803878:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80387b:	01 d0                	add    %edx,%eax
  80387d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803880:	83 ec 04             	sub    $0x4,%esp
  803883:	6a 01                	push   $0x1
  803885:	ff 75 f0             	pushl  -0x10(%ebp)
  803888:	ff 75 08             	pushl  0x8(%ebp)
  80388b:	e8 25 ef ff ff       	call   8027b5 <set_block_data>
  803890:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803893:	8b 45 08             	mov    0x8(%ebp),%eax
  803896:	83 e8 04             	sub    $0x4,%eax
  803899:	8b 00                	mov    (%eax),%eax
  80389b:	83 e0 fe             	and    $0xfffffffe,%eax
  80389e:	89 c2                	mov    %eax,%edx
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	01 d0                	add    %edx,%eax
  8038a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8038a8:	83 ec 04             	sub    $0x4,%esp
  8038ab:	6a 00                	push   $0x0
  8038ad:	ff 75 cc             	pushl  -0x34(%ebp)
  8038b0:	ff 75 c8             	pushl  -0x38(%ebp)
  8038b3:	e8 fd ee ff ff       	call   8027b5 <set_block_data>
  8038b8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038bf:	74 06                	je     8038c7 <realloc_block_FF+0x142>
  8038c1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8038c5:	75 17                	jne    8038de <realloc_block_FF+0x159>
  8038c7:	83 ec 04             	sub    $0x4,%esp
  8038ca:	68 b4 4c 80 00       	push   $0x804cb4
  8038cf:	68 f6 01 00 00       	push   $0x1f6
  8038d4:	68 41 4c 80 00       	push   $0x804c41
  8038d9:	e8 37 cf ff ff       	call   800815 <_panic>
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	8b 10                	mov    (%eax),%edx
  8038e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038e6:	89 10                	mov    %edx,(%eax)
  8038e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	74 0b                	je     8038fc <realloc_block_FF+0x177>
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 00                	mov    (%eax),%eax
  8038f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803902:	89 10                	mov    %edx,(%eax)
  803904:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390a:	89 50 04             	mov    %edx,0x4(%eax)
  80390d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803910:	8b 00                	mov    (%eax),%eax
  803912:	85 c0                	test   %eax,%eax
  803914:	75 08                	jne    80391e <realloc_block_FF+0x199>
  803916:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803919:	a3 30 50 80 00       	mov    %eax,0x805030
  80391e:	a1 38 50 80 00       	mov    0x805038,%eax
  803923:	40                   	inc    %eax
  803924:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392d:	75 17                	jne    803946 <realloc_block_FF+0x1c1>
  80392f:	83 ec 04             	sub    $0x4,%esp
  803932:	68 23 4c 80 00       	push   $0x804c23
  803937:	68 f7 01 00 00       	push   $0x1f7
  80393c:	68 41 4c 80 00       	push   $0x804c41
  803941:	e8 cf ce ff ff       	call   800815 <_panic>
  803946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	74 10                	je     80395f <realloc_block_FF+0x1da>
  80394f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803957:	8b 52 04             	mov    0x4(%edx),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	eb 0b                	jmp    80396a <realloc_block_FF+0x1e5>
  80395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803962:	8b 40 04             	mov    0x4(%eax),%eax
  803965:	a3 30 50 80 00       	mov    %eax,0x805030
  80396a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396d:	8b 40 04             	mov    0x4(%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0f                	je     803983 <realloc_block_FF+0x1fe>
  803974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803977:	8b 40 04             	mov    0x4(%eax),%eax
  80397a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80397d:	8b 12                	mov    (%edx),%edx
  80397f:	89 10                	mov    %edx,(%eax)
  803981:	eb 0a                	jmp    80398d <realloc_block_FF+0x208>
  803983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a5:	48                   	dec    %eax
  8039a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8039ab:	e9 73 02 00 00       	jmp    803c23 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8039b0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8039b4:	0f 86 69 02 00 00    	jbe    803c23 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	6a 01                	push   $0x1
  8039bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c2:	ff 75 08             	pushl  0x8(%ebp)
  8039c5:	e8 eb ed ff ff       	call   8027b5 <set_block_data>
  8039ca:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	83 e8 04             	sub    $0x4,%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	83 e0 fe             	and    $0xfffffffe,%eax
  8039d8:	89 c2                	mov    %eax,%edx
  8039da:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dd:	01 d0                	add    %edx,%eax
  8039df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8039e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8039ea:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039ee:	75 68                	jne    803a58 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039f4:	75 17                	jne    803a0d <realloc_block_FF+0x288>
  8039f6:	83 ec 04             	sub    $0x4,%esp
  8039f9:	68 5c 4c 80 00       	push   $0x804c5c
  8039fe:	68 06 02 00 00       	push   $0x206
  803a03:	68 41 4c 80 00       	push   $0x804c41
  803a08:	e8 08 ce ff ff       	call   800815 <_panic>
  803a0d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803a13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a16:	89 10                	mov    %edx,(%eax)
  803a18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 0d                	je     803a2e <realloc_block_FF+0x2a9>
  803a21:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a29:	89 50 04             	mov    %edx,0x4(%eax)
  803a2c:	eb 08                	jmp    803a36 <realloc_block_FF+0x2b1>
  803a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a31:	a3 30 50 80 00       	mov    %eax,0x805030
  803a36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a39:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a48:	a1 38 50 80 00       	mov    0x805038,%eax
  803a4d:	40                   	inc    %eax
  803a4e:	a3 38 50 80 00       	mov    %eax,0x805038
  803a53:	e9 b0 01 00 00       	jmp    803c08 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a58:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a5d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a60:	76 68                	jbe    803aca <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a66:	75 17                	jne    803a7f <realloc_block_FF+0x2fa>
  803a68:	83 ec 04             	sub    $0x4,%esp
  803a6b:	68 5c 4c 80 00       	push   $0x804c5c
  803a70:	68 0b 02 00 00       	push   $0x20b
  803a75:	68 41 4c 80 00       	push   $0x804c41
  803a7a:	e8 96 cd ff ff       	call   800815 <_panic>
  803a7f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803a85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a88:	89 10                	mov    %edx,(%eax)
  803a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 0d                	je     803aa0 <realloc_block_FF+0x31b>
  803a93:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a98:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a9b:	89 50 04             	mov    %edx,0x4(%eax)
  803a9e:	eb 08                	jmp    803aa8 <realloc_block_FF+0x323>
  803aa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa3:	a3 30 50 80 00       	mov    %eax,0x805030
  803aa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ab0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aba:	a1 38 50 80 00       	mov    0x805038,%eax
  803abf:	40                   	inc    %eax
  803ac0:	a3 38 50 80 00       	mov    %eax,0x805038
  803ac5:	e9 3e 01 00 00       	jmp    803c08 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803aca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803acf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ad2:	73 68                	jae    803b3c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ad4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ad8:	75 17                	jne    803af1 <realloc_block_FF+0x36c>
  803ada:	83 ec 04             	sub    $0x4,%esp
  803add:	68 90 4c 80 00       	push   $0x804c90
  803ae2:	68 10 02 00 00       	push   $0x210
  803ae7:	68 41 4c 80 00       	push   $0x804c41
  803aec:	e8 24 cd ff ff       	call   800815 <_panic>
  803af1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803af7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803afa:	89 50 04             	mov    %edx,0x4(%eax)
  803afd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b00:	8b 40 04             	mov    0x4(%eax),%eax
  803b03:	85 c0                	test   %eax,%eax
  803b05:	74 0c                	je     803b13 <realloc_block_FF+0x38e>
  803b07:	a1 30 50 80 00       	mov    0x805030,%eax
  803b0c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b0f:	89 10                	mov    %edx,(%eax)
  803b11:	eb 08                	jmp    803b1b <realloc_block_FF+0x396>
  803b13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b16:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1e:	a3 30 50 80 00       	mov    %eax,0x805030
  803b23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2c:	a1 38 50 80 00       	mov    0x805038,%eax
  803b31:	40                   	inc    %eax
  803b32:	a3 38 50 80 00       	mov    %eax,0x805038
  803b37:	e9 cc 00 00 00       	jmp    803c08 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b43:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b4b:	e9 8a 00 00 00       	jmp    803bda <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b56:	73 7a                	jae    803bd2 <realloc_block_FF+0x44d>
  803b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5b:	8b 00                	mov    (%eax),%eax
  803b5d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b60:	73 70                	jae    803bd2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b66:	74 06                	je     803b6e <realloc_block_FF+0x3e9>
  803b68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b6c:	75 17                	jne    803b85 <realloc_block_FF+0x400>
  803b6e:	83 ec 04             	sub    $0x4,%esp
  803b71:	68 b4 4c 80 00       	push   $0x804cb4
  803b76:	68 1a 02 00 00       	push   $0x21a
  803b7b:	68 41 4c 80 00       	push   $0x804c41
  803b80:	e8 90 cc ff ff       	call   800815 <_panic>
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	8b 10                	mov    (%eax),%edx
  803b8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8d:	89 10                	mov    %edx,(%eax)
  803b8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	85 c0                	test   %eax,%eax
  803b96:	74 0b                	je     803ba3 <realloc_block_FF+0x41e>
  803b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9b:	8b 00                	mov    (%eax),%eax
  803b9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ba0:	89 50 04             	mov    %edx,0x4(%eax)
  803ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ba9:	89 10                	mov    %edx,(%eax)
  803bab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bb1:	89 50 04             	mov    %edx,0x4(%eax)
  803bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb7:	8b 00                	mov    (%eax),%eax
  803bb9:	85 c0                	test   %eax,%eax
  803bbb:	75 08                	jne    803bc5 <realloc_block_FF+0x440>
  803bbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc0:	a3 30 50 80 00       	mov    %eax,0x805030
  803bc5:	a1 38 50 80 00       	mov    0x805038,%eax
  803bca:	40                   	inc    %eax
  803bcb:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803bd0:	eb 36                	jmp    803c08 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803bd2:	a1 34 50 80 00       	mov    0x805034,%eax
  803bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bde:	74 07                	je     803be7 <realloc_block_FF+0x462>
  803be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be3:	8b 00                	mov    (%eax),%eax
  803be5:	eb 05                	jmp    803bec <realloc_block_FF+0x467>
  803be7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bec:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf1:	a1 34 50 80 00       	mov    0x805034,%eax
  803bf6:	85 c0                	test   %eax,%eax
  803bf8:	0f 85 52 ff ff ff    	jne    803b50 <realloc_block_FF+0x3cb>
  803bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c02:	0f 85 48 ff ff ff    	jne    803b50 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c08:	83 ec 04             	sub    $0x4,%esp
  803c0b:	6a 00                	push   $0x0
  803c0d:	ff 75 d8             	pushl  -0x28(%ebp)
  803c10:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c13:	e8 9d eb ff ff       	call   8027b5 <set_block_data>
  803c18:	83 c4 10             	add    $0x10,%esp
				return va;
  803c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1e:	e9 6b 02 00 00       	jmp    803e8e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803c23:	8b 45 08             	mov    0x8(%ebp),%eax
  803c26:	e9 63 02 00 00       	jmp    803e8e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c31:	0f 86 4d 02 00 00    	jbe    803e84 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803c37:	83 ec 0c             	sub    $0xc,%esp
  803c3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c3d:	e8 3b e8 ff ff       	call   80247d <is_free_block>
  803c42:	83 c4 10             	add    $0x10,%esp
  803c45:	84 c0                	test   %al,%al
  803c47:	0f 84 37 02 00 00    	je     803e84 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c50:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c59:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c5c:	76 38                	jbe    803c96 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c5e:	83 ec 0c             	sub    $0xc,%esp
  803c61:	ff 75 0c             	pushl  0xc(%ebp)
  803c64:	e8 7b eb ff ff       	call   8027e4 <alloc_block_FF>
  803c69:	83 c4 10             	add    $0x10,%esp
  803c6c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c6f:	83 ec 08             	sub    $0x8,%esp
  803c72:	ff 75 c0             	pushl  -0x40(%ebp)
  803c75:	ff 75 08             	pushl  0x8(%ebp)
  803c78:	e8 c9 fa ff ff       	call   803746 <copy_data>
  803c7d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803c80:	83 ec 0c             	sub    $0xc,%esp
  803c83:	ff 75 08             	pushl  0x8(%ebp)
  803c86:	e8 fa f9 ff ff       	call   803685 <free_block>
  803c8b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c8e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c91:	e9 f8 01 00 00       	jmp    803e8e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c99:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c9c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c9f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ca3:	0f 87 a0 00 00 00    	ja     803d49 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ca9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cad:	75 17                	jne    803cc6 <realloc_block_FF+0x541>
  803caf:	83 ec 04             	sub    $0x4,%esp
  803cb2:	68 23 4c 80 00       	push   $0x804c23
  803cb7:	68 38 02 00 00       	push   $0x238
  803cbc:	68 41 4c 80 00       	push   $0x804c41
  803cc1:	e8 4f cb ff ff       	call   800815 <_panic>
  803cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc9:	8b 00                	mov    (%eax),%eax
  803ccb:	85 c0                	test   %eax,%eax
  803ccd:	74 10                	je     803cdf <realloc_block_FF+0x55a>
  803ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd2:	8b 00                	mov    (%eax),%eax
  803cd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd7:	8b 52 04             	mov    0x4(%edx),%edx
  803cda:	89 50 04             	mov    %edx,0x4(%eax)
  803cdd:	eb 0b                	jmp    803cea <realloc_block_FF+0x565>
  803cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce2:	8b 40 04             	mov    0x4(%eax),%eax
  803ce5:	a3 30 50 80 00       	mov    %eax,0x805030
  803cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ced:	8b 40 04             	mov    0x4(%eax),%eax
  803cf0:	85 c0                	test   %eax,%eax
  803cf2:	74 0f                	je     803d03 <realloc_block_FF+0x57e>
  803cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf7:	8b 40 04             	mov    0x4(%eax),%eax
  803cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cfd:	8b 12                	mov    (%edx),%edx
  803cff:	89 10                	mov    %edx,(%eax)
  803d01:	eb 0a                	jmp    803d0d <realloc_block_FF+0x588>
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 00                	mov    (%eax),%eax
  803d08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d20:	a1 38 50 80 00       	mov    0x805038,%eax
  803d25:	48                   	dec    %eax
  803d26:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d31:	01 d0                	add    %edx,%eax
  803d33:	83 ec 04             	sub    $0x4,%esp
  803d36:	6a 01                	push   $0x1
  803d38:	50                   	push   %eax
  803d39:	ff 75 08             	pushl  0x8(%ebp)
  803d3c:	e8 74 ea ff ff       	call   8027b5 <set_block_data>
  803d41:	83 c4 10             	add    $0x10,%esp
  803d44:	e9 36 01 00 00       	jmp    803e7f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d49:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d4c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d4f:	01 d0                	add    %edx,%eax
  803d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	6a 01                	push   $0x1
  803d59:	ff 75 f0             	pushl  -0x10(%ebp)
  803d5c:	ff 75 08             	pushl  0x8(%ebp)
  803d5f:	e8 51 ea ff ff       	call   8027b5 <set_block_data>
  803d64:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d67:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6a:	83 e8 04             	sub    $0x4,%eax
  803d6d:	8b 00                	mov    (%eax),%eax
  803d6f:	83 e0 fe             	and    $0xfffffffe,%eax
  803d72:	89 c2                	mov    %eax,%edx
  803d74:	8b 45 08             	mov    0x8(%ebp),%eax
  803d77:	01 d0                	add    %edx,%eax
  803d79:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d80:	74 06                	je     803d88 <realloc_block_FF+0x603>
  803d82:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d86:	75 17                	jne    803d9f <realloc_block_FF+0x61a>
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	68 b4 4c 80 00       	push   $0x804cb4
  803d90:	68 44 02 00 00       	push   $0x244
  803d95:	68 41 4c 80 00       	push   $0x804c41
  803d9a:	e8 76 ca ff ff       	call   800815 <_panic>
  803d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da2:	8b 10                	mov    (%eax),%edx
  803da4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803da7:	89 10                	mov    %edx,(%eax)
  803da9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	85 c0                	test   %eax,%eax
  803db0:	74 0b                	je     803dbd <realloc_block_FF+0x638>
  803db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db5:	8b 00                	mov    (%eax),%eax
  803db7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dba:	89 50 04             	mov    %edx,0x4(%eax)
  803dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dc3:	89 10                	mov    %edx,(%eax)
  803dc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dcb:	89 50 04             	mov    %edx,0x4(%eax)
  803dce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dd1:	8b 00                	mov    (%eax),%eax
  803dd3:	85 c0                	test   %eax,%eax
  803dd5:	75 08                	jne    803ddf <realloc_block_FF+0x65a>
  803dd7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dda:	a3 30 50 80 00       	mov    %eax,0x805030
  803ddf:	a1 38 50 80 00       	mov    0x805038,%eax
  803de4:	40                   	inc    %eax
  803de5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803dea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dee:	75 17                	jne    803e07 <realloc_block_FF+0x682>
  803df0:	83 ec 04             	sub    $0x4,%esp
  803df3:	68 23 4c 80 00       	push   $0x804c23
  803df8:	68 45 02 00 00       	push   $0x245
  803dfd:	68 41 4c 80 00       	push   $0x804c41
  803e02:	e8 0e ca ff ff       	call   800815 <_panic>
  803e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0a:	8b 00                	mov    (%eax),%eax
  803e0c:	85 c0                	test   %eax,%eax
  803e0e:	74 10                	je     803e20 <realloc_block_FF+0x69b>
  803e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e13:	8b 00                	mov    (%eax),%eax
  803e15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e18:	8b 52 04             	mov    0x4(%edx),%edx
  803e1b:	89 50 04             	mov    %edx,0x4(%eax)
  803e1e:	eb 0b                	jmp    803e2b <realloc_block_FF+0x6a6>
  803e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e23:	8b 40 04             	mov    0x4(%eax),%eax
  803e26:	a3 30 50 80 00       	mov    %eax,0x805030
  803e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2e:	8b 40 04             	mov    0x4(%eax),%eax
  803e31:	85 c0                	test   %eax,%eax
  803e33:	74 0f                	je     803e44 <realloc_block_FF+0x6bf>
  803e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e38:	8b 40 04             	mov    0x4(%eax),%eax
  803e3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e3e:	8b 12                	mov    (%edx),%edx
  803e40:	89 10                	mov    %edx,(%eax)
  803e42:	eb 0a                	jmp    803e4e <realloc_block_FF+0x6c9>
  803e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e61:	a1 38 50 80 00       	mov    0x805038,%eax
  803e66:	48                   	dec    %eax
  803e67:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803e6c:	83 ec 04             	sub    $0x4,%esp
  803e6f:	6a 00                	push   $0x0
  803e71:	ff 75 bc             	pushl  -0x44(%ebp)
  803e74:	ff 75 b8             	pushl  -0x48(%ebp)
  803e77:	e8 39 e9 ff ff       	call   8027b5 <set_block_data>
  803e7c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e82:	eb 0a                	jmp    803e8e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e84:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e8e:	c9                   	leave  
  803e8f:	c3                   	ret    

00803e90 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e90:	55                   	push   %ebp
  803e91:	89 e5                	mov    %esp,%ebp
  803e93:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e96:	83 ec 04             	sub    $0x4,%esp
  803e99:	68 20 4d 80 00       	push   $0x804d20
  803e9e:	68 58 02 00 00       	push   $0x258
  803ea3:	68 41 4c 80 00       	push   $0x804c41
  803ea8:	e8 68 c9 ff ff       	call   800815 <_panic>

00803ead <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ead:	55                   	push   %ebp
  803eae:	89 e5                	mov    %esp,%ebp
  803eb0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803eb3:	83 ec 04             	sub    $0x4,%esp
  803eb6:	68 48 4d 80 00       	push   $0x804d48
  803ebb:	68 61 02 00 00       	push   $0x261
  803ec0:	68 41 4c 80 00       	push   $0x804c41
  803ec5:	e8 4b c9 ff ff       	call   800815 <_panic>
  803eca:	66 90                	xchg   %ax,%ax

00803ecc <__udivdi3>:
  803ecc:	55                   	push   %ebp
  803ecd:	57                   	push   %edi
  803ece:	56                   	push   %esi
  803ecf:	53                   	push   %ebx
  803ed0:	83 ec 1c             	sub    $0x1c,%esp
  803ed3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ed7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803edb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803edf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ee3:	89 ca                	mov    %ecx,%edx
  803ee5:	89 f8                	mov    %edi,%eax
  803ee7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803eeb:	85 f6                	test   %esi,%esi
  803eed:	75 2d                	jne    803f1c <__udivdi3+0x50>
  803eef:	39 cf                	cmp    %ecx,%edi
  803ef1:	77 65                	ja     803f58 <__udivdi3+0x8c>
  803ef3:	89 fd                	mov    %edi,%ebp
  803ef5:	85 ff                	test   %edi,%edi
  803ef7:	75 0b                	jne    803f04 <__udivdi3+0x38>
  803ef9:	b8 01 00 00 00       	mov    $0x1,%eax
  803efe:	31 d2                	xor    %edx,%edx
  803f00:	f7 f7                	div    %edi
  803f02:	89 c5                	mov    %eax,%ebp
  803f04:	31 d2                	xor    %edx,%edx
  803f06:	89 c8                	mov    %ecx,%eax
  803f08:	f7 f5                	div    %ebp
  803f0a:	89 c1                	mov    %eax,%ecx
  803f0c:	89 d8                	mov    %ebx,%eax
  803f0e:	f7 f5                	div    %ebp
  803f10:	89 cf                	mov    %ecx,%edi
  803f12:	89 fa                	mov    %edi,%edx
  803f14:	83 c4 1c             	add    $0x1c,%esp
  803f17:	5b                   	pop    %ebx
  803f18:	5e                   	pop    %esi
  803f19:	5f                   	pop    %edi
  803f1a:	5d                   	pop    %ebp
  803f1b:	c3                   	ret    
  803f1c:	39 ce                	cmp    %ecx,%esi
  803f1e:	77 28                	ja     803f48 <__udivdi3+0x7c>
  803f20:	0f bd fe             	bsr    %esi,%edi
  803f23:	83 f7 1f             	xor    $0x1f,%edi
  803f26:	75 40                	jne    803f68 <__udivdi3+0x9c>
  803f28:	39 ce                	cmp    %ecx,%esi
  803f2a:	72 0a                	jb     803f36 <__udivdi3+0x6a>
  803f2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f30:	0f 87 9e 00 00 00    	ja     803fd4 <__udivdi3+0x108>
  803f36:	b8 01 00 00 00       	mov    $0x1,%eax
  803f3b:	89 fa                	mov    %edi,%edx
  803f3d:	83 c4 1c             	add    $0x1c,%esp
  803f40:	5b                   	pop    %ebx
  803f41:	5e                   	pop    %esi
  803f42:	5f                   	pop    %edi
  803f43:	5d                   	pop    %ebp
  803f44:	c3                   	ret    
  803f45:	8d 76 00             	lea    0x0(%esi),%esi
  803f48:	31 ff                	xor    %edi,%edi
  803f4a:	31 c0                	xor    %eax,%eax
  803f4c:	89 fa                	mov    %edi,%edx
  803f4e:	83 c4 1c             	add    $0x1c,%esp
  803f51:	5b                   	pop    %ebx
  803f52:	5e                   	pop    %esi
  803f53:	5f                   	pop    %edi
  803f54:	5d                   	pop    %ebp
  803f55:	c3                   	ret    
  803f56:	66 90                	xchg   %ax,%ax
  803f58:	89 d8                	mov    %ebx,%eax
  803f5a:	f7 f7                	div    %edi
  803f5c:	31 ff                	xor    %edi,%edi
  803f5e:	89 fa                	mov    %edi,%edx
  803f60:	83 c4 1c             	add    $0x1c,%esp
  803f63:	5b                   	pop    %ebx
  803f64:	5e                   	pop    %esi
  803f65:	5f                   	pop    %edi
  803f66:	5d                   	pop    %ebp
  803f67:	c3                   	ret    
  803f68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f6d:	89 eb                	mov    %ebp,%ebx
  803f6f:	29 fb                	sub    %edi,%ebx
  803f71:	89 f9                	mov    %edi,%ecx
  803f73:	d3 e6                	shl    %cl,%esi
  803f75:	89 c5                	mov    %eax,%ebp
  803f77:	88 d9                	mov    %bl,%cl
  803f79:	d3 ed                	shr    %cl,%ebp
  803f7b:	89 e9                	mov    %ebp,%ecx
  803f7d:	09 f1                	or     %esi,%ecx
  803f7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f83:	89 f9                	mov    %edi,%ecx
  803f85:	d3 e0                	shl    %cl,%eax
  803f87:	89 c5                	mov    %eax,%ebp
  803f89:	89 d6                	mov    %edx,%esi
  803f8b:	88 d9                	mov    %bl,%cl
  803f8d:	d3 ee                	shr    %cl,%esi
  803f8f:	89 f9                	mov    %edi,%ecx
  803f91:	d3 e2                	shl    %cl,%edx
  803f93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f97:	88 d9                	mov    %bl,%cl
  803f99:	d3 e8                	shr    %cl,%eax
  803f9b:	09 c2                	or     %eax,%edx
  803f9d:	89 d0                	mov    %edx,%eax
  803f9f:	89 f2                	mov    %esi,%edx
  803fa1:	f7 74 24 0c          	divl   0xc(%esp)
  803fa5:	89 d6                	mov    %edx,%esi
  803fa7:	89 c3                	mov    %eax,%ebx
  803fa9:	f7 e5                	mul    %ebp
  803fab:	39 d6                	cmp    %edx,%esi
  803fad:	72 19                	jb     803fc8 <__udivdi3+0xfc>
  803faf:	74 0b                	je     803fbc <__udivdi3+0xf0>
  803fb1:	89 d8                	mov    %ebx,%eax
  803fb3:	31 ff                	xor    %edi,%edi
  803fb5:	e9 58 ff ff ff       	jmp    803f12 <__udivdi3+0x46>
  803fba:	66 90                	xchg   %ax,%ax
  803fbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fc0:	89 f9                	mov    %edi,%ecx
  803fc2:	d3 e2                	shl    %cl,%edx
  803fc4:	39 c2                	cmp    %eax,%edx
  803fc6:	73 e9                	jae    803fb1 <__udivdi3+0xe5>
  803fc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fcb:	31 ff                	xor    %edi,%edi
  803fcd:	e9 40 ff ff ff       	jmp    803f12 <__udivdi3+0x46>
  803fd2:	66 90                	xchg   %ax,%ax
  803fd4:	31 c0                	xor    %eax,%eax
  803fd6:	e9 37 ff ff ff       	jmp    803f12 <__udivdi3+0x46>
  803fdb:	90                   	nop

00803fdc <__umoddi3>:
  803fdc:	55                   	push   %ebp
  803fdd:	57                   	push   %edi
  803fde:	56                   	push   %esi
  803fdf:	53                   	push   %ebx
  803fe0:	83 ec 1c             	sub    $0x1c,%esp
  803fe3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fe7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803feb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ff3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ff7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ffb:	89 f3                	mov    %esi,%ebx
  803ffd:	89 fa                	mov    %edi,%edx
  803fff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804003:	89 34 24             	mov    %esi,(%esp)
  804006:	85 c0                	test   %eax,%eax
  804008:	75 1a                	jne    804024 <__umoddi3+0x48>
  80400a:	39 f7                	cmp    %esi,%edi
  80400c:	0f 86 a2 00 00 00    	jbe    8040b4 <__umoddi3+0xd8>
  804012:	89 c8                	mov    %ecx,%eax
  804014:	89 f2                	mov    %esi,%edx
  804016:	f7 f7                	div    %edi
  804018:	89 d0                	mov    %edx,%eax
  80401a:	31 d2                	xor    %edx,%edx
  80401c:	83 c4 1c             	add    $0x1c,%esp
  80401f:	5b                   	pop    %ebx
  804020:	5e                   	pop    %esi
  804021:	5f                   	pop    %edi
  804022:	5d                   	pop    %ebp
  804023:	c3                   	ret    
  804024:	39 f0                	cmp    %esi,%eax
  804026:	0f 87 ac 00 00 00    	ja     8040d8 <__umoddi3+0xfc>
  80402c:	0f bd e8             	bsr    %eax,%ebp
  80402f:	83 f5 1f             	xor    $0x1f,%ebp
  804032:	0f 84 ac 00 00 00    	je     8040e4 <__umoddi3+0x108>
  804038:	bf 20 00 00 00       	mov    $0x20,%edi
  80403d:	29 ef                	sub    %ebp,%edi
  80403f:	89 fe                	mov    %edi,%esi
  804041:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804045:	89 e9                	mov    %ebp,%ecx
  804047:	d3 e0                	shl    %cl,%eax
  804049:	89 d7                	mov    %edx,%edi
  80404b:	89 f1                	mov    %esi,%ecx
  80404d:	d3 ef                	shr    %cl,%edi
  80404f:	09 c7                	or     %eax,%edi
  804051:	89 e9                	mov    %ebp,%ecx
  804053:	d3 e2                	shl    %cl,%edx
  804055:	89 14 24             	mov    %edx,(%esp)
  804058:	89 d8                	mov    %ebx,%eax
  80405a:	d3 e0                	shl    %cl,%eax
  80405c:	89 c2                	mov    %eax,%edx
  80405e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804062:	d3 e0                	shl    %cl,%eax
  804064:	89 44 24 04          	mov    %eax,0x4(%esp)
  804068:	8b 44 24 08          	mov    0x8(%esp),%eax
  80406c:	89 f1                	mov    %esi,%ecx
  80406e:	d3 e8                	shr    %cl,%eax
  804070:	09 d0                	or     %edx,%eax
  804072:	d3 eb                	shr    %cl,%ebx
  804074:	89 da                	mov    %ebx,%edx
  804076:	f7 f7                	div    %edi
  804078:	89 d3                	mov    %edx,%ebx
  80407a:	f7 24 24             	mull   (%esp)
  80407d:	89 c6                	mov    %eax,%esi
  80407f:	89 d1                	mov    %edx,%ecx
  804081:	39 d3                	cmp    %edx,%ebx
  804083:	0f 82 87 00 00 00    	jb     804110 <__umoddi3+0x134>
  804089:	0f 84 91 00 00 00    	je     804120 <__umoddi3+0x144>
  80408f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804093:	29 f2                	sub    %esi,%edx
  804095:	19 cb                	sbb    %ecx,%ebx
  804097:	89 d8                	mov    %ebx,%eax
  804099:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80409d:	d3 e0                	shl    %cl,%eax
  80409f:	89 e9                	mov    %ebp,%ecx
  8040a1:	d3 ea                	shr    %cl,%edx
  8040a3:	09 d0                	or     %edx,%eax
  8040a5:	89 e9                	mov    %ebp,%ecx
  8040a7:	d3 eb                	shr    %cl,%ebx
  8040a9:	89 da                	mov    %ebx,%edx
  8040ab:	83 c4 1c             	add    $0x1c,%esp
  8040ae:	5b                   	pop    %ebx
  8040af:	5e                   	pop    %esi
  8040b0:	5f                   	pop    %edi
  8040b1:	5d                   	pop    %ebp
  8040b2:	c3                   	ret    
  8040b3:	90                   	nop
  8040b4:	89 fd                	mov    %edi,%ebp
  8040b6:	85 ff                	test   %edi,%edi
  8040b8:	75 0b                	jne    8040c5 <__umoddi3+0xe9>
  8040ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8040bf:	31 d2                	xor    %edx,%edx
  8040c1:	f7 f7                	div    %edi
  8040c3:	89 c5                	mov    %eax,%ebp
  8040c5:	89 f0                	mov    %esi,%eax
  8040c7:	31 d2                	xor    %edx,%edx
  8040c9:	f7 f5                	div    %ebp
  8040cb:	89 c8                	mov    %ecx,%eax
  8040cd:	f7 f5                	div    %ebp
  8040cf:	89 d0                	mov    %edx,%eax
  8040d1:	e9 44 ff ff ff       	jmp    80401a <__umoddi3+0x3e>
  8040d6:	66 90                	xchg   %ax,%ax
  8040d8:	89 c8                	mov    %ecx,%eax
  8040da:	89 f2                	mov    %esi,%edx
  8040dc:	83 c4 1c             	add    $0x1c,%esp
  8040df:	5b                   	pop    %ebx
  8040e0:	5e                   	pop    %esi
  8040e1:	5f                   	pop    %edi
  8040e2:	5d                   	pop    %ebp
  8040e3:	c3                   	ret    
  8040e4:	3b 04 24             	cmp    (%esp),%eax
  8040e7:	72 06                	jb     8040ef <__umoddi3+0x113>
  8040e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040ed:	77 0f                	ja     8040fe <__umoddi3+0x122>
  8040ef:	89 f2                	mov    %esi,%edx
  8040f1:	29 f9                	sub    %edi,%ecx
  8040f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040f7:	89 14 24             	mov    %edx,(%esp)
  8040fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  804102:	8b 14 24             	mov    (%esp),%edx
  804105:	83 c4 1c             	add    $0x1c,%esp
  804108:	5b                   	pop    %ebx
  804109:	5e                   	pop    %esi
  80410a:	5f                   	pop    %edi
  80410b:	5d                   	pop    %ebp
  80410c:	c3                   	ret    
  80410d:	8d 76 00             	lea    0x0(%esi),%esi
  804110:	2b 04 24             	sub    (%esp),%eax
  804113:	19 fa                	sbb    %edi,%edx
  804115:	89 d1                	mov    %edx,%ecx
  804117:	89 c6                	mov    %eax,%esi
  804119:	e9 71 ff ff ff       	jmp    80408f <__umoddi3+0xb3>
  80411e:	66 90                	xchg   %ax,%ax
  804120:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804124:	72 ea                	jb     804110 <__umoddi3+0x134>
  804126:	89 d9                	mov    %ebx,%ecx
  804128:	e9 62 ff ff ff       	jmp    80408f <__umoddi3+0xb3>
