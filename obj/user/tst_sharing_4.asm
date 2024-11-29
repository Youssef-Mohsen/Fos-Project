
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
  80005c:	68 c0 41 80 00       	push   $0x8041c0
  800061:	6a 13                	push   $0x13
  800063:	68 dc 41 80 00       	push   $0x8041dc
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
  800085:	68 f4 41 80 00       	push   $0x8041f4
  80008a:	e8 43 0a 00 00       	call   800ad2 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 28 42 80 00       	push   $0x804228
  80009a:	e8 33 0a 00 00       	call   800ad2 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 84 42 80 00       	push   $0x804284
  8000aa:	e8 23 0a 00 00       	call   800ad2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 97 20 00 00       	call   80215c <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 b8 42 80 00       	push   $0x8042b8
  8000d0:	e8 fd 09 00 00       	call   800ad2 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 cf 1e 00 00       	call   801fac <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 ec 42 80 00       	push   $0x8042ec
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
  80010c:	68 f0 42 80 00       	push   $0x8042f0
  800111:	e8 bc 09 00 00       	call   800ad2 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800120:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800123:	e8 84 1e 00 00       	call   801fac <sys_calculate_free_frames>
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
  80014c:	e8 5b 1e 00 00       	call   801fac <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015b:	50                   	push   %eax
  80015c:	68 5c 43 80 00       	push   $0x80435c
  800161:	e8 6c 09 00 00       	call   800ad2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
		cprintf("50\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 f4 43 80 00       	push   $0x8043f4
  800171:	e8 5c 09 00 00       	call   800ad2 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
		sfree(x);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 39 1c 00 00       	call   801dbd <sfree>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("52\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 f8 43 80 00       	push   $0x8043f8
  80018f:	e8 3e 09 00 00       	call   800ad2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		expected = 0 ;
  800197:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80019e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a1:	e8 06 1e 00 00       	call   801fac <sys_calculate_free_frames>
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
  8001bf:	e8 e8 1d 00 00       	call   801fac <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001cf:	68 fc 43 80 00       	push   $0x8043fc
  8001d4:	e8 f9 08 00 00       	call   800ad2 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 47 44 80 00       	push   $0x804447
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
  800200:	68 60 44 80 00       	push   $0x804460
  800205:	e8 c8 08 00 00       	call   800ad2 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  80020d:	e8 9a 1d 00 00       	call   801fac <sys_calculate_free_frames>
  800212:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	6a 01                	push   $0x1
  80021a:	68 00 10 00 00       	push   $0x1000
  80021f:	68 95 44 80 00       	push   $0x804495
  800224:	e8 77 19 00 00       	call   801ba0 <smalloc>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	6a 01                	push   $0x1
  800234:	68 00 10 00 00       	push   $0x1000
  800239:	68 ec 42 80 00       	push   $0x8042ec
  80023e:	e8 5d 19 00 00       	call   801ba0 <smalloc>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if(x == NULL)
  800249:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80024d:	75 17                	jne    800266 <_main+0x22e>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 98 44 80 00       	push   $0x804498
  80025e:	e8 6f 08 00 00       	call   800ad2 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800266:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80026d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800270:	e8 37 1d 00 00       	call   801fac <sys_calculate_free_frames>
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
  800299:	68 f0 44 80 00       	push   $0x8044f0
  80029e:	e8 2f 08 00 00       	call   800ad2 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ac:	e8 0c 1b 00 00       	call   801dbd <sfree>
  8002b1:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8002b4:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8002bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002be:	e8 e9 1c 00 00       	call   801fac <sys_calculate_free_frames>
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
  8002dc:	e8 cb 1c 00 00       	call   801fac <sys_calculate_free_frames>
  8002e1:	29 c3                	sub    %eax,%ebx
  8002e3:	89 d8                	mov    %ebx,%eax
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ec:	68 fc 43 80 00       	push   $0x8043fc
  8002f1:	e8 dc 07 00 00       	call   800ad2 <cprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ff:	e8 b9 1a 00 00       	call   801dbd <sfree>
  800304:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  800307:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80030e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800311:	e8 96 1c 00 00       	call   801fac <sys_calculate_free_frames>
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
  80032f:	e8 78 1c 00 00       	call   801fac <sys_calculate_free_frames>
  800334:	29 c3                	sub    %eax,%ebx
  800336:	89 d8                	mov    %ebx,%eax
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	50                   	push   %eax
  80033c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033f:	68 fc 43 80 00       	push   $0x8043fc
  800344:	e8 89 07 00 00       	call   800ad2 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 45 45 80 00       	push   $0x804545
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
  800370:	68 5c 45 80 00       	push   $0x80455c
  800375:	e8 58 07 00 00       	call   800ad2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80037d:	e8 2a 1c 00 00       	call   801fac <sys_calculate_free_frames>
  800382:	89 45 c0             	mov    %eax,-0x40(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	6a 01                	push   $0x1
  80038a:	68 01 30 00 00       	push   $0x3001
  80038f:	68 91 45 80 00       	push   $0x804591
  800394:	e8 07 18 00 00       	call   801ba0 <smalloc>
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	6a 01                	push   $0x1
  8003a4:	68 00 10 00 00       	push   $0x1000
  8003a9:	68 93 45 80 00       	push   $0x804593
  8003ae:	e8 ed 17 00 00       	call   801ba0 <smalloc>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  8003b9:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003c0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8003c3:	e8 e4 1b 00 00       	call   801fac <sys_calculate_free_frames>
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
  8003ec:	e8 bb 1b 00 00       	call   801fac <sys_calculate_free_frames>
  8003f1:	29 c3                	sub    %eax,%ebx
  8003f3:	89 d8                	mov    %ebx,%eax
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003fb:	50                   	push   %eax
  8003fc:	68 5c 43 80 00       	push   $0x80435c
  800401:	e8 cc 06 00 00       	call   800ad2 <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	ff 75 bc             	pushl  -0x44(%ebp)
  80040f:	e8 a9 19 00 00       	call   801dbd <sfree>
  800414:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800417:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80041e:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800421:	e8 86 1b 00 00       	call   801fac <sys_calculate_free_frames>
  800426:	29 c3                	sub    %eax,%ebx
  800428:	89 d8                	mov    %ebx,%eax
  80042a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80042d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800430:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800433:	74 27                	je     80045c <_main+0x424>
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80043f:	e8 68 1b 00 00       	call   801fac <sys_calculate_free_frames>
  800444:	29 c3                	sub    %eax,%ebx
  800446:	89 d8                	mov    %ebx,%eax
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80044f:	68 fc 43 80 00       	push   $0x8043fc
  800454:	e8 79 06 00 00       	call   800ad2 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	6a 01                	push   $0x1
  800461:	68 ff 1f 00 00       	push   $0x1fff
  800466:	68 95 45 80 00       	push   $0x804595
  80046b:	e8 30 17 00 00       	call   801ba0 <smalloc>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800476:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80047d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800480:	e8 27 1b 00 00       	call   801fac <sys_calculate_free_frames>
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
  80049e:	e8 09 1b 00 00       	call   801fac <sys_calculate_free_frames>
  8004a3:	29 c3                	sub    %eax,%ebx
  8004a5:	89 d8                	mov    %ebx,%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 5c 43 80 00       	push   $0x80435c
  8004b3:	e8 1a 06 00 00       	call   800ad2 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004c1:	e8 f7 18 00 00       	call   801dbd <sfree>
  8004c6:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004c9:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004d0:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004d3:	e8 d4 1a 00 00       	call   801fac <sys_calculate_free_frames>
  8004d8:	29 c3                	sub    %eax,%ebx
  8004da:	89 d8                	mov    %ebx,%eax
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004e5:	74 27                	je     80050e <_main+0x4d6>
  8004e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ee:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004f1:	e8 b6 1a 00 00       	call   801fac <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 d4             	pushl  -0x2c(%ebp)
  800501:	68 fc 43 80 00       	push   $0x8043fc
  800506:	e8 c7 05 00 00       	call   800ad2 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	ff 75 b8             	pushl  -0x48(%ebp)
  800514:	e8 a4 18 00 00       	call   801dbd <sfree>
  800519:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  80051c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800523:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800526:	e8 81 1a 00 00       	call   801fac <sys_calculate_free_frames>
  80052b:	29 c3                	sub    %eax,%ebx
  80052d:	89 d8                	mov    %ebx,%eax
  80052f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800538:	74 27                	je     800561 <_main+0x529>
  80053a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800541:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800544:	e8 63 1a 00 00       	call   801fac <sys_calculate_free_frames>
  800549:	29 c3                	sub    %eax,%ebx
  80054b:	89 d8                	mov    %ebx,%eax
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	50                   	push   %eax
  800551:	ff 75 d4             	pushl  -0x2c(%ebp)
  800554:	68 fc 43 80 00       	push   $0x8043fc
  800559:	e8 74 05 00 00       	call   800ad2 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800561:	e8 46 1a 00 00       	call   801fac <sys_calculate_free_frames>
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
  80057b:	68 91 45 80 00       	push   $0x804591
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
  8005a1:	68 93 45 80 00       	push   $0x804593
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
  8005c3:	68 95 45 80 00       	push   $0x804595
  8005c8:	e8 d3 15 00 00       	call   801ba0 <smalloc>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005d3:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005da:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8005dd:	e8 ca 19 00 00       	call   801fac <sys_calculate_free_frames>
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
  800606:	e8 a1 19 00 00       	call   801fac <sys_calculate_free_frames>
  80060b:	29 c3                	sub    %eax,%ebx
  80060d:	89 d8                	mov    %ebx,%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 d4             	pushl  -0x2c(%ebp)
  800615:	50                   	push   %eax
  800616:	68 5c 43 80 00       	push   $0x80435c
  80061b:	e8 b2 04 00 00       	call   800ad2 <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  800623:	e8 84 19 00 00       	call   801fac <sys_calculate_free_frames>
  800628:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(o);
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	ff 75 b4             	pushl  -0x4c(%ebp)
  800631:	e8 87 17 00 00       	call   801dbd <sfree>
  800636:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	ff 75 bc             	pushl  -0x44(%ebp)
  80063f:	e8 79 17 00 00       	call   801dbd <sfree>
  800644:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	ff 75 b8             	pushl  -0x48(%ebp)
  80064d:	e8 6b 17 00 00       	call   801dbd <sfree>
  800652:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  800655:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  80065c:	e8 4b 19 00 00       	call   801fac <sys_calculate_free_frames>
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
  80067f:	e8 28 19 00 00       	call   801fac <sys_calculate_free_frames>
  800684:	29 c3                	sub    %eax,%ebx
  800686:	89 d8                	mov    %ebx,%eax
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80068f:	68 fc 43 80 00       	push   $0x8043fc
  800694:	e8 39 04 00 00       	call   800ad2 <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	68 97 45 80 00       	push   $0x804597
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
  8006c3:	68 b0 45 80 00       	push   $0x8045b0
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
  8006dc:	e8 94 1a 00 00       	call   802175 <sys_getenvindex>
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
  80074a:	e8 aa 17 00 00       	call   801ef9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	68 04 46 80 00       	push   $0x804604
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
  80077a:	68 2c 46 80 00       	push   $0x80462c
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
  8007ab:	68 54 46 80 00       	push   $0x804654
  8007b0:	e8 1d 03 00 00       	call   800ad2 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	50                   	push   %eax
  8007c7:	68 ac 46 80 00       	push   $0x8046ac
  8007cc:	e8 01 03 00 00       	call   800ad2 <cprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	68 04 46 80 00       	push   $0x804604
  8007dc:	e8 f1 02 00 00       	call   800ad2 <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007e4:	e8 2a 17 00 00       	call   801f13 <sys_unlock_cons>
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
  8007fc:	e8 40 19 00 00       	call   802141 <sys_destroy_env>
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
  80080d:	e8 95 19 00 00       	call   8021a7 <sys_exit_env>
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
  800824:	a1 50 50 80 00       	mov    0x805050,%eax
  800829:	85 c0                	test   %eax,%eax
  80082b:	74 16                	je     800843 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80082d:	a1 50 50 80 00       	mov    0x805050,%eax
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	50                   	push   %eax
  800836:	68 c0 46 80 00       	push   $0x8046c0
  80083b:	e8 92 02 00 00       	call   800ad2 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800843:	a1 00 50 80 00       	mov    0x805000,%eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	50                   	push   %eax
  80084f:	68 c5 46 80 00       	push   $0x8046c5
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
  800873:	68 e1 46 80 00       	push   $0x8046e1
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
  8008a2:	68 e4 46 80 00       	push   $0x8046e4
  8008a7:	6a 26                	push   $0x26
  8008a9:	68 30 47 80 00       	push   $0x804730
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
  800977:	68 3c 47 80 00       	push   $0x80473c
  80097c:	6a 3a                	push   $0x3a
  80097e:	68 30 47 80 00       	push   $0x804730
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
  8009ea:	68 90 47 80 00       	push   $0x804790
  8009ef:	6a 44                	push   $0x44
  8009f1:	68 30 47 80 00       	push   $0x804730
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
  800a29:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800a44:	e8 6e 14 00 00       	call   801eb7 <sys_cputs>
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
  800a9e:	a0 2c 50 80 00       	mov    0x80502c,%al
  800aa3:	0f b6 c0             	movzbl %al,%eax
  800aa6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	50                   	push   %eax
  800ab0:	52                   	push   %edx
  800ab1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab7:	83 c0 08             	add    $0x8,%eax
  800aba:	50                   	push   %eax
  800abb:	e8 f7 13 00 00       	call   801eb7 <sys_cputs>
  800ac0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ac3:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800ad8:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800b05:	e8 ef 13 00 00       	call   801ef9 <sys_lock_cons>
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
  800b25:	e8 e9 13 00 00       	call   801f13 <sys_unlock_cons>
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
  800b6f:	e8 dc 33 00 00       	call   803f50 <__udivdi3>
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
  800bbf:	e8 9c 34 00 00       	call   804060 <__umoddi3>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	05 f4 49 80 00       	add    $0x8049f4,%eax
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
  800d1a:	8b 04 85 18 4a 80 00 	mov    0x804a18(,%eax,4),%eax
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
  800dfb:	8b 34 9d 60 48 80 00 	mov    0x804860(,%ebx,4),%esi
  800e02:	85 f6                	test   %esi,%esi
  800e04:	75 19                	jne    800e1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e06:	53                   	push   %ebx
  800e07:	68 05 4a 80 00       	push   $0x804a05
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
  800e20:	68 0e 4a 80 00       	push   $0x804a0e
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
  800e4d:	be 11 4a 80 00       	mov    $0x804a11,%esi
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
  801045:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  80104c:	eb 2c                	jmp    80107a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80104e:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801858:	68 88 4b 80 00       	push   $0x804b88
  80185d:	68 3f 01 00 00       	push   $0x13f
  801862:	68 aa 4b 80 00       	push   $0x804baa
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
  801878:	e8 e5 0b 00 00       	call   802462 <sys_sbrk>
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
  8018f3:	e8 ee 09 00 00       	call   8022e6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 16                	je     801912 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 2e 0f 00 00       	call   802835 <alloc_block_FF>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190d:	e9 8a 01 00 00       	jmp    801a9c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801912:	e8 00 0a 00 00       	call   802317 <sys_isUHeapPlacementStrategyBESTFIT>
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 84 7d 01 00 00    	je     801a9c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 c7 13 00 00       	call   802cf1 <alloc_block_BF>
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
  801975:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8019c2:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801a19:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801a7b:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	ff 75 f0             	pushl  -0x10(%ebp)
  801a8b:	e8 09 0a 00 00       	call   802499 <sys_allocate_user_mem>
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
  801ad3:	e8 dd 09 00 00       	call   8024b5 <get_block_size>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 10 1c 00 00       	call   8036f9 <free_block>
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
  801b1e:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801b5b:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801b62:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	e8 07 09 00 00       	call   80247d <sys_free_user_mem>
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
  801b89:	68 b8 4b 80 00       	push   $0x804bb8
  801b8e:	68 88 00 00 00       	push   $0x88
  801b93:	68 e2 4b 80 00       	push   $0x804be2
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
  801bb7:	e9 ec 00 00 00       	jmp    801ca8 <smalloc+0x108>
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
  801be8:	75 0a                	jne    801bf4 <smalloc+0x54>
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	e9 b4 00 00 00       	jmp    801ca8 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bf4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bf8:	ff 75 ec             	pushl  -0x14(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	e8 7d 04 00 00       	call   802084 <sys_createSharedObject>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801c0d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801c11:	74 06                	je     801c19 <smalloc+0x79>
  801c13:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801c17:	75 0a                	jne    801c23 <smalloc+0x83>
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1e:	e9 85 00 00 00       	jmp    801ca8 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	ff 75 ec             	pushl  -0x14(%ebp)
  801c29:	68 ee 4b 80 00       	push   $0x804bee
  801c2e:	e8 9f ee ff ff       	call   800ad2 <cprintf>
  801c33:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c39:	a1 20 50 80 00       	mov    0x805020,%eax
  801c3e:	8b 40 78             	mov    0x78(%eax),%eax
  801c41:	29 c2                	sub    %eax,%edx
  801c43:	89 d0                	mov    %edx,%eax
  801c45:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c4a:	c1 e8 0c             	shr    $0xc,%eax
  801c4d:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c53:	42                   	inc    %edx
  801c54:	89 15 24 50 80 00    	mov    %edx,0x805024
  801c5a:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c60:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801c67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c6a:	a1 20 50 80 00       	mov    0x805020,%eax
  801c6f:	8b 40 78             	mov    0x78(%eax),%eax
  801c72:	29 c2                	sub    %eax,%edx
  801c74:	89 d0                	mov    %edx,%eax
  801c76:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c7b:	c1 e8 0c             	shr    $0xc,%eax
  801c7e:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801c85:	a1 20 50 80 00       	mov    0x805020,%eax
  801c8a:	8b 50 10             	mov    0x10(%eax),%edx
  801c8d:	89 c8                	mov    %ecx,%eax
  801c8f:	c1 e0 02             	shl    $0x2,%eax
  801c92:	89 c1                	mov    %eax,%ecx
  801c94:	c1 e1 09             	shl    $0x9,%ecx
  801c97:	01 c8                	add    %ecx,%eax
  801c99:	01 c2                	add    %eax,%edx
  801c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c9e:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801cb0:	83 ec 08             	sub    $0x8,%esp
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	e8 f0 03 00 00       	call   8020ae <sys_getSizeOfSharedObject>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801cc4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801cc8:	75 0a                	jne    801cd4 <sget+0x2a>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	e9 e7 00 00 00       	jmp    801dbb <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cda:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ce1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce7:	39 d0                	cmp    %edx,%eax
  801ce9:	73 02                	jae    801ced <sget+0x43>
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	83 ec 0c             	sub    $0xc,%esp
  801cf0:	50                   	push   %eax
  801cf1:	e8 8c fb ff ff       	call   801882 <malloc>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801cfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d00:	75 0a                	jne    801d0c <sget+0x62>
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	e9 af 00 00 00       	jmp    801dbb <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801d0c:	83 ec 04             	sub    $0x4,%esp
  801d0f:	ff 75 e8             	pushl  -0x18(%ebp)
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	e8 ae 03 00 00       	call   8020cb <sys_getSharedObject>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d26:	a1 20 50 80 00       	mov    0x805020,%eax
  801d2b:	8b 40 78             	mov    0x78(%eax),%eax
  801d2e:	29 c2                	sub    %eax,%edx
  801d30:	89 d0                	mov    %edx,%eax
  801d32:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d37:	c1 e8 0c             	shr    $0xc,%eax
  801d3a:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801d40:	42                   	inc    %edx
  801d41:	89 15 24 50 80 00    	mov    %edx,0x805024
  801d47:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801d4d:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801d54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d57:	a1 20 50 80 00       	mov    0x805020,%eax
  801d5c:	8b 40 78             	mov    0x78(%eax),%eax
  801d5f:	29 c2                	sub    %eax,%edx
  801d61:	89 d0                	mov    %edx,%eax
  801d63:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d68:	c1 e8 0c             	shr    $0xc,%eax
  801d6b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801d72:	a1 20 50 80 00       	mov    0x805020,%eax
  801d77:	8b 50 10             	mov    0x10(%eax),%edx
  801d7a:	89 c8                	mov    %ecx,%eax
  801d7c:	c1 e0 02             	shl    $0x2,%eax
  801d7f:	89 c1                	mov    %eax,%ecx
  801d81:	c1 e1 09             	shl    $0x9,%ecx
  801d84:	01 c8                	add    %ecx,%eax
  801d86:	01 c2                	add    %eax,%edx
  801d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801d92:	a1 20 50 80 00       	mov    0x805020,%eax
  801d97:	8b 40 10             	mov    0x10(%eax),%eax
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	50                   	push   %eax
  801d9e:	68 fd 4b 80 00       	push   $0x804bfd
  801da3:	e8 2a ed ff ff       	call   800ad2 <cprintf>
  801da8:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801dab:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801daf:	75 07                	jne    801db8 <sget+0x10e>
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 03                	jmp    801dbb <sget+0x111>
	return ptr;
  801db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc6:	a1 20 50 80 00       	mov    0x805020,%eax
  801dcb:	8b 40 78             	mov    0x78(%eax),%eax
  801dce:	29 c2                	sub    %eax,%edx
  801dd0:	89 d0                	mov    %edx,%eax
  801dd2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd7:	c1 e8 0c             	shr    $0xc,%eax
  801dda:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801de1:	a1 20 50 80 00       	mov    0x805020,%eax
  801de6:	8b 50 10             	mov    0x10(%eax),%edx
  801de9:	89 c8                	mov    %ecx,%eax
  801deb:	c1 e0 02             	shl    $0x2,%eax
  801dee:	89 c1                	mov    %eax,%ecx
  801df0:	c1 e1 09             	shl    $0x9,%ecx
  801df3:	01 c8                	add    %ecx,%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e01:	83 ec 08             	sub    $0x8,%esp
  801e04:	ff 75 08             	pushl  0x8(%ebp)
  801e07:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0a:	e8 db 02 00 00       	call   8020ea <sys_freeSharedObject>
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e15:	90                   	nop
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 0c 4c 80 00       	push   $0x804c0c
  801e26:	68 e5 00 00 00       	push   $0xe5
  801e2b:	68 e2 4b 80 00       	push   $0x804be2
  801e30:	e8 e0 e9 ff ff       	call   800815 <_panic>

00801e35 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 32 4c 80 00       	push   $0x804c32
  801e43:	68 f1 00 00 00       	push   $0xf1
  801e48:	68 e2 4b 80 00       	push   $0x804be2
  801e4d:	e8 c3 e9 ff ff       	call   800815 <_panic>

00801e52 <shrink>:

}
void shrink(uint32 newSize)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 32 4c 80 00       	push   $0x804c32
  801e60:	68 f6 00 00 00       	push   $0xf6
  801e65:	68 e2 4b 80 00       	push   $0x804be2
  801e6a:	e8 a6 e9 ff ff       	call   800815 <_panic>

00801e6f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	68 32 4c 80 00       	push   $0x804c32
  801e7d:	68 fb 00 00 00       	push   $0xfb
  801e82:	68 e2 4b 80 00       	push   $0x804be2
  801e87:	e8 89 e9 ff ff       	call   800815 <_panic>

00801e8c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	57                   	push   %edi
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ea7:	cd 30                	int    $0x30
  801ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	5b                   	pop    %ebx
  801eb3:	5e                   	pop    %esi
  801eb4:	5f                   	pop    %edi
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    

00801eb7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ec3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	52                   	push   %edx
  801ecf:	ff 75 0c             	pushl  0xc(%ebp)
  801ed2:	50                   	push   %eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	e8 b2 ff ff ff       	call   801e8c <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 02                	push   $0x2
  801eef:	e8 98 ff ff ff       	call   801e8c <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 03                	push   $0x3
  801f08:	e8 7f ff ff ff       	call   801e8c <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	90                   	nop
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 04                	push   $0x4
  801f22:	e8 65 ff ff ff       	call   801e8c <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	90                   	nop
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	52                   	push   %edx
  801f3d:	50                   	push   %eax
  801f3e:	6a 08                	push   $0x8
  801f40:	e8 47 ff ff ff       	call   801e8c <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f4f:	8b 75 18             	mov    0x18(%ebp),%esi
  801f52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	51                   	push   %ecx
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 09                	push   $0x9
  801f65:	e8 22 ff ff ff       	call   801e8c <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    

00801f74 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	52                   	push   %edx
  801f84:	50                   	push   %eax
  801f85:	6a 0a                	push   $0xa
  801f87:	e8 00 ff ff ff       	call   801e8c <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	ff 75 0c             	pushl  0xc(%ebp)
  801f9d:	ff 75 08             	pushl  0x8(%ebp)
  801fa0:	6a 0b                	push   $0xb
  801fa2:	e8 e5 fe ff ff       	call   801e8c <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 0c                	push   $0xc
  801fbb:	e8 cc fe ff ff       	call   801e8c <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 0d                	push   $0xd
  801fd4:	e8 b3 fe ff ff       	call   801e8c <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 0e                	push   $0xe
  801fed:	e8 9a fe ff ff       	call   801e8c <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 0f                	push   $0xf
  802006:	e8 81 fe ff ff       	call   801e8c <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	ff 75 08             	pushl  0x8(%ebp)
  80201e:	6a 10                	push   $0x10
  802020:	e8 67 fe ff ff       	call   801e8c <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 11                	push   $0x11
  802039:	e8 4e fe ff ff       	call   801e8c <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	90                   	nop
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_cputc>:

void
sys_cputc(const char c)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802050:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	50                   	push   %eax
  80205d:	6a 01                	push   $0x1
  80205f:	e8 28 fe ff ff       	call   801e8c <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	90                   	nop
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 14                	push   $0x14
  802079:	e8 0e fe ff ff       	call   801e8c <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	90                   	nop
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	8b 45 10             	mov    0x10(%ebp),%eax
  80208d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802090:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802093:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	6a 00                	push   $0x0
  80209c:	51                   	push   %ecx
  80209d:	52                   	push   %edx
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	50                   	push   %eax
  8020a2:	6a 15                	push   $0x15
  8020a4:	e8 e3 fd ff ff       	call   801e8c <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 16                	push   $0x16
  8020c1:	e8 c6 fd ff ff       	call   801e8c <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	51                   	push   %ecx
  8020dc:	52                   	push   %edx
  8020dd:	50                   	push   %eax
  8020de:	6a 17                	push   $0x17
  8020e0:	e8 a7 fd ff ff       	call   801e8c <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	52                   	push   %edx
  8020fa:	50                   	push   %eax
  8020fb:	6a 18                	push   $0x18
  8020fd:	e8 8a fd ff ff       	call   801e8c <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	6a 00                	push   $0x0
  80210f:	ff 75 14             	pushl  0x14(%ebp)
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	50                   	push   %eax
  802119:	6a 19                	push   $0x19
  80211b:	e8 6c fd ff ff       	call   801e8c <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	50                   	push   %eax
  802134:	6a 1a                	push   $0x1a
  802136:	e8 51 fd ff ff       	call   801e8c <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	90                   	nop
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	50                   	push   %eax
  802150:	6a 1b                	push   $0x1b
  802152:	e8 35 fd ff ff       	call   801e8c <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 05                	push   $0x5
  80216b:	e8 1c fd ff ff       	call   801e8c <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 06                	push   $0x6
  802184:	e8 03 fd ff ff       	call   801e8c <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 07                	push   $0x7
  80219d:	e8 ea fc ff ff       	call   801e8c <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 1c                	push   $0x1c
  8021b6:	e8 d1 fc ff ff       	call   801e8c <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	90                   	nop
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021ca:	8d 50 04             	lea    0x4(%eax),%edx
  8021cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	52                   	push   %edx
  8021d7:	50                   	push   %eax
  8021d8:	6a 1d                	push   $0x1d
  8021da:	e8 ad fc ff ff       	call   801e8c <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return result;
  8021e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021eb:	89 01                	mov    %eax,(%ecx)
  8021ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	c9                   	leave  
  8021f4:	c2 04 00             	ret    $0x4

008021f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	ff 75 10             	pushl  0x10(%ebp)
  802201:	ff 75 0c             	pushl  0xc(%ebp)
  802204:	ff 75 08             	pushl  0x8(%ebp)
  802207:	6a 13                	push   $0x13
  802209:	e8 7e fc ff ff       	call   801e8c <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
	return ;
  802211:	90                   	nop
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_rcr2>:
uint32 sys_rcr2()
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 1e                	push   $0x1e
  802223:	e8 64 fc ff ff       	call   801e8c <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802239:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	50                   	push   %eax
  802246:	6a 1f                	push   $0x1f
  802248:	e8 3f fc ff ff       	call   801e8c <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return ;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <rsttst>:
void rsttst()
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 21                	push   $0x21
  802262:	e8 25 fc ff ff       	call   801e8c <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
	return ;
  80226a:	90                   	nop
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	8b 45 14             	mov    0x14(%ebp),%eax
  802276:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802279:	8b 55 18             	mov    0x18(%ebp),%edx
  80227c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802280:	52                   	push   %edx
  802281:	50                   	push   %eax
  802282:	ff 75 10             	pushl  0x10(%ebp)
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	6a 20                	push   $0x20
  80228d:	e8 fa fb ff ff       	call   801e8c <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
	return ;
  802295:	90                   	nop
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <chktst>:
void chktst(uint32 n)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	6a 22                	push   $0x22
  8022a8:	e8 df fb ff ff       	call   801e8c <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b0:	90                   	nop
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <inctst>:

void inctst()
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 23                	push   $0x23
  8022c2:	e8 c5 fb ff ff       	call   801e8c <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ca:	90                   	nop
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <gettst>:
uint32 gettst()
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 24                	push   $0x24
  8022dc:	e8 ab fb ff ff       	call   801e8c <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 25                	push   $0x25
  8022f8:	e8 8f fb ff ff       	call   801e8c <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
  802300:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802303:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802307:	75 07                	jne    802310 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802309:	b8 01 00 00 00       	mov    $0x1,%eax
  80230e:	eb 05                	jmp    802315 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 25                	push   $0x25
  802329:	e8 5e fb ff ff       	call   801e8c <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
  802331:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802334:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802338:	75 07                	jne    802341 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80233a:	b8 01 00 00 00       	mov    $0x1,%eax
  80233f:	eb 05                	jmp    802346 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 25                	push   $0x25
  80235a:	e8 2d fb ff ff       	call   801e8c <syscall>
  80235f:	83 c4 18             	add    $0x18,%esp
  802362:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802365:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802369:	75 07                	jne    802372 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80236b:	b8 01 00 00 00       	mov    $0x1,%eax
  802370:	eb 05                	jmp    802377 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 25                	push   $0x25
  80238b:	e8 fc fa ff ff       	call   801e8c <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
  802393:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802396:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80239a:	75 07                	jne    8023a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80239c:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a1:	eb 05                	jmp    8023a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	6a 26                	push   $0x26
  8023ba:	e8 cd fa ff ff       	call   801e8c <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c2:	90                   	nop
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	6a 00                	push   $0x0
  8023d7:	53                   	push   %ebx
  8023d8:	51                   	push   %ecx
  8023d9:	52                   	push   %edx
  8023da:	50                   	push   %eax
  8023db:	6a 27                	push   $0x27
  8023dd:	e8 aa fa ff ff       	call   801e8c <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	52                   	push   %edx
  8023fa:	50                   	push   %eax
  8023fb:	6a 28                	push   $0x28
  8023fd:	e8 8a fa ff ff       	call   801e8c <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80240a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80240d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	6a 00                	push   $0x0
  802415:	51                   	push   %ecx
  802416:	ff 75 10             	pushl  0x10(%ebp)
  802419:	52                   	push   %edx
  80241a:	50                   	push   %eax
  80241b:	6a 29                	push   $0x29
  80241d:	e8 6a fa ff ff       	call   801e8c <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	ff 75 10             	pushl  0x10(%ebp)
  802431:	ff 75 0c             	pushl  0xc(%ebp)
  802434:	ff 75 08             	pushl  0x8(%ebp)
  802437:	6a 12                	push   $0x12
  802439:	e8 4e fa ff ff       	call   801e8c <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
	return ;
  802441:	90                   	nop
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	52                   	push   %edx
  802454:	50                   	push   %eax
  802455:	6a 2a                	push   $0x2a
  802457:	e8 30 fa ff ff       	call   801e8c <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
	return;
  80245f:	90                   	nop
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	50                   	push   %eax
  802471:	6a 2b                	push   $0x2b
  802473:	e8 14 fa ff ff       	call   801e8c <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	ff 75 0c             	pushl  0xc(%ebp)
  802489:	ff 75 08             	pushl  0x8(%ebp)
  80248c:	6a 2c                	push   $0x2c
  80248e:	e8 f9 f9 ff ff       	call   801e8c <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
	return;
  802496:	90                   	nop
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	6a 2d                	push   $0x2d
  8024aa:	e8 dd f9 ff ff       	call   801e8c <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
	return;
  8024b2:	90                   	nop
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	83 e8 04             	sub    $0x4,%eax
  8024c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	83 e8 04             	sub    $0x4,%eax
  8024da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	83 e0 01             	and    $0x1,%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	0f 94 c0             	sete   %al
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fc:	83 f8 02             	cmp    $0x2,%eax
  8024ff:	74 2b                	je     80252c <alloc_block+0x40>
  802501:	83 f8 02             	cmp    $0x2,%eax
  802504:	7f 07                	jg     80250d <alloc_block+0x21>
  802506:	83 f8 01             	cmp    $0x1,%eax
  802509:	74 0e                	je     802519 <alloc_block+0x2d>
  80250b:	eb 58                	jmp    802565 <alloc_block+0x79>
  80250d:	83 f8 03             	cmp    $0x3,%eax
  802510:	74 2d                	je     80253f <alloc_block+0x53>
  802512:	83 f8 04             	cmp    $0x4,%eax
  802515:	74 3b                	je     802552 <alloc_block+0x66>
  802517:	eb 4c                	jmp    802565 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802519:	83 ec 0c             	sub    $0xc,%esp
  80251c:	ff 75 08             	pushl  0x8(%ebp)
  80251f:	e8 11 03 00 00       	call   802835 <alloc_block_FF>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80252a:	eb 4a                	jmp    802576 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	ff 75 08             	pushl  0x8(%ebp)
  802532:	e8 fa 19 00 00       	call   803f31 <alloc_block_NF>
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80253d:	eb 37                	jmp    802576 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80253f:	83 ec 0c             	sub    $0xc,%esp
  802542:	ff 75 08             	pushl  0x8(%ebp)
  802545:	e8 a7 07 00 00       	call   802cf1 <alloc_block_BF>
  80254a:	83 c4 10             	add    $0x10,%esp
  80254d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802550:	eb 24                	jmp    802576 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802552:	83 ec 0c             	sub    $0xc,%esp
  802555:	ff 75 08             	pushl  0x8(%ebp)
  802558:	e8 b7 19 00 00       	call   803f14 <alloc_block_WF>
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802563:	eb 11                	jmp    802576 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	68 44 4c 80 00       	push   $0x804c44
  80256d:	e8 60 e5 ff ff       	call   800ad2 <cprintf>
  802572:	83 c4 10             	add    $0x10,%esp
		break;
  802575:	90                   	nop
	}
	return va;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	53                   	push   %ebx
  80257f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	68 64 4c 80 00       	push   $0x804c64
  80258a:	e8 43 e5 ff ff       	call   800ad2 <cprintf>
  80258f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 8f 4c 80 00       	push   $0x804c8f
  80259a:	e8 33 e5 ff ff       	call   800ad2 <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a8:	eb 37                	jmp    8025e1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025aa:	83 ec 0c             	sub    $0xc,%esp
  8025ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b0:	e8 19 ff ff ff       	call   8024ce <is_free_block>
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	0f be d8             	movsbl %al,%ebx
  8025bb:	83 ec 0c             	sub    $0xc,%esp
  8025be:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c1:	e8 ef fe ff ff       	call   8024b5 <get_block_size>
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	53                   	push   %ebx
  8025cd:	50                   	push   %eax
  8025ce:	68 a7 4c 80 00       	push   $0x804ca7
  8025d3:	e8 fa e4 ff ff       	call   800ad2 <cprintf>
  8025d8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025db:	8b 45 10             	mov    0x10(%ebp),%eax
  8025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	74 07                	je     8025ee <print_blocks_list+0x73>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	eb 05                	jmp    8025f3 <print_blocks_list+0x78>
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	89 45 10             	mov    %eax,0x10(%ebp)
  8025f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	75 ad                	jne    8025aa <print_blocks_list+0x2f>
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	75 a7                	jne    8025aa <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802603:	83 ec 0c             	sub    $0xc,%esp
  802606:	68 64 4c 80 00       	push   $0x804c64
  80260b:	e8 c2 e4 ff ff       	call   800ad2 <cprintf>
  802610:	83 c4 10             	add    $0x10,%esp

}
  802613:	90                   	nop
  802614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80261f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802622:	83 e0 01             	and    $0x1,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 03                	je     80262c <initialize_dynamic_allocator+0x13>
  802629:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80262c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802630:	0f 84 c7 01 00 00    	je     8027fd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802636:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80263d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802640:	8b 55 08             	mov    0x8(%ebp),%edx
  802643:	8b 45 0c             	mov    0xc(%ebp),%eax
  802646:	01 d0                	add    %edx,%eax
  802648:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80264d:	0f 87 ad 01 00 00    	ja     802800 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 89 a5 01 00 00    	jns    802803 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80265e:	8b 55 08             	mov    0x8(%ebp),%edx
  802661:	8b 45 0c             	mov    0xc(%ebp),%eax
  802664:	01 d0                	add    %edx,%eax
  802666:	83 e8 04             	sub    $0x4,%eax
  802669:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80266e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802675:	a1 30 50 80 00       	mov    0x805030,%eax
  80267a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267d:	e9 87 00 00 00       	jmp    802709 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802686:	75 14                	jne    80269c <initialize_dynamic_allocator+0x83>
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 bf 4c 80 00       	push   $0x804cbf
  802690:	6a 79                	push   $0x79
  802692:	68 dd 4c 80 00       	push   $0x804cdd
  802697:	e8 79 e1 ff ff       	call   800815 <_panic>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	74 10                	je     8026b5 <initialize_dynamic_allocator+0x9c>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ad:	8b 52 04             	mov    0x4(%edx),%edx
  8026b0:	89 50 04             	mov    %edx,0x4(%eax)
  8026b3:	eb 0b                	jmp    8026c0 <initialize_dynamic_allocator+0xa7>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 04             	mov    0x4(%eax),%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	74 0f                	je     8026d9 <initialize_dynamic_allocator+0xc0>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d3:	8b 12                	mov    (%edx),%edx
  8026d5:	89 10                	mov    %edx,(%eax)
  8026d7:	eb 0a                	jmp    8026e3 <initialize_dynamic_allocator+0xca>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026fb:	48                   	dec    %eax
  8026fc:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802701:	a1 38 50 80 00       	mov    0x805038,%eax
  802706:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	74 07                	je     802716 <initialize_dynamic_allocator+0xfd>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	eb 05                	jmp    80271b <initialize_dynamic_allocator+0x102>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	a3 38 50 80 00       	mov    %eax,0x805038
  802720:	a1 38 50 80 00       	mov    0x805038,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 85 55 ff ff ff    	jne    802682 <initialize_dynamic_allocator+0x69>
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	0f 85 4b ff ff ff    	jne    802682 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802740:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802746:	a1 48 50 80 00       	mov    0x805048,%eax
  80274b:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802750:	a1 44 50 80 00       	mov    0x805044,%eax
  802755:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	83 c0 08             	add    $0x8,%eax
  802761:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	83 c0 04             	add    $0x4,%eax
  80276a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276d:	83 ea 08             	sub    $0x8,%edx
  802770:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802772:	8b 55 0c             	mov    0xc(%ebp),%edx
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
  802778:	01 d0                	add    %edx,%eax
  80277a:	83 e8 08             	sub    $0x8,%eax
  80277d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802780:	83 ea 08             	sub    $0x8,%edx
  802783:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80279c:	75 17                	jne    8027b5 <initialize_dynamic_allocator+0x19c>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 f8 4c 80 00       	push   $0x804cf8
  8027a6:	68 90 00 00 00       	push   $0x90
  8027ab:	68 dd 4c 80 00       	push   $0x804cdd
  8027b0:	e8 60 e0 ff ff       	call   800815 <_panic>
  8027b5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027be:	89 10                	mov    %edx,(%eax)
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 0d                	je     8027d6 <initialize_dynamic_allocator+0x1bd>
  8027c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8027ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d1:	89 50 04             	mov    %edx,0x4(%eax)
  8027d4:	eb 08                	jmp    8027de <initialize_dynamic_allocator+0x1c5>
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027f5:	40                   	inc    %eax
  8027f6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027fb:	eb 07                	jmp    802804 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027fd:	90                   	nop
  8027fe:	eb 04                	jmp    802804 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802800:	90                   	nop
  802801:	eb 01                	jmp    802804 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802803:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802809:	8b 45 10             	mov    0x10(%ebp),%eax
  80280c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	8d 50 fc             	lea    -0x4(%eax),%edx
  802815:	8b 45 0c             	mov    0xc(%ebp),%eax
  802818:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	83 e8 04             	sub    $0x4,%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	83 e0 fe             	and    $0xfffffffe,%eax
  802825:	8d 50 f8             	lea    -0x8(%eax),%edx
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	01 c2                	add    %eax,%edx
  80282d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802830:	89 02                	mov    %eax,(%edx)
}
  802832:	90                   	nop
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    

00802835 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	83 e0 01             	and    $0x1,%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	74 03                	je     802848 <alloc_block_FF+0x13>
  802845:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802848:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80284c:	77 07                	ja     802855 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80284e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802855:	a1 28 50 80 00       	mov    0x805028,%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	75 73                	jne    8028d1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	83 c0 10             	add    $0x10,%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802867:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80286e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802874:	01 d0                	add    %edx,%eax
  802876:	48                   	dec    %eax
  802877:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80287a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287d:	ba 00 00 00 00       	mov    $0x0,%edx
  802882:	f7 75 ec             	divl   -0x14(%ebp)
  802885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802888:	29 d0                	sub    %edx,%eax
  80288a:	c1 e8 0c             	shr    $0xc,%eax
  80288d:	83 ec 0c             	sub    $0xc,%esp
  802890:	50                   	push   %eax
  802891:	e8 d6 ef ff ff       	call   80186c <sbrk>
  802896:	83 c4 10             	add    $0x10,%esp
  802899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	6a 00                	push   $0x0
  8028a1:	e8 c6 ef ff ff       	call   80186c <sbrk>
  8028a6:	83 c4 10             	add    $0x10,%esp
  8028a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028af:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028b2:	83 ec 08             	sub    $0x8,%esp
  8028b5:	50                   	push   %eax
  8028b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028b9:	e8 5b fd ff ff       	call   802619 <initialize_dynamic_allocator>
  8028be:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028c1:	83 ec 0c             	sub    $0xc,%esp
  8028c4:	68 1b 4d 80 00       	push   $0x804d1b
  8028c9:	e8 04 e2 ff ff       	call   800ad2 <cprintf>
  8028ce:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8028d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d5:	75 0a                	jne    8028e1 <alloc_block_FF+0xac>
	        return NULL;
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dc:	e9 0e 04 00 00       	jmp    802cef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8028e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028e8:	a1 30 50 80 00       	mov    0x805030,%eax
  8028ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f0:	e9 f3 02 00 00       	jmp    802be8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028fb:	83 ec 0c             	sub    $0xc,%esp
  8028fe:	ff 75 bc             	pushl  -0x44(%ebp)
  802901:	e8 af fb ff ff       	call   8024b5 <get_block_size>
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	83 c0 08             	add    $0x8,%eax
  802912:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802915:	0f 87 c5 02 00 00    	ja     802be0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	83 c0 18             	add    $0x18,%eax
  802921:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802924:	0f 87 19 02 00 00    	ja     802b43 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80292a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80292d:	2b 45 08             	sub    0x8(%ebp),%eax
  802930:	83 e8 08             	sub    $0x8,%eax
  802933:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8d 50 08             	lea    0x8(%eax),%edx
  80293c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80293f:	01 d0                	add    %edx,%eax
  802941:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	83 c0 08             	add    $0x8,%eax
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	6a 01                	push   $0x1
  80294f:	50                   	push   %eax
  802950:	ff 75 bc             	pushl  -0x44(%ebp)
  802953:	e8 ae fe ff ff       	call   802806 <set_block_data>
  802958:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	75 68                	jne    8029cd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802965:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802969:	75 17                	jne    802982 <alloc_block_FF+0x14d>
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	68 f8 4c 80 00       	push   $0x804cf8
  802973:	68 d7 00 00 00       	push   $0xd7
  802978:	68 dd 4c 80 00       	push   $0x804cdd
  80297d:	e8 93 de ff ff       	call   800815 <_panic>
  802982:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802988:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	85 c0                	test   %eax,%eax
  802994:	74 0d                	je     8029a3 <alloc_block_FF+0x16e>
  802996:	a1 30 50 80 00       	mov    0x805030,%eax
  80299b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80299e:	89 50 04             	mov    %edx,0x4(%eax)
  8029a1:	eb 08                	jmp    8029ab <alloc_block_FF+0x176>
  8029a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a6:	a3 34 50 80 00       	mov    %eax,0x805034
  8029ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029c2:	40                   	inc    %eax
  8029c3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029c8:	e9 dc 00 00 00       	jmp    802aa9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	75 65                	jne    802a3b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029d6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029da:	75 17                	jne    8029f3 <alloc_block_FF+0x1be>
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	68 2c 4d 80 00       	push   $0x804d2c
  8029e4:	68 db 00 00 00       	push   $0xdb
  8029e9:	68 dd 4c 80 00       	push   $0x804cdd
  8029ee:	e8 22 de ff ff       	call   800815 <_panic>
  8029f3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fc:	89 50 04             	mov    %edx,0x4(%eax)
  8029ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0c                	je     802a15 <alloc_block_FF+0x1e0>
  802a09:	a1 34 50 80 00       	mov    0x805034,%eax
  802a0e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a11:	89 10                	mov    %edx,(%eax)
  802a13:	eb 08                	jmp    802a1d <alloc_block_FF+0x1e8>
  802a15:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a18:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a20:	a3 34 50 80 00       	mov    %eax,0x805034
  802a25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a33:	40                   	inc    %eax
  802a34:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a39:	eb 6e                	jmp    802aa9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3f:	74 06                	je     802a47 <alloc_block_FF+0x212>
  802a41:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a45:	75 17                	jne    802a5e <alloc_block_FF+0x229>
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	68 50 4d 80 00       	push   $0x804d50
  802a4f:	68 df 00 00 00       	push   $0xdf
  802a54:	68 dd 4c 80 00       	push   $0x804cdd
  802a59:	e8 b7 dd ff ff       	call   800815 <_panic>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 10                	mov    (%eax),%edx
  802a63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a66:	89 10                	mov    %edx,(%eax)
  802a68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 0b                	je     802a7c <alloc_block_FF+0x247>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%eax)
  802a8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	75 08                	jne    802a9e <alloc_block_FF+0x269>
  802a96:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a99:	a3 34 50 80 00       	mov    %eax,0x805034
  802a9e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aa3:	40                   	inc    %eax
  802aa4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aad:	75 17                	jne    802ac6 <alloc_block_FF+0x291>
  802aaf:	83 ec 04             	sub    $0x4,%esp
  802ab2:	68 bf 4c 80 00       	push   $0x804cbf
  802ab7:	68 e1 00 00 00       	push   $0xe1
  802abc:	68 dd 4c 80 00       	push   $0x804cdd
  802ac1:	e8 4f dd ff ff       	call   800815 <_panic>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 10                	je     802adf <alloc_block_FF+0x2aa>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad7:	8b 52 04             	mov    0x4(%edx),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 0b                	jmp    802aea <alloc_block_FF+0x2b5>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	a3 34 50 80 00       	mov    %eax,0x805034
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 40 04             	mov    0x4(%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 0f                	je     802b03 <alloc_block_FF+0x2ce>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afd:	8b 12                	mov    (%edx),%edx
  802aff:	89 10                	mov    %edx,(%eax)
  802b01:	eb 0a                	jmp    802b0d <alloc_block_FF+0x2d8>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	a3 30 50 80 00       	mov    %eax,0x805030
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b25:	48                   	dec    %eax
  802b26:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	6a 00                	push   $0x0
  802b30:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b33:	ff 75 b0             	pushl  -0x50(%ebp)
  802b36:	e8 cb fc ff ff       	call   802806 <set_block_data>
  802b3b:	83 c4 10             	add    $0x10,%esp
  802b3e:	e9 95 00 00 00       	jmp    802bd8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	6a 01                	push   $0x1
  802b48:	ff 75 b8             	pushl  -0x48(%ebp)
  802b4b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b4e:	e8 b3 fc ff ff       	call   802806 <set_block_data>
  802b53:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5a:	75 17                	jne    802b73 <alloc_block_FF+0x33e>
  802b5c:	83 ec 04             	sub    $0x4,%esp
  802b5f:	68 bf 4c 80 00       	push   $0x804cbf
  802b64:	68 e8 00 00 00       	push   $0xe8
  802b69:	68 dd 4c 80 00       	push   $0x804cdd
  802b6e:	e8 a2 dc ff ff       	call   800815 <_panic>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 10                	je     802b8c <alloc_block_FF+0x357>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b84:	8b 52 04             	mov    0x4(%edx),%edx
  802b87:	89 50 04             	mov    %edx,0x4(%eax)
  802b8a:	eb 0b                	jmp    802b97 <alloc_block_FF+0x362>
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	a3 34 50 80 00       	mov    %eax,0x805034
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	74 0f                	je     802bb0 <alloc_block_FF+0x37b>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 40 04             	mov    0x4(%eax),%eax
  802ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baa:	8b 12                	mov    (%edx),%edx
  802bac:	89 10                	mov    %edx,(%eax)
  802bae:	eb 0a                	jmp    802bba <alloc_block_FF+0x385>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bd2:	48                   	dec    %eax
  802bd3:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802bd8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bdb:	e9 0f 01 00 00       	jmp    802cef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802be0:	a1 38 50 80 00       	mov    0x805038,%eax
  802be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	74 07                	je     802bf5 <alloc_block_FF+0x3c0>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	eb 05                	jmp    802bfa <alloc_block_FF+0x3c5>
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfa:	a3 38 50 80 00       	mov    %eax,0x805038
  802bff:	a1 38 50 80 00       	mov    0x805038,%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	0f 85 e9 fc ff ff    	jne    8028f5 <alloc_block_FF+0xc0>
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	0f 85 df fc ff ff    	jne    8028f5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	83 c0 08             	add    $0x8,%eax
  802c1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c1f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	48                   	dec    %eax
  802c2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c35:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3a:	f7 75 d8             	divl   -0x28(%ebp)
  802c3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c40:	29 d0                	sub    %edx,%eax
  802c42:	c1 e8 0c             	shr    $0xc,%eax
  802c45:	83 ec 0c             	sub    $0xc,%esp
  802c48:	50                   	push   %eax
  802c49:	e8 1e ec ff ff       	call   80186c <sbrk>
  802c4e:	83 c4 10             	add    $0x10,%esp
  802c51:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c54:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c58:	75 0a                	jne    802c64 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	e9 8b 00 00 00       	jmp    802cef <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c64:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c71:	01 d0                	add    %edx,%eax
  802c73:	48                   	dec    %eax
  802c74:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c77:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7f:	f7 75 cc             	divl   -0x34(%ebp)
  802c82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c85:	29 d0                	sub    %edx,%eax
  802c87:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c8d:	01 d0                	add    %edx,%eax
  802c8f:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c94:	a1 44 50 80 00       	mov    0x805044,%eax
  802c99:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c9f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ca6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	48                   	dec    %eax
  802caf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cb2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cba:	f7 75 c4             	divl   -0x3c(%ebp)
  802cbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc0:	29 d0                	sub    %edx,%eax
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	6a 01                	push   $0x1
  802cc7:	50                   	push   %eax
  802cc8:	ff 75 d0             	pushl  -0x30(%ebp)
  802ccb:	e8 36 fb ff ff       	call   802806 <set_block_data>
  802cd0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802cd3:	83 ec 0c             	sub    $0xc,%esp
  802cd6:	ff 75 d0             	pushl  -0x30(%ebp)
  802cd9:	e8 1b 0a 00 00       	call   8036f9 <free_block>
  802cde:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 08             	pushl  0x8(%ebp)
  802ce7:	e8 49 fb ff ff       	call   802835 <alloc_block_FF>
  802cec:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802cef:	c9                   	leave  
  802cf0:	c3                   	ret    

00802cf1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802cf1:	55                   	push   %ebp
  802cf2:	89 e5                	mov    %esp,%ebp
  802cf4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	83 e0 01             	and    $0x1,%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 03                	je     802d04 <alloc_block_BF+0x13>
  802d01:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d04:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d08:	77 07                	ja     802d11 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d0a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d11:	a1 28 50 80 00       	mov    0x805028,%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	75 73                	jne    802d8d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	83 c0 10             	add    $0x10,%eax
  802d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d23:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	48                   	dec    %eax
  802d33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d39:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3e:	f7 75 e0             	divl   -0x20(%ebp)
  802d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d44:	29 d0                	sub    %edx,%eax
  802d46:	c1 e8 0c             	shr    $0xc,%eax
  802d49:	83 ec 0c             	sub    $0xc,%esp
  802d4c:	50                   	push   %eax
  802d4d:	e8 1a eb ff ff       	call   80186c <sbrk>
  802d52:	83 c4 10             	add    $0x10,%esp
  802d55:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d58:	83 ec 0c             	sub    $0xc,%esp
  802d5b:	6a 00                	push   $0x0
  802d5d:	e8 0a eb ff ff       	call   80186c <sbrk>
  802d62:	83 c4 10             	add    $0x10,%esp
  802d65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d6b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d6e:	83 ec 08             	sub    $0x8,%esp
  802d71:	50                   	push   %eax
  802d72:	ff 75 d8             	pushl  -0x28(%ebp)
  802d75:	e8 9f f8 ff ff       	call   802619 <initialize_dynamic_allocator>
  802d7a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d7d:	83 ec 0c             	sub    $0xc,%esp
  802d80:	68 1b 4d 80 00       	push   $0x804d1b
  802d85:	e8 48 dd ff ff       	call   800ad2 <cprintf>
  802d8a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d9b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802da2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802da9:	a1 30 50 80 00       	mov    0x805030,%eax
  802dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db1:	e9 1d 01 00 00       	jmp    802ed3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 a8             	pushl  -0x58(%ebp)
  802dc2:	e8 ee f6 ff ff       	call   8024b5 <get_block_size>
  802dc7:	83 c4 10             	add    $0x10,%esp
  802dca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	83 c0 08             	add    $0x8,%eax
  802dd3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dd6:	0f 87 ef 00 00 00    	ja     802ecb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	83 c0 18             	add    $0x18,%eax
  802de2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802de5:	77 1d                	ja     802e04 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ded:	0f 86 d8 00 00 00    	jbe    802ecb <alloc_block_BF+0x1da>
				{
					best_va = va;
  802df3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802df9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dff:	e9 c7 00 00 00       	jmp    802ecb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	83 c0 08             	add    $0x8,%eax
  802e0a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e0d:	0f 85 9d 00 00 00    	jne    802eb0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	6a 01                	push   $0x1
  802e18:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e1b:	ff 75 a8             	pushl  -0x58(%ebp)
  802e1e:	e8 e3 f9 ff ff       	call   802806 <set_block_data>
  802e23:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2a:	75 17                	jne    802e43 <alloc_block_BF+0x152>
  802e2c:	83 ec 04             	sub    $0x4,%esp
  802e2f:	68 bf 4c 80 00       	push   $0x804cbf
  802e34:	68 2c 01 00 00       	push   $0x12c
  802e39:	68 dd 4c 80 00       	push   $0x804cdd
  802e3e:	e8 d2 d9 ff ff       	call   800815 <_panic>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 10                	je     802e5c <alloc_block_BF+0x16b>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e54:	8b 52 04             	mov    0x4(%edx),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 0b                	jmp    802e67 <alloc_block_BF+0x176>
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	a3 34 50 80 00       	mov    %eax,0x805034
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 0f                	je     802e80 <alloc_block_BF+0x18f>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	8b 12                	mov    (%edx),%edx
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	eb 0a                	jmp    802e8a <alloc_block_BF+0x199>
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ea2:	48                   	dec    %eax
  802ea3:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802ea8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eab:	e9 24 04 00 00       	jmp    8032d4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb6:	76 13                	jbe    802ecb <alloc_block_BF+0x1da>
					{
						internal = 1;
  802eb8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ebf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ec5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ecb:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed7:	74 07                	je     802ee0 <alloc_block_BF+0x1ef>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	eb 05                	jmp    802ee5 <alloc_block_BF+0x1f4>
  802ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee5:	a3 38 50 80 00       	mov    %eax,0x805038
  802eea:	a1 38 50 80 00       	mov    0x805038,%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	0f 85 bf fe ff ff    	jne    802db6 <alloc_block_BF+0xc5>
  802ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efb:	0f 85 b5 fe ff ff    	jne    802db6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f05:	0f 84 26 02 00 00    	je     803131 <alloc_block_BF+0x440>
  802f0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f0f:	0f 85 1c 02 00 00    	jne    803131 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f18:	2b 45 08             	sub    0x8(%ebp),%eax
  802f1b:	83 e8 08             	sub    $0x8,%eax
  802f1e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	8d 50 08             	lea    0x8(%eax),%edx
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	01 d0                	add    %edx,%eax
  802f2c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	83 c0 08             	add    $0x8,%eax
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	6a 01                	push   $0x1
  802f3a:	50                   	push   %eax
  802f3b:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3e:	e8 c3 f8 ff ff       	call   802806 <set_block_data>
  802f43:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	75 68                	jne    802fb8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f50:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f54:	75 17                	jne    802f6d <alloc_block_BF+0x27c>
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	68 f8 4c 80 00       	push   $0x804cf8
  802f5e:	68 45 01 00 00       	push   $0x145
  802f63:	68 dd 4c 80 00       	push   $0x804cdd
  802f68:	e8 a8 d8 ff ff       	call   800815 <_panic>
  802f6d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 0d                	je     802f8e <alloc_block_BF+0x29d>
  802f81:	a1 30 50 80 00       	mov    0x805030,%eax
  802f86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	eb 08                	jmp    802f96 <alloc_block_BF+0x2a5>
  802f8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f91:	a3 34 50 80 00       	mov    %eax,0x805034
  802f96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f99:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fad:	40                   	inc    %eax
  802fae:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fb3:	e9 dc 00 00 00       	jmp    803094 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	75 65                	jne    803026 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fc1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fc5:	75 17                	jne    802fde <alloc_block_BF+0x2ed>
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	68 2c 4d 80 00       	push   $0x804d2c
  802fcf:	68 4a 01 00 00       	push   $0x14a
  802fd4:	68 dd 4c 80 00       	push   $0x804cdd
  802fd9:	e8 37 d8 ff ff       	call   800815 <_panic>
  802fde:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802fe4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe7:	89 50 04             	mov    %edx,0x4(%eax)
  802fea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0c                	je     803000 <alloc_block_BF+0x30f>
  802ff4:	a1 34 50 80 00       	mov    0x805034,%eax
  802ff9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	eb 08                	jmp    803008 <alloc_block_BF+0x317>
  803000:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803003:	a3 30 50 80 00       	mov    %eax,0x805030
  803008:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80300b:	a3 34 50 80 00       	mov    %eax,0x805034
  803010:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803019:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80301e:	40                   	inc    %eax
  80301f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803024:	eb 6e                	jmp    803094 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302a:	74 06                	je     803032 <alloc_block_BF+0x341>
  80302c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803030:	75 17                	jne    803049 <alloc_block_BF+0x358>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 50 4d 80 00       	push   $0x804d50
  80303a:	68 4f 01 00 00       	push   $0x14f
  80303f:	68 dd 4c 80 00       	push   $0x804cdd
  803044:	e8 cc d7 ff ff       	call   800815 <_panic>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 10                	mov    (%eax),%edx
  80304e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
  803053:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0b                	je     803067 <alloc_block_BF+0x376>
  80305c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803072:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	75 08                	jne    803089 <alloc_block_BF+0x398>
  803081:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803084:	a3 34 50 80 00       	mov    %eax,0x805034
  803089:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803094:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803098:	75 17                	jne    8030b1 <alloc_block_BF+0x3c0>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 bf 4c 80 00       	push   $0x804cbf
  8030a2:	68 51 01 00 00       	push   $0x151
  8030a7:	68 dd 4c 80 00       	push   $0x804cdd
  8030ac:	e8 64 d7 ff ff       	call   800815 <_panic>
  8030b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 10                	je     8030ca <alloc_block_BF+0x3d9>
  8030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c2:	8b 52 04             	mov    0x4(%edx),%edx
  8030c5:	89 50 04             	mov    %edx,0x4(%eax)
  8030c8:	eb 0b                	jmp    8030d5 <alloc_block_BF+0x3e4>
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 40 04             	mov    0x4(%eax),%eax
  8030d0:	a3 34 50 80 00       	mov    %eax,0x805034
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 0f                	je     8030ee <alloc_block_BF+0x3fd>
  8030df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e8:	8b 12                	mov    (%edx),%edx
  8030ea:	89 10                	mov    %edx,(%eax)
  8030ec:	eb 0a                	jmp    8030f8 <alloc_block_BF+0x407>
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803110:	48                   	dec    %eax
  803111:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	6a 00                	push   $0x0
  80311b:	ff 75 d0             	pushl  -0x30(%ebp)
  80311e:	ff 75 cc             	pushl  -0x34(%ebp)
  803121:	e8 e0 f6 ff ff       	call   802806 <set_block_data>
  803126:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	e9 a3 01 00 00       	jmp    8032d4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803131:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803135:	0f 85 9d 00 00 00    	jne    8031d8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	6a 01                	push   $0x1
  803140:	ff 75 ec             	pushl  -0x14(%ebp)
  803143:	ff 75 f0             	pushl  -0x10(%ebp)
  803146:	e8 bb f6 ff ff       	call   802806 <set_block_data>
  80314b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80314e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803152:	75 17                	jne    80316b <alloc_block_BF+0x47a>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 bf 4c 80 00       	push   $0x804cbf
  80315c:	68 58 01 00 00       	push   $0x158
  803161:	68 dd 4c 80 00       	push   $0x804cdd
  803166:	e8 aa d6 ff ff       	call   800815 <_panic>
  80316b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 10                	je     803184 <alloc_block_BF+0x493>
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317c:	8b 52 04             	mov    0x4(%edx),%edx
  80317f:	89 50 04             	mov    %edx,0x4(%eax)
  803182:	eb 0b                	jmp    80318f <alloc_block_BF+0x49e>
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	a3 34 50 80 00       	mov    %eax,0x805034
  80318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 0f                	je     8031a8 <alloc_block_BF+0x4b7>
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a2:	8b 12                	mov    (%edx),%edx
  8031a4:	89 10                	mov    %edx,(%eax)
  8031a6:	eb 0a                	jmp    8031b2 <alloc_block_BF+0x4c1>
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031ca:	48                   	dec    %eax
  8031cb:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8031d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d3:	e9 fc 00 00 00       	jmp    8032d4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	83 c0 08             	add    $0x8,%eax
  8031de:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031e1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031ee:	01 d0                	add    %edx,%eax
  8031f0:	48                   	dec    %eax
  8031f1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8031fc:	f7 75 c4             	divl   -0x3c(%ebp)
  8031ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803202:	29 d0                	sub    %edx,%eax
  803204:	c1 e8 0c             	shr    $0xc,%eax
  803207:	83 ec 0c             	sub    $0xc,%esp
  80320a:	50                   	push   %eax
  80320b:	e8 5c e6 ff ff       	call   80186c <sbrk>
  803210:	83 c4 10             	add    $0x10,%esp
  803213:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803216:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80321a:	75 0a                	jne    803226 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
  803221:	e9 ae 00 00 00       	jmp    8032d4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803226:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80322d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803230:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803233:	01 d0                	add    %edx,%eax
  803235:	48                   	dec    %eax
  803236:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803239:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80323c:	ba 00 00 00 00       	mov    $0x0,%edx
  803241:	f7 75 b8             	divl   -0x48(%ebp)
  803244:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803247:	29 d0                	sub    %edx,%eax
  803249:	8d 50 fc             	lea    -0x4(%eax),%edx
  80324c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80324f:	01 d0                	add    %edx,%eax
  803251:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803256:	a1 44 50 80 00       	mov    0x805044,%eax
  80325b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803261:	83 ec 0c             	sub    $0xc,%esp
  803264:	68 84 4d 80 00       	push   $0x804d84
  803269:	e8 64 d8 ff ff       	call   800ad2 <cprintf>
  80326e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803271:	83 ec 08             	sub    $0x8,%esp
  803274:	ff 75 bc             	pushl  -0x44(%ebp)
  803277:	68 89 4d 80 00       	push   $0x804d89
  80327c:	e8 51 d8 ff ff       	call   800ad2 <cprintf>
  803281:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803284:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80328b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80328e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803291:	01 d0                	add    %edx,%eax
  803293:	48                   	dec    %eax
  803294:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803297:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80329a:	ba 00 00 00 00       	mov    $0x0,%edx
  80329f:	f7 75 b0             	divl   -0x50(%ebp)
  8032a2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032a5:	29 d0                	sub    %edx,%eax
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	6a 01                	push   $0x1
  8032ac:	50                   	push   %eax
  8032ad:	ff 75 bc             	pushl  -0x44(%ebp)
  8032b0:	e8 51 f5 ff ff       	call   802806 <set_block_data>
  8032b5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032b8:	83 ec 0c             	sub    $0xc,%esp
  8032bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8032be:	e8 36 04 00 00       	call   8036f9 <free_block>
  8032c3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032c6:	83 ec 0c             	sub    $0xc,%esp
  8032c9:	ff 75 08             	pushl  0x8(%ebp)
  8032cc:	e8 20 fa ff ff       	call   802cf1 <alloc_block_BF>
  8032d1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8032d4:	c9                   	leave  
  8032d5:	c3                   	ret    

008032d6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8032d6:	55                   	push   %ebp
  8032d7:	89 e5                	mov    %esp,%ebp
  8032d9:	53                   	push   %ebx
  8032da:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8032dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ef:	74 1e                	je     80330f <merging+0x39>
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	e8 bc f1 ff ff       	call   8024b5 <get_block_size>
  8032f9:	83 c4 04             	add    $0x4,%esp
  8032fc:	89 c2                	mov    %eax,%edx
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	01 d0                	add    %edx,%eax
  803303:	3b 45 10             	cmp    0x10(%ebp),%eax
  803306:	75 07                	jne    80330f <merging+0x39>
		prev_is_free = 1;
  803308:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80330f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803313:	74 1e                	je     803333 <merging+0x5d>
  803315:	ff 75 10             	pushl  0x10(%ebp)
  803318:	e8 98 f1 ff ff       	call   8024b5 <get_block_size>
  80331d:	83 c4 04             	add    $0x4,%esp
  803320:	89 c2                	mov    %eax,%edx
  803322:	8b 45 10             	mov    0x10(%ebp),%eax
  803325:	01 d0                	add    %edx,%eax
  803327:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80332a:	75 07                	jne    803333 <merging+0x5d>
		next_is_free = 1;
  80332c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803337:	0f 84 cc 00 00 00    	je     803409 <merging+0x133>
  80333d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803341:	0f 84 c2 00 00 00    	je     803409 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803347:	ff 75 08             	pushl  0x8(%ebp)
  80334a:	e8 66 f1 ff ff       	call   8024b5 <get_block_size>
  80334f:	83 c4 04             	add    $0x4,%esp
  803352:	89 c3                	mov    %eax,%ebx
  803354:	ff 75 10             	pushl  0x10(%ebp)
  803357:	e8 59 f1 ff ff       	call   8024b5 <get_block_size>
  80335c:	83 c4 04             	add    $0x4,%esp
  80335f:	01 c3                	add    %eax,%ebx
  803361:	ff 75 0c             	pushl  0xc(%ebp)
  803364:	e8 4c f1 ff ff       	call   8024b5 <get_block_size>
  803369:	83 c4 04             	add    $0x4,%esp
  80336c:	01 d8                	add    %ebx,%eax
  80336e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803371:	6a 00                	push   $0x0
  803373:	ff 75 ec             	pushl  -0x14(%ebp)
  803376:	ff 75 08             	pushl  0x8(%ebp)
  803379:	e8 88 f4 ff ff       	call   802806 <set_block_data>
  80337e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803381:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803385:	75 17                	jne    80339e <merging+0xc8>
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	68 bf 4c 80 00       	push   $0x804cbf
  80338f:	68 7d 01 00 00       	push   $0x17d
  803394:	68 dd 4c 80 00       	push   $0x804cdd
  803399:	e8 77 d4 ff ff       	call   800815 <_panic>
  80339e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	74 10                	je     8033b7 <merging+0xe1>
  8033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033af:	8b 52 04             	mov    0x4(%edx),%edx
  8033b2:	89 50 04             	mov    %edx,0x4(%eax)
  8033b5:	eb 0b                	jmp    8033c2 <merging+0xec>
  8033b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ba:	8b 40 04             	mov    0x4(%eax),%eax
  8033bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 0f                	je     8033db <merging+0x105>
  8033cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cf:	8b 40 04             	mov    0x4(%eax),%eax
  8033d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d5:	8b 12                	mov    (%edx),%edx
  8033d7:	89 10                	mov    %edx,(%eax)
  8033d9:	eb 0a                	jmp    8033e5 <merging+0x10f>
  8033db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033fd:	48                   	dec    %eax
  8033fe:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803403:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803404:	e9 ea 02 00 00       	jmp    8036f3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340d:	74 3b                	je     80344a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80340f:	83 ec 0c             	sub    $0xc,%esp
  803412:	ff 75 08             	pushl  0x8(%ebp)
  803415:	e8 9b f0 ff ff       	call   8024b5 <get_block_size>
  80341a:	83 c4 10             	add    $0x10,%esp
  80341d:	89 c3                	mov    %eax,%ebx
  80341f:	83 ec 0c             	sub    $0xc,%esp
  803422:	ff 75 10             	pushl  0x10(%ebp)
  803425:	e8 8b f0 ff ff       	call   8024b5 <get_block_size>
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	01 d8                	add    %ebx,%eax
  80342f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	6a 00                	push   $0x0
  803437:	ff 75 e8             	pushl  -0x18(%ebp)
  80343a:	ff 75 08             	pushl  0x8(%ebp)
  80343d:	e8 c4 f3 ff ff       	call   802806 <set_block_data>
  803442:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803445:	e9 a9 02 00 00       	jmp    8036f3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80344a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80344e:	0f 84 2d 01 00 00    	je     803581 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803454:	83 ec 0c             	sub    $0xc,%esp
  803457:	ff 75 10             	pushl  0x10(%ebp)
  80345a:	e8 56 f0 ff ff       	call   8024b5 <get_block_size>
  80345f:	83 c4 10             	add    $0x10,%esp
  803462:	89 c3                	mov    %eax,%ebx
  803464:	83 ec 0c             	sub    $0xc,%esp
  803467:	ff 75 0c             	pushl  0xc(%ebp)
  80346a:	e8 46 f0 ff ff       	call   8024b5 <get_block_size>
  80346f:	83 c4 10             	add    $0x10,%esp
  803472:	01 d8                	add    %ebx,%eax
  803474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	6a 00                	push   $0x0
  80347c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80347f:	ff 75 10             	pushl  0x10(%ebp)
  803482:	e8 7f f3 ff ff       	call   802806 <set_block_data>
  803487:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80348a:	8b 45 10             	mov    0x10(%ebp),%eax
  80348d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803494:	74 06                	je     80349c <merging+0x1c6>
  803496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80349a:	75 17                	jne    8034b3 <merging+0x1dd>
  80349c:	83 ec 04             	sub    $0x4,%esp
  80349f:	68 98 4d 80 00       	push   $0x804d98
  8034a4:	68 8d 01 00 00       	push   $0x18d
  8034a9:	68 dd 4c 80 00       	push   $0x804cdd
  8034ae:	e8 62 d3 ff ff       	call   800815 <_panic>
  8034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b6:	8b 50 04             	mov    0x4(%eax),%edx
  8034b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c5:	89 10                	mov    %edx,(%eax)
  8034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 0d                	je     8034de <merging+0x208>
  8034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034da:	89 10                	mov    %edx,(%eax)
  8034dc:	eb 08                	jmp    8034e6 <merging+0x210>
  8034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034f4:	40                   	inc    %eax
  8034f5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034fe:	75 17                	jne    803517 <merging+0x241>
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	68 bf 4c 80 00       	push   $0x804cbf
  803508:	68 8e 01 00 00       	push   $0x18e
  80350d:	68 dd 4c 80 00       	push   $0x804cdd
  803512:	e8 fe d2 ff ff       	call   800815 <_panic>
  803517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 10                	je     803530 <merging+0x25a>
  803520:	8b 45 0c             	mov    0xc(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	8b 55 0c             	mov    0xc(%ebp),%edx
  803528:	8b 52 04             	mov    0x4(%edx),%edx
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	eb 0b                	jmp    80353b <merging+0x265>
  803530:	8b 45 0c             	mov    0xc(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	a3 34 50 80 00       	mov    %eax,0x805034
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0f                	je     803554 <merging+0x27e>
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80354e:	8b 12                	mov    (%edx),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	eb 0a                	jmp    80355e <merging+0x288>
  803554:	8b 45 0c             	mov    0xc(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	a3 30 50 80 00       	mov    %eax,0x805030
  80355e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803576:	48                   	dec    %eax
  803577:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80357c:	e9 72 01 00 00       	jmp    8036f3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803581:	8b 45 10             	mov    0x10(%ebp),%eax
  803584:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358b:	74 79                	je     803606 <merging+0x330>
  80358d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803591:	74 73                	je     803606 <merging+0x330>
  803593:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803597:	74 06                	je     80359f <merging+0x2c9>
  803599:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80359d:	75 17                	jne    8035b6 <merging+0x2e0>
  80359f:	83 ec 04             	sub    $0x4,%esp
  8035a2:	68 50 4d 80 00       	push   $0x804d50
  8035a7:	68 94 01 00 00       	push   $0x194
  8035ac:	68 dd 4c 80 00       	push   $0x804cdd
  8035b1:	e8 5f d2 ff ff       	call   800815 <_panic>
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 10                	mov    (%eax),%edx
  8035bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c3:	8b 00                	mov    (%eax),%eax
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	74 0b                	je     8035d4 <merging+0x2fe>
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035d1:	89 50 04             	mov    %edx,0x4(%eax)
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035da:	89 10                	mov    %edx,(%eax)
  8035dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035df:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e2:	89 50 04             	mov    %edx,0x4(%eax)
  8035e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	75 08                	jne    8035f6 <merging+0x320>
  8035ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8035f6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035fb:	40                   	inc    %eax
  8035fc:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803601:	e9 ce 00 00 00       	jmp    8036d4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803606:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360a:	74 65                	je     803671 <merging+0x39b>
  80360c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803610:	75 17                	jne    803629 <merging+0x353>
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	68 2c 4d 80 00       	push   $0x804d2c
  80361a:	68 95 01 00 00       	push   $0x195
  80361f:	68 dd 4c 80 00       	push   $0x804cdd
  803624:	e8 ec d1 ff ff       	call   800815 <_panic>
  803629:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80362f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	74 0c                	je     80364b <merging+0x375>
  80363f:	a1 34 50 80 00       	mov    0x805034,%eax
  803644:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803647:	89 10                	mov    %edx,(%eax)
  803649:	eb 08                	jmp    803653 <merging+0x37d>
  80364b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364e:	a3 30 50 80 00       	mov    %eax,0x805030
  803653:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803656:	a3 34 50 80 00       	mov    %eax,0x805034
  80365b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80365e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803664:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803669:	40                   	inc    %eax
  80366a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80366f:	eb 63                	jmp    8036d4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803671:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803675:	75 17                	jne    80368e <merging+0x3b8>
  803677:	83 ec 04             	sub    $0x4,%esp
  80367a:	68 f8 4c 80 00       	push   $0x804cf8
  80367f:	68 98 01 00 00       	push   $0x198
  803684:	68 dd 4c 80 00       	push   $0x804cdd
  803689:	e8 87 d1 ff ff       	call   800815 <_panic>
  80368e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803694:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803697:	89 10                	mov    %edx,(%eax)
  803699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0d                	je     8036af <merging+0x3d9>
  8036a2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	eb 08                	jmp    8036b7 <merging+0x3e1>
  8036af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036ce:	40                   	inc    %eax
  8036cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8036d4:	83 ec 0c             	sub    $0xc,%esp
  8036d7:	ff 75 10             	pushl  0x10(%ebp)
  8036da:	e8 d6 ed ff ff       	call   8024b5 <get_block_size>
  8036df:	83 c4 10             	add    $0x10,%esp
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	6a 00                	push   $0x0
  8036e7:	50                   	push   %eax
  8036e8:	ff 75 10             	pushl  0x10(%ebp)
  8036eb:	e8 16 f1 ff ff       	call   802806 <set_block_data>
  8036f0:	83 c4 10             	add    $0x10,%esp
	}
}
  8036f3:	90                   	nop
  8036f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036f7:	c9                   	leave  
  8036f8:	c3                   	ret    

008036f9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036f9:	55                   	push   %ebp
  8036fa:	89 e5                	mov    %esp,%ebp
  8036fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036ff:	a1 30 50 80 00       	mov    0x805030,%eax
  803704:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803707:	a1 34 50 80 00       	mov    0x805034,%eax
  80370c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370f:	73 1b                	jae    80372c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803711:	a1 34 50 80 00       	mov    0x805034,%eax
  803716:	83 ec 04             	sub    $0x4,%esp
  803719:	ff 75 08             	pushl  0x8(%ebp)
  80371c:	6a 00                	push   $0x0
  80371e:	50                   	push   %eax
  80371f:	e8 b2 fb ff ff       	call   8032d6 <merging>
  803724:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803727:	e9 8b 00 00 00       	jmp    8037b7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80372c:	a1 30 50 80 00       	mov    0x805030,%eax
  803731:	3b 45 08             	cmp    0x8(%ebp),%eax
  803734:	76 18                	jbe    80374e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803736:	a1 30 50 80 00       	mov    0x805030,%eax
  80373b:	83 ec 04             	sub    $0x4,%esp
  80373e:	ff 75 08             	pushl  0x8(%ebp)
  803741:	50                   	push   %eax
  803742:	6a 00                	push   $0x0
  803744:	e8 8d fb ff ff       	call   8032d6 <merging>
  803749:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80374c:	eb 69                	jmp    8037b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80374e:	a1 30 50 80 00       	mov    0x805030,%eax
  803753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803756:	eb 39                	jmp    803791 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80375e:	73 29                	jae    803789 <free_block+0x90>
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	3b 45 08             	cmp    0x8(%ebp),%eax
  803768:	76 1f                	jbe    803789 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803772:	83 ec 04             	sub    $0x4,%esp
  803775:	ff 75 08             	pushl  0x8(%ebp)
  803778:	ff 75 f0             	pushl  -0x10(%ebp)
  80377b:	ff 75 f4             	pushl  -0xc(%ebp)
  80377e:	e8 53 fb ff ff       	call   8032d6 <merging>
  803783:	83 c4 10             	add    $0x10,%esp
			break;
  803786:	90                   	nop
		}
	}
}
  803787:	eb 2e                	jmp    8037b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803789:	a1 38 50 80 00       	mov    0x805038,%eax
  80378e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803795:	74 07                	je     80379e <free_block+0xa5>
  803797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	eb 05                	jmp    8037a3 <free_block+0xaa>
  80379e:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ad:	85 c0                	test   %eax,%eax
  8037af:	75 a7                	jne    803758 <free_block+0x5f>
  8037b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b5:	75 a1                	jne    803758 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037b7:	90                   	nop
  8037b8:	c9                   	leave  
  8037b9:	c3                   	ret    

008037ba <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037ba:	55                   	push   %ebp
  8037bb:	89 e5                	mov    %esp,%ebp
  8037bd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037c0:	ff 75 08             	pushl  0x8(%ebp)
  8037c3:	e8 ed ec ff ff       	call   8024b5 <get_block_size>
  8037c8:	83 c4 04             	add    $0x4,%esp
  8037cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8037d5:	eb 17                	jmp    8037ee <copy_data+0x34>
  8037d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037dd:	01 c2                	add    %eax,%edx
  8037df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8037e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e5:	01 c8                	add    %ecx,%eax
  8037e7:	8a 00                	mov    (%eax),%al
  8037e9:	88 02                	mov    %al,(%edx)
  8037eb:	ff 45 fc             	incl   -0x4(%ebp)
  8037ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037f4:	72 e1                	jb     8037d7 <copy_data+0x1d>
}
  8037f6:	90                   	nop
  8037f7:	c9                   	leave  
  8037f8:	c3                   	ret    

008037f9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037f9:	55                   	push   %ebp
  8037fa:	89 e5                	mov    %esp,%ebp
  8037fc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803803:	75 23                	jne    803828 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803805:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803809:	74 13                	je     80381e <realloc_block_FF+0x25>
  80380b:	83 ec 0c             	sub    $0xc,%esp
  80380e:	ff 75 0c             	pushl  0xc(%ebp)
  803811:	e8 1f f0 ff ff       	call   802835 <alloc_block_FF>
  803816:	83 c4 10             	add    $0x10,%esp
  803819:	e9 f4 06 00 00       	jmp    803f12 <realloc_block_FF+0x719>
		return NULL;
  80381e:	b8 00 00 00 00       	mov    $0x0,%eax
  803823:	e9 ea 06 00 00       	jmp    803f12 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803828:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80382c:	75 18                	jne    803846 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80382e:	83 ec 0c             	sub    $0xc,%esp
  803831:	ff 75 08             	pushl  0x8(%ebp)
  803834:	e8 c0 fe ff ff       	call   8036f9 <free_block>
  803839:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80383c:	b8 00 00 00 00       	mov    $0x0,%eax
  803841:	e9 cc 06 00 00       	jmp    803f12 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803846:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80384a:	77 07                	ja     803853 <realloc_block_FF+0x5a>
  80384c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803853:	8b 45 0c             	mov    0xc(%ebp),%eax
  803856:	83 e0 01             	and    $0x1,%eax
  803859:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80385c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385f:	83 c0 08             	add    $0x8,%eax
  803862:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803865:	83 ec 0c             	sub    $0xc,%esp
  803868:	ff 75 08             	pushl  0x8(%ebp)
  80386b:	e8 45 ec ff ff       	call   8024b5 <get_block_size>
  803870:	83 c4 10             	add    $0x10,%esp
  803873:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803879:	83 e8 08             	sub    $0x8,%eax
  80387c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	83 e8 04             	sub    $0x4,%eax
  803885:	8b 00                	mov    (%eax),%eax
  803887:	83 e0 fe             	and    $0xfffffffe,%eax
  80388a:	89 c2                	mov    %eax,%edx
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	01 d0                	add    %edx,%eax
  803891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803894:	83 ec 0c             	sub    $0xc,%esp
  803897:	ff 75 e4             	pushl  -0x1c(%ebp)
  80389a:	e8 16 ec ff ff       	call   8024b5 <get_block_size>
  80389f:	83 c4 10             	add    $0x10,%esp
  8038a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038a8:	83 e8 08             	sub    $0x8,%eax
  8038ab:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038b4:	75 08                	jne    8038be <realloc_block_FF+0xc5>
	{
		 return va;
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	e9 54 06 00 00       	jmp    803f12 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038c4:	0f 83 e5 03 00 00    	jae    803caf <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8038d3:	83 ec 0c             	sub    $0xc,%esp
  8038d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038d9:	e8 f0 eb ff ff       	call   8024ce <is_free_block>
  8038de:	83 c4 10             	add    $0x10,%esp
  8038e1:	84 c0                	test   %al,%al
  8038e3:	0f 84 3b 01 00 00    	je     803a24 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038ef:	01 d0                	add    %edx,%eax
  8038f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038f4:	83 ec 04             	sub    $0x4,%esp
  8038f7:	6a 01                	push   $0x1
  8038f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8038fc:	ff 75 08             	pushl  0x8(%ebp)
  8038ff:	e8 02 ef ff ff       	call   802806 <set_block_data>
  803904:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	83 e8 04             	sub    $0x4,%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	83 e0 fe             	and    $0xfffffffe,%eax
  803912:	89 c2                	mov    %eax,%edx
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	01 d0                	add    %edx,%eax
  803919:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	6a 00                	push   $0x0
  803921:	ff 75 cc             	pushl  -0x34(%ebp)
  803924:	ff 75 c8             	pushl  -0x38(%ebp)
  803927:	e8 da ee ff ff       	call   802806 <set_block_data>
  80392c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80392f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803933:	74 06                	je     80393b <realloc_block_FF+0x142>
  803935:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803939:	75 17                	jne    803952 <realloc_block_FF+0x159>
  80393b:	83 ec 04             	sub    $0x4,%esp
  80393e:	68 50 4d 80 00       	push   $0x804d50
  803943:	68 f6 01 00 00       	push   $0x1f6
  803948:	68 dd 4c 80 00       	push   $0x804cdd
  80394d:	e8 c3 ce ff ff       	call   800815 <_panic>
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	8b 10                	mov    (%eax),%edx
  803957:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80395a:	89 10                	mov    %edx,(%eax)
  80395c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	74 0b                	je     803970 <realloc_block_FF+0x177>
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80396d:	89 50 04             	mov    %edx,0x4(%eax)
  803970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803973:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803976:	89 10                	mov    %edx,(%eax)
  803978:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80397b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80397e:	89 50 04             	mov    %edx,0x4(%eax)
  803981:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	75 08                	jne    803992 <realloc_block_FF+0x199>
  80398a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80398d:	a3 34 50 80 00       	mov    %eax,0x805034
  803992:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803997:	40                   	inc    %eax
  803998:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80399d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039a1:	75 17                	jne    8039ba <realloc_block_FF+0x1c1>
  8039a3:	83 ec 04             	sub    $0x4,%esp
  8039a6:	68 bf 4c 80 00       	push   $0x804cbf
  8039ab:	68 f7 01 00 00       	push   $0x1f7
  8039b0:	68 dd 4c 80 00       	push   $0x804cdd
  8039b5:	e8 5b ce ff ff       	call   800815 <_panic>
  8039ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bd:	8b 00                	mov    (%eax),%eax
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	74 10                	je     8039d3 <realloc_block_FF+0x1da>
  8039c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039cb:	8b 52 04             	mov    0x4(%edx),%edx
  8039ce:	89 50 04             	mov    %edx,0x4(%eax)
  8039d1:	eb 0b                	jmp    8039de <realloc_block_FF+0x1e5>
  8039d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d6:	8b 40 04             	mov    0x4(%eax),%eax
  8039d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e1:	8b 40 04             	mov    0x4(%eax),%eax
  8039e4:	85 c0                	test   %eax,%eax
  8039e6:	74 0f                	je     8039f7 <realloc_block_FF+0x1fe>
  8039e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039eb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f1:	8b 12                	mov    (%edx),%edx
  8039f3:	89 10                	mov    %edx,(%eax)
  8039f5:	eb 0a                	jmp    803a01 <realloc_block_FF+0x208>
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a14:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a19:	48                   	dec    %eax
  803a1a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a1f:	e9 83 02 00 00       	jmp    803ca7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a24:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a28:	0f 86 69 02 00 00    	jbe    803c97 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	6a 01                	push   $0x1
  803a33:	ff 75 f0             	pushl  -0x10(%ebp)
  803a36:	ff 75 08             	pushl  0x8(%ebp)
  803a39:	e8 c8 ed ff ff       	call   802806 <set_block_data>
  803a3e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a41:	8b 45 08             	mov    0x8(%ebp),%eax
  803a44:	83 e8 04             	sub    $0x4,%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	83 e0 fe             	and    $0xfffffffe,%eax
  803a4c:	89 c2                	mov    %eax,%edx
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	01 d0                	add    %edx,%eax
  803a53:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a56:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a5e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a62:	75 68                	jne    803acc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a68:	75 17                	jne    803a81 <realloc_block_FF+0x288>
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 f8 4c 80 00       	push   $0x804cf8
  803a72:	68 06 02 00 00       	push   $0x206
  803a77:	68 dd 4c 80 00       	push   $0x804cdd
  803a7c:	e8 94 cd ff ff       	call   800815 <_panic>
  803a81:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8a:	89 10                	mov    %edx,(%eax)
  803a8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8f:	8b 00                	mov    (%eax),%eax
  803a91:	85 c0                	test   %eax,%eax
  803a93:	74 0d                	je     803aa2 <realloc_block_FF+0x2a9>
  803a95:	a1 30 50 80 00       	mov    0x805030,%eax
  803a9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%eax)
  803aa0:	eb 08                	jmp    803aaa <realloc_block_FF+0x2b1>
  803aa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa5:	a3 34 50 80 00       	mov    %eax,0x805034
  803aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aad:	a3 30 50 80 00       	mov    %eax,0x805030
  803ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ac1:	40                   	inc    %eax
  803ac2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ac7:	e9 b0 01 00 00       	jmp    803c7c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803acc:	a1 30 50 80 00       	mov    0x805030,%eax
  803ad1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ad4:	76 68                	jbe    803b3e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ad6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ada:	75 17                	jne    803af3 <realloc_block_FF+0x2fa>
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 f8 4c 80 00       	push   $0x804cf8
  803ae4:	68 0b 02 00 00       	push   $0x20b
  803ae9:	68 dd 4c 80 00       	push   $0x804cdd
  803aee:	e8 22 cd ff ff       	call   800815 <_panic>
  803af3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803af9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803afc:	89 10                	mov    %edx,(%eax)
  803afe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	85 c0                	test   %eax,%eax
  803b05:	74 0d                	je     803b14 <realloc_block_FF+0x31b>
  803b07:	a1 30 50 80 00       	mov    0x805030,%eax
  803b0c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b0f:	89 50 04             	mov    %edx,0x4(%eax)
  803b12:	eb 08                	jmp    803b1c <realloc_block_FF+0x323>
  803b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b17:	a3 34 50 80 00       	mov    %eax,0x805034
  803b1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1f:	a3 30 50 80 00       	mov    %eax,0x805030
  803b24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b33:	40                   	inc    %eax
  803b34:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b39:	e9 3e 01 00 00       	jmp    803c7c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b3e:	a1 30 50 80 00       	mov    0x805030,%eax
  803b43:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b46:	73 68                	jae    803bb0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b4c:	75 17                	jne    803b65 <realloc_block_FF+0x36c>
  803b4e:	83 ec 04             	sub    $0x4,%esp
  803b51:	68 2c 4d 80 00       	push   $0x804d2c
  803b56:	68 10 02 00 00       	push   $0x210
  803b5b:	68 dd 4c 80 00       	push   $0x804cdd
  803b60:	e8 b0 cc ff ff       	call   800815 <_panic>
  803b65:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6e:	89 50 04             	mov    %edx,0x4(%eax)
  803b71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b74:	8b 40 04             	mov    0x4(%eax),%eax
  803b77:	85 c0                	test   %eax,%eax
  803b79:	74 0c                	je     803b87 <realloc_block_FF+0x38e>
  803b7b:	a1 34 50 80 00       	mov    0x805034,%eax
  803b80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b83:	89 10                	mov    %edx,(%eax)
  803b85:	eb 08                	jmp    803b8f <realloc_block_FF+0x396>
  803b87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803b8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b92:	a3 34 50 80 00       	mov    %eax,0x805034
  803b97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ba0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ba5:	40                   	inc    %eax
  803ba6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bab:	e9 cc 00 00 00       	jmp    803c7c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803bb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803bb7:	a1 30 50 80 00       	mov    0x805030,%eax
  803bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bbf:	e9 8a 00 00 00       	jmp    803c4e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bca:	73 7a                	jae    803c46 <realloc_block_FF+0x44d>
  803bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcf:	8b 00                	mov    (%eax),%eax
  803bd1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bd4:	73 70                	jae    803c46 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bda:	74 06                	je     803be2 <realloc_block_FF+0x3e9>
  803bdc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803be0:	75 17                	jne    803bf9 <realloc_block_FF+0x400>
  803be2:	83 ec 04             	sub    $0x4,%esp
  803be5:	68 50 4d 80 00       	push   $0x804d50
  803bea:	68 1a 02 00 00       	push   $0x21a
  803bef:	68 dd 4c 80 00       	push   $0x804cdd
  803bf4:	e8 1c cc ff ff       	call   800815 <_panic>
  803bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfc:	8b 10                	mov    (%eax),%edx
  803bfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c01:	89 10                	mov    %edx,(%eax)
  803c03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c06:	8b 00                	mov    (%eax),%eax
  803c08:	85 c0                	test   %eax,%eax
  803c0a:	74 0b                	je     803c17 <realloc_block_FF+0x41e>
  803c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0f:	8b 00                	mov    (%eax),%eax
  803c11:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c14:	89 50 04             	mov    %edx,0x4(%eax)
  803c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c1d:	89 10                	mov    %edx,(%eax)
  803c1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c25:	89 50 04             	mov    %edx,0x4(%eax)
  803c28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2b:	8b 00                	mov    (%eax),%eax
  803c2d:	85 c0                	test   %eax,%eax
  803c2f:	75 08                	jne    803c39 <realloc_block_FF+0x440>
  803c31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c34:	a3 34 50 80 00       	mov    %eax,0x805034
  803c39:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c3e:	40                   	inc    %eax
  803c3f:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c44:	eb 36                	jmp    803c7c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c46:	a1 38 50 80 00       	mov    0x805038,%eax
  803c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c52:	74 07                	je     803c5b <realloc_block_FF+0x462>
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	eb 05                	jmp    803c60 <realloc_block_FF+0x467>
  803c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c60:	a3 38 50 80 00       	mov    %eax,0x805038
  803c65:	a1 38 50 80 00       	mov    0x805038,%eax
  803c6a:	85 c0                	test   %eax,%eax
  803c6c:	0f 85 52 ff ff ff    	jne    803bc4 <realloc_block_FF+0x3cb>
  803c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c76:	0f 85 48 ff ff ff    	jne    803bc4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c7c:	83 ec 04             	sub    $0x4,%esp
  803c7f:	6a 00                	push   $0x0
  803c81:	ff 75 d8             	pushl  -0x28(%ebp)
  803c84:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c87:	e8 7a eb ff ff       	call   802806 <set_block_data>
  803c8c:	83 c4 10             	add    $0x10,%esp
				return va;
  803c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c92:	e9 7b 02 00 00       	jmp    803f12 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c97:	83 ec 0c             	sub    $0xc,%esp
  803c9a:	68 cd 4d 80 00       	push   $0x804dcd
  803c9f:	e8 2e ce ff ff       	call   800ad2 <cprintf>
  803ca4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	e9 63 02 00 00       	jmp    803f12 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cb5:	0f 86 4d 02 00 00    	jbe    803f08 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803cbb:	83 ec 0c             	sub    $0xc,%esp
  803cbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cc1:	e8 08 e8 ff ff       	call   8024ce <is_free_block>
  803cc6:	83 c4 10             	add    $0x10,%esp
  803cc9:	84 c0                	test   %al,%al
  803ccb:	0f 84 37 02 00 00    	je     803f08 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803cd7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cda:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cdd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ce0:	76 38                	jbe    803d1a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803ce2:	83 ec 0c             	sub    $0xc,%esp
  803ce5:	ff 75 08             	pushl  0x8(%ebp)
  803ce8:	e8 0c fa ff ff       	call   8036f9 <free_block>
  803ced:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803cf0:	83 ec 0c             	sub    $0xc,%esp
  803cf3:	ff 75 0c             	pushl  0xc(%ebp)
  803cf6:	e8 3a eb ff ff       	call   802835 <alloc_block_FF>
  803cfb:	83 c4 10             	add    $0x10,%esp
  803cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d01:	83 ec 08             	sub    $0x8,%esp
  803d04:	ff 75 c0             	pushl  -0x40(%ebp)
  803d07:	ff 75 08             	pushl  0x8(%ebp)
  803d0a:	e8 ab fa ff ff       	call   8037ba <copy_data>
  803d0f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d12:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d15:	e9 f8 01 00 00       	jmp    803f12 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d1d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d20:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d23:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d27:	0f 87 a0 00 00 00    	ja     803dcd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d31:	75 17                	jne    803d4a <realloc_block_FF+0x551>
  803d33:	83 ec 04             	sub    $0x4,%esp
  803d36:	68 bf 4c 80 00       	push   $0x804cbf
  803d3b:	68 38 02 00 00       	push   $0x238
  803d40:	68 dd 4c 80 00       	push   $0x804cdd
  803d45:	e8 cb ca ff ff       	call   800815 <_panic>
  803d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4d:	8b 00                	mov    (%eax),%eax
  803d4f:	85 c0                	test   %eax,%eax
  803d51:	74 10                	je     803d63 <realloc_block_FF+0x56a>
  803d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d56:	8b 00                	mov    (%eax),%eax
  803d58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d5b:	8b 52 04             	mov    0x4(%edx),%edx
  803d5e:	89 50 04             	mov    %edx,0x4(%eax)
  803d61:	eb 0b                	jmp    803d6e <realloc_block_FF+0x575>
  803d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d66:	8b 40 04             	mov    0x4(%eax),%eax
  803d69:	a3 34 50 80 00       	mov    %eax,0x805034
  803d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d71:	8b 40 04             	mov    0x4(%eax),%eax
  803d74:	85 c0                	test   %eax,%eax
  803d76:	74 0f                	je     803d87 <realloc_block_FF+0x58e>
  803d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7b:	8b 40 04             	mov    0x4(%eax),%eax
  803d7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d81:	8b 12                	mov    (%edx),%edx
  803d83:	89 10                	mov    %edx,(%eax)
  803d85:	eb 0a                	jmp    803d91 <realloc_block_FF+0x598>
  803d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8a:	8b 00                	mov    (%eax),%eax
  803d8c:	a3 30 50 80 00       	mov    %eax,0x805030
  803d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803da9:	48                   	dec    %eax
  803daa:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803daf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803db5:	01 d0                	add    %edx,%eax
  803db7:	83 ec 04             	sub    $0x4,%esp
  803dba:	6a 01                	push   $0x1
  803dbc:	50                   	push   %eax
  803dbd:	ff 75 08             	pushl  0x8(%ebp)
  803dc0:	e8 41 ea ff ff       	call   802806 <set_block_data>
  803dc5:	83 c4 10             	add    $0x10,%esp
  803dc8:	e9 36 01 00 00       	jmp    803f03 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803dcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dd0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dd3:	01 d0                	add    %edx,%eax
  803dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803dd8:	83 ec 04             	sub    $0x4,%esp
  803ddb:	6a 01                	push   $0x1
  803ddd:	ff 75 f0             	pushl  -0x10(%ebp)
  803de0:	ff 75 08             	pushl  0x8(%ebp)
  803de3:	e8 1e ea ff ff       	call   802806 <set_block_data>
  803de8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803deb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dee:	83 e8 04             	sub    $0x4,%eax
  803df1:	8b 00                	mov    (%eax),%eax
  803df3:	83 e0 fe             	and    $0xfffffffe,%eax
  803df6:	89 c2                	mov    %eax,%edx
  803df8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfb:	01 d0                	add    %edx,%eax
  803dfd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e04:	74 06                	je     803e0c <realloc_block_FF+0x613>
  803e06:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e0a:	75 17                	jne    803e23 <realloc_block_FF+0x62a>
  803e0c:	83 ec 04             	sub    $0x4,%esp
  803e0f:	68 50 4d 80 00       	push   $0x804d50
  803e14:	68 44 02 00 00       	push   $0x244
  803e19:	68 dd 4c 80 00       	push   $0x804cdd
  803e1e:	e8 f2 c9 ff ff       	call   800815 <_panic>
  803e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e26:	8b 10                	mov    (%eax),%edx
  803e28:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e2b:	89 10                	mov    %edx,(%eax)
  803e2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e30:	8b 00                	mov    (%eax),%eax
  803e32:	85 c0                	test   %eax,%eax
  803e34:	74 0b                	je     803e41 <realloc_block_FF+0x648>
  803e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e39:	8b 00                	mov    (%eax),%eax
  803e3b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e3e:	89 50 04             	mov    %edx,0x4(%eax)
  803e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e44:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e47:	89 10                	mov    %edx,(%eax)
  803e49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e4f:	89 50 04             	mov    %edx,0x4(%eax)
  803e52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e55:	8b 00                	mov    (%eax),%eax
  803e57:	85 c0                	test   %eax,%eax
  803e59:	75 08                	jne    803e63 <realloc_block_FF+0x66a>
  803e5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e5e:	a3 34 50 80 00       	mov    %eax,0x805034
  803e63:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e68:	40                   	inc    %eax
  803e69:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e72:	75 17                	jne    803e8b <realloc_block_FF+0x692>
  803e74:	83 ec 04             	sub    $0x4,%esp
  803e77:	68 bf 4c 80 00       	push   $0x804cbf
  803e7c:	68 45 02 00 00       	push   $0x245
  803e81:	68 dd 4c 80 00       	push   $0x804cdd
  803e86:	e8 8a c9 ff ff       	call   800815 <_panic>
  803e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8e:	8b 00                	mov    (%eax),%eax
  803e90:	85 c0                	test   %eax,%eax
  803e92:	74 10                	je     803ea4 <realloc_block_FF+0x6ab>
  803e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e97:	8b 00                	mov    (%eax),%eax
  803e99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e9c:	8b 52 04             	mov    0x4(%edx),%edx
  803e9f:	89 50 04             	mov    %edx,0x4(%eax)
  803ea2:	eb 0b                	jmp    803eaf <realloc_block_FF+0x6b6>
  803ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea7:	8b 40 04             	mov    0x4(%eax),%eax
  803eaa:	a3 34 50 80 00       	mov    %eax,0x805034
  803eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb2:	8b 40 04             	mov    0x4(%eax),%eax
  803eb5:	85 c0                	test   %eax,%eax
  803eb7:	74 0f                	je     803ec8 <realloc_block_FF+0x6cf>
  803eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebc:	8b 40 04             	mov    0x4(%eax),%eax
  803ebf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ec2:	8b 12                	mov    (%edx),%edx
  803ec4:	89 10                	mov    %edx,(%eax)
  803ec6:	eb 0a                	jmp    803ed2 <realloc_block_FF+0x6d9>
  803ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecb:	8b 00                	mov    (%eax),%eax
  803ecd:	a3 30 50 80 00       	mov    %eax,0x805030
  803ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ede:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ee5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eea:	48                   	dec    %eax
  803eeb:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803ef0:	83 ec 04             	sub    $0x4,%esp
  803ef3:	6a 00                	push   $0x0
  803ef5:	ff 75 bc             	pushl  -0x44(%ebp)
  803ef8:	ff 75 b8             	pushl  -0x48(%ebp)
  803efb:	e8 06 e9 ff ff       	call   802806 <set_block_data>
  803f00:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f03:	8b 45 08             	mov    0x8(%ebp),%eax
  803f06:	eb 0a                	jmp    803f12 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f08:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f12:	c9                   	leave  
  803f13:	c3                   	ret    

00803f14 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f14:	55                   	push   %ebp
  803f15:	89 e5                	mov    %esp,%ebp
  803f17:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f1a:	83 ec 04             	sub    $0x4,%esp
  803f1d:	68 d4 4d 80 00       	push   $0x804dd4
  803f22:	68 58 02 00 00       	push   $0x258
  803f27:	68 dd 4c 80 00       	push   $0x804cdd
  803f2c:	e8 e4 c8 ff ff       	call   800815 <_panic>

00803f31 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f31:	55                   	push   %ebp
  803f32:	89 e5                	mov    %esp,%ebp
  803f34:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f37:	83 ec 04             	sub    $0x4,%esp
  803f3a:	68 fc 4d 80 00       	push   $0x804dfc
  803f3f:	68 61 02 00 00       	push   $0x261
  803f44:	68 dd 4c 80 00       	push   $0x804cdd
  803f49:	e8 c7 c8 ff ff       	call   800815 <_panic>
  803f4e:	66 90                	xchg   %ax,%ax

00803f50 <__udivdi3>:
  803f50:	55                   	push   %ebp
  803f51:	57                   	push   %edi
  803f52:	56                   	push   %esi
  803f53:	53                   	push   %ebx
  803f54:	83 ec 1c             	sub    $0x1c,%esp
  803f57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f67:	89 ca                	mov    %ecx,%edx
  803f69:	89 f8                	mov    %edi,%eax
  803f6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f6f:	85 f6                	test   %esi,%esi
  803f71:	75 2d                	jne    803fa0 <__udivdi3+0x50>
  803f73:	39 cf                	cmp    %ecx,%edi
  803f75:	77 65                	ja     803fdc <__udivdi3+0x8c>
  803f77:	89 fd                	mov    %edi,%ebp
  803f79:	85 ff                	test   %edi,%edi
  803f7b:	75 0b                	jne    803f88 <__udivdi3+0x38>
  803f7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803f82:	31 d2                	xor    %edx,%edx
  803f84:	f7 f7                	div    %edi
  803f86:	89 c5                	mov    %eax,%ebp
  803f88:	31 d2                	xor    %edx,%edx
  803f8a:	89 c8                	mov    %ecx,%eax
  803f8c:	f7 f5                	div    %ebp
  803f8e:	89 c1                	mov    %eax,%ecx
  803f90:	89 d8                	mov    %ebx,%eax
  803f92:	f7 f5                	div    %ebp
  803f94:	89 cf                	mov    %ecx,%edi
  803f96:	89 fa                	mov    %edi,%edx
  803f98:	83 c4 1c             	add    $0x1c,%esp
  803f9b:	5b                   	pop    %ebx
  803f9c:	5e                   	pop    %esi
  803f9d:	5f                   	pop    %edi
  803f9e:	5d                   	pop    %ebp
  803f9f:	c3                   	ret    
  803fa0:	39 ce                	cmp    %ecx,%esi
  803fa2:	77 28                	ja     803fcc <__udivdi3+0x7c>
  803fa4:	0f bd fe             	bsr    %esi,%edi
  803fa7:	83 f7 1f             	xor    $0x1f,%edi
  803faa:	75 40                	jne    803fec <__udivdi3+0x9c>
  803fac:	39 ce                	cmp    %ecx,%esi
  803fae:	72 0a                	jb     803fba <__udivdi3+0x6a>
  803fb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fb4:	0f 87 9e 00 00 00    	ja     804058 <__udivdi3+0x108>
  803fba:	b8 01 00 00 00       	mov    $0x1,%eax
  803fbf:	89 fa                	mov    %edi,%edx
  803fc1:	83 c4 1c             	add    $0x1c,%esp
  803fc4:	5b                   	pop    %ebx
  803fc5:	5e                   	pop    %esi
  803fc6:	5f                   	pop    %edi
  803fc7:	5d                   	pop    %ebp
  803fc8:	c3                   	ret    
  803fc9:	8d 76 00             	lea    0x0(%esi),%esi
  803fcc:	31 ff                	xor    %edi,%edi
  803fce:	31 c0                	xor    %eax,%eax
  803fd0:	89 fa                	mov    %edi,%edx
  803fd2:	83 c4 1c             	add    $0x1c,%esp
  803fd5:	5b                   	pop    %ebx
  803fd6:	5e                   	pop    %esi
  803fd7:	5f                   	pop    %edi
  803fd8:	5d                   	pop    %ebp
  803fd9:	c3                   	ret    
  803fda:	66 90                	xchg   %ax,%ax
  803fdc:	89 d8                	mov    %ebx,%eax
  803fde:	f7 f7                	div    %edi
  803fe0:	31 ff                	xor    %edi,%edi
  803fe2:	89 fa                	mov    %edi,%edx
  803fe4:	83 c4 1c             	add    $0x1c,%esp
  803fe7:	5b                   	pop    %ebx
  803fe8:	5e                   	pop    %esi
  803fe9:	5f                   	pop    %edi
  803fea:	5d                   	pop    %ebp
  803feb:	c3                   	ret    
  803fec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ff1:	89 eb                	mov    %ebp,%ebx
  803ff3:	29 fb                	sub    %edi,%ebx
  803ff5:	89 f9                	mov    %edi,%ecx
  803ff7:	d3 e6                	shl    %cl,%esi
  803ff9:	89 c5                	mov    %eax,%ebp
  803ffb:	88 d9                	mov    %bl,%cl
  803ffd:	d3 ed                	shr    %cl,%ebp
  803fff:	89 e9                	mov    %ebp,%ecx
  804001:	09 f1                	or     %esi,%ecx
  804003:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804007:	89 f9                	mov    %edi,%ecx
  804009:	d3 e0                	shl    %cl,%eax
  80400b:	89 c5                	mov    %eax,%ebp
  80400d:	89 d6                	mov    %edx,%esi
  80400f:	88 d9                	mov    %bl,%cl
  804011:	d3 ee                	shr    %cl,%esi
  804013:	89 f9                	mov    %edi,%ecx
  804015:	d3 e2                	shl    %cl,%edx
  804017:	8b 44 24 08          	mov    0x8(%esp),%eax
  80401b:	88 d9                	mov    %bl,%cl
  80401d:	d3 e8                	shr    %cl,%eax
  80401f:	09 c2                	or     %eax,%edx
  804021:	89 d0                	mov    %edx,%eax
  804023:	89 f2                	mov    %esi,%edx
  804025:	f7 74 24 0c          	divl   0xc(%esp)
  804029:	89 d6                	mov    %edx,%esi
  80402b:	89 c3                	mov    %eax,%ebx
  80402d:	f7 e5                	mul    %ebp
  80402f:	39 d6                	cmp    %edx,%esi
  804031:	72 19                	jb     80404c <__udivdi3+0xfc>
  804033:	74 0b                	je     804040 <__udivdi3+0xf0>
  804035:	89 d8                	mov    %ebx,%eax
  804037:	31 ff                	xor    %edi,%edi
  804039:	e9 58 ff ff ff       	jmp    803f96 <__udivdi3+0x46>
  80403e:	66 90                	xchg   %ax,%ax
  804040:	8b 54 24 08          	mov    0x8(%esp),%edx
  804044:	89 f9                	mov    %edi,%ecx
  804046:	d3 e2                	shl    %cl,%edx
  804048:	39 c2                	cmp    %eax,%edx
  80404a:	73 e9                	jae    804035 <__udivdi3+0xe5>
  80404c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80404f:	31 ff                	xor    %edi,%edi
  804051:	e9 40 ff ff ff       	jmp    803f96 <__udivdi3+0x46>
  804056:	66 90                	xchg   %ax,%ax
  804058:	31 c0                	xor    %eax,%eax
  80405a:	e9 37 ff ff ff       	jmp    803f96 <__udivdi3+0x46>
  80405f:	90                   	nop

00804060 <__umoddi3>:
  804060:	55                   	push   %ebp
  804061:	57                   	push   %edi
  804062:	56                   	push   %esi
  804063:	53                   	push   %ebx
  804064:	83 ec 1c             	sub    $0x1c,%esp
  804067:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80406b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80406f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804073:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804077:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80407b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80407f:	89 f3                	mov    %esi,%ebx
  804081:	89 fa                	mov    %edi,%edx
  804083:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804087:	89 34 24             	mov    %esi,(%esp)
  80408a:	85 c0                	test   %eax,%eax
  80408c:	75 1a                	jne    8040a8 <__umoddi3+0x48>
  80408e:	39 f7                	cmp    %esi,%edi
  804090:	0f 86 a2 00 00 00    	jbe    804138 <__umoddi3+0xd8>
  804096:	89 c8                	mov    %ecx,%eax
  804098:	89 f2                	mov    %esi,%edx
  80409a:	f7 f7                	div    %edi
  80409c:	89 d0                	mov    %edx,%eax
  80409e:	31 d2                	xor    %edx,%edx
  8040a0:	83 c4 1c             	add    $0x1c,%esp
  8040a3:	5b                   	pop    %ebx
  8040a4:	5e                   	pop    %esi
  8040a5:	5f                   	pop    %edi
  8040a6:	5d                   	pop    %ebp
  8040a7:	c3                   	ret    
  8040a8:	39 f0                	cmp    %esi,%eax
  8040aa:	0f 87 ac 00 00 00    	ja     80415c <__umoddi3+0xfc>
  8040b0:	0f bd e8             	bsr    %eax,%ebp
  8040b3:	83 f5 1f             	xor    $0x1f,%ebp
  8040b6:	0f 84 ac 00 00 00    	je     804168 <__umoddi3+0x108>
  8040bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8040c1:	29 ef                	sub    %ebp,%edi
  8040c3:	89 fe                	mov    %edi,%esi
  8040c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040c9:	89 e9                	mov    %ebp,%ecx
  8040cb:	d3 e0                	shl    %cl,%eax
  8040cd:	89 d7                	mov    %edx,%edi
  8040cf:	89 f1                	mov    %esi,%ecx
  8040d1:	d3 ef                	shr    %cl,%edi
  8040d3:	09 c7                	or     %eax,%edi
  8040d5:	89 e9                	mov    %ebp,%ecx
  8040d7:	d3 e2                	shl    %cl,%edx
  8040d9:	89 14 24             	mov    %edx,(%esp)
  8040dc:	89 d8                	mov    %ebx,%eax
  8040de:	d3 e0                	shl    %cl,%eax
  8040e0:	89 c2                	mov    %eax,%edx
  8040e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040e6:	d3 e0                	shl    %cl,%eax
  8040e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040f0:	89 f1                	mov    %esi,%ecx
  8040f2:	d3 e8                	shr    %cl,%eax
  8040f4:	09 d0                	or     %edx,%eax
  8040f6:	d3 eb                	shr    %cl,%ebx
  8040f8:	89 da                	mov    %ebx,%edx
  8040fa:	f7 f7                	div    %edi
  8040fc:	89 d3                	mov    %edx,%ebx
  8040fe:	f7 24 24             	mull   (%esp)
  804101:	89 c6                	mov    %eax,%esi
  804103:	89 d1                	mov    %edx,%ecx
  804105:	39 d3                	cmp    %edx,%ebx
  804107:	0f 82 87 00 00 00    	jb     804194 <__umoddi3+0x134>
  80410d:	0f 84 91 00 00 00    	je     8041a4 <__umoddi3+0x144>
  804113:	8b 54 24 04          	mov    0x4(%esp),%edx
  804117:	29 f2                	sub    %esi,%edx
  804119:	19 cb                	sbb    %ecx,%ebx
  80411b:	89 d8                	mov    %ebx,%eax
  80411d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804121:	d3 e0                	shl    %cl,%eax
  804123:	89 e9                	mov    %ebp,%ecx
  804125:	d3 ea                	shr    %cl,%edx
  804127:	09 d0                	or     %edx,%eax
  804129:	89 e9                	mov    %ebp,%ecx
  80412b:	d3 eb                	shr    %cl,%ebx
  80412d:	89 da                	mov    %ebx,%edx
  80412f:	83 c4 1c             	add    $0x1c,%esp
  804132:	5b                   	pop    %ebx
  804133:	5e                   	pop    %esi
  804134:	5f                   	pop    %edi
  804135:	5d                   	pop    %ebp
  804136:	c3                   	ret    
  804137:	90                   	nop
  804138:	89 fd                	mov    %edi,%ebp
  80413a:	85 ff                	test   %edi,%edi
  80413c:	75 0b                	jne    804149 <__umoddi3+0xe9>
  80413e:	b8 01 00 00 00       	mov    $0x1,%eax
  804143:	31 d2                	xor    %edx,%edx
  804145:	f7 f7                	div    %edi
  804147:	89 c5                	mov    %eax,%ebp
  804149:	89 f0                	mov    %esi,%eax
  80414b:	31 d2                	xor    %edx,%edx
  80414d:	f7 f5                	div    %ebp
  80414f:	89 c8                	mov    %ecx,%eax
  804151:	f7 f5                	div    %ebp
  804153:	89 d0                	mov    %edx,%eax
  804155:	e9 44 ff ff ff       	jmp    80409e <__umoddi3+0x3e>
  80415a:	66 90                	xchg   %ax,%ax
  80415c:	89 c8                	mov    %ecx,%eax
  80415e:	89 f2                	mov    %esi,%edx
  804160:	83 c4 1c             	add    $0x1c,%esp
  804163:	5b                   	pop    %ebx
  804164:	5e                   	pop    %esi
  804165:	5f                   	pop    %edi
  804166:	5d                   	pop    %ebp
  804167:	c3                   	ret    
  804168:	3b 04 24             	cmp    (%esp),%eax
  80416b:	72 06                	jb     804173 <__umoddi3+0x113>
  80416d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804171:	77 0f                	ja     804182 <__umoddi3+0x122>
  804173:	89 f2                	mov    %esi,%edx
  804175:	29 f9                	sub    %edi,%ecx
  804177:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80417b:	89 14 24             	mov    %edx,(%esp)
  80417e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804182:	8b 44 24 04          	mov    0x4(%esp),%eax
  804186:	8b 14 24             	mov    (%esp),%edx
  804189:	83 c4 1c             	add    $0x1c,%esp
  80418c:	5b                   	pop    %ebx
  80418d:	5e                   	pop    %esi
  80418e:	5f                   	pop    %edi
  80418f:	5d                   	pop    %ebp
  804190:	c3                   	ret    
  804191:	8d 76 00             	lea    0x0(%esi),%esi
  804194:	2b 04 24             	sub    (%esp),%eax
  804197:	19 fa                	sbb    %edi,%edx
  804199:	89 d1                	mov    %edx,%ecx
  80419b:	89 c6                	mov    %eax,%esi
  80419d:	e9 71 ff ff ff       	jmp    804113 <__umoddi3+0xb3>
  8041a2:	66 90                	xchg   %ax,%ax
  8041a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041a8:	72 ea                	jb     804194 <__umoddi3+0x134>
  8041aa:	89 d9                	mov    %ebx,%ecx
  8041ac:	e9 62 ff ff ff       	jmp    804113 <__umoddi3+0xb3>
