
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
  80005c:	68 a0 40 80 00       	push   $0x8040a0
  800061:	6a 13                	push   $0x13
  800063:	68 bc 40 80 00       	push   $0x8040bc
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
  800085:	68 d4 40 80 00       	push   $0x8040d4
  80008a:	e8 43 0a 00 00       	call   800ad2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 08 41 80 00       	push   $0x804108
  80009a:	e8 33 0a 00 00       	call   800ad2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 64 41 80 00       	push   $0x804164
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
  8000cb:	68 98 41 80 00       	push   $0x804198
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
  8000ea:	68 cc 41 80 00       	push   $0x8041cc
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
  80010c:	68 d0 41 80 00       	push   $0x8041d0
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
  80015c:	68 3c 42 80 00       	push   $0x80423c
  800161:	e8 6c 09 00 00       	call   800ad2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
		cprintf("50\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 d4 42 80 00       	push   $0x8042d4
  800171:	e8 5c 09 00 00       	call   800ad2 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
		sfree(x);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 69 1b 00 00       	call   801ced <sfree>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("52\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 d8 42 80 00       	push   $0x8042d8
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
  8001cf:	68 dc 42 80 00       	push   $0x8042dc
  8001d4:	e8 f9 08 00 00       	call   800ad2 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 27 43 80 00       	push   $0x804327
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
  800200:	68 40 43 80 00       	push   $0x804340
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
  80021f:	68 75 43 80 00       	push   $0x804375
  800224:	e8 77 19 00 00       	call   801ba0 <smalloc>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	6a 01                	push   $0x1
  800234:	68 00 10 00 00       	push   $0x1000
  800239:	68 cc 41 80 00       	push   $0x8041cc
  80023e:	e8 5d 19 00 00       	call   801ba0 <smalloc>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800249:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80024d:	75 17                	jne    800266 <_main+0x22e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 78 43 80 00       	push   $0x804378
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
  800299:	68 d0 43 80 00       	push   $0x8043d0
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
  8002ec:	68 dc 42 80 00       	push   $0x8042dc
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
  80033f:	68 dc 42 80 00       	push   $0x8042dc
  800344:	e8 89 07 00 00       	call   800ad2 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 25 44 80 00       	push   $0x804425
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
  800370:	68 3c 44 80 00       	push   $0x80443c
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
  80038f:	68 71 44 80 00       	push   $0x804471
  800394:	e8 07 18 00 00       	call   801ba0 <smalloc>
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	6a 01                	push   $0x1
  8003a4:	68 00 10 00 00       	push   $0x1000
  8003a9:	68 73 44 80 00       	push   $0x804473
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
  8003fc:	68 3c 42 80 00       	push   $0x80423c
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
  80044f:	68 dc 42 80 00       	push   $0x8042dc
  800454:	e8 79 06 00 00       	call   800ad2 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	6a 01                	push   $0x1
  800461:	68 ff 1f 00 00       	push   $0x1fff
  800466:	68 75 44 80 00       	push   $0x804475
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
  8004ae:	68 3c 42 80 00       	push   $0x80423c
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
  800501:	68 dc 42 80 00       	push   $0x8042dc
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
  800554:	68 dc 42 80 00       	push   $0x8042dc
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
  80057b:	68 71 44 80 00       	push   $0x804471
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
  8005a1:	68 73 44 80 00       	push   $0x804473
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
  8005c3:	68 75 44 80 00       	push   $0x804475
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
  800616:	68 3c 42 80 00       	push   $0x80423c
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
  80068f:	68 dc 42 80 00       	push   $0x8042dc
  800694:	e8 39 04 00 00       	call   800ad2 <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	68 77 44 80 00       	push   $0x804477
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
  8006c3:	68 90 44 80 00       	push   $0x804490
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
  800752:	68 e4 44 80 00       	push   $0x8044e4
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
  80077a:	68 0c 45 80 00       	push   $0x80450c
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
  8007ab:	68 34 45 80 00       	push   $0x804534
  8007b0:	e8 1d 03 00 00       	call   800ad2 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	50                   	push   %eax
  8007c7:	68 8c 45 80 00       	push   $0x80458c
  8007cc:	e8 01 03 00 00       	call   800ad2 <cprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	68 e4 44 80 00       	push   $0x8044e4
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
  800836:	68 a0 45 80 00       	push   $0x8045a0
  80083b:	e8 92 02 00 00       	call   800ad2 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800843:	a1 00 50 80 00       	mov    0x805000,%eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	50                   	push   %eax
  80084f:	68 a5 45 80 00       	push   $0x8045a5
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
  800873:	68 c1 45 80 00       	push   $0x8045c1
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
  8008a2:	68 c4 45 80 00       	push   $0x8045c4
  8008a7:	6a 26                	push   $0x26
  8008a9:	68 10 46 80 00       	push   $0x804610
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
  800977:	68 1c 46 80 00       	push   $0x80461c
  80097c:	6a 3a                	push   $0x3a
  80097e:	68 10 46 80 00       	push   $0x804610
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
  8009ea:	68 70 46 80 00       	push   $0x804670
  8009ef:	6a 44                	push   $0x44
  8009f1:	68 10 46 80 00       	push   $0x804610
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
  800b6f:	e8 bc 32 00 00       	call   803e30 <__udivdi3>
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
  800bbf:	e8 7c 33 00 00       	call   803f40 <__umoddi3>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	05 d4 48 80 00       	add    $0x8048d4,%eax
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
  800d1a:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
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
  800dfb:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  800e02:	85 f6                	test   %esi,%esi
  800e04:	75 19                	jne    800e1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e06:	53                   	push   %ebx
  800e07:	68 e5 48 80 00       	push   $0x8048e5
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
  800e20:	68 ee 48 80 00       	push   $0x8048ee
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
  800e4d:	be f1 48 80 00       	mov    $0x8048f1,%esi
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
  801858:	68 68 4a 80 00       	push   $0x804a68
  80185d:	68 3f 01 00 00       	push   $0x13f
  801862:	68 8a 4a 80 00       	push   $0x804a8a
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
  801902:	e8 41 0e 00 00       	call   802748 <alloc_block_FF>
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
  801925:	e8 da 12 00 00       	call   802c04 <alloc_block_BF>
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
  801ad3:	e8 f0 08 00 00       	call   8023c8 <get_block_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 00 1b 00 00       	call   8035e9 <free_block>
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
  801b89:	68 98 4a 80 00       	push   $0x804a98
  801b8e:	68 87 00 00 00       	push   $0x87
  801b93:	68 c2 4a 80 00       	push   $0x804ac2
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
  801d34:	68 d0 4a 80 00       	push   $0x804ad0
  801d39:	68 e4 00 00 00       	push   $0xe4
  801d3e:	68 c2 4a 80 00       	push   $0x804ac2
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
  801d51:	68 f6 4a 80 00       	push   $0x804af6
  801d56:	68 f0 00 00 00       	push   $0xf0
  801d5b:	68 c2 4a 80 00       	push   $0x804ac2
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
  801d6e:	68 f6 4a 80 00       	push   $0x804af6
  801d73:	68 f5 00 00 00       	push   $0xf5
  801d78:	68 c2 4a 80 00       	push   $0x804ac2
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
  801d8b:	68 f6 4a 80 00       	push   $0x804af6
  801d90:	68 fa 00 00 00       	push   $0xfa
  801d95:	68 c2 4a 80 00       	push   $0x804ac2
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

008023c8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	83 e8 04             	sub    $0x4,%eax
  8023d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8023d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	83 e8 04             	sub    $0x4,%eax
  8023ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8023f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	83 e0 01             	and    $0x1,%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 94 c0             	sete   %al
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80240c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240f:	83 f8 02             	cmp    $0x2,%eax
  802412:	74 2b                	je     80243f <alloc_block+0x40>
  802414:	83 f8 02             	cmp    $0x2,%eax
  802417:	7f 07                	jg     802420 <alloc_block+0x21>
  802419:	83 f8 01             	cmp    $0x1,%eax
  80241c:	74 0e                	je     80242c <alloc_block+0x2d>
  80241e:	eb 58                	jmp    802478 <alloc_block+0x79>
  802420:	83 f8 03             	cmp    $0x3,%eax
  802423:	74 2d                	je     802452 <alloc_block+0x53>
  802425:	83 f8 04             	cmp    $0x4,%eax
  802428:	74 3b                	je     802465 <alloc_block+0x66>
  80242a:	eb 4c                	jmp    802478 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	ff 75 08             	pushl  0x8(%ebp)
  802432:	e8 11 03 00 00       	call   802748 <alloc_block_FF>
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80243d:	eb 4a                	jmp    802489 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80243f:	83 ec 0c             	sub    $0xc,%esp
  802442:	ff 75 08             	pushl  0x8(%ebp)
  802445:	e8 c7 19 00 00       	call   803e11 <alloc_block_NF>
  80244a:	83 c4 10             	add    $0x10,%esp
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802450:	eb 37                	jmp    802489 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802452:	83 ec 0c             	sub    $0xc,%esp
  802455:	ff 75 08             	pushl  0x8(%ebp)
  802458:	e8 a7 07 00 00       	call   802c04 <alloc_block_BF>
  80245d:	83 c4 10             	add    $0x10,%esp
  802460:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802463:	eb 24                	jmp    802489 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802465:	83 ec 0c             	sub    $0xc,%esp
  802468:	ff 75 08             	pushl  0x8(%ebp)
  80246b:	e8 84 19 00 00       	call   803df4 <alloc_block_WF>
  802470:	83 c4 10             	add    $0x10,%esp
  802473:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802476:	eb 11                	jmp    802489 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802478:	83 ec 0c             	sub    $0xc,%esp
  80247b:	68 08 4b 80 00       	push   $0x804b08
  802480:	e8 4d e6 ff ff       	call   800ad2 <cprintf>
  802485:	83 c4 10             	add    $0x10,%esp
		break;
  802488:	90                   	nop
	}
	return va;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	53                   	push   %ebx
  802492:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	68 28 4b 80 00       	push   $0x804b28
  80249d:	e8 30 e6 ff ff       	call   800ad2 <cprintf>
  8024a2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	68 53 4b 80 00       	push   $0x804b53
  8024ad:	e8 20 e6 ff ff       	call   800ad2 <cprintf>
  8024b2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	eb 37                	jmp    8024f4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8024bd:	83 ec 0c             	sub    $0xc,%esp
  8024c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c3:	e8 19 ff ff ff       	call   8023e1 <is_free_block>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	0f be d8             	movsbl %al,%ebx
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d4:	e8 ef fe ff ff       	call   8023c8 <get_block_size>
  8024d9:	83 c4 10             	add    $0x10,%esp
  8024dc:	83 ec 04             	sub    $0x4,%esp
  8024df:	53                   	push   %ebx
  8024e0:	50                   	push   %eax
  8024e1:	68 6b 4b 80 00       	push   $0x804b6b
  8024e6:	e8 e7 e5 ff ff       	call   800ad2 <cprintf>
  8024eb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f8:	74 07                	je     802501 <print_blocks_list+0x73>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	eb 05                	jmp    802506 <print_blocks_list+0x78>
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
  802506:	89 45 10             	mov    %eax,0x10(%ebp)
  802509:	8b 45 10             	mov    0x10(%ebp),%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	75 ad                	jne    8024bd <print_blocks_list+0x2f>
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	75 a7                	jne    8024bd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802516:	83 ec 0c             	sub    $0xc,%esp
  802519:	68 28 4b 80 00       	push   $0x804b28
  80251e:	e8 af e5 ff ff       	call   800ad2 <cprintf>
  802523:	83 c4 10             	add    $0x10,%esp

}
  802526:	90                   	nop
  802527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802532:	8b 45 0c             	mov    0xc(%ebp),%eax
  802535:	83 e0 01             	and    $0x1,%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 03                	je     80253f <initialize_dynamic_allocator+0x13>
  80253c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80253f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802543:	0f 84 c7 01 00 00    	je     802710 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802549:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802550:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802553:	8b 55 08             	mov    0x8(%ebp),%edx
  802556:	8b 45 0c             	mov    0xc(%ebp),%eax
  802559:	01 d0                	add    %edx,%eax
  80255b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802560:	0f 87 ad 01 00 00    	ja     802713 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	0f 89 a5 01 00 00    	jns    802716 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802571:	8b 55 08             	mov    0x8(%ebp),%edx
  802574:	8b 45 0c             	mov    0xc(%ebp),%eax
  802577:	01 d0                	add    %edx,%eax
  802579:	83 e8 04             	sub    $0x4,%eax
  80257c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802581:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802588:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802590:	e9 87 00 00 00       	jmp    80261c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802599:	75 14                	jne    8025af <initialize_dynamic_allocator+0x83>
  80259b:	83 ec 04             	sub    $0x4,%esp
  80259e:	68 83 4b 80 00       	push   $0x804b83
  8025a3:	6a 79                	push   $0x79
  8025a5:	68 a1 4b 80 00       	push   $0x804ba1
  8025aa:	e8 66 e2 ff ff       	call   800815 <_panic>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 10                	je     8025c8 <initialize_dynamic_allocator+0x9c>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	8b 52 04             	mov    0x4(%edx),%edx
  8025c3:	89 50 04             	mov    %edx,0x4(%eax)
  8025c6:	eb 0b                	jmp    8025d3 <initialize_dynamic_allocator+0xa7>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 0f                	je     8025ec <initialize_dynamic_allocator+0xc0>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	8b 12                	mov    (%edx),%edx
  8025e8:	89 10                	mov    %edx,(%eax)
  8025ea:	eb 0a                	jmp    8025f6 <initialize_dynamic_allocator+0xca>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802609:	a1 38 50 80 00       	mov    0x805038,%eax
  80260e:	48                   	dec    %eax
  80260f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802614:	a1 34 50 80 00       	mov    0x805034,%eax
  802619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	74 07                	je     802629 <initialize_dynamic_allocator+0xfd>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	eb 05                	jmp    80262e <initialize_dynamic_allocator+0x102>
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	a3 34 50 80 00       	mov    %eax,0x805034
  802633:	a1 34 50 80 00       	mov    0x805034,%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	0f 85 55 ff ff ff    	jne    802595 <initialize_dynamic_allocator+0x69>
  802640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802644:	0f 85 4b ff ff ff    	jne    802595 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802653:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802659:	a1 44 50 80 00       	mov    0x805044,%eax
  80265e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802663:	a1 40 50 80 00       	mov    0x805040,%eax
  802668:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	83 c0 08             	add    $0x8,%eax
  802674:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	83 c0 04             	add    $0x4,%eax
  80267d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802680:	83 ea 08             	sub    $0x8,%edx
  802683:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	01 d0                	add    %edx,%eax
  80268d:	83 e8 08             	sub    $0x8,%eax
  802690:	8b 55 0c             	mov    0xc(%ebp),%edx
  802693:	83 ea 08             	sub    $0x8,%edx
  802696:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8026ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026af:	75 17                	jne    8026c8 <initialize_dynamic_allocator+0x19c>
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	68 bc 4b 80 00       	push   $0x804bbc
  8026b9:	68 90 00 00 00       	push   $0x90
  8026be:	68 a1 4b 80 00       	push   $0x804ba1
  8026c3:	e8 4d e1 ff ff       	call   800815 <_panic>
  8026c8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d1:	89 10                	mov    %edx,(%eax)
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 0d                	je     8026e9 <initialize_dynamic_allocator+0x1bd>
  8026dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e4:	89 50 04             	mov    %edx,0x4(%eax)
  8026e7:	eb 08                	jmp    8026f1 <initialize_dynamic_allocator+0x1c5>
  8026e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802703:	a1 38 50 80 00       	mov    0x805038,%eax
  802708:	40                   	inc    %eax
  802709:	a3 38 50 80 00       	mov    %eax,0x805038
  80270e:	eb 07                	jmp    802717 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802710:	90                   	nop
  802711:	eb 04                	jmp    802717 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802713:	90                   	nop
  802714:	eb 01                	jmp    802717 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802716:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80271c:	8b 45 10             	mov    0x10(%ebp),%eax
  80271f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	8d 50 fc             	lea    -0x4(%eax),%edx
  802728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	83 e8 04             	sub    $0x4,%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	83 e0 fe             	and    $0xfffffffe,%eax
  802738:	8d 50 f8             	lea    -0x8(%eax),%edx
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	01 c2                	add    %eax,%edx
  802740:	8b 45 0c             	mov    0xc(%ebp),%eax
  802743:	89 02                	mov    %eax,(%edx)
}
  802745:	90                   	nop
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	83 e0 01             	and    $0x1,%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 03                	je     80275b <alloc_block_FF+0x13>
  802758:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80275b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80275f:	77 07                	ja     802768 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802761:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802768:	a1 24 50 80 00       	mov    0x805024,%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	75 73                	jne    8027e4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	83 c0 10             	add    $0x10,%eax
  802777:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80277a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802781:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802787:	01 d0                	add    %edx,%eax
  802789:	48                   	dec    %eax
  80278a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80278d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802790:	ba 00 00 00 00       	mov    $0x0,%edx
  802795:	f7 75 ec             	divl   -0x14(%ebp)
  802798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279b:	29 d0                	sub    %edx,%eax
  80279d:	c1 e8 0c             	shr    $0xc,%eax
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	50                   	push   %eax
  8027a4:	e8 c3 f0 ff ff       	call   80186c <sbrk>
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027af:	83 ec 0c             	sub    $0xc,%esp
  8027b2:	6a 00                	push   $0x0
  8027b4:	e8 b3 f0 ff ff       	call   80186c <sbrk>
  8027b9:	83 c4 10             	add    $0x10,%esp
  8027bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027c5:	83 ec 08             	sub    $0x8,%esp
  8027c8:	50                   	push   %eax
  8027c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027cc:	e8 5b fd ff ff       	call   80252c <initialize_dynamic_allocator>
  8027d1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	68 df 4b 80 00       	push   $0x804bdf
  8027dc:	e8 f1 e2 ff ff       	call   800ad2 <cprintf>
  8027e1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8027e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e8:	75 0a                	jne    8027f4 <alloc_block_FF+0xac>
	        return NULL;
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ef:	e9 0e 04 00 00       	jmp    802c02 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8027f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802803:	e9 f3 02 00 00       	jmp    802afb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	ff 75 bc             	pushl  -0x44(%ebp)
  802814:	e8 af fb ff ff       	call   8023c8 <get_block_size>
  802819:	83 c4 10             	add    $0x10,%esp
  80281c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	83 c0 08             	add    $0x8,%eax
  802825:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802828:	0f 87 c5 02 00 00    	ja     802af3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	83 c0 18             	add    $0x18,%eax
  802834:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802837:	0f 87 19 02 00 00    	ja     802a56 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80283d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802840:	2b 45 08             	sub    0x8(%ebp),%eax
  802843:	83 e8 08             	sub    $0x8,%eax
  802846:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8d 50 08             	lea    0x8(%eax),%edx
  80284f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802852:	01 d0                	add    %edx,%eax
  802854:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	83 c0 08             	add    $0x8,%eax
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	6a 01                	push   $0x1
  802862:	50                   	push   %eax
  802863:	ff 75 bc             	pushl  -0x44(%ebp)
  802866:	e8 ae fe ff ff       	call   802719 <set_block_data>
  80286b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	75 68                	jne    8028e0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802878:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80287c:	75 17                	jne    802895 <alloc_block_FF+0x14d>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 bc 4b 80 00       	push   $0x804bbc
  802886:	68 d7 00 00 00       	push   $0xd7
  80288b:	68 a1 4b 80 00       	push   $0x804ba1
  802890:	e8 80 df ff ff       	call   800815 <_panic>
  802895:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80289b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 0d                	je     8028b6 <alloc_block_FF+0x16e>
  8028a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ae:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 08                	jmp    8028be <alloc_block_FF+0x176>
  8028b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d5:	40                   	inc    %eax
  8028d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8028db:	e9 dc 00 00 00       	jmp    8029bc <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	75 65                	jne    80294e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028e9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028ed:	75 17                	jne    802906 <alloc_block_FF+0x1be>
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 f0 4b 80 00       	push   $0x804bf0
  8028f7:	68 db 00 00 00       	push   $0xdb
  8028fc:	68 a1 4b 80 00       	push   $0x804ba1
  802901:	e8 0f df ff ff       	call   800815 <_panic>
  802906:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80290c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 0c                	je     802928 <alloc_block_FF+0x1e0>
  80291c:	a1 30 50 80 00       	mov    0x805030,%eax
  802921:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 08                	jmp    802930 <alloc_block_FF+0x1e8>
  802928:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80292b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802930:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802933:	a3 30 50 80 00       	mov    %eax,0x805030
  802938:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80293b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802941:	a1 38 50 80 00       	mov    0x805038,%eax
  802946:	40                   	inc    %eax
  802947:	a3 38 50 80 00       	mov    %eax,0x805038
  80294c:	eb 6e                	jmp    8029bc <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80294e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802952:	74 06                	je     80295a <alloc_block_FF+0x212>
  802954:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802958:	75 17                	jne    802971 <alloc_block_FF+0x229>
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	68 14 4c 80 00       	push   $0x804c14
  802962:	68 df 00 00 00       	push   $0xdf
  802967:	68 a1 4b 80 00       	push   $0x804ba1
  80296c:	e8 a4 de ff ff       	call   800815 <_panic>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 10                	mov    (%eax),%edx
  802976:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 0b                	je     80298f <alloc_block_FF+0x247>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	75 08                	jne    8029b1 <alloc_block_FF+0x269>
  8029a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b6:	40                   	inc    %eax
  8029b7:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8029bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_FF+0x291>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 83 4b 80 00       	push   $0x804b83
  8029ca:	68 e1 00 00 00       	push   $0xe1
  8029cf:	68 a1 4b 80 00       	push   $0x804ba1
  8029d4:	e8 3c de ff ff       	call   800815 <_panic>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 10                	je     8029f2 <alloc_block_FF+0x2aa>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ea:	8b 52 04             	mov    0x4(%edx),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	eb 0b                	jmp    8029fd <alloc_block_FF+0x2b5>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0f                	je     802a16 <alloc_block_FF+0x2ce>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a10:	8b 12                	mov    (%edx),%edx
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	eb 0a                	jmp    802a20 <alloc_block_FF+0x2d8>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a33:	a1 38 50 80 00       	mov    0x805038,%eax
  802a38:	48                   	dec    %eax
  802a39:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	6a 00                	push   $0x0
  802a43:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a46:	ff 75 b0             	pushl  -0x50(%ebp)
  802a49:	e8 cb fc ff ff       	call   802719 <set_block_data>
  802a4e:	83 c4 10             	add    $0x10,%esp
  802a51:	e9 95 00 00 00       	jmp    802aeb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	6a 01                	push   $0x1
  802a5b:	ff 75 b8             	pushl  -0x48(%ebp)
  802a5e:	ff 75 bc             	pushl  -0x44(%ebp)
  802a61:	e8 b3 fc ff ff       	call   802719 <set_block_data>
  802a66:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6d:	75 17                	jne    802a86 <alloc_block_FF+0x33e>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 83 4b 80 00       	push   $0x804b83
  802a77:	68 e8 00 00 00       	push   $0xe8
  802a7c:	68 a1 4b 80 00       	push   $0x804ba1
  802a81:	e8 8f dd ff ff       	call   800815 <_panic>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 10                	je     802a9f <alloc_block_FF+0x357>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a97:	8b 52 04             	mov    0x4(%edx),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%eax)
  802a9d:	eb 0b                	jmp    802aaa <alloc_block_FF+0x362>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	a3 30 50 80 00       	mov    %eax,0x805030
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 0f                	je     802ac3 <alloc_block_FF+0x37b>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abd:	8b 12                	mov    (%edx),%edx
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	eb 0a                	jmp    802acd <alloc_block_FF+0x385>
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae5:	48                   	dec    %eax
  802ae6:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802aeb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802aee:	e9 0f 01 00 00       	jmp    802c02 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802af3:	a1 34 50 80 00       	mov    0x805034,%eax
  802af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	74 07                	je     802b08 <alloc_block_FF+0x3c0>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	eb 05                	jmp    802b0d <alloc_block_FF+0x3c5>
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0d:	a3 34 50 80 00       	mov    %eax,0x805034
  802b12:	a1 34 50 80 00       	mov    0x805034,%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	0f 85 e9 fc ff ff    	jne    802808 <alloc_block_FF+0xc0>
  802b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b23:	0f 85 df fc ff ff    	jne    802808 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	83 c0 08             	add    $0x8,%eax
  802b2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b32:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b3f:	01 d0                	add    %edx,%eax
  802b41:	48                   	dec    %eax
  802b42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b48:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4d:	f7 75 d8             	divl   -0x28(%ebp)
  802b50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b53:	29 d0                	sub    %edx,%eax
  802b55:	c1 e8 0c             	shr    $0xc,%eax
  802b58:	83 ec 0c             	sub    $0xc,%esp
  802b5b:	50                   	push   %eax
  802b5c:	e8 0b ed ff ff       	call   80186c <sbrk>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b67:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b6b:	75 0a                	jne    802b77 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	e9 8b 00 00 00       	jmp    802c02 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b77:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b84:	01 d0                	add    %edx,%eax
  802b86:	48                   	dec    %eax
  802b87:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b92:	f7 75 cc             	divl   -0x34(%ebp)
  802b95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b98:	29 d0                	sub    %edx,%eax
  802b9a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ba0:	01 d0                	add    %edx,%eax
  802ba2:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802ba7:	a1 40 50 80 00       	mov    0x805040,%eax
  802bac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bb2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bbc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bbf:	01 d0                	add    %edx,%eax
  802bc1:	48                   	dec    %eax
  802bc2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcd:	f7 75 c4             	divl   -0x3c(%ebp)
  802bd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bd3:	29 d0                	sub    %edx,%eax
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	6a 01                	push   $0x1
  802bda:	50                   	push   %eax
  802bdb:	ff 75 d0             	pushl  -0x30(%ebp)
  802bde:	e8 36 fb ff ff       	call   802719 <set_block_data>
  802be3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802be6:	83 ec 0c             	sub    $0xc,%esp
  802be9:	ff 75 d0             	pushl  -0x30(%ebp)
  802bec:	e8 f8 09 00 00       	call   8035e9 <free_block>
  802bf1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802bf4:	83 ec 0c             	sub    $0xc,%esp
  802bf7:	ff 75 08             	pushl  0x8(%ebp)
  802bfa:	e8 49 fb ff ff       	call   802748 <alloc_block_FF>
  802bff:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	83 e0 01             	and    $0x1,%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 03                	je     802c17 <alloc_block_BF+0x13>
  802c14:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c17:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c1b:	77 07                	ja     802c24 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c1d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c24:	a1 24 50 80 00       	mov    0x805024,%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	75 73                	jne    802ca0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	83 c0 10             	add    $0x10,%eax
  802c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c36:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	48                   	dec    %eax
  802c46:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c51:	f7 75 e0             	divl   -0x20(%ebp)
  802c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c57:	29 d0                	sub    %edx,%eax
  802c59:	c1 e8 0c             	shr    $0xc,%eax
  802c5c:	83 ec 0c             	sub    $0xc,%esp
  802c5f:	50                   	push   %eax
  802c60:	e8 07 ec ff ff       	call   80186c <sbrk>
  802c65:	83 c4 10             	add    $0x10,%esp
  802c68:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c6b:	83 ec 0c             	sub    $0xc,%esp
  802c6e:	6a 00                	push   $0x0
  802c70:	e8 f7 eb ff ff       	call   80186c <sbrk>
  802c75:	83 c4 10             	add    $0x10,%esp
  802c78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c7e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c81:	83 ec 08             	sub    $0x8,%esp
  802c84:	50                   	push   %eax
  802c85:	ff 75 d8             	pushl  -0x28(%ebp)
  802c88:	e8 9f f8 ff ff       	call   80252c <initialize_dynamic_allocator>
  802c8d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c90:	83 ec 0c             	sub    $0xc,%esp
  802c93:	68 df 4b 80 00       	push   $0x804bdf
  802c98:	e8 35 de ff ff       	call   800ad2 <cprintf>
  802c9d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ca0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ca7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802cae:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802cb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802cbc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc4:	e9 1d 01 00 00       	jmp    802de6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ccf:	83 ec 0c             	sub    $0xc,%esp
  802cd2:	ff 75 a8             	pushl  -0x58(%ebp)
  802cd5:	e8 ee f6 ff ff       	call   8023c8 <get_block_size>
  802cda:	83 c4 10             	add    $0x10,%esp
  802cdd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	83 c0 08             	add    $0x8,%eax
  802ce6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ce9:	0f 87 ef 00 00 00    	ja     802dde <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	83 c0 18             	add    $0x18,%eax
  802cf5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cf8:	77 1d                	ja     802d17 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d00:	0f 86 d8 00 00 00    	jbe    802dde <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d06:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d0c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d12:	e9 c7 00 00 00       	jmp    802dde <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	83 c0 08             	add    $0x8,%eax
  802d1d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d20:	0f 85 9d 00 00 00    	jne    802dc3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d26:	83 ec 04             	sub    $0x4,%esp
  802d29:	6a 01                	push   $0x1
  802d2b:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d2e:	ff 75 a8             	pushl  -0x58(%ebp)
  802d31:	e8 e3 f9 ff ff       	call   802719 <set_block_data>
  802d36:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3d:	75 17                	jne    802d56 <alloc_block_BF+0x152>
  802d3f:	83 ec 04             	sub    $0x4,%esp
  802d42:	68 83 4b 80 00       	push   $0x804b83
  802d47:	68 2c 01 00 00       	push   $0x12c
  802d4c:	68 a1 4b 80 00       	push   $0x804ba1
  802d51:	e8 bf da ff ff       	call   800815 <_panic>
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 10                	je     802d6f <alloc_block_BF+0x16b>
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d67:	8b 52 04             	mov    0x4(%edx),%edx
  802d6a:	89 50 04             	mov    %edx,0x4(%eax)
  802d6d:	eb 0b                	jmp    802d7a <alloc_block_BF+0x176>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	a3 30 50 80 00       	mov    %eax,0x805030
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0f                	je     802d93 <alloc_block_BF+0x18f>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8d:	8b 12                	mov    (%edx),%edx
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	eb 0a                	jmp    802d9d <alloc_block_BF+0x199>
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db0:	a1 38 50 80 00       	mov    0x805038,%eax
  802db5:	48                   	dec    %eax
  802db6:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802dbb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dbe:	e9 01 04 00 00       	jmp    8031c4 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dc9:	76 13                	jbe    802dde <alloc_block_BF+0x1da>
					{
						internal = 1;
  802dcb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802dd2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802dd8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802dde:	a1 34 50 80 00       	mov    0x805034,%eax
  802de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dea:	74 07                	je     802df3 <alloc_block_BF+0x1ef>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	eb 05                	jmp    802df8 <alloc_block_BF+0x1f4>
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	a3 34 50 80 00       	mov    %eax,0x805034
  802dfd:	a1 34 50 80 00       	mov    0x805034,%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	0f 85 bf fe ff ff    	jne    802cc9 <alloc_block_BF+0xc5>
  802e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0e:	0f 85 b5 fe ff ff    	jne    802cc9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e18:	0f 84 26 02 00 00    	je     803044 <alloc_block_BF+0x440>
  802e1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e22:	0f 85 1c 02 00 00    	jne    803044 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2e:	83 e8 08             	sub    $0x8,%eax
  802e31:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8d 50 08             	lea    0x8(%eax),%edx
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	01 d0                	add    %edx,%eax
  802e3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	83 c0 08             	add    $0x8,%eax
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	6a 01                	push   $0x1
  802e4d:	50                   	push   %eax
  802e4e:	ff 75 f0             	pushl  -0x10(%ebp)
  802e51:	e8 c3 f8 ff ff       	call   802719 <set_block_data>
  802e56:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	75 68                	jne    802ecb <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e63:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e67:	75 17                	jne    802e80 <alloc_block_BF+0x27c>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 bc 4b 80 00       	push   $0x804bbc
  802e71:	68 45 01 00 00       	push   $0x145
  802e76:	68 a1 4b 80 00       	push   $0x804ba1
  802e7b:	e8 95 d9 ff ff       	call   800815 <_panic>
  802e80:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 0d                	je     802ea1 <alloc_block_BF+0x29d>
  802e94:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e99:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	eb 08                	jmp    802ea9 <alloc_block_BF+0x2a5>
  802ea1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebb:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec0:	40                   	inc    %eax
  802ec1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ec6:	e9 dc 00 00 00       	jmp    802fa7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	75 65                	jne    802f39 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ed4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ed8:	75 17                	jne    802ef1 <alloc_block_BF+0x2ed>
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	68 f0 4b 80 00       	push   $0x804bf0
  802ee2:	68 4a 01 00 00       	push   $0x14a
  802ee7:	68 a1 4b 80 00       	push   $0x804ba1
  802eec:	e8 24 d9 ff ff       	call   800815 <_panic>
  802ef1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ef7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 0c                	je     802f13 <alloc_block_BF+0x30f>
  802f07:	a1 30 50 80 00       	mov    0x805030,%eax
  802f0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	eb 08                	jmp    802f1b <alloc_block_BF+0x317>
  802f13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f16:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802f23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2c:	a1 38 50 80 00       	mov    0x805038,%eax
  802f31:	40                   	inc    %eax
  802f32:	a3 38 50 80 00       	mov    %eax,0x805038
  802f37:	eb 6e                	jmp    802fa7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f3d:	74 06                	je     802f45 <alloc_block_BF+0x341>
  802f3f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f43:	75 17                	jne    802f5c <alloc_block_BF+0x358>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 14 4c 80 00       	push   $0x804c14
  802f4d:	68 4f 01 00 00       	push   $0x14f
  802f52:	68 a1 4b 80 00       	push   $0x804ba1
  802f57:	e8 b9 d8 ff ff       	call   800815 <_panic>
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	8b 10                	mov    (%eax),%edx
  802f61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0b                	je     802f7a <alloc_block_BF+0x376>
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f88:	89 50 04             	mov    %edx,0x4(%eax)
  802f8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	75 08                	jne    802f9c <alloc_block_BF+0x398>
  802f94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f97:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa1:	40                   	inc    %eax
  802fa2:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fab:	75 17                	jne    802fc4 <alloc_block_BF+0x3c0>
  802fad:	83 ec 04             	sub    $0x4,%esp
  802fb0:	68 83 4b 80 00       	push   $0x804b83
  802fb5:	68 51 01 00 00       	push   $0x151
  802fba:	68 a1 4b 80 00       	push   $0x804ba1
  802fbf:	e8 51 d8 ff ff       	call   800815 <_panic>
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 10                	je     802fdd <alloc_block_BF+0x3d9>
  802fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd5:	8b 52 04             	mov    0x4(%edx),%edx
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	eb 0b                	jmp    802fe8 <alloc_block_BF+0x3e4>
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	8b 40 04             	mov    0x4(%eax),%eax
  802fe3:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	74 0f                	je     803001 <alloc_block_BF+0x3fd>
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 40 04             	mov    0x4(%eax),%eax
  802ff8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ffb:	8b 12                	mov    (%edx),%edx
  802ffd:	89 10                	mov    %edx,(%eax)
  802fff:	eb 0a                	jmp    80300b <alloc_block_BF+0x407>
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301e:	a1 38 50 80 00       	mov    0x805038,%eax
  803023:	48                   	dec    %eax
  803024:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	6a 00                	push   $0x0
  80302e:	ff 75 d0             	pushl  -0x30(%ebp)
  803031:	ff 75 cc             	pushl  -0x34(%ebp)
  803034:	e8 e0 f6 ff ff       	call   802719 <set_block_data>
  803039:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80303c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303f:	e9 80 01 00 00       	jmp    8031c4 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803044:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803048:	0f 85 9d 00 00 00    	jne    8030eb <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80304e:	83 ec 04             	sub    $0x4,%esp
  803051:	6a 01                	push   $0x1
  803053:	ff 75 ec             	pushl  -0x14(%ebp)
  803056:	ff 75 f0             	pushl  -0x10(%ebp)
  803059:	e8 bb f6 ff ff       	call   802719 <set_block_data>
  80305e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803065:	75 17                	jne    80307e <alloc_block_BF+0x47a>
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	68 83 4b 80 00       	push   $0x804b83
  80306f:	68 58 01 00 00       	push   $0x158
  803074:	68 a1 4b 80 00       	push   $0x804ba1
  803079:	e8 97 d7 ff ff       	call   800815 <_panic>
  80307e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 10                	je     803097 <alloc_block_BF+0x493>
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80308f:	8b 52 04             	mov    0x4(%edx),%edx
  803092:	89 50 04             	mov    %edx,0x4(%eax)
  803095:	eb 0b                	jmp    8030a2 <alloc_block_BF+0x49e>
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	74 0f                	je     8030bb <alloc_block_BF+0x4b7>
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b5:	8b 12                	mov    (%edx),%edx
  8030b7:	89 10                	mov    %edx,(%eax)
  8030b9:	eb 0a                	jmp    8030c5 <alloc_block_BF+0x4c1>
  8030bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8030dd:	48                   	dec    %eax
  8030de:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	e9 d9 00 00 00       	jmp    8031c4 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	83 c0 08             	add    $0x8,%eax
  8030f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8030f4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803101:	01 d0                	add    %edx,%eax
  803103:	48                   	dec    %eax
  803104:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803107:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80310a:	ba 00 00 00 00       	mov    $0x0,%edx
  80310f:	f7 75 c4             	divl   -0x3c(%ebp)
  803112:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803115:	29 d0                	sub    %edx,%eax
  803117:	c1 e8 0c             	shr    $0xc,%eax
  80311a:	83 ec 0c             	sub    $0xc,%esp
  80311d:	50                   	push   %eax
  80311e:	e8 49 e7 ff ff       	call   80186c <sbrk>
  803123:	83 c4 10             	add    $0x10,%esp
  803126:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803129:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80312d:	75 0a                	jne    803139 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80312f:	b8 00 00 00 00       	mov    $0x0,%eax
  803134:	e9 8b 00 00 00       	jmp    8031c4 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803139:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803140:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803143:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803146:	01 d0                	add    %edx,%eax
  803148:	48                   	dec    %eax
  803149:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80314c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80314f:	ba 00 00 00 00       	mov    $0x0,%edx
  803154:	f7 75 b8             	divl   -0x48(%ebp)
  803157:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80315a:	29 d0                	sub    %edx,%eax
  80315c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80315f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803162:	01 d0                	add    %edx,%eax
  803164:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803169:	a1 40 50 80 00       	mov    0x805040,%eax
  80316e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803174:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80317b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80317e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803181:	01 d0                	add    %edx,%eax
  803183:	48                   	dec    %eax
  803184:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803187:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80318a:	ba 00 00 00 00       	mov    $0x0,%edx
  80318f:	f7 75 b0             	divl   -0x50(%ebp)
  803192:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803195:	29 d0                	sub    %edx,%eax
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	6a 01                	push   $0x1
  80319c:	50                   	push   %eax
  80319d:	ff 75 bc             	pushl  -0x44(%ebp)
  8031a0:	e8 74 f5 ff ff       	call   802719 <set_block_data>
  8031a5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8031a8:	83 ec 0c             	sub    $0xc,%esp
  8031ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8031ae:	e8 36 04 00 00       	call   8035e9 <free_block>
  8031b3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8031b6:	83 ec 0c             	sub    $0xc,%esp
  8031b9:	ff 75 08             	pushl  0x8(%ebp)
  8031bc:	e8 43 fa ff ff       	call   802c04 <alloc_block_BF>
  8031c1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8031c4:	c9                   	leave  
  8031c5:	c3                   	ret    

008031c6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
  8031c9:	53                   	push   %ebx
  8031ca:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8031cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8031db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031df:	74 1e                	je     8031ff <merging+0x39>
  8031e1:	ff 75 08             	pushl  0x8(%ebp)
  8031e4:	e8 df f1 ff ff       	call   8023c8 <get_block_size>
  8031e9:	83 c4 04             	add    $0x4,%esp
  8031ec:	89 c2                	mov    %eax,%edx
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	01 d0                	add    %edx,%eax
  8031f3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8031f6:	75 07                	jne    8031ff <merging+0x39>
		prev_is_free = 1;
  8031f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8031ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803203:	74 1e                	je     803223 <merging+0x5d>
  803205:	ff 75 10             	pushl  0x10(%ebp)
  803208:	e8 bb f1 ff ff       	call   8023c8 <get_block_size>
  80320d:	83 c4 04             	add    $0x4,%esp
  803210:	89 c2                	mov    %eax,%edx
  803212:	8b 45 10             	mov    0x10(%ebp),%eax
  803215:	01 d0                	add    %edx,%eax
  803217:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80321a:	75 07                	jne    803223 <merging+0x5d>
		next_is_free = 1;
  80321c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	0f 84 cc 00 00 00    	je     8032f9 <merging+0x133>
  80322d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803231:	0f 84 c2 00 00 00    	je     8032f9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803237:	ff 75 08             	pushl  0x8(%ebp)
  80323a:	e8 89 f1 ff ff       	call   8023c8 <get_block_size>
  80323f:	83 c4 04             	add    $0x4,%esp
  803242:	89 c3                	mov    %eax,%ebx
  803244:	ff 75 10             	pushl  0x10(%ebp)
  803247:	e8 7c f1 ff ff       	call   8023c8 <get_block_size>
  80324c:	83 c4 04             	add    $0x4,%esp
  80324f:	01 c3                	add    %eax,%ebx
  803251:	ff 75 0c             	pushl  0xc(%ebp)
  803254:	e8 6f f1 ff ff       	call   8023c8 <get_block_size>
  803259:	83 c4 04             	add    $0x4,%esp
  80325c:	01 d8                	add    %ebx,%eax
  80325e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803261:	6a 00                	push   $0x0
  803263:	ff 75 ec             	pushl  -0x14(%ebp)
  803266:	ff 75 08             	pushl  0x8(%ebp)
  803269:	e8 ab f4 ff ff       	call   802719 <set_block_data>
  80326e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803271:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803275:	75 17                	jne    80328e <merging+0xc8>
  803277:	83 ec 04             	sub    $0x4,%esp
  80327a:	68 83 4b 80 00       	push   $0x804b83
  80327f:	68 7d 01 00 00       	push   $0x17d
  803284:	68 a1 4b 80 00       	push   $0x804ba1
  803289:	e8 87 d5 ff ff       	call   800815 <_panic>
  80328e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 10                	je     8032a7 <merging+0xe1>
  803297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80329f:	8b 52 04             	mov    0x4(%edx),%edx
  8032a2:	89 50 04             	mov    %edx,0x4(%eax)
  8032a5:	eb 0b                	jmp    8032b2 <merging+0xec>
  8032a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b5:	8b 40 04             	mov    0x4(%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0f                	je     8032cb <merging+0x105>
  8032bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bf:	8b 40 04             	mov    0x4(%eax),%eax
  8032c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c5:	8b 12                	mov    (%edx),%edx
  8032c7:	89 10                	mov    %edx,(%eax)
  8032c9:	eb 0a                	jmp    8032d5 <merging+0x10f>
  8032cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ed:	48                   	dec    %eax
  8032ee:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8032f3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032f4:	e9 ea 02 00 00       	jmp    8035e3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8032f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fd:	74 3b                	je     80333a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8032ff:	83 ec 0c             	sub    $0xc,%esp
  803302:	ff 75 08             	pushl  0x8(%ebp)
  803305:	e8 be f0 ff ff       	call   8023c8 <get_block_size>
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	89 c3                	mov    %eax,%ebx
  80330f:	83 ec 0c             	sub    $0xc,%esp
  803312:	ff 75 10             	pushl  0x10(%ebp)
  803315:	e8 ae f0 ff ff       	call   8023c8 <get_block_size>
  80331a:	83 c4 10             	add    $0x10,%esp
  80331d:	01 d8                	add    %ebx,%eax
  80331f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803322:	83 ec 04             	sub    $0x4,%esp
  803325:	6a 00                	push   $0x0
  803327:	ff 75 e8             	pushl  -0x18(%ebp)
  80332a:	ff 75 08             	pushl  0x8(%ebp)
  80332d:	e8 e7 f3 ff ff       	call   802719 <set_block_data>
  803332:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803335:	e9 a9 02 00 00       	jmp    8035e3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80333a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333e:	0f 84 2d 01 00 00    	je     803471 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803344:	83 ec 0c             	sub    $0xc,%esp
  803347:	ff 75 10             	pushl  0x10(%ebp)
  80334a:	e8 79 f0 ff ff       	call   8023c8 <get_block_size>
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	89 c3                	mov    %eax,%ebx
  803354:	83 ec 0c             	sub    $0xc,%esp
  803357:	ff 75 0c             	pushl  0xc(%ebp)
  80335a:	e8 69 f0 ff ff       	call   8023c8 <get_block_size>
  80335f:	83 c4 10             	add    $0x10,%esp
  803362:	01 d8                	add    %ebx,%eax
  803364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	6a 00                	push   $0x0
  80336c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80336f:	ff 75 10             	pushl  0x10(%ebp)
  803372:	e8 a2 f3 ff ff       	call   802719 <set_block_data>
  803377:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80337a:	8b 45 10             	mov    0x10(%ebp),%eax
  80337d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803384:	74 06                	je     80338c <merging+0x1c6>
  803386:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80338a:	75 17                	jne    8033a3 <merging+0x1dd>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 48 4c 80 00       	push   $0x804c48
  803394:	68 8d 01 00 00       	push   $0x18d
  803399:	68 a1 4b 80 00       	push   $0x804ba1
  80339e:	e8 72 d4 ff ff       	call   800815 <_panic>
  8033a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a6:	8b 50 04             	mov    0x4(%eax),%edx
  8033a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ac:	89 50 04             	mov    %edx,0x4(%eax)
  8033af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ba:	8b 40 04             	mov    0x4(%eax),%eax
  8033bd:	85 c0                	test   %eax,%eax
  8033bf:	74 0d                	je     8033ce <merging+0x208>
  8033c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c4:	8b 40 04             	mov    0x4(%eax),%eax
  8033c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ca:	89 10                	mov    %edx,(%eax)
  8033cc:	eb 08                	jmp    8033d6 <merging+0x210>
  8033ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e4:	40                   	inc    %eax
  8033e5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8033ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ee:	75 17                	jne    803407 <merging+0x241>
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 83 4b 80 00       	push   $0x804b83
  8033f8:	68 8e 01 00 00       	push   $0x18e
  8033fd:	68 a1 4b 80 00       	push   $0x804ba1
  803402:	e8 0e d4 ff ff       	call   800815 <_panic>
  803407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340a:	8b 00                	mov    (%eax),%eax
  80340c:	85 c0                	test   %eax,%eax
  80340e:	74 10                	je     803420 <merging+0x25a>
  803410:	8b 45 0c             	mov    0xc(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	8b 55 0c             	mov    0xc(%ebp),%edx
  803418:	8b 52 04             	mov    0x4(%edx),%edx
  80341b:	89 50 04             	mov    %edx,0x4(%eax)
  80341e:	eb 0b                	jmp    80342b <merging+0x265>
  803420:	8b 45 0c             	mov    0xc(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	a3 30 50 80 00       	mov    %eax,0x805030
  80342b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0f                	je     803444 <merging+0x27e>
  803435:	8b 45 0c             	mov    0xc(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343e:	8b 12                	mov    (%edx),%edx
  803440:	89 10                	mov    %edx,(%eax)
  803442:	eb 0a                	jmp    80344e <merging+0x288>
  803444:	8b 45 0c             	mov    0xc(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803461:	a1 38 50 80 00       	mov    0x805038,%eax
  803466:	48                   	dec    %eax
  803467:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80346c:	e9 72 01 00 00       	jmp    8035e3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803471:	8b 45 10             	mov    0x10(%ebp),%eax
  803474:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803477:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347b:	74 79                	je     8034f6 <merging+0x330>
  80347d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803481:	74 73                	je     8034f6 <merging+0x330>
  803483:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803487:	74 06                	je     80348f <merging+0x2c9>
  803489:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80348d:	75 17                	jne    8034a6 <merging+0x2e0>
  80348f:	83 ec 04             	sub    $0x4,%esp
  803492:	68 14 4c 80 00       	push   $0x804c14
  803497:	68 94 01 00 00       	push   $0x194
  80349c:	68 a1 4b 80 00       	push   $0x804ba1
  8034a1:	e8 6f d3 ff ff       	call   800815 <_panic>
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	8b 10                	mov    (%eax),%edx
  8034ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ae:	89 10                	mov    %edx,(%eax)
  8034b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 0b                	je     8034c4 <merging+0x2fe>
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034c1:	89 50 04             	mov    %edx,0x4(%eax)
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ca:	89 10                	mov    %edx,(%eax)
  8034cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	75 08                	jne    8034e6 <merging+0x320>
  8034de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8034eb:	40                   	inc    %eax
  8034ec:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f1:	e9 ce 00 00 00       	jmp    8035c4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8034f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fa:	74 65                	je     803561 <merging+0x39b>
  8034fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803500:	75 17                	jne    803519 <merging+0x353>
  803502:	83 ec 04             	sub    $0x4,%esp
  803505:	68 f0 4b 80 00       	push   $0x804bf0
  80350a:	68 95 01 00 00       	push   $0x195
  80350f:	68 a1 4b 80 00       	push   $0x804ba1
  803514:	e8 fc d2 ff ff       	call   800815 <_panic>
  803519:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80351f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803522:	89 50 04             	mov    %edx,0x4(%eax)
  803525:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803528:	8b 40 04             	mov    0x4(%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 0c                	je     80353b <merging+0x375>
  80352f:	a1 30 50 80 00       	mov    0x805030,%eax
  803534:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803537:	89 10                	mov    %edx,(%eax)
  803539:	eb 08                	jmp    803543 <merging+0x37d>
  80353b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803543:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803546:	a3 30 50 80 00       	mov    %eax,0x805030
  80354b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803554:	a1 38 50 80 00       	mov    0x805038,%eax
  803559:	40                   	inc    %eax
  80355a:	a3 38 50 80 00       	mov    %eax,0x805038
  80355f:	eb 63                	jmp    8035c4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803561:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803565:	75 17                	jne    80357e <merging+0x3b8>
  803567:	83 ec 04             	sub    $0x4,%esp
  80356a:	68 bc 4b 80 00       	push   $0x804bbc
  80356f:	68 98 01 00 00       	push   $0x198
  803574:	68 a1 4b 80 00       	push   $0x804ba1
  803579:	e8 97 d2 ff ff       	call   800815 <_panic>
  80357e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803584:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803587:	89 10                	mov    %edx,(%eax)
  803589:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0d                	je     80359f <merging+0x3d9>
  803592:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803597:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80359a:	89 50 04             	mov    %edx,0x4(%eax)
  80359d:	eb 08                	jmp    8035a7 <merging+0x3e1>
  80359f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035be:	40                   	inc    %eax
  8035bf:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8035c4:	83 ec 0c             	sub    $0xc,%esp
  8035c7:	ff 75 10             	pushl  0x10(%ebp)
  8035ca:	e8 f9 ed ff ff       	call   8023c8 <get_block_size>
  8035cf:	83 c4 10             	add    $0x10,%esp
  8035d2:	83 ec 04             	sub    $0x4,%esp
  8035d5:	6a 00                	push   $0x0
  8035d7:	50                   	push   %eax
  8035d8:	ff 75 10             	pushl  0x10(%ebp)
  8035db:	e8 39 f1 ff ff       	call   802719 <set_block_data>
  8035e0:	83 c4 10             	add    $0x10,%esp
	}
}
  8035e3:	90                   	nop
  8035e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035e7:	c9                   	leave  
  8035e8:	c3                   	ret    

008035e9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8035e9:	55                   	push   %ebp
  8035ea:	89 e5                	mov    %esp,%ebp
  8035ec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8035ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8035f7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ff:	73 1b                	jae    80361c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803601:	a1 30 50 80 00       	mov    0x805030,%eax
  803606:	83 ec 04             	sub    $0x4,%esp
  803609:	ff 75 08             	pushl  0x8(%ebp)
  80360c:	6a 00                	push   $0x0
  80360e:	50                   	push   %eax
  80360f:	e8 b2 fb ff ff       	call   8031c6 <merging>
  803614:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803617:	e9 8b 00 00 00       	jmp    8036a7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80361c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803621:	3b 45 08             	cmp    0x8(%ebp),%eax
  803624:	76 18                	jbe    80363e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803626:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	ff 75 08             	pushl  0x8(%ebp)
  803631:	50                   	push   %eax
  803632:	6a 00                	push   $0x0
  803634:	e8 8d fb ff ff       	call   8031c6 <merging>
  803639:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80363c:	eb 69                	jmp    8036a7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80363e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803646:	eb 39                	jmp    803681 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80364e:	73 29                	jae    803679 <free_block+0x90>
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	3b 45 08             	cmp    0x8(%ebp),%eax
  803658:	76 1f                	jbe    803679 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	ff 75 08             	pushl  0x8(%ebp)
  803668:	ff 75 f0             	pushl  -0x10(%ebp)
  80366b:	ff 75 f4             	pushl  -0xc(%ebp)
  80366e:	e8 53 fb ff ff       	call   8031c6 <merging>
  803673:	83 c4 10             	add    $0x10,%esp
			break;
  803676:	90                   	nop
		}
	}
}
  803677:	eb 2e                	jmp    8036a7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803679:	a1 34 50 80 00       	mov    0x805034,%eax
  80367e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803685:	74 07                	je     80368e <free_block+0xa5>
  803687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	eb 05                	jmp    803693 <free_block+0xaa>
  80368e:	b8 00 00 00 00       	mov    $0x0,%eax
  803693:	a3 34 50 80 00       	mov    %eax,0x805034
  803698:	a1 34 50 80 00       	mov    0x805034,%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	75 a7                	jne    803648 <free_block+0x5f>
  8036a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a5:	75 a1                	jne    803648 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036a7:	90                   	nop
  8036a8:	c9                   	leave  
  8036a9:	c3                   	ret    

008036aa <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
  8036ad:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8036b0:	ff 75 08             	pushl  0x8(%ebp)
  8036b3:	e8 10 ed ff ff       	call   8023c8 <get_block_size>
  8036b8:	83 c4 04             	add    $0x4,%esp
  8036bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8036be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8036c5:	eb 17                	jmp    8036de <copy_data+0x34>
  8036c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cd:	01 c2                	add    %eax,%edx
  8036cf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	01 c8                	add    %ecx,%eax
  8036d7:	8a 00                	mov    (%eax),%al
  8036d9:	88 02                	mov    %al,(%edx)
  8036db:	ff 45 fc             	incl   -0x4(%ebp)
  8036de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036e4:	72 e1                	jb     8036c7 <copy_data+0x1d>
}
  8036e6:	90                   	nop
  8036e7:	c9                   	leave  
  8036e8:	c3                   	ret    

008036e9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8036ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f3:	75 23                	jne    803718 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8036f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036f9:	74 13                	je     80370e <realloc_block_FF+0x25>
  8036fb:	83 ec 0c             	sub    $0xc,%esp
  8036fe:	ff 75 0c             	pushl  0xc(%ebp)
  803701:	e8 42 f0 ff ff       	call   802748 <alloc_block_FF>
  803706:	83 c4 10             	add    $0x10,%esp
  803709:	e9 e4 06 00 00       	jmp    803df2 <realloc_block_FF+0x709>
		return NULL;
  80370e:	b8 00 00 00 00       	mov    $0x0,%eax
  803713:	e9 da 06 00 00       	jmp    803df2 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803718:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80371c:	75 18                	jne    803736 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80371e:	83 ec 0c             	sub    $0xc,%esp
  803721:	ff 75 08             	pushl  0x8(%ebp)
  803724:	e8 c0 fe ff ff       	call   8035e9 <free_block>
  803729:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80372c:	b8 00 00 00 00       	mov    $0x0,%eax
  803731:	e9 bc 06 00 00       	jmp    803df2 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803736:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80373a:	77 07                	ja     803743 <realloc_block_FF+0x5a>
  80373c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803743:	8b 45 0c             	mov    0xc(%ebp),%eax
  803746:	83 e0 01             	and    $0x1,%eax
  803749:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80374c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374f:	83 c0 08             	add    $0x8,%eax
  803752:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803755:	83 ec 0c             	sub    $0xc,%esp
  803758:	ff 75 08             	pushl  0x8(%ebp)
  80375b:	e8 68 ec ff ff       	call   8023c8 <get_block_size>
  803760:	83 c4 10             	add    $0x10,%esp
  803763:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	83 e8 08             	sub    $0x8,%eax
  80376c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	83 e8 04             	sub    $0x4,%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	83 e0 fe             	and    $0xfffffffe,%eax
  80377a:	89 c2                	mov    %eax,%edx
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	01 d0                	add    %edx,%eax
  803781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803784:	83 ec 0c             	sub    $0xc,%esp
  803787:	ff 75 e4             	pushl  -0x1c(%ebp)
  80378a:	e8 39 ec ff ff       	call   8023c8 <get_block_size>
  80378f:	83 c4 10             	add    $0x10,%esp
  803792:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803798:	83 e8 08             	sub    $0x8,%eax
  80379b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80379e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037a4:	75 08                	jne    8037ae <realloc_block_FF+0xc5>
	{
		 return va;
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	e9 44 06 00 00       	jmp    803df2 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b4:	0f 83 d5 03 00 00    	jae    803b8f <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8037ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8037c3:	83 ec 0c             	sub    $0xc,%esp
  8037c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c9:	e8 13 ec ff ff       	call   8023e1 <is_free_block>
  8037ce:	83 c4 10             	add    $0x10,%esp
  8037d1:	84 c0                	test   %al,%al
  8037d3:	0f 84 3b 01 00 00    	je     803914 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8037d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037df:	01 d0                	add    %edx,%eax
  8037e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8037e4:	83 ec 04             	sub    $0x4,%esp
  8037e7:	6a 01                	push   $0x1
  8037e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ec:	ff 75 08             	pushl  0x8(%ebp)
  8037ef:	e8 25 ef ff ff       	call   802719 <set_block_data>
  8037f4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	83 e8 04             	sub    $0x4,%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	83 e0 fe             	and    $0xfffffffe,%eax
  803802:	89 c2                	mov    %eax,%edx
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	01 d0                	add    %edx,%eax
  803809:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	6a 00                	push   $0x0
  803811:	ff 75 cc             	pushl  -0x34(%ebp)
  803814:	ff 75 c8             	pushl  -0x38(%ebp)
  803817:	e8 fd ee ff ff       	call   802719 <set_block_data>
  80381c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80381f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803823:	74 06                	je     80382b <realloc_block_FF+0x142>
  803825:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803829:	75 17                	jne    803842 <realloc_block_FF+0x159>
  80382b:	83 ec 04             	sub    $0x4,%esp
  80382e:	68 14 4c 80 00       	push   $0x804c14
  803833:	68 f6 01 00 00       	push   $0x1f6
  803838:	68 a1 4b 80 00       	push   $0x804ba1
  80383d:	e8 d3 cf ff ff       	call   800815 <_panic>
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	8b 10                	mov    (%eax),%edx
  803847:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80384a:	89 10                	mov    %edx,(%eax)
  80384c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	85 c0                	test   %eax,%eax
  803853:	74 0b                	je     803860 <realloc_block_FF+0x177>
  803855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803858:	8b 00                	mov    (%eax),%eax
  80385a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80385d:	89 50 04             	mov    %edx,0x4(%eax)
  803860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803863:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803866:	89 10                	mov    %edx,(%eax)
  803868:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80386b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386e:	89 50 04             	mov    %edx,0x4(%eax)
  803871:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	85 c0                	test   %eax,%eax
  803878:	75 08                	jne    803882 <realloc_block_FF+0x199>
  80387a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80387d:	a3 30 50 80 00       	mov    %eax,0x805030
  803882:	a1 38 50 80 00       	mov    0x805038,%eax
  803887:	40                   	inc    %eax
  803888:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80388d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803891:	75 17                	jne    8038aa <realloc_block_FF+0x1c1>
  803893:	83 ec 04             	sub    $0x4,%esp
  803896:	68 83 4b 80 00       	push   $0x804b83
  80389b:	68 f7 01 00 00       	push   $0x1f7
  8038a0:	68 a1 4b 80 00       	push   $0x804ba1
  8038a5:	e8 6b cf ff ff       	call   800815 <_panic>
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	8b 00                	mov    (%eax),%eax
  8038af:	85 c0                	test   %eax,%eax
  8038b1:	74 10                	je     8038c3 <realloc_block_FF+0x1da>
  8038b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b6:	8b 00                	mov    (%eax),%eax
  8038b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038bb:	8b 52 04             	mov    0x4(%edx),%edx
  8038be:	89 50 04             	mov    %edx,0x4(%eax)
  8038c1:	eb 0b                	jmp    8038ce <realloc_block_FF+0x1e5>
  8038c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c6:	8b 40 04             	mov    0x4(%eax),%eax
  8038c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8038ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d1:	8b 40 04             	mov    0x4(%eax),%eax
  8038d4:	85 c0                	test   %eax,%eax
  8038d6:	74 0f                	je     8038e7 <realloc_block_FF+0x1fe>
  8038d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038db:	8b 40 04             	mov    0x4(%eax),%eax
  8038de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e1:	8b 12                	mov    (%edx),%edx
  8038e3:	89 10                	mov    %edx,(%eax)
  8038e5:	eb 0a                	jmp    8038f1 <realloc_block_FF+0x208>
  8038e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ea:	8b 00                	mov    (%eax),%eax
  8038ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803904:	a1 38 50 80 00       	mov    0x805038,%eax
  803909:	48                   	dec    %eax
  80390a:	a3 38 50 80 00       	mov    %eax,0x805038
  80390f:	e9 73 02 00 00       	jmp    803b87 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803914:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803918:	0f 86 69 02 00 00    	jbe    803b87 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80391e:	83 ec 04             	sub    $0x4,%esp
  803921:	6a 01                	push   $0x1
  803923:	ff 75 f0             	pushl  -0x10(%ebp)
  803926:	ff 75 08             	pushl  0x8(%ebp)
  803929:	e8 eb ed ff ff       	call   802719 <set_block_data>
  80392e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	83 e8 04             	sub    $0x4,%eax
  803937:	8b 00                	mov    (%eax),%eax
  803939:	83 e0 fe             	and    $0xfffffffe,%eax
  80393c:	89 c2                	mov    %eax,%edx
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	01 d0                	add    %edx,%eax
  803943:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803946:	a1 38 50 80 00       	mov    0x805038,%eax
  80394b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80394e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803952:	75 68                	jne    8039bc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803954:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803958:	75 17                	jne    803971 <realloc_block_FF+0x288>
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 bc 4b 80 00       	push   $0x804bbc
  803962:	68 06 02 00 00       	push   $0x206
  803967:	68 a1 4b 80 00       	push   $0x804ba1
  80396c:	e8 a4 ce ff ff       	call   800815 <_panic>
  803971:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803977:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397a:	89 10                	mov    %edx,(%eax)
  80397c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397f:	8b 00                	mov    (%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 0d                	je     803992 <realloc_block_FF+0x2a9>
  803985:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80398a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80398d:	89 50 04             	mov    %edx,0x4(%eax)
  803990:	eb 08                	jmp    80399a <realloc_block_FF+0x2b1>
  803992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803995:	a3 30 50 80 00       	mov    %eax,0x805030
  80399a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b1:	40                   	inc    %eax
  8039b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8039b7:	e9 b0 01 00 00       	jmp    803b6c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8039bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039c4:	76 68                	jbe    803a2e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039ca:	75 17                	jne    8039e3 <realloc_block_FF+0x2fa>
  8039cc:	83 ec 04             	sub    $0x4,%esp
  8039cf:	68 bc 4b 80 00       	push   $0x804bbc
  8039d4:	68 0b 02 00 00       	push   $0x20b
  8039d9:	68 a1 4b 80 00       	push   $0x804ba1
  8039de:	e8 32 ce ff ff       	call   800815 <_panic>
  8039e3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ec:	89 10                	mov    %edx,(%eax)
  8039ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f1:	8b 00                	mov    (%eax),%eax
  8039f3:	85 c0                	test   %eax,%eax
  8039f5:	74 0d                	je     803a04 <realloc_block_FF+0x31b>
  8039f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039ff:	89 50 04             	mov    %edx,0x4(%eax)
  803a02:	eb 08                	jmp    803a0c <realloc_block_FF+0x323>
  803a04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a07:	a3 30 50 80 00       	mov    %eax,0x805030
  803a0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1e:	a1 38 50 80 00       	mov    0x805038,%eax
  803a23:	40                   	inc    %eax
  803a24:	a3 38 50 80 00       	mov    %eax,0x805038
  803a29:	e9 3e 01 00 00       	jmp    803b6c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a2e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a33:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a36:	73 68                	jae    803aa0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a3c:	75 17                	jne    803a55 <realloc_block_FF+0x36c>
  803a3e:	83 ec 04             	sub    $0x4,%esp
  803a41:	68 f0 4b 80 00       	push   $0x804bf0
  803a46:	68 10 02 00 00       	push   $0x210
  803a4b:	68 a1 4b 80 00       	push   $0x804ba1
  803a50:	e8 c0 cd ff ff       	call   800815 <_panic>
  803a55:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a5e:	89 50 04             	mov    %edx,0x4(%eax)
  803a61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a64:	8b 40 04             	mov    0x4(%eax),%eax
  803a67:	85 c0                	test   %eax,%eax
  803a69:	74 0c                	je     803a77 <realloc_block_FF+0x38e>
  803a6b:	a1 30 50 80 00       	mov    0x805030,%eax
  803a70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a73:	89 10                	mov    %edx,(%eax)
  803a75:	eb 08                	jmp    803a7f <realloc_block_FF+0x396>
  803a77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a82:	a3 30 50 80 00       	mov    %eax,0x805030
  803a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a90:	a1 38 50 80 00       	mov    0x805038,%eax
  803a95:	40                   	inc    %eax
  803a96:	a3 38 50 80 00       	mov    %eax,0x805038
  803a9b:	e9 cc 00 00 00       	jmp    803b6c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803aa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803aa7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aaf:	e9 8a 00 00 00       	jmp    803b3e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aba:	73 7a                	jae    803b36 <realloc_block_FF+0x44d>
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	8b 00                	mov    (%eax),%eax
  803ac1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ac4:	73 70                	jae    803b36 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aca:	74 06                	je     803ad2 <realloc_block_FF+0x3e9>
  803acc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ad0:	75 17                	jne    803ae9 <realloc_block_FF+0x400>
  803ad2:	83 ec 04             	sub    $0x4,%esp
  803ad5:	68 14 4c 80 00       	push   $0x804c14
  803ada:	68 1a 02 00 00       	push   $0x21a
  803adf:	68 a1 4b 80 00       	push   $0x804ba1
  803ae4:	e8 2c cd ff ff       	call   800815 <_panic>
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	8b 10                	mov    (%eax),%edx
  803aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af1:	89 10                	mov    %edx,(%eax)
  803af3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af6:	8b 00                	mov    (%eax),%eax
  803af8:	85 c0                	test   %eax,%eax
  803afa:	74 0b                	je     803b07 <realloc_block_FF+0x41e>
  803afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aff:	8b 00                	mov    (%eax),%eax
  803b01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b04:	89 50 04             	mov    %edx,0x4(%eax)
  803b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b0d:	89 10                	mov    %edx,(%eax)
  803b0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b15:	89 50 04             	mov    %edx,0x4(%eax)
  803b18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	85 c0                	test   %eax,%eax
  803b1f:	75 08                	jne    803b29 <realloc_block_FF+0x440>
  803b21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b24:	a3 30 50 80 00       	mov    %eax,0x805030
  803b29:	a1 38 50 80 00       	mov    0x805038,%eax
  803b2e:	40                   	inc    %eax
  803b2f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b34:	eb 36                	jmp    803b6c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b36:	a1 34 50 80 00       	mov    0x805034,%eax
  803b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b42:	74 07                	je     803b4b <realloc_block_FF+0x462>
  803b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	eb 05                	jmp    803b50 <realloc_block_FF+0x467>
  803b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b50:	a3 34 50 80 00       	mov    %eax,0x805034
  803b55:	a1 34 50 80 00       	mov    0x805034,%eax
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	0f 85 52 ff ff ff    	jne    803ab4 <realloc_block_FF+0x3cb>
  803b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b66:	0f 85 48 ff ff ff    	jne    803ab4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	6a 00                	push   $0x0
  803b71:	ff 75 d8             	pushl  -0x28(%ebp)
  803b74:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b77:	e8 9d eb ff ff       	call   802719 <set_block_data>
  803b7c:	83 c4 10             	add    $0x10,%esp
				return va;
  803b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b82:	e9 6b 02 00 00       	jmp    803df2 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	e9 63 02 00 00       	jmp    803df2 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b95:	0f 86 4d 02 00 00    	jbe    803de8 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803b9b:	83 ec 0c             	sub    $0xc,%esp
  803b9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ba1:	e8 3b e8 ff ff       	call   8023e1 <is_free_block>
  803ba6:	83 c4 10             	add    $0x10,%esp
  803ba9:	84 c0                	test   %al,%al
  803bab:	0f 84 37 02 00 00    	je     803de8 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803bb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803bba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803bbd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803bc0:	76 38                	jbe    803bfa <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803bc2:	83 ec 0c             	sub    $0xc,%esp
  803bc5:	ff 75 0c             	pushl  0xc(%ebp)
  803bc8:	e8 7b eb ff ff       	call   802748 <alloc_block_FF>
  803bcd:	83 c4 10             	add    $0x10,%esp
  803bd0:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803bd3:	83 ec 08             	sub    $0x8,%esp
  803bd6:	ff 75 c0             	pushl  -0x40(%ebp)
  803bd9:	ff 75 08             	pushl  0x8(%ebp)
  803bdc:	e8 c9 fa ff ff       	call   8036aa <copy_data>
  803be1:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803be4:	83 ec 0c             	sub    $0xc,%esp
  803be7:	ff 75 08             	pushl  0x8(%ebp)
  803bea:	e8 fa f9 ff ff       	call   8035e9 <free_block>
  803bef:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803bf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bf5:	e9 f8 01 00 00       	jmp    803df2 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bfd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c00:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c03:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c07:	0f 87 a0 00 00 00    	ja     803cad <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c11:	75 17                	jne    803c2a <realloc_block_FF+0x541>
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 83 4b 80 00       	push   $0x804b83
  803c1b:	68 38 02 00 00       	push   $0x238
  803c20:	68 a1 4b 80 00       	push   $0x804ba1
  803c25:	e8 eb cb ff ff       	call   800815 <_panic>
  803c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	85 c0                	test   %eax,%eax
  803c31:	74 10                	je     803c43 <realloc_block_FF+0x55a>
  803c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c36:	8b 00                	mov    (%eax),%eax
  803c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c3b:	8b 52 04             	mov    0x4(%edx),%edx
  803c3e:	89 50 04             	mov    %edx,0x4(%eax)
  803c41:	eb 0b                	jmp    803c4e <realloc_block_FF+0x565>
  803c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c46:	8b 40 04             	mov    0x4(%eax),%eax
  803c49:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c51:	8b 40 04             	mov    0x4(%eax),%eax
  803c54:	85 c0                	test   %eax,%eax
  803c56:	74 0f                	je     803c67 <realloc_block_FF+0x57e>
  803c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5b:	8b 40 04             	mov    0x4(%eax),%eax
  803c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c61:	8b 12                	mov    (%edx),%edx
  803c63:	89 10                	mov    %edx,(%eax)
  803c65:	eb 0a                	jmp    803c71 <realloc_block_FF+0x588>
  803c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6a:	8b 00                	mov    (%eax),%eax
  803c6c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c84:	a1 38 50 80 00       	mov    0x805038,%eax
  803c89:	48                   	dec    %eax
  803c8a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c95:	01 d0                	add    %edx,%eax
  803c97:	83 ec 04             	sub    $0x4,%esp
  803c9a:	6a 01                	push   $0x1
  803c9c:	50                   	push   %eax
  803c9d:	ff 75 08             	pushl  0x8(%ebp)
  803ca0:	e8 74 ea ff ff       	call   802719 <set_block_data>
  803ca5:	83 c4 10             	add    $0x10,%esp
  803ca8:	e9 36 01 00 00       	jmp    803de3 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cb3:	01 d0                	add    %edx,%eax
  803cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803cb8:	83 ec 04             	sub    $0x4,%esp
  803cbb:	6a 01                	push   $0x1
  803cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  803cc0:	ff 75 08             	pushl  0x8(%ebp)
  803cc3:	e8 51 ea ff ff       	call   802719 <set_block_data>
  803cc8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cce:	83 e8 04             	sub    $0x4,%eax
  803cd1:	8b 00                	mov    (%eax),%eax
  803cd3:	83 e0 fe             	and    $0xfffffffe,%eax
  803cd6:	89 c2                	mov    %eax,%edx
  803cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdb:	01 d0                	add    %edx,%eax
  803cdd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ce0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ce4:	74 06                	je     803cec <realloc_block_FF+0x603>
  803ce6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803cea:	75 17                	jne    803d03 <realloc_block_FF+0x61a>
  803cec:	83 ec 04             	sub    $0x4,%esp
  803cef:	68 14 4c 80 00       	push   $0x804c14
  803cf4:	68 44 02 00 00       	push   $0x244
  803cf9:	68 a1 4b 80 00       	push   $0x804ba1
  803cfe:	e8 12 cb ff ff       	call   800815 <_panic>
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 10                	mov    (%eax),%edx
  803d08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d0b:	89 10                	mov    %edx,(%eax)
  803d0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	85 c0                	test   %eax,%eax
  803d14:	74 0b                	je     803d21 <realloc_block_FF+0x638>
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d1e:	89 50 04             	mov    %edx,0x4(%eax)
  803d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d24:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d27:	89 10                	mov    %edx,(%eax)
  803d29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d2f:	89 50 04             	mov    %edx,0x4(%eax)
  803d32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d35:	8b 00                	mov    (%eax),%eax
  803d37:	85 c0                	test   %eax,%eax
  803d39:	75 08                	jne    803d43 <realloc_block_FF+0x65a>
  803d3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d3e:	a3 30 50 80 00       	mov    %eax,0x805030
  803d43:	a1 38 50 80 00       	mov    0x805038,%eax
  803d48:	40                   	inc    %eax
  803d49:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d52:	75 17                	jne    803d6b <realloc_block_FF+0x682>
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	68 83 4b 80 00       	push   $0x804b83
  803d5c:	68 45 02 00 00       	push   $0x245
  803d61:	68 a1 4b 80 00       	push   $0x804ba1
  803d66:	e8 aa ca ff ff       	call   800815 <_panic>
  803d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	74 10                	je     803d84 <realloc_block_FF+0x69b>
  803d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d7c:	8b 52 04             	mov    0x4(%edx),%edx
  803d7f:	89 50 04             	mov    %edx,0x4(%eax)
  803d82:	eb 0b                	jmp    803d8f <realloc_block_FF+0x6a6>
  803d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d87:	8b 40 04             	mov    0x4(%eax),%eax
  803d8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 0f                	je     803da8 <realloc_block_FF+0x6bf>
  803d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9c:	8b 40 04             	mov    0x4(%eax),%eax
  803d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da2:	8b 12                	mov    (%edx),%edx
  803da4:	89 10                	mov    %edx,(%eax)
  803da6:	eb 0a                	jmp    803db2 <realloc_block_FF+0x6c9>
  803da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dab:	8b 00                	mov    (%eax),%eax
  803dad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc5:	a1 38 50 80 00       	mov    0x805038,%eax
  803dca:	48                   	dec    %eax
  803dcb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803dd0:	83 ec 04             	sub    $0x4,%esp
  803dd3:	6a 00                	push   $0x0
  803dd5:	ff 75 bc             	pushl  -0x44(%ebp)
  803dd8:	ff 75 b8             	pushl  -0x48(%ebp)
  803ddb:	e8 39 e9 ff ff       	call   802719 <set_block_data>
  803de0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	eb 0a                	jmp    803df2 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803de8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803df2:	c9                   	leave  
  803df3:	c3                   	ret    

00803df4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803df4:	55                   	push   %ebp
  803df5:	89 e5                	mov    %esp,%ebp
  803df7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803dfa:	83 ec 04             	sub    $0x4,%esp
  803dfd:	68 80 4c 80 00       	push   $0x804c80
  803e02:	68 58 02 00 00       	push   $0x258
  803e07:	68 a1 4b 80 00       	push   $0x804ba1
  803e0c:	e8 04 ca ff ff       	call   800815 <_panic>

00803e11 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e11:	55                   	push   %ebp
  803e12:	89 e5                	mov    %esp,%ebp
  803e14:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e17:	83 ec 04             	sub    $0x4,%esp
  803e1a:	68 a8 4c 80 00       	push   $0x804ca8
  803e1f:	68 61 02 00 00       	push   $0x261
  803e24:	68 a1 4b 80 00       	push   $0x804ba1
  803e29:	e8 e7 c9 ff ff       	call   800815 <_panic>
  803e2e:	66 90                	xchg   %ax,%ax

00803e30 <__udivdi3>:
  803e30:	55                   	push   %ebp
  803e31:	57                   	push   %edi
  803e32:	56                   	push   %esi
  803e33:	53                   	push   %ebx
  803e34:	83 ec 1c             	sub    $0x1c,%esp
  803e37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e47:	89 ca                	mov    %ecx,%edx
  803e49:	89 f8                	mov    %edi,%eax
  803e4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e4f:	85 f6                	test   %esi,%esi
  803e51:	75 2d                	jne    803e80 <__udivdi3+0x50>
  803e53:	39 cf                	cmp    %ecx,%edi
  803e55:	77 65                	ja     803ebc <__udivdi3+0x8c>
  803e57:	89 fd                	mov    %edi,%ebp
  803e59:	85 ff                	test   %edi,%edi
  803e5b:	75 0b                	jne    803e68 <__udivdi3+0x38>
  803e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e62:	31 d2                	xor    %edx,%edx
  803e64:	f7 f7                	div    %edi
  803e66:	89 c5                	mov    %eax,%ebp
  803e68:	31 d2                	xor    %edx,%edx
  803e6a:	89 c8                	mov    %ecx,%eax
  803e6c:	f7 f5                	div    %ebp
  803e6e:	89 c1                	mov    %eax,%ecx
  803e70:	89 d8                	mov    %ebx,%eax
  803e72:	f7 f5                	div    %ebp
  803e74:	89 cf                	mov    %ecx,%edi
  803e76:	89 fa                	mov    %edi,%edx
  803e78:	83 c4 1c             	add    $0x1c,%esp
  803e7b:	5b                   	pop    %ebx
  803e7c:	5e                   	pop    %esi
  803e7d:	5f                   	pop    %edi
  803e7e:	5d                   	pop    %ebp
  803e7f:	c3                   	ret    
  803e80:	39 ce                	cmp    %ecx,%esi
  803e82:	77 28                	ja     803eac <__udivdi3+0x7c>
  803e84:	0f bd fe             	bsr    %esi,%edi
  803e87:	83 f7 1f             	xor    $0x1f,%edi
  803e8a:	75 40                	jne    803ecc <__udivdi3+0x9c>
  803e8c:	39 ce                	cmp    %ecx,%esi
  803e8e:	72 0a                	jb     803e9a <__udivdi3+0x6a>
  803e90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e94:	0f 87 9e 00 00 00    	ja     803f38 <__udivdi3+0x108>
  803e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e9f:	89 fa                	mov    %edi,%edx
  803ea1:	83 c4 1c             	add    $0x1c,%esp
  803ea4:	5b                   	pop    %ebx
  803ea5:	5e                   	pop    %esi
  803ea6:	5f                   	pop    %edi
  803ea7:	5d                   	pop    %ebp
  803ea8:	c3                   	ret    
  803ea9:	8d 76 00             	lea    0x0(%esi),%esi
  803eac:	31 ff                	xor    %edi,%edi
  803eae:	31 c0                	xor    %eax,%eax
  803eb0:	89 fa                	mov    %edi,%edx
  803eb2:	83 c4 1c             	add    $0x1c,%esp
  803eb5:	5b                   	pop    %ebx
  803eb6:	5e                   	pop    %esi
  803eb7:	5f                   	pop    %edi
  803eb8:	5d                   	pop    %ebp
  803eb9:	c3                   	ret    
  803eba:	66 90                	xchg   %ax,%ax
  803ebc:	89 d8                	mov    %ebx,%eax
  803ebe:	f7 f7                	div    %edi
  803ec0:	31 ff                	xor    %edi,%edi
  803ec2:	89 fa                	mov    %edi,%edx
  803ec4:	83 c4 1c             	add    $0x1c,%esp
  803ec7:	5b                   	pop    %ebx
  803ec8:	5e                   	pop    %esi
  803ec9:	5f                   	pop    %edi
  803eca:	5d                   	pop    %ebp
  803ecb:	c3                   	ret    
  803ecc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ed1:	89 eb                	mov    %ebp,%ebx
  803ed3:	29 fb                	sub    %edi,%ebx
  803ed5:	89 f9                	mov    %edi,%ecx
  803ed7:	d3 e6                	shl    %cl,%esi
  803ed9:	89 c5                	mov    %eax,%ebp
  803edb:	88 d9                	mov    %bl,%cl
  803edd:	d3 ed                	shr    %cl,%ebp
  803edf:	89 e9                	mov    %ebp,%ecx
  803ee1:	09 f1                	or     %esi,%ecx
  803ee3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ee7:	89 f9                	mov    %edi,%ecx
  803ee9:	d3 e0                	shl    %cl,%eax
  803eeb:	89 c5                	mov    %eax,%ebp
  803eed:	89 d6                	mov    %edx,%esi
  803eef:	88 d9                	mov    %bl,%cl
  803ef1:	d3 ee                	shr    %cl,%esi
  803ef3:	89 f9                	mov    %edi,%ecx
  803ef5:	d3 e2                	shl    %cl,%edx
  803ef7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803efb:	88 d9                	mov    %bl,%cl
  803efd:	d3 e8                	shr    %cl,%eax
  803eff:	09 c2                	or     %eax,%edx
  803f01:	89 d0                	mov    %edx,%eax
  803f03:	89 f2                	mov    %esi,%edx
  803f05:	f7 74 24 0c          	divl   0xc(%esp)
  803f09:	89 d6                	mov    %edx,%esi
  803f0b:	89 c3                	mov    %eax,%ebx
  803f0d:	f7 e5                	mul    %ebp
  803f0f:	39 d6                	cmp    %edx,%esi
  803f11:	72 19                	jb     803f2c <__udivdi3+0xfc>
  803f13:	74 0b                	je     803f20 <__udivdi3+0xf0>
  803f15:	89 d8                	mov    %ebx,%eax
  803f17:	31 ff                	xor    %edi,%edi
  803f19:	e9 58 ff ff ff       	jmp    803e76 <__udivdi3+0x46>
  803f1e:	66 90                	xchg   %ax,%ax
  803f20:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f24:	89 f9                	mov    %edi,%ecx
  803f26:	d3 e2                	shl    %cl,%edx
  803f28:	39 c2                	cmp    %eax,%edx
  803f2a:	73 e9                	jae    803f15 <__udivdi3+0xe5>
  803f2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f2f:	31 ff                	xor    %edi,%edi
  803f31:	e9 40 ff ff ff       	jmp    803e76 <__udivdi3+0x46>
  803f36:	66 90                	xchg   %ax,%ax
  803f38:	31 c0                	xor    %eax,%eax
  803f3a:	e9 37 ff ff ff       	jmp    803e76 <__udivdi3+0x46>
  803f3f:	90                   	nop

00803f40 <__umoddi3>:
  803f40:	55                   	push   %ebp
  803f41:	57                   	push   %edi
  803f42:	56                   	push   %esi
  803f43:	53                   	push   %ebx
  803f44:	83 ec 1c             	sub    $0x1c,%esp
  803f47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f5f:	89 f3                	mov    %esi,%ebx
  803f61:	89 fa                	mov    %edi,%edx
  803f63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f67:	89 34 24             	mov    %esi,(%esp)
  803f6a:	85 c0                	test   %eax,%eax
  803f6c:	75 1a                	jne    803f88 <__umoddi3+0x48>
  803f6e:	39 f7                	cmp    %esi,%edi
  803f70:	0f 86 a2 00 00 00    	jbe    804018 <__umoddi3+0xd8>
  803f76:	89 c8                	mov    %ecx,%eax
  803f78:	89 f2                	mov    %esi,%edx
  803f7a:	f7 f7                	div    %edi
  803f7c:	89 d0                	mov    %edx,%eax
  803f7e:	31 d2                	xor    %edx,%edx
  803f80:	83 c4 1c             	add    $0x1c,%esp
  803f83:	5b                   	pop    %ebx
  803f84:	5e                   	pop    %esi
  803f85:	5f                   	pop    %edi
  803f86:	5d                   	pop    %ebp
  803f87:	c3                   	ret    
  803f88:	39 f0                	cmp    %esi,%eax
  803f8a:	0f 87 ac 00 00 00    	ja     80403c <__umoddi3+0xfc>
  803f90:	0f bd e8             	bsr    %eax,%ebp
  803f93:	83 f5 1f             	xor    $0x1f,%ebp
  803f96:	0f 84 ac 00 00 00    	je     804048 <__umoddi3+0x108>
  803f9c:	bf 20 00 00 00       	mov    $0x20,%edi
  803fa1:	29 ef                	sub    %ebp,%edi
  803fa3:	89 fe                	mov    %edi,%esi
  803fa5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fa9:	89 e9                	mov    %ebp,%ecx
  803fab:	d3 e0                	shl    %cl,%eax
  803fad:	89 d7                	mov    %edx,%edi
  803faf:	89 f1                	mov    %esi,%ecx
  803fb1:	d3 ef                	shr    %cl,%edi
  803fb3:	09 c7                	or     %eax,%edi
  803fb5:	89 e9                	mov    %ebp,%ecx
  803fb7:	d3 e2                	shl    %cl,%edx
  803fb9:	89 14 24             	mov    %edx,(%esp)
  803fbc:	89 d8                	mov    %ebx,%eax
  803fbe:	d3 e0                	shl    %cl,%eax
  803fc0:	89 c2                	mov    %eax,%edx
  803fc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fc6:	d3 e0                	shl    %cl,%eax
  803fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fd0:	89 f1                	mov    %esi,%ecx
  803fd2:	d3 e8                	shr    %cl,%eax
  803fd4:	09 d0                	or     %edx,%eax
  803fd6:	d3 eb                	shr    %cl,%ebx
  803fd8:	89 da                	mov    %ebx,%edx
  803fda:	f7 f7                	div    %edi
  803fdc:	89 d3                	mov    %edx,%ebx
  803fde:	f7 24 24             	mull   (%esp)
  803fe1:	89 c6                	mov    %eax,%esi
  803fe3:	89 d1                	mov    %edx,%ecx
  803fe5:	39 d3                	cmp    %edx,%ebx
  803fe7:	0f 82 87 00 00 00    	jb     804074 <__umoddi3+0x134>
  803fed:	0f 84 91 00 00 00    	je     804084 <__umoddi3+0x144>
  803ff3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ff7:	29 f2                	sub    %esi,%edx
  803ff9:	19 cb                	sbb    %ecx,%ebx
  803ffb:	89 d8                	mov    %ebx,%eax
  803ffd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804001:	d3 e0                	shl    %cl,%eax
  804003:	89 e9                	mov    %ebp,%ecx
  804005:	d3 ea                	shr    %cl,%edx
  804007:	09 d0                	or     %edx,%eax
  804009:	89 e9                	mov    %ebp,%ecx
  80400b:	d3 eb                	shr    %cl,%ebx
  80400d:	89 da                	mov    %ebx,%edx
  80400f:	83 c4 1c             	add    $0x1c,%esp
  804012:	5b                   	pop    %ebx
  804013:	5e                   	pop    %esi
  804014:	5f                   	pop    %edi
  804015:	5d                   	pop    %ebp
  804016:	c3                   	ret    
  804017:	90                   	nop
  804018:	89 fd                	mov    %edi,%ebp
  80401a:	85 ff                	test   %edi,%edi
  80401c:	75 0b                	jne    804029 <__umoddi3+0xe9>
  80401e:	b8 01 00 00 00       	mov    $0x1,%eax
  804023:	31 d2                	xor    %edx,%edx
  804025:	f7 f7                	div    %edi
  804027:	89 c5                	mov    %eax,%ebp
  804029:	89 f0                	mov    %esi,%eax
  80402b:	31 d2                	xor    %edx,%edx
  80402d:	f7 f5                	div    %ebp
  80402f:	89 c8                	mov    %ecx,%eax
  804031:	f7 f5                	div    %ebp
  804033:	89 d0                	mov    %edx,%eax
  804035:	e9 44 ff ff ff       	jmp    803f7e <__umoddi3+0x3e>
  80403a:	66 90                	xchg   %ax,%ax
  80403c:	89 c8                	mov    %ecx,%eax
  80403e:	89 f2                	mov    %esi,%edx
  804040:	83 c4 1c             	add    $0x1c,%esp
  804043:	5b                   	pop    %ebx
  804044:	5e                   	pop    %esi
  804045:	5f                   	pop    %edi
  804046:	5d                   	pop    %ebp
  804047:	c3                   	ret    
  804048:	3b 04 24             	cmp    (%esp),%eax
  80404b:	72 06                	jb     804053 <__umoddi3+0x113>
  80404d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804051:	77 0f                	ja     804062 <__umoddi3+0x122>
  804053:	89 f2                	mov    %esi,%edx
  804055:	29 f9                	sub    %edi,%ecx
  804057:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80405b:	89 14 24             	mov    %edx,(%esp)
  80405e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804062:	8b 44 24 04          	mov    0x4(%esp),%eax
  804066:	8b 14 24             	mov    (%esp),%edx
  804069:	83 c4 1c             	add    $0x1c,%esp
  80406c:	5b                   	pop    %ebx
  80406d:	5e                   	pop    %esi
  80406e:	5f                   	pop    %edi
  80406f:	5d                   	pop    %ebp
  804070:	c3                   	ret    
  804071:	8d 76 00             	lea    0x0(%esi),%esi
  804074:	2b 04 24             	sub    (%esp),%eax
  804077:	19 fa                	sbb    %edi,%edx
  804079:	89 d1                	mov    %edx,%ecx
  80407b:	89 c6                	mov    %eax,%esi
  80407d:	e9 71 ff ff ff       	jmp    803ff3 <__umoddi3+0xb3>
  804082:	66 90                	xchg   %ax,%ax
  804084:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804088:	72 ea                	jb     804074 <__umoddi3+0x134>
  80408a:	89 d9                	mov    %ebx,%ecx
  80408c:	e9 62 ff ff ff       	jmp    803ff3 <__umoddi3+0xb3>
